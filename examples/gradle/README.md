# Example for Java projects using built-in dependency analysis with Gradle
Most projects use build systems to define the project structure, dependencies, and the necessary processes to build, test, and do many other tasks easily automated.
Some of these build systems, such as Gradle and Maven in the Java world, are extensible and allow to have a look into the project structure, dependencies, etc. as a direct part of the build process,
thus making it easier to use that data for visualizations.

This example is just for Gradle dependencies, but can be combined with other hierarchies as shown in the other examples.
Here we do not parse the project files ourselves, but expect the Gradle build to produce `dependencies.json` files for each of its projects of the following form:

```json
{
    "groupId": <Group ID of the project, e.g.> "de.cau.cs.kieler.spviz.gradle",
    "artifactId": <Artifact ID of the project, e.g.> "de.cau.cs.kieler.spviz.gradle.model",
    "version": <Version of the project, e.g.> "0.1.0-SNAPSHOT",
    "configurations": [
        <List of Configurations>
    ]
```

with each configuration as:
```json
{
    "configuration": <Name of this configuration, e.g.> "compile",
    "dependencies": [
        <List of Dependencies>
    ]
}
```
and these Dependencies and the recursive ones as:
```json
{
    "groupId": <Group ID of the project, e.g.> "org.eclipse.emf",
    "artifactId": <Artifact ID of the project, e.g.> "org.eclipse.emf.ecore.xmi",
    "version": <Version of the project, e.g.> "2.16.0",
    "dependencies": [
        <List of Dependencies>
    ]
}
```

With this information we are able to display and connect the dependencies of any configuration:
multiple in combination, each in its own view, etc.
Files following this scheme can be extracted by adding this code to the main `build.gradle` file of the project and executing the build via `./gradlew printSolvedDepsTreeInJson`:

<details>
  <summary>Show code...</summary>

```groovy
subprojects {
	// Adapted from idea from cSn in https://stackoverflow.com/questions/36536561/is-there-a-way-to-list-all-gradle-dependencies-programmatically 
	task printSolvedDepsTreeInJson {
		doLast {
			def jsonOutput = "{\"groupId\": \"${project.group}\",\n"
			jsonOutput += "\"artifactId\": \"${project.name}\",\n"
			jsonOutput += "\"version\": \"${project.version}\",\n"
			jsonOutput += "\"configurations\": ["
			configurations.each { configuration ->
				if (!configuration.canBeResolved) {
					return
				}
				try {
					def configJson = "\n{"
                    configJson += "\"configuration\":\"${configuration.name}\",\n"
                    configJson += "\"dependencies\":["
                    configuration.resolvedConfiguration.firstLevelModuleDependencies.each { dep ->
                        def addToJson
                        addToJson = { resolvedDep ->
                            configJson += "\n{"
                            configJson += "\"groupId\":\"${resolvedDep.module.id.group}\",\n"
                            configJson += "\"artifactId\":\"${resolvedDep.module.id.name}\",\n"
                            configJson += "\"version\":\"${resolvedDep.module.id.version}\",\n"
                            configJson += "\"dependencies\":["

                            if (resolvedDep.children.size() != 0) {
                                resolvedDep.children.each { childResolvedDep ->
                                    if (resolvedDep in childResolvedDep.getParents()) {
                                        addToJson(childResolvedDep)
                                    }
                                }
                                if (configJson[-1] == ',') {
                                    configJson = configJson[0..-2]
                                }
                            }
                            configJson += "]},"
                        }
                        
                        addToJson(dep)
                    }
                    if (configJson[-1] == ',') {
                        configJson = configJson[0..-2]
                    }
                    configJson += "]},"
					jsonOutput += configJson
                } catch (Exception e) {
					return
				}

			}
			if (jsonOutput[-1] == ',') {
				jsonOutput = jsonOutput[0..-2]
			}
			jsonOutput += "]}"
			new File(projectDir, "dependencies.json").text = jsonOutput
			println "Saved output to 'dependencies.json'."
		}
	}

}
```
</details>

Using this with an open source project following this scheme was tested with the [Spring Boot](https://github.com/spring-projects/spring-boot) project.
This example just looks at the dependencies from the `compileClasspath` configuration, but could be easily extended/adapted for other configurations.

The `generate` project provides a command line tool using [Picocli](https://picocli.info/) to generate a `gradle` model from a source project. For this example, we expect the project to be structured using a Gradle build with some task for all subprojects to analyze following the description above.

# Using the example
Building the `.spvizmodel` and `.spviz` files in Eclipse will cause it to create/update projects for the gradle model and visualization. Importing the `generate` project next to that will allow you to use it and generate model files from your project.