#!/bin/bash

# Doom Config Sync Script

set -e
set -o pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

cd ~/.config/doom || {
    echo -e "${RED}✗ Could not find ~/.config/doom directory${NC}"
    exit 1
}

echo -e "${BLUE}╔════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Doom Config Sync Starting    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════╝${NC}"
echo

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

# Commit local changes if any
if [[ -n $(git status --porcelain) ]]; then
    echo -e "${YELLOW}→${NC} Committing local changes..."
    git add -A
    git commit -m "Auto-sync from $(hostname): $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "${GREEN}✓${NC} Committed"
    echo
fi

# Pull with rebase
echo -e "${BLUE}→${NC} Syncing with remote..."
if git pull --rebase origin "$CURRENT_BRANCH"; then
    echo -e "${GREEN}✓${NC} Pulled changes"

    # Push if we have local commits
    if ! git diff --quiet @{u}; then
        echo -e "${BLUE}→${NC} Pushing local changes..."
        git push
        echo -e "${GREEN}✓${NC} Pushed"
    fi

    echo -e "${GREEN}✓${NC} Doom config synced!"

    # Check if we need to run doom sync
    if git diff --name-only HEAD@{1} HEAD | grep -qE '(init\.el|packages\.el)'; then
        echo
        echo -e "${YELLOW}⚠${NC} init.el or packages.el changed"
        echo -e "${YELLOW}→${NC} Remember to run: ${GREEN}doom sync${NC}"
    fi
else
    echo -e "${RED}✗ Sync failed - please resolve conflicts manually${NC}"
    exit 1
fi
