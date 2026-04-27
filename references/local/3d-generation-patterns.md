# 3D Generation Patterns

Use this reference when an AI agent needs to create or update Godot 3D layouts.

## Semantic layout data

Agents should not directly reason from raw coordinates alone. Store named objects and relationships.

Minimal layout shape:

```json
{
  "version": 1,
  "units": "meters",
  "landmarks": [
    {
      "id": "hub",
      "label": "Hub",
      "position": [24, 0, 0],
      "size": [10, 4, 8],
      "anchors": {
        "front_door": [24, 0, -5],
        "service_counter": [24, 0, -1],
        "waiting_area": [29, 0, 2]
      }
    }
  ],
  "routes": [
    {
      "id": "hub_loop",
      "points": ["hub.front_door", "hub.service_counter", "hub.waiting_area"]
    }
  ],
  "interaction_zones": [
    {
      "id": "hub_service_zone",
      "kind": "interaction",
      "anchor": "hub.service_counter",
      "radius": 2.5
    }
  ]
}
```

## Node naming

Use stable, semantic names:

- `Landmark_Hub`
- `Anchor_Hub_ServiceCounter`
- `Zone_Hub_Service`
- `Route_HubLoop`
- `Actor_Guide_A`

This improves agent inspection, screenshot debugging, and MCP/editor automation if added later.

## Navigation

Use `NavigationRegion3D` and `NavigationAgent3D` for actor movement. Keep generated layouts small enough that navigation can be inspected visually before scaling up.

Validation cameras should include:

- whole-map orthographic/debug view
- player-height view at each landmark
- route-specific camera for path checks

## Collision

Start with simple shapes:

- `BoxShape3D` for walls, desks, kiosks, signs
- `CylinderShape3D` for posts or circular zones
- avoid complex concave collision on early generated assets

## Interaction readability

For interaction-heavy 3D layouts, the world must make these readable:

- line of sight or proximity relationships
- queue/order expectations when relevant
- public vs formal spaces
- guided paths
- interaction points
- text surfaces that expose rules or consequences

Visual polish is secondary until these relations are readable.

## Generated assets

For first playable slices, generate proxy geometry:

- colored boxes for buildings
- simple text labels using `Label3D`
- simple desk/counter meshes
- route markers in debug-only groups

Replace with imported glTF assets after gameplay validation.
