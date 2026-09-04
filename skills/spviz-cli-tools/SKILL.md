---
name: spviz-cli-tools
description: Provides SPViz and KLighD command-line tools for other SPViz skills without downloading a tool during each workflow.
license: EPL-2.0
---
# Use the bundled SPViz command-line tools
This is a support skill for other SPViz workflows.
Resolve the CLI tool paths relative to this skill file.

## Bundled tools
| Tool | Relative path | Platform |
| --- | --- | --- |
| SPViz CLI | `tools\spviz-cli.jar` | Java, cross-platform |
| KLighD CLI | `tools\klighd-win.exe` | Windows x64 |
| KLighD CLI | `tools\klighd-macos` | macOS x64 |
| KLighD CLI | `tools\klighd-linux` | Linux x64 |

## Platform handling

The SPViz jar can be used anywhere a compatible Java 21 or higher runtime is available.
The bundled KLighD executables are operating-system-specific, only use the one that matches the current platform.

## Handoff
Verify the required *absolute* tool path, return it to the calling context, and continue there.
