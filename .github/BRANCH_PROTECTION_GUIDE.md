# Branch Protection Strategy

This repository implements comprehensive branch protection rules to ensure code quality and maintain a stable codebase.

## Protected Branches

### Main Branch (`main`)
- **Purpose**: Production-ready code
- **Direct pushes**: Disabled
- **Force pushes**: Disabled
- **Deletions**: Disabled
- **Required approvals**: 2
- **Dismiss stale reviews**: Enabled
- **Require code owner reviews**: Enabled
- **Required status checks**: All CI/CD checks must pass
- **Enforce for administrators**: Yes
- **Require conversation resolution**: Yes

### Development Branch (`develop`)
- **Purpose**: Integration branch for features
- **Direct pushes**: Disabled
- **Force pushes**: Disabled
- **Deletions**: Disabled
- **Required approvals**: 1
- **Dismiss stale reviews**: Enabled
- **Require code owner reviews**: Enabled
- **Required status checks**: Test and lint checks must pass
- **Enforce for administrators**: No
- **Require conversation resolution**: Yes

## CI/CD Checks

All pull requests must pass the following automated checks:

1. **Tests**: All unit and integration tests must pass
2. **Linting**: Code must comply with style guidelines
3. **Build**: Project must build successfully
4. **Security Scan**: No critical vulnerabilities detected
5. **Commit Message Lint**: Commits must follow conventional commit format

## Pre-commit Hooks

Local development includes pre-commit hooks for:

- Trailing whitespace removal
- End-of-file fixing
- YAML/JSON/TOML validation
- Large file prevention (>500KB)
- Merge conflict detection
- Branch protection (prevents direct commits to main/master)
- Code formatting (Black, isort, Prettier, ESLint)
- Shell script validation
- Secret scanning (Gitleaks)
- Commit message validation

### Installing Pre-commit Hooks

```bash
# Install pre-commit
pip install pre-commit

# Install the git hook scripts
pre-commit install

# Install commit-msg hook for commit message validation
pre-commit install --hook-type commit-msg

# (Optional) Run against all files
pre-commit run --all-files
```

## CODEOWNERS

The CODEOWNERS file ensures that appropriate team members review changes to critical parts of the codebase. Code owners are automatically requested for review when PRs modify their areas of responsibility.

## Applying Branch Protection Rules

To apply these rules to your GitHub repository:

1. Go to Settings → Branches
2. Add a branch protection rule for `main`
3. Configure settings according to `.github/branch-protection.json`
4. Repeat for `develop` branch
5. Ensure required status checks are available in your repository

## Best Practices

1. **Feature Branches**: Create feature branches from `develop`
2. **Naming Convention**: Use descriptive names (e.g., `feature/add-auth`, `fix/memory-leak`)
3. **Small PRs**: Keep pull requests focused and reviewable
4. **Clear Descriptions**: Write comprehensive PR descriptions
5. **Test Coverage**: Include tests for new features
6. **Documentation**: Update docs with code changes
7. **Clean History**: Use meaningful commit messages

## Emergency Procedures

If you need to bypass protection temporarily:

1. Document the reason in the PR
2. Get approval from repository admin
3. Use admin override sparingly
4. Re-enable protections immediately after

## Commit Message Format

Follow conventional commits:

```
type(scope): subject

body

footer
```

Types: feat, fix, docs, style, refactor, test, chore

Example:
```
feat(auth): add OAuth2 integration

- Implement Google OAuth2 provider
- Add token refresh mechanism
- Update user model with OAuth fields

Closes #123
```