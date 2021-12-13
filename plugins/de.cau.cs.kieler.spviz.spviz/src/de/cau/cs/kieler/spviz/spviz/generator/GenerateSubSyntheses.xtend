/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spviz.sPViz.View
import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact
import org.eclipse.core.resources.IFolder
import org.eclipse.core.runtime.IProgressMonitor

import static extension de.cau.cs.kieler.spviz.spvizmodel.util.SPVizModelExtension.*

/**
 * Generates sub syntheses classes for overviews and their contained artifacts.
 * 
 * @author leo, nre
 */
class GenerateSubSyntheses {
    def static void generate(IFolder sourceFolder, DataAccess data, IProgressMonitor progressMonitor) {
        
        val bundleNamePrefix = data.getBundleNamePrefix
        val folder = bundleNamePrefix.replace('.', '/') + "/viz/subsyntheses/"
        for (artifact : data.artifacts) {
            var content = generateSimpleSynthesis(bundleNamePrefix, artifact.name)
            FileGenerator.generateOrUpdateFile(sourceFolder, folder + "Simple" + artifact.name + "Synthesis.xtend", content,
                progressMonitor)

            content = generateSynthesis(artifact, data)
            FileGenerator.generateOrUpdateFile(sourceFolder, folder + artifact.name + "Synthesis.xtend", content,
                progressMonitor)
        }
        for (view : data.views) {
            val content = generateOverviewSythesis(view, data)
            FileGenerator.generateOrUpdateFile(sourceFolder, folder + view.name + "OverviewSynthesis.xtend", content,
                progressMonitor)
        }
    }

    /**
     * Generates the overview syntheses contend for a given overview.
     * 
     * @param overview
     *         the overview name as a string
     * @param data
     *         a DataAccess to easily get the information from
     * @return 
     *         the generated file content as a string
     */
    def static String generateOverviewSythesis(View view, DataAccess data) {
        val viewName = view.name
        return '''
            package «data.getBundleNamePrefix».viz.subsyntheses
            
            import com.google.inject.Inject
            import de.cau.cs.kieler.klighd.kgraph.KGraphFactory
            import de.cau.cs.kieler.klighd.kgraph.KNode
            import de.cau.cs.kieler.klighd.krendering.extensions.KEdgeExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KNodeExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KRenderingExtensions
            import de.cau.cs.kieler.klighd.syntheses.AbstractSubSynthesis
            import de.cau.cs.kieler.klighd.kgraph.KIdentifier
            import java.util.EnumSet
            import java.util.List
            import org.eclipse.elk.core.math.ElkPadding
            import org.eclipse.elk.core.options.CoreOptions
            import org.eclipse.elk.core.options.Direction
            import org.eclipse.elk.core.options.SizeConstraint
            import «data.getBundleNamePrefix».model.«viewName»OverviewContext
            import «data.getBundleNamePrefix».viz.SynthesisUtils
            «FOR shownElement : view.shownElements»
                import «data.getBundleNamePrefix».model.«shownElement.shownElement.name»Context
            «ENDFOR»
            import «data.getBundleNamePrefix».viz.Styles

            
            import static extension de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses.*
            import static extension «data.getBundleNamePrefix».viz.SynthesisUtils.*
            import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
            
            /**
             * Transformation as an overview of all «viewName.toFirstLower»s in the given list of «viewName.toFirstLower»s.
             */
            class «viewName»OverviewSynthesis extends AbstractSubSynthesis<«viewName»OverviewContext, KNode> {
                @Inject extension KEdgeExtensions
                @Inject extension KNodeExtensions
                @Inject extension KRenderingExtensions
                @Inject extension Styles
                «FOR shownElement : view.shownElements»
                    @Inject Simple«shownElement.shownElement.name»Synthesis simple«shownElement.shownElement.name»Synthesis
                    @Inject «shownElement.shownElement.name»Synthesis «shownElement.shownElement.name.toFirstLower»Synthesis
                «ENDFOR»
                extension KGraphFactory = KGraphFactory.eINSTANCE
                
                override transform(«viewName»OverviewContext «viewName.toFirstLower»OverviewContext) {
                    return #[
                        createNode => [
                            associateWith(«viewName.toFirstLower»OverviewContext)
                            data += createKIdentifier => [ it.id = «viewName.toFirstLower»OverviewContext.hashCode.toString ]
                            if («viewName.toFirstLower»OverviewContext.expanded) {
                                initiallyExpand
                            } else {
                                initiallyCollapse
                            }
                            setLayoutOption(it, CoreOptions::ALGORITHM, "org.eclipse.elk.layered")
                            setLayoutOption(it, CoreOptions::DIRECTION, Direction.DOWN)
                            setLayoutOption(CoreOptions::NODE_SIZE_CONSTRAINTS, EnumSet.of(SizeConstraint.MINIMUM_SIZE))
                            addOverviewRendering("«viewName»", «viewName.toFirstLower»OverviewContext.overviewText, «!view.shownConnections.empty», usedContext)
                            
                            // remove the padding of the invisible container.
                            addLayoutParam(CoreOptions.PADDING, new ElkPadding(0, 0, 0, 0))
                            
                            // Add all simple «viewName.toFirstLower» renderings in a first subgraph (top)
                            val collapsedOverviewNode = transformCollapsed«viewName»Overview(«viewName.toFirstLower»OverviewContext)
                            children += collapsedOverviewNode
                            
                            // Add all detailed «viewName.toFirstLower» renderings and their connections in a second subgraph (bottom)
                            val detailedOverviewNode = transformDetailed«viewName»Overview(«viewName.toFirstLower»OverviewContext)
                            children += detailedOverviewNode
                            
                            // Put an invisible edge between the collapsed and detailed overviews to guarantee the simple renderings
                            // are above the detailed ones.
                            collapsedOverviewNode.outgoingEdges += createEdge => [
                                addPolyline => [
                                    invisible = true
                                ]
                                target = detailedOverviewNode
                            ]
                        ]
                    ]
                }
                
                /**
                 * The top part of the «viewName.toFirstLower» overview rendering containing all collapsed «viewName.toFirstLower» renderings in a box layout.
                 * 
                 * @param «viewName.toFirstLower»OverviewContext The overview context for all «viewName.toFirstLower»s in this subsynthesis.
                 */
                private def KNode transformCollapsed«viewName»Overview(«viewName»OverviewContext «viewName.toFirstLower»OverviewContext) {
                    «FOR shownElement : view.shownElements»
                        val filteredCollapsed«shownElement.shownElement.name»Contexts = filteredElementContexts(
                            «viewName.toFirstLower»OverviewContext.collapsed«shownElement.shownElement.name»Contexts as List<«shownElement.shownElement.name»Context>, usedContext).toList
                    «ENDFOR»
                    createNode => [
                        associateWith(«viewName.toFirstLower»OverviewContext)
                        configureBoxLayout
                        addInvisibleContainerRendering
                        tooltip = «viewName.toFirstLower»OverviewContext.overviewText
                        
                        «FOR shownElement : view.shownElements»
                            // all «shownElement.shownElement.name»s
                            filteredCollapsed«shownElement.shownElement.name»Contexts.sortBy [
                                SynthesisUtils.getId(modelElement.name, usedContext)
                            ].forEach [ collapsed«shownElement.shownElement.name»Context, index |
                                children += simple«shownElement.shownElement.name»Synthesis.transform(
                                    collapsed«shownElement.shownElement.name»Context as «shownElement.shownElement.name»Context, -index)
                            ]
                        «ENDFOR»
                    ]
                }
                
                /**
                 * The bottom part of the «viewName.toFirstLower» overview rendering containing all detailed «viewName.toFirstLower» renderings and their
                 * connections in a layered layout.
                 * 
                 * @param «viewName.toFirstLower»OverviewContext The overview context for all «viewName.toFirstLower»s in this subsynthesis.
                 */
                private def KNode transformDetailed«viewName»Overview(«viewName»OverviewContext «viewName.toFirstLower»OverviewContext) {
                    «FOR shownElement : view.shownElements»
                        val filteredDetailed«shownElement.shownElement.name»Contexts = filteredElementContexts(
                            «viewName.toFirstLower»OverviewContext.detailed«shownElement.shownElement.name»Contexts, usedContext)
                    «ENDFOR»
                    createNode => [
                        associateWith(«viewName.toFirstLower»OverviewContext)
                        configureOverviewLayout
                        addInvisibleContainerRendering
                        tooltip = «viewName.toFirstLower»OverviewContext.overviewText
                        
                        «FOR shownElement : view.shownElements»
                            children += filteredDetailed«shownElement.shownElement.name»Contexts.flatMap [
                                return «shownElement.shownElement.name.toFirstLower»Synthesis.transform(it as «shownElement.shownElement.name»Context)
                            ]
                        «ENDFOR»
                        
«««                        TODO: correct way around?
                        «FOR shownConnection : view.shownConnections»
                            // Add all by «shownConnection.shownConnection.requiring.name.toFirstLower»s required «shownConnection.shownConnection.required.name.toFirstLower»s edges.
                            «viewName.toFirstLower»OverviewContext.required«shownConnection.shownConnection.requiring.name»Requires«shownConnection.shownConnection.required.name»Named«shownConnection.shownConnection.name»Edges.forEach [
«««                            // Connects the {@code sourceBundleNode} and the {@code usedByBundleNode} via an arrow in UML style,
«««                            // so [usedByBundleNode] ----- uses -----> [sourceBundleNode]
                                val requiring = key
                                val required = value
                                if (!nodeExists(requiring) || !nodeExists(required)) {
                                    // Only Add edges if the nodes are actually shown.
                                    return
                                }
                                val requiringNode = requiring.node
                                val requiredNode = required.node
                                val requiringPort = requiringNode.ports.findFirst [
                                    data.filter(KIdentifier).head?.id === "required«shownConnection.shownConnection.name»«shownConnection.shownConnection.required.name»s"
                                ]
                                val requiredPort = requiredNode.ports.findFirst [
                                    data.filter(KIdentifier).head?.id === "requiring«shownConnection.shownConnection.name»«shownConnection.shownConnection.requiring.name»s"
                                ]
                                
                                val edge = createEdge(requiring, required) => [
                                    addRequired«shownConnection.shownConnection.requiring.name»Requires«shownConnection.shownConnection.required.name»Named«shownConnection.shownConnection.name»EdgeRendering
                                    sourcePort = requiringPort
                                    targetPort = requiredPort
                                    source = requiringNode
                                    target = requiredNode
                                ]
                                requiringNode.outgoingEdges += edge
                                requiredNode.incomingEdges += edge
                            ]
                        «ENDFOR»
                    ]
                }
                
            }
            
        '''
    }
    
    /**
     * Generates the syntheses contend for a given artifact.
     * 
     * @param artifact
     *         the artifact name as a string
     * @param data
     *         a DataAccess to easily get the information from
     * @return 
     *         the generated file content as a string
     */
    def static String generateSynthesis(Artifact artifact, DataAccess data) {
        val artifactName = artifact.name
        val views = data.getViews(artifact)
        return '''
            package «data.getBundleNamePrefix».viz.subsyntheses
            
            import com.google.inject.Inject
            import de.cau.cs.kieler.klighd.kgraph.KGraphFactory
            import de.cau.cs.kieler.klighd.kgraph.KNode
            import de.cau.cs.kieler.klighd.krendering.extensions.KNodeExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KPortExtensions
            import de.cau.cs.kieler.klighd.syntheses.AbstractSubSynthesis
            import «data.modelBundleNamePrefix».model.«artifactName»
            «FOR required : data.getRequiredArtifacts(artifact)»
                «IF required.required !== artifact»
                    import «data.modelBundleNamePrefix».model.«required.required.name»
                «ENDIF»
            «ENDFOR»
            «FOR requiring : data.getRequiringArtifacts(artifact)»
                «IF requiring.requiring !== artifact»
                    import «data.modelBundleNamePrefix».model.«requiring.requiring.name»
                «ENDIF»
            «ENDFOR»
            import «data.modelBundleNamePrefix».model.«data.projectName»
            import «data.getBundleNamePrefix».viz.SynthesisUtils
            import «data.getBundleNamePrefix».viz.Styles
            import «data.getBundleNamePrefix».model.«artifactName»Context
            import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
            «FOR view : views»
                import «data.bundleNamePrefix».model.«view.name»OverviewContext
            «ENDFOR»
            import org.eclipse.elk.core.options.CoreOptions
            import org.eclipse.elk.core.options.PortConstraints
            import org.eclipse.elk.core.options.PortSide
            
            /**
             * Sub-synthesis of {@link «data.projectName»}s that handles expanded {@link «artifactName»} views.
             */
            class «artifactName»Synthesis extends AbstractSubSynthesis<«artifactName»Context, KNode> {
                @Inject extension KNodeExtensions
                @Inject extension KPortExtensions
                @Inject extension Styles
                extension KGraphFactory = KGraphFactory.eINSTANCE
                
                override transform(«artifactName»Context context) {
                    val «artifactName.toFirstLower» = context.modelElement
                    return #[
                        context.createNode() => [
                            addLayoutParam(CoreOptions::PORT_CONSTRAINTS, PortConstraints::FIXED_ORDER)
                            associateWith(context)
                            data += createKIdentifier => [ it.id = context.hashCode.toString ]
                            
                            «FOR required : data.getRequiredArtifacts(artifact)»
                            val filteredRequired«required.required.name»s = SynthesisUtils.filteredElements(«artifactName.toFirstLower».required«required.name»«required.required.name»s,
                                context.parent as IOverviewVisualizationContext<«required.required.name»>, usedContext)
                            if (!filteredRequired«required.required.name»s.empty) {
                                ports += createPort(context, "required«required.name»«required.required.name»s") => [
                                    associateWith(context)
                                    data += createKIdentifier => [ it.id = "required«required.name»«required.required.name»s" ]
                                    // Required «artifactName.toFirstLower»s are always shown and expanded to the east with the drawing direction.
                                    addLayoutParam(CoreOptions::PORT_SIDE, PortSide::EAST)
                                    addLayoutParam(CoreOptions::PORT_INDEX, 0)
                                    addRequired«required.requiring.name»Requires«required.required.name»Named«required.name»ActionPortRendering(filteredRequired«required.required.name»s.size, context.allRequired«required.requiring.name»Requires«required.required.name»Named«required.name»Shown)
                                    width = 12
                                    height = 12
                                ]
                            }
                            
                            «ENDFOR»
                            «FOR requiring : data.getRequiringArtifacts(artifact)»
                            val filteredRequiring«requiring.requiring.name»s = SynthesisUtils.filteredElements(«artifactName.toFirstLower».requiring«requiring.name»«requiring.requiring.name»s,
                                context.parent as IOverviewVisualizationContext<«requiring.requiring.name»>, usedContext)
                            if (!filteredRequiring«requiring.requiring.name»s.empty) {
                                ports += createPort(context, "requiring«requiring.name»«requiring.requiring.name»s") => [
                                    associateWith(context)
                                    data += createKIdentifier => [ it.id = "requiring«requiring.name»«requiring.requiring.name»s" ]
                                    // Requiring «artifactName.toFirstLower»s are always shown and expanded to the west against the drawing direction.
                                    addLayoutParam(CoreOptions::PORT_SIDE, PortSide::WEST)
                                    addLayoutParam(CoreOptions::PORT_INDEX, 1)
                                    addRequiring«requiring.requiring.name»Requires«requiring.required.name»Named«requiring.name»ActionPortRendering(filteredRequiring«requiring.requiring.name»s.size, context.allRequiring«requiring.requiring.name»Requires«requiring.required.name»Named«requiring.name»Shown)
                                    width = 12
                                    height = 12
                                ]
                            }
                            
                            «ENDFOR»
                            // Add the rendering.
                            val hasChildren = !children.empty
                            «IF views.empty»
                                add«artifactName»Rendering(«artifactName.toFirstLower», false, hasChildren, usedContext)
                            «ELSE»
                                add«artifactName»Rendering(«artifactName.toFirstLower»,
                                «FOR view : views SEPARATOR ' || ' AFTER ')'»
                                    context.parent instanceof «view.name»OverviewContext, hasChildren, usedContext
                                «ENDFOR»
                            «ENDIF»
                        ]
                    ]
                }
            }
            
        '''
    }
    
    /**
     * Generates the simplified syntheses contend for a given artifact.
     * 
     * @param packageName
     *      the base path name of the spviz packages.
     * @param artifact
     *         the artifact name as a string
     * @return 
     *         the generated file content as a string
     */
    def static String generateSimpleSynthesis(String packageName, String artifactName) {
        return '''
            package «packageName».viz.subsyntheses
            
            import com.google.inject.Inject
            import de.cau.cs.kieler.klighd.kgraph.KGraphFactory
            import de.cau.cs.kieler.klighd.kgraph.KNode
            import de.cau.cs.kieler.klighd.krendering.extensions.KNodeExtensions
            import de.cau.cs.kieler.klighd.syntheses.AbstractSubSynthesis
            import org.eclipse.elk.core.options.CoreOptions
            import «packageName».viz.SynthesisUtils
            import «packageName».viz.Styles
            import «packageName».model.«artifactName»Context
            
            import static extension de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses.*
            
            /**
             * Transformation of a simple view of a «artifactName» that provides functionality to be expanded, when the specific 
             * synthesis for «artifactName» is called.
             */
            class Simple«artifactName»Synthesis extends AbstractSubSynthesis<«artifactName»Context, KNode> {
                @Inject extension KNodeExtensions
                @Inject extension Styles
                extension KGraphFactory = KGraphFactory.eINSTANCE
                
                override transform(«artifactName»Context context) {
                    transform(context, 0)
                }
                
                def transform(«artifactName»Context context, int priority) {
                    val «artifactName.toFirstLower» = context.modelElement
                    return #[
                        context.createNode() => [
                            associateWith(context)
                            data += createKIdentifier => [ it.id = context.hashCode.toString ]
                            val label = SynthesisUtils.getId(«artifactName.toFirstLower».name, usedContext) ?: ""
                            setLayoutOption(CoreOptions::PRIORITY, priority)
                            add«artifactName»InOverviewRendering(«artifactName.toFirstLower», label, usedContext)
                        ]
                    ]
                }
            }
            
        '''
    }
    
}
