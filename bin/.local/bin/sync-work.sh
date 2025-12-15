#!/usr/bin/env bash

set -e

SRC="$HOME/work/"
DST="$HOME/Dropbox/work-backup/"

# rsync -avh \
#   --delete \
#   --progress \
#   --stats \
#   --exclude-from="$HOME/.rsync-excludes" \
#   --dry-run \
#   "$SRC" "$DST"

rsync -avh \
  --progress \
  --stats \
  --exclude-from="$HOME/.rsync-excludes" \
  "$SRC" "$DST"
