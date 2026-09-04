---
name: spviz-klighd-execution
description: Runs a built SPViz visualization model with the KLighD CLI and serves it for browser-based inspection or local documentation. Use when a generated language-server jar and project model are available and the user wants to view its diagrams.
license: EPL-2.0
---
## Preconditions
Locate and verify:
- a shaded jar under `<visualization package>.language.server\target\`
- either an XMI project model whose extension is the lowercase A2M name, or a project-model DSL instance whose extension is the lowercase A2M name followed by `dsl`
- Java 21 if the language server needs to start locally
- the compatible KLighD CLI supplied by `spviz-cli-tools`

If the jar is missing, use `spviz-build`.
If the model is missing, use `spviz-model-generator` or `spviz-project-model-dsl`.

## Prefer `serve` with a browser canvas
Use this workflow when the host can open and inspect a browser canvas:

1. Select an unused local port, using `8000` when it is available.
2. Start KLighD as a persistent background process and capture its output:
`<klighd-cli> --ls_path <language-server.jar> --port <port> serve`
3. Wait for KLighD to print its base URL.
Forward a failure if the process fails.
4. Convert the model path to an absolute `file:///` URI.
Use forward slashes and percent-encode characters that are not safe in a query value.
Append it to the printed URL as `?source=<file-uri>`.
5. Verify that the resulting HTTP URL returns status 200, then open that same URL in the browser canvas.
6. Read the loaded page and verify that it renders the expected project name and the generated view names from the `.spviz` source after a few seconds of connection initialization.
Treat a generic page shell, an error model, or missing expected views as a failed load and report the visible error.

Keep the KLighD process running while the user inspects the diagram. Use a detached
process when the host would otherwise terminate background processes at the end of
the agent turn.

## Fall back to `open`
Use `open` only when the host cannot display or inspect a browser page:
`<klighd-cli> --ls_path <language-server.jar> open <model-file>`
The command starts a local server and opens the diagram in the system browser.
Keep the process running and ask the user to confirm the project name and expected views.
Do not use this fallback merely because browser verification requires another tool call.

## Serve local documentation
To serve diagrams embedded in local documentation, start the server without opening a specific model:
`klighd-win.exe --ls_path <language-server.jar> --port <port> serve`
Use iframe URLs with an absolute `file:///` source URI.
Keep the server running for as long as the documentation is being viewed.


## Handoff
Return to the previous context only after the diagram has loaded or the user has confirmed it has, depending on the workflow.