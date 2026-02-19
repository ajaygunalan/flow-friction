# ROS2 Single-Package Worktree — Overlay Workspace Pattern

## Why it's different

A ROS2 package inside a workspace (`ros2_ws/src/<pkg>/`) can't use the generic flat worktree pattern because:

1. **colcon needs `src/<pkg>/` structure** — running `colcon build` inside a flat worktree dumps `build/install/log/` into the source tree (known footgun)
2. **Dependencies live in the parent workspace** — the package depends on sibling packages; must source `ros2_ws/install/setup.bash` before building
3. **Worktrees can't live inside `ros2_ws/src/`** — colcon would find duplicate `package.xml` files and conflict

## Directory layout

```
/home/user/
├── ros2_ws/                                  ← parent workspace (underlay)
│   ├── build/
│   ├── install/
│   └── src/
│       ├── ur_admittance_controller/         ← original (master)
│       └── other_packages/
│
├── ur_admittance_controller-worktrees/       ← next to workspace, not inside it
│   ├── stiffness-tuning/                     ← branch folder = mini overlay workspace
│   │   ├── src/ur_admittance_controller/     ← worktree lives here
│   │   ├── build/                            ← colcon output
│   │   └── install/                          ← colcon output
│   └── impedance-mode/
│       ├── src/ur_admittance_controller/
│       ├── build/
│       └── install/
```

## Build flow

1. `source ros2_ws/install/setup.bash` — makes all workspace packages visible
2. `cd` into the branch folder (e.g., `stiffness-tuning/`)
3. `colcon build --symlink-install` — builds only this package, finds deps from step 1
4. For incremental rebuilds: `colcon build --packages-select <pkg>`

## Key details

- `--symlink-install` makes Python edits instant (no rebuild needed)
- C++ edits need `colcon build --packages-select <pkg>` (seconds, incremental)
- Each branch folder is independent — its own `build/` and `install/`
- Switching branches = `cd` to another folder
- `local_setup.bash` (not `setup.bash`) when sourcing overlay to avoid re-sourcing underlay
