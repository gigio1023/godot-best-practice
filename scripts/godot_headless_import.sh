#!/usr/bin/env bash
set -euo pipefail

GODOT_PATH="${GODOT_PATH:-godot}"
PROJECT_PATH="${1:-.}"

if [ ! -f "$PROJECT_PATH/project.godot" ]; then
  echo "FAIL: project.godot not found in $PROJECT_PATH"
  exit 2
fi

echo "Using Godot: $GODOT_PATH"
echo "Project: $PROJECT_PATH"
"$GODOT_PATH" --headless --path "$PROJECT_PATH" --import
