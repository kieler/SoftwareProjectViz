/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020-2021 by
 * + Kiel University
 *   + Department of Computer Science
 *	 + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spviz.sPViz.SPViz
import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import de.cau.cs.kieler.spviz.spvizmodel.generator.XCoreProjectGenerator
import java.util.Collections
import java.util.List
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IProjectDescription
import org.eclipse.core.resources.IncrementalProjectBuilder
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.emf.codegen.ecore.Generator
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

/**
 * Generates code from your model files on save.
 * 
 * @author leo, nre
 * @see https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SPVizGenerator extends AbstractGenerator {
	
	
//	TODO: add flags and a class for each 'via' connection (look at 'UsedPackagesOfBundleEdgeConnection' for reference) 
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		println("Generate visualization for " + resource.contents.head?.class)
		
		val DataAccess spviz = new DataAccess(resource)
		
		// Generate the -viz.model XCore project
		val String xcoreContent = xcoreContent(spviz)
		val progressMonitor = new NullProgressMonitor
		val project = new XCoreProjectGenerator(spviz.getBundleNamePrefix + ".model")
		  .configureXCoreFile(spviz.vizName + 'Model.xcore', xcoreContent)
		  .configureRequiredBundles(#[spviz.modelBundleNamePrefix + ".model"])
		  .generate(progressMonitor)
        val sourceFolder = project.getFolder("src");
		
		// Generate further source files for the project
		GenerateVizModelUtils.generate(sourceFolder, spviz, progressMonitor)
		
		
		// Generate the -viz.viz model Plug-In Java project
		val projectPath = new Path("/" + spviz.getBundleNamePrefix + ".viz/src")
        val vizProject = Generator.createEMFProject(projectPath, null as IPath,
            Collections.<IProject>emptyList(), progressMonitor,
            Generator.EMF_MODEL_PROJECT_STYLE.bitwiseOr(Generator.EMF_PLUGIN_PROJECT_STYLE))
            
            
        val sourceVizFolder = vizProject.getFolder("src")
        
        // Generate the manifest
        FileGenerator.generateOrUpdateFile(vizProject, "/META-INF/MANIFEST.MF",
            FileGenerator.manifestContent(spviz.getBundleNamePrefix + '.viz', requiredVizBundles(spviz)), progressMonitor)
        
        // Generate the services file
        FileGenerator.generateOrUpdateFile(vizProject,
            "/META-INF/services/de.cau.cs.kieler.klighd.IKlighdStartupHook", serviceFileContent(spviz), progressMonitor)
        
        // Generate the plugin.xml file
        FileGenerator.generateOrUpdateFile(vizProject, "/plugin.xml", pluginXmlContent(spviz), progressMonitor)

        // Add the Xtext nature to the project
        val IProjectDescription projectDescription = vizProject.getDescription();
        val String[] natureIds = projectDescription.getNatureIds();
        val String[] newNatureIds = newArrayOfSize(natureIds.length + 1);
        System.arraycopy(natureIds, 0, newNatureIds, 0, natureIds.length);
        newNatureIds.set(natureIds.length, "org.eclipse.xtext.ui.shared.xtextNature");
        projectDescription.setNatureIds(newNatureIds);
        vizProject.setDescription(projectDescription, progressMonitor);
        vizProject.build(IncrementalProjectBuilder.INCREMENTAL_BUILD, progressMonitor)        
		
		// Generate further source files for the project
		GenerateSyntheses.generate(sourceVizFolder, spviz, progressMonitor)
		GenerateSubSyntheses.generate(sourceVizFolder, spviz, progressMonitor)
		GenerateActions.generate(sourceVizFolder, spviz, progressMonitor)
	}
	
	protected def List<String> requiredVizBundles(DataAccess spviz) {
        return #[
            "de.cau.cs.kieler.klighd",
            "de.cau.cs.kieler.klighd.krendering.extensions",
            "org.eclipse.elk.alg.layered",
            "org.eclipse.elk.core",
            "org.eclipse.elk.core.service",
            "org.eclipse.emf.ecore.xmi",
            "org.eclipse.xtend.lib",
            "org.eclipse.xtext.xbase.lib",
            "com.google.inject",
            spviz.getBundleNamePrefix + ".model",
            spviz.modelBundleNamePrefix + ".model"
        ]
    }
    
    /**
     * Generates the content for the plugin.xml file
     * 
     * @param spviz
     *      a DataAccess instance for the Spviz data
     * @return
     *      the generated content for the plugin configuration as a String.
     */
    private def String pluginXmlContent(DataAccess spviz) {
        return '''
        <?xml version="1.0" encoding="UTF-8"?>
        <?eclipse version=\"3.4\"?>
        <plugin>
            <extension
                point="de.cau.cs.kieler.klighd.extensions">
                <startupHook
                    class="«spviz.getBundleNamePrefix».viz.KlighdSetup">
                </startupHook>
            </extension>
        </plugin>
        '''
    }
    
    /**
     * Generates the content for the IKLighdStartupHook service file
     * 
     * @param spviz
     *      a DataAccess instance for the Spviz data
     * @return
     *      the generated content for the service configuration as a String.
     */
    private def String serviceFileContent(DataAccess spviz) {
        return '''
        «spviz.getBundleNamePrefix».viz.KlighdSetup
        '''
    }
	
	/**
	 * Generates the content for the Model.xcore file
	 * 
	 * @param spviz
	 *  	a DataAccess to easily get the information from
	 * @return 
	 * 		the generated content for the visualization model XCore file as a String
	 */
	private def String xcoreContent(DataAccess spviz) {
		return '''
			@GenModel(modelDirectory="«spviz.getBundleNamePrefix».model/src")
			
			package «spviz.getBundleNamePrefix».model
			
			import org.eclipse.emf.ecore.EEList
			«FOR artifact : spviz.artifacts»
				import «spviz.modelBundleNamePrefix».model.«artifact»
			«ENDFOR»
			import «spviz.modelBundleNamePrefix».model.«spviz.projectName»
			
			
			///////////////////////////////////////////////////////////////////////////////////////
			// ------------------------------- Generic Interfaces -------------------------------//
			///////////////////////////////////////////////////////////////////////////////////////
			
			/*
			 * Interface for visualization contexts of the (OSGi) model synthesis. Each context may contain child contexts, where each
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
