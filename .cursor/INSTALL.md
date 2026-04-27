# Cursor Install

## Preferred

```bash
npx skills add gigio1023/godot-best-practice --agent cursor
```

## Manual install

Install into Cursor skills:

```bash
mkdir -p ~/.cursor/skills
git clone git@github.com:gigio1023/godot-best-practice.git ~/.cursor/skills/godot-best-practice
```

Or symlink from the shared agents directory:

```bash
mkdir -p ~/.agents/skills ~/.cursor/skills
git clone git@github.com:gigio1023/godot-best-practice.git ~/.agents/skills/godot-best-practice
ln -s ~/.agents/skills/godot-best-practice ~/.cursor/skills/godot-best-practice
```
