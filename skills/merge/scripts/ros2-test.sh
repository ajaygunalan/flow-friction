#!/usr/bin/env bash
# ros2-test.sh — Build and test a ROS2 package in a worktree overlay workspace
# Usage: ros2-test.sh <git-worktree-path>
#
# The git worktree path is <branch>/src/<pkg>/ (from git worktree list).
# The overlay workspace is two levels up: <branch>/

set -euo pipefail

GIT_WT_PATH="$1"

# --- Derive overlay workspace and package name ---
PKG_NAME=$(basename "$GIT_WT_PATH")
OVERLAY_WS=$(dirname "$(dirname "$GIT_WT_PATH")")

if [ ! -d "$OVERLAY_WS/src/$PKG_NAME" ]; then
    echo "ERROR: Expected overlay workspace at $OVERLAY_WS with src/$PKG_NAME/"
    exit 1
fi

# --- Find the parent ROS2 workspace ---
# The original repo is inside ros2_ws/src/<pkg>/
# Get original repo path from git worktree list (first entry = main worktree)
REPO_ROOT=$(cd "$GIT_WT_PATH" && git worktree list | head -1 | awk '{print $1}')
SRC_DIR=$(dirname "$REPO_ROOT")
WS_DIR=$(dirname "$SRC_DIR")
SETUP_FILE="$WS_DIR/install/setup.bash"

if [ ! -f "$SETUP_FILE" ]; then
    echo "ERROR: Could not find parent workspace install/setup.bash"
    echo "Expected at: $SETUP_FILE"
    exit 1
fi

# --- Source workspace and build + test ---
echo "Sourcing workspace: $SETUP_FILE"
# shellcheck disable=SC1090
source "$SETUP_FILE"

cd "$OVERLAY_WS"

echo "Building $PKG_NAME..."
colcon build --packages-select "$PKG_NAME"

echo "Testing $PKG_NAME..."
colcon test --packages-select "$PKG_NAME"
colcon test-result --verbose
