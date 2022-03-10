/*
 * SPViz - Kieler Software Project Visualization for Projects
 * 
 * A part of Kieler
 * https://github.com/kieler
 * 
 * Copyright 2022 by
 * + Christian-Albrechts-University of Kiel
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 */
package de.cau.cs.kieler.spviz.gradle.generate;

import java.io.File;
import java.io.IOException;
import java.lang.System.Logger.Level;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import de.cau.cs.kieler.spviz.gradle.generate.json.JsonConfiguration;
import de.cau.cs.kieler.spviz.gradle.generate.json.JsonDependency;
import de.cau.cs.kieler.spviz.gradle.generate.json.JsonProject;
import de.cau.cs.kieler.spviz.gradle.model.GradleFactory;
import de.cau.cs.kieler.spviz.gradle.model.GradleProject;
import de.cau.cs.kieler.spviz.gradle.model.Project;

/**
 * This class reads all the data for Gradle projects from the {@code dependencies.json} files. The
 * schema of these files should follow as described in the README.md.
 *
 * @author nre
 */
public class ReadProjectFiles {

	static final java.lang.System.Logger LOGGER = System.getLogger(GradleModelDataGenerator.class.getName());

	final GradleProject gradleProject = GradleFactory.eINSTANCE.createGradleProject();

	private final HashMap<String, Project> projects = new HashMap<>();


	/**
	 * Generates the HashMaps with data for projects.
	 *
	 * @param projectPath to extract project data from
	 * @return GradleProject with all project artifacts
	 */
	public GradleProject generateData(final File projectPath, final String projectName) {
		gradleProject.setProjectName(projectName);
		
		// Parsing of dependencies.json files for project and dependency data.
		final List<Path> dependenciesFilePaths = new ArrayList<Path>();
		findFiles(StaticVariables.DEPENDENCIES_FILE, projectPath, dependenciesFilePaths);
		for (final Path dependenciesPath : dependenciesFilePaths) {
			parseDependenciesFile(dependenciesPath);
		}
		
		return gradleProject;

	}
	
	private void parseDependenciesFile(Path dependenciesPath) {
		try {
			JsonProject jsonProject = ReadProjectFilesUtility.readFileToJson(dependenciesPath);
			
			// Create or update a model project for this dependencies file
			final String name = jsonProject.groupId + ":" + jsonProject.artifactId;
			final Project project = createOrFindProject(name);
			project.setExternal(false);
			for (JsonConfiguration configuration : jsonProject.configurations) {
				if (!configuration.configuration.equals("compileClasspath")) {
					// We could also have a look at other configurations, this example however only
					// looks at the "compileClasspath" configuration.
					continue;
				}
				addDependencies(project, configuration.dependencies);
			}
		} catch (IOException e) {
			LOGGER.log(Level.ERROR, "Could not parse dependencies.json: " + dependenciesPath.toString());
		}
	}
	
	private void addDependencies(Project project, List<JsonDependency> dependencies) {
		for (JsonDependency dependency : dependencies) {
			final String name = dependency.groupId + ":" + dependency.artifactId;
			final Project depProject = createOrFindProject(name);
			if (!project.getConnectedDependencyProjects().contains(depProject)) {
				project.getConnectedDependencyProjects().add(depProject);
			}
			addDependencies(depProject, dependency.dependencies);
		}
	}

	/**
	 * Return the project with the given name. If it was generated before, return that, or else return a new one.
	 * The {@code name} and {@code ecoreId} of the module are pre-set.
	 * 
	 * @param name The identifying name of the project ([groupId].[artifactId])
	 * @return The (possibly newly created) project.
	 */
	private Project createOrFindProject(String name) {
		if (projects.containsKey(name)) {
			return projects.get(name);
		} else {
			// Create a new model and set it up
			final Project project = GradleFactory.eINSTANCE.createProject();
			project.setName(name);
			project.setEcoreId(StaticVariables.PROJECT_PREFIX + toAscii(name));
			project.setExternal(true);
			projects.put(name, project);
			gradleProject.getProjects().add(project);
			return project;
		}
	}

	/**
	 * Finds all files in a directory and all its sub-directories. Adds the path to
	 * the files to the <em>accumulator</em>
	 *
	 * @param name Filename extension/ending to search for
	 * @param file Path to search in
	 * @param accumulator The list to accumulate the found paths in.
	 */
	private void findFiles(final String name, final File file, final List<Path> accumulator) {
		final File[] list = file.listFiles();

		if (list != null) {
			for (final File fil : list) {
				if (fil.isDirectory()) {
					// Ignore /target directories.
					if (!fil.getPath().endsWith(File.separator + "target")) {
						findFiles(name, fil, accumulator);
					}
				} else if (fil.getName().endsWith(name)) {
					Path filePath = Paths.get(fil.getPath());
					accumulator.add(filePath);
				}
			}
		}
	}

	/**
	 * Converts the given name to an ACII string save for using in an Ecore ID.
	 * German umlauts are converted to their long form counterparts (e.g., ä->ae)
	 * and special characters not in the alphabet are replaced by underscores (_).
	 * 
	 * @param name The name to convert to an ASCII string
	 * @return An ASCII-only version of the string.
	 */
	private String toAscii(String name) {
		Map<Character, String> mappings = new HashMap<>();
		mappings.put('Ä', "Ae");
		mappings.put('ä', "ae");
		mappings.put('Ö', "Oe");
		mappings.put('ö', "oe");
		mappings.put('Ü', "Ue");
		mappings.put('ü', "ue");
		mappings.put('ẞ', "Ss");
		mappings.put('ß', "ss");
		
		StringBuilder sb = new StringBuilder();
		name.chars().forEachOrdered((int character) -> {
			// Replace all known mappings to readable allowable ID substrings
			if (mappings.containsKey((char) character)) {
				sb.append(mappings.get((char) character));
			// Keep all A-Z,a-z and .- the same.
			} else if (character >= 'A' && character <= 'Z' || character >= 'a' && character <= 'z' || character == '.' || character == '-') {
				sb.append((char) character);
			// Replace all other characters by _
			} else {
				sb.append('_');
			}
		});
		
		return sb.toString();
	}

}
