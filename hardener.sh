#!/bin/bash

# VPS Security Hardener with Internal Logging
# ============================================
# Purpose: Automate security hardening for Ubuntu/Debian servers
# Logs: Text files in ./logs/ directory

# Configuration
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR/security_hardening_$TIMESTAMP.log"
ERROR_LOG="$LOG_DIR/errors_$TIMESTAMP.log"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==================================================
# LOGGING FUNCTIONS
# ==================================================

log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Write to log file
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    # Terminal output with colors
    case $level in
        INFO)
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        SUCCESS)
            echo -e "${GREEN}[✓]${NC} $message"
            ;;
        WARNING)
            echo -e "${YELLOW}[⚠]${NC} $message"
            ;;
        ERROR)
            echo -e "${RED}[✗]${NC} $message"
            echo "[$timestamp] [ERROR] $message" >> "$ERROR_LOG"
            ;;
    esac
}

log_divider() {
    echo "" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
}

# ==================================================
# SECURITY FUNCTIONS
# ==================================================

init_logging() {
    log INFO "Starting VPS Security Hardening..."
    log INFO "Hostname: $(hostname)"
    log INFO "OS: $(lsb_release -d | cut -f2)"
    log INFO "Kernel: $(uname -r)"
    log INFO "Log file: $LOG_FILE"
    log INFO "Error log: $ERROR_LOG"
    log_divider
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log ERROR "This script must be run as root (use sudo)"
        exit 1
    fi
    log SUCCESS "Root privileges verified"
}

update_system() {
    log INFO "Updating system packages..."
    
    if apt-get update -qq 2>/dev/null; then
        log SUCCESS "Package list updated"
    else
        log ERROR "Failed to update package list"
        return 1
    fi
    
    if apt-get upgrade -y -qq 2>/dev/null; then
        log SUCCESS "System packages upgraded"
    else
        log ERROR "Failed to upgrade packages"
        return 1
    fi
    
    log_divider
}

secure_ssh() {
    log INFO "Hardening SSH configuration..."
    
    SSH_CONFIG="/etc/ssh/sshd_config"
    
    if [[ ! -f "$SSH_CONFIG" ]]; then
        log ERROR "SSH config file not found: $SSH_CONFIG"
        return 1
    fi
    
    # Create backup
    BACKUP_SSH="${SSH_CONFIG}.backup.$(date +%s)"
    cp "$SSH_CONFIG" "$BACKUP_SSH"
    log INFO "SSH config backup created: $BACKUP_SSH"
    
    # Disable root login
    if grep -q "^PermitRootLogin" "$SSH_CONFIG"; then
        sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"
    else
        echo "PermitRootLogin no" >> "$SSH_CONFIG"
    fi
    log SUCCESS "PermitRootLogin disabled"
    
    # Disable password authentication (enforce key-based auth)
    if grep -q "^PasswordAuthentication" "$SSH_CONFIG"; then
        sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CONFIG"
    else
        echo "PasswordAuthentication no" >> "$SSH_CONFIG"
    fi
    log SUCCESS "PasswordAuthentication disabled"
    
    # Enable public key authentication
    if grep -q "^PubkeyAuthentication" "$SSH_CONFIG"; then
        sed -i 's/^PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSH_CONFIG"
    else
        echo "PubkeyAuthentication yes" >> "$SSH_CONFIG"
    fi
    log SUCCESS "PubkeyAuthentication enabled"
    
    # Disable empty password login
    if grep -q "^PermitEmptyPasswords" "$SSH_CONFIG"; then
        sed -i 's/^PermitEmptyPasswords.*/PermitEmptyPasswords no/' "$SSH_CONFIG"
    else
        echo "PermitEmptyPasswords no" >> "$SSH_CONFIG"
    fi
    log SUCCESS "Empty password login disabled"
    
    # Test SSH config
    if sshd -t 2>/dev/null; then
        log SUCCESS "SSH config syntax valid"
        systemctl restart ssh
        log SUCCESS "SSH service restarted"
    else
        log ERROR "SSH config syntax error - reverting backup"
        cp "$BACKUP_SSH" "$SSH_CONFIG"
        return 1
    fi
    
    log_divider
}

enable_firewall() {
    log INFO "Configuring firewall (UFW)..."
    
    if ! command -v ufw &> /dev/null; then
        log INFO "UFW not found, installing..."
        apt-get install -y -qq ufw
        log SUCCESS "UFW installed"
    fi
    
    # Set default policies
    ufw default deny incoming
    ufw default allow outgoing
    log SUCCESS "Firewall default policies set"
    
    # Allow SSH (critical!)
    ufw allow 22/tcp
    log SUCCESS "SSH port (22) allowed"
    
    # Enable firewall
    ufw --force enable > /dev/null 2>&1
    log SUCCESS "UFW firewall enabled"
    
    log_divider
}

setup_fail2ban() {
    log INFO "Setting up Fail2Ban..."
    
    if ! command -v fail2ban-client &> /dev/null; then
        log INFO "Fail2Ban not found, installing..."
        apt-get install -y -qq fail2ban
        log SUCCESS "Fail2Ban installed"
    else
        log INFO "Fail2Ban already installed"
    fi
    
    # Enable and start service
    systemctl enable fail2ban > /dev/null 2>&1
    systemctl start fail2ban > /dev/null 2>&1
    
    if systemctl is-active --quiet fail2ban; then
        log SUCCESS "Fail2Ban enabled and running"
    else
        log ERROR "Failed to start Fail2Ban service"
        return 1
    fi
    
    log_divider
}

disable_unused_services() {
    log INFO "Disabling unnecessary services..."
    
    local services=("avahi-daemon" "cups" "isc-dhcp-server")
    local disabled=0
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service"; then
            systemctl disable "$service" > /dev/null 2>&1
            systemctl stop "$service" > /dev/null 2>&1
            log SUCCESS "Disabled service: $service"
            ((disabled++))
        fi
    done
    
    if [[ $disabled -eq 0 ]]; then
        log INFO "No unnecessary services found to disable"
    fi
    
    log_divider
}

audit_permissions() {
    log INFO "Auditing sensitive file permissions..."
    
    # Check SUID binaries
    log INFO "Scanning for SUID binaries..."
    SUID_FILES=$(find / -perm -4000 2>/dev/null | head -20)
    SUID_COUNT=$(echo "$SUID_FILES" | wc -l)
    
    echo "" >> "$LOG_FILE"
    echo "=== SUID Binaries Audit ===" >> "$LOG_FILE"
    echo "Total SUID files found: $SUID_COUNT" >> "$LOG_FILE"
    echo "$SUID_FILES" >> "$LOG_FILE"
    
    log SUCCESS "SUID audit completed (logged: $SUID_COUNT files)"
    
    # Check /etc/sudoers permissions
    SUDOERS_PERMS=$(stat -c "%a" /etc/sudoers)
    if [[ "$SUDOERS_PERMS" == "440" ]]; then
        log SUCCESS "/etc/sudoers permissions correct: $SUDOERS_PERMS"
    else
        log WARNING "/etc/sudoers permissions: $SUDOERS_PERMS (expected: 440)"
    fi
    
    log_divider
}

setup_log_rotation() {
    log INFO "Configuring log file retention..."
    
    # Create logrotate config for our logs
    LOG_ROTATION_CONFIG="/etc/logrotate.d/vps-security-hardener"
    
    cat > "$LOG_ROTATION_CONFIG" << 'LOGROTATE'
./logs/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 0644 root root
}
LOGROTATE
    
    log SUCCESS "Log rotation configured (30-day retention)"
    log_divider
}

generate_summary() {
    log INFO "Security Hardening Summary"
    log INFO "=========================="
    log SUCCESS "✓ System updated"
    log SUCCESS "✓ SSH hardened"
    log SUCCESS "✓ Firewall enabled"
    log SUCCESS "✓ Fail2Ban configured"
    log SUCCESS "✓ Unused services disabled"
    log SUCCESS "✓ File permissions audited"
    log INFO "All logs saved to: $LOG_FILE"
    
    log_divider
}

# ==================================================
# ERROR HANDLER
# ==================================================

error_exit() {
    log ERROR "Script encountered an error and will exit"
    log INFO "Review error log: $ERROR_LOG"
    exit 1
}

trap error_exit ERR

# ==================================================
# MAIN EXECUTION
# ==================================================

main() {
    init_logging
    
    check_root
    
    update_system
    
    secure_ssh
    
    enable_firewall
    
    setup_fail2ban
    
    disable_unused_services
    
    audit_permissions
    
    setup_log_rotation
    
    generate_summary
    
    echo ""
    log SUCCESS "VPS Security Hardening completed successfully!"
    echo ""
}

# Execute main function
main
