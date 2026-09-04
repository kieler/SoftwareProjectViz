---
name: spviz-model-generator
description: Completes the generated SPViz project model generator by inspecting a repository or following a user-supplied source description, extracting artifacts, containments, and connections, and producing a usable model generator. Use when a `.generate` scaffold or `ReadProjectFiles.java` needs implementation and the user asks to complete it.
license: EPL-2.0
---

# Implement a project model generator
The generated `.generate` project is the bridge between a real repository and the generated visualization.
This skill owns the extractor, not the A2M/VC2M design.

## Required intake
Ask for the source repository path and the intended model output location if ambiguous.
When the source contains multiple possible representations, inspect them first, recommend the most machine-readable source, and ask which facts should be parsed.
If the user provided a prose description, ask how each described artifact and relationship is represented in the repository.

Before coding, read:
- the generated `ReadProjectFiles.java` checklist and helper methods
- the generated `<a2m-package>.model` package and its `*Project` root
- the generated `ModelUtil.java` in the `<a2m-package>.model.util` package
- `ConfigAndExecuteCli.java`, `*ModelDataGenerator.java`, and the save/load utility
- if available, a structurally similar example in `https://github.com/kieler/SoftwareProjectViz-examples`
Do not treat the examples as production-ready code, re-check their behavior against the requirements for this project, and do not copy them blindly.

Inspect the A2M again.
Every checklist item corresponds to an artifact extraction, containment, or connection requirement.
Do not implement only the visually interesting part and leave the rest of the model structurally inconsistent.

## Choose facts for data extraction
Prefer machine-readable facts already produced by the project's build or analysis tools.
If unsure about anything, ask the user to provide information or decide on a policy for how to handle it.
Do not guess or invent relationships.

Record a small extraction contract before editing that covers artifact identity, source files, containment rules, connection rules, and the external/unresolved policy.
This makes failures distinguishable from an empty but successful run.

## Implement in stages
1. Validate the root path and initialize the generated project root with its descriptive project name.
2. Scan and parse source files.
Also identify if the build system or other tools can provide additional facts, requiring the generator to run during the build or using build artifacts.
Verify with the user if such additional facts are needed for the requested views.
Register every artifact with a stable key before resolving references.
The generated `createOrFind<Type>` helpers and per-type maps are intended for this purpose.
3. Set each artifact's display name and a stable ASCII-safe `ecoreId`.
Reuse the generated `toAscii` helper or an equivalent deterministic normalization.
Do not use a traversal index as the identity.
4. Set `external` deliberately.
A source artifact known to belong to the analyzed repository is normally internal; an unresolved dependency stub can be external.
The scaffold's `createOrFind<Type>` helpers initialize new artifacts as external, so explicitly set `external` to `false` for artifacts found in the analyzed repository.
Preserve the user's policy for whether external stubs should be visible.
5. Attach containment relations to the generated parent lists.
6. Attach connections after all possible targets have been registered.
Use the exact generated bidirectional getter or the generated `ModelUtil.add<Connection>` helper after inspecting its signature.
Do not manipulate unrelated EMF implementation classes.
7. Add labels only when the source supplies meaningful labels.
For a global label, use `ModelUtil.add<Connection>(source, target, label)`.
For a context-specific label, use `ModelUtil.add<Connection>InContext(source, target, context, label)`, where both endpoints must be contained by `context`.
8. Validate required artifacts and relationships, then return the project.

Create unresolved external stubs only when that is useful for the requested views and the identity is sufficiently reliable.
If a reference cannot be resolved or parsed, log the path and relationship and fail or report it according to the agreed extraction contract.
Do not silently drop edges or convert malformed input into a success-shaped empty model.

The generated `ReadProjectFiles.java` is the intended manual extension point.
The generator intentionally leaves an existing `.generate` directory untouched.
Do not delete it to regenerate the scaffold without first backing up manual changes.

## CLI and output
The generated launcher uses command line options:
| option | parameter |
| --- | --- |
| -N, --names | project-key=display-name |
| -P, --paths | project-key=path-to-project |
| -S, -O, --output | directory for the generated model |

The exact executable name is derived from the A2M name.
After building the generator, locate the shaded jar rather than assuming its filename:
`java -jar <a2m-package>.generate/target/<generator>-shaded.jar -N project=Project -P project=/path/to/repository -S /path/to/models`

## Verify the extractor
Ask the user or infer from the context to verify the extractor on the requested project. Check:
- every intended artifact type has a sensible count
- containments have the correct parent and no duplicate children
- connections resolve to the intended direction and target
- external artifacts follow the agreed policy
- stable IDs do not collide
- the generated model verifies with the generated language server jar's `--validate` option

## Handoff
Suggest building the generator with `spviz-build`, then run it and continue with `spviz-klighd-execution`.
If that succeeds, return to the previous context.
