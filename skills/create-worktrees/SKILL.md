---
description: One-time setup — create main + 4 numbered worktree slots for any repo
allowed-tools:
  - Bash
---

Abort if not in a git repo. Abort if working directory is dirty (`git status --porcelain` is non-empty).

```
REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$REPO_ROOT")
```

## Detect layout

Check if this repo is **nested** inside a larger build system or **standalone**.

**Nested ROS2**: repo's parent directory is named `src` AND `$REPO_ROOT/../../install/setup.bash` exists.

**Nested general**: repo's parent directory contains `Cargo.toml` with `[workspace]`, or a `CMakeLists.txt` that is NOT the repo's own.

**Standalone**: none of the above.

---

## Flow A: Standalone repo (bare repo + internal worktrees)

> Use for: standalone Python, Rust, C++, Go, Node, etc.

Abort if `.bare/` already exists (already set up).

### Convert to bare repo

Convert in-place (preserves all local branches, unpushed commits, stashes, hooks):

1. `mv $REPO_ROOT/.git $REPO_ROOT/.bare`
2. `echo "gitdir: ./.bare" > $REPO_ROOT/.git`
3. `git --git-dir=$REPO_ROOT/.bare config core.bare true`
4. `git --git-dir=$REPO_ROOT/.bare config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"`

Remove the old working tree files — everything in `$REPO_ROOT` **except** `.bare/` and `.git`:

```bash
cd "$REPO_ROOT"
ls -A | grep -v '^\.\(bare\|git\)$' | xargs rm -rf
```

### Create worktrees

```
git worktree add main main
git worktree add w1 -b w1-slot main
git worktree add w2 -b w2-slot main
git worktree add w3 -b w3-slot main
git worktree add w4 -b w4-slot main
```

### Install dependencies

For **each** worktree (`main`, `w1`, `w2`, `w3`, `w4`), `cd` in and detect build system (see [dependency table](#dependency-table) below).

### Confirm

Print:

```
$REPO_NAME/
├── .bare/
├── main/   ← read-only reference (always on main)
├── w1/     ← work slot
├── w2/     ← work slot
├── w3/     ← work slot
└── w4/     ← work slot
```

Remind user: `cd w1 && git checkout -b feature-name` to start working.

---

## Flow B: Nested ROS2 repo (external overlay worktrees)

> Use for: ROS2 package inside `ros2_ws/src/<pkg>/`

The original repo stays in place as the "main" (read-only reference). Worktrees go **outside** the workspace to avoid colcon conflicts.

### Determine paths

```bash
PKG_NAME="$REPO_NAME"
SRC_DIR=$(dirname "$REPO_ROOT")          # ros2_ws/src/
WS_DIR=$(dirname "$SRC_DIR")             # ros2_ws/
WS_PARENT=$(dirname "$WS_DIR")           # parent of ros2_ws
WT_BASE="$WS_PARENT/${PKG_NAME}-worktrees"
SETUP_FILE="$WS_DIR/install/setup.bash"
```

Abort if worktrees directory already has `w1/` (already set up).

### Create overlay worktree slots

For each slot (`w1`, `w2`, `w3`, `w4`):

```bash
mkdir -p "$WT_BASE/w<N>/src"
git worktree add "$WT_BASE/w<N>/src/$PKG_NAME" -b "w<N>-slot" main
```

### Build each slot

For each slot:

```bash
source "$SETUP_FILE"
cd "$WT_BASE/w<N>"
colcon build --symlink-install
```

### Confirm

Print:

```
$WS_DIR/                                      ← parent workspace (underlay)
└── src/
    └── $PKG_NAME/                            ← original repo = "main"

$WT_BASE/                                     ← outside workspace
├── w1/
│   ├── src/$PKG_NAME/                        ← git worktree
│   ├── build/
│   └── install/
├── w2/  w3/  w4/                             ← same structure
```

Remind user: `cd $WT_BASE/w1/src/$PKG_NAME && git checkout -b feature-name` to start working.

Print rebuild command: `cd $WT_BASE/w1 && source $SETUP_FILE && colcon build --packages-select $PKG_NAME`

---

## Flow C: Nested general repo (external flat worktrees)

> Use for: Cargo workspace member, CMake subproject, etc.

The original repo stays in place as "main". Worktrees go outside as siblings.

### Determine paths

```bash
PARENT_PROJECT=$(find_parent_build_system)   # the workspace/superproject root
WT_BASE="$(dirname "$PARENT_PROJECT")/${REPO_NAME}-worktrees"
```

Abort if worktrees directory already has `w1/` (already set up).

### Create worktree slots

```bash
mkdir -p "$WT_BASE"
git worktree add "$WT_BASE/w1" -b w1-slot main
git worktree add "$WT_BASE/w2" -b w2-slot main
git worktree add "$WT_BASE/w3" -b w3-slot main
git worktree add "$WT_BASE/w4" -b w4-slot main
```

### Install dependencies

For each slot, `cd` in and detect build system (see [dependency table](#dependency-table) below).

### Confirm

Print the layout and remind user to `cd` into a slot to start working.

---

## Shared steps (all flows)

### Initialize submodules (if any)

If `.gitmodules` exists in any worktree, run `git submodule update --init --recursive` in each.

### Import vcstool repos (if any)

If any `*.repos` file exists, run `vcs import src < <file>.repos` in each worktree.

### Dependency table

For each worktree, detect build system by checking which files exist, **in this order** (first match wins):

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

Note: for Flow B (nested ROS2), dependency installation is handled by `colcon build` in the overlay — skip this table.
