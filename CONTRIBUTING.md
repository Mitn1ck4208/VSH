# Contributing to VSH

Thank you for your interest in contributing to VSH (VPS Security Hardener)!

## Code of Conduct

Be respectful, inclusive, and constructive in all interactions.

## How to Contribute

### 1. Report Bugs

- Check if bug already exists in Issues
- Include OS version and script output
- Attach relevant log files (sanitized)
- Describe expected vs actual behavior

### 2. Suggest Features

- Describe use case clearly
- Explain why feature would be useful
- Provide implementation ideas if possible

### 3. Submit Code

#### Setup Development Environment

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/vsh.git
cd vsh

# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and test
chmod +x hardener.sh
sudo ./hardener.sh  # Test in VM first!
```

#### Code Style

- Use bash best practices
- Add comments for complex logic
- Follow existing naming conventions
- Test thoroughly before submitting

#### Commit Messages

```bash
# Good commit messages
git commit -m "Add kernel hardening options"
git commit -m "Fix firewall rule validation"
git commit -m "Update documentation for SSH section"

# Format: "Action: Description"
```

#### Before Submitting PR

1. **Test thoroughly** - Run in VM or test environment
2. **Check logs** - Ensure logging works correctly
3. **Update README** - Document new features
4. **Review changes** - Use `git diff` to verify

#### Submit Pull Request

1. Push to your fork
2. Create Pull Request with clear title and description
3. Link any related issues
4. Wait for review and feedback

### 4. Improve Documentation

- Fix typos and clarify instructions
- Add troubleshooting examples
- Translate documentation
- Create setup guides

## Development Checklist

Before submitting changes:

- [ ] Code tested in Ubuntu/Debian environment
- [ ] New features documented in README.md
- [ ] Logging statements added for new operations
- [ ] Error handling included
- [ ] Comments explain complex logic
- [ ] No hardcoded paths or credentials
- [ ] Backward compatible with existing configs
- [ ] Git commit messages are clear

## Testing Guidelines

### Required Testing

```bash
# 1. Test in clean virtual machine
ssh user@test-vm
sudo ./hardener.sh

# 2. Verify logs are created
ls -la logs/
cat logs/security_hardening_*.log

# 3. Verify no errors
grep ERROR logs/errors_*.log

# 4. Check SSH still works
ssh -v user@test-vm
exit
```

### Edge Cases to Test

- Running script twice
- Running with modified config
- Running on minimal install
- Running on different Ubuntu versions

## Project Structure

```
vsh/
├── hardener.sh          # Main script (only ~400 lines)
├── security.conf        # Configuration file
├── README.md            # User documentation
├── CONTRIBUTING.md      # This file
├── LICENSE              # MIT License
├── SETUP.md             # Setup instructions
├── .gitignore           # Git ignore patterns
└── logs/                # Log files directory
```

## Areas for Contribution

### Easy (Good for Beginners)
- [ ] Update documentation
- [ ] Add comments to code
- [ ] Report bugs
- [ ] Suggest improvements

### Medium
- [ ] Add new security checks
- [ ] Improve error handling
- [ ] Add configuration options
- [ ] Create troubleshooting guides

### Advanced
- [ ] Add kernel hardening (sysctl)
- [ ] Implement SSL/TLS automation
- [ ] Create dashboard/monitoring
- [ ] Build test suite

## Supported Distributions

- Ubuntu 22.04 LTS ✓
- Ubuntu 20.04 LTS ✓
- Debian 11 ✓
- Debian 12 ✓

Test on at least one version before submitting.

## Questions?

- Open an Issue for questions
- Check existing discussions
- Review documentation first

## License

By contributing, you agree your code will be licensed under MIT License.

---

**Thanks for contributing to VSH!** 🙏
