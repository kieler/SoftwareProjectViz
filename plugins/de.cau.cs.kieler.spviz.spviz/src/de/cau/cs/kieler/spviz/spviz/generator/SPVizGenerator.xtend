/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020-2023 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import de.cau.cs.kieler.spviz.spvizmodel.generator.JavaMavenProjectGenerator
import de.cau.cs.kieler.spviz.spvizmodel.generator.XCoreProjectGenerator
import de.cau.cs.kieler.spviz.spvizmodel.generator.maven.Dependency
import java.util.Arrays
import java.util.Collections
import java.util.List
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IProjectDescription
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.emf.codegen.ecore.Generator
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.jdt.core.JavaCore
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

import static extension de.cau.cs.kieler.spviz.spvizmodel.util.SPVizModelExtension.*
import static extension de.cau.cs.kieler.spviz.spviz.util.SPVizExtension.*

/**
 * Generates code from your model files on save.
 * 
 * @author leo, nre
 * @see https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SPVizGenerator extends AbstractGenerator {
    
    
//    TODO: add flags and a class for each 'via' connection (look at 'UsedPackagesOfBundleEdgeConnection' for reference) 
    
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
        val project = new XCoreProjectGenerator(data.getBundleNamePrefix + ".model")
            .configureXCoreFile(data.visualizationName + 'Model.xcore', xcoreContent)
            .configureRequiredBundles(#[data.modelBundleNamePrefix + ".model"])
            .configureExportedPackages(exportedVizModelPackages(data))
            .configureMaven(true)
            .generate(progressMonitor)
        
        // Add the xtend-gen folder to the classpath
        val xtendGenFolder = project.getFolder("xtend-gen")
        if (!xtendGenFolder.exists()) {
            xtendGenFolder.create(false, true, progressMonitor)
        }
        val javaProject = JavaCore.create(project);
        val oldClasspathEntries = javaProject.getRawClasspath
        if (!oldClasspathEntries.contains(JavaCore.newSourceEntry(xtendGenFolder.getFullPath()))) {        
            val classpathEntries = Arrays.copyOf(oldClasspathEntries, oldClasspathEntries.size + 1)
            classpathEntries.set(oldClasspathEntries.size, JavaCore.newSourceEntry(xtendGenFolder.getFullPath()))
            javaProject.setRawClasspath(classpathEntries, progressMonitor)
        }
        
        val sourceFolder = project.getFolder("src-gen")
        // Generate further source files for the project
        GenerateVizModelUtils.generate(sourceFolder, data, progressMonitor)
        
        // Generate the build.properties file
        FileGenerator.generateFile(project, "/build.properties",
            FileGenerator.modelBuildPropertiesContent(), progressMonitor)
        
        
        // Generate the -viz.viz model Plug-In Java project
        val projectPath = new Path("/" + data.getBundleNamePrefix + ".viz/src-gen")
        val vizProject = Generator.createEMFProject(projectPath, null as IPath,
            Collections.<IProject>emptyList(), progressMonitor,
            Generator.EMF_MODEL_PROJECT_STYLE.bitwiseOr(Generator.EMF_PLUGIN_PROJECT_STYLE))
        XCoreProjectGenerator.addNatures(vizProject, true, progressMonitor)
            
            
        val sourceVizFolder = vizProject.getFolder("src-gen")
        
        // Generate the manifest
        FileGenerator.generateFile(vizProject, "/META-INF/MANIFEST.MF",
            FileGenerator.manifestContent(data.getBundleNamePrefix + '.viz', requiredVizBundles(data), exportedVizPackages(data)), progressMonitor)
        
        // Generate the services file
        FileGenerator.generateFile(vizProject,
            "/META-INF/services/de.cau.cs.kieler.klighd.IKlighdStartupHook", serviceFileContent(data), progressMonitor)
        
        // Generate the plugin.xml file
        FileGenerator.generateFile(vizProject, "/plugin.xml", pluginXmlContent(data), progressMonitor)
        
        // Generate the build.properties file
        FileGenerator.generateFile(vizProject, "/build.properties", 
            FileGenerator.buildPropertiesContent(true), progressMonitor
        )
        
        // Generate further source files for the project
        GenerateSyntheses.generate(sourceVizFolder, data, progressMonitor)
        GenerateSubSyntheses.generate(sourceVizFolder, data, progressMonitor)
        GenerateActions.generate(sourceVizFolder, data, progressMonitor)
        
        // Copy icons over into the project
        FileGenerator.copyFiles("de.cau.cs.kieler.spviz.spviz",
            "/icons/",
            vizProject.getFolder("icons"),
            progressMonitor
        )
        
        // Add the Xtext and Plugin natures to the project
        val IProjectDescription projectDescription = vizProject.getDescription();
        var String[] natureIds = projectDescription.getNatureIds()
        if (natureIds === null) {
            natureIds = #[ "org.eclipse.xtext.ui.shared.xtextNature", "org.eclipse.pde.PluginNature" ]
        } else {
            if (!project.hasNature("org.eclipse.xtext.ui.shared.xtextNature")) {
                val oldNatureIds = natureIds
                natureIds = newArrayOfSize(oldNatureIds.length + 1)
                System.arraycopy(oldNatureIds, 0, natureIds, 0, oldNatureIds.length)
                natureIds.set(oldNatureIds.length, "org.eclipse.xtext.ui.shared.xtextNature")
            }
            if (!project.hasNature("org.eclipse.pde.PluginNature")) {
                val oldNatureIds = natureIds
                natureIds = newArrayOfSize(oldNatureIds.length + 1 )
                System.arraycopy(oldNatureIds, 0, natureIds, 0, oldNatureIds.length)
                natureIds.set(oldNatureIds.length, "org.eclipse.pde.PluginNature")
            }
        }
        projectDescription.setNatureIds(natureIds);
        vizProject.setDescription(projectDescription, progressMonitor);
        
        
        // Generate the .language.server Maven project
        val lsProject = new JavaMavenProjectGenerator(data.getBundleNamePrefix, data.getBundleNamePrefix + ".language.server")
            .configureDependencies(requiredLSDependencies(data))
            .configureDependencyManagement(lsDependencyManagement)
            .configureXtendSources(true)
            .configureSourceFolderName("src-gen")
            .configureGenerateShadedJar(true)
            .configureMainClass(data.visualizationName + "LanguageServer")
            .generate(progressMonitor)
        
        // Generate further source files for the java project
        val launchFolder = lsProject.getFolder("launch")
        if (!launchFolder.exists) {
            launchFolder.create(false, true, progressMonitor)
        }
        GenerateLanguageServer.generate(lsProject.getFolder("src-gen"), launchFolder, data, progressMonitor)
        
        // Generate the Maven build framework for this visualization.
        GenerateMavenBuild.generate(data.bundleNamePrefix, data.visualizationName.toFirstUpper, data.modelBundleNamePrefix, "0.1.0", progressMonitor)
    }
    
    def lsDependencyManagement() {
        return '''
            <dependencyManagement>
              <dependencies>
                <dependency>
                  <groupId>de.cau.cs.kieler.klighd</groupId>
                  <artifactId>de.cau.cs.kieler.kgraph.text</artifactId>
                  <version>${klighd-version}</version>
                  <exclusions>
                    <exclusion>
                      <groupId>org.eclipse.platform</groupId>
                      <artifactId>org.eclipse.swt</artifactId>
                    </exclusion>
                  </exclusions>
                </dependency>
                <dependency>
                  <groupId>de.cau.cs.kieler.klighd</groupId>
                  <artifactId>de.cau.cs.kieler.kgraph.text.ide</artifactId>
                  <version>${klighd-version}</version>
                  <exclusions>
                    <exclusion>
                      <groupId>org.eclipse.platform</groupId>
                      <artifactId>org.eclipse.swt</artifactId>
                    </exclusion>
                  </exclusions>
                </dependency>
                <dependency>
                  <groupId>de.cau.cs.kieler.klighd</groupId>
                  <artifactId>de.cau.cs.kieler.klighd.lsp</artifactId>
                  <version>${klighd-version}</version>
                  <exclusions>
                    <exclusion>
                      <groupId>org.eclipse.platform</groupId>
                      <artifactId>org.eclipse.swt</artifactId>
                    </exclusion>
                  </exclusions>
                </dependency>
                <dependency>
                  <groupId>de.cau.cs.kieler.klighd</groupId>
                  <artifactId>de.cau.cs.kieler.klighd</artifactId>
                  <version>${klighd-version}</version>
                  <exclusions>
                    <exclusion>
                      <groupId>org.eclipse.platform</groupId>
                      <artifactId>org.eclipse.swt</artifactId>
                    </exclusion>
                    <exclusion>
                      <groupId>org.eclipse.platform</groupId>
                      <artifactId>org.eclipse.ui.workbench</artifactId>
                    </exclusion>
                    <exclusion>
                      <groupId>org.eclipse.platform</groupId>
                      <artifactId>org.eclipse.jface</artifactId>
                    </exclusion>
                  </exclusions>
                </dependency>
              </dependencies>
            </dependencyManagement>
        '''
    }
    
    protected def List<String> exportedVizModelPackages(DataAccess data) {
        return #[
            data.bundleNamePrefix + ".model",
            data.bundleNamePrefix + ".model.impl",
            data.bundleNamePrefix + ".model.util"
        ]
    }
    
    protected def List<Dependency> requiredLSDependencies(DataAccess data) {
        return #[
           new Dependency("com.google.code.gson", "gson", "${gson-version}"),
           new Dependency("com.google.inject", "guice", "${guice-version}"),
           new Dependency("de.cau.cs.kieler.klighd", "de.cau.cs.kieler.kgraph.text", "${klighd-version}"),
           new Dependency("de.cau.cs.kieler.klighd", "de.cau.cs.kieler.kgraph.text.ide", "${klighd-version}"),
           new Dependency("de.cau.cs.kieler.klighd", "de.cau.cs.kieler.klighd", "${klighd-version}"),
           new Dependency("de.cau.cs.kieler.klighd", "de.cau.cs.kieler.klighd.ide", "${klighd-version}"),
           new Dependency("de.cau.cs.kieler.klighd", "de.cau.cs.kieler.klighd.krendering.extensions", "${klighd-version}"),
           new Dependency("de.cau.cs.kieler.klighd", "de.cau.cs.kieler.klighd.lsp", "${klighd-version}"),
           new Dependency("de.cau.cs.kieler.klighd", "de.cau.cs.kieler.klighd.standalone", "${klighd-version}"),
           new Dependency("org.apache.logging.log4j", "log4j-core", "2.18.0"),
           new Dependency("org.eclipse.elk", "org.eclipse.elk.alg.common", "${elk-version}"),
           new Dependency("org.eclipse.elk", "org.eclipse.elk.alg.layered", "${elk-version}"),
           new Dependency("org.eclipse.elk", "org.eclipse.elk.alg.rectpacking", "${elk-version}"),
           new Dependency("org.eclipse.elk", "org.eclipse.elk.core", "${elk-version}"),
           new Dependency("org.eclipse.elk", "org.eclipse.elk.core.service", "${elk-version}"),
           new Dependency("org.eclipse.lsp4j", "org.eclipse.lsp4j", "${lsp4j-version}"),
           new Dependency("org.eclipse.lsp4j", "org.eclipse.lsp4j.jsonrpc", "${lsp4j-version}"),
           new Dependency("org.eclipse.xtend", "org.eclipse.xtend.lib", "${xtend-version}"),
           new Dependency("org.eclipse.xtext", "org.eclipse.xtext.ide", "${xtext-version}"),
           new Dependency("org.eclipse.xtext", "org.eclipse.xtext.xbase.lib", "${xtext-version}"),
           new Dependency(data.bundleNamePrefix, data.bundleNamePrefix + ".viz", "${project.version}"),
           new Dependency(data.bundleNamePrefix, data.bundleNamePrefix + ".model", "${project.version}"),
           new Dependency(data.modelBundleNamePrefix, data.modelBundleNamePrefix + ".model", "${project.version}")
        ]
    }
    
    protected def List<String> requiredVizBundles(DataAccess data) {
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
            data.getBundleNamePrefix + ".model",
            data.modelBundleNamePrefix + ".model"
        ]
    }
    
    protected def List<String> exportedVizPackages(DataAccess data) {
        return #[
           data.bundleNamePrefix + ".viz"
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
     *      a DataAccess to easily get the information from
     * @return 
     *         the generated content for the visualization model XCore file as a String
     */
    private def String xcoreContent(DataAccess data) {
        return '''
            @GenModel(
                fileExtensions="«data.visualizationName.toLowerCase»",
                modelDirectory="«data.getBundleNamePrefix».model/src-gen",
                modelName="«data.visualizationName»",
                prefix="«data.visualizationName»",
                updateClasspath="false"
            )
            
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
             */
            interface IOverviewVisualizationContext<M> extends IVisualizationContext<EEList<M>> {
                
                /*
                 * Indicates whether the overview should be shown plain or expanded with its contents shown.
                 */
                boolean expanded = "false"
                
                /**
                 * Indicates whether the collapsed elements in this overview should be shown
                 */
                boolean showCollapsedElements = "true"
                
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
                    «FOR connected : data.getConnectedArtifacts(artifact)»
                        boolean allConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»Shown
                    «ENDFOR»
                    «FOR connecting : data.getConnectingArtifacts(artifact)»
                        boolean allConnecting«connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»Shown
                    «ENDFOR»
                    «FOR containedView : data.getContainedViews(artifact)»
                       // The overview context for the «containedView.view.name.toFirstLower» overview shown in detailed «artifact.name.toFirstLower»s
                       refers «containedView.view.name»OverviewContext «containedView.view.name.toFirstLower»OverviewContext
                    «ENDFOR»
                }
                
            «ENDFOR»
            
            «FOR connection : data.connections»
                class «connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Container extends IOverviewVisualizationContext<Object> {
                    contains Pair<«connection.connecting.name»Context, «connection.connected.name»Context>[] «connection.connecting.name.toFirstLower»Connects«connection.connected.name»Named«connection.name»Edges
                }
            «ENDFOR»
            
            «FOR categoryConnection : data.getUniqueCategoryConnections»
                class «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container extends IOverviewVisualizationContext<Object> {
                    // For the category connection between «categoryConnection.connectingCategory.name.toFirstLower»s to connect via their «categoryConnection.connection.name.toFirstLower»s, define some relations for
                    // pre-calculating which connected «categoryConnection.connectedArtifact.name.toFirstLower»s, connecting «categoryConnection.connectingArtifact.name.toFirstLower»s, and which «categoryConnection.connectedCategory.name.toFirstLower»s are connected in this way.
                    
                    /** All «categoryConnection.connectedCategory.name.toFirstLower» category edges related to «categoryConnection.connection.name.toFirstLower»s that are possible. */
                    contains Pair<«categoryConnection.connectedCategory.name.toFirstUpper»Context, «categoryConnection.connectedCategory.name.toFirstUpper»Context>[] possible«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edges
                    /** All «categoryConnection.connectedCategory.name.toFirstLower» category edges related to «categoryConnection.connection.name.toFirstLower»s that are currently connected. */
                    contains Pair<«categoryConnection.connectedCategory.name.toFirstUpper»Context, «categoryConnection.connectedCategory.name.toFirstUpper»Context>[] «categoryConnection.connectingCategory.name.toFirstLower»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edges
                    /** All inner «categoryConnection.connectedCategory.name.toFirstLower» category edges related to «categoryConnection.connection.name.toFirstLower»s that are possible. */
                    contains Pair<«categoryConnection.connectingArtifact.name.toFirstUpper»Context, «categoryConnection.connectedArtifact.name.toFirstUpper»Context>[] possible«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edges
                    /** All inner «categoryConnection.connectedCategory.name.toFirstLower» category edges related to «categoryConnection.connection.name.toFirstLower»s that are currently connected. */
                    contains Pair<«categoryConnection.connectingArtifact.name.toFirstUpper»Context, «categoryConnection.connectedArtifact.name.toFirstUpper»Context>[] «categoryConnection.connectingArtifact.name.toFirstLower»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edges
                }
            «ENDFOR»

            «FOR view : data.views»
                class «view.name»OverviewContext extends IOverviewVisualizationContext<Object>«««
«                  »«FOR connection : view.shownConnections.map[shownConnection] BEFORE ", " SEPARATOR ", "»«««
«                      »«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Container«««
«                  »«ENDFOR»«««
«                  »«FOR categoryConnection : view.shownCategoryConnections BEFORE ", " SEPARATOR ", "»«««
«                      »«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container«««
«                  »«ENDFOR» {
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
                
            /**
             * KLighD's synthesis options for storing/restoring an equal view. 
             */
            contains Option[] synthesisOptions
            
            /**
             * KLighD's layout options for storing/restoring an equal view.
             */
            contains Option[] layoutOptions
            
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
