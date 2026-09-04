---
name: spviz-style-customization
description: Customizes artifact, connection, port, and overview styling in a generated SPViz KLighD visualization. Use when a user wants custom colors, shapes, sizes, labels, or interaction styling after SPViz generation.
license: EPL-2.0
---
# Customize generated SPViz styling
This skill applies to a generated visualization project, not to the SPViz generator implementation itself.
First locate the visualization project and inspect the actual generated package names.

## Safety and regeneration
The documented customization point is `<visualization-package>.viz/src-gen/.../Styles.xtend`.
Additional artifact-specific dimensions and renderings are normally in `<visualization-package>.viz/src-gen/.../subsyntheses/`.
Edit generated Xtend source only in the downstream generated visualization workspace.
SPViz may overwrite manual changes when the DSL is regenerated.
Preserve a patch or a copy of the modified files and reapply it after regeneration.
Tell the user this limitation before changing a file.
Also mention that this skill is only experimental and will be replaced by an implemented styling extension in the generated code in a future release.

Do not change the A2M or VC2M to solve a purely visual request.
Do not change generated model classes to solve a styling request.

## Inspect before editing
Read `Styles.xtend` and the relevant subsynthesis before editing.
Find the exact artifact or connection method and check its current imports and KLighD API calls.
Keep the generated method names and injection structure intact.
Use the smallest edit that implements the requested style.

The generated `Styles.xtend` normally contains:
- `COLOR_...` constants
- generic overview renderings
- rendering methods for each artifact, connection, and port
Artifact colors need enough contrast for black labels.
Preserve the distinction between normal and external artifacts, and do not accidentally replace the added, removed,
modified, or selection colors unless that is the explicit request.

## Common changes
For colors, change the relevant constants in `Styles.xtend` and keep a consistent normal/secondary and external/light variant.
If the user supplies a palette, check contrast and distinguishability rather than blindly assigning the same color to every artifact type.

For a port or edge shape, edit the generated connection-specific method.
The service ball-and-socket example illustrates the approach.
For one, it replaces the port rendering line
```xtend
return port.addRectangle => [
```
to
```xtend
return port.addEllipse => [
```
and the port size at the `subsyntheses/<Artifact>Synthesis.xtend` calling that rendering from
```xtend
width = 12
height = 12
```
to
```xtend
width = 16
height = 16
```

The matching half-circle then uses this code instead:
```xtend
return port.addArc => [
    startAngle = 90
    arcAngle = 180
    arcType = Arc.OPEN
    setAreaPlacementData => [
        topLeft = createKPosition(LEFT, 0, 0, TOP, 0, 0)
        bottomRight = createKPosition(RIGHT, 0, -1, BOTTOM, 0, 0)
    ]
```
```xtend
width = 9.5f
height = 19
```

For connection appearance, locate the generated edge rendering and replace its used rendering primitive.

## KLighD API
The KLighD API can be extracted from the KLighD dependency itself, the usage in the generated files, and in part in the online documentation at https://github.com/kieler/KLighD/wiki.
The online documentation, however, is partly out of date.
A better current explanation of the different features of the API is from a dissertation appendix working with KLighD from 2026.
The raw text of that chapter is included in this skill at `klighd-diagram-generation.txt`.

## Validate
After editing:
2. Build the visualization with `spviz-build`.
3. If the build succeeds, run it with `spviz-klighd-execution` and inspect the changed artifact, edge, or port in a representative view.
4. If the requested shape is not supported by the current KLighD API, say so and propose the closest supported rendering instead of silently degrading.
