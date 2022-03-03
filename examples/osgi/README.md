# Example for Java projects using the OSGi Service Framework
This example configuration combines two kinds of connections that may occur within Java projects&mdash;dependencies between plug-ins and requirements and providings of services between classes via OSGi services.

The `generate` project provides a command line tool using [Picocli](https://picocli.info/) to generate a `osgi` model from a source project. For this example, we expect the project to be structured into:

- `.product` files defining OSGi products. Products are expected to consist of a list of features contained.
- `.feature` files defining OSGi features. Features are expected to consist of a list of bundles or plugins contained.
- `META-INF/MANIFEST.MF` files defining OSGi bundles. From it the required bundles and packages are extracted.
- `OSGI-INF/*.xml` files next to the bundle information defining all service components, provided interfaces, and implementing classes.

This example replicates large parts of the behavior of [osgiviz](https://www.github.com/kieler/osgiviz)

# Using the example
Building the `.spvizmodel` and `.spviz` files in Eclipse will cause it to create/update projects for the osgi model and visualization. Importing the `generate` project next to that will allow you to use it and generate model files from your project.

This configuration can be used for example for most Java projects here in the [KIELER](https://github.com/kieler) software project using OSGi bundling, the [example OSGi project](https://github.com/kieler/osgiviz/tree/master/examples/languagedemo) for OSGiViz, or any other Java project using manifest-first dependency handling and optional OSGi service handling.