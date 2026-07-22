# Changelog - VSH

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Kernel hardening (sysctl configuration)
- SSL/TLS certificate automation
- Docker security hardening
- Network monitoring integration
- Email notifications on completion
- GitHub Actions CI/CD workflow
- Automated testing suite

## [1.0.0] - 2024-01-15

### Added
- Initial release of VSH
- SSH hardening (disable root login, enforce key-based auth)
- UFW firewall configuration and setup
- Fail2Ban installation and configuration
- System package update and upgrade
- Unnecessary service disabling
- SUID binary auditing
- File permission auditing
- Internal text-based logging system
- Colored terminal output
- Automatic log rotation
- Configuration file support
- Comprehensive documentation
- MIT License

### Features
- Automatic backups of modified configuration files
- SSH config syntax validation before restart
- Rollback on error capability
- Detailed logging for audit trails
- Error handling for critical operations

## How to Report Bugs

1. Check existing issues first
2. Open new issue with bug report template
3. Include environment details
4. Attach sanitized log files
5. Describe steps to reproduce

## Version History

### v1.0.0 (Initial Release)
- ✓ Core hardening features
- ✓ Logging system
- ✓ Documentation
- ✓ Configuration support

### v1.1.0 (Planned)
- Kernel hardening
- Enhanced auditing
- Performance improvements

### v2.0.0 (Planned)
- Multiple distro support (CentOS, Rocky, Alma)
- Interactive configuration wizard
- Web dashboard
- API integration

## Upgrade Guide

### From v1.0.0 to v1.1.0 (Planned)

```bash
# Pull latest changes
git pull origin main

# Backup current config
cp security.conf security.conf.backup

# Run updated script
sudo ./hardener.sh
```

## Deprecations

None currently.

## Security

For security vulnerabilities, please email security report to project maintainer instead of using issue tracker.

## Dependencies

### Required
- Bash 4.0+
- Ubuntu/Debian with sudo access
- Internet connection for package downloads

### Optional
- UFW (Uncomplicated Firewall)
- Fail2Ban
- apt-get package manager

## Installation Methods

### Method 1: GitHub (Recommended)
```bash
git clone https://github.com/Mitn1ck4208/vsh.git
cd vsh
sudo ./hardener.sh
```

### Method 2: Download Script Only
```bash
curl -O https://raw.githubusercontent.com/Mitn1ck4208/vsh/main/hardener.sh
chmod +x hardener.sh
sudo ./hardener.sh
```

## Testing

Tested and verified on:
- ✓ Ubuntu 22.04 LTS
- ✓ Ubuntu 20.04 LTS
- ✓ Debian 11
- ✓ Debian 12

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Contributors

- Mitn1ck4208 (Author)

## Acknowledgments

- OpenSSH project
- UFW (Uncomplicated Firewall)
- Fail2Ban project
- Linux community

---

**Latest Update:** July 2024
**Current Version:** 1.0.0
**Next Release:** Q2 2024
