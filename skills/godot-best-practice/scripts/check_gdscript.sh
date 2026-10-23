#!/usr/bin/env bash
# Parse regular .gd files in a trusted project; importing is a separate action.
set -u

usage() {
	printf '%s\n' "Usage: check_gdscript.sh [--] [PROJECT_DIR]"
	printf '%s\n' "Set GODOT_BIN (or legacy GODOT_PATH) to the matching Godot editor binary."
	printf '%s\n' "Requires Bash, find, mktemp, and grep. Does not import assets or run a scene."
}

if [ "$#" -eq 1 ] && { [ "$1" = "-h" ] || [ "$1" = "--help" ]; }; then
	usage
	exit 0
fi
if [ "${1:-}" = "--" ]; then
	shift
fi
if [ "$#" -gt 1 ] || { [ "$#" -eq 1 ] && [ -z "$1" ]; }; then
	usage >&2
	exit 2
fi

project_input="${1:-.}"
godot_input="${GODOT_BIN:-${GODOT_PATH:-godot}}"

if [ ! -d "$project_input" ]; then
	printf 'FAIL: project directory does not exist: %s\n' "$project_input" >&2
	exit 2
fi
project_dir=$(cd -- "$project_input" && pwd -P) || exit 2
if [ ! -f "$project_dir/project.godot" ]; then
	printf 'FAIL: project.godot not found in %s\n' "$project_dir" >&2
	exit 2
fi

# Materialize discovery so a partial/failed find cannot become a passing scan.
scratch=$(mktemp -d "${TMPDIR:-/tmp}/check-gdscript.XXXXXXXX") || exit 2
trap 'rm -rf -- "$scratch"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
if ! find "$project_dir" \
	-type d \( -name .git -o -name .godot \) -prune -o \
	-type f -name '*.gd' -print0 > "$scratch/scripts"; then
	printf 'FAIL: could not discover all GDScript files in %s\n' "$project_dir" >&2
	exit 2
fi
if [ ! -s "$scratch/scripts" ]; then
	printf 'SKIP: no regular .gd files found in %s; no Godot check ran.\n' "$project_dir"
	exit 0
fi

case "$godot_input" in
	*/*) godot_bin="$godot_input" ;;
	*) godot_bin=$(command -v "$godot_input" 2>/dev/null || true) ;;
esac
if [ -z "$godot_bin" ] || [ ! -f "$godot_bin" ] || [ ! -x "$godot_bin" ]; then
	printf 'FAIL: Godot binary not found or not executable: %s\n' "$godot_input" >&2
	exit 127
fi

if godot_version=$("$godot_bin" --version 2>&1); then
	:
else
	status=$?
	printf 'FAIL: could not read Godot version with %s (exit %d)\n' "$godot_bin" "$status" >&2
	printf '%s\n' "$godot_version" >&2
	exit "$status"
fi
if godot_help=$("$godot_bin" --help 2>&1); then
	:
else
	status=$?
	printf 'FAIL: could not read Godot help (exit %d)\n' "$status" >&2
	printf '%s\n' "$godot_help" >&2
	exit "$status"
fi
# Godot can silently ignore unavailable CLI options, even with exit status zero.
for option in --headless --path --script --check-only; do
	if ! printf '%s\n' "$godot_help" | grep -Fq -- "$option"; then
		printf 'FAIL: configured binary does not advertise %s in --help\n' "$option" >&2
		exit 2
	fi
done

printf 'Godot: %s\n' "$godot_version"
printf 'Project: %s\n' "$project_dir"
checked=0
failed=0

while IFS= read -r -d '' file; do
	rel_path=${file#"$project_dir"/}
	checked=$((checked + 1))
	if output=$("$godot_bin" --headless --path "$project_dir" --script "res://$rel_path" --check-only 2>&1); then
		status=0
	else
		status=$?
	fi
	if [ "$status" -ne 0 ] || printf '%s\n' "$output" | grep -Eq 'ERROR:|Parse Error|Compile Error|Failed to load script'; then
		printf 'FAIL: %s (exit %d)\n' "$rel_path" "$status"
		printf '%s\n' "$output"
		failed=$((failed + 1))
	else
		printf 'OK: %s\n' "$rel_path"
		# Warnings can explain a limited result even when parsing succeeds.
		if printf '%s\n' "$output" | grep -q 'WARNING:'; then
			printf '%s\n' "$output"
		fi
	fi
done < "$scratch/scripts"

printf 'Checked: %d\n' "$checked"
printf 'Failed: %d\n' "$failed"
if [ "$failed" -ne 0 ]; then
	exit 1
fi
