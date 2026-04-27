# Claude Code Install

## Preferred

```bash
npx skills add gigio1023/godot-best-practice --agent claude-code
```

## Manual install

Install into Claude Code skills:

```bash
mkdir -p ~/.claude/skills
git clone git@github.com:gigio1023/godot-best-practice.git ~/.claude/skills/godot-best-practice
```

Or use the shared agents directory and symlink:

```bash
mkdir -p ~/.agents/skills ~/.claude/skills
git clone git@github.com:gigio1023/godot-best-practice.git ~/.agents/skills/godot-best-practice
ln -s ~/.agents/skills/godot-best-practice ~/.claude/skills/godot-best-practice
```
