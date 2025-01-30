/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021-2025 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spviz.sPViz.ShownCategoryConnection
import de.cau.cs.kieler.spviz.spviz.sPViz.View
import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact
import java.io.File
import java.util.HashSet
import java.util.List
import java.util.Set

import static extension de.cau.cs.kieler.spviz.spviz.util.SPVizExtension.*
import static extension de.cau.cs.kieler.spviz.spvizmodel.util.SPVizModelExtension.*

/**
 * Generates sub syntheses classes for overviews and their contained artifacts.
 * 
 * @author nre, leo
 */
class GenerateSubSyntheses {
    def static void generate(File sourceFolder, DataAccess data) {
        
        val bundleNamePrefix = data.getBundleNamePrefix
        val folder = FileGenerator.createDirectory(sourceFolder, bundleNamePrefix.replace('.', '/') + "/viz/subsyntheses")
        for (artifact : data.artifacts) {
            var content = generateSimpleSynthesis(bundleNamePrefix, artifact.name)
            FileGenerator.updateFile(folder, "Simple" + artifact.name + "Synthesis.xtend", content)

            content = generateSynthesis(artifact, data)
            FileGenerator.updateFile(folder, artifact.name + "Synthesis.xtend", content)
        }
        for (view : data.views) {
            val content = generateOverviewSythesis(view, data)
            FileGenerator.updateFile(folder, view.name + "OverviewSynthesis.xtend", content)
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
        // the category connections defined in this view
        val innerCategoryConnections = view.shownCategoryConnections
        // the category connections connecting connections from this view
        val List<ShownCategoryConnection> outerCategoryConnections = data.getUniqueCategoryConnections.filter[it.innerView === view].toList
        val Set<Artifact> categories = outerCategoryConnections.map[it.connectedCategory].toSet
        return '''
            package «data.getBundleNamePrefix».viz.subsyntheses
            
            import com.google.inject.Inject
            import de.cau.cs.kieler.klighd.kgraph.KGraphFactory
            import de.cau.cs.kieler.klighd.kgraph.KIdentifier
            import de.cau.cs.kieler.klighd.kgraph.KNode
            import de.cau.cs.kieler.klighd.krendering.extensions.KContainerRenderingExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KEdgeExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KNodeExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KPortExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KRenderingExtensions
            import de.cau.cs.kieler.klighd.syntheses.AbstractSubSynthesis
            import java.util.EnumSet
            import java.util.List
            import org.eclipse.elk.alg.layered.options.LayeredOptions
            import org.eclipse.elk.alg.layered.options.OrderingStrategy
            import org.eclipse.elk.core.math.ElkPadding
            import org.eclipse.elk.core.options.CoreOptions
            import org.eclipse.elk.core.options.Direction
            import org.eclipse.elk.core.options.PortConstraints
            import org.eclipse.elk.core.options.PortSide
            import org.eclipse.elk.core.options.SizeConstraint
            import «data.getBundleNamePrefix».model.«viewName»OverviewContext
            import «data.getBundleNamePrefix».viz.SynthesisUtils
            import «data.getBundleNamePrefix».viz.Styles
            «FOR shownElement : view.shownElements»
                import «data.getBundleNamePrefix».model.«shownElement.shownElement.name»Context
            «ENDFOR»
            «FOR artifact : categories»
                import «data.bundleNamePrefix».model.«artifact.name.toFirstUpper»Context
                import «data.modelBundleNamePrefix».model.«artifact.name.toFirstUpper»
            «ENDFOR»
            «FOR categoryConnection : outerCategoryConnections»
                import «data.bundleNamePrefix».model.«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container
            «ENDFOR»

            import static «data.getBundleNamePrefix».viz.Options.*
            
            import static extension de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses.*
            import static extension «data.getBundleNamePrefix».viz.SynthesisUtils.*
            import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
            
            /**
             * Transformation as an overview of all «viewName.toFirstLower»s in the given list of «viewName.toFirstLower»s.
             */
            class «viewName»OverviewSynthesis extends AbstractSubSynthesis<«viewName»OverviewContext, KNode> {
                @Inject extension KContainerRenderingExtensions
                @Inject extension KEdgeExtensions
                @Inject extension KNodeExtensions
                @Inject extension KPortExtensions
                @Inject extension KRenderingExtensions
                @Inject extension Styles
                «FOR shownElement : view.shownElements»
                    @Inject Simple«shownElement.shownElement.name»Synthesis simple«shownElement.shownElement.name»Synthesis
                    @Inject «shownElement.shownElement.name»Synthesis «shownElement.shownElement.name.toFirstLower»Synthesis
                «ENDFOR»
                extension KGraphFactory = KGraphFactory.eINSTANCE
                
                override transform(«viewName»OverviewContext context) {
                    return #[
                        createNode => [
                            associateWith(context)
                            data += createKIdentifier => [ it.id = context.hashCode.toString ]
                            setLayoutOption(CoreOptions::PORT_CONSTRAINTS, PortConstraints::FIXED_SIDE)
                            setLayoutOption(CoreOptions::ALGORITHM, "org.eclipse.elk.layered")
                            setLayoutOption(CoreOptions::SEPARATE_CONNECTED_COMPONENTS, false)
                            setLayoutOption(LayeredOptions::CONSIDER_MODEL_ORDER_STRATEGY, OrderingStrategy::NODES_AND_EDGES)
                            setLayoutOption(CoreOptions::DIRECTION, Direction.RIGHT)
                            setLayoutOption(CoreOptions::NODE_SIZE_CONSTRAINTS, EnumSet.of(SizeConstraint.MINIMUM_SIZE))
                            if (TOPDOWN_LAYOUT.booleanValue) {
                                SynthesisUtils.configureTopdownLayout(it, false)
                            }
                            val isFocus = context.rootVisualization.focus === context
                            addOverviewRendering("«viewName»", context.overviewText, context.isExpanded, «!view.shownConnections.empty || !view.shownCategoryConnections.empty», isFocus, usedContext)
                            
                            // add no children if it is not expanded.
                            if (!context.isExpanded) {
                                return
                            }
                            
                            // remove the padding of the invisible container.
                            addLayoutParam(CoreOptions.PADDING, new ElkPadding(0, 0, 0, 0))
                            
                            «FOR categoryConnection : outerCategoryConnections»
                                var Iterable<«categoryConnection.connectedCategory.name.toFirstUpper»Context> connected«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s = #[]
                                var Iterable<«categoryConnection.connectedCategory.name.toFirstUpper»Context> connecting«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s = #[]
                                var Iterable<«data.bundleNamePrefix».model.Pair<«categoryConnection.connectingArtifact.name.toFirstUpper»Context, «categoryConnection.connectedArtifact.name.toFirstUpper»Context>> connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections = #[]
                                var Iterable<«data.bundleNamePrefix».model.Pair<«categoryConnection.connectingArtifact.name.toFirstUpper»Context, «categoryConnection.connectedArtifact.name.toFirstUpper»Context>> connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections = #[]
                                if (usedContext.getOptionValue(CONTAINER_EDGES_WHEN_FOCUSED) as Boolean || context.rootVisualization.focus !== context) {
                                    // Add an invisible port for each «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» connection via their «categoryConnection.innerView.name.toFirstLower» inside a «categoryConnection.connectedCategory.name.toFirstLower» category,
                                    // if the connection is currently to be shown;
                                    // or add an invisible port for each «categoryConnection.connectedCategory.name.toFirstLower» source/target pair related to the parent «categoryConnection.connectedCategory.name.toFirstLower», depending
                                    // on the configured option.
                                    // First remember all the («categoryConnection.connectedCategory.name.toFirstLower»/«categoryConnection.connectingArtifact.name.toFirstLower»-«categoryConnection.connectedArtifact.name.toFirstLower») pairs to connect, to be able to add such a port for both the outside of the «categoryConnection.innerView.name.toFirstLower» overview,
                                    // as well as the hidden inner detailed overview.
                                    
                                    if (context.parent instanceof «categoryConnection.connectedCategory.name.toFirstUpper»Context
                                        && context.parent.parent instanceof «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container) {
                                        connected«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s = SynthesisUtils.shownConnectedCategoryConnections«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(context.parent.parent as «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container, context.parent.modelElement as «categoryConnection.connectedCategory.name.toFirstUpper»)
                                        connecting«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s = SynthesisUtils.shownConnectingCategoryConnections«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(context.parent.parent as «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container, context.parent.modelElement as «categoryConnection.connectedCategory.name.toFirstUpper»)
                                    }
                                    if (context.parent instanceof «categoryConnection.connectedCategory.name.toFirstUpper»Context
                                        && context.parent.parent instanceof «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container) {
                                        connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections = SynthesisUtils.shownConnected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(context.parent.parent as «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container, context)
                                        connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections = SynthesisUtils.shownConnecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(context.parent.parent as «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container, context)
                                    }
                                    if (usedContext.getOptionValue(CONTAINER_CONNECTION_STYLE) as Boolean) {
                                        // Option says to split on the inside.
                                        
                                        // Add an invisible port for each «categoryConnection.connectedCategory.name.toFirstLower»->«categoryConnection.connectedCategory.name.toFirstLower» connection via their B Dep inside a «categoryConnection.connectedCategory.name.toFirstLower» category,
                                        // if the connection is currently to be shown.
                                        for (connected«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper» : connected«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s) {
                                            ports += it.createPort(context, "connected«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»To" + connected«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper».modelElement.ecoreId) => [
                                                associateWith(context)
                                                data += createKIdentifier => [ it.id = "connected«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»To" + connected«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper».modelElement.ecoreId ]
                                                // Connected elements are always shown and expanded to the east with the drawing direction.
                                                addLayoutParam(CoreOptions::PORT_SIDE, PortSide::EAST)
                                                addGenericInvisiblePortRendering
                                                width = 1
                                                height = 1
                                            ]
                                        }
                                        
                                        for (connecting«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper» : connecting«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s) {
                                            ports += it.createPort(context, "connecting«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper».modelElement.ecoreId) => [
                                                associateWith(context)
                                                data += createKIdentifier => [ it.id = "connecting«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper».modelElement.ecoreId ]
                                                // Connecting elements always connect from the west with the drawing direction.
                                                addLayoutParam(CoreOptions::PORT_SIDE, PortSide::WEST)
                                                addGenericInvisiblePortRendering
                                                width = 1
                                                height = 1
                                            ]
                                        }
                                    } else {
                                        // Option says to split on the outside.
                                        
                                        // Add an invisible port for each «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» connection via their «categoryConnection.innerView.name.toFirstLower» inside a «categoryConnection.connectedCategory.name.toFirstLower» category,
                                        // if the connection is currently to be shown.
                                        for (connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connection : connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections) {
                                            ports += it.createPort(context, "connected«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connection.key.modelElement.ecoreId + "To" + connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connection.value.modelElement.ecoreId) => [
                                                associateWith(context)
                                                data += createKIdentifier => [ it.id = "connected«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connection.key.modelElement.ecoreId + "To" + connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connection.value.modelElement.ecoreId ]
                                                // Connected elements are always shown and expanded to the east with the drawing direction.
                                                addLayoutParam(CoreOptions::PORT_SIDE, PortSide::EAST)
                                                addGenericInvisiblePortRendering
                                                width = 1
                                                height = 1
                                            ]
                                        }
                                        
                                        for (connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connection : connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections) {
                                            ports += it.createPort(context, "connecting«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connection.key.modelElement.ecoreId + "To" + connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connection.value.modelElement.ecoreId) => [
                                                associateWith(context)
                                                data += createKIdentifier => [ it.id = "connecting«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connection.key.modelElement.ecoreId + "To" + connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connection.value.modelElement.ecoreId ]
                                                // Connecting elements always connect from the west with the drawing direction.
                                                addLayoutParam(CoreOptions::PORT_SIDE, PortSide::WEST)
                                                addGenericInvisiblePortRendering
                                                width = 1
                                                height = 1
                                            ]
                                        }
                                    }
                                }
                            «ENDFOR»
                            
                            // Add all simple «viewName.toFirstLower» renderings in a first subgraph (top because of node order)
                            val collapsedOverviewNode = transformCollapsed«viewName»Overview(context)
                            // only show the collapsed nodes if there are collapsed nodes or if the hide button would uncover the hidden collapsed ones.
                            «FOR shownElement : view.shownElements BEFORE "if (!collapsedOverviewNode.children.empty || usedContext.getOptionValue(INTERACTIVE_BUTTONS) as Boolean && (" SEPARATOR " || " AFTER ")) {"»«««
«                              »!context.collapsed«shownElement.shownElement.name.toFirstUpper»Contexts.isEmpty«««
«                          »«ENDFOR»
                                children += collapsedOverviewNode
                            }
                            
                            // Add all detailed «viewName.toFirstLower» renderings and their connections in a second subgraph (bottom because of node order)
                            val detailedOverviewNode = transformDetailed«viewName»Overview(context, it«««
«                          »«FOR categoryConnection : outerCategoryConnections BEFORE ', ' SEPARATOR ', '»«««
«                              »connected«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s, «««
«                              »connecting«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s, «««
«                              »connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections, «««
«                              »connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections«««
«                          »«ENDFOR»)
                            if (!detailedOverviewNode.children.empty) {
                                children += detailedOverviewNode
                            }
                        ]
                    ]
                }
                
                /**
                 * The top part of the «viewName.toFirstLower» overview rendering containing all collapsed «viewName.toFirstLower» renderings in a box layout.
                 * 
                 * @param «viewName.toFirstLower»OverviewContext The overview context for all «viewName.toFirstLower»s in this subsynthesis.
                 */
                private def KNode transformCollapsed«viewName»Overview(«viewName»OverviewContext «viewName.toFirstLower»OverviewContext) {
                    val shown = «viewName.toFirstLower»OverviewContext.showCollapsedElements
                    «FOR shownElement : view.shownElements»
                        val filteredCollapsed«shownElement.shownElement.name»Contexts = if (shown) {
                            filteredElementContexts(
                                «viewName.toFirstLower»OverviewContext.collapsed«shownElement.shownElement.name»Contexts as List<«shownElement.shownElement.name»Context>, usedContext).toList
                        } else {
                            #[]
                        }
                    «ENDFOR»
                    createNode => [
                        associateWith(«viewName.toFirstLower»OverviewContext)
                        configureBoxLayout
                        if (TOPDOWN_LAYOUT.booleanValue) {
                            SynthesisUtils.configureTopdownLayout(it, false)
                        }
                        data += createKIdentifier => [ it.id = "collapsed" ]
                        «FOR shownElement : view.shownElements BEFORE "addOverviewOfCollapsedRendering(shown, " SEPARATOR " || " AFTER ", usedContext)"»«««
«                          »!«viewName.toFirstLower»OverviewContext.collapsed«shownElement.shownElement.name.toFirstUpper»Contexts.isEmpty«««
«                      »«ENDFOR»
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
                 * @param context The overview context for all «viewName.toFirstLower»s in this sub-synthesis.
                 * @param parentNode The node that the returned node will be added to later. Important to be able to connect the inner category edge.
                 «FOR categoryConnection : outerCategoryConnections»
                     * @param connected«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s the category connections going out of this overview («categoryConnection.connectedCategory.name.toFirstUpper»)
                     * @param connecting«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s the category connections going into this overview («categoryConnection.connectedCategory.name.toFirstUpper»)
                     * @param connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections the category connections going out of this overview («categoryConnection.connectingArtifact.name.toFirstUpper»->«categoryConnection.connectedArtifact.name.toFirstUpper»)
                     * @param connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections the category connections going into this overview («categoryConnection.connectingArtifact.name.toFirstUpper»->«categoryConnection.connectedArtifact.name.toFirstUpper»)
                «ENDFOR»
                 */
                 private def KNode transformDetailed«viewName»Overview(«viewName»OverviewContext context, KNode parentNode«««
«               »«FOR categoryConnection : outerCategoryConnections BEFORE ', ' SEPARATOR ', '»«««
«                   »Iterable<«categoryConnection.connectedCategory.name.toFirstUpper»Context> connected«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s, «««
«                   »Iterable<«categoryConnection.connectedCategory.name.toFirstUpper»Context> connecting«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s, «««
«                   »Iterable<«data.bundleNamePrefix».model.Pair<«categoryConnection.connectingArtifact.name.toFirstUpper»Context, «categoryConnection.connectedArtifact.name.toFirstUpper»Context>> connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections, «««
«                   »Iterable<«data.bundleNamePrefix».model.Pair<«categoryConnection.connectingArtifact.name.toFirstUpper»Context, «categoryConnection.connectedArtifact.name.toFirstUpper»Context>> connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections«««
«               »«ENDFOR») {
                    «FOR shownElement : view.shownElements»
                        val filteredDetailed«shownElement.shownElement.name»Contexts = filteredElementContexts(
                            context.detailed«shownElement.shownElement.name»Contexts, usedContext)
                    «ENDFOR»
                    createNode => [
                        associateWith(context)
                        configureOverviewLayout
                        if (TOPDOWN_LAYOUT.booleanValue) {
                            SynthesisUtils.configureTopdownLayout(it, false)
                        }
                        data += createKIdentifier => [ it.id = "expanded" ]
                        addInvisibleContainerRendering => [
                            addChildArea
                        ]
                        tooltip = context.overviewText
                        
                        «FOR shownElement : view.shownElements»
                            children += filteredDetailed«shownElement.shownElement.name»Contexts.flatMap [
                                return «shownElement.shownElement.name.toFirstLower»Synthesis.transform(it as «shownElement.shownElement.name»Context)
                            ]
                        «ENDFOR»
                        
                        «FOR shownConnection : view.shownConnections»
                            // Add all by «shownConnection.shownConnection.connecting.name.toFirstLower»s connected «shownConnection.shownConnection.connected.name.toFirstLower»s edges.
                            context.«shownConnection.shownConnection.connecting.name.toFirstLower»Connects«shownConnection.shownConnection.connected.name»Named«shownConnection.shownConnection.name»Edges.forEach [
«««                            // Connects the {@code sourceBundleNode} and the {@code usedByBundleNode} via an arrow in UML style,
«««                            // so [usedByBundleNode] ----- uses -----> [sourceBundleNode]
                                val connecting = key
                                val connected = value
                                if (!nodeExists(connecting) || !nodeExists(connected)) {
                                    // Only Add edges if the nodes are actually shown.
                                    return
                                }
                                val connectingNode = connecting.node
                                val connectedNode = connected.node
                                val connectingPort = connectingNode.ports.findFirst [
                                    data.filter(KIdentifier).head?.id === "connected«shownConnection.shownConnection.name»«shownConnection.shownConnection.connected.name»s"
                                ]
                                val connectedPort = connectedNode.ports.findFirst [
                                    data.filter(KIdentifier).head?.id === "connecting«shownConnection.shownConnection.name»«shownConnection.shownConnection.connecting.name»s"
                                ]
                                
                                val edge = createEdge(connecting, connected) => [
                                    addConnected«shownConnection.shownConnection.connecting.name»Connects«shownConnection.shownConnection.connected.name»Named«shownConnection.shownConnection.name»EdgeRendering(true, false)
                                    sourcePort = connectingPort
                                    targetPort = connectedPort
                                    source = connectingNode
                                    target = connectedNode
                                ]
                                connectingNode.outgoingEdges += edge
                                connectedNode.incomingEdges += edge
                            ]
                        «ENDFOR»
                        if (usedContext.getOptionValue(CONTAINER_EDGES_WHEN_FOCUSED) as Boolean || context.rootVisualization.focus !== context) {
                            «FOR categoryConnection : outerCategoryConnections»
                                // Edges for the «categoryConnection.connectingCategory.name.toFirstLower»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper» connection.
                                if (usedContext.getOptionValue(CONTAINER_CONNECTION_STYLE) as Boolean) {
                                    // Add an invisible port for each currently shown «categoryConnection.connectedCategory.name.toFirstLower»->«categoryConnection.connectedCategory.name.toFirstLower» connection via their «categoryConnection.innerView.name.toFirstLower» inside a «categoryConnection.connectedCategory.name.toFirstLower» category,
                                    // as well as the edges connecting from the «categoryConnection.connectingArtifact.name.toFirstLower»s to them and them to the outside ports.
                                    for (connected«categoryConnection.connectedCategory.name.toFirstUpper» : connected«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s) {
                                        val connectionId = "connected«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»To" + connected«categoryConnection.connectedCategory.name.toFirstUpper».modelElement.ecoreId
                                        val newPort = it.createPort(context, connectionId) => [
                                            associateWith(context)
                                            data += createKIdentifier => [ it.id = connectionId ]
                                            // Connected elements are always shown and expanded to the east with the drawing direction.
                                            addLayoutParam(CoreOptions::PORT_SIDE, PortSide::EAST)
                                            addGenericInvisiblePortRendering
                                            width = 1
                                            height = 1
                                        ]
                                        ports += newPort
                                        // hidden layer to «categoryConnection.innerView.name.toFirstLower» outside edge
                                        {
                                            val connectingNode = it
                                            val connectedNode = parentNode
                                            val connectingPort = newPort
                                            val connectedPort = connectedNode.ports.findFirst [
                                                data.filter(KIdentifier).head?.id.equals(connectionId)
                                            ]
                                            
                                            val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                addConnected«categoryConnection.connectingArtifact.name.toFirstUpper»Connects«categoryConnection.connectedArtifact.name.toFirstUpper»Named«categoryConnection.connection.name.toFirstUpper»EdgeRendering(false, false)
                                                sourcePort = connectingPort
                                                targetPort = connectedPort
                                                source = connectingNode
                                                target = connectedNode
                                            ]
                                            connectingNode.outgoingEdges += edge
                                            connectedNode.incomingEdges += edge
                                        }
                                    }
                                    // «categoryConnection.connectingArtifact.name.toFirstLower» to hidden layer edge needs to happen for each «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» connection, not only for each «categoryConnection.connectedCategory.name.toFirstLower».
                                    // First, make sure to find all edges with the same source and target, they should only get a single
                                    // thicker edge.
                                    // Each first edge with later duplicates that should be drawn thick.
                                    val thickIndices = <Integer>newHashSet
                                    // Each later duplicate that should be skipped.
                                    val skipIndices = <Integer>newArrayList
                                    val connected«categoryConnection.connectedArtifact.name.toFirstUpper»ConnectionsList = connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections.toList
                                    indicesOfEqual«categoryConnection.connectingArtifact.name.toFirstUpper»To«categoryConnection.connectedCategory.name.toFirstUpper»In«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(connected«categoryConnection.connectedArtifact.name.toFirstUpper»ConnectionsList, thickIndices, skipIndices)
                                    
                                    for (var int i = 0; i < connected«categoryConnection.connectedArtifact.name.toFirstUpper»ConnectionsList.size; i++) {
                                        val thisIndex = i // make the lambda happy with a final variable
                                        if (!skipIndices.contains(thisIndex)) {
                                            val connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection = connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections.get(i)
                                            val connectionId = "connected«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.key.modelElement.ecoreId + "To" + connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.value.modelElement.ecoreId
                                            // «categoryConnection.connectingArtifact.name.toFirstLower» to hidden layer edge
                                            {
                                                // the child node related to the source «categoryConnection.connectingArtifact.name.toFirstLower».
                                                val connectingNode = children.filter(KNode).findFirst [
                                                    data.filter(KIdentifier).head?.id.equals(connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.key.modelElement.ecoreId)
                                                ]
                                                val connectedNode = it
                                                val connectingPort = connectingNode.ports.findFirst [
                                                    data.filter(KIdentifier).head?.id.equals("connected«categoryConnection.connection.name.toFirstUpper»«categoryConnection.connectedArtifact.name.toFirstUpper»s")
                                                ]
                                                val «categoryConnection.connectedCategory.name.toFirstUpper»PortName = "connected«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»To" + (connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.value.parent.parent.modelElement as «categoryConnection.connectedCategory.name.toFirstUpper»).ecoreId
                                                val connectedPort = connectedNode.ports.findFirst [
                                                    data.filter(KIdentifier).head?.id.equals(«categoryConnection.connectedCategory.name.toFirstUpper»PortName)
                                                ]
                                                
                                                val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                    addConnected«categoryConnection.connectingArtifact.name.toFirstUpper»Connects«categoryConnection.connectedArtifact.name.toFirstUpper»Named«categoryConnection.connection.name.toFirstUpper»EdgeRendering(false, thickIndices.contains(thisIndex))
                                                    sourcePort = connectingPort
                                                    targetPort = connectedPort
                                                    source = connectingNode
                                                    target = connectedNode
                                                ]
                                                connectingNode.outgoingEdges += edge
                                                connectedNode.incomingEdges += edge
                                            }
                                        }
                                    }
                                    
                                    for (connecting«categoryConnection.connectedCategory.name.toFirstUpper» : connecting«categoryConnection.connectedCategory.name.toFirstUpper»From«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»s) {
                                        val connectionId = "connecting«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectedCategory.name.toFirstUpper».modelElement.ecoreId
                                        val newPort = it.createPort(context, connectionId) => [
                                            associateWith(context)
                                            data += createKIdentifier => [ it.id = connectionId ]
                                            // Connecting elements always connect from the west with the drawing direction.
                                            addLayoutParam(CoreOptions::PORT_SIDE, PortSide::WEST)
                                            addGenericInvisiblePortRendering
                                            width = 1
                                            height = 1
                                        ]
                                        ports += newPort
                                        // «categoryConnection.innerView.name.toFirstLower» outside edge to hidden layer
                                        {
                                            val connectingNode = parentNode
                                            val connectedNode = it
                                            val connectingPort = connectingNode.ports.findFirst [
                                                data.filter(KIdentifier).head?.id.equals(connectionId)
                                            ]
                                            val connectedPort = newPort
                                            
                                            val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                addConnected«categoryConnection.connectingArtifact.name.toFirstUpper»Connects«categoryConnection.connectedArtifact.name.toFirstUpper»Named«categoryConnection.connection.name.toFirstUpper»EdgeRendering(false, false)
                                                sourcePort = connectingPort
                                                targetPort = connectedPort
                                                source = connectingNode
                                                target = connectedNode
                                            ]
                                            connectingNode.outgoingEdges += edge
                                            connectedNode.incomingEdges += edge
                                        }
                                    }
                                    
                                    val connecting«categoryConnection.connectedArtifact.name.toFirstUpper»ConnectionsList = connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections.toList
                                    indicesOfEqual«categoryConnection.connectedCategory.name.toFirstUpper»To«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(connecting«categoryConnection.connectedArtifact.name.toFirstUpper»ConnectionsList, thickIndices, skipIndices)
                                    // hidden layer to «categoryConnection.connectedArtifact.name.toFirstUpper» edge needs to happen for each «categoryConnection.connectingArtifact.name.toFirstUpper»->«categoryConnection.connectedArtifact.name.toFirstUpper» connection, not only for each «categoryConnection.connectedCategory.name.toFirstUpper».
                                    for (var int i = 0; i < connecting«categoryConnection.connectedArtifact.name.toFirstUpper»ConnectionsList.size; i++) {
                                        val thisIndex = i // make the lambda happy with a final variable
                                        if (!skipIndices.contains(thisIndex)) {
                                            val connecting«categoryConnection.connectedArtifact.name.toFirstUpper»Connection = connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections.get(i)
                                            val connectionId = "connecting«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.key.modelElement.ecoreId + "To" + connecting«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.value.modelElement.ecoreId
                                            // hidden layer to «categoryConnection.connectedArtifact.name.toFirstLower» edge
                                            {
                                                val connectingNode = it
                                                // the child node related to the target «categoryConnection.connectedArtifact.name.toFirstLower».
                                                val connectedNode = children.filter(KNode).findFirst [
                                                    data.filter(KIdentifier).head?.id.equals(connecting«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.value.modelElement.ecoreId)
                                                ]
                                                val connecting«categoryConnection.connectedCategory.name.toFirstUpper»PortName = "connecting«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + (connecting«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.key.parent.parent.modelElement as «categoryConnection.connectedCategory.name.toFirstUpper»).ecoreId
                                                val connectingPort = connectingNode.ports.findFirst [
                                                    data.filter(KIdentifier).head?.id.equals(connecting«categoryConnection.connectedCategory.name.toFirstUpper»PortName)
                                                ]
                                                val connectedPort = connectedNode.ports.findFirst [
                                                    data.filter(KIdentifier).head?.id.equals("connecting«categoryConnection.connection.name.toFirstUpper»«categoryConnection.connectingArtifact.name.toFirstUpper»s")
                                                ]
                                                
                                                val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                    addConnected«categoryConnection.connectingArtifact.name.toFirstUpper»Connects«categoryConnection.connectedArtifact.name.toFirstUpper»Named«categoryConnection.connection.name.toFirstUpper»EdgeRendering(true, thickIndices.contains(thisIndex))
                                                    sourcePort = connectingPort
                                                    targetPort = connectedPort
                                                    source = connectingNode
                                                    target = connectedNode
                                                ]
                                                connectingNode.outgoingEdges += edge
                                                connectedNode.incomingEdges += edge
                                            }
                                        }
                                    }
                                } else {
                                    // Add an invisible port for each currently shown «categoryConnection.connectingArtifact.name.toFirstUpper»->«categoryConnection.connectedArtifact.name.toFirstUpper» connection via their «categoryConnection.innerView.name.toFirstLower» inside a «categoryConnection.connectedCategory.name.toFirstLower» category,
                                    // as well as the edges connecting from the «categoryConnection.connectingArtifact.name.toFirstLower» to them and them to the outside ports.
                                    for (connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection : connected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections) {
                                        val connectionId = "connected«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.key.modelElement.ecoreId + "To" + connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.value.modelElement.ecoreId
                                        val newPort = it.createPort(context, connectionId) => [
                                            associateWith(context)
                                            data += createKIdentifier => [ it.id = connectionId ]
                                            // Connected elements are always shown and expanded to the east with the drawing direction.
                                            addLayoutParam(CoreOptions::PORT_SIDE, PortSide::EAST)
                                            addGenericInvisiblePortRendering
                                            width = 1
                                            height = 1
                                        ]
                                        ports += newPort
                                        // «categoryConnection.connectingArtifact.name.toFirstLower» to hidden layer edge
                                        {
                                            // the child node related to the source «categoryConnection.connectingArtifact.name.toFirstLower».
                                            val connectingNode = children.filter(KNode).findFirst [
                                                data.filter(KIdentifier).head?.id.equals(connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.key.modelElement.ecoreId)
                                            ]
                                            val connectedNode = it
                                            val connectingPort = connectingNode.ports.findFirst [
                                                data.filter(KIdentifier).head?.id.equals("connected«categoryConnection.connection.name.toFirstUpper»«categoryConnection.connectedArtifact.name.toFirstUpper»s")
                                            ]
                                            val connectedPort = newPort
                                            
                                            val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                addConnected«categoryConnection.connectingArtifact.name.toFirstUpper»Connects«categoryConnection.connectedArtifact.name.toFirstUpper»Named«categoryConnection.connection.name.toFirstUpper»EdgeRendering(false, false)
                                                sourcePort = connectingPort
                                                targetPort = connectedPort
                                                source = connectingNode
                                                target = connectedNode
                                            ]
                                            connectingNode.outgoingEdges += edge
                                            connectedNode.incomingEdges += edge
                                        }
                                        // hidden layer to «categoryConnection.innerView.name.toFirstLower» outside edge
                                        {
                                            val connectingNode = it
                                            val connectedNode = parentNode
                                            val connectingPort = newPort
                                            val connectedPort = connectedNode.ports.findFirst [
                                                data.filter(KIdentifier).head?.id.equals(connectionId)
                                            ]
                                            
                                            val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                addConnected«categoryConnection.connectingArtifact.name.toFirstUpper»Connects«categoryConnection.connectedArtifact.name.toFirstUpper»Named«categoryConnection.connection.name.toFirstUpper»EdgeRendering(false, false)
                                                sourcePort = connectingPort
                                                targetPort = connectedPort
                                                source = connectingNode
                                                target = connectedNode
                                            ]
                                            connectingNode.outgoingEdges += edge
                                            connectedNode.incomingEdges += edge
                                        }
                                    }
                                    
                                    for (connecting«categoryConnection.connectedArtifact.name.toFirstUpper»Connection : connecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Connections) {
                                        val connectionId = "connecting«categoryConnection.connectingCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.key.modelElement.ecoreId + "To" + connecting«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.value.modelElement.ecoreId
                                        val newPort = it.createPort(context, connectionId) => [
                                            associateWith(context)
                                            data += createKIdentifier => [ it.id = connectionId ]
                                            // Connecting elements always connect from the west with the drawing direction.
                                            addLayoutParam(CoreOptions::PORT_SIDE, PortSide::WEST)
                                            addGenericInvisiblePortRendering
                                            width = 1
                                            height = 1
                                        ]
                                        ports += newPort
                                        // «categoryConnection.innerView.name.toFirstLower» outside edge to hidden layer
                                        {
                                            val connectingNode = parentNode
                                            val connectedNode = it
                                            val connectingPort = connectingNode.ports.findFirst [
                                                data.filter(KIdentifier).head?.id.equals(connectionId)
                                            ]
                                            val connectedPort = newPort
                                            
                                            val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                addConnected«categoryConnection.connectingArtifact.name.toFirstUpper»Connects«categoryConnection.connectedArtifact.name.toFirstUpper»Named«categoryConnection.connection.name.toFirstUpper»EdgeRendering(false, false)
                                                sourcePort = connectingPort
                                                targetPort = connectedPort
                                                source = connectingNode
                                                target = connectedNode
                                            ]
                                            connectingNode.outgoingEdges += edge
                                            connectedNode.incomingEdges += edge
                                        }
                                        // hidden layer to «categoryConnection.connectedArtifact.name.toFirstLower» edge
                                        {
                                            val connectingNode = it
                                            // the child node related to the target «categoryConnection.connectedArtifact.name.toFirstLower».
                                            val connectedNode = children.filter(KNode).findFirst [
                                                data.filter(KIdentifier).head?.id.equals(connecting«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.value.modelElement.ecoreId)
                                            ]
                                            val connectingPort = newPort
                                            val connectedPort = connectedNode.ports.findFirst [
                                                data.filter(KIdentifier).head?.id.equals("connecting«categoryConnection.connection.name.toFirstUpper»«categoryConnection.connectingArtifact.name.toFirstLower»s")
                                            ]
                                            
                                            val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                addConnected«categoryConnection.connectingArtifact.name.toFirstUpper»Connects«categoryConnection.connectedArtifact.name.toFirstUpper»Named«categoryConnection.connection.name.toFirstUpper»EdgeRendering(false, true)
                                                sourcePort = connectingPort
                                                targetPort = connectedPort
                                                source = connectingNode
                                                target = connectedNode
                                            ]
                                            connectingNode.outgoingEdges += edge
                                            connectedNode.incomingEdges += edge
                                        }
                                    }
                                }
                            «ENDFOR»
                            
                            // Add all inner category edges.
                            «FOR categoryConnection : innerCategoryConnections»
                                context.«categoryConnection.connectingCategory.name.toFirstLower»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edges.forEach [
                                    val connecting = key
                                    val connected = value
                                    if (!nodeExists(connecting) || !nodeExists(connected)) {
                                        // Only Add edges if the nodes are actually shown.
                                        return
                                    }
                                    val connectingNode = connecting.node
                                    val connectedNode = connected.node
                                    val connectingPort = connectingNode.ports.findFirst [
                                        data.filter(KIdentifier).head?.id.equals("connected«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»To" + connected.modelElement.ecoreId)
                                    ]
                                    val connectedPort = connectedNode.ports.findFirst [
                                        data.filter(KIdentifier).head?.id.equals("connecting«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting.modelElement.ecoreId)
                                    ]
                                    
                                    val edge = createEdge(connecting, connected) => [
                                        addConnected«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»EdgeRendering
                                        sourcePort = connectingPort
                                        targetPort = connectedPort
                                        source = connectingNode
                                        target = connectedNode
                                    ]
                                    connectingNode.outgoingEdges += edge
                                    connectedNode.incomingEdges += edge
                                ]
                            «ENDFOR»
                        }
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
        val views = data.getContainingViews(artifact)
        val containedViews = data.getContainedViews(artifact)
        val Set<String> importedArtifacts = new HashSet
        importedArtifacts.add(artifact.name)
        for (connected : data.getConnectedArtifacts(artifact)) {
            importedArtifacts.add(connected.connected.name)
        }
        for (connecting : data.getConnectingArtifacts(artifact)) {
            importedArtifacts.add(connecting.connecting.name)
        }
        // The connections for which this artifact is the category.
        val categories = data.getUniqueCategoryConnections.filter[artifact === it.sourceChain.source]
        
        return '''
            package «data.getBundleNamePrefix».viz.subsyntheses
            
            import com.google.inject.Inject
            import de.cau.cs.kieler.klighd.kgraph.KGraphFactory
            import de.cau.cs.kieler.klighd.kgraph.KIdentifier
            import de.cau.cs.kieler.klighd.kgraph.KNode
            import de.cau.cs.kieler.klighd.krendering.extensions.KEdgeExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KNodeExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KPortExtensions
            import de.cau.cs.kieler.klighd.syntheses.AbstractSubSynthesis
            «FOR importedArtifact : importedArtifacts»
                import «data.modelBundleNamePrefix».model.«importedArtifact»
            «ENDFOR»
            import «data.modelBundleNamePrefix».model.«data.projectName»
            import «data.getBundleNamePrefix».viz.Options
            import «data.getBundleNamePrefix».viz.Styles
            import «data.getBundleNamePrefix».viz.SynthesisUtils
            import «data.getBundleNamePrefix».model.«artifactName»Context
            import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
            «FOR view : views»
                import «data.bundleNamePrefix».model.«view.name»OverviewContext
            «ENDFOR»
            «FOR categoryConnection : categories»
                import «data.bundleNamePrefix».model.«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container
            «ENDFOR»
            
            import java.util.EnumSet
            import org.eclipse.elk.alg.layered.options.LayeredOptions
            import org.eclipse.elk.alg.layered.options.OrderingStrategy
            import org.eclipse.elk.core.options.CoreOptions
            import org.eclipse.elk.core.options.Direction
            import org.eclipse.elk.core.options.EdgeRouting
            import org.eclipse.elk.core.options.PortConstraints
            import org.eclipse.elk.core.options.PortSide
            import org.eclipse.elk.core.options.SizeConstraint
            «FOR connection : (data.getConnectedArtifacts(artifact) + data.getConnectingArtifacts(artifact)).toSet»
                import «data.bundleNamePrefix».model.«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Container
            «ENDFOR»
            
            import static extension de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses.*
            import static «data.bundleNamePrefix».viz.Options.*
            
            /**
             * Sub-synthesis of {@link «data.projectName»}s that handles expanded {@link «artifactName»} views.
             */
            class «artifactName»Synthesis extends AbstractSubSynthesis<«artifactName»Context, KNode> {
                @Inject extension KEdgeExtensions
                @Inject extension KNodeExtensions
                @Inject extension KPortExtensions
                @Inject extension Styles
                «FOR containedView : containedViews»
                    @Inject «containedView.view.name»OverviewSynthesis «containedView.view.name.toFirstLower»OverviewSynthesis
                «ENDFOR»
                extension KGraphFactory = KGraphFactory.eINSTANCE
                
                override transform(«artifactName»Context context) {
                    val «artifactName.toFirstLower» = context.modelElement
                    return #[
                        context.createNode() => [
                            addLayoutParam(CoreOptions::PORT_CONSTRAINTS, PortConstraints::FIXED_SIDE)
                            associateWith(context)
                            data += createKIdentifier => [ it.id = «artifactName.toFirstLower».ecoreId ]
                            setLayoutOption(CoreOptions::NODE_SIZE_CONSTRAINTS, EnumSet.of(SizeConstraint.MINIMUM_SIZE))
                            setLayoutOption(CoreOptions::ALGORITHM, "org.eclipse.elk.layered")
                            setLayoutOption(CoreOptions::SEPARATE_CONNECTED_COMPONENTS, false)
                            setLayoutOption(LayeredOptions::CONSIDER_MODEL_ORDER_STRATEGY, OrderingStrategy::NODES_AND_EDGES)
                            setLayoutOption(CoreOptions::DIRECTION, Direction.RIGHT)
                            setLayoutOption(CoreOptions::EDGE_ROUTING, EdgeRouting.POLYLINE)
                            if (TOPDOWN_LAYOUT.booleanValue) {
                                SynthesisUtils.configureTopdownLayout(it, false)
                            }
                            
                            «FOR containedView : containedViews»
                                // Show a «containedView.view.name.toFirstLower» overview within this «artifactName»
                                // Only show this, if the option for it says so and if the context is available.
                                if (usedContext.getOptionValue(Options.«artifactName.toUpperCase»_SHOW_«containedView.view.name.toUpperCase») === true
                                    && context.«containedView.view.name.toFirstLower»OverviewContext !== null) {
                                    val «containedView.view.name.toFirstLower»OverviewNodes = «containedView.view.name.toFirstLower»OverviewSynthesis.transform(context.«containedView.view.name.toFirstLower»OverviewContext)
                                    children += «containedView.view.name.toFirstLower»OverviewNodes
                                    
                                    «FOR categoryConnection : categories.filter[it.innerView === containedView.view]»
                                        if (context.parent instanceof «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container) {
                                            // Add an invisible port for each «categoryConnection.connectedCategory.name.toFirstLower»->«categoryConnection.connectedCategory.name.toFirstLower» connection via their «categoryConnection.innerView.name.toFirstLower»,
                                            // if such a connection is currently to be shown.
                                            val connected«categoryConnection.connectedCategory.name.toFirstUpper»Connections = SynthesisUtils.shownConnectedCategoryConnections«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(context.parent as «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container, «categoryConnection.connectedCategory.name.toFirstLower»)
                                            for (connected«categoryConnection.connectedCategory.name.toFirstUpper»Connection : connected«categoryConnection.connectedCategory.name.toFirstUpper»Connections) {
                                                ports += createPort(context, "connected«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»To" + connected«categoryConnection.connectedCategory.name.toFirstUpper»Connection.modelElement.ecoreId) => [
                                                    associateWith(context)
                                                    data += createKIdentifier => [ it.id = "connected«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»To" + connected«categoryConnection.connectedCategory.name.toFirstUpper»Connection.modelElement.ecoreId ]
                                                    // Connected elements are always shown and expanded to the east with the drawing direction.
                                                    addLayoutParam(CoreOptions::PORT_SIDE, PortSide::EAST)
                                                    addGenericInvisiblePortRendering
                                                    width = 1
                                                    height = 1
                                                ]
                                            }
                                            
                                            // Same for incoming ports.
                                            val connecting«categoryConnection.connectedCategory.name.toFirstUpper»Connections = SynthesisUtils.shownConnectingCategoryConnections«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(context.parent as «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container, «categoryConnection.connectedCategory.name.toFirstLower»)
                                            for (connecting«categoryConnection.connectedCategory.name.toFirstUpper»Connection : connecting«categoryConnection.connectedCategory.name.toFirstUpper»Connections) {
                                                ports += createPort(context, "connecting«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectedCategory.name.toFirstUpper»Connection.modelElement.ecoreId) => [
                                                    associateWith(context)
                                                    data += createKIdentifier => [ it.id = "connecting«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectedCategory.name.toFirstUpper»Connection.modelElement.ecoreId ]
                                                    // Connecting elements always connect from the west with the drawing direction.
                                                    addLayoutParam(CoreOptions::PORT_SIDE, PortSide::WEST)
                                                    addGenericInvisiblePortRendering
                                                    width = 1
                                                    height = 1
                                                ]
                                            }
                                            if (usedContext.getOptionValue(CONTAINER_CONNECTION_STYLE) as Boolean) {
                                                // Add edges for each «categoryConnection.connectedCategory.name.toFirstUpper»->«categoryConnection.connectedCategory.name.toFirstUpper» connection in this «categoryConnection.connectedCategory.name.toFirstUpper»->«categoryConnection.connectedCategory.name.toFirstUpper» category connection
                                                // from the child B Deps OV's cumulative «categoryConnection.connectedCategory.name.toFirstUpper»->«categoryConnection.connectedCategory.name.toFirstUpper» ports to the cumulative «categoryConnection.connectedCategory.name.toFirstUpper»->«categoryConnection.connectedCategory.name.toFirstUpper» port here.
                                                for (connected«categoryConnection.connectedCategory.name.toFirstUpper»Connection : connected«categoryConnection.connectedCategory.name.toFirstUpper»Connections) {
                                                    val connectionId = "connected«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»To" + connected«categoryConnection.connectedCategory.name.toFirstUpper»Connection.modelElement.ecoreId
                                                    val connectingNode = «categoryConnection.innerView.name.toFirstLower»OverviewNodes.head
                                                    val connectedNode = it
                                                    val connectingPort = connectingNode.ports.findFirst [
                                                        data.filter(KIdentifier).head?.id.equals(connectionId)
                                                    ]
                                                    val connectedPort = connectedNode.ports.findFirst [
                                                        data.filter(KIdentifier).head?.id.equals(connectionId)
                                                    ]
                                                    
                                                    val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                        addConnected«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»EdgeRendering
                                                        sourcePort = connectingPort
                                                        targetPort = connectedPort
                                                        source = connectingNode
                                                        target = connectedNode
                                                    ]
                                                    connectingNode.outgoingEdges += edge
                                                    connectedNode.incomingEdges += edge
                                                }
                                                
                                                // Same for incoming edges.
                                                for (connecting«categoryConnection.connectedCategory.name.toFirstUpper»Connection : connecting«categoryConnection.connectedCategory.name.toFirstUpper»Connections) {
                                                    val connectionId = "connecting«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectedCategory.name.toFirstUpper»Connection.modelElement.ecoreId
                                                    
                                                    val connectingNode = it
                                                    val connectedNode = «categoryConnection.innerView.name.toFirstLower»OverviewNodes.head
                                                    val connectingPort = connectingNode.ports.findFirst [
                                                        data.filter(KIdentifier).head?.id.equals(connectionId)
                                                    ]
                                                    val connectedPort = connectedNode.ports.findFirst [
                                                        data.filter(KIdentifier).head?.id.equals(connectionId)
                                                    ]
                                                    
                                                    val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                        addConnected«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»EdgeRendering
                                                        sourcePort = connectingPort
                                                        targetPort = connectedPort
                                                        source = connectingNode
                                                        target = connectedNode
                                                    ]
                                                    connectingNode.outgoingEdges += edge
                                                    connectedNode.incomingEdges += edge
                                                }
                                                
                                            } else {
                                                // Add edges for each «categoryConnection.connectingArtifact.name.toFirstUpper»->«categoryConnection.connectedArtifact.name.toFirstUpper» connection in this «categoryConnection.connectedCategory.name.toFirstUpper»->«categoryConnection.connectedCategory.name.toFirstUpper» category connection
                                                // from the child B Deps OV's individual dep ports to the cumulative «categoryConnection.connectedCategory.name.toFirstUpper»->«categoryConnection.connectedCategory.name.toFirstUpper» port here.
                                                val connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connections = SynthesisUtils.shownConnected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(context.parent as «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container, context.«categoryConnection.innerView.name.toFirstLower»OverviewContext)
                                                for (connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection : connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connections) {
                                                    val connectionId = "connected«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.key.modelElement.ecoreId + "To" + connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.value.modelElement.ecoreId
                                                    
                                                    val connectingNode = «categoryConnection.innerView.name.toFirstLower»OverviewNodes.head
                                                    val connectedNode = it
                                                    val connectingPort = connectingNode.ports.findFirst [
                                                        data.filter(KIdentifier).head?.id.equals(connectionId)
                                                    ]
                                                    val connectedPort = connectedNode.ports.findFirst [
                                                        data.filter(KIdentifier).head?.id.equals("connected«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»To" + (connected«categoryConnection.connectedArtifact.name.toFirstUpper»Connection.value.parent.parent as «categoryConnection.connectedCategory.name.toFirstUpper»Context).modelElement.ecoreId)
                                                    ]
                                                    
                                                    val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                        addConnected«categoryConnection.connectingArtifact.name.toFirstUpper»Connects«categoryConnection.connectedArtifact.name.toFirstUpper»Named«categoryConnection.connection.name.toFirstUpper»EdgeRendering(false, false)
                                                        sourcePort = connectingPort
                                                        targetPort = connectedPort
                                                        source = connectingNode
                                                        target = connectedNode
                                                    ]
                                                    connectingNode.outgoingEdges += edge
                                                    connectedNode.incomingEdges += edge
                                                }
                                                
                                                // Same for incoming edges.
                                                val connecting«categoryConnection.connectingArtifact.name.toFirstUpper»Connections = SynthesisUtils.shownConnecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(context.parent as «categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container, context.«categoryConnection.innerView.name.toFirstLower»OverviewContext)
                                                for (connecting«categoryConnection.connectingArtifact.name.toFirstUpper»Connection : connecting«categoryConnection.connectingArtifact.name.toFirstUpper»Connections) {
                                                    val connectionId = "connecting«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + connecting«categoryConnection.connectingArtifact.name.toFirstUpper»Connection.key.modelElement.ecoreId + "To" + connecting«categoryConnection.connectingArtifact.name.toFirstUpper»Connection.value.modelElement.ecoreId
                                                    
                                                    val connectingNode = it
                                                    val connectedNode = «categoryConnection.innerView.name.toFirstLower»OverviewNodes.head
                                                    val connectingPort = connectingNode.ports.findFirst [
                                                        data.filter(KIdentifier).head?.id.equals("connecting«categoryConnection.connectedCategory.name.toFirstUpper»CategoryVia«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»From" + (connecting«categoryConnection.connectingArtifact.name.toFirstUpper»Connection.key.parent.parent as «categoryConnection.connectedCategory.name.toFirstUpper»Context).modelElement.ecoreId)
                                                    ]
                                                    val connectedPort = connectedNode.ports.findFirst [
                                                        data.filter(KIdentifier).head?.id.equals(connectionId)
                                                    ]
                                                    
                                                    val edge = createEdge(connectingNode, connectedNode, connectionId) => [
                                                        addConnected«categoryConnection.connectingArtifact.name.toFirstUpper»Connects«categoryConnection.connectedArtifact.name.toFirstUpper»Named«categoryConnection.connection.name.toFirstUpper»EdgeRendering(false, false)
                                                        sourcePort = connectingPort
                                                        targetPort = connectedPort
                                                        source = connectingNode
                                                        target = connectedNode
                                                    ]
                                                    connectingNode.outgoingEdges += edge
                                                    connectedNode.incomingEdges += edge
                                                }
                                            }
                                        }
                                        
                                    «ENDFOR»
                                }
                            «ENDFOR»
                            
                            «FOR connected : data.getConnectedArtifacts(artifact)»
                                // Only show this port if the parent overview context supports this connection type.
                                if (context.parent instanceof «connected.connecting.name»Connects«connected.connected.name»Named«connected.name»Container) {
                                    val filteredConnected«connected.name»«connected.connected.name»s = SynthesisUtils.filteredElements(«artifactName.toFirstLower».connected«connected.name»«connected.connected.name»s,
                                        context.parent as IOverviewVisualizationContext<«connected.connected.name»>, usedContext)
                                    if (!«artifactName.toFirstLower».connected«connected.name»«connected.connected.name»s.empty) {
                                        ports += createPort(context, "connected«connected.name»«connected.connected.name»s") => [
                                            associateWith(context)
                                            data += createKIdentifier => [ it.id = "connected«connected.name»«connected.connected.name»s" ]
                                            // Connected «artifactName.toFirstLower»s are always shown and expanded to the east with the drawing direction.
                                            addLayoutParam(CoreOptions::PORT_SIDE, PortSide::EAST)
                                            addLayoutParam(CoreOptions::PORT_INDEX, 0)
                                            addConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»PortRendering(filteredConnected«connected.name»«connected.connected.name»s.size, context.allConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»Shown)
                                            width = 12
                                            height = 12
                                        ]
                                    }
                                }
                                
                            «ENDFOR»
                            «FOR connecting : data.getConnectingArtifacts(artifact)»
                                // Only show this port if the parent overview context supports this connection type.
                                if (context.parent instanceof «connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»Container) {
                                    val filteredConnecting«connecting.name»«connecting.connecting.name»s = SynthesisUtils.filteredElements(«artifactName.toFirstLower».connecting«connecting.name»«connecting.connecting.name»s,
                                        context.parent as IOverviewVisualizationContext<«connecting.connecting.name»>, usedContext)
                                    if (!«artifactName.toFirstLower».connecting«connecting.name»«connecting.connecting.name»s.empty) {
                                        ports += createPort(context, "connecting«connecting.name»«connecting.connecting.name»s") => [
                                            associateWith(context)
                                            data += createKIdentifier => [ it.id = "connecting«connecting.name»«connecting.connecting.name»s" ]
                                            // Connecting «artifactName.toFirstLower»s are always shown and expanded to the west against the drawing direction.
                                            addLayoutParam(CoreOptions::PORT_SIDE, PortSide::WEST)
                                            addLayoutParam(CoreOptions::PORT_INDEX, 1)
                                            addConnecting«connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»PortRendering(filteredConnecting«connecting.name»«connecting.connecting.name»s.size, context.allConnecting«connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»Shown)
                                            width = 12
                                            height = 12
                                        ]
                                    }
                                }
                                
                            «ENDFOR»
                            // Add the rendering.
                            val hasChildren = !children.empty
                            «IF views.empty»
                                add«artifactName»Rendering(«artifactName.toFirstLower», false, hasChildren, usedContext)
                            «ELSE»
                                add«artifactName»Rendering(«artifactName.toFirstLower»,
                                «FOR view : views SEPARATOR ' || ' AFTER ','»
                                    context.parent instanceof «view.name»OverviewContext
                                «ENDFOR»
                                hasChildren, usedContext)
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
