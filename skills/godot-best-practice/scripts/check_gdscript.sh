#!/usr/bin/env bash
set -u

usage() {
	printf '%s\n' "Usage: check_gdscript.sh [PROJECT_DIR]"
	printf '%s\n' "Set GODOT_BIN (or legacy GODOT_PATH) to the matching Godot editor binary."
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
	usage
	exit 0
fi

project_input="${1:-.}"
godot_input="${GODOT_BIN:-${GODOT_PATH:-godot}}"

if [ ! -d "$project_input" ]; then
	printf 'FAIL: project directory does not exist: %s\n' "$project_input" >&2
	exit 2
fi

project_dir=$(cd "$project_input" && pwd -P) || exit 2

if [ ! -f "$project_dir/project.godot" ]; then
	printf 'FAIL: project.godot not found in %s\n' "$project_dir" >&2
	exit 2
fi

case "$godot_input" in
	*/*)
		if [ ! -x "$godot_input" ]; then
			printf 'FAIL: Godot binary is not executable: %s\n' "$godot_input" >&2
			exit 127
		fi
		godot_bin="$godot_input"
		;;
	*)
		godot_bin=$(command -v "$godot_input" 2>/dev/null || true)
		if [ -z "$godot_bin" ]; then
			printf 'FAIL: Godot binary not found: %s\n' "$godot_input" >&2
			exit 127
		fi
		;;
esac

if godot_version=$("$godot_bin" --version 2>&1); then
	:
else
	status=$?
	printf 'FAIL: could not read Godot version with %s (exit %d)\n' "$godot_bin" "$status" >&2
	printf '%s\n' "$godot_version" >&2
	exit "$status"
fi

printf 'Godot: %s\n' "$godot_version"
printf 'Project: %s\n' "$project_dir"

checked=0
failed=0

while IFS= read -r -d '' file; do
	rel_path=${file#"$project_dir"/}
	res_path="res://$rel_path"
	checked=$((checked + 1))

	if output=$("$godot_bin" --headless --path "$project_dir" --script "$res_path" --check-only 2>&1); then
		status=0
	else
		status=$?
	fi

	if [ "$status" -ne 0 ] || printf '%s\n' "$output" | grep -Eq 'SCRIPT ERROR|Parse Error|Compile Error|Failed to load script'; then
		printf 'FAIL: %s (exit %d)\n' "$rel_path" "$status"
		printf '%s\n' "$output"
		failed=$((failed + 1))
	else
		printf 'OK: %s\n' "$rel_path"
	fi
done < <(
	find "$project_dir" \
		\( -path "$project_dir/.git" -o -path "$project_dir/.godot" \) -prune -o \
		-type f -name '*.gd' -print0
)

printf 'Checked: %d\n' "$checked"
printf 'Failed: %d\n' "$failed"

if [ "$failed" -ne 0 ]; then
	exit 1
fi
