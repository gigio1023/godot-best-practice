# Blender GLB import smoke

This fixture checks explicit Blender GLB export, Godot import, and changed-source
reimport through a game-owned wrapper scene. It is a runtime smoke check, separate
from the model and harness evaluation in the parent directory.

## Run

From the repository root, supply executable absolute paths to both editors:

```bash
BLENDER_BIN=/path/to/blender \
GODOT_BIN=/path/to/godot \
./evals/blender-smoke/run.sh
```

The runner needs Bash and standard command-line tools. Blender supplies Python
and its glTF exporter. The runner prints a temporary workspace path and retains
the source `.blend`, exported `.glb`, Godot project, and per-command logs there,
including after a failure. It does not download or install editors. The `.blend`
file stays outside the Godot project so it cannot trigger direct Blender import.

The initial export contains a two-meter cube centered at Blender Z = 1 with a
`Slide` translation from X = 0 to X = 2. The source uses frames 1 through 25 at
24 fps, metric units, and unit scale. The second Blender process reopens that
saved source, changes the mesh width to three meters and the animation endpoint
to X = 3, then overwrites the same GLB. Godot imports both versions in the same
project without clearing its import cache. A wrapper references the imported
scene and owns its own metadata and marker child.

## Observed result

Passed on 2026-10-23 on macOS arm64 with Blender **5.2.3 LTS**,
build `e13b728c6880`, and Godot **4.7.2**, build
`4.7.2.stable.official.ed1daf0bf`. These measurements describe this fixture and
these binaries. The [recorded output](result-2026-10-23.log) retains the engine
versions and checker observations from the passing run.

| Check | Initial import | Changed-source reimport |
| --- | --- | --- |
| Mesh bounds in Godot units | `2 × 2 × 2` | `3 × 2 × 2` |
| Initial global position | `0, 1, 0` | `0, 1, 0` |
| Object basis | Identity | Identity |
| `Slide` position tracks | 1 | 1 |
| GLB sampler time range | `1/24` to `25/24` seconds | Same |
| Imported first key | `0` seconds | `0` seconds |
| Imported last key and clip length | `1.04166662693024` seconds | Same |
| Animation endpoint | `2, 1, 0` | `3, 1, 0` |
| Wrapper metadata and marker | Preserved | Preserved |

The source motion spans one second. Its exported time origin is `1/24` second;
Godot adds the initial value at time zero and retains the endpoint at `25/24`.
The checker reads the GLB JSON sampler accessors separately from the imported
animation keys and samples the endpoint at `clip.length`. The wrapper file also
remained byte-identical across both imports.

Blender came from the
[official 5.2.3 macOS arm64 disk image](https://download.blender.org/release/Blender5.2/blender-5.2.3-macos-arm64.dmg),
verified against the
[official SHA-256 manifest](https://download.blender.org/release/Blender5.2/blender-5.2.3.sha256):

```text
acc05374485a272342d4b323c15ac01953e7f697da2f1bad8af9c3bf087267a4
```

The image was mounted read-only for the run and detached afterward. No global
Blender installation changed.

This headless check covers one unrigged mesh and one translation animation.
Visual appearance, materials, textures, rigs, collision generation, direct
`.blend` import, and exported-game behavior were not checked. No model or harness
quality was evaluated.
