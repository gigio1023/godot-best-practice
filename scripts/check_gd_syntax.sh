#!/usr/bin/env bash
set -uo pipefail

GODOT_PATH="${GODOT_PATH:-godot}"
PROJECT_PATH="${1:-.}"

if [ ! -f "$PROJECT_PATH/project.godot" ]; then
  echo "FAIL: project.godot not found in $PROJECT_PATH"
  exit 2
fi

echo "Using Godot: $GODOT_PATH"
echo "Project: $PROJECT_PATH"
echo "---"

errors=0
checked=0

while IFS= read -r -d '' file; do
  rel_path="${file#$PROJECT_PATH/}"
  res_path="res://$rel_path"
  checked=$((checked + 1))

  output=$("$GODOT_PATH" --headless --path "$PROJECT_PATH" --script "$res_path" --check-only 2>&1)
  status=$?

  if [ "$status" -ne 0 ] || echo "$output" | grep -Eq "SCRIPT ERROR|Parse Error|Compile Error"; then
    echo "FAIL: $rel_path"
    echo "$output" | grep -E "SCRIPT ERROR|Parse Error|Compile Error|at:" || echo "$output"
    echo ""
    errors=$((errors + 1))
  else
    echo "OK: $rel_path"
  fi
done < <(find "$PROJECT_PATH" -name "*.gd" -type f \
  ! -path "*/.godot/*" \
  ! -path "*/addons/*" \
  -print0)

echo "---"
echo "Checked: $checked files"
echo "Errors: $errors"

exit "$errors"
