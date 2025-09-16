/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2025 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import java.io.File

/**
 * Generates classes for the dual difference visualization.
 * 
 * @author nre
 */
class GenerateDiffViz {
    def static void generate(File sourceFolder, DataAccess data) {
        val File folder = FileGenerator.createDirectory(sourceFolder, data.getBundleNamePrefix.replace('.','/') + "/diffviz")
        
        FileGenerator.updateFile(folder, data.visualizationName.toFirstUpper + "DiffDiagramSynthesis.xtend",
            generateDiffVizDiagramSynthesis(data))
        FileGenerator.updateFile(folder, "KlighdSetup.xtend", generateKlighdSetup(data))
        FileGenerator.updateFile(folder, "DiffSynthesisProperties.xtend", generateDiffSynthesisProperties(data))
    }
    
    /**
     * Generates the content for the diagram synthesis to show two models next to each other and to compare them.
     * 
     * @param data
     *      a DataAccess to easily get the information from
     * @return 
     *      the generated file content as a string
     */
    def static String generateDiffVizDiagramSynthesis(DataAccess data) {
        return '''
           package «data.bundleNamePrefix».diffviz
           
           import com.google.inject.Inject
           import de.cau.cs.kieler.klighd.kgraph.KNode
           import de.cau.cs.kieler.klighd.krendering.ViewSynthesisShared
           import de.cau.cs.kieler.klighd.krendering.extensions.KEdgeExtensions
           import de.cau.cs.kieler.klighd.krendering.extensions.KNodeExtensions
           import de.cau.cs.kieler.klighd.krendering.extensions.KRenderingExtensions
           import de.cau.cs.kieler.klighd.syntheses.AbstractDiagramSynthesis
           import de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses
           import «data.modelBundleNamePrefix».diff.dsl.«data.spvizModel.name.toFirstLower»DiffDsl.«data.spvizModel.name.toFirstUpper»Diff
           import «data.modelBundleNamePrefix».model.«data.projectName»
           import «data.bundleNamePrefix».viz.«data.projectName»DiagramSynthesis
           import org.eclipse.elk.alg.layered.options.LayeredOptions
           import org.eclipse.elk.core.options.CoreOptions
           import org.eclipse.elk.core.options.Direction
           import org.eclipse.emf.common.util.URI
           import org.eclipse.emf.ecore.resource.Resource
           import org.eclipse.xtext.resource.XtextResourceSet
           
           @ViewSynthesisShared
           class «data.visualizationName.toFirstUpper»DiffDiagramSynthesis extends AbstractDiagramSynthesis<«data.spvizModel.name.toFirstUpper»Diff> {
               @Inject extension KNodeExtensions
               @Inject extension KEdgeExtensions
               @Inject extension KRenderingExtensions
               
               @Inject «data.projectName»DiagramSynthesis «data.projectName.toFirstLower»DiagramSynthesis
               
               override KNode transform(«data.spvizModel.name.toFirstUpper»Diff model) {
                   val root = model.createNode().associateWith(model)
                    
                   val resource = model.eResource
                   // Find out where this files is located. The comparison files are interpreted relative to this path.
                   val fileString = resource.URI.toString
                   val folderString = fileString.substring(0, fileString.lastIndexOf('/'))
                   
                   // In the following, exceptions can occur if the model at the given path is not loadable.
                   // Load the source model
                   val XtextResourceSet rs = new XtextResourceSet  
                   
                   var source«data.projectName» = usedContext.getProperty(DiffSynthesisProperties.SOURCE_«data.spvizModel.name.toUpperCase»_MODEL)
                   if (source«data.projectName» === null) {
                       
                       val Resource source = rs.createResource(URI.createURI(folderString + "/" + model.sourceModel))
                       source.load(rs.getLoadOptions())
                       source«data.projectName» = source.contents.head as «data.projectName»
                       
                       usedContext.setProperty(DiffSynthesisProperties.SOURCE_«data.spvizModel.name.toUpperCase»_MODEL, source«data.projectName»)
                   }
                   
                   var target«data.projectName» = usedContext.getProperty(DiffSynthesisProperties.TARGET_«data.spvizModel.name.toUpperCase»_MODEL)
                   if (target«data.projectName» === null) {
                       
                       val Resource target = rs.createResource(URI.createURI(folderString + "/" + model.targetModel))
                       target.load(rs.getLoadOptions())
                       target«data.projectName» = target.contents.head as «data.projectName»
                       usedContext.setProperty(DiffSynthesisProperties.TARGET_«data.spvizModel.name.toUpperCase»_MODEL, target«data.projectName»)
                       
                   }
                   
                   val source«data.projectName»_ = source«data.projectName»
                   val target«data.projectName»_ = target«data.projectName»
                   
                   root.children += createNode => [
                       addRectangle => [ invisible = true ]
                       associateWith(model)
                       DiagramSyntheses.setLayoutOption(it, CoreOptions::ALGORITHM, "org.eclipse.elk.layered")
                       setLayoutOption(LayeredOptions.DIRECTION, Direction.RIGHT)
                       «data.projectName.toFirstLower»DiagramSynthesis.targetModel = target«data.projectName»_
                       «data.projectName.toFirstLower»DiagramSynthesis.sourceModel = source«data.projectName»_
                       
                       // display both «data.projectName»s and tell their synthesis which model is which
                          «data.projectName.toFirstLower»DiagramSynthesis.other = false
                       
                       val overviewSource«data.projectName»Node = «data.projectName.toFirstLower»DiagramSynthesis.transform(source«data.projectName»_, usedContext)
                       children += overviewSource«data.projectName»Node
                       
                       «data.projectName.toFirstLower»DiagramSynthesis.other = true
                       
                       val overviewTarget«data.projectName»Node = «data.projectName.toFirstLower»DiagramSynthesis.transform(target«data.projectName»_, usedContext)
                       children += overviewTarget«data.projectName»Node
                       
                       val edge = createEdge(source«data.projectName»_, target«data.projectName»_) => [
                           addPolyline => [ invisible = true ]
                           source = overviewSource«data.projectName»Node
                           target = overviewTarget«data.projectName»Node
                       ]
                       overviewSource«data.projectName»Node.outgoingEdges.add(edge)
                       
                       ]
                   return root
               }
           }
           
        '''
    }
    
    /**
     * Generates the content for the KLighD setup.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return 
     *         the generated file content as a string
     */
    def static String generateKlighdSetup(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».diffviz
            
            import de.cau.cs.kieler.klighd.IKlighdStartupHook
            import de.cau.cs.kieler.klighd.KlighdDataManager
            
            /**
             * Setup registering all KLighD extensions required to run this bundle.
             */
            class KlighdSetup implements IKlighdStartupHook {
                override execute() {
                    KlighdDataManager.instance
                        .registerDiagramSynthesisClass(«data.visualizationName.toFirstUpper»DiffDiagramSynthesis.name, «data.visualizationName.toFirstUpper»DiffDiagramSynthesis)
                }
            }
            
        '''
    }
    
    /**
     * Generates the content for DiffSynthesisProperties class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return 
     *         the generated file content as a string
     */
    def static String generateDiffSynthesisProperties(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».diffviz
            
            import «data.modelBundleNamePrefix».model.«data.projectName»
            import org.eclipse.elk.graph.properties.IProperty
            import org.eclipse.elk.graph.properties.Property
            
            /**
             * Class to provide easy access to properties stored for the diff syntheses.
             */
            class DiffSynthesisProperties {
                /** 
                 * Property that stores the view context of the source model. Used to remember already loaded synthesis.
                 */
                 public static final IProperty<«data.projectName»> SOURCE_«data.spvizModel.name.toUpperCase»_MODEL = new Property<«data.projectName»>("«data.spvizModel.name.toFirstLower»diff.sourceModel",null)
                
                /**
                 * Property that stores the view context of the target model. Used to remember already loaded synthesis.
                 */
                 
                 public static final IProperty<«data.projectName»> TARGET_«data.spvizModel.name.toUpperCase»_MODEL = new Property<«data.projectName»>("«data.spvizModel.name.toFirstLower»diff.targetModel",null)
                
                }
            
        '''
    }
    
}