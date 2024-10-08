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
}