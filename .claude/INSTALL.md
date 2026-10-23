# Claude Code install

The installable skill is `skills/godot-best-practice/` in this repository.

## Skills CLI

Project scope:

```bash
npx skills add gigio1023/godot-best-practice --agent claude-code
```

User scope:

```bash
npx skills add gigio1023/godot-best-practice --agent claude-code --global
```

Claude Code discovers project skills in `.claude/skills/` and user skills in
`$HOME/.claude/skills/` by default. Skills CLI uses `$CLAUDE_CONFIG_DIR/skills/`
for user installs when `CLAUDE_CONFIG_DIR` is set. These paths were checked
against [Skills CLI 1.7.4](https://github.com/vercel-labs/skills/blob/a80e4c9d12d607631249d4d7d059f835d4b2f13a/src/agents.ts#L155-L163)
on 2026-10-23. That release requires Node.js 22.20 or newer.

## Development checkout

Clone the repository somewhere stable, then link the payload rather than the
repository root:

```bash
git clone https://github.com/gigio1023/godot-best-practice.git "$HOME/git/godot-best-practice"
mkdir -p "$HOME/.claude/skills"
ln -s "$HOME/git/godot-best-practice/skills/godot-best-practice" \
  "$HOME/.claude/skills/godot-best-practice"
```

For a project-only link, place it under
`.claude/skills/godot-best-practice` instead.

Invoke it explicitly as `/godot-best-practice` when needed; the trigger
description also supports implicit selection. After updating the checkout,
verify `SKILL.md`, every linked reference, and the bundled script.
