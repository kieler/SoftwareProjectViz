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

import static extension de.cau.cs.kieler.spviz.spvizmodel.util.SPVizModelExtension.*

/**
 * Generates code from your model files on save.
 * 
 * @author leo, nre
 * @see https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SPVizGenerator extends AbstractGenerator {
	
	
//	TODO: add flags and a class for each 'via' connection (look at 'UsedPackagesOfBundleEdgeConnection' for reference) 
	
    val String[] CLASHING_NAMES = #[
        "Appendable", "AutoCloseable", "CharSequence", "Cloneable", "Comparable", "Iterable", "ProcessHandle", "ProcessHandle.Info", "Readable", "Runnable", "StackWalker.StackFrame", "System.Logger", "Thread.UncaughtExceptionHandler",
        "Boolean", "Byte", "Character", "Character.Subset", "Character.UnicodeBlock", "Class", "ClassLoader", "ClassValue", "Compiler", "Double", "Enum", "Float", "InheritableThreadLocal", "Integer", "Long", "Math", "Module", "ModuleLayer", "ModuleLayer.Controller", "Number", "Object", "Package", "Process", "ProcessBuilder", "ProcessBuilder.Redirect", "Runtime", "Runtime.Version", "RuntimePermission", "SecurityManager", "Short", "StackTraceElement", "StrictMath", "String", "StringBuffer", "StringBuilder", "System", "System.LoggerFinder", "Thread", "ThreadGroup", "ThreadLocal", "Throwable", "Void",
        "Character.UnicodeScript", "ProcessBuilder.Redirect.Type", "StackWalker.Option", "System.Logger.Level", "Thread.State",
        "ArithmeticException", "ArrayIndexOutOfBoundsException", "ArrayStoreException", "ClassCastException", "ClassNotFoundException", "CloneNotSupportedException", "EnumConstantNotPresentException", "Exception", "IllegalAccessException", "IllegalArgumentException", "IllegalCallerException", "IllegalMonitorStateException", "IllegalStateException", "IllegalThreadStateException", "IndexOutOfBoundsException", "InstantiationException", "InterruptedException", "NegativeArraySizeException", "NoSuchFieldException", "NoSuchMethodException", "NullPointerException", "NumberFormatException", "ReflectiveOperationException", "RuntimeException", "SecurityException", "StringIndexOutOfBoundsException", "TypeNotPresentException", "UnsupportedOperationException",
        "AbstractMethodError", "AssertionError", "BootstrapMethodError", "ClassCircularityError", "ClassFormatError", "Error", "ExceptionInInitializerError", "IllegalAccessError", "IncompatibleClassChangeError", "InstantiationError", "InternalError", "LinkageError", "NoClassDefFoundError", "NoSuchFieldError", "NoSuchMethodError", "OutOfMemoryError", "StackOverflowError", "ThreadDeath", "UnknownError", "UnsatisfiedLinkError", "UnsupportedClassVersionError", "VerifyError", "VirtualMachineError"
    ]
    
    override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		println("Generate visualization for " + resource.contents.head?.class)
		
		val DataAccess data = new DataAccess(resource)
		
		// Generate the -viz.model XCore project
		val String xcoreContent = xcoreContent(data)
		val progressMonitor = new NullProgressMonitor
		// TODO: remove all the .model suffixes for the model packages to be more in line with other emf projects and
		// have a more "speaking" automatically generated name for ...Package, ...Switch, etc. classes
		val project = new XCoreProjectGenerator(data.getBundleNamePrefix + ".model")
		  .configureXCoreFile(data.visualizationName + 'Model.xcore', xcoreContent)
		  .configureRequiredBundles(#[data.modelBundleNamePrefix + ".model"])
		  .generate(progressMonitor)
        val sourceFolder = project.getFolder("src");
		
		// Generate further source files for the project
		GenerateVizModelUtils.generate(sourceFolder, data, progressMonitor)
		
		
		// Generate the -viz.viz model Plug-In Java project
		val projectPath = new Path("/" + data.getBundleNamePrefix + ".viz/src")
        val vizProject = Generator.createEMFProject(projectPath, null as IPath,
            Collections.<IProject>emptyList(), progressMonitor,
            Generator.EMF_MODEL_PROJECT_STYLE.bitwiseOr(Generator.EMF_PLUGIN_PROJECT_STYLE))
            
            
        val sourceVizFolder = vizProject.getFolder("src")
        
        // Generate the manifest
        FileGenerator.generateOrUpdateFile(vizProject, "/META-INF/MANIFEST.MF",
            FileGenerator.manifestContent(data.getBundleNamePrefix + '.viz', requiredVizBundles(data)), progressMonitor)
        
        // Generate the services file
        FileGenerator.generateOrUpdateFile(vizProject,
            "/META-INF/services/de.cau.cs.kieler.klighd.IKlighdStartupHook", serviceFileContent(data), progressMonitor)
        
        // Generate the plugin.xml file
        FileGenerator.generateOrUpdateFile(vizProject, "/plugin.xml", pluginXmlContent(data), progressMonitor)

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
		GenerateSyntheses.generate(sourceVizFolder, data, progressMonitor)
		GenerateSubSyntheses.generate(sourceVizFolder, data, progressMonitor)
		GenerateActions.generate(sourceVizFolder, data, progressMonitor)
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
     * @param data
     *      a DataAccess instance for the Spviz data
     * @return
     *      the generated content for the plugin configuration as a String.
     */
    private def String pluginXmlContent(DataAccess data) {
        return '''
        <?xml version="1.0" encoding="UTF-8"?>
        <?eclipse version=\"3.4\"?>
        <plugin>
            <extension
                point="de.cau.cs.kieler.klighd.extensions">
                <startupHook
                    class="«data.getBundleNamePrefix».viz.KlighdSetup">
                </startupHook>
            </extension>
        </plugin>
        '''
    }
    
    /**
     * Generates the content for the IKLighdStartupHook service file
     * 
     * @param data
     *      a DataAccess instance for the Spviz data
     * @return
     *      the generated content for the service configuration as a String.
     */
    private def String serviceFileContent(DataAccess data) {
        return '''
        «data.getBundleNamePrefix».viz.KlighdSetup
        '''
    }
	
	/**
	 * Generates the content for the Model.xcore file
	 * 
	 * @param data
	 *  	a DataAccess to easily get the information from
	 * @return 
	 * 		the generated content for the visualization model XCore file as a String
	 */
	private def String xcoreContent(DataAccess data) {
		return '''
			@GenModel(modelDirectory="«data.getBundleNamePrefix».model/src")
			
			package «data.getBundleNamePrefix».model
			
			import org.eclipse.emf.ecore.EEList
			«FOR artifact : data.artifacts»
				import «data.modelBundleNamePrefix».model.«artifact.name»
			«ENDFOR»
			import «data.modelBundleNamePrefix».model.«data.projectName»
			
			
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
			
			«FOR artifact : data.artifacts»
				class «artifact.name»Context extends IVisualizationContext<«correctArtifactName(artifact.name, data)»> {
					«FOR required : data.getRequiredArtifacts(artifact)»
						boolean allRequired«required.requiring.name»Requires«required.required.name»Named«required.name»Shown
					«ENDFOR»
					«FOR requiring : data.getRequiringArtifacts(artifact)»
						boolean allRequiring«requiring.requiring.name»Requires«requiring.required.name»Named«requiring.name»Shown
					«ENDFOR»
				}
				
			«ENDFOR»

			«FOR view : data.views»
				class «view.name»OverviewContext extends IOverviewVisualizationContext<Object> {
					«FOR connection : view.shownConnections»
						contains Pair<«connection.shownConnection.requiring.name»Context, «connection.shownConnection.required.name»Context>[] required«connection.shownConnection.requiring.name»Requires«connection.shownConnection.required.name»Named«connection.shownConnection.name»Edges
						contains Pair<«connection.shownConnection.requiring.name»Context, «connection.shownConnection.required.name»Context>[] requiring«connection.shownConnection.requiring.name»Requires«connection.shownConnection.required.name»Named«connection.shownConnection.name»Edges
					«ENDFOR»
					«FOR shownElement : view.shownElements»
						refers «shownElement.shownElement.name»Context[] collapsed«shownElement.shownElement.name»Contexts
						refers «shownElement.shownElement.name»Context[] detailed«shownElement.shownElement.name»Contexts
						refers «correctArtifactName(shownElement.shownElement.name, data)»[] «shownElement.shownElement.name.toFirstLower»s
					«ENDFOR»
				}
				
			«ENDFOR»
			
			///////////////////////////////////////////////////////////////////////////////////////
			// ------------------------- The Main Visualization Class ---------------------------//
			///////////////////////////////////////////////////////////////////////////////////////
			
			
			/*
			 * Context for the synthesis that contains information about the root project overview.
			 */
			class «data.visualizationName» extends IVisualizationContext<«data.projectName»> {
			
				«FOR view : data.views»
					/*
					 * The context for the «view.name.toFirstLower» overview.
					 */
					refers «view.name»OverviewContext «view.name.toFirstLower»OverviewContext
				«ENDFOR»
				
				/*
				 * The child context currently in focus of the view.
				 */
				refers IVisualizationContext<?> focus
				
			}
			
		'''
	}
    
    /**
     * Corrects the artifact name if it clashes with the auto-imported public java.lang classes.
     */
    def correctArtifactName(String string, DataAccess data) {
        if (!CLASHING_NAMES.contains(string)) {
            return string
        }
        return data.modelBundleNamePrefix + ".model." + string
    }
    
}
