#!/usr/bin/env bash
# Run explicit GLB export/import/reimport in a retained temporary workspace.
set -euo pipefail

if [[ "${1:-}" == "--help" ]]; then
    printf '%s\n' 'Usage: BLENDER_BIN=/absolute/path/to/blender GODOT_BIN=/absolute/path/to/godot ./run.sh'
    printf '%s\n' 'Requires Bash and local editor binaries. Keeps its temporary project and logs.'
    exit 0
fi

for variable in BLENDER_BIN GODOT_BIN; do
    binary="${!variable:-}"
    if [[ "$binary" != /* || ! -x "$binary" ]]; then
        printf 'FAIL: %s must name an executable absolute path\n' "$variable" >&2
        exit 2
    fi
done

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
workspace=$(mktemp -d "${TMPDIR:-/tmp}/blender-godot-smoke.XXXXXX")
project="$workspace/project"
mkdir -p "$project/assets" "$workspace/source" "$workspace/logs"
printf 'Artifacts: %s\n' "$workspace"
cp "$script_dir/check_import.gd" "$project/check_import.gd"

cat > "$project/project.godot" <<'EOF'
config_version=5

[application]
config/name="Blender GLB import smoke"

[rendering]
renderer/rendering_method="gl_compatibility"
EOF

cat > "$project/wrapper.tscn" <<'EOF'
[gd_scene format=3]

[ext_resource type="PackedScene" path="res://assets/fixture.glb" id="1_asset"]

[node name="GameOwnedWrapper" type="Node3D"]
metadata/smoke_owner = "game"

[node name="Model" parent="." instance=ExtResource("1_asset")]

[node name="GameOwnedMarker" type="Marker3D" parent="."]
position = Vector3(4, 5, 6)
EOF
cp "$project/wrapper.tscn" "$workspace/wrapper.before.tscn"

run_logged() {
    local label="$1"
    shift
    "$@" 2>&1 | tee "$workspace/logs/$label.log"
    if grep -Eq 'SCRIPT ERROR|^ERROR:|^Error:' "$workspace/logs/$label.log"; then
        printf 'FAIL: engine error in %s\n' "$workspace/logs/$label.log" >&2
        exit 1
    fi
}

run_logged blender-version "$BLENDER_BIN" --version
run_logged godot-version "$GODOT_BIN" --version

for stage in initial reimport; do
    run_logged "blender-$stage" "$BLENDER_BIN" --background --factory-startup \
        --python-exit-code 1 --python "$script_dir/export_fixture.py" -- \
        "$stage" "$workspace/source/fixture.blend" "$project/assets/fixture.glb"
    if [[ "$stage" == initial ]]; then
        cp "$project/assets/fixture.glb" "$workspace/fixture.before.glb"
    elif cmp -s "$workspace/fixture.before.glb" "$project/assets/fixture.glb"; then
        printf '%s\n' 'FAIL: reexport did not change the GLB' >&2
        exit 1
    fi
    run_logged "godot-import-$stage" "$GODOT_BIN" --headless --path "$project" --import
    run_logged "godot-check-$stage" "$GODOT_BIN" --headless --path "$project" \
        --script res://check_import.gd -- "$stage"
    grep -q "PASS stage=$stage" "$workspace/logs/godot-check-$stage.log"
done

if ! cmp -s "$workspace/wrapper.before.tscn" "$project/wrapper.tscn"; then
    printf '%s\n' 'FAIL: reimport changed the game-owned wrapper file' >&2
    exit 1
fi
printf 'PASS: initial import and changed-source reimport; wrapper file unchanged\nArtifacts: %s\n' "$workspace"
