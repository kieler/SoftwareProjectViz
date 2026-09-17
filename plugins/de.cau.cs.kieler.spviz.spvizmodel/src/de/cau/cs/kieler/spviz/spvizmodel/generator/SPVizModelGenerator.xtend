/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020-2026 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * + and Scheidt & Bachmann System Technik GmbH, 24109 Melsdorf
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Containment
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import java.io.File
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.util.ArrayList
import java.util.LinkedHashMap
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.mwe2.launch.runtime.Mwe2Launcher
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.URIConverter
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
            LOGGER.info("Generating difference DSL")
            // Generate DiffDSL
            val CliProjectsCreator creator = new CliProjectsCreator()
            val WizardConfiguration config = new WizardConfiguration() => [
                rootLocation = rootPath.toAbsolutePath.toString
                baseName = model.package + ".diff.dsl"
                language.name = baseName + "." + model.name + "DiffDsl"
                language.fileExtensions = FileExtensions.fromString(model.name.toLowerCase + "diff")
                preferredBuildSystem = BuildSystem.MAVEN
                javaVersion = JavaVersion.JAVA21
                runtimeProject.withPluginXml = false
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
            
            // Execute Xtext generation workflow and configure new dependencies
            val diffDslMwe2File = new File(diffDslPackageFolder, "Generate" + model.name + "DiffDsl.mwe2")
            configureMwe2(diffDslMwe2File, config.language.name, model)
            runMwe2(diffDslMwe2File, rootPath, model)
            configureDslManifest(new File(diffDslFolder, "META-INF/MANIFEST.MF"), model)
            configureDslTargetPlatform(new File(config.rootLocation + "/" + config.baseName + ".target/" + config.baseName + ".target.target"))
        }
        
        if (noModelDsl) {
            LOGGER.info("Skip generating model DSL.")
        } else {
            LOGGER.info("Generating model DSL")
            // Generate model DSL
            val CliProjectsCreator creator = new CliProjectsCreator()
            val WizardConfiguration config = new WizardConfiguration() => [
                rootLocation = rootPath.toAbsolutePath.toString
                baseName = model.package + ".model.dsl"
                language.name = baseName + "." + model.name + "Dsl"
                language.fileExtensions = FileExtensions.fromString(model.name.toLowerCase + "dsl")
                preferredBuildSystem = BuildSystem.MAVEN
                javaVersion = JavaVersion.JAVA21
                runtimeProject.withPluginXml = false
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
            var content = generateDslGrammar(model)
            FileGenerator.updateFile(dslPackageFolder, model.name + "Dsl.xtext", content)
            
            // Execute Xtext generation workflow and configure new dependencies
            val dslMwe2File = new File(dslPackageFolder, "Generate" + model.name + "Dsl.mwe2")
            configureMwe2(dslMwe2File, config.language.name, model)
            runMwe2(dslMwe2File, rootPath, model)
            configureDslManifest(new File(dslFolder, "META-INF/MANIFEST.MF"), model)
            configureDslTargetPlatform(new File(config.rootLocation + "/" + config.baseName + ".target/" + config.baseName + ".target.target"))
            
            // Adapt the source files of the model DSL as in thesis so that it creates a correct model readable by the synthesis.
            // RuntimeModule
            content = generateRuntimeModule(model)
            FileGenerator.updateFile(dslPackageFolder, model.name + "DslRuntimeModule.java", content)  
            // Resource
            content = generateResource(model)
            FileGenerator.updateFile(dslPackageFolder, model.name + "DslResource.xtend", content)
            // Validator
            val dslValidationFolder = FileGenerator.createDirectory(dslFolder, "src/" + config.baseName.replace('.', '/') + "/validation")
            content = generateDslValidator(model)
            FileGenerator.updateFile(dslValidationFolder, model.name + "DslValidator.java", content)
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
            /**
             * Managed by ModelUtil.add... methods. Modify this list only when importing or transforming a model.
             */
            contains ConnectionLabel[] connectionLabels
        }
        
        abstract class ConnectionLabel {
            String label
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
        «FOR artifact : model.artifacts»
            «FOR connection : artifact.references.filter(Connection)»
                class «directLabelClassName(artifact, connection)» extends ConnectionLabel {
                    refers «connection.connects.name» target
                }

                class «contextLabelClassName(artifact, connection)» extends ConnectionLabel {
                    refers «artifact.name» source
                    refers «connection.connects.name» target
                }

            «ENDFOR»
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
    
    private static def String generateDslGrammar(SPVizModel model) {
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
                            ('«connection.name.toFirstLower»' connectionLabels += «directLabelClassName(artifact, connection)»)*
                        «ENDFOR»
                        ('labels' '{' connectionLabels += ContextConnectionLabel* '}')?
                    '}')?
                ;
                
            «ENDFOR»
            ContextConnectionLabel returns ConnectionLabel:
                «FOR connection : model.artifacts.flatMap[references.filter(Connection)] SEPARATOR " |"»
                    «contextLabelClassName(connection.eContainer as Artifact, connection)»
                «ENDFOR»
            ;

            «FOR artifact : model.artifacts»
                «FOR connection : artifact.references.filter(Connection)»
                    «directLabelClassName(artifact, connection)» returns «directLabelClassName(artifact, connection)»:
                        target=[«connection.connects.name.toFirstUpper»|EString] (label=EString)?
                    ;

                    «contextLabelClassName(artifact, connection)» returns «contextLabelClassName(artifact, connection)»:
                        '«connection.name.toFirstLower»' source=[«artifact.name.toFirstUpper»|EString] '->'
                        target=[«connection.connects.name.toFirstUpper»|EString] label=EString
                    ;

                «ENDFOR»
            «ENDFOR»
            EString returns ecore::EString:
                STRING | ID
            ;
        '''
    }

    private static def String generateDslValidator(SPVizModel model) {
        return '''
            package «model.package».model.dsl.validation;

            import «model.package».model.ConnectionLabel;
            import org.eclipse.emf.ecore.EObject;
            import org.eclipse.emf.ecore.EStructuralFeature;
            import org.eclipse.xtext.validation.Check;

            public class «model.name»DslValidator extends Abstract«model.name»DslValidator {

                @Check
                public void checkContextLabelEndpoints(ConnectionLabel label) {
                    EStructuralFeature sourceFeature = label.eClass().getEStructuralFeature("source");
                    EStructuralFeature targetFeature = label.eClass().getEStructuralFeature("target");
                    if (sourceFeature == null || targetFeature == null) {
                        return;
                    }
            
                    EObject context = label.eContainer();
                    EObject source = (EObject) label.eGet(sourceFeature);
                    EObject target = (EObject) label.eGet(targetFeature);
                    if (!contains(context, source) || !contains(context, target)) {
                        error("Context label source and target must both be contained in the label context.", label, targetFeature);
                    }
                }
            
                private static boolean contains(EObject context, EObject element) {
                    if (context == element) {
                        return true;
                    }
                    for (EObject reference : context.eCrossReferences()) {
                        if (reference == element) {
                            return true;
                        }
                    }
                    return false;
                }
            }
        '''
    }
    
    /**
     * Add "modelResource" variable to the workflows so that programmatic workflow runs in the CLI can run the workflow with non-platform resource.
     */
    private static def void configureMwe2(File mwe2File, String languageName, SPVizModel model) {
        val modelResourceDeclaration = "var modelResource = \"platform:/resource/" + model.package + ".model/model/" + model.name + "Model.xcore\""
        FileGenerator.addIfMissing(
            mwe2File,
            modelResourceDeclaration,
            "var rootPath = \"..\"",
            "\n" + modelResourceDeclaration
        )
        val referencedResource = "referencedResource = modelResource"
        FileGenerator.addIfMissing(
            mwe2File,
            referencedResource,
            "name = \"" + languageName + "\"",
            "\n" + FileGenerator.indent(referencedResource, 3)
        )
    }
    
    /**
     * Runs the Mwe2 Xtext workflow with the locally-generated resources.
     */
    private static def void runMwe2(File workflowFile, Path rootPath, SPVizModel model) {
        registerPlatformResources()
        val modelFile = new File(rootPath.toAbsolutePath.toFile, model.package + ".model/model/" + model.name + "Model.xcore")
        val String[] arguments = #[
            workflowFile.toURI.toString,
            "-p",
            "rootPath=" + rootPath.toAbsolutePath.toString,
            "-p",
            "modelResource=" + modelFile.toURI.toString
        ]
        LOGGER.info("Generating Xtext infrastructure from {}", workflowFile)
        new Mwe2Launcher().run(arguments)
    }
    
    /**
     * Re-registers Xtext and EMF platform resources to be usable within non-platform executions.
     */
    private static def void registerPlatformResources() {
        registerBundledResource(
            "platform:/resource/org.eclipse.emf.ecore/model/Ecore.genmodel",
            "/model/Ecore.genmodel"
        )
        registerBundledResource(
            "platform:/resource/org.eclipse.xtext.common.types/model/JavaVMTypes.genmodel",
            "/model/JavaVMTypes.genmodel"
        )
        registerBundledResource(
            "platform:/resource/org.eclipse.xtext.xbase/model/Xbase.genmodel",
            "/model/Xbase.genmodel"
        )
        registerBundledResource(
            "platform:/resource/org.eclipse.emf.ecore/model/Ecore.ecore",
            "/model/Ecore.ecore"
        )
        registerBundledResource(
            "platform:/resource/org.eclipse.xtext.common.types/model/JavaVMTypes.ecore",
            "/model/JavaVMTypes.ecore"
        )
        registerBundledResource(
            "platform:/resource/org.eclipse.xtext.xbase/model/XAnnotations.ecore",
            "/model/XAnnotations.ecore"
        )
        registerBundledResource(
            "platform:/resource/org.eclipse.xtext.xbase/model/Xtype.ecore",
            "/model/Xtype.ecore"
        )
        registerBundledResource(
            "platform:/resource/org.eclipse.xtext.xbase/model/Xbase.ecore",
            "/model/Xbase.ecore"
        )
        registerBundledResource(
            "platform:/resource/org.eclipse.emf.ecore.xcore.lib/model/XcoreLang.xcore",
            "/model/XcoreLang.xcore"
        )
    }
    
    private static def void registerBundledResource(String platformUri, String classpathUri) {
        val resource = typeof(SPVizModelGenerator).getResource(classpathUri)
        if (resource !== null) {
            URIConverter.URI_MAP.put(URI.createURI(platformUri), URI.createURI(resource.toString))
        }
    }
    
    private static def void configureDslTargetPlatform(File targetFile) {
        FileGenerator.addIfMissing(
            targetFile,
            "org.eclipse.emf.ecore.xcore.sdk.feature.group",
            "<unit id=\"org.eclipse.emf.sdk.feature.group\" version=\"0.0.0\"/>",
            "\n" + FileGenerator.indent('<unit id="org.eclipse.emf.ecore.xcore.sdk.feature.group" version="0.0.0"/>', 3)
        )
    }
    
    /**
     * Configure missing dependencies for the DSL projects.
     */
    private static def void configureDslManifest(File manifestFile, SPVizModel model) {
        val xcoreDependency = "org.eclipse.emf.ecore.xcore"
        FileGenerator.addIfMissing(
            manifestFile,
            xcoreDependency,
            "Require-Bundle: ",
            xcoreDependency + ",\n "
        )
        val modelBundle = model.package + ".model"
        FileGenerator.addIfMissing(
            manifestFile,
            modelBundle + ",",
            "Require-Bundle: ",
            modelBundle + ",\n "
        )
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
            «FOR artifact : model.artifacts»
                «FOR connection : artifact.references.filter(Connection)»
                    import «model.package».model.«directLabelClassName(artifact, connection)»
                «ENDFOR»
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
                                        // The generated model DSL stores direct connection declarations as label records.
                                        // Restore the existing inverse connection references from those records.
                                        «FOR connection : artifact.references.filter(Connection)»
                                            «artifact.name.toFirstLower».connectionLabels.filter(«directLabelClassName(artifact, connection)»).forEach [ label |
                                                if (
                                                    !«artifact.name.toFirstLower».connected«connection.name»«connection.connects.name»s.contains(label.target)
                                                    && «artifact.name.toFirstLower».connected«connection.name»«connection.connects.name»s instanceof NotifyingListImpl
                                                ) {
                                                    («artifact.name.toFirstLower».connected«connection.name»«connection.connects.name»s as NotifyingListImpl<«connection.connects.name»>).basicAdd(label.target, null)
                                                }
                                            ]
                                        «ENDFOR»
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
                 * Converts the given name to an ASCII string save for using in an Ecore ID.
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
                        
                        // Xtend needs to know these are char types for a proper char-as-number comparison below.
                        val char A = 'A'
                        val char Z = 'Z'
                        val char a = 'a'
                        val char z = 'z'
                        val char dot = '.'
                        val char dash = '-'
                        val char zero = '0'
                        val char one = '1'
                        val char nine = '9'
                        
                        if (mappings.containsKey(character as char)) {
                            sb.append(mappings.get(character as char))
                        // Keep all A-Z,a-z,0-9 and .- the same.
                        } else if (character >= A && character <= Z || 
                            character >= a && character <= z ||
                            character === dot ||
                            character === dash ||
                            character === zero ||
                            character >= one && character <= nine) {
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

    private static def String directLabelClassName(Artifact artifact, Connection connection) {
        return artifact.name.toFirstUpper + "Connects" + connection.connects.name.toFirstUpper + "Named"
            + connection.name.toFirstUpper + "Label"
    }

    private static def String contextLabelClassName(Artifact artifact, Connection connection) {
        return artifact.name.toFirstUpper + "Connects" + connection.connects.name.toFirstUpper + "Named"
            + connection.name.toFirstUpper + "ContextLabel"
    }
}
