package de.cau.cs.kieler.spviz.gradle.generate.json;

import java.util.List;

/**
 * Simple class for parsing Json data of Gradle projects via Gson.
 * 
 * @author nre
 */
public class JsonProject {
	public String groupId;
	public String artifactId;
	public String version;
	public List<JsonConfiguration> configurations;
}
