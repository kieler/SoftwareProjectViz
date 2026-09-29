---
name: spviz-style-customization
description: Customizes artifact, connection, port, and overview styling in a generated SPViz KLighD visualization. Use when a user wants custom colors, shapes, sizes, labels, or interaction styling after SPViz generation.
license: EPL-2.0
---
# Customize generated SPViz styling
This skill applies to a generated visualization project, not to the SPViz generator implementation itself.
First locate the visualization project and inspect the actual generated package names.

## Customization point
The generated `src-gen/<package-path>/viz/Styles.xtend` implements the complete default appearance, and a customized subclass can be registered through Guice.
Do not edit `src-gen`, which is replaced on regeneration.
Do not change the A2M or VC2M to solve a purely visual request.
Do not change generated model classes to solve a styling request.

## Inspect before editing
Read `Styles.xtend` to find the generated artifact/connection method signatures and overridable color getters.
Find the exact artifact or connection method and check its current imports and KLighD API calls.
Keep the generated method names and injection structure intact.
Use the smallest edit that implements the requested style.

The generated `Styles.xtend` normally contains:
- `COLOR_...` constants
- generic overview renderings
- rendering methods for each artifact, connection, and port
Artifact colors need enough contrast against labels, which are black by default.
Preserve the distinction between normal and external artifacts, and do not accidentally replace the added, removed,
modified, or selection colors unless that is the explicit request.

## Common changes
For any changes, overwrite the relevant methods from `src-gen/<package-path>/viz/Styles.xtend` in a custom subclass in `src`.
Then create `<visualization-package>.viz/META-INF/services/<visualization-package>.viz.Styles` containing the subclass's fully qualified name on one line.

For colors, keep a consistent normal/secondary and external/light variant.
If the user supplies a palette, check contrast and distinguishability rather than blindly assigning the same color to every artifact type.

For a port or edge shape, edit the generated connection-specific method.
The service ball-and-socket example illustrates the approach.
It overrides each generated connection-specific `...PortShape(KPort)` method and its width and height getters in the subclass.
```xtend
override KContainerRendering addConnectedSourceConnectsTargetNamedConnectionPortShape(KPort port) {
    port.addEllipse
}

override float getConnectedSourceConnectsTargetNamedConnectionPortWidth() { 16f }
override float getConnectedSourceConnectsTargetNamedConnectionPortHeight() { 16f }

override KContainerRendering addConnectingSourceConnectsTargetNamedConnectionPortShape(KPort port) {
    port.addArc => [
        startAngle = 90
        arcAngle = 180
        arcType = Arc.OPEN
        setAreaPlacementData => [
            topLeft = createKPosition(LEFT, 0, 0, TOP, 0, 0)
            bottomRight = createKPosition(RIGHT, 0, -1, BOTTOM, 0, 0)
        ]
    ]
}

override float getConnectingSourceConnectsTargetNamedConnectionPortWidth() { 9.5f }
override float getConnectingSourceConnectsTargetNamedConnectionPortHeight() { 19f }
```
Use the KLighD imports and extension imports required by these types and rendering calls.
This change will look like a ball (16x16 ellipse) for one port and a slightly larger socket (9.5x19 half-circle arc) for the other port.
Use different Source/Target/Connection names depending on where the change should be applied.

For connection appearance, locate the related edge rendering and overwrite its used rendering primitive.

## KLighD API
The KLighD API can be extracted from the KLighD dependency itself, the usage in the generated files, and in part in the online documentation at https://github.com/kieler/KLighD/wiki.
The online documentation, however, is partly out of date.
A better current explanation of the different features of the API is from a dissertation appendix working with KLighD from 2026.
The raw text of that chapter is included in this skill at `klighd-diagram-generation.txt`.

## Validate
After editing:
1. Build the visualization with `spviz-build`.
2. If the build succeeds, run it with `spviz-klighd-execution` and inspect the changed artifact, edge, or port in a representative view.
3. If the requested shape is not supported by the current KLighD API, say so and propose the closest supported rendering instead of silently degrading.
