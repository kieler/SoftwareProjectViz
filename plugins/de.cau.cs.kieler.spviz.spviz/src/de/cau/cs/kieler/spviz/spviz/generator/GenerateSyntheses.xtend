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

import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import java.util.LinkedHashMap
import org.eclipse.core.resources.IFolder
import org.eclipse.core.runtime.IProgressMonitor

/**
 * Generates classes for the syntheses of the visualization.
 * 
 * @author leo, nre
 */
class GenerateSyntheses {
	def static void generate(IFolder sourceFolder, DataAccess spviz, IProgressMonitor progressMonitor) {
		val folder = spviz.getBundleNamePrefix.replace('.','/') + "/viz/"
		
		FileGenerator.generateOrUpdateFile(sourceFolder, folder + "DiagramSynthesis.xtend", generateDiagramSynthesis(spviz),
            progressMonitor)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "KlighdSetup.xtend", generateKlighdSetup(spviz),
            progressMonitor)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "Styles.xtend", generateStyles(spviz),
            progressMonitor)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "SynthesisUtils.xtend", generateSynthesisUtils(spviz),
            progressMonitor)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "SynthesisProperties.xtend",
            generateSynthesisProperties(spviz), progressMonitor)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "Options.xtend", generateOptions(spviz), progressMonitor)
	}
	
	/**
	 * Generates the contend for the diagram synthesis.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateDiagramSynthesis(DataAccess spviz){
		return '''
			package «spviz.getBundleNamePrefix».viz
			
			import com.google.common.collect.ImmutableList
			import com.google.inject.Inject
			import de.cau.cs.kieler.klighd.DisplayedActionData
			import de.cau.cs.kieler.klighd.kgraph.KGraphFactory
			import de.cau.cs.kieler.klighd.krendering.ViewSynthesisShared
			import de.cau.cs.kieler.klighd.krendering.extensions.KNodeExtensions
			import de.cau.cs.kieler.klighd.syntheses.AbstractDiagramSynthesis
			import «spviz.getBundleNamePrefix».viz.actions.RedoAction
			import «spviz.getBundleNamePrefix».viz.actions.ResetViewAction
«««			import «spviz.packageName».viz.actions.StoreModelAction
			import «spviz.getBundleNamePrefix».viz.actions.UndoAction
			import «spviz.getBundleNamePrefix».model.IVisualizationContext
			import «spviz.getBundleNamePrefix».model.«spviz.vizName»
			«FOR overview : spviz.overviews»
				import «spviz.getBundleNamePrefix».model.«overview»OverviewContext
			«ENDFOR»
			import «spviz.getBundleNamePrefix».model.util.VizModelUtil
			«FOR overview : spviz.overviews»
				import «spviz.getBundleNamePrefix».viz.subsyntheses.«overview»OverviewSynthesis
			«ENDFOR»
			import «spviz.modelBundleNamePrefix».model.«spviz.projectName»
			import java.util.LinkedHashSet
			import org.eclipse.elk.alg.layered.options.CrossingMinimizationStrategy
			import org.eclipse.elk.alg.layered.options.LayeredMetaDataProvider
			import org.eclipse.elk.alg.layered.options.LayeredOptions
			import org.eclipse.elk.core.options.BoxLayouterOptions
			import org.eclipse.elk.core.util.BoxLayoutProvider.PackingMode
			
«««			import static «spviz.packageName».viz.Options.*
			import static extension «spviz.getBundleNamePrefix».model.util.ContextExtensions.*
			
			/**
			 * Main diagram synthesis for {@link «spviz.projectName»} models.
			 */
			@ViewSynthesisShared
			class DiagramSynthesis extends AbstractDiagramSynthesis<«spviz.projectName»> {
				@Inject extension KNodeExtensions
				@Inject extension Styles
				«FOR overview : spviz.overviews»
					@Inject «overview»OverviewSynthesis «overview.toFirstLower»OverviewSynthesis
				«ENDFOR»
				
				extension KGraphFactory = KGraphFactory.eINSTANCE
				
				override getInputDataType() {
					«spviz.projectName»
				}
				
				override getDisplayedActions() {
					return #[
						DisplayedActionData.create(UndoAction.ID, "Undo",
							"Undoes the last action performed on the view model."),
						DisplayedActionData.create(RedoAction.ID, "Redo",
							"Redoes the last action that was undone on the view model."),
						DisplayedActionData.create(ResetViewAction.ID, "Reset View",
							"Resets the view to its default overview state.")
«««						DisplayedActionData.create(StoreModelAction.ID, "Store View Model",
«««							"Stores the current view configuration and model to disk.")
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
					
«««					// Add general options.
«««					options.addAll(SIMPLE_TEXT, SERVICE_CONNECTION_VISUALIZATION_IN_BUNDLES)
«««					
«««					// Add category options.
«««					options.addAll(FILTER_CATEGORY, TEXT_FILTER_CATEGORY, VIEW_FILTER_CATEGORY, PERFORMANCE)
«««					
«««					// Add all text filter options.
«««					options.addAll(FILTER_BY_BUNDLE_CATEGORY, FILTER_BY, FILTER_BUNDLE_CATEGORIES, FILTER_BUNDLES, FILTER_FEATURES,
«««						FILTER_PACKAGE_OBJECTS, FILTER_PRODUCTS, FILTER_SERVICE_COMPONENTS, FILTER_SERVICE_INTERFACES,
«««						FILTER_CLASSES)
«««					
«««					// Add all view filter options.
«««					options.addAll(SHOW_EXTERNAL, BUNDLE_SHOW_SERVICES, FILTER_CARDINALITY_LABEL, FILTER_DESCRIPTIONS,
«««						DESCRIPTION_LENGTH, SHORTEN_BY, INTERACTIVE_BUTTONS)
«««					
«««					// Add all performance options.
«««					options.addAll(SHOW_ICONS)
					
					return options.toList
				}
				
				override transform(«spviz.projectName» model) {
					val modelNode = createNode.associateWith(model)
					
					// Create a view with the currently stored visualization context in mind. If there is no current context, create
					// a new one for the general model overview and store that for later use.
					val visualizationContexts = usedContext.getProperty(SynthesisProperties.VISUALIZATION_CONTEXTS)
					var index = usedContext.getProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX)
					var «spviz.vizName» visualizationContext = null
					
					if (!visualizationContexts.empty && index !== null) {
						visualizationContext = visualizationContexts.get(index)
					}
					// If the visualization context is for another model than the model this method was called for or does not exist
					// yet, reset the contexts.
					if (visualizationContext === null || !visualizationContext.isRootModel(model)) {
						visualizationContexts.removeIf [ true ]
						index = 0
						usedContext.setProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX, index)
						visualizationContext = VizModelUtil.create«spviz.vizName»(model)
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
							setLayoutOption(BoxLayouterOptions.BOX_PACKING_MODE, PackingMode.GROUP_MIXED)
							addProjectRendering
							«FOR overview : spviz.overviews»
								
								val overview«overview»Nodes = «overview.toFirstLower»OverviewSynthesis.transform(visContext.«overview.toFirstLower»OverviewContext)
								children += overview«overview»Nodes
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
						«FOR overview : spviz.overviews»
							«overview»OverviewContext: {
								return «overview.toFirstLower»OverviewSynthesis.transform(context)
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
	 * Generates the contend for the klighd setup.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateKlighdSetup(DataAccess spviz){
		return '''
			package «spviz.getBundleNamePrefix».viz
			
			import de.cau.cs.kieler.klighd.IKlighdStartupHook
			import de.cau.cs.kieler.klighd.KlighdDataManager
«««			import «spviz.packageName».viz.actions.ConnectAllAction
			import «spviz.getBundleNamePrefix».viz.actions.ContextCollapseExpandAction
			import «spviz.getBundleNamePrefix».viz.actions.ContextExpandAllAction
«««			import «spviz.packageName».viz.actions.ContextRemoveAction
«««			import «spviz.packageName».viz.actions.FocusAction
			import «spviz.getBundleNamePrefix».viz.actions.OverviewContextCollapseExpandAction
			«FOR overview : spviz.overviews»
			«FOR connection : spviz.getOverviewConnections(overview)»
				import «spviz.getBundleNamePrefix».viz.actions.RevealRequired«connection.get(0)»«connection.get(2)»sAction
				import «spviz.getBundleNamePrefix».viz.actions.RevealRequiring«connection.get(0)»«connection.get(1)»sAction
			«ENDFOR»
			«ENDFOR»
«««			import «spviz.packageName».viz.actions.SelectRelatedAction
			import «spviz.getBundleNamePrefix».viz.actions.UndoAction
			import «spviz.getBundleNamePrefix».viz.actions.RedoAction
			import «spviz.getBundleNamePrefix».viz.actions.ResetViewAction
			
			/**
			 * Setup registering all KLighD extensions required to run this bundle.
			 */
			class KlighdSetup implements IKlighdStartupHook {
				override execute() {
					KlighdDataManager.instance
«««					.registerAction(SelectRelatedAction.ID, new SelectRelatedAction)
«««					.registerAction(FocusAction.ID, new FocusAction)
					.registerAction(UndoAction.ID, new UndoAction)
					.registerAction(RedoAction.ID, new RedoAction)
					.registerAction(ResetViewAction.ID, new ResetViewAction)
«««					.registerAction(StoreModelAction.ID, new StoreModelAction)
					.registerAction(ContextCollapseExpandAction.ID, new ContextCollapseExpandAction)
					.registerAction(ContextExpandAllAction.ID, new ContextExpandAllAction)
«««					.registerAction(ContextRemoveAction.ID, new ContextRemoveAction)
					.registerAction(OverviewContextCollapseExpandAction.ID, new OverviewContextCollapseExpandAction)
«««					.registerAction(ConnectAllAction.ID, new ConnectAllAction)
					«FOR overview : spviz.overviews»
					«FOR connection : spviz.getOverviewConnections(overview)»
						.registerAction(RevealRequired«connection.get(0)»«connection.get(2)»sAction.ID, new RevealRequired«connection.get(0)»«connection.get(2)»sAction)
						.registerAction(RevealRequiring«connection.get(0)»«connection.get(1)»sAction.ID, new RevealRequiring«connection.get(0)»«connection.get(1)»sAction)
					«ENDFOR»
					«ENDFOR»
					.registerDiagramSynthesisClass(DiagramSynthesis.name, DiagramSynthesis)
«««					.registerDiagramSynthesisClass(OsgiVizSynthesis.name, OsgiVizSynthesis)
				}
			}
			
		'''
	}
	
	
	// TODO: dynamic coloring
	// TODO: add connections specific renderings
	/**
	 * Generates the contend for the synthesis styles class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateStyles(DataAccess spviz){
		
		// unschoener hack
		val LinkedHashMap<String, Integer> artifactNumberMap = newLinkedHashMap()
		for (var i = 0; i < spviz.artifacts.length; i++){
			artifactNumberMap.put(spviz.artifacts.get(i), i % 10)
		}
			
		return '''
			package «spviz.getBundleNamePrefix».viz
			
			import com.google.inject.Inject
			import de.cau.cs.kieler.klighd.ViewContext
			import de.cau.cs.kieler.klighd.kgraph.KEdge
			import de.cau.cs.kieler.klighd.kgraph.KNode
			import de.cau.cs.kieler.klighd.kgraph.KPort
«««			import de.cau.cs.kieler.klighd.krendering.Arc
«««			import de.cau.cs.kieler.klighd.krendering.KArc
			import de.cau.cs.kieler.klighd.krendering.KContainerRendering
«««			import de.cau.cs.kieler.klighd.krendering.KEllipse
			import de.cau.cs.kieler.klighd.krendering.KPolyline
			import de.cau.cs.kieler.klighd.krendering.KRectangle
			import de.cau.cs.kieler.klighd.krendering.KRoundedRectangle
			import de.cau.cs.kieler.klighd.krendering.KText
			import de.cau.cs.kieler.klighd.krendering.LineStyle
«««			import de.cau.cs.kieler.klighd.krendering.ModifierState
			import de.cau.cs.kieler.klighd.krendering.ViewSynthesisShared
			import de.cau.cs.kieler.klighd.krendering.extensions.KColorExtensions
			import de.cau.cs.kieler.klighd.krendering.extensions.KContainerRenderingExtensions
			import de.cau.cs.kieler.klighd.krendering.extensions.KEdgeExtensions
			import de.cau.cs.kieler.klighd.krendering.extensions.KLabelExtensions
			import de.cau.cs.kieler.klighd.krendering.extensions.KPolylineExtensions
			import de.cau.cs.kieler.klighd.krendering.extensions.KRenderingExtensions
«««			import «spviz.packageName».viz.actions.ConnectAllAction
			import «spviz.getBundleNamePrefix».viz.actions.ContextCollapseExpandAction
			import «spviz.getBundleNamePrefix».viz.actions.ContextExpandAllAction
«««			import «spviz.packageName».viz.actions.ContextRemoveAction
«««			import «spviz.packageName».viz.actions.FocusAction
			import «spviz.getBundleNamePrefix».viz.actions.OverviewContextCollapseExpandAction
«««			import «spviz.packageName».viz.actions.SelectRelatedAction
			«FOR overview : spviz.overviews»
				«FOR connection : spviz.getOverviewConnections(overview)»
					import «spviz.getBundleNamePrefix».viz.actions.RevealRequired«connection.get(0)»«connection.get(2)»sAction
					import «spviz.getBundleNamePrefix».viz.actions.RevealRequiring«connection.get(0)»«connection.get(1)»sAction
				«ENDFOR»
			«ENDFOR»
			«FOR artifact : spviz.artifacts»
				import «spviz.modelBundleNamePrefix».model.«artifact»
			«ENDFOR»
«««			import java.util.List
			
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
				@Inject extension KLabelExtensions
				@Inject extension KPolylineExtensions
				@Inject extension KRenderingExtensions
				
				// The colors used for the visualization.
				public static final String DEFAULT_BACKGROUND_COLOR  = "white"
				public static final String COLOR_0			 = "#E0F7FF" // HSV 195 12 100
				public static final String SECONDARY_COLOR_0 = "#C2F0FF" // HSV 195 24 100
				public static final String COLOR_1			 = "#E0EBFF" // HSV 220 12 100
				public static final String SECONDARY_COLOR_1 = "#C2D6FF" // HSV 220 24 100
				public static final String COLOR_2			 = "#F7FDFF" // HSV 195 3 100
				public static final String SECONDARY_COLOR_2 = "#F0FBFF" // HSV 195 6 100
				public static final String COLOR_3			 = "#F5FFE0" // HSV 79 12 100
				public static final String SECONDARY_COLOR_3 = "#ECFFC2" // HSV 79 24 100
				public static final String COLOR_4			 = "#E0FFE9" // HSV 137 12 100
				public static final String SECONDARY_COLOR_4 = "#C2FFD3" // HSV 137 24 100
				public static final String COLOR_5			 = "#F7FFFA" // HSV 137 3 100
				public static final String SECONDARY_COLOR_5 = "#F0FFF4" // HSV 137 6 100
				public static final String COLOR_6			 = "#E7E0FF" // HSV 253 12 100
				public static final String SECONDARY_COLOR_6 = "#CFC2FF" // HSV 253 24 100
				public static final String COLOR_7			 = "#FFEAE0" // HSV 19 12 100
				public static final String SECONDARY_COLOR_7 = "#FFD5C2" // HSV 19 24 100
				public static final String COLOR_8			 = "#FFE0F5" // HSV 319 12 100
				public static final String SECONDARY_COLOR_8 = "#FFC2EC" // HSV 319 24 100
				public static final String COLOR_9			 = "#FFE0E0" // HSV 0 12 100
				public static final String SECONDARY_COLOR_9 = "#FFC2C2" // HSV 0 24 100
				
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
				 */
				def KRoundedRectangle addGenericRendering(KNode node, String name) {
					node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
						setShadow(SHADOW_COLOR.color, 4, 4)
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
				 * @param isConnectable if the overview rendering contains connectable elements
				 * @param context The used ViewContext.
				 */
				def void addOverviewRendering(KNode node, String headlineText, String tooltipText, boolean isConnectable,
					ViewContext context) {
					// Expanded
					node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
						setAsExpandedView
						setGridPlacement(1)
						addDoubleClickAction(OverviewContextCollapseExpandAction.ID)
						addRectangle => [
							var columns = 4
«««							val interactiveButtons = context.getOptionValue(INTERACTIVE_BUTTONS) as Boolean
«««							if (interactiveButtons) {
«««								columns += 4
«««								if (isConnectable) {
«««									columns += 1
«««								}
«««							} 
							setGridPlacement(columns)
							invisible = true
							addRectangle => [
								invisible = true
								addSimpleLabel(headlineText) => [
									fontBold = true
									selectionFontBold = true
								]
							]
«««							if (interactiveButtons) {
								addVerticalLine
«««								addFocusButton(context)
								addExpandAllButton(context)
«««								if (isConnectable) {
«««									addConnectAllButton(context)
«««								}
								addOverviewContextCollapseExpandButton(false, context)
«««							}
						]
						addHorizontalSeperatorLine(1, 0)
						addChildArea
						setShadow(SHADOW_COLOR.color, 4, 4)
						background = DEFAULT_BACKGROUND_COLOR.color
						tooltip = tooltipText
						setSelectionStyle
					]
					
					// Collapsed
					node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
						setAsCollapsedView
						setGridPlacement(1)
						addDoubleClickAction(OverviewContextCollapseExpandAction.ID)
						addRectangle => [
«««							val interactiveButtons = context.getOptionValue(INTERACTIVE_BUTTONS) as Boolean
							var columns = 3
«««							if (interactiveButtons) {
«««								columns += 2
«««							}
							setGridPlacement(columns)
							invisible = true
							addRectangle => [
								invisible = true
								addSimpleLabel(headlineText)
							]
«««							if (interactiveButtons) {
								addVerticalLine
								addOverviewContextCollapseExpandButton(true, context)
«««							}
						]
						setShadow(SHADOW_COLOR.color, 4, 4)
						background = DEFAULT_BACKGROUND_COLOR.color
						tooltip = tooltipText
						setSelectionStyle
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
«««						if (context.getOptionValue(SHOW_ICONS) as Boolean) {
«««							val imagePath = if (expand) "icons/restore128.png" else "icons/minimize128.png"
«««							addImage("«spviz.packageName».viz", imagePath) => [
«««								setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
«««								addSingleOrMultiClickAction(action)
«««							]
«««						} else {
						val label = if (expand) "+" else "-"
						addButton(label, action)
«««						}
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
«««						if (context.getOptionValue(SHOW_ICONS) as Boolean) {
«««							addImage("«spviz.packageName».viz", "icons/expand128.png") => [
«««								setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
«««								addSingleOrMultiClickAction(action)
«««							]
«««						} else {
«««						placeholder label
						val label = "⭱" 
						addButton(label, action)
«««						}
					]
				}
				
«««				/**
«««				 * Adds a button in a grid placement rendering that causes the {@link ConnectAllAction} to be called.
«««				 * 
«««				 * @param container The parent rendering this button should be added to.
«««				 * @param context The used ViewContext.
«««				 */
«««				def KRectangle addConnectAllButton(KContainerRendering container, ViewContext context) {
«««					val action = ConnectAllAction::ID
«««					return container.addRectangle => [
«««						setGridPlacementData => [
«««							flexibleWidth = false
«««						]
«««						addSingleOrMultiClickAction(action)
«««						lineWidth = 0
«««						tooltip = "Connects all elements in this overview."
«««						if (context.getOptionValue(SHOW_ICONS) as Boolean) {
«««							addImage("«spviz.packageName».viz", "icons/connect128.png") => [
«««								setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
«««								addSingleOrMultiClickAction(action)
«««							]
«««						} else {
«««							val label = "Connect all"
«««							addButton(label, action)
«««						}
«««					]
«««				}
«««				
«««				/**
«««				 * Adds a button in a grid placement rendering that causes the {@link ContextRemoveAction} to be called.
«««				 * 
«««				 * @param container The parent rendering this button should be added to.
«««				 */
«««				def KRectangle addRemoveButton(KContainerRendering container) {
«««					return container.addButton("x", ContextRemoveAction::ID) => [
«««						tooltip = "Remove this element from the view."
«««					]
«««				}
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
«««						if (context.getOptionValue(SHOW_ICONS) as Boolean) {
«««							val imagePath = if (expand) "icons/restore128.png" else "icons/minimize128.png"
«««							addImage("«spviz.packageName».viz", imagePath) => [
«««								setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
«««								addSingleOrMultiClickAction(action)
«««							]
«««						} else {
						val label = if (expand) "+" else "-"
						addButton(label, action)
«««						}
					]
				}
«««				
«««				/**
«««				 * Adds a button in grid placement that causes the {@link FocusAction} to be called.
«««				 * 
«««				 * @param container The parent rendering this button should be added to.
«««				 * @param context The used ViewContext.
«««				 */
«««				def KRectangle addFocusButton(KContainerRendering container, ViewContext context) {
«««					val action = FocusAction::ID
«««					return container.addRectangle => [
«««						setGridPlacementData => [
«««							flexibleWidth = false
«««						]
«««						addSingleOrMultiClickAction(action)
«««						lineWidth = 0
«««						tooltip = "Focus the view to this overview alone."
«««						if (context.getOptionValue(SHOW_ICONS) as Boolean) {
«««							addImage("«spviz.packageName».viz", "icons/loupe128.png") => [
«««								setPointPlacementData(RIGHT, 0, 0.5f, TOP, 0, 0.5f, H_CENTRAL, V_CENTRAL, 4f, 4f, 12, 12)
«««								addSingleOrMultiClickAction(action)
«««							]
«««						} else {
«««							val label = "Focus"
«««							addButton(label, action)
«««						}
«««					]
«««				}
				
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
				 */
				def void addProjectRendering(KNode node) {
					node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
						setGridPlacement(1)
						addRectangle => [
							invisible = true
							addSimpleLabel("Overview") => [
								fontBold = true
								selectionFontBold = true
							]
						]
						addHorizontalSeperatorLine(1, 0)
						addChildArea
						setShadow(SHADOW_COLOR.color, 4, 4)
						background = DEFAULT_BACKGROUND_COLOR.color
						tooltip = "The overview of all available views for this project."
						setSelectionStyle
					]
				}
				
				«FOR artifact : spviz.artifacts»
					// ------------------------------------- «artifact» renderings -------------------------------------
					
					/**
					 * Adds a simple rendering for a {@link «artifact»} to the given node that can be expanded to call the
					 * {link ReferencedSynthesisExpandAction} to dynamically call the feature synthesis for the given feature.
					 * 
					 * @param node The KNode to add this rendering to.
					 * @param aritfact The «artifact.toFirstLower» this rendering should represent.
					 * @param label The representing name of this feature that should be shown.
					 * @param context The used ViewContext.
					 */
					def add«artifact»InOverviewRendering(KNode node, «artifact» artifact, String name, ViewContext context) {
						node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
«««							val interactiveButtons = context.getOptionValue(INTERACTIVE_BUTTONS) as Boolean
							var columns = 3
«««							if (interactiveButtons) {
«««								columns += 2
«««							}
							setGridPlacement(columns)
							addRectangle => [
								invisible = true
								addSimpleLabel(name)
							]
«««							if (interactiveButtons) {
								addVerticalLine
								addCollapseExpandButton(true, context)
«««							}
							setBackgroundGradient(COLOR_«artifactNumberMap.get(artifact)».color, SECONDARY_COLOR_«artifactNumberMap.get(artifact)».color, 90)
							addDoubleClickAction(ContextCollapseExpandAction::ID)
«««							addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
«««								ModifierState.NOT_PRESSED)
							setShadow(SHADOW_COLOR.color, 4, 4)
							tooltip = artifact.getName
							setSelectionStyle
						]
					}
					
					/**
					 * Adds a rendering for a {@link «artifact»} to the given node.
					 * Contains the name of the «artifact.toFirstLower», a button to focus this product and text for the ID and description of this product.
					 * 
					 * @param node The KNode this rendering should be attached to.
					 * @param artifact The «artifact.toFirstLower» this rendering represents.
					 * @param inOverview If this product is shown in a «artifact.toFirstLower» overview.
					 * @param hasChildren If this rendering should leave space for a child area.
					 * @param context The view context used in the synthesis.
					 * 
					 * @return The entire rendering for a «artifact.toFirstLower».
					 */
					def KRoundedRectangle add«artifact»Rendering(KNode node, «artifact» artifact, boolean inOverview, boolean hasChildren,
						ViewContext context) {
						node.addRoundedRectangle(ROUNDNESS, ROUNDNESS) => [
							setBackgroundGradient(COLOR_«artifactNumberMap.get(artifact)».color, SECONDARY_COLOR_«artifactNumberMap.get(artifact)».color, 90)
							setGridPlacement(1)
							addRectangle => [
«««								val interactiveButtons = context.getOptionValue(INTERACTIVE_BUTTONS) as Boolean
								var columns = 3
«««								if (interactiveButtons) {
«««									columns += 2
«««								}
								setGridPlacement(columns)
								invisible = true
								addRectangle => [
									invisible = true
«««									addSimpleLabel(artifact.descriptiveName) => [
									addSimpleLabel(artifact.getName) => [
										fontBold = true
										selectionFontBold = true
									]
								]
«««								if (interactiveButtons) {
									addVerticalLine
									if (inOverview) {
										addCollapseExpandButton(false, context)
									} else {
«««										addRemoveButton
									}
«««								}
							]
							addHorizontalSeperatorLine(1, 0)
							addRectangle => [
								invisible = true
								addSimpleLabel("ID: " + SynthesisUtils.getId(artifact.getName, context)) => [
									tooltip = artifact.getName
«««									addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
«««										ModifierState.NOT_PRESSED)
								]
							]
«««							if (context.getOptionValue(FILTER_DESCRIPTIONS) as Boolean) {
«««								val desc = SynthesisUtils.descriptionLabel(artifact.about, context)
«««								if (!desc.empty) {
«««									addRectangle => [
«««										invisible = true
«««										addSimpleLabel("Description: " + desc) => [
«««											tooltip = p.about
«««											addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
«««												ModifierState.NOT_PRESSED)
«««										]
«««									]
«««								}
«««							}
							if (hasChildren) {
								addHorizontalSeperatorLine(1, 0)
								addChildArea
							}
							setShadow(SHADOW_COLOR.color, 4, 4)
«««							addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
«««								ModifierState.NOT_PRESSED)
							setSelectionStyle
						]
					}
					
					«FOR required : spviz.getRequiredArtifacts(artifact)»
						/**
						 * The rendering of a port that connects a «artifact.toFirstLower» with the required «required.get(1)». Issues the
						 * {@link RevealRequired«required.get(0)»«required.get(1)»sAction} if clicked.
						 */
						def KRectangle addRequired«required.get(0)»«required.get(1)»sActionPortRendering(KPort port, int numReferences, boolean allShown) {
							return port.addRectangle => [
								background = if (allShown) ALL_SHOWN_COLOR.color else NOT_ALL_SHOWN_COLOR.color
								val tooltipText = "Show required «required.get(1).toFirstLower»s  (" + numReferences + " total)."
								tooltip = tooltipText
								addSingleClickAction(RevealRequired«required.get(0)»«required.get(1)»sAction::ID)
							]
						}
						
						/**
						 * Adds the rendering for an edge showing a «required.get(1).toFirstLower» requirement.
						 */
						def addRequired«required.get(0)»«required.get(1)»EdgeRendering(KEdge edge) {
							edge.addPolyline => [
								lineWidth = 2
								addHeadArrowDecorator => [
									lineWidth = 1
									background = "black".color
									foreground = "black".color
									selectionLineWidth = 1.5f
									selectionForeground = SELECTION_COLOR.color
									selectionBackground = SELECTION_COLOR.color
«««									addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
«««										ModifierState.NOT_PRESSED)
									suppressSelectablility
								]
								lineStyle = LineStyle.DASH
								selectionLineWidth = 3
								selectionForeground = SELECTION_COLOR.color
«««								addSingleClickAction(SelectRelatedAction::ID, ModifierState.NOT_PRESSED, ModifierState.NOT_PRESSED,
«««									ModifierState.NOT_PRESSED)
							]
						}
					
					«ENDFOR»
					«FOR requiring : spviz.getRequiringArtifacts(artifact)»	
						/**
						 * The rendering of a port that connects a «artifact.toFirstLower» with the «requiring.get(1)»s that require it. Issues the
						 * {@link RevealRequiring«requiring.get(0)»»«requiring.get(1)»sAction} if clicked.
						 */
						def KRectangle addRequiring«requiring.get(0)»«requiring.get(1)»sActionPortRendering(KPort port, int numReferences, boolean allShown) {
							return port.addRectangle => [
								background = if (allShown) ALL_SHOWN_COLOR.color else NOT_ALL_SHOWN_COLOR.color
								val tooltipText = "Show «requiring.get(1).toFirstLower»s that require this «artifact.toFirstLower» (" + numReferences + " total)."
								tooltip = tooltipText
								addSingleClickAction(RevealRequiring«requiring.get(0)»«requiring.get(1)»sAction::ID)
							]
						}
				
					«ENDFOR»
					
				«ENDFOR»
			}
			
		'''
	}
	
	/**
	 * Generates the contend for SynthesisUtils class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateSynthesisUtils(DataAccess spviz){
		return '''
			package «spviz.getBundleNamePrefix».viz
			
			import de.cau.cs.kieler.klighd.IAction.ActionContext
			import de.cau.cs.kieler.klighd.SynthesisOption
			import de.cau.cs.kieler.klighd.ViewContext
			import de.cau.cs.kieler.klighd.internal.util.KlighdInternalProperties
			import de.cau.cs.kieler.klighd.kgraph.KGraphElement
			import de.cau.cs.kieler.klighd.kgraph.KNode
			import de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses
			import «spviz.getBundleNamePrefix».model.IOverviewVisualizationContext
			import «spviz.getBundleNamePrefix».model.IVisualizationContext
			import java.util.List
			import org.eclipse.elk.core.options.CoreOptions
			import org.eclipse.elk.core.options.Direction
			import org.eclipse.elk.core.options.EdgeRouting
			
			import static extension de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses.*
			import static extension «spviz.getBundleNamePrefix».model.util.ContextExtensions.*
			
			/**
			 * Util class that contains some static methods commonly used for the Osgi synthesis.
			 * 
			 * @author nre
			 */
			final class SynthesisUtils {
				/**
				 * Utils class can not be instanciated.
				 */
				private new() {}
				
				/**
				* Returns the domain element the clicked KNode given its action context.
				* Uses a fallback mechanism to work around the SourceModelTrackingAdapter that seems bugged for this synthesis.
				* FIXME: find out why the usual way does not work all the time and remove the need for this method!
				*/
				def static Object getDomainElement(ActionContext context) {
					getDomainElement(context, context.KNode)
				}
				
				/**
				 * Returns the domain element for any KNode given its action context.
				 * Uses a fallback mechanism to work around the SourceModelTrackingAdapter that seems bugged for this synthesis.
				 * FIXME: find out why the usual way does not work all the time and remove the need for this method!
				 */
				def static Object getDomainElement(ActionContext context, KGraphElement kElement) {
					// Default case, how it should work all the time.
					var Object element
					if (kElement instanceof KNode) {
						element = context.getDomainElement(kElement)
					}
					
					// Fallback by using the KLighD internal property set during the synthesis.
					if (element === null) {
						element = kElement.getProperty(KlighdInternalProperties.MODEL_ELEMEMT)
					}
					return element
				}
				
				
				/**
				 * If the id should be truncated by the prefix of the {@link OsgiOptions#SHORTEN_BY} option, this returns a
				 * truncated version of the id, otherwise the id itself.
				 * 
				 * @param id The id that should possibly be truncated.
				 * @return The possibly truncated id.
				 */
				def static String getId(String id, ViewContext usedContext) {
«««					val prefix = usedContext.getOptionValue(SHORTEN_BY) as String
«««					if (!prefix.empty && id.startsWith(prefix)) {
«««						return "..." + id.substring(prefix.length)
«««					}
					return id
				}
			
				/**
				 * Returns the descriptive text of a label shortened by the {@link OsgiOptions#DESCRIPTION_LENGTH} option.
				 * @param text The text that should be shortened.
				 * @param context The view context used to display the diagram.
				 * @return The given string shortened by the description length option.
				 */
				def static String descriptionLabel(String text, ViewContext context) {
«««					val threshold = context.getOptionValue(DESCRIPTION_LENGTH) as Number
					if (text === null) {
						return ""
					}
«««					if (text.length <= threshold.intValue) {
					return text
«««					}
«««					return text.substring(0, threshold.intValue) + " ..."
				}
				
				/**
				 * Configures the layout of any overview node. Configures the box layout algorithm of elk.
				 */
				def static void configureBoxLayout(KNode node) {
					node => [
						DiagramSyntheses.setLayoutOption(node, CoreOptions::ALGORITHM, "org.eclipse.elk.box")
«««						setLayoutOption(CoreOptions::EXPAND_NODES, true)
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
						setLayoutOption(CoreOptions::DIRECTION, Direction.RIGHT)
						setLayoutOption(CoreOptions::EDGE_ROUTING, EdgeRouting.POLYLINE)
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
				
				def static <M> Iterable<M> filteredElements(List<M> elements, IOverviewVisualizationContext<M> oc,
					ViewContext usedContext) {
					val elementsInContext = elements.filter [
						oc.modelElements.contains(it)
					]
					
«««					val regex = ".*" + usedContext.getOptionValue(FILTER_BY) as String + ".*"
«««					if (!regex.empty && !elementsInContext.empty) {
«««						val (M) => boolean filter = switch (elementsInContext.head) {
«««							Bundle		   case usedContext.getOptionValue(FILTER_BUNDLES)			=== true: {
«««								[ (it as Bundle)		  .uniqueId	   .matches(regex) ]
«««							}
«««							Feature		  case usedContext.getOptionValue(FILTER_FEATURES)		   === true: {
«««								[ (it as Feature)		 .uniqueId	   .matches(regex) ]
«««							}
«««							Product		  case usedContext.getOptionValue(FILTER_PRODUCTS)		   === true: {
«««								[ (it as Product)		 .uniqueId	   .matches(regex) ]
«««							}
«««							BundleCategory   case usedContext.getOptionValue(FILTER_BUNDLE_CATEGORIES)  === true: {
«««								[ (it as BundleCategory)  .categoryName   .matches(regex) ]
«««							}
«««							PackageObject	case usedContext.getOptionValue(FILTER_PACKAGE_OBJECTS)	=== true: {
«««								[ (it as PackageObject)   .uniqueId	   .matches(regex) ]
«««							}
«««							ServiceComponent case usedContext.getOptionValue(FILTER_SERVICE_COMPONENTS) === true: {
«««								[ (it as ServiceComponent).name		   .matches(regex) ]
«««							}
«««							ServiceInterface case usedContext.getOptionValue(FILTER_SERVICE_INTERFACES) === true: {
«««								[ (it as ServiceInterface).name		   .matches(regex) ]
«««							}
«««							Class			case usedContext.getOptionValue(FILTER_CLASSES)			=== true: {
«««								[ (it as Class).displayedString		   .matches(regex) ]
«««							}
«««							default: {
«««								// In case the option for the filter is turned off, just return the given list.
«««								null
«««							}
«««						}
«««						if (filter === null) {
«««							return elementsInContext
«««						} else {
«««							return elementsInContext.filter(filter)
«««						}
«««					} else {
					return elementsInContext
«««					}
				}
				
			}
			
		'''
	}
	
	/**
	 * Generates the contend for SynthesisProperties class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateSynthesisProperties(DataAccess spviz){
		return '''
			package «spviz.getBundleNamePrefix».viz
			
			import de.cau.cs.kieler.klighd.ViewContext
			import «spviz.getBundleNamePrefix».model.IVisualizationContext
			import «spviz.getBundleNamePrefix».model.«spviz.vizName»
			import java.util.LinkedList
			import java.util.List
			import org.eclipse.elk.graph.properties.IProperty
			import org.eclipse.elk.graph.properties.Property
			
			/**
			 * Class to provide easy access to properties stored for the syntheses.
			 */
			class SynthesisProperties {
				/** 
				 * Property pointing towards the list of saved {@link «spviz.vizName»}s that are used to model the currently
				 * displayed view and all previously used contexts for undo/redo functionality.
				 * Currently does not store a delta between the contexts, but a hard copy of every state used since the beginning
				 * default view.
				 */
				public static final IProperty<List<«spviz.vizName»>> VISUALIZATION_CONTEXTS = new Property<List<«spviz.vizName»>>("osgimodel.visualizationContexts", new LinkedList<«spviz.vizName»>)
				
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
				public static final IProperty<«spviz.vizName»> MODEL_VISUALIZATION_CONTEXT = new Property<«spviz.vizName»>("model.modelVisualizationContext", null)
				
			}
			
		'''
	}
	
	/**
	 * Generates the contend for Options class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateOptions(DataAccess spviz){
		return '''
			package «spviz.getBundleNamePrefix».viz
			
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
				
				/** Category option containing options for filtering. */
				public static final SynthesisOption FILTER_CATEGORY = SynthesisOption.createCategory("Filter", true)
				
				/** Category option containing options for text filtering. */
				public static final SynthesisOption TEXT_FILTER_CATEGORY = SynthesisOption.createCategory("Text filter", false)
					.setCategory(FILTER_CATEGORY)
				
				/** Category option containing options for view filtering. */
				public static final SynthesisOption VIEW_FILTER_CATEGORY = SynthesisOption.createCategory("View filter", false)
					.setCategory(FILTER_CATEGORY)
				
				/** Option indicating whether external elements should be shown. */
				public static final SynthesisOption SHOW_EXTERNAL = SynthesisOption.createCheckOption(
					"External elements", true).setCategory(VIEW_FILTER_CATEGORY)
				
				/** Option for limiting the length of descriptive texts. */
				public static final SynthesisOption DESCRIPTION_LENGTH = SynthesisOption.createRangeOption(
					"Description text length", 0, 500, 1, 20).setCategory(VIEW_FILTER_CATEGORY)
				
				/** Option for shortening all IDs by the prefix in the option. */
				public static final SynthesisOption SHORTEN_BY = SynthesisOption.createTextOption(
					"Shorten IDs by").setCategory(VIEW_FILTER_CATEGORY)
				
				/** Option for showing interactive buttons. */
				public static final SynthesisOption INTERACTIVE_BUTTONS = SynthesisOption.createCheckOption(
					"Interactive Buttons", true).setCategory(VIEW_FILTER_CATEGORY)
				
				
				/** Category option containing options for graphical performance. */
				public static final SynthesisOption PERFORMANCE = SynthesisOption.createCategory("Performance", false)
					
				/** Option for using Icons or simpler texts. */
				public static final SynthesisOption SHOW_ICONS = SynthesisOption.createCheckOption("Icons", true)
					.setCategory(PERFORMANCE)
			}
			
		'''
	}

	
}