/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020-2026 by
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
        SPVizModelGenerator.generate(resource, output, false, false)
    }
    
    static def void generate(Resource resource, Path rootPath, boolean noModelDsl, boolean noDiff) {
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
        
        if (noDiff) {
            LOGGER.info("Skip generating difference DSL.")
        } else {
            LOGGER.info("Generate difference DSL")
            // Generate DiffDSL
            val CliProjectsCreator creator = new CliProjectsCreator()
            val WizardConfiguration config = new WizardConfiguration() => [
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
            content = generateDiffDslMwe2(model)
            FileGenerator.updateFile(diffDslPackageFolder, "Generate" + model.name + "DiffDsl.mwe2", content)
            // TODO: also only update this file, only the emf.ecore.xcore dependency is missing.
            val diffDslManifestFolder = FileGenerator.createDirectory(diffDslFolder, "META-INF")
            content = diffManifestContent(model)
            FileGenerator.updateFile(diffDslManifestFolder, "MANIFEST.MF", content)
            // TODO: also only update this file, only the emf.ecore.xcore.sdk.feature.group is missing.
            val diffDslTargetSourceFolder = new File(config.rootLocation + "/" + config.baseName + ".target")
            content = dslTargetPlatformContent(model, true)
            FileGenerator.updateFile(diffDslTargetSourceFolder, config.baseName + ".target.target", content)
            // The generated .ide plugin does not export the correct packages required by the also generated ui plugin, re-generate its MANIFEST.MF file
            val diffDslIdeFolder = new File(config.rootLocation + "/" + config.baseName + ".ide")
            content = dslIdeManifestContent(model, true)
            FileGenerator.updateFile(FileGenerator.createDirectory(diffDslIdeFolder, "META-INF"), "MANIFEST.MF", content)
            // The generated .ui plugin misses some imports in its Manifest as well
            val diffDslUiFolder = new File(config.rootLocation + "/" + config.baseName + ".ui")
            content = dslUiManifestContent(model, true)
            FileGenerator.updateFile(FileGenerator.createDirectory(diffDslUiFolder, "META-INF"), "MANIFEST.MF", content)
        }
        
        if (noModelDsl) {
            LOGGER.info("Skip generating model DSL.")
        } else {
            LOGGER.info("Generate model DSL")
            // Generate model DSL
            val CliProjectsCreator creator = new CliProjectsCreator()
            val WizardConfiguration config = new WizardConfiguration() => [
                rootLocation = rootPath.toAbsolutePath.toString
                baseName = model.package + ".model.dsl"
                language.name = baseName + "." + model.name + "Dsl"
                language.fileExtensions = FileExtensions.fromString(model.name.toLowerCase + "dsl")
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
            val dslFolder = new File(config.rootLocation + "/" + config.baseName)
            val dslPackageFolder = FileGenerator.createDirectory(dslFolder, "src/" + config.baseName.replace('.', '/'))
            var content = generateDslGrammar(model, config.language)
            FileGenerator.updateFile(dslPackageFolder, model.name + "Dsl.xtext", content)
            // TODO: only update this file and not do a full regeneration (only the referencedResource is missing)
            content = generateDslMwe2(model)
            FileGenerator.updateFile(dslPackageFolder, "Generate" + model.name + "Dsl.mwe2", content)
            // TODO: also only update this file, only the emf.ecore.xcore dependency is missing.
            val dslManifestFolder = FileGenerator.createDirectory(dslFolder, "META-INF")
            content = dslManifestContent(model)
            FileGenerator.updateFile(dslManifestFolder, "MANIFEST.MF", content)
            // TODO: also only update this file, only the emf.ecore.xcore.sdk.feature.group is missing.
            val dslTargetSourceFolder = new File(config.rootLocation + "/" + config.baseName + ".target")
            content = dslTargetPlatformContent(model, false)
            FileGenerator.updateFile(dslTargetSourceFolder, config.baseName + ".target.target", content)
            // The build properties falsely add the "plugin.xml" to the binary inclusions automatically, this removes that again.
            content = generateDslBuildProperties(model)
            FileGenerator.updateFile(dslFolder, "build.properties", content)
            // The generated .ide plugin does not export the correct packages required by the also generated ui plugin, re-generate its MANIFEST.MF file
            val dslIdeFolder = new File(config.rootLocation + "/" + config.baseName + ".ide")
            content = dslIdeManifestContent(model, false)
            FileGenerator.updateFile(FileGenerator.createDirectory(dslIdeFolder, "META-INF"), "MANIFEST.MF", content)
            // The generated .ui plugin misses some imports in its Manifest as well
            val dslUiFolder = new File(config.rootLocation + "/" + config.baseName + ".ui")
            content = dslUiManifestContent(model, false)
            FileGenerator.updateFile(FileGenerator.createDirectory(dslUiFolder, "META-INF"), "MANIFEST.MF", content)
            
            // Adapt the source files of the model DSL as in thesis so that it creates a correct model readable by the synthesis.
            // RuntimeModule
            content = generateRuntimeModule(model)
            FileGenerator.updateFile(dslPackageFolder, model.name + "DslRuntimeModule.java", content)  
            // Resource
            content = generateResource(model)
            FileGenerator.updateFile(dslPackageFolder, model.name + "DslResource.xtend", content)
        }
        
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
            grammar «model.package».diff.dsl.«model.name»DiffDsl with org.eclipse.xtext.common.Terminals
            
            generate «model.name.toFirstLower»DiffDsl "«language.nsURI»/«model.name»DiffDsl"
            
            import "«model.package».model" as «model.name»Model
            
            «model.name»Diff:
                'compare' sourceModel=STRING
                'to' targetModel=STRING
            ;
        '''
        
    }
    
    private static def String generateDslGrammar(SPVizModel model, LanguageDescriptor language) {
        return '''
            grammar «model.package».model.dsl.«model.name»Dsl with org.eclipse.xtext.common.Terminals
            
            import "«model.package».model"
            import "http://www.eclipse.org/emf/2002/Ecore" as ecore
            
            «model.name»Project returns «model.name»Project:
                ('projectName' projectName=EString)?
                (
                    «FOR artifact : model.artifacts SEPARATOR " |"»
                        «artifact.name.toFirstLower»s += «artifact.name.toFirstUpper»
                    «ENDFOR»
                )*
            ;
            
            «FOR artifact : model.artifacts»
                «artifact.name.toFirstUpper» returns «artifact.name.toFirstUpper»:
                    (external?='external')?
                    '«artifact.name.toFirstLower»'
                    name=EString
                    ('{'
                        «FOR containment : artifact.references.filter(Containment)»
                            ('«containment.contains.name.toFirstLower»s:' '[' «containment.contains.name.toFirstLower»s += [«containment.contains.name.toFirstUpper»|EString] ( "," «containment.contains.name.toFirstLower»s += [«containment.contains.name.toFirstUpper»|EString])* ']' )?
                        «ENDFOR»
                        «FOR connection : artifact.references.filter(Connection)»
                            ('«connection.name.toFirstLower»' connected«connection.name.toFirstUpper»«connection.connects.name.toFirstUpper»s += [«connection.connects.name.toFirstUpper»|EString] ('«connection.name.toFirstLower»' connected«connection.name.toFirstUpper»«connection.connects.name.toFirstUpper»s += [«connection.connects.name.toFirstUpper»|EString])*)?
                        «ENDFOR»
                    '}')?
                ;
                
            «ENDFOR»
            EString returns ecore::EString:
                STRING | ID
            ;
        '''
    }
    
    private static def String generateDiffDslMwe2(SPVizModel model) {
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
    
    private static def String generateDslMwe2(SPVizModel model) {
        return '''
            module «model.package».model.dsl.Generate«model.name»Dsl
            
            import org.eclipse.xtext.xtext.generator.*
            import org.eclipse.xtext.xtext.generator.model.project.*
            
            var rootPath = ".."
            
            Workflow {
                
                component = XtextGenerator {
                    configuration = {
                        project = StandardProjectConfig {
                            baseName = "«model.package».model.dsl"
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
                        name = "«model.package».model.dsl.«model.name»Dsl"
                        fileExtensions = "«model.name.toLowerCase»dsl"
                        referencedResource = "platform:/resource/«model.package».model/model/«model.name»Model.xcore"
                        
                        fragment = ecore2xtext.Ecore2XtextValueConverterServiceFragment2 auto-inject {}
            
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
    
    private static def String dslTargetPlatformContent(SPVizModel model, boolean diff) {
        return '''
             <?xml version="1.0" encoding="UTF-8" standalone="no"?>
             <?pde version="3.8"?>
             <target name="«model.package».«diff ? "diff" : "model"».dsl.target" sequenceNumber="1">
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
             Bundle-Vendor: SPViz
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
    
    private static def String dslManifestContent(SPVizModel model) {
        return '''
             Manifest-Version: 1.0
             Bundle-ManifestVersion: 2
             Bundle-Name: «model.package».model.dsl
             Bundle-Vendor: SPViz
             Bundle-Version: 1.0.0.qualifier
             Bundle-SymbolicName: «model.package».model.dsl; singleton:=true
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
             Automatic-Module-Name: «model.package».model.dsl
             Export-Package: «model.package».model.dsl,
              «model.package».model.dsl.scoping,
              «model.package».model.dsl.services,
              «model.package».model.dsl.parser.antlr,
              «model.package».model.dsl.serializer,
              «model.package».model.dsl.validation,
              «model.package».model.dsl.generator,
              «model.package».model.dsl.parser.antlr.internal
             Import-Package: org.apache.log4j
        '''
    }
    
    private static def String dslIdeManifestContent(SPVizModel model, boolean diff) {
        val String dslPackageName = model.package + "." + (diff ? "diff" : "model") + ".dsl"
        val String idePackageName = dslPackageName + ".ide"
        val String uiPackageName = dslPackageName + ".ui"
        return '''
            Manifest-Version: 1.0
            Bundle-ManifestVersion: 2
            Bundle-Name: «idePackageName»
            Bundle-Vendor: My Company
            Bundle-Version: 1.0.0.qualifier
            Bundle-SymbolicName: «idePackageName»; singleton:=true
            Bundle-ActivationPolicy: lazy
            Require-Bundle: «dslPackageName»,
             org.eclipse.xtext.ide,
             org.eclipse.xtext.xbase.ide
            Bundle-RequiredExecutionEnvironment: JavaSE-17
            Automatic-Module-Name: «idePackageName»
            Export-Package: «idePackageName».contentassist.antlr,
             «idePackageName».contentassist.antlr.internal;x-friends:="«uiPackageName»"
        '''
    }
    
    private static def String dslUiManifestContent(SPVizModel model, boolean diff) {
        val String dslPackageName = model.package + "." + (diff ? "diff" : "model") + ".dsl"
        val String idePackageName = dslPackageName + ".ide"
        val String uiPackageName = dslPackageName + ".ui"
        return '''
            Manifest-Version: 1.0
            Bundle-ManifestVersion: 2
            Bundle-Name: «uiPackageName»
            Bundle-Vendor: SPViz
            Bundle-Version: 1.0.0.qualifier
            Bundle-SymbolicName: «uiPackageName»; singleton:=true
            Bundle-ActivationPolicy: lazy
            Require-Bundle: «dslPackageName»,
             «idePackageName»,
             org.eclipse.xtext.ui,
             org.eclipse.xtext.ui.shared,
             org.eclipse.xtext.ui.codetemplates.ui,
             org.eclipse.ui.editors;bundle-version="3.14.300",
             org.eclipse.ui.ide;bundle-version="3.18.500",
             org.eclipse.compare,
             org.eclipse.xtext.builder
            Import-Package: org.apache.log4j
            Bundle-RequiredExecutionEnvironment: JavaSE-17
            Automatic-Module-Name: «uiPackageName»
        '''
    }
    
    private static def String generateDslBuildProperties(SPVizModel model) {
        return '''
            source.. = src/,\
                       src-gen/,\
                       xtend-gen/
            bin.includes = .,\
                           META-INF/
            bin.excludes = **/*.mwe2,\
                           **/*.xtend
            additional.bundles = org.eclipse.xtext.xbase,\
                                 org.eclipse.xtext.common.types,\
                                 org.eclipse.xtext.xtext.generator,\
                                 org.eclipse.emf.codegen.ecore,\
                                 org.eclipse.emf.mwe.utils,\
                                 org.eclipse.emf.mwe2.launch,\
                                 org.eclipse.emf.mwe2.lib,\
                                 org.objectweb.asm,\
                                 org.apache.commons.logging,\
                                 org.apache.log4j
        '''
    }
    
    private static def String generateRuntimeModule(SPVizModel model) {
        return '''
            /*
             * generated by SPViz
             */
            package «model.package».model.dsl;
            
            import org.eclipse.xtext.resource.XtextResource;
            
            /**
             * Use this class to register components to be used at runtime / without the Equinox extension registry.
             */
            public class «model.name»DslRuntimeModule extends Abstract«model.name»DslRuntimeModule {
                @Override
                public Class<? extends XtextResource> bindXtextResource() {
                    return «model.name»DslResource.class;
                }
            }
        '''
    }
    
    private static def String generateResource(SPVizModel model) {
        return '''
            package «model.package».model.dsl
            
            import java.util.HashMap
            import java.util.Map
            import org.eclipse.emf.common.notify.impl.NotifyingListImpl
            import org.eclipse.xtext.linking.lazy.LazyLinkingResource
            import org.eclipse.xtext.parser.IParseResult
            «FOR artifact : model.artifacts»
                import «model.package».model.«artifact.name»
            «ENDFOR»
            
            /**
             * A customized {@link LazyLinkingResource}. Modifies the parsed model and adds an ID based on the element name.
             * 
             * @author nre & mam
             */
            class «model.name»DslResource extends LazyLinkingResource {
                
                «FOR artifact : model.artifacts»
                    public static val «artifact.name.toUpperCase»_ID_PREFIX = "«artifact.name»_"
                «ENDFOR»
                
                override void updateInternalState(IParseResult parseResult) {
                    super.updateInternalState(parseResult)
                    // Give each element a default ID based on the name if it is not explicitly set.
                    if (parseResult.rootASTElement !== null) {
                        parseResult.rootASTElement.eAllContents.forEach[ element |
                            switch (element) {
                                «FOR artifact : model.artifacts»
                                    «artifact.name»: {
                                        val «artifact.name.toFirstLower» = element as «artifact.name»
                                        if («artifact.name.toFirstLower».ecoreId === null) {
                                            «artifact.name.toFirstLower».ecoreId = «artifact.name.toUpperCase»_ID_PREFIX + «artifact.name.toFirstLower».name.toAscii
                                        }
                                        // resolve all opposite relations, as Xtext fails to properly set them up here.
                                        «FOR connection : artifact.references.filter(Connection)»
                                            «artifact.name.toFirstLower».connected«connection.name»«connection.connects.name»s.forEach [ connected |
                                                if (
                                                    !connected.connecting«connection.name»«artifact.name»s.contains(«artifact.name.toFirstLower»)
                                                    && connected.connecting«connection.name»«artifact.name»s instanceof NotifyingListImpl
                                                ) {
                                                    (connected.connecting«connection.name»«artifact.name»s as NotifyingListImpl<«artifact.name»>).basicAdd(«artifact.name.toFirstLower», null)
                                                }
                                            ]
                                        «ENDFOR»
                                        «FOR containment : artifact.references.filter(Containment)»
                                            «artifact.name.toFirstLower».«containment.contains.name.toFirstLower»s.forEach [ «containment.contains.name.toFirstLower» |
                                                if (
                                                    !«containment.contains.name.toFirstLower».«artifact.name.toFirstLower»s.contains(«artifact.name.toFirstLower»)
                                                    && «containment.contains.name.toFirstLower».«artifact.name.toFirstLower»s instanceof NotifyingListImpl
                                                ) {
                                                    («containment.contains.name.toFirstLower».«artifact.name.toFirstLower»s as NotifyingListImpl<«artifact.name»>).basicAdd(«artifact.name.toFirstLower», null)
                                                }
                                            ]
                                        «ENDFOR»
                                    }
                                «ENDFOR»
                                default: {
                                    // nop
                                }
                            }
                        ]
                    }
                }
                
                /**
                 * Converts the given name to an ACII string save for using in an Ecore ID.
                 * German umlauts are converted to their long form counterparts (e.g., ä->ae)
                 * and special characters not in the alphabet are replaced by underscores (_).
                 * 
                 * @param name The name to convert to an ASCII string
                 * @return An ASCII-only version of the string.
                 */
                def private String toAscii(String name) {
                    if (name === null) return null
                    
                    val Map<Character, String> mappings = new HashMap
                    mappings.put('Ä', "Ae")
                    mappings.put('ä', "ae")
                    mappings.put('Ö', "Oe")
                    mappings.put('ö', "oe")
                    mappings.put('Ü', "Ue")
                    mappings.put('ü', "ue")
                    mappings.put('ẞ', "Ss")
                    mappings.put('ß', "ss")
                    
                    val StringBuilder sb = new StringBuilder()
                    name.chars().forEachOrdered([character |
                        // Replace all known mappings to readable allowable ID substrings
                        
                        // character literals in xtend are dumb ~ nre mam
                        val char A = 'A'
                        val char Z = 'Z'
                        val char a = 'a'
                        val char z = 'z'
                        val char dot = '.'
                        val char dash = '-'
                        
                        if (mappings.containsKey(character as char)) {
                            sb.append(mappings.get(character as char))
                        // Keep all A-Z,a-z and .- the same.
                        } else if (character >= A && character <= Z || character >= a && character <= z || character === dot || character === dash) {
                            sb.append(character as char)
                        // Replace all other characters by _
                        } else {
                            sb.append('_')
                        }
                    ])
                    
                    return sb.toString();
                }
                
            }
        '''
    }
}
