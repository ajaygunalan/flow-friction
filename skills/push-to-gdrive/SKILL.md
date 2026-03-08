---
description: Push to Google Drive — uses current directory to decide scope. From gdrive root pushes everything, from a subfolder pushes only that folder.
allowed-tools:
  - Bash
  - AskUserQuestion
---

## Determine what to push

1. Get cwd via `pwd`
2. If cwd is `/media/ajay/gdrive` → source = `/media/ajay/gdrive`, dest = `gdrive:`
3. If cwd is under `/media/ajay/gdrive/` → extract relative path, source = `/media/ajay/gdrive/<rel>`, dest = `gdrive:<rel>`
4. If cwd is outside `/media/ajay/gdrive` → ask user: "You're not in the gdrive. Push entire drive, or specify a folder?"

Tell the user what will be pushed before running.

## Push

```bash
rclone copy <source> <dest> \
  --exclude-from /media/ajay/gdrive/.rcloneignore \
  --transfers 3 \
  --verbose \
  --stats-one-line \
  --stats 10s
```

Uses `rclone copy` (not sync) — uploads new/changed files only, never deletes from Google Drive.

## After

Report: files transferred, total size, elapsed time.
