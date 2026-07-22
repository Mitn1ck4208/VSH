# Quick Start Guide - VSH

## Step 1: Prepare Your Local Repository

```bash
# Create project directory
mkdir vsh
cd vsh

# Initialize git
git init
git config user.name "Mitn1ck4208"
git config user.email "Mitn1ck4208@users.noreply.github.com"
```

## Step 2: Add Project Files

Copy these files into your project directory:
- `hardener.sh` - Main security hardening script
- `security.conf` - Configuration file
- `README.md` - Project documentation
- `.gitignore` - Git ignore patterns
- `SETUP.md` - This file

Make the script executable:
```bash
chmod +x hardener.sh
```

Create logs directory:
```bash
mkdir -p logs
touch logs/.gitkeep
```

## Step 3: Initial Commit

```bash
# Add all files
git add .

# Create first commit
git commit -m "Initial commit: VSH - VPS Security Hardener with logging system"

# Check status
git status
```

## Step 4: Create GitHub Repository

1. Go to https://github.com/new
2. Fill in repository name: `vsh`
3. Add description: "VSH - Automated security hardening for Ubuntu/Debian VPS with text-based logging"
4. Choose visibility: **Public** (for sharing)
5. Click "Create repository"

## Step 5: Connect to GitHub

```bash
# Add remote origin with your username (Mitn1ck4208)
git remote add origin https://github.com/Mitn1ck4208/vsh.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

## Step 6: Verify

Check your GitHub repository:
- https://github.com/Mitn1ck4208/vsh
- Verify all files are present
- Check README renders correctly
- Confirm logs directory is empty (only .gitkeep)

## Testing Locally

### Before Running on Production

1. **Test in Virtual Machine:**
```bash
# SSH into test VM
ssh user@test-vm

# Run the script
sudo ./hardener.sh
```

2. **Check Logs:**
```bash
# View main log
cat logs/security_hardening_*.log

# View errors
cat logs/errors_*.log
```

3. **Verify SSH Still Works:**
```bash
# In separate terminal
ssh -v user@test-vm
```

## Project Structure

```
vsh/
├── .git/                      # Git repository (created by git init)
├── .gitignore                 # Git ignore file
├── README.md                  # Main documentation
├── SETUP.md                   # This file
├── LICENSE                    # MIT License
├── hardener.sh                # Main script (executable)
├── security.conf              # Configuration file
└── logs/                      # Log files (created by script)
    └── .gitkeep               # Keep directory in git
```

## Next Steps

### 1. Add More Features
- SSH certificate management
- Kernel hardening (sysctl settings)
- Docker security
- Network monitoring

### 2. Create GitHub Issues
- Document planned features
- Track bugs
- Accept community contributions

### 3. Version Tagging
```bash
# Create release tag
git tag -a v1.0 -m "Initial release"
git push origin v1.0
```

### 4. Add GitHub Actions (Optional)
Create `.github/workflows/test.yml` for automated testing

### 5. Documentation
- Add troubleshooting section
- Create security audit checklist
- Document all log messages

## Useful Git Commands

```bash
# Check git status
git status

# View commit history
git log

# View changes
git diff

# View remote
git remote -v

# Update from GitHub
git pull origin main

# Push changes
git push origin main

# Create a branch for new features
git checkout -b feature/new-feature
```

## Common Issues

### "fatal: destination path already exists"
```bash
# If directory already has git
cd existing-directory
git remote add origin https://github.com/USERNAME/repo.git
git branch -M main
git push -u origin main
```

### "fatal: not a git repository"
```bash
git init
```

### "Permission denied" when running script
```bash
chmod +x hardener.sh
sudo ./hardener.sh
```

### SSH connection issues after running script
```bash
# Check SSH status
sudo systemctl status ssh

# Check firewall
sudo ufw status

# Review logs
cat logs/errors_*.log
```

## GitHub Profile Tips

- ✅ Add a bio mentioning DevOps/Security
- ✅ Pin this repository on your profile
- ✅ Add topics: `security`, `bash`, `hardening`, `vps`, `ubuntu`, `debian`
- ✅ Enable GitHub Pages for documentation

## Collaboration

To invite others:
1. Go to repository Settings
2. Click "Manage access"
3. Add collaborators
4. Set permissions (Maintain, Write, Read, etc.)

## Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Docs](https://docs.github.com)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [Bash Scripting Guide](https://www.gnu.org/software/bash/manual/)

---

**Ready to push?** Run: `git push origin main`
