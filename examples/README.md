# Examples

Here you can find some example files and generators for projects. In each folder there are `.spvizmodel` and `.spviz` files to define the project and visualization models, respectively.
Load these up in your Eclipse to let the SPViz generator generate the model and visualization Java projects automatically.
See the example's readmes for further information.

These examples try to show what can be visualized in a simple way using the Software Project Visualization. This includes direct dependencies between artifacts such as Java modules via Maven (see the [springdi example](https://github.com/kieler/SoftwareProjectViz/tree/main/examples/springDI)), [OSGi](https://github.com/kieler/SoftwareProjectViz/tree/main/examples/osgi), or [Gradle](https://github.com/kieler/SoftwareProjectViz/tree/main/examples/gradle), either analyzed directly in the generator or by the build tool. Also other connections can be shown, such as class hierarchies, method calls, component wiring via dependency injection, etc. Not only for Java, but for any language or use case you choose and where such relations can be extracted conveniently in a generator analyzing the code base, as for example in the [yarnInversify example](https://github.com/kieler/SoftwareProjectViz/tree/main/examples/yarnInversify).

## Using Maven to handle the generated artifacts
After building the `.spvizmodel` and `.spviz` files in your Eclipse and letting the project generate all the model and visualization artifacts for you, you can use these artifacts directly in your Eclipse.
You can also use Maven to build the artifacts, connect the example generators in the sub-folders here to it and build a language server with KLighD diagrams for your project architecture visualization.
To connect the example project's Maven builds to the generated model artifacts, you first have to call `mvn install` on the generated visualization's `.build` folder to install the artifacts in your local `.m2` repository, then call Maven in the example `.generate` folders.
This will create a shaded `jar` you can execute to generate your model.
