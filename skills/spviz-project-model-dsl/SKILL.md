---
name: spviz-project-model-dsl
description: Authors concrete SPViz project model instances in a generated model DSL, including artifacts, external markers, containments, connections, and labels. Use when a user wants to write a project model manually or describe a target architecture for comparison, not for designing the architecture metamodel DSL.
license: EPL-2.0
---

## Inspect the generated language first
Ask for or infer:
- the source `.spvizmodel` or the generated A2M model project
- the generated model-DSL project and its exact file extension
- whether this is for a current extracted model or a target design
- the artifact instances, containment hierarchy, connections, external-element policy, and any labels the user wants represented.

Read the generated grammar before writing instances.
It is an `.xtext` file normally under the generated `<a2m-package>.model.dsl` project and is produced from the A2M.
Use this generated grammar and its validation diagnostics.

## General syntax model
A concrete model normally has an optional project name followed by artifact instances.
An instance has an artifact-type keyword, a stable name, and an optional body.
The name is also the cross-reference identifier and is used to derive the generated `ecoreId`:

```
projectName "Example"

module "core" {
    components: ["api"]
    dependency "utilities" "runtime dependency"
}

module "utilities"
component "api"
```

This is an illustrative shape only.
Replace `module`, `components`, `dependency`, and `component` with the lower-case keywords generated from the actual A2M.

Use `external` before an artifact instance when it is a deliberately unresolved or
an element outside the analyzed project scope:
`external module "third-party"`

External artifacts are still real model nodes, they are only represented fainter and can be filtered.
They are not a way to suppress an unknown relationship.
Add them only when their identity is reliable and the requested view benefits from showing the boundary.

Containments are written in the generated containment feature as a type-specific list.
Connections use the generated connection keyword and cross-reference the target instance by name.
Direct connections can have an optional label.
Context labels belong in the generated `labels` block and must reference both endpoints.
Check the grammar instead of guessing punctuation, pluralization, or label placement.

## Modeling rules
1. Define each instance ID exactly once.
Use stable IDs that survive file reordering and revision comparison.
Do not use line numbers or traversal positions.
2. Make every cross-reference resolve to an instance of the target A2M type.
If an external target is needed, declare it explicitly rather than leaving a dangling name.
3. Match containment direction to the A2M.
If `Product contains Module` is declared, list the module in the product's generated containment feature, not in the module unless the generated grammar says otherwise.
4. Add each connection in the direction declared by the A2M.
5. Keep artifact names stable across model revisions when an element should be recognized as the same element by the difference visualization.
6. Use labels for source facts such as dependency scopes or cardinalities, not for styling or prose that belongs in documentation.
7. Do not duplicate containment entries and connections.
8. Keep large generated models in an extractor or build pipeline.
Use this DSL for manually maintained models, deliberate target architectures, and examples.

Do not infer a missing artifact type or relationship from the desired diagram.
If the A2M lacks it, return to `spviz-dsl-modeling` and decide whether the architecture metamodel should change.

## Workflow
1. Ensure the A2M and its model DSL have been generated without `--no-model-dsl`, or obtain the matching generated model-DSL project.
2. Read the generated grammar and identify the root rule and all artifact rules.
3. If necessary, build or regenerate the generated model-DSL project so its parser and validator are current.
4. Write the model to contain every required artifact, containment, and connection of the requested project or target architecture.
5. Check every reference, ID, external marker, and label against the A2M.
6. Validate the model against the `--validate` option of the generated language server jar.
7. Ask the user to confirm that the model is complete, iterate as needed.

## Hand-off
After completing the model DSL to the user's satisfaction, hand back to the previous context.
