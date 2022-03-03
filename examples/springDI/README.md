# Example for Java projects using dependency injection via Spring
This example configuration combines two kinds of connections that may occur within Java projects&mdash;dependencies between modules and requirements and providings of services between classes via dependency injection.

The `generate` project provides a command line tool using [Picocli](https://picocli.info/) to generate a `springdi` model from a source project. For this example, we expect the project to be structured into:

- `pom.xml` files defining Maven artifacts. Here we expect artifacts to be `pom.xml` files with no parent module, but child modules defining the contents of this artifact.
- `pom.xml` files defining Maven modules, referenced by an artifact `pom.xml`. The dependencies are expected to be defined in the `<dependencies>` tag of the modules.
- Java source files using dependency injection. Here component interfaces, implementations and other classes are identified to be part of the dependency injections for the following reasons:
    - interfaces are component interfaces
    - classes with the `@Named` annotation are component implementations for the interface they implement
    - interfaces, components or other classes are identified to require a component interface if they have fields or methods with parameters, that have an `@Inject` annotation.


# Using the example
Building the `.spvizmodel` and `.spviz` files in Eclipse will cause it to create/update projects for the springdi model and visualization. Importing the `generate` project next to that will allow you to use it and generate model files from your project.