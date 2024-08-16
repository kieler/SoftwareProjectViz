/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021-2024 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import java.io.File

/**
 * Generates utility classes for the model.
 * 
 * @author nre, leo
 */
class GenerateModelUtils {
    def static void generate(File sourceFolder, SPVizModel spvizModel) {
        val folder = FileGenerator.createDirectory(sourceFolder, spvizModel.package.replace('.', '/') + "/model/util/")
        FileGenerator.updateFile(folder, "ModelUtil.java", generateModelUtil(spvizModel.name + "Project", spvizModel.package))
    }
    
    /**
     * Generates the content for the ModelUtil.java file contained inside the model package
     * 
     * @param projectName
     *      the model project name
     * @param importedNamespace
     *         the model package name
     * @return 
     *         the generated file content as a string
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
