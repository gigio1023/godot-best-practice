# Live Editor Control

Use a connected editor when it provides useful scene mutation, diagnostics, input, or visual evidence. Godot AI is an optional third-party adapter. The workflow also applies to other integrations with equivalent capabilities.

## Routing

| Task | Route |
| --- | --- |
| Code or broad text refactor | File edits, followed by reload/build and diagnostics |
| Small understood text-resource edit | File edit or editor operation |
| Node structure, properties, connections | Editor operation with suitable save/undo behavior |
| Camera, materials, lighting, animation, UI | Editor/runtime capture of the changed state |
| Gameplay interaction | Run, bounded input, runtime state/logs, capture |
| Import, CI, export | CLI and resulting artifact |

Before writes or launch, match the canonical project root, Godot version, and readiness. Route explicitly if multiple sessions are plausible. Reuse this evidence until the session or project changes. Apply the same execution authority as the equivalent CLI/editor action, including runtime diagnostics already requested by the user.

Read-only review can inspect a connected editor. Running, reloading, autosaving, or changing the global active session are state changes. Prefer per-call routing and bounded operations; arbitrary code evaluation executes project code. Check the integration's actual capabilities rather than assuming every operation supports undo.

## Godot AI v4.3.0 adapter

Verified **2026-10-23** against the latest release, [v4.3.0](https://github.com/hi-godot/godot-ai/releases/tag/v4.3.0), commit `b82b5c519b1b17228f70d8effce1626f391bd1dd`. The pinned [README](https://github.com/hi-godot/godot-ai/blob/b82b5c519b1b17228f70d8effce1626f391bd1dd/README.md) and [tool catalog](https://github.com/hi-godot/godot-ai/blob/b82b5c519b1b17228f70d8effce1626f391bd1dd/docs/TOOLS.md) own installation, schemas, and response details. This source check is not a live integration test.

V4 requires Godot 4.7+ within the 4.x line; v3/v4 plugins and servers are incompatible. Use the `godot-ai attach` stdio command supplied by the editor dock's **Configure** or manual fallback. A bare `http://127.0.0.1:8000/mcp` entry cannot authenticate. Missing setup is not permission to upgrade the project or reconfigure the user's tools.

Tool names below are server names; host prefixes vary.

1. Use `session_manage(op="list")` or `godot://sessions` to identify the exact project. Rolled-up tools accept top-level `session_id`, beside `op` and `params`. For tools without per-call routing, use `session_activate` only after resolving the target and accounting for its state change.
2. Read `editor_state`; require `readiness="ready"` before writes. Confirm the intended scene where relevant.
3. Use scene/node/resource operations for editor-owned structure. Edit substantial code in files, then reload or import. Inspect returned `diagnostics` and new-error hints before dependent edits, including in headless sessions.
4. Run with `project_run` when behavior must be exercised. It **autosaves in-memory MCP edits by default**; use `autosave=False` when those edits must remain unsaved, and account for whether the run can observe unsaved state.
5. Inspect `game_status.status` using the table below. Exercise the changed state with `game_manage` runtime queries or bounded input.
6. Read `logs_read(source="editor", include_details=true)` for parse/load/plugin/debugger errors and `source="game"` for the current run. Retain `run_id` across launches. A clean game log cannot rule out boot errors that occurred before the helper connected.
7. Use `editor_screenshot` with the appropriate target: `viewport`, `viewport_2d`, `cinematic`, or `game`. Record scene, exercised state, viewport, and renderer. If Vision Routing returns `vision_description`/`routed_via`, report it as a routed description; it is not an image you inspected.
8. Stop an unintended running or debugger-break session with `project_manage(op="stop")`. Keep a user-owned editor open.

| `game_status.status` | Meaning and next action |
| --- | --- |
| `live` | Game helper connected; proceed with supported runtime checks |
| `launching` | Helper not ready yet; poll within a bounded startup window |
| `not_live` | Helper-ready window expired; inspect launch/parse/load diagnostics |
| `break` | Debugger stopped the game; stop, inspect the error, fix, then relaunch |
| `no_helper` | Process launched without helper; use process evidence, not helper-dependent input/capture |
| `stopped` | No active game session |

### C# boundary

Godot AI v4.3.0 reads and edits C# as text. `diagnostics_status="not_checked"` and an empty diagnostics array do not mean compilation passed. Rebuild with the .NET workflow and inspect its output; `logs_read` does not capture the .NET compiler's build output.

## Evidence and fallback

An operation response proves that operation, not gameplay, image quality, or export success. Mark a result passed only when the intended state or artifact was observed; distinguish relevant errors, unavailable prerequisites, and calls that did not exercise the claim.

For a plausible startup race, refresh status once or use a bounded readiness poll. If the same prerequisite remains absent, continue through files/CLI and identify the specific live or visual evidence that remains unavailable. Do not repeatedly rediscover tools or retry a missing service.
