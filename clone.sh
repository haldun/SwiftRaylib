#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: ./clone.sh <NewProjectName> [destination-dir]"
    echo "Example: ./clone.sh Asteroids"
    echo "         ./clone.sh Asteroids ~/Projects"
    exit 1
fi

NEW_NAME="$1"
DEST_PARENT="${2:-..}"  # default: sibling of the template
OLD_NAME="SwiftRaylib"

if [[ ! "$NEW_NAME" =~ ^[A-Za-z][A-Za-z0-9_]*$ ]]; then
    echo "Error: name must start with a letter and contain only letters, digits, underscores."
    exit 1
fi

# Resolve paths
TEMPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_PARENT="$(cd "$DEST_PARENT" && pwd)"
DEST_DIR="$DEST_PARENT/$NEW_NAME"

if [ -e "$DEST_DIR" ]; then
    echo "Error: $DEST_DIR already exists."
    exit 1
fi

echo "Creating $NEW_NAME at $DEST_DIR..."

# Copy template, excluding things we don't want
mkdir -p "$DEST_DIR"
rsync -a \
    --exclude '.build' \
    --exclude '.git' \
    --exclude '.swiftpm' \
    --exclude 'Package.resolved' \
    --exclude 'clone.sh' \
    "$TEMPLATE_DIR/" "$DEST_DIR/"

cd "$DEST_DIR"

# Rename directories
[ -d "Sources/$OLD_NAME" ] && mv "Sources/$OLD_NAME" "Sources/$NEW_NAME"
[ -d "Tests/${OLD_NAME}Tests" ] && mv "Tests/${OLD_NAME}Tests" "Tests/${NEW_NAME}Tests"
[ -f "Tests/${NEW_NAME}Tests/${OLD_NAME}Tests.swift" ] && \
    mv "Tests/${NEW_NAME}Tests/${OLD_NAME}Tests.swift" "Tests/${NEW_NAME}Tests/${NEW_NAME}Tests.swift"

# Replace name inside files (cross-platform via perl)
find . -type f \
    \( -name "*.swift" -o -name "*.md" -o -name "Package.swift" \) \
    -not -path "./raylib-*/*" \
    -exec perl -i -pe "s/\Q$OLD_NAME\E/$NEW_NAME/g" {} +

# Fresh git history
git init -q
git add .
git commit -q -m "Initial commit from SwiftRaylib template"

echo ""
echo "✅ Done!"
echo "   cd $DEST_DIR"
echo "   swift run"
