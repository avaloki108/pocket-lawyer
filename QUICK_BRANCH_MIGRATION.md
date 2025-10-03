# Quick Branch Migration: main → master

## 🚀 Quick Start (For Repository Admins)

This is a condensed version of the full migration guide. See `BRANCH_MIGRATION.md` for complete details.

### Step 1: Create master branch
```bash
git checkout main
git pull origin main
git checkout -b master
git push origin master
```

### Step 2: Change default branch on GitHub
**Via Web Interface:**
1. Go to: `https://github.com/avaloki108/pocket-lawyer/settings/branches`
2. Under "Default branch", click the switch icon
3. Select `master` → Click "Update" → Confirm

**Via GitHub CLI:**
```bash
gh repo edit avaloki108/pocket-lawyer --default-branch master
```

### Step 3: Delete main branch
⚠️ **Only after confirming master is the default!**

```bash
git push origin --delete main
git branch -d main
```

### Step 4: Verify
```bash
gh repo view avaloki108/pocket-lawyer --json defaultBranchRef --jq .defaultBranchRef.name
# Should output: master
```

## ✅ Status

- [x] No hardcoded `main` branch references found in repository files
- [x] Migration guide created
- [ ] **TO DO:** Execute migration steps above

## 📚 Resources

- Full migration guide: `BRANCH_MIGRATION.md`
- GitHub docs: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository/changing-the-default-branch

## 💡 Note

This repository has been prepared for branch migration. All configuration files and scripts have been verified to contain no hardcoded references to the `main` branch, so the migration should be smooth.
