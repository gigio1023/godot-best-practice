# godot-best-practice

A portable skill that keeps coding agents from mistaking a plausible diff for a
working Godot project.

It changes the default workflow from “the text looks right” to:

**inspect the project and engine version → preserve Godot ownership and resource
semantics → make the smallest native change → prove it at the engine layer**

That matters because many Godot failures are invisible in a normal code review.
Scripts can parse against the wrong minor version, a tiny `.tscn` edit can break
resource IDs or node ownership, an imported asset can work in the editor but
disappear from an export, and a clean diff says nothing about layout, collision,
rendering, or runtime behavior.

## What changes with the skill

- **Version before advice.** The agent identifies the project's Godot version
  and checks version-matched official docs or engine source for exact behavior.
- **Godot files stay Godot files.** Scenes, resources, UIDs, NodePaths, imports,
  and generated outputs are handled as serialized engine data, not arbitrary
  text.
- **Architecture follows ownership.** Scenes, scripts, resources, signals,
  groups, and autoloads are selected by composition, lifetime, and dependency
  boundaries.
- **Completion requires the right evidence.** A parse, import, build, scene load,
  runtime capture, or export is chosen according to the claim. Missing evidence
  is reported as blocked, never inferred as a pass.

| Common agent failure | What this skill makes explicit |
| --- | --- |
| Reuses Godot 3 or older 4.x APIs from memory | Detect the project version and verify the exact class, migration, or implementation source |
| Patches `.tscn`/`.tres` like ordinary code | Preserve section order, UIDs, resource IDs, paths, node ownership, and import/generated boundaries |
| Hides cross-scene dependencies in `/root/...` NodePaths | Compose dependencies at their owning scene with references or signals |
| Calls a clean diff “done” | Match the claim with engine, runtime, visual, or export evidence |
| Runs a random local editor against an older project | Treat version changes as migrations with explicit scope and recoverable version control |

## Use it for

- GDScript and Godot C# implementation, debugging, and review
- `project.godot`, `.gd`, `.tscn`, `.tres`, `.import`, scenes, and resources
- scene ownership, signals, groups, autoloads, input, and lifecycle design
- 2D, 3D, UI, physics, navigation, rendering, shaders, and asset imports
- export diagnosis and version upgrades
- review-only checks where the project must remain unchanged

It is not an engine-neutral game-design guide, a generic C#/GLSL style guide, an
asset generator, or a guide for contributing to the Godot engine source itself.

## How it works

1. Inspect the actual project root, version evidence, repository conventions,
   language stack, addons, renderer/physics choices, and affected files.
2. Route the task to a small versioned reference instead of loading a broad
   Godot handbook.
3. Preserve existing public paths and serialized contracts while choosing the
   smallest Godot-native boundary.
4. Validate only at layers that prove the requested result and report every
   unavailable layer honestly.

The common `SKILL.md` contains no Claude-only or Codex-only invocation, tool, or
permission syntax. Installation and UI metadata stay in adapters so the domain
contract remains usable in both harnesses.

## Optional live editor control

The portable baseline remains file editing plus the Godot CLI. When a compatible
live-editor integration is already configured, the skill now prefers it for
editor-owned scene changes, runtime input and inspection, logs, and visual
capture, while keeping code-heavy edits, CI, and exports on their stronger
file/CLI paths.

[Godot AI](https://github.com/hi-godot/godot-ai) is the first recommended
adapter. The skill verifies the exact project session and readiness before
stateful calls, combines file edits with live reload and play evidence, and
falls back cleanly when the integration is missing or offline. Godot AI is not
a package dependency: installing this skill never installs or configures an MCP
server or project addon. The versioned capability mapping and safety rules live
in
[`references/live-editor-control.md`](skills/godot-best-practice/references/live-editor-control.md).

## Try it

- `Fix this GDScript using the project's Godot version and run the narrowest useful checks.`
- `Review this .tscn diff for UID, resource, NodePath, and ownership risks. Do not edit files.`
- `Refactor this cross-scene absolute NodePath into a Godot-native dependency.`
- `Diagnose why this imported GLB works in the editor but fails in the export.`
- `Assess upgrading this project to the current stable Godot release and cite the official migration sources.`

## Install

The repository keeps the installable payload at
`skills/godot-best-practice/`. This is intentional: remote installs then include
its references, script, and Codex metadata instead of copying only `SKILL.md`.

Install for the current project:

```bash
npx skills add gigio1023/godot-best-practice --agent codex --agent claude-code
```

Install for your user account across projects:

```bash
npx skills add gigio1023/godot-best-practice --agent codex --agent claude-code --global
```

The agent identifiers `codex` and `claude-code` and the complete nested-payload
install were verified with Skills CLI 1.5.15 and rechecked against the Skills
CLI 1.7.0 source on 2026-09-23. Project installs use `.agents/skills/` for Codex
and `.claude/skills/` for Claude Code; user installs use `$HOME/.agents/skills/`
and `$HOME/.claude/skills/` respectively.

For a development checkout or manual symlink, follow the focused
[Codex](.codex/INSTALL.md) or [Claude Code](.claude/INSTALL.md) guide.

## Version and source policy

This rewrite was grounded in the official Godot 4.7 stable engine tag and the
matching documentation branch:

- Godot `4.7-stable`, released 2026-06-18, commit
  [`5b4e0cb`](https://github.com/godotengine/godot/commit/5b4e0cb0fd279832bbdd69fed5354d4e5ad26f88)
- `godot-docs` branch `4.7`, commit
  [`0585d03`](https://github.com/godotengine/godot-docs/commit/0585d03bea24497cf91f0969c81a187c892371c4)

Those values are a reproducible authoring baseline, not a permanent “latest”
claim. The skill detects the target project's version first and rechecks official
release evidence whenever the user asks for current behavior. See
[source provenance](docs/source-provenance.md) for the exact implementation and
documentation files used.

## Package layout

```text
godot-best-practice/
├── README.md                    # Why, scope, install, and maintenance entry point
├── skills/godot-best-practice/ # Complete installable payload
│   ├── SKILL.md                # Portable Godot task contract
│   ├── references/             # Versioned domain guidance + optional live-editor adapter
│   ├── scripts/                # Deterministic GDScript parser check
│   └── agents/openai.yaml      # Optional Codex UI adapter
├── .codex/INSTALL.md
├── .claude/INSTALL.md
├── docs/source-provenance.md
└── evals/                      # Cross-harness fixtures, rubric, and results
```

The 2026-07-10 evaluation targeted Codex with GPT-5.6 Sol and Claude Code with
Claude Fable 5; future runs target GPT-6 Sol in Codex 0.156.1 or later and
Claude Fable 5.1 in Claude Code. The same fixture and rubric compare no skill,
the previous skill, and this candidate; unavailable cells remain explicitly
untested. See the [evaluation protocol](evals/README.md) and [recorded
results](evals/results.md).

## License

MIT. Official Godot sources are linked and attributed but not vendored.
