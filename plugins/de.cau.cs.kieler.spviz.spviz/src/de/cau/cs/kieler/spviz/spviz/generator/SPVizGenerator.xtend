/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020-2024 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import de.cau.cs.kieler.spviz.spvizmodel.generator.JavaMavenProjectGenerator
import de.cau.cs.kieler.spviz.spvizmodel.generator.ProjectGenerator
import de.cau.cs.kieler.spviz.spvizmodel.generator.maven.Dependency
import java.io.File
import java.io.InputStream
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.util.List
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Platform
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.slf4j.Logger
import org.slf4j.LoggerFactory

import static extension de.cau.cs.kieler.spviz.spviz.util.SPVizExtension.*
import static extension de.cau.cs.kieler.spviz.spvizmodel.util.SPVizModelExtension.*

/**
 * Generates code from your model files on save.
 * 
 * @author nre, leo
 * @see https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SPVizGenerator extends AbstractGenerator {
    
    static final Logger LOGGER = LoggerFactory.getLogger(SPVizGenerator)
    
    override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
        val workspace = ResourcesPlugin.workspace
        val output = Paths.get(workspace.root.location.toString)
        SPVizGenerator.generate(resource, output)
    }
    
//    TODO: add flags and a class for each 'via' connection (look at 'UsedPackagesOfBundleEdgeConnection' for reference) 
    
    static val String[] CLASHING_NAMES = #[
        "Appendable", "AutoCloseable", "CharSequence", "Cloneable", "Comparable", "Iterable", "ProcessHandle", "ProcessHandle.Info", "Readable", "Runnable", "StackWalker.StackFrame", "System.Logger", "Thread.UncaughtExceptionHandler",
        "Boolean", "Byte", "Character", "Character.Subset", "Character.UnicodeBlock", "Class", "ClassLoader", "ClassValue", "Compiler", "Double", "Enum", "Float", "InheritableThreadLocal", "Integer", "Long", "Math", "Module", "ModuleLayer", "ModuleLayer.Controller", "Number", "Object", "Package", "Process", "ProcessBuilder", "ProcessBuilder.Redirect", "Runtime", "Runtime.Version", "RuntimePermission", "SecurityManager", "Short", "StackTraceElement", "StrictMath", "String", "StringBuffer", "StringBuilder", "System", "System.LoggerFinder", "Thread", "ThreadGroup", "ThreadLocal", "Throwable", "Void",
        "Character.UnicodeScript", "ProcessBuilder.Redirect.Type", "StackWalker.Option", "System.Logger.Level", "Thread.State",
        "ArithmeticException", "ArrayIndexOutOfBoundsException", "ArrayStoreException", "ClassCastException", "ClassNotFoundException", "CloneNotSupportedException", "EnumConstantNotPresentException", "Exception", "IllegalAccessException", "IllegalArgumentException", "IllegalCallerException", "IllegalMonitorStateException", "IllegalStateException", "IllegalThreadStateException", "IndexOutOfBoundsException", "InstantiationException", "InterruptedException", "NegativeArraySizeException", "NoSuchFieldException", "NoSuchMethodException", "NullPointerException", "NumberFormatException", "ReflectiveOperationException", "RuntimeException", "SecurityException", "StringIndexOutOfBoundsException", "TypeNotPresentException", "UnsupportedOperationException",
        "AbstractMethodError", "AssertionError", "BootstrapMethodError", "ClassCircularityError", "ClassFormatError", "Error", "ExceptionInInitializerError", "IllegalAccessError", "IncompatibleClassChangeError", "InstantiationError", "InternalError", "LinkageError", "NoClassDefFoundError", "NoSuchFieldError", "NoSuchMethodError", "OutOfMemoryError", "StackOverflowError", "ThreadDeath", "UnknownError", "UnsatisfiedLinkError", "UnsupportedClassVersionError", "VerifyError", "VirtualMachineError"
    ]
    
    static def void generate(Resource resource, Path rootPath) {
        
        val DataAccess data = new DataAccess(resource)
        val root = rootPath.toAbsolutePath.toString + "/"
        
        // Generate the -viz.model XCore project
        val String xcoreContent = xcoreContent(data)
        val vizModelProjectName = data.getBundleNamePrefix + ".model"
        val vizModelProjectPath = root + vizModelProjectName
        if (new File(vizModelProjectPath).isDirectory) {
            LOGGER.info("Updating sources of project {}", vizModelProjectPath)
        } else {
            LOGGER.info("Generating project {}", vizModelProjectPath)
        }
        val vizModelProjectDirectory = FileGenerator.createDirectory(vizModelProjectPath)
        new ProjectGenerator(vizModelProjectName, vizModelProjectPath)
            .configureXCoreFile(data.visualizationName, xcoreContent)
            .configureRequiredBundles(#[data.modelBundleNamePrefix + ".model"])
            .configureExportedPackages(exportedVizModelPackages(data))
            .configureMaven(true)
            .additionalSourceFolder("xtend-gen")
            .generate()
        
        
        val sourceVizModelFolder = FileGenerator.createDirectory(vizModelProjectDirectory, "src-gen")
        // Generate further source files for the project
        GenerateVizModelUtils.generate(sourceVizModelFolder, data)
        
        
        // Generate the -viz.viz model Plug-In Java project
        val vizProjectName = data.getBundleNamePrefix + ".viz"
        val vizProjectPath = root + vizProjectName
        if (new File(vizProjectPath).isDirectory) {
            LOGGER.info("Updating sources of project {}", vizProjectPath)
        } else {
            LOGGER.info("Generating project {}", vizProjectPath)
        }
        val vizProjectDirectory = FileGenerator.createDirectory(vizProjectPath)
        new ProjectGenerator(vizProjectName, vizProjectPath)
            .configureMaven(true)
            .configureKlighd(true)
            .configureIcons(true)
            .additionalSourceFolder("xtend-gen")
            .configureRequiredBundles(requiredVizBundles(data))
            .configureExportedPackages(exportedVizPackages(data))
            .generate()
            
        val sourceVizFolder = new File(vizProjectPath, "src-gen")
        
        // Generate further source files for the project
        GenerateSyntheses.generate(sourceVizFolder, data)
        GenerateSubSyntheses.generate(sourceVizFolder, data)
        GenerateActions.generate(sourceVizFolder, data)
        
        // Copy icons over into the project
        copyIcons(FileGenerator.createDirectory(vizProjectDirectory, "icons"))
        
        
        // Generate the .language.server Maven project
        val lsProjectName = data.bundleNamePrefix + ".language.server"
        val lsProjectPath = root + lsProjectName
        if (new File(lsProjectPath).isDirectory) {
            LOGGER.info("Updating sources of project {}", lsProjectPath)
        } else {
            LOGGER.info("Generating project {}", lsProjectPath)
        }
        val lsProjectDirectory = FileGenerator.createDirectory(lsProjectPath)
        new JavaMavenProjectGenerator(data.bundleNamePrefix, lsProjectName, lsProjectPath)
            .configureDependencies(requiredLSDependencies(data))
            .configureDependencyManagement(lsDependencyManagement)
            .configureXtendSources(true)
            .configureSourceFolderName("src-gen")
            .configureGenerateShadedJar(true)
            .configureMainClass(data.visualizationName + "LanguageServer")
            .generate()
        
        // Generate further source files for the java project
        val launchFolder = FileGenerator.createDirectory(lsProjectDirectory, "launch")
        val lsSourceFolder = FileGenerator.createDirectory(lsProjectDirectory, "src-gen")
        GenerateLanguageServer.generate(lsSourceFolder, launchFolder, data)
        
        // Generate the Maven build framework for this visualization.
        GenerateMavenBuild.generate(root, data.bundleNamePrefix, data.visualizationName.toFirstUpper, data.modelBundleNamePrefix, "0.1.0")
    }
    
    /**
     * Copies the files from the icons/ folder to the target folder.
     * 
     * @param targetFolder The folder to copy the files to.
     */
    static def void copyIcons(File targetFolder) {
        targetFolder.mkdirs
        if (Platform.isRunning) {
            // If the platform is running, the folder can be found in the bundle under the resource path.
            val url = Platform.getBundle("de.cau.cs.kieler.spviz.spviz")
                ?.getEntry("icons")
            val folder = new File(FileLocator.toFileURL(url).toURI.path)
            for (file : folder.listFiles) {
                val fileName = file.name
                val newFile = new File(targetFolder, fileName)
                if (!newFile.exists) {
                    Files.copy(file.toPath, newFile.toPath)
                }
            }
        } else {
            // The file path is searched on the classpath directly
            val fileNames = #["connect.svg", "connect128.png",
                "expand.svg", "expand128.png",
                "loupe.svg", "loupe128.png",
                "loupe-crossed.svg", "loupe-crossed128.png",
                "minimize.svg", "minimize128.png",
                "restore.svg", "restore128.png"]
            for (fileName : fileNames) {
                val InputStream source = SPVizGenerator.classLoader.getResourceAsStream("icons/" + fileName)
                val newFile = new File(targetFolder, fileName)
                if (!newFile.exists) {
                    Files.copy(source, newFile.toPath)
                }
            }
        }
    }
    
    static def lsDependencyManagement() {
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
    
    protected static def List<String> exportedVizModelPackages(DataAccess data) {
        return #[
            data.bundleNamePrefix + ".model",
            data.bundleNamePrefix + ".model.impl",
            data.bundleNamePrefix + ".model.util"
        ]
    }
    
    protected static def List<Dependency> requiredLSDependencies(DataAccess data) {
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
    
    protected static def List<String> requiredVizBundles(DataAccess data) {
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
    
    protected static def List<String> exportedVizPackages(DataAccess data) {
        return #[
           data.bundleNamePrefix + ".viz"
        ]
    }
    
    /**
     * Generates the content for the Model.xcore file
     * 
     * @param data
     *      a DataAccess to easily get the information from
     * @return 
     *         the generated content for the visualization model XCore file as a String
     */
    private static def String xcoreContent(DataAccess data) {
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
    static def correctArtifactName(String string, DataAccess data) {
        if (!CLASHING_NAMES.contains(string)) {
            return string
        }
        return data.modelBundleNamePrefix + ".model." + string
    }
    
}
