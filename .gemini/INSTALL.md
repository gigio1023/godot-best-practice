# Gemini CLI Install

## Preferred

```bash
npx skills add gigio1023/godot-best-practice --agent gemini
```

For private repos, make sure the environment has GitHub credentials that can read `gigio1023/godot-best-practice`.

## Manual install

Install into the shared agents skill directory:

```bash
mkdir -p ~/.agents/skills
git clone git@github.com:gigio1023/godot-best-practice.git ~/.agents/skills/godot-best-practice
```

Then configure Gemini CLI to read this skill directory according to your local Gemini setup.
