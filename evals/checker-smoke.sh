#!/usr/bin/env bash
# Exercise checker input and failure reporting with a controlled CLI adapter.
set -eu

repo=$(cd -- "$(dirname -- "$0")/.." && pwd -P)
checker="$repo/skills/godot-best-practice/scripts/check_gdscript.sh"
scratch=$(mktemp -d "${TMPDIR:-/tmp}/godot-checker-smoke.XXXXXXXX")
trap 'rm -rf -- "$scratch"' EXIT
cp -R "$repo/evals/fixture" "$scratch/project with spaces"
project="$scratch/project with spaces"
mkdir -p "$scratch/bin" "$scratch/empty" "$project/.godot"
touch "$scratch/empty/project.godot" "$project/.godot/ignored.gd"
printf 'extends Node\n' > "$project/scripts/odd name
second.gd"

cat > "$scratch/engine" <<'ENGINE'
#!/usr/bin/env bash
case "${1:-}" in
	--version) printf '4.7.2.stable.fixture\n'; exit 0 ;;
	--help)
		if [ "${SMOKE_MODE:-}" = help-failure ]; then exit 42; fi
		printf '%s\n' '--headless --path --script --check-only'
		exit 0 ;;
esac
case "$*" in *res://.godot/*) exit 9 ;; esac
for arg in "$@"; do
	case "$arg" in
		*/diagnostic-probe.gd)
			if [ "${SMOKE_MODE:-}" != silent-errors ]; then
				printf 'SCRIPT ERROR: Parse Error: intentional probe failure at %s\n' "$arg"
			fi
			exit 0 ;;
	esac
done
case "${SMOKE_MODE:-}" in
	error-zero) printf 'ERROR: intentional resource failure\n'; exit 0 ;;
	parse-failure) printf 'Parse Error: intentional failure\n'; exit 17 ;;
esac
ENGINE
chmod +x "$scratch/engine"

passed=0
expect_exit() {
	local label="$1" expected="$2" actual=0
	shift 2
	"$@" > "$scratch/output" 2>&1 || actual=$?
	if [ "$actual" -ne "$expected" ]; then
		printf 'FAIL: %s: expected exit %d, got %d\n' "$label" "$expected" "$actual" >&2
		cat "$scratch/output" >&2
		exit 1
	fi
	printf 'OK: %s (exit %d)\n' "$label" "$actual"
	passed=$((passed + 1))
}

expect_exit 'spaces, newline filename, and cache exclusion' 0 env GODOT_BIN="$scratch/engine" bash "$checker" "$project"
grep -q '^Checked: 4$' "$scratch/output"
expect_exit 'legacy GODOT_PATH' 0 env GODOT_BIN= GODOT_PATH="$scratch/engine" bash "$checker" "$project"
expect_exit 'empty project is an explicit skip' 0 env GODOT_BIN=/missing bash "$checker" "$scratch/empty"
grep -q '^SKIP:.*no Godot check ran' "$scratch/output"
expect_exit 'missing project' 2 bash "$checker" "$scratch/missing"
expect_exit 'empty path' 2 bash "$checker" ''
expect_exit 'extra arguments' 2 bash "$checker" "$project" unexpected
expect_exit 'missing binary' 127 env GODOT_BIN="$scratch/missing" bash "$checker" "$project"
expect_exit 'version failure status' 42 env GODOT_BIN="$repo/evals/fixture/eval-input/failing-godot.sh" bash "$checker" "$project"
expect_exit 'help failure status' 42 env GODOT_BIN="$scratch/engine" SMOKE_MODE=help-failure bash "$checker" "$project"
expect_exit 'unsupported options' 2 env GODOT_BIN="$repo/evals/fixture/eval-input/fake-godot-ok.sh" bash "$checker" "$project"
expect_exit 'suppressed parser diagnostics' 2 env GODOT_BIN="$scratch/engine" SMOKE_MODE=silent-errors bash "$checker" "$project"
expect_exit 'zero-exit engine error' 1 env GODOT_BIN="$scratch/engine" SMOKE_MODE=error-zero bash "$checker" "$project"
expect_exit 'nonzero parser error' 1 env GODOT_BIN="$scratch/engine" SMOKE_MODE=parse-failure bash "$checker" "$project"

# Reproduce a partial discovery failure, independently of filesystem privileges.
cat > "$scratch/bin/find" <<'FIND'
#!/usr/bin/env bash
printf '%s\0' "$1/scripts/main.gd"
printf 'find: intentional discovery failure\n' >&2
exit 7
FIND
chmod +x "$scratch/bin/find"
expect_exit 'partial discovery failure' 2 env PATH="$scratch/bin:$PATH" GODOT_BIN="$scratch/engine" bash "$checker" "$project"
printf 'Passed: %d checker contract cases. No real Godot execution in this smoke check.\n' "$passed"
