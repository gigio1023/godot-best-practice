# Live Editor Control

Use a live-editor integration when it gives stronger evidence or safer
editor-owned mutations than raw file editing. The capability contract is
portable; Godot AI is the recommended first-class adapter, not a required
dependency.

## Contents

- Capability contract
- Routing by task
- Session and authority preflight
- Godot AI adapter
- Evidence and fallback
- Maintenance boundary

## Capability contract

A useful live-editor integration may provide some or all of these capabilities:

- identify connected editor sessions and their project roots;
- read editor readiness, Godot version, current scene, and play state;
- inspect and mutate scene trees, node properties, signals, and resources;
- run and stop the project, inspect the runtime tree, and send player input;
- read editor and game diagnostics;
- capture the editor viewport or running game.

Route by available capability, not by an assumed MCP namespace. Tool prefixes,
installation paths, and configuration syntax belong to each harness. If a
different integration provides the same semantics, apply the same authority and
evidence rules.

## Routing by task

| Task | Preferred route |
| --- | --- |
| GDScript/C# or broad textual refactor | Edit files; use the integration to reload, run, and read diagnostics |
| Small, fully understood `.tscn`/`.tres` edit | Direct edit or live editor, whichever preserves serialized ownership better |
| Add/reparent/configure nodes or connect signals | Live editor with undo/save support |
| Camera, lighting, materials, particles, animation, UI layout | Live editor plus captured visual evidence |
| Gameplay behavior or interaction | Run, send bounded input, inspect runtime state/logs, and capture the exercised state |
| Import, headless smoke, CI | Godot CLI |
| Export | Godot CLI plus artifact inspection or launch |

Do not use a live-editor write merely because it exists. File edits remain
better when the diff is the primary artifact, when many textual occurrences
must change consistently, or when the operation must be reproducible in CI.

## Session and authority preflight

Before the first stateful call:

1. Enumerate sessions or query the intended session directly.
2. Match the editor's canonical project root to the `project.godot` selected for
   the task. A folder name alone is insufficient when several checkouts exist.
3. Confirm the Godot version and editor readiness. Treat plugin/server version
   incompatibility as unavailable capability, not as permission to replace it.
4. Route every call explicitly when multiple sessions remain plausible.
5. Inspect project trust surfaces before launch or reload just as for a direct
   Godot invocation: addons, `@tool` scripts, autoloads, GDExtensions, and build
   hooks can execute code.

Review-only work may read an already-connected editor without saving, reloading,
running, switching the global active session, or mutating state. A change/build
request permits in-scope editor mutations and proportionate runtime checks; it
does not authorize installing or reconfiguring the integration.

Prefer typed, bounded operations over arbitrary evaluation. Runtime code
evaluation is project-code execution and should be used only with implementation
authority, a trusted project, and no narrower operation that proves the claim.

## Godot AI adapter

This mapping was checked on 2026-09-23 against [hi-godot/godot-ai `v4.2.1`](https://github.com/hi-godot/godot-ai/tree/v4.2.1) at commit `bfc264200584ea5823f18356acb164781f57796d`, including its `docs/TOOLS.md`. Recheck the upstream tool catalog and compatibility behavior before changing the mapping or asserting it for a different version.

Godot AI v4 requires Godot 4.7 or newer, and v3 and v4 plugins and servers do not interoperate. A client connects only through the `godot-ai attach` stdio command that the editor dock's **Configure** writes or its **Run this manually** fallback shows; a bare `http://127.0.0.1:8000/mcp` entry cannot authenticate. Treat an older Godot version, a mismatched plugin and server, or a bare HTTP client entry as unavailable capability, not as permission to upgrade or reconfigure the integration.

Use unqualified server tool names here; Codex and Claude Code may expose them
under different MCP prefixes.

1. Call `session_manage(op="list")` (or read `godot://sessions`) and select the
   exact project path. Use per-call `session_id` where available; otherwise pin
   it with `session_activate` after the target is unambiguous.
2. Call `editor_state` and require the expected project name/path context,
   Godot version, current scene when relevant, and `readiness="ready"` before
   writes.
3. Use scene/node/resource domain operations for editor-owned structure. Use
   file editing for substantial code changes, then ask the editor to reimport or
   reload as needed.
4. Use `project_run` for behavior claims. Interpret `game_status`, not only the
   legacy play boolean. `live` proves the game helper connected; `launching`
   needs a bounded poll; `break` requires stop, diagnostics, and a fix before a
   meaningful retry; `no_helper` permits process-level evidence but blocks
   helper-dependent input/capture claims.
5. Use `game_manage` for runtime tree inspection and bounded keyboard, mouse,
   gamepad, or action input. Exercise the changed state rather than only the
   initial frame.
6. Read `logs_read(source="editor", include_details=true)` for parse, load,
   addon, and debugger errors. Read the current run's game log for runtime
   behavior; retain `run_id` when comparing across launches.
7. Use `editor_screenshot` for UI, 2D/3D composition, camera, materials,
   lighting, animation, and running-game claims. Record the scene, state,
   viewport, and renderer that the capture represents.
8. Stop play when the workflow leaves the editor in an unintended running or
   debugger-break state. Do not quit a user-owned editor merely to make a check
   look clean.

After any stateful call, inspect returned diagnostics and new-error hints before
issuing dependent mutations. A successful MCP response proves only that
operation; it does not replace export or platform evidence.

## Evidence and fallback

Classify live-editor evidence with the same labels used elsewhere:

- **Passed:** the intended editor/runtime state and artifact were observed.
- **Failed:** the integration reached the target and returned a relevant error
  or wrong result.
- **Blocked:** the service, compatible editor session, helper, display/GPU, or
  required authority was unavailable.
- **Inconclusive:** the call succeeded but did not exercise or capture the claim.

On connection failure, refresh status once when a transient startup is
plausible. If the same prerequisite remains absent, use the strongest file/CLI
fallback and stop retrying. Never infer that an unobserved scene, interaction,
or visual result passed.

## Maintenance boundary

Keep the portable capability and authority rules stable. Update only this
adapter when Godot AI renames tools, changes readiness/liveness semantics, or
adds a stronger bounded operation. Do not copy the complete upstream tool
manual into this skill; link behavior to the task and evidence decisions that
agents otherwise get wrong.
