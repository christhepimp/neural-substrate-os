#!/usr/bin/env bash
# Run against a rooted Android emulator: ./lab/probe-host.sh
# Requires adb in PATH and `su` working in the guest.
set -euo pipefail

OUT_DIR="${1:-lab/captures}"
mkdir -p "$OUT_DIR"
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
FILE="$OUT_DIR/probe-$STAMP.txt"

echo "Writing $FILE"
{
  echo "=== uname ==="
  adb shell uname -a || true
  echo
  echo "=== /proc/version ==="
  adb shell cat /proc/version || true
  echo
  echo "=== id (unprivileged) ==="
  adb shell id || true
  echo
  echo "=== id (su) ==="
  adb shell su -c id || true
  echo
  echo "=== fingerprint ==="
  adb shell getprop ro.build.fingerprint || true
  echo
  echo "=== mounts (head) ==="
  adb shell mount | head -n 40 || true
} | tee "$FILE"

echo "Done."
