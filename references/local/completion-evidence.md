# Completion Evidence

Use this before claiming Godot work is complete.

## Contents

- Minimum Evidence
- Script Evidence
- Scene And Resource Evidence
- Scene Generation Evidence
- Visual Evidence
- Export Evidence
- Version Upgrade Evidence
- Report Format

## Minimum Evidence

Run from the Godot project root when Godot is available:

```bash
godot --headless --import
bash scripts/check_gd_syntax.sh .
```

If the repo stores the skill scripts outside the Godot project, call them by absolute path:

```bash
bash /path/to/godot-best-practice/scripts/check_gd_syntax.sh /path/to/project
```

If the repo does not include a local syntax script, use the skill script or a targeted Godot `--check-only` command.

## Script Evidence

For changed `.gd` files:

```bash
godot --headless --script res://path/to/script.gd --check-only
```

For C# projects, also run the project's normal .NET/Godot build workflow if present.

## Scene And Resource Evidence

For changed scenes/resources:

1. run `godot --headless --import`
2. load or instantiate the changed scene
3. assert required child nodes, exported dependencies, and groups exist
4. run a short smoke script if behavior changed

## Scene Generation Evidence

For generated scenes:

1. check layout JSON against a schema if one exists
2. run the generator
3. run `godot --headless --import`
4. open or load the generated scene through Godot
5. run a smoke script that verifies required node names/groups exist

## Visual Evidence

For UI, 2D layout, 3D layout, lighting, camera, collision visibility, or animation timing, text inspection is insufficient.

At minimum, provide one of:

- Playwright/browser screenshot if the game is exported or run through a viewport tool
- Godot screenshot capture script
- manual screenshot from a launched project
- recorded run for navigation-heavy changes

Check:

- player is not spawned inside geometry
- main landmarks or UI panels are visible and reachable
- actor routes do not clip through walls
- labels/text surfaces are readable
- UI does not overlap or clip at target resolutions
- lighting/camera changes are visible in runtime

## Export Evidence

For export changes:

1. inspect `export_presets.cfg`
2. verify export templates are installed when possible
3. run the relevant export command or document why it is blocked
4. smoke-launch the exported artifact when feasible

Example:

```bash
godot --headless --export-release "Web" build/web/index.html
```

## Version Upgrade Evidence

For Godot version upgrades or broad portability work:

- read official upgrade notes for the source and target versions
- run import after opening with the target version
- run representative smoke scenes
- inspect changed rendering, physics, input, export, and C#/.NET behavior when relevant
- keep before/after screenshots or logs for user-facing behavior

## Report Format

Final agent response should include:

```text
Godot version:
Commands run:
Visual evidence:
Export evidence:
Known blocked checks:
Files changed:
```
