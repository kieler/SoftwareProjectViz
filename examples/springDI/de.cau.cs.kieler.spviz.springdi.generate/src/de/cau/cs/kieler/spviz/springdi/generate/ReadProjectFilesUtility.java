/*
 * SPViz - Kieler Software Project Visualization for Projects
 * 
 * A part of Kieler
 * https://github.com/kieler
 * 
 * Copyright 2021 by
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

package de.cau.cs.kieler.spviz.springdi.generate;

import java.io.File;
import java.io.IOException;
import java.lang.System.Logger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

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

	static Document readFileToDocument(final Path filePath) throws ParserConfigurationException, SAXException, IOException {
		return readFileToDocument(filePath.toFile());
	}
	
	static Document readFileToDocument(final String filePath) throws ParserConfigurationException, SAXException, IOException {
		return readFileToDocument(new File(filePath));
	}

	static Document readFileToDocument(final File file) throws ParserConfigurationException, SAXException, IOException {
		final DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		return dBuilder.parse(file);
	}

}
