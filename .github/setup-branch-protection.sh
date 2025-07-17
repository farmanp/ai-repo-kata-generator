#!/bin/bash

# Script to configure GitHub branch protection rules via GitHub API
# Requires: gh CLI tool and appropriate permissions

set -e

REPO="farmanp/ai-repo-kata-generator"
MAIN_BRANCH="main"
DEVELOP_BRANCH="develop"

echo "Setting up branch protection rules for $REPO..."

# Function to create or update branch protection
setup_branch_protection() {
    local branch=$1
    local reviewers=$2
    local enforce_admins=$3

    echo "Configuring protection for $branch branch..."

    # Create branch protection rule
    gh api \
        --method PUT \
        -H "Accept: application/vnd.github+json" \
        "/repos/$REPO/branches/$branch/protection" \
        --field "required_status_checks[strict]=true" \
        --field "required_status_checks[contexts][]=continuous-integration/github-actions" \
        --field "required_status_checks[contexts][]=test" \
        --field "required_status_checks[contexts][]=lint" \
        --field "required_status_checks[contexts][]=build" \
        --field "enforce_admins=$enforce_admins" \
        --field "required_pull_request_reviews[required_approving_review_count]=$reviewers" \
        --field "required_pull_request_reviews[dismiss_stale_reviews]=true" \
        --field "required_pull_request_reviews[require_code_owner_reviews]=true" \
        --field "restrictions=null" \
        --field "allow_force_pushes=false" \
        --field "allow_deletions=false" \
        --field "required_conversation_resolution=true" \
        --field "lock_branch=false" \
        --field "allow_fork_syncing=false"

    echo "✓ Branch protection configured for $branch"
}

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed."
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub."
    echo "Please run: gh auth login"
    exit 1
fi

# Setup main branch protection (2 reviewers, enforce for admins)
setup_branch_protection "$MAIN_BRANCH" 2 true

# Setup develop branch protection (1 reviewer, don't enforce for admins)
setup_branch_protection "$DEVELOP_BRANCH" 1 false

echo ""
echo "✅ Branch protection rules have been configured successfully!"
echo ""
echo "Next steps:"
echo "1. Install pre-commit hooks locally: pip install pre-commit && pre-commit install"
echo "2. Review the CODEOWNERS file and update with your team members"
echo "3. Ensure your CI/CD workflows are properly configured"
echo "4. Read the Branch Protection Guide at .github/BRANCH_PROTECTION_GUIDE.md"
