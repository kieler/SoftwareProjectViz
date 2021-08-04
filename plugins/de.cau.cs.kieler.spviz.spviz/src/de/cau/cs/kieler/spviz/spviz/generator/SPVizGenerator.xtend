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
package de.cau.cs.kieler.spviz.spviz.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import de.cau.cs.kieler.spviz.spviz.sPViz.SPViz

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SPVizGenerator extends AbstractGenerator {
	
	/**
	 * TODO: add flags and a class for each 'via' connection (look at 'UsedPackagesOfBundleEdgeConnection' for reference) 
	 * 
	 * TODO: directly generate a visualization model project 
	 * 
	 * TODO: directly generate a visualization project based on the model project and the visualization model project.
	 */
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		println("Generate visualization for " + resource.contents.head?.class)
		
		val DataAccess spviz = new DataAccess(resource.contents.head as SPViz)
		
		val String content = xcoreContent(spviz)
		fsa.generateFile(spviz.vizName + 'Model.xcore', content)
		
		/** syntheses files */
		GenerateSyntheses.generate(fsa, spviz)
		GenerateSubSyntheses.generate(fsa, spviz)
		GenerateModelUtils.generate(fsa, spviz)
		GenerateActions.generate(fsa, spviz)
	}
	
	/**
	 * Generates the contend for the Model.xcore file
	 * 
	 * @param model
	 *  	a DataAccess to easily get the information from
	 * @return 
	 * 		the generated contend for the visualisation model XCore file as a string
	 */
	private def String xcoreContent(DataAccess spviz) {
		return '''
			@GenModel(modelDirectory="«spviz.packageName».model/src")
			
			package «spviz.packageName».model
			
			import org.eclipse.emf.ecore.EEList
			«FOR artifact : spviz.artifacts»
				import «spviz.importedNamespace».model.«artifact»
			«ENDFOR»
			import «spviz.importedNamespace».model.«spviz.projectName»
			
			
			///////////////////////////////////////////////////////////////////////////////////////
			// ------------------------------- Generic Interfaces -------------------------------//
			///////////////////////////////////////////////////////////////////////////////////////
			
			/*
			 * Interface for visualization contexts of the model synthesis. Each context may contain child contexts, where each
			 * context will give the synthesis additional information in which state parts of the model should be generated in.
			 * 
			 * @param <M> The model element class this visualization context is for.
			 * 
			 * @author nre
			 */
			interface IVisualizationContext<M> {
				
				/*
				 * All contexts that need to be into the view model as children.
				 */
				contains IVisualizationContext<?>[] childContexts opposite parent
				
				/*
				 * The model element to get the data from for this context.
				 */
				refers M modelElement
				
				/*
				 * The parent visualization context containing this context.
				 */
				container IVisualizationContext<?> parent opposite childContexts
				
				/**
				 * Indicating if the child contexts of this context have been initialized correctly.
				 */
				boolean childrenInitialized
				
			}
			
			/*
			 * Interface for a visualization context for overviews that simply shows a list of elements in collapsed or detailed
			 * fashion individually.
			 * 
			 * @param <M> The model element class of the child contexts of this context.
			 * 
			 * @author nre
			 */
			interface IOverviewVisualizationContext<M> extends IVisualizationContext<EEList<M>> {
				
				/*
				 * Indicates whether the overview should be shown plain or expanded with its contents shown.
				 */
				boolean expanded = "false"
				
			}
			
			///////////////////////////////////////////////////////////////////////////////////////
			// ------------------------------- Helper Data Classes ------------------------------//
			///////////////////////////////////////////////////////////////////////////////////////
			
			class Pair<K,V> {
				refers K key
				refers V value
			}
			
			class Option {
				String ^id
				String value
			}
			
			///////////////////////////////////////////////////////////////////////////////////////
			// ------------------------------- Context Classes ----------------------------------//
			///////////////////////////////////////////////////////////////////////////////////////
			
			«FOR artifact : spviz.artifacts»
				class «artifact»Context extends IVisualizationContext<«artifact»> {
					«FOR required : spviz.getRequiredArtifacts(artifact)»
						boolean allRequired«required.get(0)»«required.get(1)»sShown
					«ENDFOR»
					«FOR requiring : spviz.getRequiringArtifacts(artifact)»
						boolean allRequiring«requiring.get(0)»«requiring.get(1)»sShown
					«ENDFOR»
				}
				
			«ENDFOR»

			«FOR overview : spviz.overviews»
				class «overview»OverviewContext extends IOverviewVisualizationContext<Object> {
					«FOR connection : spviz.getOverviewConnections(overview)»
						contains Pair <«connection.get(1)»Context,«connection.get(2)»Context>[] required«connection.get(0)»«connection.get(2)»Edges
						contains Pair <«connection.get(2)»Context,«connection.get(1)»Context>[] requiring«connection.get(0)»«connection.get(1)»Edges
					«ENDFOR»
					«FOR artifact : spviz.getDisplayedArtifacts(overview)»
						refers «artifact»Context[] collapsed«artifact»Contexts
						refers «artifact»Context[] detailed«artifact»Contexts
						refers «artifact»[] «artifact.toFirstLower»s
					«ENDFOR»
				}
				
			«ENDFOR»
			
			///////////////////////////////////////////////////////////////////////////////////////
			// ------------------------- The Main Visualization Class ---------------------------//
			///////////////////////////////////////////////////////////////////////////////////////
			
			
			/*
			 * Context for the synthesis that contains information about the root project overview.
			 */
			class «spviz.vizName» extends IVisualizationContext<«spviz.projectName»> {
			
				«FOR overview : spviz.overviews»
					/*
					 * The context for the «overview.toFirstLower» overview.
					 */
					refers «overview»OverviewContext «overview.toFirstLower»OverviewContext
				«ENDFOR»
				
				/*
				 * The child context currently in focus of the view.
				 */
				refers IVisualizationContext<?> focus
				
			}
			
		'''
	}
}
