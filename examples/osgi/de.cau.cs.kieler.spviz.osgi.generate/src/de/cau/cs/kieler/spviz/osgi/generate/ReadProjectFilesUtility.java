// ******************************************************************************
//
// Copyright (c) 2018-2021 by
// Scheidt & Bachmann System Technik GmbH, 24145 Kiel
//
// This program and the accompanying materials are made available under the
// terms of the Eclipse Public License 2.0 which is available at
// http://www.eclipse.org/legal/epl-2.0.
// 
// SPDX-License-Identifier: EPL-2.0
//
// ******************************************************************************

package de.cau.cs.kieler.spviz.osgi.generate;

import java.io.IOException;
import java.lang.System.Logger;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Comparator;

import de.cau.cs.kieler.spviz.osgi.model.Bundle;
import de.cau.cs.kieler.spviz.osgi.model.OSGiProject;

/**
 * This is a utility class for {@linkplain ReadProjectFiles} with methods for
 * reading and parsing files.
 *
 * @author dams
 *
 */

public class ReadProjectFilesUtility {
	static final Logger LOGGER = System.getLogger(ReadProjectFilesUtility.class.getName());

	/**
	 * Reads file content into a string.
	 *
	 * @param filePath
	 * @param logger
	 * @return returns a String with the file content of the input file.
	 */
	static String readFileToString(final String filePath) {
		String fileData = null;
		try {
			fileData = new String(Files.readAllBytes(Paths.get(filePath)));
		} catch (final IOException e) {
			LOGGER.log(System.Logger.Level.ERROR, "There was an error with parsing the javafile to String.", e); //$NON-NLS-1$
		}

		return fileData;
	}

	/**
	 * This method takes a absolute filepath to a java file, which is part of a
	 * bundle and returns the belonging bundle.
	 *
	 * @param filePath the absolute filepath of the java file
	 * @return the belonging bundlename
	 */
	static String getBundleFromPath(final String filePath) {
		final String[] filePathContents = filePath.replace("\\", "/").split("/");
		for (int x = 0; x < filePathContents.length; x++) {
			if (x + 1 != filePathContents.length && filePathContents[x].equals("bundles")) {
				return filePathContents[x + 1];
			}
		}
		return "";
	}

	/**
	 * This method takes an interface name, and returns the belonging bundle.
	 *
	 */
	static Bundle getBundleFromInterface(String interfaceName, OSGiProject project) {
		return project.getBundles().stream()//
				.filter(bundleName -> interfaceName.startsWith(bundleName.getEcoreId()))//
				.max(Comparator.comparingInt(x -> x.getEcoreId().length()))
				.orElse(null);
	}
}
