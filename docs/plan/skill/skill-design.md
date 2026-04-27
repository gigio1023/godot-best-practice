# Skill Design

## Goal

Create a reusable `godot-best-practice` skill that makes coding agents effective across Godot 4.x work: GDScript, C#, scenes, resources, 2D, 3D, UI, physics, navigation, rendering, shaders, import/export, version upgrades, and runtime evidence checks.

The skill should carry high-signal Godot practice locally, while using official docs for exact details and version-sensitive behavior.

## Skill Category

Primary: Library and API Reference.

Secondary:

- Product Verification
- Code Quality and Review
- Code Scaffolding and Templates
- Runbook

The skill intentionally avoids vendoring the full official Godot docs. It focuses on agent failure modes, practical defaults, official-doc lookup paths, and repeatable runtime checks.

## Trigger Strategy

The skill description must be pushy enough to trigger for:

- Godot
- Godot best practice
- GDScript and C#
- `.gd`, `.tscn`, `.tres`
- nodes, scenes, resources, signals, groups, autoloads
- 2D, 3D, UI, physics, navigation, rendering, shaders
- asset import and export
- version upgrades and portability questions
- Korean Godot requests such as `Godot 문법`, `Godot 활용법`, `Godot 패턴`, `Godot 씬`

## Progressive Disclosure

`SKILL.md` stays short and routes the agent to references:

- `official-docs-index.md`
- `godot-version-and-cli.md`
- `gdscript-and-csharp.md`
- `godot-architecture-patterns.md`
- `scene-resource-workflow.md`
- `domain-guides.md`
- `completion-evidence.md`
- `mcp-integration.md`
- `3d-generation-patterns.md`
- `source-notes.md`

Scripts are bundled for deterministic checks. They should be executed instead of re-created by the agent.

## Official Docs Strategy

Use a hybrid docs model:

1. Local skill notes provide stable best-practice defaults.
2. `~/git/godot-docs` provides fast local search over official docs when present.
3. `https://docs.godotengine.org/en/stable/` provides hosted stable docs.
4. `https://github.com/godotengine/godot-docs` and raw GitHub URLs provide web-fetchable source when hosted page structure changes.

This avoids bloating `SKILL.md` while keeping the agent grounded in official docs.

## Non-Goals

- Do not vendor all official Godot docs.
- Do not require a specific MCP server.
- Do not make GUT mandatory.
- Do not convert Unity projects mechanically.
- Do not make the skill 3D-only.

- no secrets are committed.
