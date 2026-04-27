# godot-best-practice

Godot 4.x guidance for coding agents.

This repo packages the `godot-best-practice` skill: a project-neutral skill that stops agents from treating Godot like generic Python, Unity, web UI, or raw text files. It works across 2D, 3D, UI, physics, navigation, rendering, shaders, assets, export, GDScript, C#, scenes, and resources.

## What It Catches

Without this skill | What breaks in Godot | With this skill
--- | --- | ---
Treats `.tscn` and `.tres` as ordinary text patches | Text scenes/resources have ordered sections, string UIDs, external/internal resources, node ownership, NodePaths, and import rules; small malformed edits can stop the project from importing | Preserve resource structure and IDs; prefer the editor, Godot APIs, `ResourceSaver`, or small generator/editor scripts for fragile scene/resource edits
Claims completion from a clean code diff | Many failures only appear after Godot imports resources, parses scripts, loads scenes, applies UI layout, runs the renderer, or tries an export preset | Ask for the narrowest useful evidence: import run, `--check-only`, scene load, smoke run, screenshot, or export attempt
Answers from Godot 3.x memory or stale 4.x assumptions | Godot 4 changed scene/resource format, physics defaults, class names, C#/.NET support, export behavior, and upgrade rules | Detect the project version first, then check the local official docs, online docs, or class reference before giving exact API/version guidance
Turns game objects into one large script or global manager | Godot docs separate declarative scene composition from imperative scripts; overusing autoloads creates global state, broad bug scope, and unnecessary resource lifetime | Use scenes for game-specific concepts, scripts for behavior/tools, resources for data, signals for decoupling, and autoloads only for genuinely broad lifetime services
Hard-codes long `NodePath`/`GetNode` chains across scenes | Renames, inherited scenes, ownership changes, and imported scene overrides can silently break brittle paths and hidden dependencies | Prefer exported Node/Resource references, scene-unique names, local ownership boundaries, groups, and signals across scene boundaries
Builds UI by fixed pixel positions | Containers take over child Control positioning; anchors, offsets, size flags, scaling, and aspect ratios change what users actually see | Use Control containers, anchors, size flags, themes, and target-resolution screenshots instead of trusting coordinates
Edits imported artifacts as source | `.godot/imported/`, compiled imported scenes, and generated import artifacts can be overwritten or diverge from source assets/import settings | Change source assets, import settings, post-import scripts, or intentional inherited-scene overrides, then reimport and inspect the result
Treats C# as GDScript with braces | Godot C# needs the .NET editor/build, different naming/export/signal patterns, generated partial classes/events, and platform checks such as Godot 4 C# web export limits | Use C#-specific exports, partial classes, generated signal events, build steps, and platform guidance instead of translating syntax mechanically
Assumes desktop success means export success | Export templates, presets, permissions, paths, renderer support, and platform-specific limitations can fail outside the editor | Inspect `export_presets.cfg`, target platform docs, templates, permissions, and run an export attempt when the claim depends on deployment
Generates 3D worlds as coordinate dumps | Raw transform lists are hard to review, regenerate, debug visually, or map back to gameplay intent | Use semantic layout data, named anchors, route IDs, generator scripts, debug groups, and inspection cameras

## Install

### Skills CLI

```bash
npx skills add gigio1023/godot-best-practice
```

### Without Skills CLI

Ask your coding agent to fetch and follow the install instructions for its environment:

Codex:

```text
Fetch and follow instructions from https://raw.githubusercontent.com/gigio1023/godot-best-practice/refs/heads/main/.codex/INSTALL.md
```

Claude Code:

```text
Fetch and follow instructions from https://raw.githubusercontent.com/gigio1023/godot-best-practice/refs/heads/main/.claude/INSTALL.md
```

Cursor:

```text
Fetch and follow instructions from https://raw.githubusercontent.com/gigio1023/godot-best-practice/refs/heads/main/.cursor/INSTALL.md
```

Gemini CLI:

```text
Fetch and follow instructions from https://raw.githubusercontent.com/gigio1023/godot-best-practice/refs/heads/main/.gemini/INSTALL.md
```

Detailed docs: `docs/README.codex.md`, `docs/README.claude.md`, `docs/README.cursor.md`, `docs/README.gemini.md`.

## Use It For

- editing `.gd`, `.cs`, `.tscn`, `.tres`, import settings, and project settings
- designing scene/resource/script boundaries
- choosing between signals, groups, resources, autoloads, and exported references
- checking GDScript/C# syntax and Godot 4.x API assumptions
- working with 2D, 3D, UI, physics, navigation, rendering, shaders, assets, and export
- generating or reviewing data-driven scenes
- upgrading Godot versions or answering version-sensitive Godot questions

## Why This Skill Helps

Godot has strong conventions that general coding agents often miss:

- scenes are declarative composition, not behavior scripts
- `.tscn` and `.tres` are serialized resources, not GDScript
- Godot 3.x advice often breaks or misleads in Godot 4.x
- runtime/visual/export claims need evidence, not just text diffs
- official docs and class reference pages matter for exact names and signatures

The skill keeps those guardrails close while leaving detailed API lookup to official Godot docs.

## What's Inside

- `SKILL.md` - trigger metadata and the default Godot workflow
- `references/local/official-docs-index.md` - local/web official-doc lookup map
- `references/local/gdscript-and-csharp.md` - scripting defaults and gotchas
- `references/local/godot-architecture-patterns.md` - scenes, resources, signals, groups, autoloads
- `references/local/scene-resource-workflow.md` - `.tscn`, `.tres`, imports, generated scenes
- `references/local/domain-guides.md` - 2D, 3D, UI, physics, navigation, rendering, shaders, export
- `references/local/completion-evidence.md` - evidence to collect before claiming Godot work is done
- `references/local/3d-generation-patterns.md` - generated 3D layout patterns
- `scripts/` - Godot import and GDScript syntax helper scripts

## Example Prompts

- `Use Godot best practices to refactor this scene.`
- `Fix this GDScript using Godot 4.x syntax and project conventions.`
- `Review this .tscn edit and tell me if it is safe.`
- `Generate a small Godot 3D layout from this JSON.`
- `Check whether this export setup is correct for Web.`

## Repo Layout

```text
godot-best-practice/
├── SKILL.md
├── references/
│   ├── local/
│   └── research/
├── scripts/
├── assets/templates/
├── docs/
├── .codex/
├── .claude/
├── .cursor/
└── .gemini/
```

## License

MIT.
