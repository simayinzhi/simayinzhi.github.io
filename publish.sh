#!/bin/bash
set -e

OBSIDIAN_ARTICLES="/Users/philma/Library/Mobile Documents/iCloud~md~obsidian/Documents/my notes/11_Article"
QUARTZ_DIR="/Users/philma/simayinzhi.github.io"
QUARTZ_CONTENT="$QUARTZ_DIR/content"

echo "Syncing articles from Obsidian (11_Article) to Quartz content..."
mkdir -p "$QUARTZ_CONTENT"
rsync -av --delete --exclude=".DS_Store" "$OBSIDIAN_ARTICLES/" "$QUARTZ_CONTENT/"

cd "$QUARTZ_DIR"

echo "Building Quartz site..."
npx quartz build

echo "Pushing to GitHub..."
git checkout -B main
git add .
git commit -m "Publish updates from Obsidian $(date '+%Y-%m-%d %H:%M')" || echo "No changes to commit"
git push -u origin main --force

echo "Publish complete! Deployment to https://simayinzhi.github.io is in progress."
