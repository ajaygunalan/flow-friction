#!/usr/bin/env bash
# ros2-test.sh — Build and test a ROS2 package in a worktree
# Usage: ros2-test.sh <worktree-path>
#
# Supports two layouts:
#   1. Overlay workspace (old /branch pattern):
#      <branch>/src/<pkg>/   — worktree is nested inside an overlay
#   2. Bare repo slot (new /create-worktrees pattern):
#      <repo>/w3/            — worktree IS the package root

set -euo pipefail

GIT_WT_PATH="$1"

# --- Get package name from package.xml (works for both layouts) ---
PKG_NAME=$(grep -oP '<name>\K[^<]+' "$GIT_WT_PATH/package.xml" | head -1)

if [ -z "$PKG_NAME" ]; then
    echo "ERROR: Could not read package name from $GIT_WT_PATH/package.xml"
    exit 1
fi

# --- Detect layout ---
# If two levels up contains src/<pkg>/, this is an overlay workspace (old layout)
POSSIBLE_OVERLAY=$(dirname "$(dirname "$GIT_WT_PATH")")
CLEANUP_TEMP=""

if [ -d "$POSSIBLE_OVERLAY/src/$PKG_NAME" ]; then
    # === Old overlay layout ===
    OVERLAY_WS="$POSSIBLE_OVERLAY"

    # Find parent ROS2 workspace from main worktree
    REPO_ROOT=$(cd "$GIT_WT_PATH" && git worktree list | head -1 | awk '{print $1}')
    SRC_DIR=$(dirname "$REPO_ROOT")
    WS_DIR=$(dirname "$SRC_DIR")
    SETUP_FILE="$WS_DIR/install/setup.bash"

    if [ -f "$SETUP_FILE" ]; then
        echo "Sourcing parent workspace: $SETUP_FILE"
        # shellcheck disable=SC1090
        source "$SETUP_FILE"
    else
        echo "WARNING: Could not find parent workspace at $SETUP_FILE"
    fi
else
    # === Bare repo layout — create temporary overlay workspace ===
    OVERLAY_WS=$(mktemp -d "/tmp/ros2-test-${PKG_NAME}-XXXXXX")
    CLEANUP_TEMP="$OVERLAY_WS"
    mkdir -p "$OVERLAY_WS/src"
    ln -s "$GIT_WT_PATH" "$OVERLAY_WS/src/$PKG_NAME"

    echo "Created temporary overlay workspace: $OVERLAY_WS"

    # Source base ROS if not already sourced
    if [ -z "${AMENT_PREFIX_PATH:-}" ]; then
        ROS_SETUP="/opt/ros/${ROS_DISTRO:-humble}/setup.bash"
        if [ -f "$ROS_SETUP" ]; then
            echo "Sourcing ROS base: $ROS_SETUP"
            # shellcheck disable=SC1090
            source "$ROS_SETUP"
        else
            echo "WARNING: No ROS environment found. colcon may fail if dependencies are missing."
        fi
    fi
fi

# --- Clean up temp overlay on exit (bare repo layout only) ---
if [ -n "$CLEANUP_TEMP" ]; then
    trap 'rm -rf "$CLEANUP_TEMP"' EXIT
fi

# --- Build and test ---
cd "$OVERLAY_WS"

echo "Building $PKG_NAME..."
colcon build --packages-select "$PKG_NAME"

echo "Testing $PKG_NAME..."
colcon test --packages-select "$PKG_NAME"
colcon test-result --verbose
