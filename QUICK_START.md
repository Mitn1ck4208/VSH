# VSH - Quick Start Guide ⚡

Fast setup for VPS Security Hardener. For detailed info, see [README.md](README.md).

## 1️⃣ Install (30 seconds)

```bash
git clone https://github.com/Mitn1ck4208/vsh.git
cd vsh
chmod +x hardener.sh
```

## 2️⃣ Test (Recommended - 5 minutes)

```bash
# In a virtual machine or test server
sudo ./hardener.sh

# Check results
cat logs/security_hardening_*.log
```

## 3️⃣ Deploy (Production)

```bash
# On your VPS
sudo ./hardener.sh

# Verify SSH access works
# Open new terminal, DON'T close this one yet!
ssh -v user@your-vps
```

## ✅ What Gets Hardened

| Component | Action |
|-----------|--------|
| SSH | Root login disabled, key-based auth enforced |
| Firewall | UFW enabled, SSH allowed (port 22) |
| Intrusion | Fail2Ban installed and running |
| Updates | System packages updated and upgraded |
| Services | Avahi, CUPS, DHCP server disabled |
| Audit | SUID binaries and permissions checked |

## 📋 Logs

Everything logged to text files:

```bash
# Main log
cat logs/security_hardening_*.log

# Errors only
cat logs/errors_*.log

# Auto-rotated after 30 days
```

## ⚠️ Important Notes

- **SSH Setup First:** Configure SSH keys BEFORE running
- **Test First:** Always test in VM before production
- **Keep Connection:** Don't close SSH until script finishes
- **Password Auth:** Will be disabled - use SSH keys only
- **Backups:** SSH config backed up automatically

## 🔧 Customize (Optional)

```bash
# Edit configuration
nano security.conf

# Adjust settings:
DISABLE_ROOT_LOGIN=true
ENABLE_UFW=true
ENABLE_FAIL2BAN=true
```

## 🆘 Troubleshooting

### Lost SSH Access?
```bash
# Use backup
sudo cp /etc/ssh/sshd_config.backup.TIMESTAMP /etc/ssh/sshd_config
sudo systemctl restart ssh
```

### Script Failed?
```bash
# Check error log
cat logs/errors_*.log

# Make sure running as root
sudo ./hardener.sh
```

### Firewall Blocking Service?
```bash
# Allow additional port
sudo ufw allow 8080/tcp
```

## 📖 Documentation

| File | Purpose |
|------|---------|
| [README.md](README.md) | Full documentation |
| [SETUP.md](SETUP.md) | GitHub setup guide |
| [SECURITY.md](SECURITY.md) | Security policy |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to contribute |
| [CHANGELOG.md](CHANGELOG.md) | Version history |

## 🚀 After Hardening

```bash
# Verify everything works
sudo systemctl status ssh
sudo ufw status
sudo fail2ban-client status

# Review changes
cat logs/security_hardening_*.log

# Keep backups safe
sudo cp /etc/ssh/sshd_config ~/.ssh/sshd_config.safe
```

## 💡 Next Steps

1. **Monitor** - Review logs regularly
2. **Update** - Keep system packages updated
3. **Backup** - Regular configuration backups
4. **Test** - Test access methods regularly
5. **Contribute** - Share improvements

## ❓ Common Questions

**Q: Can I run this on Windows?**
A: Only with WSL2 (Windows Subsystem for Linux)

**Q: Does it work on CentOS/RHEL?**
A: Not yet - currently Ubuntu/Debian only

**Q: How long does it take?**
A: Typically 2-5 minutes depending on system

**Q: Can I undo changes?**
A: SSH config backed up - others are improvements you'd want to keep

**Q: What if I need to enable password login again?**
A: Edit `/etc/ssh/sshd_config` and set `PasswordAuthentication yes`

## 📞 Help & Support

- **Issues:** GitHub Issues
- **Questions:** GitHub Discussions
- **Security:** See [SECURITY.md](SECURITY.md)
- **Contribute:** See [CONTRIBUTING.md](CONTRIBUTING.md)

## 🔒 Security Reminders

✓ Always test in non-production first
✓ Ensure SSH key access before disabling passwords
✓ Keep SSH session open while running script
✓ Store SSH keys securely
✓ Review logs after completion
✓ Monitor Fail2Ban bans regularly

## Project Info

- **Author:** Mitn1ck4208
- **License:** MIT
- **Repository:** https://github.com/Mitn1ck4208/vsh
- **Version:** 1.0.0
- **Updated:** January 15, 2024

---

**Ready?** → `sudo ./hardener.sh` 🚀

For advanced options, see [README.md](README.md)
