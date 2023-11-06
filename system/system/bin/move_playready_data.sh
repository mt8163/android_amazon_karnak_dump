#!/system/bin/sh

DEST_PATH_PR="/data/vendor/playready"
FILES_MOVED_PR="/data/vendor/playready/files_moved"
SRC_PATH_PR="/data/playready"

if [ ! -f "$FILES_MOVED_PR" ]; then
  for i in "$SRC_PATH_PR/"*; do
    if [ -f "$i" ]; then
      mv $i "$DEST_PATH_PR"
    fi
  done
  restorecon -R "$DEST_PATH_PR"
  echo 1 > "$FILES_MOVED_PR"
fi
