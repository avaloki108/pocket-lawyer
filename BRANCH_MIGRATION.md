# Branch Migration Guide: main → master

This document provides step-by-step instructions for migrating the default branch from `main` to `master`.

## Prerequisites

- Admin access to the GitHub repository
- Local clone of the repository
- GitHub CLI (`gh`) or access to GitHub web interface

## Migration Steps

### Step 1: Create the master branch from main

```bash
# Ensure you have the latest main branch
git checkout main
git pull origin main

# Create master branch from main
git checkout -b master

# Push master to remote
git push origin master
```

### Step 2: Change the default branch on GitHub

**Option A: Using GitHub Web Interface**

1. Navigate to your repository on GitHub
2. Click on **Settings** (⚙️)
3. Click on **Branches** in the left sidebar
4. Under "Default branch", click the switch icon (⇄)
5. Select `master` from the dropdown
6. Click **Update**
7. Confirm the change

**Option B: Using GitHub CLI**

```bash
# Change default branch
gh repo edit --default-branch master
```

**Option C: Using GitHub API**

```bash
curl -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.github.com/repos/avaloki108/pocket-lawyer \
  -d '{"default_branch":"master"}'
```

### Step 3: Update local tracking

All contributors should update their local repositories:

```bash
# Fetch latest changes
git fetch origin

# Update local main branch
git checkout main
git pull

# Switch to master
git checkout master
git pull

# Set upstream for master
git branch --set-upstream-to=origin/master master
```

### Step 4: Delete the main branch

⚠️ **Warning**: Only proceed after confirming master is set as default!

**On GitHub:**

1. Navigate to repository **Settings** → **Branches**
2. Find the `main` branch under "Branch protection rules" or in branch list
3. Delete the `main` branch

**Using command line:**

```bash
# Delete remote main branch
git push origin --delete main

# Delete local main branch
git branch -d main
```

### Step 5: Update branch protection rules (if applicable)

If you had branch protection rules on `main`, replicate them for `master`:

1. Go to **Settings** → **Branches**
2. Click **Add rule** or edit existing rule
3. Apply the same protection settings to `master` that were on `main`

### Step 6: Update CI/CD and webhooks (if applicable)

- Check GitHub Actions workflows for hardcoded `main` references
- Update any webhooks that filter by branch name
- Update any external CI/CD systems (Travis, CircleCI, etc.)

## Verification

After migration, verify:

```bash
# Check default branch
gh repo view --json defaultBranchRef --jq .defaultBranchRef.name

# Verify main is deleted
git ls-remote --heads origin | grep main || echo "main deleted successfully"

# Verify master exists
git ls-remote --heads origin | grep master
```

## Rollback (if needed)

If you need to rollback:

```bash
# Recreate main from master
git checkout master
git checkout -b main
git push origin main

# Change default back to main via GitHub settings
# Then delete master branch
```

## Notes

- This repository currently has no hardcoded references to `main` branch in configuration files
- No GitHub Actions workflows were found that need updating
- All contributors should be notified before making this change
- Consider updating documentation to reference `master` instead of `main`

## Post-Migration Checklist

- [ ] Default branch changed to master on GitHub
- [ ] Main branch deleted from remote
- [ ] Team notified of the change
- [ ] Local clones updated by all contributors
- [ ] Branch protection rules migrated
- [ ] CI/CD configurations verified
- [ ] Documentation updated (if needed)
