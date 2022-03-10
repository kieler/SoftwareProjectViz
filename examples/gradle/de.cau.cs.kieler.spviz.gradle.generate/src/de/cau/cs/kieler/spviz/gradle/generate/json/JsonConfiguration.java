package de.cau.cs.kieler.spviz.gradle.generate.json;

import java.util.List;

/**
 * Simple class for parsing Json data of Gradle configurations via Gson.
 * 
 * @author nre
 */
public class JsonConfiguration {
	public String configuration;
	public List<JsonDependency> dependencies;
}
