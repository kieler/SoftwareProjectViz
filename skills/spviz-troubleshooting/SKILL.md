---
name: spviz-troubleshooting
description: Diagnoses failures *specific to SPViz*, regarding its DSLs, code generation, generated project models, generated language servers, and generated visualization compatibility. Use when an SPViz-specific stage fails or the failing SPViz stage is unclear, but do not use for generic operating-system, network, Java, or Maven issues.
license: EPL-2.0
---
# Troubleshoot the SPViz toolchain
Use this skill to isolate the failing stage before changing files or repeating a build.
Do not hide errors behind broad retries or silent fallbacks.

## Tool availability
Use `spviz-cli-tools` first.
It owns the SPViz CLI, the KLighD CLI, and deterministic path selection.

If a bundled file is missing, mismatched, or incompatible, report the exact failure.
Do not silently download a replacement.
Ask before using an explicitly supplied tool or obtaining a release asset as a fallback.

## `.spvizmodel` or `.spviz` errors
Check the errors against the corresponding `.xtext` grammar files contained in this skill and check:
- the `.spviz` file (the VC2M) imports the intended `.spvizmodel` file (the A2M)
- every qualified artifact and connection name exists in the A2M
- containment chains in artifact views match declared containments
- category connections have the required inner view and category data
- identifiers do not collide with generated Java/EMF names

### CLI project generation
The SPViz CLI logs most common errors and explains the most likely error.
Start with the reported errors and the CLI diagnostics.
If no error is reported, inspect the output tree for the expected
`<a2m-package>.model`, `<a2m-package>.generate`, visualization model/viz,
language-server, build, and optional model/diff DSL projects.
To clarify, call `java -jar <path-to-spviz-cli.jar> --help` for descriptions of the CLI options.
If the bundled CLI is unavailable or invalid, diagnose it through `spviz-cli-tools`
before asking the user for an alternative.

## Maven and Java failures
Check Java and Maven:

```
java -version
mvn -version
```

Generated projects target Java 21 and use Maven 3.9.
Use Java 21 unless the generated project's documentation explicitly establishes compatibility with a newer JDK.
On Windows, use `mvn.cmd` when `mvn` is not available.

The compilation may fail due to stale sources in the generated packages, because SPViz does not clean the target directory.
Artifacts or views removed from the A2M or VC2M can remain in generated projects and cause build errors.
Prefer a new, empty output directory.
Before deleting obsolete generated files, preserve manual changes, especially completed `.generate` implementations.

Never edit `*-gen`, `xtend-gen`, generated Java, or generated EMF implementation files
to fix a source problem. Change the DSL or supported source customization point and
regenerate.

## Generator and model failures
For a completed `.generate` project, inspect `ReadProjectFiles.java`. Check:

- the source root exists and is the intended repository
- stable ASCII-safe IDs are unique
- connections use the declared source-to-target direction
- the saved model can be loaded by the generated model code.

An empty diagram commonly means the extractor returned an empty or erroneous model, not that the visualization failed.
Unexpected output, such as an error model shown alongside an error message, can indicate a known problem:
- "emf.ecore.xmi.FeatureNotFoundException" may be thrown if the project model was generated with an older version of the A2M
- if the diagram shows a tree rooted at a node called `<architecture-name>Project`, it likely uses the `EObjectFallbackSynthesis` instead of the generated synthesis, so prompt the user to change that in the diagram view's "General" panel, if it is available in the "Current synthesis" dropdown.

For a concrete model DSL parse failure, read and check against the generated grammar.
Use `spviz-project-model-dsl` rather than modifying generated DSL output to fix model DSL errors.

## Language-server and KLighD failures
Make sure to use the correct executables. Locate the shaded jar under:
```
<visualization package>.language.server\target\
```

Verify that the KLighD CLI executable is version 0.8.1 or later:

```
# Use the verified bundled executable name, for example:
klighd-win.exe --help
klighd-win.exe --version
```
For most consistent results, use the `--ls_path` option to point to the language-server jar.

## Eclipse failures
For unresolved generated bundles, prompt the user to activate or reload
`spviz.build\de.cau.cs.kieler.spviz.targetplatform\de.cau.cs.kieler.spviz.targetplatform.target`
and to clean and automatically build the generated projects (Project->Clean...->Select generated bundles->Clean) and run Maven->Update Project on all projects.

## Stop conditions and handoff
Stop this skill if the diagnostics options from this skill are exhausted.
Ask the user for input when any part is ambiguous.
Use your own reasoning for further troubleshooting and route to:

- `spviz-dsl-modeling` for an incorrect A2M/VC2M design
- `spviz-project-model-dsl` for concrete project model syntax
- `spviz-model-generator` for extraction logic
- `spviz-build` for a normal build/package workflow
- `spviz-cli-tools` for a missing, mismatched, or incompatible bundled CLI
- `spviz-klighd-execution` for a ready language-server/project model pair
- `spviz-eclipse-integration` for P2, target-platform, or runtime Eclipse work
