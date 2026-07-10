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
`$HOME/.claude/skills/`.

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
