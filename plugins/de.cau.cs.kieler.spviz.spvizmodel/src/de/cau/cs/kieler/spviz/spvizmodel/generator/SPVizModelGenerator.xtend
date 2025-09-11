/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020-2025 by
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
import java.io.File
import java.nio.file.Path
import java.nio.file.Paths
import java.util.ArrayList
import java.util.LinkedHashMap
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.eclipse.xtext.util.JavaVersion
import org.eclipse.xtext.xtext.wizard.BuildSystem
import org.eclipse.xtext.xtext.wizard.LanguageDescriptor
import org.eclipse.xtext.xtext.wizard.LanguageDescriptor.FileExtensions
import org.eclipse.xtext.xtext.wizard.LineDelimiter
import org.eclipse.xtext.xtext.wizard.WizardConfiguration
import org.eclipse.xtext.xtext.wizard.cli.CliProjectsCreator
import org.slf4j.Logger
import org.slf4j.LoggerFactory

/**
 * Generates code from your model files on save.
 * 
 * @author nre, leo
 * @see https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SPVizModelGenerator extends AbstractGenerator {
    
    static final Logger LOGGER = LoggerFactory.getLogger(SPVizModelGenerator)
    
    override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
        val workspace = ResourcesPlugin.workspace
        val output = Paths.get(workspace.root.location.toString)
        SPVizModelGenerator.generate(resource, output)
    }
    
    static def void generate(Resource resource, Path rootPath) {
        val rootDirectory = new File(rootPath.toAbsolutePath.toString)
        val SPVizModel model = resource.contents.head as SPVizModel
        
        val String fileContent = xcoreContent(model)
        val projectName = model.package + ".model"
        val projectPath = rootPath.toAbsolutePath.toString + "/" + projectName
        if (new File(projectPath).isDirectory) {
            LOGGER.info("Updating sources of project {}", projectPath)
        } else {
            LOGGER.info("Generating project {}", projectPath)
        }
        new ProjectGenerator(projectName, projectPath)
            .configureXCoreFile(model.name, fileContent)
            .configureExportedPackages(#[
                projectName,
                projectName + ".impl",
                projectName + ".util"
            ])
            .configureMaven(true)
            .generate()
            
        val sourceFolder = new File(projectPath, "src-gen")
        
        // Generate further source files for the project
        GenerateModelUtils.generate(sourceFolder, model)
        
        // Generate the build artifacts for the project
        val projectDirectory = FileGenerator.createDirectory(projectPath)
        val version = "0.1.0"
        GenerateModelMavenBuild.addPluginPom(projectDirectory, model, version)
        
        GenerateModelMavenBuild.addSpvizBuildProject(rootDirectory, version)
        
        // Generate a .generate scaffold for the model if not already existent.
        GenerateGeneratorScaffold.generate(rootDirectory, model, version)
        
        // Generate DiffDSL
        var CliProjectsCreator creator = new CliProjectsCreator()
        var WizardConfiguration config = new WizardConfiguration() => [
            rootLocation = rootPath.toAbsolutePath.toString
            baseName = model.package + ".diff.dsl"
            language.name = baseName + "." + model.name + "DiffDsl"
            language.fileExtensions = FileExtensions.fromString(model.name.toLowerCase + "diff")
            preferredBuildSystem = BuildSystem.MAVEN
            javaVersion = JavaVersion.JAVA17
            ideProject.enabled = true
            // ensures that META-INF/MANIFEST.MF will be generated for all projects
            uiProject.enabled = true
            // cannot find a way to also auto-generate .project files for Eclipse
        ]
        creator.lineDelimiter = LineDelimiter.UNIX.value
        
        creator.createProjects(config)
        
        // modify xtext grammar
        val diffDslFolder = new File(config.rootLocation + "/" + config.baseName)
        val diffDslPackageFolder = FileGenerator.createDirectory(diffDslFolder, "src/" + config.baseName.replace('.', '/'))
        var content = generateDiffGrammar(model, config.language)
        FileGenerator.updateFile(diffDslPackageFolder, model.name + "DiffDsl.xtext", content)
        // TODO: only update this file and not do a full regeneration (only the referencedResource is missing)
        content = generateMwe2(model)
        FileGenerator.updateFile(diffDslPackageFolder, "Generate" + model.name + "DiffDsl.mwe2", content)
        // TODO: also update this file, only the emf.ecore.xcore dependency is missing.
        val diffDslManifestFolder = FileGenerator.createDirectory(diffDslFolder, "META-INF")
        content = diffManifestContent(model)
        FileGenerator.updateFile(diffDslManifestFolder, "MANIFEST.MF", content)
        // TODO: also update this file as well, only the emf.ecore.xcore.sdk.feature.group is missing.
        val diffDslTargetSourceFolder = new File(config.rootLocation + "/" + config.baseName + ".target")
        content = diffDslTargetPlatformContent(model)
        FileGenerator.updateFile(diffDslTargetSourceFolder, config.baseName + ".target.target", content)
        
        
        // TODO: Generate model DSL
        // We cannot generate the model DSL from the generated architecture model here easily:
        // - The generator first needs to load the model package, which it can only do if the model has been compiled first.
        // - I do not want to build the model code in the generator directly, that is something Maven already does.
        // - I could split the generator into two parts:
        // 1. generate model code as abov
        // 2. trigger Maven build from the generator to only build the model (separate Maven goal)
        // 3. load model in the generator and generate DSL code (alternative: trigger this generator from Maven instead, CliProjectsCreator is a CLI tool, after all)
        // see https://github.com/xtext/xtext-reference-projects/tree/74ac80c44fc8b61c7eb38c858769f4247971b09f/launch
        // and https://github.com/eclipse-xtext/xtext-website/blob/9d54f6538fa42b2a39fd1d27e83ddf4807538165/xtext-website/_posts/releasenotes/2018-09-04-version-2-15-0.md?plain=1#L41
        // 4. generate remaining files / changed files into the new DSL code
        // (5. build the entire project via Maven, now with the DSL code) 
        
        // Mock of Step 3:
        // First, we need to load the class/package of the previously generated architecture model.
//        val classLoader = new URLClassLoader(#[java.net.URI.create("file://" + rootPath.toAbsolutePath.toString + "/" + model.package + ".model").toURL])
//        val Class<?> thePackage = classLoader.loadClass(model.package + ".model." + model.name + "Package")
//        val Object modelPackage = thePackage.fields.findFirst[name.equals("eINSTANCE")]?.get(thePackage)
//        if (modelPackage instanceof EPackage) { // or is this an EClass?
//            println("yay!")
//        }
//        val LanguageDescriptor modelLanguage = new LanguageDescriptor()
//        modelLanguage.name = model.package
//        modelLanguage.fileExtensions = FileExtensions.fromString(model.name.toLowerCase)
//        creator = new CliProjectsCreator()
//        config = new WizardConfiguration() => [
//            rootLocation = rootPath.toAbsolutePath.toString
//            baseName = model.package + ".dsl"
//            language.name = baseName + "." + model.name + "Dsl"
//            language.fileExtensions = FileExtensions.fromString(model.name.toLowerCase + "dsl")
//            preferredBuildSystem = BuildSystem.MAVEN
//            javaVersion = JavaVersion.JAVA17
//            ideProject.enabled = true
//            // ensures that META-INF/MANIFEST.MF will be generated for all projects
//            uiProject.enabled = true
//            // cannot find a way to also auto-generate .project files for Eclipse
//            ecore2Xtext.defaultEPackageInfo = new EPackageInfo(modelPackage, URI.createPlatformResourceURI(modelLanguage.nsURI), URI.createPlatformResourceURI(modelLanguage.nsURI), "?",
//            modelLanguage.name)
//            ecore2Xtext.rootElementClass = value // type EClass? // is this the "entry rule"? -> model.name + "Project" is the class name
//        ]
//        creator.lineDelimiter = LineDelimiter.UNIX.value
//        
//        creator.createProjects(config)
        
        // How it would be done from Eclipse:
        // 1. create a new project using the "Xtext Project From Existing Ecore Models" wizard
        // see https://github.com/eclipse-xtext/xtext/blob/997bedb00a8eb43ebfe43576aa1e4a638eaba10f/org.eclipse.xtext.tests/src/org/eclipse/xtext/xtext/wizard/cli/CliWizardIntegrationTest.java#L51
        // 2. configure and run it:
        //    - use the model xcore file
        //    - use the (projectName) model as the entry rule for the grammar
        //    - give it the proper project name (model.package + ".dsl"), language name (same in CamelCase), and extension (same in lowercase)
        // 3. fix the dependencies in the newly generated plugin: add the slf4j.api dependency. Xtext needs it, but currently does not add it, seems to be an Xtext bug.
        // 4. Run the org.eclipse.emf.mew2.launch.runtime.Mwe2Launcher on the new project as configured in the generated run configuration
        // 5. adapt the dsl resource (and other classes I forgot) as in thesis so that it creates a correct model readable by the synthesis
    }
    
    /**
     * Generates the content for the Model.xcore file
     * 
     * @param model
     *      a SPVizModel to get the needed information from
     * @return 
     *         the generated content for the model XCore file as a string
     */
    private static def String xcoreContent(SPVizModel model) {
        
        // maps all artifacts to all artifacts they relate to, regardless of direction
        val LinkedHashMap<String, ArrayList<String>> crossRef = newLinkedHashMap()
        // initialize with empty lists
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
        // initialize with empty lists
        for(artifact : model.artifacts) connections.put(artifact.name, newArrayList)
        for(artifact : model.artifacts) {
            for(reference: artifact.references) {
                if(reference instanceof Connection) {
                    val connectionName = reference.name
                    val connected = reference.connects.name
                    val connecting = artifact.name 
                    
                    val connectedList = "connected" + connectionName + connected + "s"
                    val connectingList = "connecting" + connectionName + connecting + "s"
                    
                    connections.get(connecting).add(
                        connected + "[] "  + connectedList + " opposite " + connectingList
                    )
                    connections.get(connected).add(
                        connecting + "[] " + connectingList + " opposite " + connectedList
                    )
                }
            }
        }
        
        // String building
        return '''
        @GenModel(
            fileExtensions="«model.name.toLowerCase»",
            modelDirectory="«model.package».model/src-gen",
            modelName="«model.name»",
            prefix="«model.name»"
        )
        
        package «model.package».model
        
        class «model.name»Project {
            String projectName
            «FOR artifact : model.artifacts»
                contains «artifact.name»[] «artifact.name.toFirstLower»s
            «ENDFOR»
        }
        
        abstract class Identifiable {
            unique id String ecoreId
            String name
            boolean external
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
    
    private static def String generateDiffGrammar(SPVizModel model, LanguageDescriptor language) {
        return '''
            grammar «model.package + ".diff.dsl"».«model.name»DiffDsl with org.eclipse.xtext.common.Terminals
            
            generate «model.name.toFirstLower»DiffDsl "«language.nsURI»/«model.name»DiffDsl"
            
            import "«model.package».model" as «model.name»Model
            
            «model.name»Diff:
                'compare' sourceModel=STRING
                'to' targetModel=STRING;
            
        '''
        
    }
    
    private static def String generateMwe2(SPVizModel model) {
        return '''
            module «model.package».diff.dsl.Generate«model.name»DiffDsl
            
            import org.eclipse.xtext.xtext.generator.*
            import org.eclipse.xtext.xtext.generator.model.project.*
            
            var rootPath = ".."
            
            Workflow {
                
                component = XtextGenerator {
                    configuration = {
                        project = StandardProjectConfig {
                            baseName = "«model.package».diff.dsl"
                            rootPath = rootPath
                            eclipsePlugin = {
                                enabled = true
                            }
                            createEclipseMetaData = true
                        }
                        code = {
                            encoding = "UTF-8"
                            lineDelimiter = "\n"
                            fileHeader = "/*\n * generated by SPViz and Xtext \${version}\n */"
                            preferXtendStubs = false
                        }
                    }
                    language = StandardLanguage {
                        name = "«model.package».diff.dsl.«model.name»DiffDsl"
«««                        This is the important missing line
                        referencedResource = "platform:/resource/«model.package».model/model/«model.name»Model.xcore"
                        fileExtensions = "«model.name.toLowerCase»diff"
            
                        serializer = {
                            generateStub = false
                        }
                        validator = {
                            // composedCheck = "org.eclipse.xtext.validation.NamesAreUniqueValidator"
                            // Generates checks for @Deprecated grammar annotations, an IssueProvider and a corresponding PropertyPage
                            generateDeprecationValidation = true
                        }
                        generator = {
                            generateXtendStub = true
                        }
                    }
                }
            }
             
        '''   
    }
    
    private static def String diffDslTargetPlatformContent(SPVizModel model) {
        return '''
             <?xml version="1.0" encoding="UTF-8" standalone="no"?>
             <?pde version="3.8"?>
             <target name="«model.package».diff.dsl.target" sequenceNumber="1">
                 <locations>
                     <location includeAllPlatforms="false" includeConfigurePhase="false" includeMode="planner" includeSource="true" type="InstallableUnit">
                         <unit id="org.eclipse.jdt.feature.group" version="0.0.0"/>
                         <unit id="org.eclipse.platform.feature.group" version="0.0.0"/>
                         <unit id="org.eclipse.pde.feature.group" version="0.0.0"/>
                         <unit id="org.eclipse.draw2d.feature.group" version="0.0.0"/>
                         <unit id="org.eclipse.emf.sdk.feature.group" version="0.0.0"/>
«««                         Only this line would be missing otherwise
                         <unit id="org.eclipse.emf.ecore.xcore.sdk.feature.group" version="0.0.0"/>
                         <repository location="https://download.eclipse.org/releases/2023-12"/>
                     </location>
                     <location includeAllPlatforms="false" includeConfigurePhase="false" includeMode="planner" includeSource="true" type="InstallableUnit">
                         <unit id="org.eclipse.emf.mwe2.launcher.feature.group" version="0.0.0"/>
                         <repository location="https://download.eclipse.org/modeling/emft/mwe/updates/releases/2.16.0/"/>
                     </location>
                     <location includeAllPlatforms="false" includeConfigurePhase="false" includeMode="planner" includeSource="true" type="InstallableUnit">
                         <unit id="org.eclipse.xtext.sdk.feature.group" version="0.0.0"/>
                         <repository location="https://download.eclipse.org/modeling/tmf/xtext/updates/releases/2.33.0/"/>
                     </location>
                     <location includeAllPlatforms="false" includeConfigurePhase="false" includeMode="planner" includeSource="true" type="InstallableUnit">
                         <unit id="com.google.gson" version="2.10.1"/>
                         <unit id="com.google.inject" version="7.0.0"/>
                         <unit id="jakarta.inject.jakarta.inject-api" version="2.0.1"/>
                         <unit id="org.antlr.runtime" version="3.2.0.v20230929-1400"/>
                         <unit id="org.junit" version="4.13.2.v20230809-1000"/>
                         <unit id="org.hamcrest" version="2.2.0"/>
                         <unit id="org.hamcrest.core" version="2.2.0.v20230809-1000"/>
                         <unit id="org.objectweb.asm" version="9.6.0"/>
                         <unit id="io.github.classgraph.classgraph" version="4.8.164"/>
                         <repository location="https://download.eclipse.org/tools/orbit/simrel/orbit-aggregation/2023-12"/>
                     </location>
                 </locations>
             </target>
             
        '''   
    }
    
    private static def String diffManifestContent(SPVizModel model) {
        return '''
             Manifest-Version: 1.0
             Bundle-ManifestVersion: 2
             Bundle-Name: «model.package».diff.dsl
             Bundle-Vendor: My Company
             Bundle-Version: 1.0.0.qualifier
             Bundle-SymbolicName: «model.package».diff.dsl; singleton:=true
             Bundle-ActivationPolicy: lazy
             Require-Bundle: «model.package».model,
              org.eclipse.xtext,
«««             missing line follows:
              org.eclipse.emf.ecore.xcore,
              org.eclipse.xtext.xbase,
              org.eclipse.equinox.common;bundle-version="3.16.0",
              org.antlr.runtime;bundle-version="[3.2.0,3.2.1)",
              org.eclipse.emf.ecore,
              org.eclipse.xtext.xbase.lib;bundle-version="2.14.0",
              org.eclipse.xtext.util,
              org.eclipse.emf.common
             Bundle-RequiredExecutionEnvironment: JavaSE-17
             Automatic-Module-Name: «model.package».diff.dsl
             Export-Package: «model.package».diff.dsl,
              «model.package».diff.dsl.scoping,
              «model.package».diff.dsl.«model.name.toFirstLower»DiffDsl.util,
              «model.package».diff.dsl.services,
              «model.package».diff.dsl.parser.antlr,
              «model.package».diff.dsl.serializer,
              «model.package».diff.dsl.validation,
              «model.package».diff.dsl.«model.name.toFirstLower»DiffDsl,
              «model.package».diff.dsl.generator,
              «model.package».diff.dsl.«model.name.toFirstLower»DiffDsl.impl,
              «model.package».diff.dsl.parser.antlr.internal
             Import-Package: org.apache.log4j
             
             
        '''
    }
}
