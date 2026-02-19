---
description: Create a git worktree + branch for isolated work
argument-hint: "<branch-name>"
allowed-tools:
  - Bash
---

Abort if not in a git repo, `$ARGUMENTS` is empty, or branch already exists.

## Detect ROS2 single-package repo

If `package.xml` exists at repo root **and** `src/*/package.xml` does NOT exist (i.e., this is a single ROS2 package, not a workspace), use the ROS2 worktree flow. See [references/ros2-worktree.md](references/ros2-worktree.md) for details.

Run: `bash ~/.claude/skills/branch/scripts/ros2-setup.sh <repo-root> $ARGUMENTS`

Print the rebuild command and the worktree path. **Stop here** — skip the generic flow below.

## Generic worktree creation (all other projects)

Detect the repo name from the current directory basename. Create the worktrees folder `../<repo-name>-worktrees/` if it doesn't exist. Run `git worktree add ../<repo-name>-worktrees/$ARGUMENTS -b $ARGUMENTS`.

## Initialize submodules (if any)

If `.gitmodules` exists, run `git submodule update --init --recursive` in the new worktree.

## Import vcstool repos (if any)

If any `*.repos` file exists at the worktree root, run `vcs import src < <file>.repos` in the new worktree.

## Install dependencies

`cd` into the new worktree and detect the build system by checking which files exist, **in this order** (first match wins):

| Check | Run |
|---|---|
| `uv.lock` | `uv sync` |
| `poetry.lock` | `poetry install` |
| `Pipfile.lock` | `pipenv install` |
| `requirements.txt` | `pip install -r requirements.txt` |
| `Cargo.lock` or `Cargo.toml` | `cargo build` |
| `src/*/package.xml` (ROS2 workspace) | `colcon build` |
| `CMakeLists.txt` | `cmake -B build && cmake --build build` |
| `meson.build` | `meson setup build && meson compile -C build` |
| `Makefile` | `make` |
| `pnpm-lock.yaml` | `pnpm install` |
| `package-lock.json` | `npm install` |
| `yarn.lock` | `yarn install` |
| `go.sum` | `go mod download` |
| `Gemfile.lock` | `bundle install` |

If none match, skip — tell the user no build system was detected.

Confirm with the full path, remind user to `cd` into it and run `claude` there.
