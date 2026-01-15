/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021-2026 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import java.io.File
import java.util.List
import org.eclipse.emf.codegen.util.CodeGenUtil

/**
 * Generator for various different Java projects. Configure it with chained configure[...] methods and start with
 * {@link #generate()}.
 * 
 * @author nre
 */
class ProjectGenerator {
    
    /** The name of the project */
    val String projectName
    
    /** directory of the project to be generated */
    val File projectDirectory
    
    /** The name of the Xcore model */
    var String xCoreModelName = null
    
    /** Name of the to-be-generated Xcore file */
    var String xCoreFileName = null
    
    /** Content of the to-be-generated Xcore file */
    var String xCoreFileContent = null
    
    /** If this project features a KLighD startup hook */
    var boolean klighdHook = false
    
    /** If this project as an additional icons folder for the binary build. */
    var boolean icons = false
    
    /** The additional required bundles for this new project. */
    val List<String> requiredBundles = newArrayList
    
    /** The exported packages for this project. */
    val List<String> exportedPackages = newArrayList
    
    /** If this project should have Maven nature. */
    var boolean mavenNature = false
    
    /** Additional source folders that should be included in this project's build process. */
    val List<String> additionalSourceFolders = newArrayList

    /**
     * Create a new generator.
     */
    new(String projectName, String projectPath) {
        this.projectName = projectName
        this.projectDirectory = FileGenerator.createDirectory(projectPath)
        configureRequiredBundles(#["org.eclipse.emf.ecore", "org.eclipse.xtext.xbase.lib",
            "org.eclipse.emf.ecore.xcore.lib"])
    }
    
    /**
     * Configure the model name and content of the Xcore file in the /model folder of the generated project.
     * 
     * @param modelName The name of the Xcore model
     * @param fileContent The content for that Xcore file.
     * @return This generator, for chaining configurations.
     */
    def ProjectGenerator configureXCoreFile(String modelName, String fileContent) {
        this.xCoreModelName = modelName
        this.xCoreFileName = modelName + 'Model.xcore'
        this.xCoreFileContent = fileContent
        
        return this
    }
    
    /**
     * Configures if this generator should generate this project with a KLighD startup hook in mind.
     * 
     * @param klighdHook {@code true} if this should have a startup hook.
     * @return This generator, for chaining configurations.
     */
    def configureKlighd(boolean klighdHook) {
        this.klighdHook = klighdHook
        return this
    }
    
    /**
     * Configures if this generator should generate this project with an icons folder in mind.
     * 
     * @param icons {@code true} if this should keep it in mind..
     * @return This generator, for chaining configurations.
     */
    def configureIcons(boolean icons) {
        this.icons = icons
        return this
    }
    
    /**
     * Adds the given bundles as requirements to be written into the manifest as plug-in dependencies.
     * 
     * @param requiredBundles The IDs of the bundles to be added as dependencies.
     * @return This generator, for chaining configurations.
     */
    def ProjectGenerator configureRequiredBundles(Iterable<String> requiredBundles) {
        for (requiredBundle : requiredBundles) {
            if (!this.requiredBundles.contains(requiredBundle)) {
                this.requiredBundles.add(requiredBundle)
            }
        }
        
        return this
    }
    
    /**
     * Adds the given packages to be written into the manifest as package exports.
     * 
     * @param exportedPackages The IDs of the packages to be exported.
     * @return This generator, for chaining configurations.
     */
    def ProjectGenerator configureExportedPackages(Iterable<String> exportedPackages) {
        for (exportedPackage : exportedPackages) {
            if (!this.exportedPackages.contains(exportedPackage)) {
                this.exportedPackages.add(exportedPackage)
            }
        }
        
        return this
    }
    
    /**
     * Configures if this generator should generate this project with Maven nature.
     * 
     * @param mavenNature {@code true} if this should have the Maven nature.
     * @return This generator, for chaining configurations.
     */
    def configureMaven(boolean mavenNature) {
        this.mavenNature = mavenNature
        return this
    }
    
    /**
     * Adds the given relative path as further source folders of this project.
     * 
     * @param sourceFolder the folder to add as a source folder, e.g. xtend-gen or src-gen.
     * @return This generator, for chaining configurations.
     */
    def additionalSourceFolder(String sourceFolder) {
        this.additionalSourceFolders.add(sourceFolder)
        return this
    }

    /**
     * Starts the generation of this generator.
     */
    def void generate() {
        // Create all necessary directories
        FileGenerator.createDirectory(projectDirectory, "src-gen")
        for (sourceFolder : additionalSourceFolders) {
            FileGenerator.createDirectory(projectDirectory, sourceFolder)
        }
        val File settingsDirectory = FileGenerator.createDirectory(projectDirectory, ".settings")
        
        // Create the .classpath file
        FileGenerator.generateFile(projectDirectory,  ".classpath", classpathContent)
        
        // Create the .project file
        FileGenerator.generateFile(projectDirectory, ".project", projectContent)
        
        // Create the settings/org.eclipse.core.resources.prefs file
        FileGenerator.generateFile(settingsDirectory, "org.eclipse.core.resources.prefs", eclipseCoreResourcesPrefsContent)

        // Generate the manifest
        val File manifestDirectory = FileGenerator.createDirectory(projectDirectory, "META-INF")
        FileGenerator.generateFile(manifestDirectory, "MANIFEST.MF",
            manifestContent(projectName, requiredBundles, exportedPackages))
        
        if (this.xCoreModelName !== null) {
            // Create the /model directory
            val File modelDirectory = FileGenerator.createDirectory(projectDirectory, "model")
            
            // Create/Update the Xcore file in the project.
            FileGenerator.generateFile(modelDirectory, xCoreFileName, xCoreFileContent)
            
        }
        
        if (this.xCoreModelName !== null || this.klighdHook) {
            // Generate the plugin.xml
            FileGenerator.generateFile(projectDirectory, "plugin.xml", pluginXmlContent)
        }
        
        if (this.klighdHook) {
            // Generate the services file
            FileGenerator.createDirectory(projectDirectory, "META-INF/services")
            FileGenerator.generateFile(projectDirectory,
                "/META-INF/services/de.cau.cs.kieler.klighd.IKlighdStartupHook", serviceFileContent)
        }
        
        // Generate plugin.properties
        FileGenerator.generateFile(projectDirectory, "plugin.properties", pluginPropertiesContent)
        
        // Generate build.properties
        FileGenerator.generateFile(projectDirectory, "build.properties", buildPropertiesContent)
    }
    
    private def classpathContent() {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <classpath>
                <classpathentry kind="src" path="src-gen"/>
                «FOR additionalSourceFolder : additionalSourceFolders»
                    <classpathentry kind="src" path="«additionalSourceFolder»"/>
                «ENDFOR»
                <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-21"/>
                <classpathentry kind="con" path="org.eclipse.pde.core.requiredPlugins"/>
                <classpathentry kind="output" path="bin"/>
            </classpath>
            
        '''
    }
    
    private def projectContent() {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <projectDescription>
                <name>«projectName»</name>
                <comment></comment>
                <projects>
                </projects>
                <buildSpec>
                    <buildCommand>
                        <name>org.eclipse.xtext.ui.shared.xtextBuilder</name>
                        <arguments>
                        </arguments>
                    </buildCommand>
                    <buildCommand>
                        <name>org.eclipse.jdt.core.javabuilder</name>
                        <arguments>
                        </arguments>
                    </buildCommand>
                    <buildCommand>
                        <name>org.eclipse.pde.ManifestBuilder</name>
                        <arguments>
                        </arguments>
                    </buildCommand>
                    <buildCommand>
                        <name>org.eclipse.pde.SchemaBuilder</name>
                        <arguments>
                        </arguments>
                    </buildCommand>
                    «IF mavenNature»
                        <buildCommand>
                            <name>org.eclipse.m2e.core.maven2Builder</name>
                            <arguments>
                            </arguments>
                        </buildCommand>
                    «ENDIF»
                </buildSpec>
                <natures>
                    <nature>org.eclipse.jdt.core.javanature</nature>
                    <nature>org.eclipse.pde.PluginNature</nature>
                    <nature>org.eclipse.xtext.ui.shared.xtextNature</nature>
                    «IF mavenNature»
                        <nature>org.eclipse.m2e.core.maven2Nature</nature>
                    «ENDIF»
                </natures>
            </projectDescription>
            
        '''
    }
    
    private def eclipseCoreResourcesPrefsContent() {
        return '''
            eclipse.preferences.version=1
            encoding/<project>=UTF-8
            
        '''
    }
    
    /**
     * Generates the content for the MANIFEST.MF file
     * 
     * @param identifier
     *      the fully qualified identifier of the generated bundle.
     * @param requiredBundles
     *      the Bundles this bundle requires and should be added to the manifest.
     * @param exportedPackages
     *      the Packages this bundle exports and should be added to the manifest.
     * @return
     *      the generated content for the manifest as a String.
     */
    private def manifestContent(String identifier, Iterable<String> requiredBundles, Iterable<String> exportedPackages) {
        return '''
        Manifest-Version: 1.0
        Bundle-ManifestVersion: 2
        Automatic-Module-Name: «CodeGenUtil.validPluginID(identifier)»
        Bundle-Name: «identifier»
        Bundle-Vendor: SPViz
        Bundle-SymbolicName: «CodeGenUtil.validPluginID(identifier)»; singleton:=true
        Bundle-Version: 0.1.0.qualifier
        Bundle-RequiredExecutionEnvironment: JavaSE-21
        «FOR exportedPackage : exportedPackages BEFORE "Export-Package:" SEPARATOR ','»
            «" " + exportedPackage»
        «ENDFOR»
        «FOR requiredBundle : requiredBundles BEFORE "Require-Bundle:" SEPARATOR ','»
            «" " + requiredBundle»
        «ENDFOR»
        '''
    }
    
    private def pluginXmlContent() {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <?eclipse version="3.0"?>
            
            <!--
            -->
            
            <plugin>
            
                «IF xCoreModelName !== null»
                    <extension point="org.eclipse.emf.ecore.generated_package">
                      <!-- @generated «xCoreModelName»Model -->
                      <package
                            uri="«projectName»"
                            class="«projectName».«xCoreModelName»Package"
                            genModel="model/«xCoreFileName»"/>
                    </extension>
                «ENDIF»
                «IF klighdHook»
                    <extension
                        point="de.cau.cs.kieler.klighd.extensions">
                        <startupHook
                            class="«projectName».KlighdSetup">
                        </startupHook>
                    </extension>
                «ENDIF»
            
            </plugin>

        '''
    }
    
    private def String serviceFileContent() {
        return '''
            «projectName».KlighdSetup
        '''
    }
    
    private def pluginPropertiesContent() {
        return '''
            #
            
            pluginName = «projectName»
            providerName = https://github.com/kieler/SoftwareProjectViz/

        '''
    }
    
    private def buildPropertiesContent() {
        return '''
            #
            
            bin.includes = .,\
                           «IF xCoreFileName !== null»
                               model/,\
                               plugin.properties,\
                           «ENDIF»
                           «IF icons»
                               icons/,\
                           «ENDIF»
                           META-INF/,\
                           plugin.xml
            bin.excludes = **/*.xtend,\
                           **/*.java._trace
            source.. = src-gen/«IF !additionalSourceFolders.empty»,\«ENDIF»
                       «FOR sourceFolder : additionalSourceFolders SEPARATOR ',\\'»
                           «sourceFolder»/
                       «ENDFOR»
            output.. = target/classes/

        '''
    }

}
