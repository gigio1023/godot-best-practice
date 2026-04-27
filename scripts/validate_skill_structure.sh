#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"

fail() {
  echo "FAIL $*"
  exit 1
}

required=(
  "SKILL.md"
  "README.md"
  "references/local/official-docs-index.md"
  "references/local/godot-version-and-cli.md"
  "references/local/gdscript-and-csharp.md"
  "references/local/godot-architecture-patterns.md"
  "references/local/scene-resource-workflow.md"
  "references/local/domain-guides.md"
  "references/local/3d-generation-patterns.md"
  "references/local/validation-gates.md"
  "references/local/mcp-integration.md"
  "references/research/source-notes.md"
)

for path in "${required[@]}"; do
  if [ ! -f "$ROOT/$path" ]; then
    fail "missing $path"
  fi
done

name_line=$(grep -E '^name: ' "$ROOT/SKILL.md" | head -n 1)
name="${name_line#name: }"

if [ "$name" != "godot-best-practice" ]; then
  fail "SKILL.md frontmatter name mismatch"
fi

if ! [[ "$name" =~ ^[a-z0-9-]{1,64}$ ]]; then
  fail "SKILL.md name must be lowercase letters, numbers, and hyphens, max 64 chars"
fi

if [[ "$name" =~ anthropic|claude ]]; then
  fail "SKILL.md name contains a reserved word"
fi

grep -q '^description: >' "$ROOT/SKILL.md" || fail "SKILL.md description must use folded frontmatter"

description=$(
  awk '
    /^description: >/ { in_desc=1; next }
    in_desc && /^[a-zA-Z0-9_-]+:/ { exit }
    in_desc { sub(/^  /, ""); print }
  ' "$ROOT/SKILL.md" | tr '\n' ' ' | sed 's/[[:space:]][[:space:]]*/ /g; s/^ //; s/ $//'
)

if [ -z "$description" ]; then
  fail "SKILL.md description is empty"
fi

if [ "${#description}" -gt 1024 ]; then
  fail "SKILL.md description is too long: ${#description} characters"
fi

grep -Eq '^version: [0-9]+\.[0-9]+\.[0-9]+$' "$ROOT/SKILL.md" || fail "SKILL.md version must be semver"

if ! awk '/^tags:$/ { in_tags=1; next } in_tags && /^  - / { found=1 } in_tags && /^---$/ { exit } END { exit found ? 0 : 1 }' "$ROOT/SKILL.md"; then
  fail "SKILL.md tags must include at least one tag"
fi

grep -q '^## Gotchas$' "$ROOT/SKILL.md" || fail "SKILL.md must include a Gotchas section"

line_count=$(wc -l < "$ROOT/SKILL.md" | tr -d ' ')
if [ "$line_count" -gt 500 ]; then
  fail "SKILL.md is too long: $line_count lines"
fi

while IFS= read -r ref; do
  path="${ref#\`}"
  path="${path%\`}"
  if [ ! -f "$ROOT/$path" ]; then
    fail "referenced file missing from SKILL.md: $path"
  fi
done < <(grep -oE '`[^`]+\.md`' "$ROOT/SKILL.md" | sort -u)

while IFS= read -r script; do
  if [ ! -x "$script" ]; then
    fail "script is not executable: ${script#$ROOT/}"
  fi
done < <(find "$ROOT/scripts" -type f)

while IFS= read -r ref_file; do
  ref_lines=$(wc -l < "$ref_file" | tr -d ' ')
  if [ "$ref_lines" -gt 100 ] && ! grep -q '^## Contents$' "$ref_file"; then
    fail "reference over 100 lines lacks Contents section: ${ref_file#$ROOT/}"
  fi
done < <(find "$ROOT/references" -type f -name '*.md')

secret_pattern='AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9_]{36,}|sk-[A-Za-z0-9]{20,}|-----BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY-----'
secret_report="/tmp/godot-best-practice-secret-scan.txt"

if command -v rg >/dev/null 2>&1; then
  if rg -n --hidden --glob '!.git/**' "$secret_pattern" "$ROOT" >"$secret_report"; then
    cat "$secret_report"
    fail "potential secret detected"
  fi
else
  if grep -RIE --exclude-dir=.git "$secret_pattern" "$ROOT" >"$secret_report"; then
    cat "$secret_report"
    fail "potential secret detected"
  fi
fi

echo "OK skill structure valid"
