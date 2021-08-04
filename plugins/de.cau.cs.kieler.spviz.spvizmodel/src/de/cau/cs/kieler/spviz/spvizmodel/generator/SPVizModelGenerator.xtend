/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020 by
 * + Kiel University
 *   + Department of Computer Science
 *	 + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Containment
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection
import java.util.LinkedHashMap
import java.util.ArrayList

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SPVizModelGenerator extends AbstractGenerator {
	
	/**
	 *TODO: directly generate a project model project 
	 */
	 
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val SPVizModel model =  resource.contents.head as SPVizModel
		
		val String fileContent = xcoreContent(model)		
		fsa.generateFile(model.name + 'Model.xcore', fileContent)
	}
	
	/**
	 * Generates the contend for the Model.xcore file
	 * 
	 * @param model
	 *  	a SPVizModel to get the needed information from
	 * @return 
	 * 		the generated contend for the model XCore file as a string
	 */
	private def String xcoreContent(SPVizModel model) {
		
		// maps all artifacts to all artifacts they relate to, regardless of direction
		val LinkedHashMap<String, ArrayList<String>> crossRef = newLinkedHashMap()
		// initialise with empty lists
		for(artifact : model.artifacts) crossRef.put(artifact.name, newArrayList())
		for(artifact : model.artifacts) {
			for(reference: artifact.references) {
				if(reference instanceof Containment) {
					crossRef.get(artifact.name).add(reference.contains.name)
					crossRef.get(reference.contains.name).add(artifact.name)
				}
			}
		}
		
		// maps all artifacts to pairs of their connection name + connected artifact
		val LinkedHashMap<String, ArrayList<String>> connections = newLinkedHashMap()
		// initialise with empty lists
		for(artifact : model.artifacts) connections.put(artifact.name, newArrayList)
		for(artifact : model.artifacts) {
			for(reference: artifact.references) {
				if(reference instanceof Connection) {
					val connectionName = reference.name
					val required = reference.dependsOn.name
					val requiring = artifact.name 
					
					val requiredList = "required" + connectionName + required + "s"
					val requiringList = "requiring" + connectionName + requiring + "s"
					
					connections.get(requiring).add(
						required + "[] "  + requiredList + " opposite " + requiringList
					)
					connections.get(required).add(
						requiring + "[] " + requiringList + " opposite " + requiredList
					)
				}
			}
		}
		
		// String building
		return '''
		@GenModel(modelDirectory="«model.package».model/src")
		
		package «model.package».model
		
		class «model.name»Project {
			«FOR artifact : model.artifacts»
				contains «artifact.name»[] «artifact.name.toFirstLower»s
			«ENDFOR»
		}
		
		abstract class Identifiable {
			unique id String ecoreId
			String name
		}
		
		«FOR artifact : model.artifacts»
		class «artifact.name» extends Identifiable {
			«FOR reference : crossRef.get(artifact.name)»
				refers «reference»[] «reference.toFirstLower»s opposite «artifact.name.toFirstLower»s
			«ENDFOR»
			«FOR reference : connections.get(artifact.name)»
				refers «reference»
			«ENDFOR»
		}
		
		«ENDFOR»			
		'''
	}
}