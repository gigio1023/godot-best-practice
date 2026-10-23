# Deterministic validation, 2026-10-23

The refreshed checker passed 14 controlled CLI cases and real Godot 4.7.2 fixture checks. These results establish helper behavior and a small engine smoke scenario. No new model or cross-harness behavior evaluation ran; the [2026-07-10 evaluation](results.md) remains historical evidence for its recorded payloads.

## Checker contract cases

Run from the repository root:

```sh
bash -n skills/godot-best-practice/scripts/check_gdscript.sh
bash -n evals/checker-smoke.sh
bash evals/checker-smoke.sh
```

The smoke runner copies the frozen fixture into a temporary directory and uses a controlled engine adapter. It removes the temporary files on exit and needs no installed Godot. The cases check public command results, including reproduced false-success paths; they do not measure engine correctness.

| Case | Observed exit |
| --- | ---: |
| Spaces, newline filename, cache exclusion | 0; four scripts checked |
| Legacy `GODOT_PATH` | 0 |
| No GDScript files | 0; explicit `SKIP` |
| Missing project | 2 |
| Empty project argument | 2 |
| Extra arguments | 2 |
| Missing binary | 127 |
| Binary version failure | 42 |
| Binary help failure | 42 |
| Missing CLI capability | 2 |
| Suppressed parser diagnostics | 2 |
| Engine error with exit zero | 1 |
| Nonzero parser error | 1 |
| Partial file discovery failure | 2 |

Before the fix, extra arguments were ignored and failed file discovery returned `Checked: 0`, `Failed: 0`, exit 0. An empty project returned the same apparent success. It now reports an explicit skip, so a C# project does not fail merely because it has no GDScript.

The GitHub workflow runs these deterministic cases on Linux and macOS with `actions/checkout` pinned to [v7.0.1](https://github.com/actions/checkout/releases/tag/v7.0.1). Its Node 24 runtime requires Actions Runner 2.327.1 or later; the workflow uses GitHub-hosted current runners. The local run used macOS and Bash 3.2. CI execution is separate from the local result recorded here.

## Real engine checks

Binary: `4.7.2.stable.official.ed1daf0bf`, [official standard macOS build](https://godotengine.org/download/archive/4.7.2-stable/), extracted into temporary storage. No global engine installation was performed. The downloaded ZIP SHA-256 matched the official release API digest:

```text
c58a24e31d720be9d62f60cb5627c4e695fb72f21b0cfe1bc9ccaa9a3b3ba63e
```

With `GODOT_BIN` set to the absolute executable path, these commands reproduce the scenario from the repository root:

```sh
scratch=$(mktemp -d)
cp -R evals/fixture "$scratch/project"
"$GODOT_BIN" --headless --path "$scratch/project" --import
GODOT_BIN="$GODOT_BIN" bash skills/godot-best-practice/scripts/check_gdscript.sh "$scratch/project"
"$GODOT_BIN" --headless --path "$scratch/project" \
  --scene res://scenes/main.tscn --quit-after 2
```

| Check | Observed result |
| --- | --- |
| Fresh fixture import | Exit 0; import completed; no error diagnostics |
| Fixture GDScript parse | Exit 0; `Checked: 3`, `Failed: 0` |
| Main scene startup | Exit 0; no error diagnostics in two iterations |

The bounded scene run establishes startup only. It does not exercise input, gameplay outcomes, visual appearance, C#, or exports.

The rejection check appended invalid syntax to the temporary copy:

```sh
printf '\nfunc broken(\n' >> "$scratch/project/scripts/player.gd"
GODOT_BIN="$GODOT_BIN" bash skills/godot-best-practice/scripts/check_gdscript.sh "$scratch/project"
```

The underlying Godot process returned exit 0 and printed `SCRIPT ERROR: Parse Error` and `ERROR: Failed to load script`. The helper returned exit 1 with `Checked: 3`, `Failed: 1`. This confirms why checking diagnostics is necessary even when the process exits successfully. Remove the temporary project after inspecting the results.

## Suppressed diagnostic regression

Independent review reproduced another false success: a malformed script returned engine exit 0 without diagnostics when the project set `application/run/disable_stderr=true`. The setting also took effect from `override.cfg`. The checker now parses a deliberately malformed temporary script in the same project context before scanning and requires the expected parse error plus the exact temporary script path. It returns exit 2 when diagnostics cannot be established. No project configuration is rewritten.

After the invalid-script check above, reproduce the override case on the temporary project:

```sh
printf '[application]\nrun/disable_stderr=true\n' > "$scratch/project/override.cfg"
GODOT_BIN="$GODOT_BIN" bash skills/godot-best-practice/scripts/check_gdscript.sh "$scratch/project"
```

Observed results after the fix:

| Real engine case | Checker result |
| --- | --- |
| Valid fixture in a directory containing spaces | Exit 0; three scripts passed |
| Malformed script, diagnostics enabled | Exit 1; one of three scripts failed |
| Malformed script, `project.godot` suppresses stderr | Exit 2; parser diagnostics unavailable |
| Malformed script, `override.cfg` suppresses stderr | Exit 2; parser diagnostics unavailable |

An independent reviewer reran all four real-engine cases and all 14 controlled cases after the fix. The probe confirms observability; it is not a sandbox or a gameplay test.

The frozen fixture, prompts, rubric, and historical evaluation results were not changed. No fresh model quality, trigger discovery, or cross-harness acceptance claim follows from these checks.
