# Examples

Here you can find some example files and generators for projects. In each folder there are `.spvizmodel` and `.spviz` files to define the project and visualization models, respectively.
Load these up in your Eclipse to let the SPViz generator generate the model and visualization Java projects automatically.
See the example's readmes for further information.

These examples try to show what can be visualized in a simple way using the Software Project Visualization. This includes direct dependencies between artifacts such as Java modules via Maven (see the [springdi example](https://github.com/kieler/SoftwareProjectViz/tree/main/examples/springDI)), [OSGi](https://github.com/kieler/SoftwareProjectViz/tree/main/examples/osgi), or Gradle, either analyzed directly in the generator or by the build tool (example to be added). Also other connections can be shown, such as class hierarchies, method calls, component wiring via dependency injection, etc. Not only for Java, but for any language or use case you choose and where such relations can be extracted conveniently in a generator analyzing the code base.