# godot-best-practice

Reusable Godot 4.x best-practice skill for coding agents.

This is a project-neutral skill. It is meant to work in any Godot project, not only 3D projects and not a specific game/runtime. It guides agents to read the project first, use Godot-native patterns, consult official docs for exact behavior, edit conservatively, and verify with Godot CLI/runtime evidence.

## Install

```bash
npx skills add gigio1023/godot-best-practice
```

Agent-specific installs:

```bash
npx skills add gigio1023/godot-best-practice --agent codex
npx skills add gigio1023/godot-best-practice --agent claude-code
npx skills add gigio1023/godot-best-practice --agent gemini
npx skills add gigio1023/godot-best-practice --agent cursor
```

If this repository is private, run the install from an environment with GitHub credentials for `gigio1023/godot-best-practice`.

## Scope

Use this skill for Godot 4.x work involving:

- GDScript and C#
- scenes, nodes, resources, signals, groups, and autoloads
- 2D, 3D, UI, physics, navigation, rendering, shaders, assets, and export
- `.gd`, `.tscn`, `.tres`, imports, generated scenes, and project settings
- validation, smoke checks, screenshots, exports, and version upgrades

## Structure

- `SKILL.md` - trigger metadata and routing instructions
- `references/local/` - focused Godot guidance loaded on demand
- `references/research/` - source notes and attribution
- `scripts/` - validation and Godot CLI helper scripts
- `assets/templates/` - reusable generated-layout examples
- `.codex/`, `.claude/`, `.cursor/`, `.gemini/` - agent-specific install notes

The skill does not vendor the full Godot documentation. It keeps local guidance compact and points agents to official docs through `references/local/official-docs-index.md`.

## Validate

Validate the skill package:

```bash
bash scripts/validate_skill_structure.sh .
```

Useful Godot project checks:

```bash
bash scripts/godot_headless_import.sh /path/to/godot/project
bash scripts/check_gd_syntax.sh /path/to/godot/project
```

These scripts catch early structure/import/syntax issues. They do not replace runtime smoke tests, visual inspection, export checks, or official documentation lookup.

## Attribution

This repo does not vendor upstream skill files. It uses public Godot skill and MCP examples as research inputs, noted in `references/research/source-notes.md`. The syntax-checking workflow is inspired by the MIT-licensed `fernforestgames/agent-skill-godot`; details are in `NOTICE`.

## License

Personal use.
