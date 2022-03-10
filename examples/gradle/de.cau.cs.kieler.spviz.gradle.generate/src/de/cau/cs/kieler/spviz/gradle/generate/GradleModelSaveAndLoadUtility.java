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

import java.io.IOException;
import java.util.Collections;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import de.cau.cs.kieler.spviz.gradle.model.GradleProject;

public class GradleModelSaveAndLoadUtility {

	/**
	 * Takes a Gradle project and saves the data under modelSaveFilePath/fileName.
	 * 
	 * @param fileName the name for the file
	 * @param data GradleProject to save
	 * @throws IOException
	 */
	public static void saveData(final String fileName, final GradleProject data, String modelSaveFilePath) throws IOException {
		final Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		final Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("gradle", new XMIResourceFactoryImpl());

		final ResourceSet resSet = new ResourceSetImpl();
		modelSaveFilePath= modelSaveFilePath.replace("\\", "/");
		if (!modelSaveFilePath.endsWith("/")) {
			modelSaveFilePath+="/";
		}
		final Resource resource = resSet.createResource(URI.createURI("file:///"+modelSaveFilePath+fileName));
		resource.getContents().add(data);
		resource.save(Collections.EMPTY_MAP);
	}

}
