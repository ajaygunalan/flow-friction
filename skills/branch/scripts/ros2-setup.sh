#!/usr/bin/env bash
# ros2-setup.sh — Create a ROS2 worktree with overlay workspace structure
# Usage: ros2-setup.sh <repo-root> <branch-name>
#
# Creates: <ws-parent>/<pkg>-worktrees/<branch>/src/<pkg>/  (worktree)
# Builds:  sources parent workspace, runs colcon build --symlink-install

set -euo pipefail

REPO_ROOT="$1"
BRANCH="$2"
PKG_NAME=$(basename "$REPO_ROOT")

# --- Find the parent ROS2 workspace ---
# Walk up from repo root looking for a sibling install/setup.bash
# Expected layout: ros2_ws/src/<pkg>/ → workspace is ros2_ws/
SRC_DIR=$(dirname "$REPO_ROOT")
WS_DIR=$(dirname "$SRC_DIR")
SETUP_FILE="$WS_DIR/install/setup.bash"

if [ ! -f "$SETUP_FILE" ]; then
    echo "ERROR: Could not find parent workspace install/setup.bash"
    echo "Expected at: $SETUP_FILE"
    echo "Make sure you are inside a ROS2 workspace (ros2_ws/src/<pkg>/)"
    exit 1
fi

# --- Create worktree with overlay structure ---
# Place <pkg>-worktrees/ next to ros2_ws/ (same parent directory)
WS_PARENT=$(dirname "$WS_DIR")
WT_BASE="$WS_PARENT/${PKG_NAME}-worktrees"
WT_DIR="$WT_BASE/$BRANCH"
WT_PKG="$WT_DIR/src/$PKG_NAME"

mkdir -p "$WT_DIR/src"

echo "Creating worktree at: $WT_PKG"
cd "$REPO_ROOT"
git worktree add "$WT_PKG" -b "$BRANCH"

# --- Source parent workspace and build ---
echo "Sourcing workspace: $SETUP_FILE"
# shellcheck disable=SC1090
source "$SETUP_FILE"

echo "Building with colcon..."
cd "$WT_DIR"
colcon build --symlink-install

echo ""
echo "=== Done ==="
echo "Worktree:  $WT_DIR"
echo "Branch:    $BRANCH"
echo ""
echo "To rebuild after edits:"
echo "  cd $WT_DIR && source $SETUP_FILE && colcon build --packages-select $PKG_NAME"
