# VPS Security Hardener 🔒

An automated bash script for hardening Ubuntu/Debian VPS security with comprehensive logging to text files.

## Features

✅ **SSH Hardening**
- Disable root login
- Enforce key-based authentication
- Disable password authentication
- Disable empty password login

✅ **Firewall Configuration**
- UFW firewall setup and configuration
- Default deny incoming policy
- Allow SSH (port 22)

✅ **Intrusion Detection**
- Fail2Ban installation and configuration
- Automatic service startup on boot

✅ **System Hardening**
- System package updates
- Disable unnecessary services (Avahi, CUPS, DHCP)
- Audit SUID binaries and permissions

✅ **Internal Logging**
- Text-based logging to `./logs/` directory
- Separate files for success/info and error logs
- Timestamp on every log entry
- Automatic log rotation and retention

## Requirements

- Ubuntu/Debian-based Linux distribution
- Root or sudo access
- Minimum 512MB RAM
- Active internet connection (for package updates)

## Installation

### Clone the repository
```bash
git clone https://github.com/yourusername/vps-security-hardener.git
cd vps-security-hardener
```

### Make script executable
```bash
chmod +x hardener.sh
```

## Usage

### Basic Usage
```bash
sudo ./hardener.sh
```

The script will:
1. Display colored output to terminal
2. Log all actions to text files in `./logs/`
3. Create backups of modified configuration files
4. Generate a summary report

### What Gets Logged

**Main Log File:** `logs/security_hardening_TIMESTAMP.log`
- INFO: Informational messages
- SUCCESS: Completed operations
- WARNING: Non-critical issues
- ERROR: Failed operations (also in error log)

**Error Log File:** `logs/errors_TIMESTAMP.log`
- Only contains ERROR level entries
- Useful for troubleshooting

### Log Locations

All logs are stored in the `logs/` directory:
```
logs/
├── security_hardening_20240115_143022.log
├── errors_20240115_143022.log
├── security_hardening_20240114_091500.log
└── errors_20240114_091500.log
```

Logs are automatically rotated and retained for 30 days.

## Configuration

Edit `security.conf` to customize hardening behavior:

```bash
# SSH Configuration
SSH_PORT=22
DISABLE_ROOT_LOGIN=true
DISABLE_PASSWORD_AUTH=true

# Firewall Settings
ENABLE_UFW=true

# Intrusion Detection
ENABLE_FAIL2BAN=true
```

## Safety Features

- **Automatic Backups**: SSH config is backed up before modification
- **Syntax Validation**: SSH config is tested before restarting service
- **Rollback on Error**: Configuration is reverted if validation fails
- **Detailed Logging**: All actions are logged for audit trails
- **Error Handling**: Script stops on critical errors

## Important Notes

⚠️ **Before Running:**
- Test in a non-production environment first
- Ensure you have SSH key access configured
- Disable password authentication last
- Keep SSH access available during testing

⚠️ **SSH Access:**
- After hardening, password login will be disabled
- Ensure your SSH public key is in `~/.ssh/authorized_keys`
- Test SSH connection without closing current session

## Troubleshooting

### SSH Connection Lost
```bash
# If you lose SSH access, use the backup
sudo cp /etc/ssh/sshd_config.backup.TIMESTAMP /etc/ssh/sshd_config
sudo systemctl restart ssh
```

### Script Failed to Run
```bash
# Check error log for details
cat logs/errors_*.log

# Ensure script has correct permissions
chmod +x hardener.sh

# Run with sudo
sudo ./hardener.sh
```

### Firewall Blocking Services
```bash
# Temporarily disable UFW for troubleshooting
sudo ufw disable

# View current rules
sudo ufw status
```

## Log File Format

Each log entry follows this format:
```
[YYYY-MM-DD HH:MM:SS] [LEVEL] Message content
```

Example:
```
[2024-01-15 14:30:22] [INFO] Starting VPS Security Hardening...
[2024-01-15 14:30:22] [INFO] Hostname: production-server
[2024-01-15 14:30:28] [SUCCESS] System packages upgraded
[2024-01-15 14:31:45] [SUCCESS] SSH service restarted
```

## Performance

- Script typically completes in 2-5 minutes
- Time depends on system load and network speed
- No significant performance impact after completion

## System Changes

The script modifies:
- `/etc/ssh/sshd_config` (with backup)
- Firewall rules via UFW
- Service status (enable/disable)
- System packages

All changes are logged and can be reviewed in the log files.

## Security Audit

After running, check:
```bash
# SSH status
sudo systemctl status ssh

# Firewall status
sudo ufw status verbose

# Fail2Ban status
sudo fail2ban-client status

# Logs
cat logs/security_hardening_*.log
```

## Future Improvements

Planned features:
- [ ] Kernel hardening (sysctl)
- [ ] SSL/TLS certificate automation
- [ ] Docker security hardening
- [ ] Network monitoring integration
- [ ] Email notifications

## Contributing

Contributions are welcome! Please:
1. Test changes thoroughly
2. Update logs for new features
3. Follow the script's logging format
4. Document security implications

## License

MIT License - See LICENSE file for details

## Support

For issues or questions:
1. Check error logs: `logs/errors_*.log`
2. Review main log: `logs/security_hardening_*.log`
3. Open an issue on GitHub

## Disclaimer

This script modifies system security configurations. Use at your own risk. Always:
- Test in non-production first
- Keep backups of original configurations
- Have recovery procedures in place
- Understand each change made

---

**Last Updated:** July 2026
**Version:** 1.0
**Tested On:** Ubuntu 22.04 LTS, Ubuntu 20.04 LTS, Debian 11
