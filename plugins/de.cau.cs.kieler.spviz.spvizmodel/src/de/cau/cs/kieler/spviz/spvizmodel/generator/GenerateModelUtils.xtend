/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import org.eclipse.core.resources.IFolder
import org.eclipse.core.runtime.IProgressMonitor

/**
 * Generates utility classes for the model.
 * 
 * @author leo, nre
 */
class GenerateModelUtils {
	def static void generate(IFolder sourceFolder, SPVizModel spvizModel, IProgressMonitor progressMonitor) {
		var folder = spvizModel.package.replace('.', '/') + "/model/util/"
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "ModelUtil.java",
            generateModelUtil(spvizModel.name + "Project", spvizModel.package), progressMonitor)
	}
	
	/**
	 * Generates the contend for the ModelUtil.java file contained inside the model package
	 * 
	 * @param projectName
	 *  	the model project name
	 * @param importedNamespace
	 * 		the model package name
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateModelUtil(String projectName, String importedNamespace){
		return '''
			package «importedNamespace».model.util;

			import «importedNamespace».model.«projectName»;
			import org.eclipse.emf.ecore.EObject;
			
			/**
			 * Handy methods for handling with OSGi model elements.
			 */
			public final class ModelUtil {
				
				/**
				 * Returns the «projectName» this model element belongs to.
				 * 
				 * @param element The element to find the project for.
				 * @return The project containing the element.
				 */
				public static «projectName» parentProject(EObject element) {
					EObject current = element;
					while (!(current instanceof «projectName») && current != null) {
						current = current.eContainer();
					}
					if (current instanceof «projectName») {
						return («projectName») current;
					} else {
						return null;
					}
				}
				
			}
			
		'''
	}

}
