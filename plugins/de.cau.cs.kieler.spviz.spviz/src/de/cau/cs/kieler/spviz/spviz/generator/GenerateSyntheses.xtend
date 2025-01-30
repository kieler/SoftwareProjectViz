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

import de.cau.cs.kieler.spviz.spviz.sPViz.View
import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact
import java.awt.Color
import java.io.File
import java.util.HashMap
import java.util.Locale
import java.util.Map
import java.util.Set

import static extension de.cau.cs.kieler.spviz.spviz.util.SPVizExtension.*
import static extension de.cau.cs.kieler.spviz.spvizmodel.util.SPVizModelExtension.*

/**
 * Generates classes for the syntheses of the visualization.
 * 
 * @author nre, leo
 */
class GenerateSyntheses {
    def static void generate(File sourceFolder, DataAccess data) {
        val File folder = FileGenerator.createDirectory(sourceFolder, data.getBundleNamePrefix.replace('.','/') + "/viz")
        
        FileGenerator.updateFile(folder, data.projectName.toFirstUpper + "DiagramSynthesis.xtend",
            generateDiagramSynthesis(data))
        FileGenerator.updateFile(folder, data.visualizationName.toFirstUpper + "DiagramSynthesis.xtend",
            generateVizDiagramSynthesis(data))
        FileGenerator.updateFile(folder, "KlighdSetup.xtend", generateKlighdSetup(data))
        FileGenerator.updateFile(folder, "Styles.xtend", generateStyles(data))
        FileGenerator.updateFile(folder, "SynthesisUtils.xtend", generateSynthesisUtils(data))
        FileGenerator.updateFile(folder, "SynthesisProperties.xtend", generateSynthesisProperties(data))
        FileGenerator.updateFile(folder, "Options.xtend", generateOptions(data))
        FileGenerator.updateFile(folder, "FileHandler.xtend", generateFileHandler(data))
        FileGenerator.updateFile(folder, "VisualizationReInitializer.xtend", generateVisualizationReInitializer(data))
    }
    
    /**
     * Generates the content for the diagram synthesis.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return 
     *         the generated file content as a string
     */
    def static String generateDiagramSynthesis(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».viz
            
            import com.google.common.collect.ImmutableList
            import com.google.inject.Inject
            import de.cau.cs.kieler.klighd.DisplayedActionData
            import de.cau.cs.kieler.klighd.kgraph.KGraphFactory
            import de.cau.cs.kieler.klighd.krendering.ViewSynthesisShared
            import de.cau.cs.kieler.klighd.krendering.extensions.KNodeExtensions
            import de.cau.cs.kieler.klighd.syntheses.AbstractDiagramSynthesis
            import «data.getBundleNamePrefix».viz.actions.RedoAction
            import «data.getBundleNamePrefix».viz.actions.ResetViewAction
            import «data.getBundleNamePrefix».viz.actions.StoreModelAction
            import «data.getBundleNamePrefix».viz.actions.UndoAction
            import «data.getBundleNamePrefix».model.IVisualizationContext
            import «data.getBundleNamePrefix».model.«data.visualizationName»
            «FOR view : data.views»
                import «data.getBundleNamePrefix».model.«view.name»OverviewContext
            «ENDFOR»
            import «data.getBundleNamePrefix».model.util.VizModelUtil
            «FOR view : data.views»
                import «data.getBundleNamePrefix».viz.subsyntheses.«view.name»OverviewSynthesis
            «ENDFOR»
            import «data.modelBundleNamePrefix».model.«data.projectName»
            import java.util.LinkedHashSet
            import org.eclipse.elk.alg.layered.options.CrossingMinimizationStrategy
            import org.eclipse.elk.alg.layered.options.LayeredMetaDataProvider
            import org.eclipse.elk.alg.layered.options.LayeredOptions
            import org.eclipse.elk.core.options.BoxLayouterOptions
            import org.eclipse.elk.core.util.BoxLayoutProvider.PackingMode
            
            import static «data.bundleNamePrefix».viz.Options.*
            import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
            
            /**
             * Main diagram synthesis for {@link «data.projectName»} models.
             */
            @ViewSynthesisShared
            class «data.projectName.toFirstUpper»DiagramSynthesis extends AbstractDiagramSynthesis<«data.projectName»> {
                @Inject extension KNodeExtensions
                @Inject extension Styles
                «FOR view : data.views»
                    @Inject «view.name»OverviewSynthesis «view.name.toFirstLower»OverviewSynthesis
                «ENDFOR»
                
                extension KGraphFactory = KGraphFactory.eINSTANCE
                
                override getInputDataType() {
                    «data.projectName»
                }
                
                override getDisplayedActions() {
                    return #[
                        DisplayedActionData.create(UndoAction.ID, "Undo",
                            "Undoes the last action performed on the view model."),
                        DisplayedActionData.create(RedoAction.ID, "Redo",
                            "Redoes the last action that was undone on the view model."),
                        DisplayedActionData.create(ResetViewAction.ID, "Reset View",
                            "Resets the view to its default overview state."),
                        DisplayedActionData.create(StoreModelAction.ID, "Store View Model",
                            "Stores the current view configuration and model to disk.")
                    ]
                }
                
                override getDisplayedLayoutOptions() {
                    return ImmutableList::of(
                        specifyLayoutOption(LayeredOptions::HIGH_DEGREE_NODES_TREATMENT, #[true, false]),
                        specifyLayoutOption(LayeredMetaDataProvider::CROSSING_MINIMIZATION_STRATEGY,
                            #[CrossingMinimizationStrategy.INTERACTIVE, CrossingMinimizationStrategy.LAYER_SWEEP])
                    )
                }
                
                override getDisplayedSynthesisOptions() {
                    val options = new LinkedHashSet()
                    
                    options.add(CONTAINER_CONNECTION_STYLE)        
                    
                    // Add category options.
                    options.addAll(FILTER_CATEGORY, TEXT_FILTER_CATEGORY, VIEW_FILTER_CATEGORY, PERFORMANCE)
                    
                    // Add all text filter options.
                    «FOR artifact : data.artifacts BEFORE "options.addAll(FILTER_BY, " SEPARATOR "," AFTER ")"»
                       FILTER_«artifact.name.toUpperCase(Locale.ROOT)»S
                    «ENDFOR»
                    
                    // Add all view filter options.
                    options.addAll(SHOW_EXTERNAL, CONTAINER_EDGES_WHEN_FOCUSED, SHORTEN_BY, INTERACTIVE_BUTTONS)
                    
                    // Add all artifact view filters.
                    «FOR artifact : data.artifacts»
                       «FOR view : data.getContainedViews(artifact) BEFORE "options.addAll(" SEPARATOR "," AFTER ")"»
                           «artifact.name.toUpperCase»_SHOW_«view.view.name.toUpperCase»
                       «ENDFOR»
                    «ENDFOR»
                    
                    // Add all performance options.
                    options.addAll(SHOW_ICONS, SHOW_SHADOWS)
                    
                    options.add(TOPDOWN_LAYOUT)
                    
                    return options.toList
                }
                
                override transform(«data.projectName» model) {
                    val modelNode = createNode.associateWith(model)
                    if (TOPDOWN_LAYOUT.booleanValue) {
                        SynthesisUtils.configureTopdownLayout(modelNode, true)
                    }
                    
                    // Create a view with the currently stored visualization context in mind. If there is no current context, create
                    // a new one for the general model overview and store that for later use.
                    val visualizationContexts = usedContext.getProperty(SynthesisProperties.VISUALIZATION_CONTEXTS)
                    var index = usedContext.getProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX)
                    var «data.visualizationName» visualizationContext = null
                    
                    if (!visualizationContexts.empty && index !== null) {
                        visualizationContext = visualizationContexts.get(index)
                    }
                    // If the visualization context is for another model than the model this method was called for or does not exist
                    // yet, reset the contexts.
                    if (visualizationContext === null || !visualizationContext.isRootModel(model)) {
                        visualizationContexts.removeIf [ true ]
                        index = 0
                        usedContext.setProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX, index)
                        visualizationContext = VizModelUtil.create«data.visualizationName»(model)
                        visualizationContexts.add(visualizationContext)
                    }
            
                    // Make this variable final here for later usage in the lambda.
                    val visContext = visualizationContext
                    if (visContext.focus === null) {
                        // This synthesis can be used.
                        
                        // The overview of the entire OSGi Project.
                        modelNode.children += createNode => [
                            associateWith(model)
                            data += createKIdentifier => [ it.id = visContext.hashCode.toString ]
                            SynthesisUtils.configureBoxLayout(it)
                            if (TOPDOWN_LAYOUT.booleanValue) {
                                SynthesisUtils.configureTopdownLayout(it, false)
                            }
                            addProjectRendering(model.projectName, usedContext)
                            «FOR view : data.views»
                                
                                val overview«view.name»Nodes = «view.name.toFirstLower»OverviewSynthesis.transform(visContext.«view.name.toFirstLower»OverviewContext)
                                children += overview«view.name»Nodes
                            «ENDFOR»
                        ]
                        
                        return modelNode
                        
                    } else {
                        // Delegate the view model generation to another subsynthesis that can show the requested visualization context.
                        val children = transformSubModel(visualizationContext.focus)
                        
                        modelNode.children += children
                        
                        return modelNode
                    }
                }
                
                private def transformSubModel(IVisualizationContext<?> context) {
                    switch (context) {
                        «FOR view : data.views»
                            «view.name»OverviewContext: {
                                return «view.name.toFirstLower»OverviewSynthesis.transform(context)
                            }
                        «ENDFOR»
                        default: {
                            throw new IllegalArgumentException("The context class has no known subsynthesis: " + context.class)
                        }
                    }
                }
                
            }
        '''
    }
    
    /**
     * Generates the content for the diagram synthesis for predefined visualization models.
     * 
     * @param data
     *      a DataAccess to easily get the information from
     * @return 
     *      the generated file content as a string
     */
    def static String generateVizDiagramSynthesis(DataAccess data) {
        return '''
           package «data.bundleNamePrefix».viz
           
           import com.google.inject.Inject
           import com.google.inject.Injector
           import de.cau.cs.kieler.klighd.Klighd
           import de.cau.cs.kieler.klighd.krendering.ViewSynthesisShared
           import de.cau.cs.kieler.klighd.syntheses.AbstractDiagramSynthesis
           import org.eclipse.elk.core.service.ILayoutConfigurationStore
           import org.eclipse.elk.core.service.LayoutConnectorsService
           import «data.bundleNamePrefix».model.Option
           import «data.bundleNamePrefix».model.«data.visualizationName»
           import «data.bundleNamePrefix».model.impl.«data.visualizationName»Impl
           
           /**
            * Diagram synthesis for predefined visualization models.
            * 
            * @author nre
            */
           @ViewSynthesisShared
           class «data.visualizationName»DiagramSynthesis extends AbstractDiagramSynthesis<«data.visualizationName»Impl> {
               
               @Inject «data.projectName»DiagramSynthesis diagramSynthesisDelegate
               
               override getInputDataType() {
                   «data.visualizationName»Impl
               }
               
               override getDisplayedActions() {
                   diagramSynthesisDelegate.displayedActions
               }
               
               override getDisplayedLayoutOptions() {
                   diagramSynthesisDelegate.displayedLayoutOptions
               }
                  
               override getDisplayedSynthesisOptions() {
                   diagramSynthesisDelegate.displayedSynthesisOptions
               }
               
               override transform(«data.visualizationName»Impl model) {
                   val visualizationContexts = usedContext.getProperty(SynthesisProperties.VISUALIZATION_CONTEXTS)
                   var index = usedContext.getProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX)
                   val rootVisualization = usedContext.getProperty(SynthesisProperties.MODEL_VISUALIZATION_CONTEXT)
                   var «data.visualizationName» visualizationContext = null
                   
                   if (!visualizationContexts.empty && index !== null) {
                       visualizationContext = visualizationContexts.get(index)
                   }
                   // If the visualization context is for another model than the model this method was called for or does not exist
                   // yet, reset the contexts.
                   if (visualizationContext === null || rootVisualization !== model) {
                       visualizationContexts.removeIf [ true ]
                       index = 0
                       usedContext.setProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX, index)
                       
                       // As we use a different model, the root model may differ from what is shown in the visualization
                       // context. So create a new visualization context and initialize and connect it with everything the old model
                       // had as well.
                       visualizationContext = VisualizationReInitializer.reInitialize(model)
                       visualizationContexts.add(visualizationContext)
                       usedContext.setProperty(SynthesisProperties.MODEL_VISUALIZATION_CONTEXT, model)
                       
                       // Set synthesis and layout options according to the stored options.
                       setSynthesisOptions(model.getSynthesisOptions)
                       setLayoutOptions(model.getLayoutOptions)
                       
                   }
                   
                   diagramSynthesisDelegate.transform(visualizationContext.getModelElement, usedContext)
               }
               
               /**
                * Configures the new synthesis options to be used during this synthesis.
                * 
                * @param newSynthesisOptions The new synthesis options to set.
                */
               protected def void setSynthesisOptions(Iterable<Option> newSynthesisOptions) {
                   val allSynthesisOptions = usedContext.displayedSynthesisOptions
                   for (storedOption : newSynthesisOptions) {
                       val option = allSynthesisOptions.findFirst [ id.equals(storedOption.id) ]
                       // Only configure options which are available.
                       if (option !== null) {
                           SynthesisUtils.configureSynthesisOption(option, storedOption.value, usedContext)
                       }
                   }
               }
               
               /**
                * Configures the new layout options to be used for layout runs on this model.
                * 
                * @param newLayoutOptions The new layout options to set.
                */
               protected def void setLayoutOptions(Iterable<Option> newLayoutOptions) {
                   if (!Klighd.IS_PLATFORM_RUNNING) {
                       println("Cannot load layout options without a running Eclipse platform, skipping.")
                       return
                   }
                   try {
                       val Injector injector = LayoutConnectorsService.instance.getInjector(null, usedContext)
                       val ILayoutConfigurationStore.Provider layoutConfigStoreProvider =
                           injector.getInstance(ILayoutConfigurationStore.Provider)
                       val ILayoutConfigurationStore layoutConfigStore =
                           layoutConfigStoreProvider.get(usedContext.diagramWorkbenchPart, usedContext.viewModel)
                       for (storedOptions : newLayoutOptions) {
                           layoutConfigStore.setOptionValue(storedOptions.id, storedOptions.value)
                       }
                   } catch (Throwable t) {
                       // Continue without loading the layout options, but log it on the console for now.
                       println("Cannot load the layout options for this model:")
                       t.printStackTrace
                   }
               }
               
           }
           
        '''
    }
    
    /**
     * Generates the content for the klighd setup.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return 
     *         the generated file content as a string
     */
    def static String generateKlighdSetup(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».viz
            
            import de.cau.cs.kieler.klighd.IKlighdStartupHook
            import de.cau.cs.kieler.klighd.KlighdDataManager
            import «data.bundleNamePrefix».viz.actions.ConnectAllAction
            import «data.getBundleNamePrefix».viz.actions.ContextCollapseExpandAction
            import «data.getBundleNamePrefix».viz.actions.ContextExpandAllAction
«««            import «spviz.packageName».viz.actions.ContextRemoveAction
            import «data.getBundleNamePrefix».viz.actions.DefocusAction
            import «data.getBundleNamePrefix».viz.actions.FocusAction
            import «data.getBundleNamePrefix».viz.actions.OverviewContextCollapseExpandAction
            «FOR connection : data.connections»
                import «data.getBundleNamePrefix».viz.actions.RevealConnected«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action
                import «data.getBundleNamePrefix».viz.actions.RemoveConnected«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action
                import «data.getBundleNamePrefix».viz.actions.RevealConnecting«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action
                import «data.getBundleNamePrefix».viz.actions.RemoveConnecting«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action
            «ENDFOR»
            import «data.getBundleNamePrefix».viz.actions.SelectRelatedAction
            import «data.getBundleNamePrefix».viz.actions.ShowHideCollapsedAction
            import «data.getBundleNamePrefix».viz.actions.UndoAction
            import «data.getBundleNamePrefix».viz.actions.RedoAction
            import «data.getBundleNamePrefix».viz.actions.ResetViewAction
            import «data.getBundleNamePrefix».viz.actions.StoreModelAction
            
            /**
             * Setup registering all KLighD extensions required to run this bundle.
             */
            class KlighdSetup implements IKlighdStartupHook {
                override execute() {
                    KlighdDataManager.instance
                    .registerAction(SelectRelatedAction.ID, new SelectRelatedAction)
                    .registerAction(FocusAction.ID, new FocusAction)
                    .registerAction(DefocusAction.ID, new DefocusAction)
                    .registerAction(UndoAction.ID, new UndoAction)
                    .registerAction(RedoAction.ID, new RedoAction)
                    .registerAction(ResetViewAction.ID, new ResetViewAction)
                    .registerAction(StoreModelAction.ID, new StoreModelAction)
                    .registerAction(ContextCollapseExpandAction.ID, new ContextCollapseExpandAction)
                    .registerAction(ContextExpandAllAction.ID, new ContextExpandAllAction)
«««                    .registerAction(ContextRemoveAction.ID, new ContextRemoveAction)
                    .registerAction(OverviewContextCollapseExpandAction.ID, new OverviewContextCollapseExpandAction)
                    .registerAction(ConnectAllAction.ID, new ConnectAllAction)
                    .registerAction(ShowHideCollapsedAction.ID, new ShowHideCollapsedAction)
                    «FOR connection : data.connections»
                        .registerAction(RevealConnected«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action.ID, new RevealConnected«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action)
                        .registerAction(RevealConnected«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action.Recursive.ID, new RevealConnected«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action.Recursive)
                        .registerAction(RemoveConnected«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action.ID, new RemoveConnected«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action)
                        .registerAction(RevealConnecting«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action.ID, new RevealConnecting«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action)
                        .registerAction(RevealConnecting«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action.Recursive.ID, new RevealConnecting«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action.Recursive)
                        .registerAction(RemoveConnecting«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action.ID, new RemoveConnecting«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action)
                    «ENDFOR»
                    .registerDiagramSynthesisClass(«data.projectName.toFirstUpper»DiagramSynthesis.name, «data.projectName.toFirstUpper»DiagramSynthesis)
                    .registerDiagramSynthesisClass(«data.visualizationName.toFirstUpper»DiagramSynthesis.name, «data.visualizationName.toFirstUpper»DiagramSynthesis)
                }
            }
            
        '''
    }
    
    /**
     * Generates the content for the synthesis styles class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return 
     *         the generated file content as a string
     */
    def static String generateStyles(DataAccess data) {
        // Generate colors for the artifacts as needed, distributed by means of the golden ratio around hue to generate
        // consistent and far spaced colors, no matter the number of artifacts.
        val float GOLDEN_RATIO = ((1 + Math.sqrt(5)) / 2) as float
        val Map<Artifact, String> colors = new HashMap
        val Map<Artifact, String> secondaryColors = new HashMap 
        val Map<Artifact, String> externalColors = new HashMap
        val Map<Artifact, String> externalSecondaryColors = new HashMap 
        val float s                   = 0.12f
        val float secondary_s         = 0.24f
        val float external_s          = 0.03f
        val float externalSecondary_s = 0.06f
        val b = 1.0f
        for (var i = 0; i < data.artifacts.length; i++) {
            // Distribute the color
            val float h = GOLDEN_RATIO * i
            
            // Create a color in HSB color space
            val color                  = Color.getHSBColor(h, s, b)
            val secondaryColor         = Color.getHSBColor(h, secondary_s, b)
            val externalColor          = Color.getHSBColor(h, external_s, b)
            val externalSecondaryColor = Color.getHSBColor(h, externalSecondary_s, b)
            
            // And convert it to RGB
            colors                 .put(data.artifacts.get(i), "#" + Integer.toHexString(color                 .RGB.bitwiseAnd(0xFFFFFF)))
            secondaryColors        .put(data.artifacts.get(i), "#" + Integer.toHexString(secondaryColor        .RGB.bitwiseAnd(0xFFFFFF)))
            externalColors         .put(data.artifacts.get(i), "#" + Integer.toHexString(externalColor         .RGB.bitwiseAnd(0xFFFFFF)))
            externalSecondaryColors.put(data.artifacts.get(i), "#" + Integer.toHexString(externalSecondaryColor.RGB.bitwiseAnd(0xFFFFFF)))
        }
            
        return '''
            package «data.getBundleNamePrefix».viz
            
            import com.google.inject.Inject
            import de.cau.cs.kieler.klighd.ViewContext
            import de.cau.cs.kieler.klighd.kgraph.KEdge
            import de.cau.cs.kieler.klighd.kgraph.KNode
            import de.cau.cs.kieler.klighd.kgraph.KPort
            import de.cau.cs.kieler.klighd.krendering.KContainerRendering
            import de.cau.cs.kieler.klighd.krendering.KPolyline
            import de.cau.cs.kieler.klighd.krendering.KRectangle
            import de.cau.cs.kieler.klighd.krendering.KRoundedRectangle
            import de.cau.cs.kieler.klighd.krendering.KText
            import de.cau.cs.kieler.klighd.krendering.LineStyle
            import de.cau.cs.kieler.klighd.krendering.ModifierState
            import de.cau.cs.kieler.klighd.krendering.ViewSynthesisShared
            import de.cau.cs.kieler.klighd.krendering.extensions.KColorExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KContainerRenderingExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KEdgeExtensions
«««            import de.cau.cs.kieler.klighd.krendering.extensions.KLabelExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KPolylineExtensions
            import de.cau.cs.kieler.klighd.krendering.extensions.KRenderingExtensions
            import «data.bundleNamePrefix».viz.actions.ConnectAllAction
            import «data.getBundleNamePrefix».viz.actions.ContextCollapseExpandAction
            import «data.getBundleNamePrefix».viz.actions.ContextExpandAllAction
«««            import «spviz.packageName».viz.actions.ContextRemoveAction
            import «data.getBundleNamePrefix».viz.actions.DefocusAction
            import «data.getBundleNamePrefix».viz.actions.FocusAction
            import «data.getBundleNamePrefix».viz.actions.OverviewContextCollapseExpandAction
            import «data.getBundleNamePrefix».viz.actions.SelectRelatedAction
            import «data.getBundleNamePrefix».viz.actions.ShowHideCollapsedAction
            «FOR connection : data.connections»
                import «data.getBundleNamePrefix».viz.actions.RevealConnected«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action
                import «data.getBundleNamePrefix».viz.actions.RemoveConnected«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action
                import «data.getBundleNamePrefix».viz.actions.RevealConnecting«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action
                import «data.getBundleNamePrefix».viz.actions.RemoveConnecting«connection.connecting.name»Connects«connection.connected.name»Named«connection.name»Action
            «ENDFOR»
            «FOR artifact : data.artifacts»
                import «data.modelBundleNamePrefix».model.«artifact.name»
            «ENDFOR»
«««            import java.util.List
            import static «data.getBundleNamePrefix».viz.Options.*
            
            import static extension de.cau.cs.kieler.klighd.microlayout.PlacementUtil.*
            import static extension de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses.*
            
            /**
             * The renderings and styles of Models.
             */
            @ViewSynthesisShared
            class Styles {
                @Inject extension KColorExtensions
                @Inject extension KContainerRenderingExtensions
                @Inject extension KEdgeExtensions
«««                @Inject extension KLabelExtensions
                @Inject extension KPolylineExtensions
                @Inject extension KRenderingExtensions
                
                // The colors used for the visualization.
                public static final String DEFAULT_BACKGROUND_COLOR = "white"
                «FOR artifact : data.artifacts»
                    public static final String COLOR_«artifact.name» = "«colors.get(artifact)»"
                    public static final String SECONDARY_COLOR_«artifact.name» = "«secondaryColors.get(artifact)»"
                    public static final String EXTERNAL_COLOR_«artifact.name» = "«externalColors.get(artifact)»"
                    public static final String EXTERNAL_SECONDARY_COLOR_«artifact.name» = "«externalSecondaryColors.get(artifact)»"
                «ENDFOR»
            
                // Port colors.
                public static final String ALL_SHOWN_COLOR = "white"
                public static final String NOT_ALL_SHOWN_COLOR = "black"
                
                public static final String SHADOW_COLOR = "black"
                
                // Edge colors.
                public static final String SELECTION_COLOR = "blue"
                
                /** The roundness of visualized rounded rectangles. */
                static final int ROUNDNESS = 4
                
                // ------------------------------------- Generic renderings -------------------------------------
                
                /**
                 * Sets the selection style of the node.
                 */
                def setSelectionStyle(KContainerRendering rendering) {
                    rendering => [
                        selectionLineWidth = 3 * lineWidthValue;
                        selectionForeground = SELECTION_COLOR.color;
                    ]
                }
                
                /**
                 * Adds a simple rendering for any named element to the given node.
                 * @param context The used ViewContext.
                 */
                def KRoundedRectangle addGenericRendering(KNode node, String name, ViewContext context) {
                    node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
                        if (context.getOptionValue(SHOW_SHADOWS) as Boolean) {
                            setShadow(SHADOW_COLOR.color, 4, 4)
                        }
                        addSimpleLabel(name)
                        setSelectionStyle
                    ]
                }
                
                /**
                 * Adds a rendering allowing a container rendering for any context with the given text as its headline.
                 * 
                 * @param node The KNode to add the rendering to.
                 * @param headlineText The headline presenting this overview.
                 * @param tooltipText What should be shown in a tooltip when hovering this overview.
                 * @param isExpanded if the overview rendering should show its children.
                 * @param isConnectable if the overview rendering contains connectable elements
                 * @param isFocused if the overview is currently focused
                 * @param context The used ViewContext.
                 */
                def void addOverviewRendering(KNode node, String headlineText, String tooltipText, boolean isExpanded,
                    boolean isConnectable, boolean isFocused, ViewContext context) {
                    if (isExpanded) {
                        // Expanded
                        node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
                            setGridPlacement(1)
                            addDoubleClickAction(OverviewContextCollapseExpandAction.ID)
                            addRectangle => [
                                var columns = 1
                                val interactiveButtons = context.getOptionValue(INTERACTIVE_BUTTONS) as Boolean
                                if (interactiveButtons) {
                                    columns += 4
                                    if (isConnectable) {
                                        columns += 1
                                    }
                                } 
                                setGridPlacement(columns)
                                invisible = true
                                addRectangle => [
                                    invisible = true
                                    addSimpleLabel(headlineText) => [
                                        fontBold = true
                                        selectionFontBold = true
                                    ]
                                ]
                                if (interactiveButtons) {
                                    addVerticalLine
                                    if (isFocused) {
                                        addDefocusButton(context)
                                    } else {
                                        addFocusButton(context)
                                    }
                                    addExpandAllButton(context)
                                    if (isConnectable) {
                                        addConnectAllButton(context)
                                    }
                                    addOverviewContextCollapseExpandButton(false, context)
                                }
                            ]
                            addHorizontalSeperatorLine(1, 0)
                            addChildArea
                            if (context.getOptionValue(SHOW_SHADOWS) as Boolean) {
                                setShadow(SHADOW_COLOR.color, 4, 4)
                            }
                            background = DEFAULT_BACKGROUND_COLOR.color
                            tooltip = tooltipText
                            setSelectionStyle
                        ]
                    } else {
                        // Collapsed
                        node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
                            setGridPlacement(1)
                            addDoubleClickAction(OverviewContextCollapseExpandAction.ID)
                            addRectangle => [
                                val interactiveButtons = context.getOptionValue(INTERACTIVE_BUTTONS) as Boolean
                                var columns = 1
                                if (interactiveButtons) {
                                    columns += 2
                                }
                                setGridPlacement(columns)
                                invisible = true
                                addRectangle => [
                                    invisible = true
                                    addSimpleLabel(headlineText)
                                ]
                                if (interactiveButtons) {
                                    addVerticalLine
                                    addOverviewContextCollapseExpandButton(true, context)
                                }
                            ]
                            if (context.getOptionValue(SHOW_SHADOWS) as Boolean) {
                                setShadow(SHADOW_COLOR.color, 4, 4)
                            }
                            background = DEFAULT_BACKGROUND_COLOR.color
                            tooltip = tooltipText
                            setSelectionStyle
                        ]
                    }
                }
                
                /**
                 * Adds the rendering in the overview, for the collapsed elements. May be hidden.
                 * 
                 * @param node The node representing and containing all collapsed elements in an overview.
                 * @param shown If the collapsed elements are currently shown
                 * @param showButton If the collapse/expand button is to be shown
                 * @param context The used ViewContext.
                 */
                def KContainerRendering addOverviewOfCollapsedRendering(KNode node, boolean shown, boolean showButton, ViewContext context) {
                    val actionId = ShowHideCollapsedAction::ID
                    val doWhat = shown ? "Hide" : "Show"
                    node.addInvisibleContainerRendering => [
                        addChildArea
                        // Button to show/hide this overview
                        val interactiveButtons = context.getOptionValue(INTERACTIVE_BUTTONS) as Boolean
                        if (interactiveButtons) {
                            addRoundedRectangle(2, 2) => [
                                tooltip = doWhat + " the collapsed elements"
                                setPointPlacementData(RIGHT, 2f, 0f, TOP, 2f, 0f, H_RIGHT, V_TOP, 4f, 4f, 0f, 0f)
                                
                                if (showButton) {
                                    // Either add an icon button or a text button, depending on its option.
                                    val showIcons = context.getOptionValue(SHOW_ICONS) as Boolean
                                    if (showIcons) {
                                        val imagePath = if (shown) "icons/minimize128.png" else "icons/restore128.png"
                                        addImage("«data.bundleNamePrefix».viz", imagePath) => [
                                            setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
                                            addSingleOrMultiClickAction(actionId)
                                        ]
                                    } else {
                                        addText(doWhat) => [
                                            suppressSelectability
                                            fontSize = 8
                                            fontBold = true
                                            selectionFontBold = true
                                            val size = estimateTextSize
                                            setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, size.width, size.height)
                                            addSingleOrMultiClickAction(actionId)
                                        ]
                                    }
                                }
                            ]
                        }
                    ]
                }
                
                /**
                 * Adds a vertical line without flexible width into a grid placement.
                 * 
                 * @param container The parent rendering this button should be added to.
                 */
                def KPolyline addVerticalLine(KContainerRendering container) {
                    container.addVerticalLine(RIGHT, 0, 1) => [
                        setGridPlacementData => [
                            flexibleWidth = false
                        ]
                    ]
                }
                
                /**
                 * Adds a button as a part of a grid placement rendering that will cause an action to be called.
                 * 
                 * @param container The parent rendering this button should be added to.
                 * @param text The text that should be displayed on the button.
                 * @param actionId The id of the action that should be called if the button is clicked.
                 */
                def KRectangle addButton(KContainerRendering container, String text, String actionId) {
                    return container.addRectangle => [
                        setGridPlacementData => [
                            flexibleWidth = false
                        ]
                        lineWidth = 0
                        addSingleOrMultiClickAction(actionId)
                        addText(text) => [
                            suppressSelectability
                            fontSize = 8
                            fontBold = true
                            selectionFontBold = true
                            val size = estimateTextSize
                            setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, size.width, size.height)
                            addSingleOrMultiClickAction(actionId)
                        ]
                    ]
                }
                
                /**
                 * Adds a button in a grid placement rendering that causes the {@link ContextCollapseAction} to be called.
                 * 
                 * @param container The parent rendering this button should be added to.
                 * @param expand Whether this button should expand or collapse. {@code true} for expanding, {@code false} for
                 * collapsing.
                 * @param context The used ViewContext.
                 */
                def KRectangle addCollapseExpandButton(KContainerRendering container, boolean expand, ViewContext context) {
                    val doWhat = if (expand) "Expand" else "Collapse"
                    val action = ContextCollapseExpandAction::ID
                    return container.addRectangle => [
                        setGridPlacementData => [
                            flexibleWidth = false
                        ]
                        addSingleOrMultiClickAction(action)
                        lineWidth = 0
                        tooltip = doWhat + " this element."
                        if (context.getOptionValue(SHOW_ICONS) as Boolean) {
                            val imagePath = if (expand) "icons/restore128.png" else "icons/minimize128.png"
                            addImage("«data.bundleNamePrefix».viz", imagePath) => [
                                setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
                                addSingleOrMultiClickAction(action)
                            ]
                        } else {
                            val label = if (expand) "+" else "-"
                            addButton(label, action)
                        }
                    ]
                }
                
                /**
                 * Adds a button in a grid placement rendering that causes the {@link ContextExpandAllAction} to be called.
                 * 
                 * @param container The parent rendering this button should be added to.
                 * @param context The used ViewContext.
                 */
                def KRectangle addExpandAllButton(KContainerRendering container, ViewContext context) {
                    val action = ContextExpandAllAction::ID
                    return container.addRectangle => [
                        setGridPlacementData => [
                            flexibleWidth = false
                        ]
                        addSingleOrMultiClickAction(action)
                        lineWidth = 0
                        tooltip = "Expand all elements in this overview."
                        if (context.getOptionValue(SHOW_ICONS) as Boolean) {
                            addImage("«data.bundleNamePrefix».viz", "icons/expand128.png") => [
                                setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
                                addSingleOrMultiClickAction(action)
                            ]
                        } else {
                            val label = "Expand all"
                            addButton(label, action)
                        }
                    ]
                }
                
                /**
                 * Adds a button in a grid placement rendering that causes the {@link ConnectAllAction} to be called.
                 * 
                 * @param container The parent rendering this button should be added to.
                 * @param context The used ViewContext.
                 */
                def KRectangle addConnectAllButton(KContainerRendering container, ViewContext context) {
                    val action = ConnectAllAction::ID
                    return container.addRectangle => [
                        setGridPlacementData => [
                            flexibleWidth = false
                        ]
                        addSingleOrMultiClickAction(action)
                        lineWidth = 0
                        tooltip = "Connects all elements in this overview."
                        if (context.getOptionValue(SHOW_ICONS) as Boolean) {
                            addImage("«data.bundleNamePrefix».viz", "icons/connect128.png") => [
                                setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
                                addSingleOrMultiClickAction(action)
                            ]
                        } else {
                            val label = "Connect all"
                            addButton(label, action)
                        }
                    ]
                }
«««                
«««                /**
«««                 * Adds a button in a grid placement rendering that causes the {@link ContextRemoveAction} to be called.
«««                 * 
«««                 * @param container The parent rendering this button should be added to.
«««                 */
«««                def KRectangle addRemoveButton(KContainerRendering container) {
«««                    return container.addButton("x", ContextRemoveAction::ID) => [
«««                        tooltip = "Remove this element from the view."
«««                    ]
«««                }
«««                
                /**
                 * Adds a button in a grid placement that causes the {@link OverviewContextCollapseExpandAction} to be called.
                 * 
                 * @param container The parent rendering this button should be added to.
                 * @param expand Whether this button should expand or collapse. {@code true} for expanding, {@code false} for
                 * collapsing.
                 * @param context The used ViewContext.
                 */
                def KRectangle addOverviewContextCollapseExpandButton(KContainerRendering container, boolean expand,
                    ViewContext context) {
                    val action = OverviewContextCollapseExpandAction::ID
                    val doWhat = if (expand) "Expand" else "Collapse"
                    return container.addRectangle => [
                        setGridPlacementData => [
                            flexibleWidth = false
                        ]
                        addSingleOrMultiClickAction(action)
                        lineWidth = 0
                        tooltip = doWhat + " this overview."
                        if (context.getOptionValue(SHOW_ICONS) as Boolean) {
                            val imagePath = if (expand) "icons/restore128.png" else "icons/minimize128.png"
                            addImage("«data.bundleNamePrefix».viz", imagePath) => [
                                setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
                                addSingleOrMultiClickAction(action)
                            ]
                        } else {
                            val label = if (expand) "+" else "-"
                            addButton(label, action)
                        }
                    ]
                }
                
                /**
                 * Adds a button in grid placement that causes the {@link FocusAction} to be called.
                 * 
                 * @param container The parent rendering this button should be added to.
                 * @param context The used ViewContext.
                 */
                def KRectangle addFocusButton(KContainerRendering container, ViewContext context) {
                    val action = FocusAction::ID
                    return container.addRectangle => [
                        setGridPlacementData => [
                            flexibleWidth = false
                        ]
                        addSingleOrMultiClickAction(action)
                        lineWidth = 0
                        tooltip = "Focus the view to this overview alone."
                        if (context.getOptionValue(SHOW_ICONS) as Boolean) {
                            addImage("«data.bundleNamePrefix».viz", "icons/loupe128.png") => [
                                setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
                                addSingleOrMultiClickAction(action)
                            ]
                        } else {
                            val label = "Focus"
                            addButton(label, action)
                        }
                    ]
                }
                
                /**
                 * Adds a button in grid placement that causes the {@link DefocusAction} to be called.
                 * 
                 * @param container The parent rendering this button should be added to.
                 * @param context The used ViewContext.
                 */
                def KRectangle addDefocusButton(KContainerRendering container, ViewContext context) {
                    val action = DefocusAction::ID
                    return container.addRectangle => [
                        setGridPlacementData => [
                            flexibleWidth = false
                        ]
                        addSingleOrMultiClickAction(action)
                        lineWidth = 0
                        tooltip = "Remove the focus from this overview."
                        if (context.getOptionValue(SHOW_ICONS) as Boolean) {
                            addImage("«data.bundleNamePrefix».viz", "icons/loupe-crossed128.png") => [
                                setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
                                addSingleOrMultiClickAction(action)
                            ]
                        } else {
                            val label = "Defocus"
                            addButton(label, action)
                        }
                    ]
                }
                
                /**
                 * Adds a simple text label to any rendering with some surrounding space for better readability.
                 */
                def KText addSimpleLabel(KContainerRendering rendering, String text) {
                    rendering.addText(text) => [
                        // Add surrounding space
                        setGridPlacementData().from(LEFT, 10, 0, TOP, 8, 0).to(RIGHT, 10, 0, BOTTOM, 8, 0)
                        // Remove the default bold property on selected texts.
                        selectionFontBold = false
                        suppressSelectability
                    ]
                }
                
                // ------------------------------------- Project renderings ------------------------------------
                /**
                 * Adds the rendering as a project overview.
                 * @param context The used ViewContext.
                 */
                def void addProjectRendering(KNode node, String projectName, ViewContext context) {
                    node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
                        setGridPlacement(1)
                        addRectangle => [
                            invisible = true
                            addSimpleLabel(projectName) => [
                                fontBold = true
                                selectionFontBold = true
                            ]
                        ]
                        addHorizontalSeperatorLine(1, 0)
                        addChildArea
                        if (context.getOptionValue(SHOW_SHADOWS) as Boolean) {
                            setShadow(SHADOW_COLOR.color, 4, 4)
                        }
                        background = DEFAULT_BACKGROUND_COLOR.color
                        tooltip = "The overview of all available views for this project."
                        setSelectionStyle
                    ]
                }
                
                def KRectangle addGenericInvisiblePortRendering(KPort port) {
                    return port.addRectangle => [
                        invisible = true
                    ]
                }
                
                «FOR artifact : data.artifacts»
                    // ------------------------------------- «artifact.name» renderings -------------------------------------
                    
                    /**
                     * Adds a simple rendering for a {@link «artifact.name»} to the given node that can be expanded to call the
                     * {link ReferencedSynthesisExpandAction} to dynamically call the feature synthesis for the given feature.
                     * 
                     * @param node The KNode to add this rendering to.
                     * @param aritfact The «artifact.name.toFirstLower» this rendering should represent.
                     * @param label The representing name of this feature that should be shown.
                     * @param context The used ViewContext.
                     */
                    def add«artifact.name»InOverviewRendering(KNode node, «artifact.name» artifact, String name, ViewContext context) {
                        node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
                            val interactiveButtons = context.getOptionValue(INTERACTIVE_BUTTONS) as Boolean
                            var columns = 1
                            if (interactiveButtons) {
                                columns += 2
                            }
                            setGridPlacement(columns)
                            addRectangle => [
                                invisible = true
                                addSimpleLabel(name)
                            ]
                            if (interactiveButtons) {
                                addVerticalLine
                                addCollapseExpandButton(true, context)
                            }
                            if (artifact.isExternal) {
                                setBackgroundGradient(EXTERNAL_COLOR_«artifact.name».color, EXTERNAL_SECONDARY_COLOR_«artifact.name».color, 90)
                            } else {
                                setBackgroundGradient(COLOR_«artifact.name».color, SECONDARY_COLOR_«artifact.name».color, 90)
                            }
                            addDoubleClickAction(ContextCollapseExpandAction::ID)
                            addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
                                ModifierState.NOT_PRESSED)
                            if (context.getOptionValue(SHOW_SHADOWS) as Boolean) {
                                setShadow(SHADOW_COLOR.color, 4, 4)
                            }
                            tooltip = "«artifact.name» \"" + artifact.getName + "\""
                            setSelectionStyle
                        ]
                    }
                    
                    /**
                     * Adds a rendering for a {@link «artifact.name»} to the given node.
                     * Contains the name of the «artifact.name.toFirstLower», a button to focus this artifact and text for the ID and description of this artifact.
                     * 
                     * @param node The KNode this rendering should be attached to.
                     * @param artifact The «artifact.name.toFirstLower» this rendering represents.
                     * @param inOverview If this product is shown in a «artifact.name.toFirstLower» overview.
                     * @param hasChildren If this rendering should leave space for a child area.
                     * @param context The view context used in the synthesis.
                     * 
                     * @return The entire rendering for a «artifact.name.toFirstLower».
                     */
                    def KRoundedRectangle add«artifact.name»Rendering(KNode node, «artifact.name» artifact, boolean inOverview, boolean hasChildren,
                        ViewContext context) {
                        node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
                            if (artifact.isExternal) {
                                setBackgroundGradient(EXTERNAL_COLOR_«artifact.name».color, EXTERNAL_SECONDARY_COLOR_«artifact.name».color, 90)
                            } else {
                                setBackgroundGradient(COLOR_«artifact.name».color, SECONDARY_COLOR_«artifact.name».color, 90)
                            }
                            setGridPlacement(1)
                            addRectangle => [
                                val interactiveButtons = context.getOptionValue(INTERACTIVE_BUTTONS) as Boolean
                                var columns = 1
                                if (interactiveButtons) {
                                    columns += 2
                                }
                                setGridPlacement(columns)
                                invisible = true
                                addRectangle => [
                                    invisible = true
                                    addSimpleLabel(SynthesisUtils.getId(artifact.getName, context)) => [
                                        fontBold = true
                                        selectionFontBold = true
                                    ]
                                ]
                                if (interactiveButtons) {
                                    addVerticalLine
                                    if (inOverview) {
                                        addCollapseExpandButton(false, context)
                                    } else {
«««                                        addRemoveButton
                                    }
                                }
                            ]
«««                            addHorizontalSeperatorLine(1, 0)
«««                            addRectangle => [
«««                                invisible = true
«««                                addSimpleLabel("ID: " + SynthesisUtils.getId(artifact.getName, context)) => [
«««                                    tooltip = "«artifact.name» \"" + artifact.getName + "\""
«««                                    addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
«««                                        ModifierState.NOT_PRESSED)
«««                                ]
«««                            ]
«««                            if (context.getOptionValue(FILTER_DESCRIPTIONS) as Boolean) {
«««                                val desc = SynthesisUtils.descriptionLabel(artifact.about, context)
«««                                if (!desc.empty) {
«««                                    addRectangle => [
«««                                        invisible = true
«««                                        addSimpleLabel("Description: " + desc) => [
«««                                            tooltip = p.about
«««                                            addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
«««                                                ModifierState.NOT_PRESSED)
«««                                        ]
«««                                    ]
«««                                }
«««                            }
                            if (hasChildren) {
                                addHorizontalSeperatorLine(1, 0)
                                addChildArea
                            }
                            if (context.getOptionValue(SHOW_SHADOWS) as Boolean) {
                                setShadow(SHADOW_COLOR.color, 4, 4)
                            }
                            addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
                                ModifierState.NOT_PRESSED)
                            setSelectionStyle
                        ]
                    }
                    
                    «FOR connected : data.getConnectedArtifacts(artifact)»
                        /**
                         * The rendering of a port that connects a «artifact.name» with the connected «connected.connected.name»s. Issues the
                         * {@link RevealConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»Action} or {@link RevealConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»Action.Recursive} if
                         * clicked when not all connected «connected.connected.name»s are shown, or the {@link RemoveConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»Action}
                         * if all are already shown.
                         */
                        def KRectangle addConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»PortRendering(KPort port, int numReferences, boolean allShown) {
                            return port.addRectangle => [
                                if (allShown) {
                                    background = ALL_SHOWN_COLOR.color
                                    tooltip = "Remove connected «connected.connected.name.toFirstLower»s via «connected.name»."
                                    addSingleClickAction(RemoveConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»Action::ID, ModifierState.DONT_CARE, ModifierState.NOT_PRESSED, ModifierState.DONT_CARE)
                                } else {
                                    background = NOT_ALL_SHOWN_COLOR.color
                                    tooltip = "Show connected «connected.connected.name.toFirstLower»s via «connected.name» (" + numReferences + " total)."
                                    addSingleClickAction(RevealConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»Action::ID, ModifierState.DONT_CARE, ModifierState.NOT_PRESSED, ModifierState.DONT_CARE)
                                }
                                addSingleClickAction(RevealConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»Action.Recursive::ID, ModifierState.DONT_CARE, ModifierState.PRESSED, ModifierState.DONT_CARE)
                            ]
                        }
                        
                        /**
                         * Adds the rendering for an edge showing a «connected.connected.name.toFirstLower» connection.
                         * 
                         * @param head if this edge shold render an arrow head.
                         * @param thick if this edge shold be rendered thicker.
                         */
                        def addConnected«connected.connecting.name»Connects«connected.connected.name»Named«connected.name»EdgeRendering(KEdge edge, boolean head, boolean thick) {
                            edge.addPolyline => [
                                lineWidth = thick ? 4 : 2
                                if (head) {
                                    addHeadArrowDecorator => [
                                        lineWidth = thick ? 2 : 1
                                        background = "black".color
                                        foreground = "black".color
                                        selectionLineWidth = thick ? 3 : 1.5f
                                        selectionForeground = SELECTION_COLOR.color
                                        selectionBackground = SELECTION_COLOR.color
                                        addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
                                            ModifierState.NOT_PRESSED)
                                        suppressSelectablility
                                    ]
                                }
                                lineStyle = LineStyle.DASH
                                selectionLineWidth = thick ? 6 : 3
                                selectionForeground = SELECTION_COLOR.color
                                addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
                                    ModifierState.NOT_PRESSED)
                            ]
                        }

                    «ENDFOR»
                    «FOR connecting : data.getConnectingArtifacts(artifact)»
                        /**
                         * The rendering of a port that connects a «artifact.name.toFirstLower» with the «connecting.connecting.name»s that connect it. Issues the
                         * {@link RevealConnecting«connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»Action} or {@link RevealConnecting«connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»Action.Recursive} if
                         * clicked when not all connecting «connecting.connecting.name»s are shown, or the {@link RemoveConnecting«connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»Action}
                         * if all are already shown.
                         */
                        def KRectangle addConnecting«connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»PortRendering(KPort port, int numReferences, boolean allShown) {
                            return port.addRectangle => [
                                if (allShown) {
                                    background = ALL_SHOWN_COLOR.color
                                    tooltip = "Remove connecting «connecting.connecting.name.toFirstLower»s via «connecting.name»."
                                    addSingleClickAction(RemoveConnecting«connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»Action::ID, ModifierState.DONT_CARE, ModifierState.NOT_PRESSED, ModifierState.DONT_CARE)
                                } else {
                                    background = NOT_ALL_SHOWN_COLOR.color
                                    tooltip = "Show connecting «connecting.connecting.name.toFirstLower»s via «connecting.name» (" + numReferences + " total)."
                                    addSingleClickAction(RevealConnecting«connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»Action::ID, ModifierState.DONT_CARE, ModifierState.NOT_PRESSED, ModifierState.DONT_CARE)
                                }
                                addSingleClickAction(RevealConnecting«connecting.connecting.name»Connects«connecting.connected.name»Named«connecting.name»Action.Recursive::ID, ModifierState.DONT_CARE, ModifierState.PRESSED, ModifierState.DONT_CARE)
                            ]
                        }
                    «ENDFOR»

                «ENDFOR»
                
                «FOR categoryConnection : data.getUniqueCategoryConnections»
                    /**
                     * Adds the rendering for a category edge showing a «categoryConnection.connectedCategory.name.toFirstLower» connection via their «categoryConnection.connectingArtifact.name.toFirstLower» to «categoryConnection.connectedArtifact.name.toFirstLower» «categoryConnection.connection.name.toFirstLower».
                     */
                    def addConnected«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»EdgeRendering(KEdge edge) {
                        edge.addPolyline => [
                            lineWidth = 4
                            lineStyle = LineStyle.DASH
                            selectionLineWidth = 6
                            selectionForeground = SELECTION_COLOR.color
                            addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
                                ModifierState.NOT_PRESSED)
                        ]
                    }
                «ENDFOR»
            }
            
        '''
    }
    
    /**
     * Generates the content for SynthesisUtils class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return 
     *         the generated file content as a string
     */
    def static String generateSynthesisUtils(DataAccess data) {
        val Set<Artifact> categoryArtifacts = newHashSet
        val Set<View> categoryViews = newHashSet
        
        for (categoryConnection : data.getUniqueCategoryConnections) {
            categoryArtifacts.add(categoryConnection.connectedArtifact)
            categoryArtifacts.add(categoryConnection.connectingArtifact)
            categoryArtifacts.add(categoryConnection.connectedCategory)
            categoryArtifacts.add(categoryConnection.connectingCategory)
            
            categoryViews.add(categoryConnection.innerView)
        }
        
        return '''
            package «data.getBundleNamePrefix».viz
            
            import de.cau.cs.kieler.klighd.SynthesisOption
            import de.cau.cs.kieler.klighd.ViewContext
            import de.cau.cs.kieler.klighd.kgraph.KNode
            import de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses
            import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
            import «data.getBundleNamePrefix».model.IVisualizationContext
            import java.util.EnumSet
            import java.util.List
            import java.util.Set
            import org.eclipse.elk.alg.layered.components.ComponentOrderingStrategy
            import org.eclipse.elk.alg.layered.options.LayeredOptions
            import org.eclipse.elk.alg.layered.options.OrderingStrategy
            import org.eclipse.elk.core.options.ContentAlignment
            import org.eclipse.elk.core.options.CoreOptions
            import org.eclipse.elk.core.options.Direction
            import org.eclipse.elk.core.options.EdgeRouting
            import org.eclipse.elk.core.options.PortConstraints
            import org.eclipse.elk.core.options.TopdownSizeApproximator
            import org.eclipse.elk.core.options.TopdownNodeTypes
            
            «FOR artifact : data.artifacts»
                import «data.modelBundleNamePrefix».model.«artifact.name.toFirstUpper»
            «ENDFOR»
            «FOR artifact : categoryArtifacts»
                import «data.bundleNamePrefix».model.«artifact.name.toFirstUpper»Context
            «ENDFOR»
            «FOR view : categoryViews»
                import «data.bundleNamePrefix».model.«view.name.toFirstUpper»OverviewContext
            «ENDFOR»
            «FOR categoryConnection : data.getUniqueCategoryConnections»
                import «data.bundleNamePrefix».model.«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container
            «ENDFOR»
            
            import static «data.bundleNamePrefix».viz.Options.*
            
            import static extension de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses.*
            import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
            
            /**
             * Util class that contains some static methods commonly used for the syntheses.
             * 
             * @author nre
             */
            final class SynthesisUtils {
                /**
                 * Utils class can not be instantiated.
                 */
                private new() {}
                
                /**
                 * If the id should be truncated by the prefix of the {@link Options#SHORTEN_BY} option, this returns a
                 * truncated version of the id, otherwise the id itself.
                 * 
                 * @param id The id that should possibly be truncated.
                 * @return The possibly truncated id.
                 */
                def static String getId(String id, ViewContext usedContext) {
                    val prefix = usedContext.getOptionValue(SHORTEN_BY) as String
                    if (!prefix.empty && id.startsWith(prefix)) {
                        return "..." + id.substring(prefix.length)
                    }
                    return id
                }
                
                def static <M> Iterable<M> filteredElements(List<M> elements, IOverviewVisualizationContext<M> oc,
                    ViewContext usedContext) {
                    val elementsInContext = elements.filter [
                        oc.modelElements.contains(it)
                    ]
                    
                    val regex = ".*" + usedContext.getOptionValue(FILTER_BY) as String + ".*"
                    if (!elementsInContext.empty) {
                        val (M) => boolean filter = switch (elementsInContext.head) {
                            «FOR artifact : data.artifacts» 
                                «artifact.name.toFirstUpper» case usedContext.getOptionValue(FILTER_«artifact.name.toUpperCase(Locale.ROOT)»S) === true: {
                                    [ (it as «artifact.name.toFirstUpper»).name.matches(regex) ]
                                }
                            «ENDFOR»
                            default: {
                                // In case the option for the filter is turned off, just return the given list.
                                null
                            }
                        }
                        if (filter === null) {
                            return elementsInContext
                        } else {
                            return elementsInContext.filter(filter)
                        }
                    } else {
                        return elementsInContext
                    }
                }
                
                /**
                 * Filters the list of given visualization contexts by the filter options of the diagram options.
                 * 
                 * @param visualizationContexts The unfiltered list of all visualization contexts.
                 * @param usedContext The ViewContext used to display the diagram these visualizations are shown in.
                 * @return An Iterable of the visualization contexts filtered by the diagram options.
                 */
                def static <M> Iterable<? extends IVisualizationContext<M>> filteredElementContexts(
                    List<? extends IVisualizationContext<M>> visualizationContexts, ViewContext usedContext) {
                    val regex = ".*" + usedContext.getOptionValue(FILTER_BY) as String + ".*"
                    if (!visualizationContexts.empty) {
                        val (IVisualizationContext<M>) => boolean filter = switch (visualizationContexts.head.modelElement) {
                            // The filter functions for the different artifacts, returns false if any filter does not match.
                            «FOR artifact : data.artifacts»
                                «artifact.name»: {
                                    [
                                        // The «artifact.name.toFirstLower»'s ID needs to match the FILTER_BY regex,
                                        if (usedContext.getOptionValue(FILTER_«artifact.name.toUpperCase(Locale.ROOT)»S) === true
                                            && !(modelElement as «artifact.name.toFirstUpper»).name.matches(regex)) {
                                            return false
                                        }
                                        // Filter out external elements if they should not be shown
                                        if ((usedContext.getOptionValue(Options.SHOW_EXTERNAL)) === false
                                            && (modelElement as «artifact.name»).isExternal) {
                                            return false
                                        }
                                        return true
                                    ]
                                }
                            «ENDFOR»
                            default: {
                                null
                            }
                        }
                        if (filter === null) {
                            return visualizationContexts
                        } else {
                            return visualizationContexts.filter(filter)
                        }
                    } else {
                        return visualizationContexts
                    }
                }
                
                «FOR categoryConnection : data.getUniqueCategoryConnections»
                    /**
                     * For a category connection between «categoryConnection.connectedCategory.name.toFirstLower» based on their «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» «categoryConnection.connection.name.toFirstLower» in «(categoryConnection.connection.connecting).name.toFirstLower»Dot«categoryConnection.connection.name.toFirstUpper» and given a such «categoryConnection.connectedCategory.name.toFirstLower» category container and a «categoryConnection.connectedCategory.name.toFirstLower»,
                     * returns all «categoryConnection.connectedCategory.name.toFirstLower» that are connected to the given «categoryConnection.connectedCategory.name.toFirstLower» in the container.
                     * 
                     * @param parentContext The «categoryConnection.connectedCategory.name.toFirstLower» category container.
                     * @param «categoryConnection.connectedCategory.name.toFirstLower» The connecting «categoryConnection.connectedCategory.name.toFirstLower».
                     * @return The connected «categoryConnection.connectedCategory.name.toFirstLower»s.
                     */
                    def static Iterable<«categoryConnection.connectedCategory.name.toFirstUpper»Context> shownConnectedCategoryConnections«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container parentContext, «categoryConnection.connectedCategory.name.toFirstUpper» «categoryConnection.connectedCategory.name.toFirstLower») {
                        val allConnections = shownCategoryConnections«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(parentContext, «categoryConnection.connectedCategory.name.toFirstLower»)
                        return allConnections.filter[it.key.modelElement === «categoryConnection.connectedCategory.name.toFirstLower»].map[it.value]
                    }
                    
                    /**
                     * For a category connection between «categoryConnection.connectedCategory.name.toFirstLower» based on their «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» «categoryConnection.connection.name.toFirstLower» in «(categoryConnection.connection.connecting).name.toFirstLower»Dot«categoryConnection.connection.name.toFirstUpper» and given a such «categoryConnection.connectedCategory.name.toFirstLower» category container and a «categoryConnection.connectedCategory.name.toFirstLower»,
                     * returns all «categoryConnection.connectedCategory.name.toFirstLower» that are connecting to the given «categoryConnection.connectedCategory.name.toFirstLower» in the container.
                     * 
                     * @param parentContext The «categoryConnection.connectedCategory.name.toFirstLower» category container.
                     * @param «categoryConnection.connectedCategory.name.toFirstLower» The connected «categoryConnection.connectedCategory.name.toFirstLower».
                     * @return The connecting «categoryConnection.connectedCategory.name.toFirstLower»s.
                     */
                    def static Iterable<«categoryConnection.connectedCategory.name.toFirstUpper»Context> shownConnectingCategoryConnections«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container parentContext, «categoryConnection.connectedCategory.name.toFirstUpper» «categoryConnection.connectedCategory.name.toFirstLower») {
                        val allConnections = shownCategoryConnections«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(parentContext, «categoryConnection.connectedCategory.name.toFirstLower»)
                        return allConnections.filter[it.value.modelElement === «categoryConnection.connectedCategory.name.toFirstLower»].map[it.key]
                    }
                    
                    def static Iterable<«data.bundleNamePrefix».model.Pair<«categoryConnection.connectedCategory.name.toFirstUpper»Context, «categoryConnection.connectedCategory.name.toFirstUpper»Context>> shownCategoryConnections«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container parentContext, «categoryConnection.connectedCategory.name.toFirstUpper» «categoryConnection.connectedCategory.name.toFirstLower») {
                        val allConnections = parentContext.«categoryConnection.connectingCategory.name.toFirstLower»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edges
                        return allConnections.filter[it.key.modelElement === «categoryConnection.connectedCategory.name.toFirstLower» || it.value.modelElement === «categoryConnection.connectedCategory.name.toFirstLower»]
                    }
                    
                    /**
                     * For a category connection between «categoryConnection.connectedCategory.name.toFirstLower» based on their «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» «categoryConnection.connection.name.toFirstLower» in «categoryConnection.innerView.name.toFirstLower» and given a such «categoryConnection.connectedCategory.name.toFirstLower» category container and a «categoryConnection.innerView.name.toFirstLower» container,
                     * returns all «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» connections that are connected to one of the «categoryConnection.connectedArtifact.name.toFirstLower» in the «categoryConnection.innerView.name.toFirstLower» container related to the «categoryConnection.connectedCategory.name.toFirstLower» cat container.
                     * 
                     * @param containerContext The «categoryConnection.connectedCategory.name.toFirstLower» cat container.
                     * @param parentContext The «categoryConnection.innerView.name.toFirstLower» container.
                     * @return The outgoing «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» «categoryConnection.connection.name.toFirstLower» connections.
                     */
                    def static Iterable<«data.bundleNamePrefix».model.Pair<«categoryConnection.connectingArtifact.name.toFirstUpper»Context, «categoryConnection.connectedArtifact.name.toFirstUpper»Context>> shownConnected«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container containerContext, «categoryConnection.innerView.name.toFirstUpper»OverviewContext parentContext) {
                        val allConnections = containerContext.«categoryConnection.connectingArtifact.name.toFirstLower»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edges
                        val all«categoryConnection.connectingArtifact.name.toFirstUpper»Contexts = parentContext.childContexts.filter(«categoryConnection.connectingArtifact.name.toFirstUpper»Context)
                        return allConnections.filter[ all«categoryConnection.connectingArtifact.name.toFirstUpper»Contexts.contains(it.key) ]
                    }
                    
                    /**
                     * For a category connection between «categoryConnection.connectedCategory.name.toFirstLower» based on their «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» «categoryConnection.connection.name.toFirstLower» in «categoryConnection.innerView.name.toFirstLower» and given a such «categoryConnection.connectedCategory.name.toFirstLower» category container and a «categoryConnection.innerView.name.toFirstLower» container,
                     * returns all «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» connections that are connecting to one of the «categoryConnection.connectedArtifact.name.toFirstLower» in the «categoryConnection.innerView.name.toFirstLower» container related to the «categoryConnection.connectedCategory.name.toFirstLower» cat container.
                     * 
                     * @param containerContext The «categoryConnection.connectedCategory.name.toFirstLower» cat container.
                     * @param parentContext The «categoryConnection.innerView.name.toFirstLower» container.
                     * @return The incoming «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower» «categoryConnection.connection.name.toFirstLower» connections.
                     */
                    def static Iterable<«data.bundleNamePrefix».model.Pair<«categoryConnection.connectingArtifact.name.toFirstUpper»Context, «categoryConnection.connectedArtifact.name.toFirstUpper»Context>> shownConnecting«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Container containerContext, «categoryConnection.innerView.name.toFirstUpper»OverviewContext parentContext) {
                        val allConnections = containerContext.«categoryConnection.connectingArtifact.name.toFirstLower»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edges
                        val all«categoryConnection.connectedArtifact.name.toFirstUpper»Contexts = parentContext.childContexts.filter(«categoryConnection.connectedArtifact.name.toFirstUpper»Context)
                        return allConnections.filter[ all«categoryConnection.connectedArtifact.name.toFirstUpper»Contexts.contains(it.value) ]
                    }
                «ENDFOR»
                
                /**
                 * Configures top-down layout for the given node.
                 * 
                 * @param node The node to configure.
                 * @param root If the {@code node} is the graph's root node.
                 
                 */
                def static void configureTopdownLayout(KNode node, boolean root) {
                    node => [
                        setLayoutOption(CoreOptions::TOPDOWN_LAYOUT, true)
                        setLayoutOption(CoreOptions::NODE_SIZE_FIXED_GRAPH_SIZE, true)
                        setLayoutOption(CoreOptions::TOPDOWN_NODE_TYPE, root ? TopdownNodeTypes.ROOT_NODE : TopdownNodeTypes.HIERARCHICAL_NODE)
                        setLayoutOption(CoreOptions::TOPDOWN_HIERARCHICAL_NODE_WIDTH, 150d)
                        setLayoutOption(CoreOptions::TOPDOWN_HIERARCHICAL_NODE_ASPECT_RATIO, 1.41d)
                        setLayoutOption(CoreOptions::TOPDOWN_SCALE_CAP, 1.0)
                        setLayoutOption(CoreOptions.TOPDOWN_SIZE_APPROXIMATOR, TopdownSizeApproximator.COUNT_CHILDREN)
                        if (!root) setLayoutOption(CoreOptions.CONTENT_ALIGNMENT, EnumSet.of(ContentAlignment.V_CENTER, ContentAlignment.H_CENTER))
                    ]
                }

                
                /**
                 * Configures the layout of any overview node. Configures the box layout algorithm of elk.
                 */
                def static void configureBoxLayout(KNode node) {
                    node => [
                        DiagramSyntheses.setLayoutOption(node, CoreOptions::ALGORITHM, "org.eclipse.elk.rectpacking")
«««                        // setLayoutOption(CoreOptions::EXPAND_NODES, true)
                    ]
                }
                
                /**
                 * Configures the layout on a overview for the top level node that shows the connection between elements within that
                 * overview.
                 * 
                 * @param node The node containing the elements of the overview.
                 */
                def static void configureOverviewLayout(KNode node) {
                    node => [
                        setLayoutOption(CoreOptions::ALGORITHM, "org.eclipse.elk.layered")
                        setLayoutOption(LayeredOptions.CONSIDER_MODEL_ORDER_COMPONENTS, ComponentOrderingStrategy.GROUP_MODEL_ORDER)
                        setLayoutOption(CoreOptions::DIRECTION, Direction.RIGHT)
                        setLayoutOption(CoreOptions::EDGE_ROUTING, EdgeRouting.POLYLINE)
                        setLayoutOption(CoreOptions::PORT_CONSTRAINTS, PortConstraints::FIXED_SIDE)
            //            setLayoutOption(CoreOptions::SEPARATE_CONNECTED_COMPONENTS, false)
                        setLayoutOption(CoreOptions::SEPARATE_CONNECTED_COMPONENTS, true)
                        setLayoutOption(LayeredOptions::CONSIDER_MODEL_ORDER_STRATEGY, OrderingStrategy::NODES_AND_EDGES)
                    ]
                }
                
                /**
                 * Configures the {@code option} of the {@code viewContext} with the new {@code value} while regarding some special
                 * cases that arise when using an arbitrary Object as the value.
                 * 
                 * @param option The synthesis option
                 * @param value The value for that option
                 * @param viewContext The current {@code ViewContext} in which the option is configured
                 */
                def static void configureSynthesisOption(SynthesisOption option, String value, ViewContext viewContext) {
                    if (option.isChoiceOption) {
                        // If the string representation matches between an option value and the new value, use that.
                        var newOption = option.values.findFirst[toString.equals(value.toString)]
                        if (option.values.contains(newOption)) {
                            viewContext.configureOption(option, newOption)
                        }
                    } else if (option.isRangeOption) {
                        val lowerBound = option.range.first
                        val upperBound = option.range.second
                        val stepSize = option.stepSize
                        val initialValue = option.initialValue as Number
                        if (lowerBound.equals(lowerBound.intValue())
                            && upperBound.equals(upperBound.intValue())
                            && stepSize.equals(stepSize.intValue())
                            && initialValue.equals(initialValue.intValue())) {
                            // The option contains an Integer
                            viewContext.configureOption(option, Float.parseFloat(value).intValue)
                        } else {
                            // The option contains a Float
                            viewContext.configureOption(option, Float.parseFloat(value))
                        }
                    } else if (option.isCheckOption) {
                        viewContext.configureOption(option, Boolean.parseBoolean(value))
                    } else if (option.isCategory) {
                        viewContext.configureOption(option, Boolean.parseBoolean(value))
                    } else if (option.isTextOption) {
                        viewContext.configureOption(option, value)
                    } else if (option.isSeparator) {
                        // Do nothing, separators cannot be configured.
                    }
                }
                
                «FOR categoryConnection : data.getUniqueCategoryConnections»
                    /**
                     * Helper method to find find all «categoryConnection.connectingArtifact.name.toFirstLower» to «categoryConnection.connectedArtifact.name.toFirstLower» connections with equal source «categoryConnection.connectingArtifact.name.toFirstLower» and target «categoryConnection.connectedCategory.name.toFirstLower». Writes the index of
                     * each first occurrence of a duplicate into the {@code firstDuplicateIndices} list and all indices of other
                     * occurrences of duplicates in the {@code otherDuplicateIndices} list.
                     * 
                     * @param pairList The list of pairs to find the duplicates in. Will not be changed.
                     * @param firstDuplicateIndices a list as that returns the indices of the first duplicates in the list. The list
                     *      will be cleared and filled with new indices as calculated by this method.
                     * @param otherDuplicateIndices a list as that returns the indices of the other duplicates in the list. The list
                     *      will be cleared and filled with new indices as calculated by this method.
                     */
                    def static void indicesOfEqual«categoryConnection.connectingArtifact.name.toFirstUpper»To«categoryConnection.connectedCategory.name.toFirstUpper»In«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(List<«data.bundleNamePrefix».model.Pair<«categoryConnection.connectingArtifact.name.toFirstUpper»Context, «categoryConnection.connectedArtifact.name.toFirstUpper»Context>> pairList, Set<Integer> firstDuplicateIndices, List<Integer> otherDuplicateIndices) {
                        firstDuplicateIndices.clear
                        otherDuplicateIndices.clear
                        for (var int i = 0; i < pairList.size; i++) {
                            val thisIndex = i // make the lambda happy with a final variable
                            if (!otherDuplicateIndices.contains(thisIndex)) {
                                val connection = pairList.get(thisIndex)
                                pairList.forEach [ otherPair, otherIndex |
                                    if (otherIndex !== thisIndex
                                        // both sources are the same
                                        && otherPair.key === connection.key
                                        // both targets are leading to the same overview
                                        && otherPair.value.parent === connection.value.parent
                                    ) {
                                        // found another pair with the same key and value.
                                        firstDuplicateIndices.add(thisIndex)
                                        otherDuplicateIndices.add(otherIndex)
                                    }
                                ]
                            }
                        }
                    }
                    
                    /**
                     * Helper method to find find all «categoryConnection.connectingArtifact.name.toFirstLower» to «categoryConnection.connectedArtifact.name.toFirstLower» connections with equal source «categoryConnection.connectedCategory.name.toFirstUpper» and target «categoryConnection.connectedArtifact.name.toFirstUpper». Writes the index of
                     * each first occurrence of a duplicate into the {@code firstDuplicateIndices} list and all indices of other
                     * occurrences of duplicates in the {@code otherDuplicateIndices} list.
                     * 
                     * @param pairList The list of pairs to find the duplicates in. Will not be changed.
                     * @param firstDuplicateIndices a list as that returns the indices of the first duplicates in the list. The list
                     *      will be cleared and filled with new indices as calculated by this method.
                     * @param otherDuplicateIndices a list as that returns the indices of the other duplicates in the list. The list
                     *      will be cleared and filled with new indices as calculated by this method.
                     */
                    def static void indicesOfEqual«categoryConnection.connectedCategory.name.toFirstUpper»To«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»(List<«data.bundleNamePrefix».model.Pair<«categoryConnection.connectingArtifact.name.toFirstUpper»Context, «categoryConnection.connectedArtifact.name.toFirstUpper»Context>> pairList, Set<Integer> firstDuplicateIndices, List<Integer> otherDuplicateIndices) {
                        firstDuplicateIndices.clear
                        otherDuplicateIndices.clear
                        for (var int i = 0; i < pairList.size; i++) {
                            val thisIndex = i // make the lambda happy with a final variable
                            if (!otherDuplicateIndices.contains(thisIndex)) {
                                val connection = pairList.get(thisIndex)
                                pairList.forEach [ otherPair, otherIndex |
                                    if (otherIndex !== thisIndex
                                        // both sources are leading to the same overview
                                        && otherPair.key.parent === connection.key.parent
                                        // both targets are the same
                                        && otherPair.value === connection.value
                                    ) {
                                        // found another pair with the same key and value.
                                        firstDuplicateIndices.add(thisIndex)
                                        otherDuplicateIndices.add(otherIndex)
                                    }
                                ]
                            }
                        }
                    }
                    
                «ENDFOR»
            }
            
            
        '''
    }
    
    /**
     * Generates the content for SynthesisProperties class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return 
     *         the generated file content as a string
     */
    def static String generateSynthesisProperties(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».viz
            
            import de.cau.cs.kieler.klighd.ViewContext
            import «data.getBundleNamePrefix».model.«data.visualizationName»
            import java.util.LinkedList
            import java.util.List
            import org.eclipse.elk.graph.properties.IProperty
            import org.eclipse.elk.graph.properties.Property
            
            /**
             * Class to provide easy access to properties stored for the syntheses.
             */
            class SynthesisProperties {
                /** 
                 * Property pointing towards the list of saved {@link «data.visualizationName»}s that are used to model the currently
                 * displayed view and all previously used contexts for undo/redo functionality.
                 * Currently does not store a delta between the contexts, but a hard copy of every state used since the beginning
                 * default view.
                 */
                public static final IProperty<List<«data.visualizationName»>> VISUALIZATION_CONTEXTS = new Property<List<«data.visualizationName»>>("osgimodel.visualizationContexts", new LinkedList<«data.visualizationName»>)
                
                /**
                 * Property pointing towards which index points towards the currently used visualization context in the
                 * {@link SynthesisProperties#VISUALIZATION_CONTEXTS} property that both are stored in the {@link ViewContext}
                 * used to display the view model.
                 * May be null if no visualization context has been set yet.
                 */
                public static final IProperty<Integer> CURRENT_VISUALIZATION_CONTEXT_INDEX = new Property<Integer>("model.currentVisualizationContextIndex", null)
                
                /**
                 * The root model visualization context for the VizSynthesis to figure out the change of file against the usual
                 * change of the visualization model.
                 * May be null if the model visualization context has not been set yet for the view context.
                 */
                public static final IProperty<«data.visualizationName»> MODEL_VISUALIZATION_CONTEXT = new Property<«data.visualizationName»>("model.modelVisualizationContext", null)
                
            }
            
        '''
    }
    
    /**
     * Generates the content for Options class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return 
     *         the generated file content as a string
     */
    def static String generateOptions(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».viz
            
            import de.cau.cs.kieler.klighd.SynthesisOption
            
            /**
             * A collection of all options that are used in the synthesis and their required enums.
             */
            class Options {
                /** The enum holding all possible values for the {@link #BUNDLE_TEXT} option. */
                enum SimpleTextType {
                    Id, Name
                }
                
                /** Option for setting the main text to be shown in unexpanded objects. */
                public static final SynthesisOption SIMPLE_TEXT = SynthesisOption.createChoiceOption("Descriptive text",
                    #[SimpleTextType.Id, SimpleTextType.Name], SimpleTextType.Id)
                    .description = "Set the main text to be shown in unexpanded objects."
                
                /** Debug option to toggle the display style of container connection edges. */
                public static final SynthesisOption CONTAINER_CONNECTION_STYLE = SynthesisOption.createCheckOption("DEBUG: Container Connection Style", true)
                    .description = "Set the container connection style: true (on) for splitting at the artifact->inner overview border, false (off) for splitting at the outer overview->artifact border."
                
                /** Category option containing options for filtering. */
                public static final SynthesisOption FILTER_CATEGORY = SynthesisOption.createCategory("Filter", true)
                    .description = "Category containing options for filtering."
                
                /** Category option containing options for text filtering. */
                public static final SynthesisOption TEXT_FILTER_CATEGORY = SynthesisOption.createCategory("Text filter", false)
                    .setCategory(FILTER_CATEGORY)
                    .description = "Category for filtering based on texts."
                
                /** Option for filtering an overview by only elements containing the regular expression in their identifier. */
                public static final SynthesisOption FILTER_BY = SynthesisOption.createTextOption(
                    "Filter by IDs containing ... (Java regex)", "").setCategory(TEXT_FILTER_CATEGORY)
                    .description = "Filter an overview by only elements containing the regular expression in their identifier. You may use a Java regex to specify complex filters."
                
                «FOR artifact : data.artifacts»
                    /** Option that indicates if the {@link #FILTER_BY} option should be applied to shown «artifact.name»s. */
                    public static final SynthesisOption FILTER_«artifact.name.toUpperCase(Locale.ROOT)»S = SynthesisOption.createCheckOption(
                        "Apply to «artifact.name»s", true).setCategory(TEXT_FILTER_CATEGORY)
                        .description = "Indicates if the \"Filter by IDs containing ...\"-option should be applied to shown «artifact.name»s."
                «ENDFOR»
                
                /** Category option containing options for view filtering. */
                public static final SynthesisOption VIEW_FILTER_CATEGORY = SynthesisOption.createCategory("View filter", false)
                    .setCategory(FILTER_CATEGORY)
                    .description = "Category for filtering the view."
                
                /** Option indicating whether external elements should be shown. */
                public static final SynthesisOption SHOW_EXTERNAL = SynthesisOption.createCheckOption(
                    "External elements", true).setCategory(VIEW_FILTER_CATEGORY)
                    .description = "Changes whether elements not directly defined in the model should be shown."
                
                public static final SynthesisOption CONTAINER_EDGES_WHEN_FOCUSED = SynthesisOption.createCheckOption(
                    "Container edges when focused", true).setCategory(VIEW_FILTER_CATEGORY)
                    .description = "Changes whether overviews that are shown in categories and have container edges should show their edges going out of the overview."
                
                /** Category option containing options for filtering artifact views. */
                public static final SynthesisOption ARTIFACT_VIEW_FILTER_CATEGORY = SynthesisOption.createCategory("Artifact overview filter", false)
                    .setCategory(FILTER_CATEGORY)
                    .description = "Category for filtering overviews shown within artifacts."
                
                «FOR artifact : data.artifacts»
                    «FOR view : data.getContainedViews(artifact)»
                            /** Option indicating whether «view.view.name.toFirstLower» overviews should be shown in «artifact.name.toFirstLower»s. */
                            public static final SynthesisOption «artifact.name.toUpperCase»_SHOW_«view.view.name.toUpperCase»= SynthesisOption.createCheckOption(
                                "«view.view.name.toFirstUpper» Overviews in «artifact.name.toFirstUpper»", true).setCategory(ARTIFACT_VIEW_FILTER_CATEGORY)
                                .description = "Changes whether «view.view.name.toFirstUpper» overviews are shown within «artifact.name.toFirstUpper»."
                            
                    «ENDFOR»
                «ENDFOR»
                /** Option for limiting the length of descriptive texts. */
                public static final SynthesisOption DESCRIPTION_LENGTH = SynthesisOption.createRangeOption(
                    "Description text length", 0, 500, 1, 20).setCategory(VIEW_FILTER_CATEGORY)
                    .description = "Limit the length of descriptive texts to this maximum value."
                
                /** Option for shortening all IDs by the prefix in the option. */
                public static final SynthesisOption SHORTEN_BY = SynthesisOption.createTextOption(
                    "Shorten IDs by").setCategory(VIEW_FILTER_CATEGORY)
                    .description = "Shorten the IDs of all artifacts by this prefix."
                
                /** Option for showing interactive buttons. */
                public static final SynthesisOption INTERACTIVE_BUTTONS = SynthesisOption.createCheckOption(
                    "Interactive Buttons", true).setCategory(VIEW_FILTER_CATEGORY)
                    .description = "Shows interactive buttons for navigating this view."
                
                
                /** Category option containing options for graphical performance. */
                public static final SynthesisOption PERFORMANCE = SynthesisOption.createCategory("Performance", false)
                    .description = "Options for graphical performance."
                    
                /** Option for using Icons or simpler texts. */
                public static final SynthesisOption SHOW_ICONS = SynthesisOption.createCheckOption("Icons", true)
                    .setCategory(PERFORMANCE)
                    .description = "Use images as icons for the buttons. Inflates the view model and reduces performance for a cleaner view."
                
                /** Option for enabling shadow effects on any artifacts. */
                    public static final SynthesisOption SHOW_SHADOWS = SynthesisOption.createCheckOption("Shadows", false)
                        .setCategory(PERFORMANCE)
                        .description = "Show a shadow effect for any artifact."
                
                public static final SynthesisOption TOPDOWN_LAYOUT = SynthesisOption.createCheckOption("Topdown Layout", false)
                    .description = "Switch between ELK'S top-down and bottom-up layout."
            }
            
        '''
    }
    
    /**
     * Generates the content for the FileHandler class.
     * 
     * @param data
     *      a DataAccess to easily get the information from
     * @return 
     *      the generated file content as a string
     */
    def static String generateFileHandler(DataAccess data) {
        return '''
           package «data.getBundleNamePrefix».viz
           
           import com.google.inject.Injector
           import de.cau.cs.kieler.klighd.Klighd
           import de.cau.cs.kieler.klighd.ViewContext
           import java.io.File
           import java.nio.file.Files
           import java.nio.file.Paths
           import java.text.SimpleDateFormat
           import java.util.Collections
           import java.util.Date
           import java.util.List
           import org.eclipse.core.runtime.IStatus
           import org.eclipse.core.runtime.Status
           import org.eclipse.elk.core.data.LayoutMetaDataService
           import org.eclipse.elk.core.service.ILayoutConfigurationStore
           import org.eclipse.elk.core.service.LayoutConfigurationManager
           import org.eclipse.elk.core.service.LayoutConnectorsService
           import org.eclipse.emf.common.util.URI
           import org.eclipse.emf.ecore.EObject
           import org.eclipse.emf.ecore.resource.Resource
           import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
           import org.eclipse.emf.ecore.util.EcoreUtil.Copier
           import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
           import «data.getBundleNamePrefix».model.«data.visualizationName»
           import «data.getBundleNamePrefix».model.«data.visualizationName»Factory
           import «data.getBundleNamePrefix».model.«data.visualizationName»Package
           import «data.modelBundleNamePrefix».model.«data.projectName»
           import «data.modelBundleNamePrefix».model.«data.spvizModel.name»Package
           
           import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
           
           /**
            * Writes to and reads from a temporary file, which contains the current {@link «data.visualizationName»}.
            * It is used to keep the visualization contexts state as long as the virtual machine is running.
            * 
            * @author ldi, nre
            */
           class FileHandler {
               
               /** No instanciation of this class, only static use. */
               private new() {}
           
               static URI tempDirURI = null;
           
               /**
                * Create a temporary folder for this session.
                */
               def static void createTempFolder() {
                   val systempTempPath = Paths.get(System.getProperty("java.io.tmpdir"))
                   val tempPath = Files.createTempDirectory(systempTempPath, "spviz");
                   tempPath.toFile().deleteOnExit();
                   tempDirURI = URI.createURI(tempPath.toUri().toString())
               }
           
               /**
                * @param viewContext
                *  a {@link ViewContext} to read the input file URI from
                * @return the temporary file name
                */
               def static String getSourceFileName(ViewContext viewContext) {
                   val obj = viewContext.getInputModel() as EObject
                   val URI uri = obj.eResource.URI
                   var fileName = uri.lastSegment()
                   val stripFileEnding = "«data.spvizModel.name.toLowerCase»"
                   if (fileName.endsWith(stripFileEnding)) {
                       fileName = fileName.substring(0, fileName.lastIndexOf(stripFileEnding)) + "«data.spviz.name.toLowerCase»"
                   }
                   return fileName
               }
           
               /**
                * Reads and returns a «data.visualizationName» from the related temp file, if it exists.
                * 
                * @param name
                *      for constructing the URI to load
                * @return a {@link «data.visualizationName»} or null, if no file exists for the given name
                */
               def static «data.visualizationName» getFromTempFile(String name) {
                   if(tempDirURI === null) return null
                   val emfURI = tempDirURI.appendSegment(name)
           
                   val resSet = new ResourceSetImpl
                   // check if a file at that URI exists
                   if (resSet.getURIConverter().exists(emfURI, null)) {
                       val res = resSet.createResource(emfURI)
                       res.load(Collections.EMPTY_MAP)
           
                       val iterator = res.getContents().iterator()
                       while (iterator.hasNext()) {
                           val checkViz = iterator.next() as «data.visualizationName»
                           if(checkViz !== null) return checkViz
                       }
                   }
                   return null
               }
           
               /**
                * (over)writes the current «data.visualizationName» into the (temp) file.
                * 
                * @param viewContext
                *      The ViewContext for which its model should be saved.
                * @param isTemp
                *      If {@code true}, the file is saved in a temporary directory (always the same file), or
                *      next to original (always a new file) otherwise.
                */
               def static void writeCurrentModelToFile(ViewContext viewContext, boolean isTemp) {
                   if (isTemp && tempDirURI === null) createTempFolder()
           
                   try {
                       // Get the currently viewed model from the context.
                       val int index = viewContext.getProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX)
                       val List<«data.visualizationName»> contexts = viewContext.getProperty(SynthesisProperties.VISUALIZATION_CONTEXTS)
                       val «data.visualizationName» currentContext = contexts.get(index)
           
                       // Also get the model referred by the viz and store that as well.
                       val «data.visualizationName» rootContext = currentContext.rootVisualization
                       val «data.projectName» rootModel = rootContext?.modelElement
           
                       // Take a copy of the context and model first to not mess up the current resource they might be stored in.
                       val Copier copier = new Copier(true, true)
                       val «data.projectName» copiedModel = copier.copy(rootModel) as «data.projectName»
                       val «data.visualizationName» copiedRoot = copier.copy(rootContext) as «data.visualizationName»
                       val copiedContext = if (currentContext === rootContext) {
                               copiedRoot
                           } else {
                               copier.copy(currentContext) as «data.visualizationName»
                           }
                       copier.copyReferences
           
                       // Persist the current state of KLighD's synthesis options in the model...
                       // ...the synthesis options
                       storeSynthesisOptions(copiedRoot, viewContext)
                       // ...and the layout options
                       storeLayoutOptions(copiedRoot, viewContext)
           
                       // Store the model.
                       val r = Resource.Factory.Registry.INSTANCE
                       val extensionFactories = r.getExtensionToFactoryMap
                       val vizFileEnding = "«data.spviz.name.toLowerCase»"
                       val modelFileEnding = "«data.spvizModel.name.toLowerCase»"
                       extensionFactories.put(vizFileEnding, new XMIResourceFactoryImpl)
                       extensionFactories.put(modelFileEnding, new XMIResourceFactoryImpl)
                       val resSet = new ResourceSetImpl
                       resSet.packageRegistry.put(«data.visualizationName»Package.eNS_URI, «data.visualizationName»Package.eINSTANCE)
                       resSet.packageRegistry.put(«data.spvizModel.name»Package.eNS_URI, «data.spvizModel.name»Package.eINSTANCE)
           
                       // build URI for viz file
                       var URI writeURI
                       if (isTemp) {
                           val sourceName = getSourceFileName(viewContext)
                           writeURI = tempDirURI
                           writeURI = writeURI.appendSegment(sourceName)
                           // Clear up the temp files during shutdown.
                           new File(writeURI.toFileString).deleteOnExit
                       } else {
                           writeURI = rootModel.eResource().getURI().trimSegments(1)
                           val projectName = rootModel.projectName
                           val timeStamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date)
                           val fileName = projectName + "-visualization-" + timeStamp + "." + vizFileEnding
                           writeURI = writeURI.appendSegment(fileName)
                       }
                       // prepare Resource
                       val res = resSet.createResource(writeURI)
                       res.getContents().add(copiedContext)
           
                       // A resource to hold the original model to reference to while saving
                       val modelRes = resSet.createResource(rootModel.eResource().getURI())
                       modelRes.getContents().add(copiedModel)
           
                       // Save the content.
                       res.save(Collections.EMPTY_MAP)
                   } catch (Throwable t) {
                       Klighd.log(
                           new Status(IStatus.ERROR, "«data.getBundleNamePrefix».viz",
                               "Something went wrong while saving the current model in a temp file:", t));
                   }
               }
           
               /**
                * Stores the currently used synthesis options in the visualization context.
                * 
                * @param visualizationContext The context to save the current options to.
                * @param viewContext The view context used to display the current diagram.
                */
               protected def static void storeSynthesisOptions(«data.visualizationName» visualizationContext, ViewContext viewContext) {
                   val synthesisOptions = viewContext.displayedSynthesisOptions
                   visualizationContext.synthesisOptions.clear
                   for (option : synthesisOptions) {
                       val storedOption = «data.visualizationName»Factory.eINSTANCE.createOption => [
                           id = option.id
                           value = viewContext.getOptionValue(option).toString
                       ]
                       visualizationContext.synthesisOptions.add(storedOption)
                   }
               }
           
               /**
                * Stores the currently used layout options in the visualization context.
                * 
                * @param visualizationContext The context to save the current options to.
                * @param viewContext The view context used to display the current diagram.
                */
               protected def static void storeLayoutOptions(«data.visualizationName» visualizationContext, ViewContext viewContext) {
                   val layoutOptions = viewContext.displayedLayoutOptions
                   visualizationContext.layoutOptions.clear
                   // We need to obtain the LayoutConfigurationManager responsible for the view context to get
                   // the current options.
                   // This works in Eclipse-mode, but not in standalone-mode, as the returned injector is null
                   // This is because no org.eclipse.elk.core.service.layoutConnectors can be registered without a running 
                   // platform and Eclipse extension points (or so it seems).
                   // I probably need to find a way to correctly register everything from ELK in non-Eclipse-mode and also use that
                   // to configure the options in the LSP; currently that stores the layout config itself and does not use any ELK
                   // stuff for that.
                   // See ELK Issue #719 for details https://github.com/eclipse/elk/issues/719
                   if (!Klighd.IS_PLATFORM_RUNNING) {
                       println("Cannot store layout options without a running Eclipse platform, skipping.")
                       return
                   }
                   try {
                       val Injector injector = LayoutConnectorsService.instance.getInjector(null, viewContext)
                       val LayoutConfigurationManager layoutConfigManager = injector.getInstance(LayoutConfigurationManager)
                       val ILayoutConfigurationStore.Provider layoutConfigStoreProvider = injector.getInstance(
                           ILayoutConfigurationStore.Provider)
                       for (option : layoutOptions) {
                           val optionData = LayoutMetaDataService.instance.getOptionData(option.first.id)
                           val layoutConfigStore = layoutConfigStoreProvider.get(viewContext.diagramWorkbenchPart,
                               viewContext.viewModel)
                           val optionValue = layoutConfigManager.getOptionValue(optionData, layoutConfigStore)
                           val storedOption = «data.visualizationName»Factory.eINSTANCE.createOption => [
                               id = option.first.id
                               value = optionValue.toString
                           ]
                           visualizationContext.layoutOptions.add(storedOption)
                       }
                   } catch (Throwable t) {
                       // Continue without storing the layout options, but log it on the console for now.
                       println("Cannot store the layout options for this model in non-Eclipse mode.")
                       // t.printStackTrace
                   }
               }
           }
           
        '''
    }
    
    /**
     * Generates the content for the VisualizationReInitializer class.
     * 
     * @param data
     *      a DataAccess to easily get the information from
     * @return 
     *      the generated file content as a string
     */
    def static String generateVisualizationReInitializer(DataAccess data) {
        return '''
            package «data.bundleNamePrefix».viz
            
            import «data.bundleNamePrefix».model.IOverviewVisualizationContext
            import «data.bundleNamePrefix».model.IVisualizationContext
            import «data.bundleNamePrefix».model.«data.visualizationName»
            import «data.bundleNamePrefix».model.util.VizModelUtil
            
            «FOR artifact : data.artifacts»
                import «data.bundleNamePrefix».model.«artifact.name»Context
            «ENDFOR»
            «FOR view : data.views»
                import «data.getBundleNamePrefix».model.«view.name»OverviewContext
            «ENDFOR»
            
            import static extension «data.bundleNamePrefix».model.util.ContextExtensions.*
            
            /**
             * Helper class for the {@link «data.visualizationName»Synthesis} that re-initializes a {@link «data.visualizationName»} loaded from a file for that the
             * connected {@link «data.projectName»} has changed. The main helper method {@link #reInitialize(«data.visualizationName»)} handles this
             * possible mismatch between the visualization context and its model by creating a new visualization context that
             * connects to everything still matched in the «data.projectName» while omitting and not connecting parts that are removed from
             * the model.
             * 
             * @author nre
             */
            class VisualizationReInitializer {
                
                /**
                 * Re-initializes a new visualization context to be as close as possible to the given old visualization context
                 * while respecting the data given in the model element of the visualization.
                 * To be executed if a loaded visualization context is to be displayed for that the underlying model may have
                 * updated and references in the visualization context therefore may not be correct anymore.
                 * 
                 * @param oldViz The loaded visualization context to be replicated as best as possible with its contained model.
                 * @returns A new visualization context matching the old one.
                 */
                static def «data.visualizationName» reInitialize(«data.visualizationName» oldViz) {
                    val newViz = VizModelUtil.create«data.visualizationName»(oldViz.modelElement)
                    // If the children of the old context have been initialized, initialize the new context as well and check
                    // all children.
                    if (oldViz.childrenInitialized) {
                        newViz.initializeChildVisualizationContexts
                        // First, reinitialize all child contexts to be the same as before.
                        «FOR view : data.views»
                            reInitialize(oldViz.«view.name.toFirstLower»OverviewContext, newViz.«view.name.toFirstLower»OverviewContext)
                            if (oldViz.focus === oldViz.«view.name.toFirstLower»OverviewContext) {
                                newViz.focus = newViz.«view.name.toFirstLower»OverviewContext
                            }
                        «ENDFOR»
                        // Only after all child contexts are as before, reconnect them as before.
                        «FOR view : data.views»
                            reConnect(oldViz.«view.name.toFirstLower»OverviewContext, newViz.«view.name.toFirstLower»OverviewContext)
                        «ENDFOR»
                    }
                    
                    if (oldViz.focus !== null && newViz.focus === null) {
                        // TODO: let the user know that the focus got lost due to the model having changed.
                        System.out.println("SPViz: Focus reset, as the underlying model does not allow for that view anymore.")
                    }
                    return newViz
                }
                
                «FOR view : data.views»
                    /**
                     * Dispatch method to Re-initialize a given {@code newContext} with the state of detailed, expanded and revealed
                     * elements from the {@code oldContext}. Every method re-initializes the given context and all children recursively.
                     */
                    private static dispatch def void reInitialize(«view.name.toFirstUpper»OverviewContext oldContext,
                        «view.name.toFirstUpper»OverviewContext newContext) {
                        reInitializeChildContexts(oldContext, newContext)
                        // Restore the state of every element from the old context that also exists in the new model.
                        «FOR shownElement : view.shownElements»
                            for (detailed : oldContext.detailed«shownElement.shownElement.name»Contexts) {
                                val artifact = detailed.modelElement
                                val newArtifact = newContext.collapsed«shownElement.shownElement.name»Contexts.findFirst [ artifact === it.modelElement ]
                                if (newArtifact !== null) {
                                    newContext.makeDetailed(newArtifact)
                                }
                            }
                        «ENDFOR»
                        // Restore the expanded state.
                        newContext.expanded = oldContext.expanded
                        newContext.showCollapsedElements = oldContext.showCollapsedElements
                        
                        // Re-initialize all child contexts.
                        reInitializeOverviewChildContexts(newContext, oldContext)
                    }
                «ENDFOR»
                
                private static def void reInitializeOverviewChildContexts(IOverviewVisualizationContext<?> newOverview,
                    IOverviewVisualizationContext<?> oldOverview) {
                    if (newOverview.childrenInitialized) {
                        for (childContext : oldOverview.childContexts) {
                            val childElement = childContext.modelElement
                            val newChildContext = newOverview.childContexts.findFirst [ childElement === it.modelElement ]
                            if (newChildContext !== null) {
                                reInitialize(childContext, newChildContext)
                            }
                        }
                    }
                    val rootContext = oldOverview.rootVisualization
                    if (rootContext.focus === oldOverview) {
                        newOverview.rootVisualization.focus = newOverview
                    }
                }
                
                «FOR artifact : data.artifacts»
                    private static dispatch def void reInitialize(«artifact.name.toFirstUpper»Context oldContext, «artifact.name.toFirstUpper»Context newContext) {
                        reInitializeChildContexts(oldContext, newContext)
                        if (newContext.childrenInitialized) {
                            // Restore the contained artifact overview contexts.
                            «FOR artifactView : data.getContainedViews(artifact)»
                                reInitialize(oldContext.«artifactView.view.name.toFirstLower»OverviewContext, newContext.«artifactView.view.name.toFirstLower»OverviewContext)
                            «ENDFOR»
                        }
                    }
                «ENDFOR»
                
                private static dispatch def void reInitialize(Void oldContext, Void newContext) {
                    // nothing to do if we get nothing.
                }
                
                private static def <M> void reInitializeChildContexts(IVisualizationContext<M> oldContext,
                    IVisualizationContext<M> newContext) {
                    if (oldContext.childrenInitialized && !newContext.childrenInitialized) {
                        newContext.initializeChildVisualizationContexts
                    }
                }
                
                «FOR view : data.views»
                    /**
                     * Dispatch method to re-connect a given {@code newContext} with the connections from the {@code oldContext}. Every
                     * method re-connects the given context and all children recursively.
                     * Assumes, that the new contexts are already initialized as from the old context with just the connections missing.
                     */
                    private static dispatch def void reConnect(«view.name.toFirstUpper»OverviewContext oldContext,
                        «view.name.toFirstUpper»OverviewContext newContext) {
                        «FOR connection : view.shownConnections»
                            for (oldEdge : oldContext.«connection.shownConnection.connecting.name.toFirstLower»Connects«connection.shownConnection.connected.name»Named«connection.shownConnection.name»Edges) {
                                // check if the source and target of the connection still exist and if they are still in connected.
                                val connecting = oldEdge.key.modelElement
                                val connected = oldEdge.value.modelElement
                                if (newContext.«connection.shownConnection.connecting.name.toFirstLower»s.contains(connecting)
                                    && newContext.«connection.shownConnection.connected.name.toFirstLower»s.contains(connected)
                                    && connecting.connected«connection.shownConnection.name»«connection.shownConnection.connected.name»s.contains(connected)) {
                                    val connectingContext = newContext.childContexts.findFirst [ connecting === it.modelElement ] as «connection.shownConnection.connecting.name»Context
                                    val connectedContext  = newContext.childContexts.findFirst [ connected  === it.modelElement ] as «connection.shownConnection.connected.name»Context
                                    connectingContext.add«connection.shownConnection.name»«connection.shownConnection.connected.name»Edge(connectedContext)
                                }
                            }
                        «ENDFOR»
                        «FOR categoryConnection : view.shownCategoryConnections»
                            // The possible category connections for «categoryConnection.innerView.name.toFirstLower» have already been initialized, so
                            // re-connect the category edges for «categoryConnection.innerView.name.toFirstLower» from that.
                            for (oldEdge : oldContext.«categoryConnection.connectingArtifact.name.toFirstLower»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edges) {
                                // Check if the source and target of the connection still exist, if they still can be, and if they still are connected.
                                val connecting«categoryConnection.connectingArtifact.name.toFirstUpper» = oldEdge.key.modelElement
                                val connecting«categoryConnection.connectedCategory.name.toFirstUpper» = oldEdge.key.parent?.parent?.modelElement
                                val connected«categoryConnection.connectedArtifact.name.toFirstUpper» = oldEdge.value.modelElement
                                val connected«categoryConnection.connectedCategory.name.toFirstUpper» = oldEdge.value.parent?.parent?.modelElement
                                
                                if (newContext.«categoryConnection.connectedCategory.name.toFirstLower»s.contains(connecting«categoryConnection.connectedCategory.name.toFirstUpper»)
                                    && newContext.«categoryConnection.connectedCategory.name.toFirstLower»s.contains(connected«categoryConnection.connectedCategory.name.toFirstUpper»)
                                ) {
                                    val matchedEdge = newContext.possible«categoryConnection.connectingArtifact.name.toFirstUpper»And«categoryConnection.connectedArtifact.name.toFirstUpper»In«categoryConnection.connectedCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edges.findFirst [ connecting«categoryConnection.connectingArtifact.name.toFirstUpper» === it.key.modelElement && connected«categoryConnection.connectedArtifact.name.toFirstUpper» === it.value.modelElement ]
                                    if (matchedEdge !== null) {
                                        // This method also connects the «categoryConnection.connectedCategory.name.toFirstLower»->«categoryConnection.connectedCategory.name.toFirstLower» container alongside the «categoryConnection.connectingArtifact.name.toFirstLower»->«categoryConnection.connectedArtifact.name.toFirstLower»
                                        add«categoryConnection.connectingCategory.name.toFirstUpper»CategoryConnects«categoryConnection.connectedCategory.name.toFirstUpper»Via«(categoryConnection.connection.connecting).name.toFirstUpper»Dot«categoryConnection.connection.name.toFirstUpper»Edge(matchedEdge.key, matchedEdge.value)
                                    }
                                }
                            }
                        «ENDFOR»
                        reConnectOverviewChildContexts(oldContext, newContext)
                    }
                «ENDFOR»

                private static def void reConnectOverviewChildContexts(IOverviewVisualizationContext<?> oldOverview,
                    IOverviewVisualizationContext<?> newOverview) {
                    // re-connect everything in the child contexts
                    for (childContext : oldOverview.childContexts) {
                        val element = childContext.modelElement
                        val newChildContext = newOverview.childContexts.findFirst [ element === it.modelElement ]
                        if (newChildContext !== null) {
                            reConnect(childContext, newChildContext)
                        }
                    }
                }
                
                «FOR artifact : data.artifacts»
                    private static dispatch def void reConnect(«artifact.name.toFirstUpper»Context oldContext, «artifact.name.toFirstUpper»Context newContext) {
                        «FOR containedView : data.getContainedViews(artifact)»
                            reConnect(oldContext.«containedView.view.name.toFirstLower»OverviewContext, newContext.«containedView.view.name.toFirstLower»OverviewContext)
                        «ENDFOR»
                    }
                «ENDFOR»
                private static dispatch def void reConnect(Void oldContext, Void newContext) {}
            }
        '''
    }
    
}