# Codex Usage

Use this repo as a Codex-readable skill package for Godot 4.x best practices.

Recommended install:

```bash
npx skills add gigio1023/godot-best-practice --agent codex
```

Manual install:

```bash
mkdir -p ~/.agents/skills
git clone git@github.com:gigio1023/godot-best-practice.git ~/.agents/skills/godot-best-practice
```

Trigger examples:

- "Use the Godot best practice skill to refactor this scene."
- "Godot 문법 기준으로 이 GDScript 고쳐줘."
- "Godot UI/physics/export 패턴 확인해서 구현해줘."
- "Generate a Godot `.tscn` from this layout JSON."

Codex should read the project first, use official docs for exact/version-sensitive behavior, prefer Godot-native architecture, and verify with CLI/runtime evidence.
