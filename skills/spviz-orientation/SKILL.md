---
name: spviz-orientation
description: Helps users understand SPViz, choose an installed SPViz workflow, and clarify an ambiguous goal before another SPViz skill starts work.
license: EPL-2.0
---

# Orient a user to SPViz
Use this skill only when the user asks what SPViz can do, asks which workflow to use,
or has not provided enough information to select another installed SPViz skill.
Do not use it as an extra intake step when the user's goal and relevant paths are
already clear.

## First response
Start with a brief, task-specific introduction and link to the SPViz documentation for further information: `https://github.com/kieler/SoftwareProjectViz/wiki`

## Select a workflow
Inspect the frontmatter of the SPViz skills that are currently installed.
Treat that frontmatter as the routing catalog.
The following skills should be available, report any missing skills to the user and suggest they install them if relevant:
- `spviz-orientation`
- `spviz-cli-tools`
- `spviz-dsl-modeling`
- `spviz-model-generator`
- `spviz-build`
- `spviz-klighd-execution`
- `spviz-project-model-dsl`
- `spviz-difference-visualization`
- `spviz-style-customization`
- `spviz-troubleshooting`

If the goal is ambiguous, ask one focused question at a time with the host's
interactive question mechanism. Once a skill matches the goal, hand off to it and
ask only for information that skill still needs.

## Explain the workflow accurately
SPViz generates graph-based software architecture visualizations from two input DSLs:

- `.spvizmodel`: an architecture metamodel (A2M) containing artifact types, containments, and connections.
- `.spviz`: a view context metamodel (VC2M) importing the A2M and defining abstract views.

The CLI generates Java/EMF/Xtend projects, a project model generator scaffold, a
KLighD synthesis, a language server, DSL support, and Maven build configuration.
Using the generated code as a visualization tool requires a project model.
That model can come from the completed Java generator template,
another extractor that emits a supported model format, or the generated project model DSL.

Prose can guide A2M and VC2M design, but it does not replace extracting source facts
into a project model.
SPViz is suitable for artifacts and relationships that are naturally shown as a
graph, including dependency hierarchies, containment, service/DI relationships, and selected runtime relations when a data extractor provides them.
It is not a general chart or table generator.

## When to stop
If the requested task falls outside the installed SPViz workflows, explain that boundary and do not pretend that SPViz supports it.
In that case, stop this skill.
