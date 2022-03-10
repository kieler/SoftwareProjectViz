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
import java.lang.System.Logger;
import java.util.Optional;

import de.cau.cs.kieler.spviz.gradle.model.GradleProject;

/**
 * The model generator for Gradle projects.
 * 
 * @author nre
 */
public final class GradleModelDataGenerator {

	static final Logger LOGGER = System.getLogger(GradleModelDataGenerator.class.getName());

	
	/**
	 * Generates Gradle project data from a given project path. The generated Model
	 * will be returned and also saved in a file.
	 * 
	 * @param projectFilePath The path to the project root folder
	 * @param projectName     Descriptive name of the project
	 * @param save    if true, model file will be saved under target/projectName.gradle
	 * @return The generated Gradle project data.
	 */
	public static GradleProject generateData(final String projectFilePath, final String projectName, Optional<String> modelSaveFilePath) {

		final ReadProjectFiles reader = new ReadProjectFiles();
		LOGGER.log(System.Logger.Level.INFO, "Generating data for " + projectName);
		final GradleProject project = reader.generateData(new File(projectFilePath), projectName);
		
		if (modelSaveFilePath.isPresent()) {

			LOGGER.log(System.Logger.Level.INFO, "Saving data for " + projectName);
			final String fileName = projectName + ".gradle";
			try {
				GradleModelSaveAndLoadUtility.saveData(fileName, project, modelSaveFilePath.get());
			} catch (final IOException e) {
				LOGGER.log(System.Logger.Level.ERROR, "There was a Problem while saving.", e);
				e.printStackTrace();
			}
		}
		LOGGER.log(System.Logger.Level.INFO, "Finished");

		return project;
	}

}
