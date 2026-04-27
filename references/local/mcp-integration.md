# Godot MCP Integration

Use this when the user asks whether Godot can be controlled through MCP, editor automation, viewport operations, or external Godot tooling.

## Position

MCP is useful, but it should not be the core source of truth for agent-assisted Godot authoring.

Preferred source of truth:

1. project files
2. semantic layout data
3. generator scripts
4. Godot CLI checks
5. screenshots/runtime evidence
6. MCP/editor state as optional convenience

## Good MCP uses

- inspect the running editor state
- run the project
- capture screenshots
- read console output
- select nodes for quick inspection
- trigger already-defined editor tools

## Bad MCP uses

- placing large scenes or UI by coordinate guessing
- making silent editor-only changes without files or generator source
- treating the viewport as the canonical representation
- relying on a third-party MCP server without fallback checks

## Security and reliability

Before installing or trusting a Godot MCP server:

- inspect source and permissions
- understand transport and exposed tools
- avoid exposing shell/file write tools unnecessarily
- keep editor automation scoped to the project
- preserve file-based completion evidence

## Known public examples

Public Godot MCP and skill examples exist, including:

- https://mcp.directory/skills/godot
- https://github.com/fernforestgames/agent-skill-godot
- https://github.com/bradypp/godot-mcp
- https://gdaimcp.com/docs

Do not copy their assumptions blindly. Some expect specific MCP servers or editor addons to be installed.

## Agent Rule

If MCP/editor automation changes the project, the agent still needs file diffs and Godot check commands. A successful editor operation is not enough evidence by itself.
