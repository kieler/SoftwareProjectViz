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

package de.cau.cs.kieler.spviz.yarnInversify.generate;

import java.io.File;
import java.io.IOException;
import java.lang.System.Logger;
import java.util.Optional;

import de.cau.cs.kieler.spviz.yarnInversify.model.YarnInversifyProject;

/**
 * The model generator for YarnInversify projects.
 * 
 * @author nre
 */
public final class YarnInversifyModelDataGenerator {

	static final Logger LOGGER = System.getLogger(YarnInversifyModelDataGenerator.class.getName());

	
	/**
	 * Generates YarnInversify project data from a given project path. The generated Model
	 * will be returned and also saved in a file.
	 * 
	 * @param projectFilePath The path to the project root folder
	 * @param projectName     Descriptive name of the project
	 * @param save    if true, model file will be saved under target/projectName.yarninversify
	 * @return The generated YarnInversify project data.
	 */
	public static YarnInversifyProject generateData(final String projectFilePath, final String projectName, Optional<String> modelSaveFilePath) {

		final ReadProjectFiles reader = new ReadProjectFiles();
		LOGGER.log(System.Logger.Level.INFO, "Generating data for " + projectName);
		final YarnInversifyProject project = reader.generateData(new File(projectFilePath), projectName);
		
		if (modelSaveFilePath.isPresent()) {

			LOGGER.log(System.Logger.Level.INFO, "Saving data for " + projectName);
			final String fileName = projectName + ".yarninversify";
			try {
				YarnInversifyModelSaveAndLoadUtility.saveData(fileName, project, modelSaveFilePath.get());
			} catch (final IOException e) {
				LOGGER.log(System.Logger.Level.ERROR, "There was a Problem while saving.", e);
				e.printStackTrace();
			}
		}
		LOGGER.log(System.Logger.Level.INFO, "Finished");

		return project;
	}

}
