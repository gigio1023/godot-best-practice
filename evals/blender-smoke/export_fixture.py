"""Create or update a fixed Blender source and export its selected mesh as GLB.

Run with Blender's bundled Python. The source lives outside the Godot project
so the smoke exercises explicit GLB import without also importing a .blend file.
"""

import argparse
from pathlib import Path
import sys

import bpy


def main() -> None:
    """Export the initial two-meter cube or reexport the edited source file."""
    parser: argparse.ArgumentParser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("stage", choices=("initial", "reimport"))
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    arguments: argparse.Namespace = parser.parse_args(sys.argv[sys.argv.index("--") + 1 :])
    source: Path = arguments.source.resolve()
    output: Path = arguments.output.resolve()

    if arguments.stage == "initial":
        bpy.ops.wm.read_factory_settings(use_empty=True)
        bpy.ops.mesh.primitive_cube_add(size=2.0, location=(0.0, 0.0, 1.0))
        bpy.context.object.name = "FixtureCube"
    else:
        bpy.ops.wm.open_mainfile(filepath=str(source))

    cube: bpy.types.Object = bpy.data.objects["FixtureCube"]
    if arguments.stage == "reimport":
        # Edit mesh data, leaving the object transform at unit scale.
        vertex: bpy.types.MeshVertex
        for vertex in cube.data.vertices:
            vertex.co.x *= 1.5

    endpoint_x: float = 2.0 if arguments.stage == "initial" else 3.0
    cube.location = (0.0, 0.0, 1.0)
    cube.keyframe_insert(data_path="location", frame=1)
    cube.location.x = endpoint_x
    cube.keyframe_insert(data_path="location", frame=25)
    cube.animation_data.action.name = "Slide"

    scene: bpy.types.Scene = bpy.context.scene
    scene.unit_settings.system = "METRIC"
    scene.unit_settings.scale_length = 1.0
    scene.render.fps = 24
    scene.render.fps_base = 1.0
    scene.frame_start = 1
    scene.frame_end = 25
    scene.frame_set(1)
    bpy.ops.object.select_all(action="DESELECT")
    cube.select_set(True)
    bpy.context.view_layer.objects.active = cube
    bpy.ops.wm.save_as_mainfile(filepath=str(source))
    bpy.ops.export_scene.gltf(
        filepath=str(output),
        export_format="GLB",
        use_selection=True,
        export_yup=True,
        export_animations=True,
        export_animation_mode="ACTIONS",
        export_frame_range=True,
    )
    print(
        f"EXPORTED stage={arguments.stage} dimensions={tuple(cube.dimensions)} "
        f"endpoint_x={endpoint_x} frames=1..25 fps=24"
    )


if __name__ == "__main__":
    main()
