# Codex install

The installable skill is `skills/godot-best-practice/` in this repository.

## Skills CLI

Project scope:

```bash
npx skills add gigio1023/godot-best-practice --agent codex
```

User scope:

```bash
npx skills add gigio1023/godot-best-practice --agent codex --global
```

Codex discovers project skills in `.agents/skills/` and user skills in
`$HOME/.agents/skills/`.

## Development checkout

Clone the repository somewhere stable, then link the payload rather than the
repository root:

```bash
git clone https://github.com/gigio1023/godot-best-practice.git "$HOME/git/godot-best-practice"
mkdir -p "$HOME/.agents/skills"
ln -s "$HOME/git/godot-best-practice/skills/godot-best-practice" \
  "$HOME/.agents/skills/godot-best-practice"
```

For a project-only link, place it under
`.agents/skills/godot-best-practice` instead.

After updating the checkout, verify `SKILL.md`, every linked reference, and the
bundled script before relying on the skill. Do not use `skills check` as a lint
command; in Skills CLI 1.5.15 through 1.7.0 it is an alias for `skills update`.
