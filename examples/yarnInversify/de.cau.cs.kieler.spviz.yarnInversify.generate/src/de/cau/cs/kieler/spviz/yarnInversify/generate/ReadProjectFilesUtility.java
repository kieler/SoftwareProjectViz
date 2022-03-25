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

import java.io.IOException;
import java.io.Reader;
import java.lang.System.Logger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

import com.google.gson.Gson;


/**
 * This is a utility class for {@linkplain ReadProjectFiles} with methods for
 * reading and parsing files.
 *
 * @author nre
 */

public class ReadProjectFilesUtility {
	static final Logger LOGGER = System.getLogger(ReadProjectFilesUtility.class.getName());
	
	static final Gson gson = new Gson();
	static final Yaml yaml = new Yaml();

	/**
	 * Reads the yaml file at the destination and puts it into a {@link Map} with field->value
	 * mapping for generic further access.
	 * 
	 * @param filePath The path to find the yaml file
	 * @return The yaml file as a {@link Map}.
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	static Map<String, Object> yamlToMap(final Path filePath) throws IOException {
		return yaml.loadAs(Files.newBufferedReader(filePath), Map.class);
	}
	
	/**
	 * Reads the json File at the destination and puts it into a {@link Map} with field->value
	 * mapping for easy further access.
	 * 
	 * @param filePath The path to find the json file
	 * @return The json file as a {@link Map}.
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	static Map<String, Object> jsonToMap(final Path filePath) throws IOException {
		Reader jsonReader = Files.newBufferedReader(filePath);
		
		return gson.fromJson(jsonReader, Map.class);
	}
	
	/**
	 * Reads file content into a string.
	 *
	 * @param filePath The path to find the file
	 * @return A String with the file content of the input file.
	 * @throws IOException
	 */
	static String readFileToString(final Path filePath) throws IOException {
		return new String(Files.readAllBytes(filePath));
	}

}
