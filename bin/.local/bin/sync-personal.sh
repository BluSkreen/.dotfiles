#!/usr/bin/env bash

set -e

SRC="$HOME/personal/"
DST="$HOME/Dropbox/personal-backup/"

# --delete \
# rsync -avh \
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
