/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Containment
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SPVizModelGenerator extends AbstractGenerator {

    override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
        val SPVizModel model =  resource.contents.head as SPVizModel
        
        val String fileContent = '''
           «model.fileHeader»
           
           «model.mainContent»
        '''
        
        
        fsa.generateFile('model/' + model.name + '.xcore', fileContent)
        // TODO: generate a project model project from this xcore file and build it.
        // Template files that are then filled with data from here are probably the way to go.
    }
    
    private def String fileHeader(SPVizModel model) {
        return '''
            @GenModel(modelDirectory="«model.package».model/src")
            
            package «model.package»
        '''
    }
    
    private def String mainContent(SPVizModel model) {
        return '''
           «FOR artifact : model.artifacts»
               class «artifact.name» {
                   «FOR reference : artifact.references»
                       «IF reference instanceof Containment»
                           contains «reference.contains.eClass.name»[] «reference.contains.eClass.name.firstCharLowercase»s
                       «ELSEIF reference instanceof Connection»
                           refers «reference.connectsTo.eClass.name»[] «reference.name»
                       «ENDIF»
                   «ENDFOR»
               }
           «ENDFOR»
       '''
    }
    
    /**
     * Converts a string to let the first char be lowercase.
     */
    private def String firstCharLowercase(String string) {
        if (string.empty) {
            return string
        }
        
        val char[] c = string.toCharArray();
        c.set(0, Character.toLowerCase(c.get(0)))
        return new String(c);
    }
}