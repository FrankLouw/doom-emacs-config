#!/bin/bash


set -e

cd ~/.config/doom

echo "=== Doom Config Sync ==="
echo "Pulling changes..."
git pull --rebase

if [[ -n $(git status -s) ]]; then
    echo "Committing local changes..."
    git add -A
    git commit -m "Sync from $(hostname): $(date '+%Y-%m-%d %H:%M:%S')"

    echo "Pushing changes..."
    git push
    echo "✓ Config synced!"
    echo "Run 'doom sync' if you changed init.el or packages.el"
else
    echo "✓ Already up to date"
fi
