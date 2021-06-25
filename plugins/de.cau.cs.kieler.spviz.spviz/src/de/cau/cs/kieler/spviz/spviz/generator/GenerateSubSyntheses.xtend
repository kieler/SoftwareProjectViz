package de.cau.cs.kieler.spviz.spviz.generator

import org.eclipse.xtext.generator.IFileSystemAccess2

/**
 * Generates sub syntheses classes for overviews and their contained artifacts.
 */
class GenerateSubSyntheses {
	def static void generate(IFileSystemAccess2 fsa, DataAccess spviz){
		
		val packageName = spviz.packageName
		val folder = "viz/" + packageName.replace('.','/') + "/viz/subsyntheses/"
		for (artifact : spviz.artifacts) {
			var content = generateSimpleSynthesis(packageName, artifact)
			fsa.generateFile(folder + "Simple" + artifact + "Synthesis.xtend", content)
			
			content = generateSynthesis(artifact, spviz)
			fsa.generateFile(folder + artifact + "Synthesis.xtend", content)
		}
		for (overview : spviz.overviews) {
			val content = generateOverviewSythesis(overview, spviz)
			fsa.generateFile(folder + overview + "OverviewSynthesis.xtend", content)
		}
	}

	/**
	 * Generates the overview syntheses contend for a given overview.
	 * 
	 * @param overview
	 * 		the overview name as a string
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateOverviewSythesis(String overview, DataAccess spviz){
		return '''
			package «spviz.packageName».viz.subsyntheses
			
			import com.google.inject.Inject
			import de.cau.cs.kieler.klighd.kgraph.KGraphFactory
			import de.cau.cs.kieler.klighd.kgraph.KNode
			import de.cau.cs.kieler.klighd.krendering.extensions.KEdgeExtensions
			import de.cau.cs.kieler.klighd.krendering.extensions.KNodeExtensions
			import de.cau.cs.kieler.klighd.krendering.extensions.KRenderingExtensions
			import de.cau.cs.kieler.klighd.syntheses.AbstractSubSynthesis
			import de.cau.cs.kieler.klighd.kgraph.KIdentifier
			import «spviz.packageName».viz.Styles
			import «spviz.packageName».viz.SynthesisUtils
			«FOR artifact : spviz.getDisplayedArtifacts(overview)»
				import «spviz.packageName».model.«artifact»Context
			«ENDFOR»
			import «spviz.packageName».model.«overview»OverviewContext
			import java.util.EnumSet
			import java.util.List
			import org.eclipse.elk.core.math.ElkPadding
			import org.eclipse.elk.core.options.CoreOptions
			import org.eclipse.elk.core.options.Direction
			import org.eclipse.elk.core.options.SizeConstraint

			
			import static extension de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses.*
			import static extension «spviz.packageName».viz.SynthesisUtils.*
			import static extension «spviz.packageName».model.util.ContextExtensions.*
			
			/**
			 * Transformation as an overview of all «overview.toFirstLower»s in the given list of «overview.toFirstLower»s.
			 */
			class «overview»OverviewSynthesis extends AbstractSubSynthesis<«overview»OverviewContext, KNode> {
				@Inject extension KEdgeExtensions
				@Inject extension KNodeExtensions
				@Inject extension KRenderingExtensions
				@Inject extension Styles
				«FOR artifact : spviz.getDisplayedArtifacts(overview)»
					@Inject Simple«artifact»Synthesis simple«artifact»Synthesis
					@Inject «artifact»Synthesis «artifact.toFirstLower»Synthesis
				«ENDFOR»
				extension KGraphFactory = KGraphFactory.eINSTANCE
				
				override transform(«overview»OverviewContext «overview.toFirstLower»OverviewContext) {
					return #[
						createNode => [
							associateWith(«overview.toFirstLower»OverviewContext)
							data += createKIdentifier => [ it.id = «overview.toFirstLower»OverviewContext.hashCode.toString ]
							if («overview.toFirstLower»OverviewContext.expanded) {
								initiallyExpand
							} else {
								initiallyCollapse
							}
							setLayoutOption(it, CoreOptions::ALGORITHM, "org.eclipse.elk.layered")
							setLayoutOption(it, CoreOptions::DIRECTION, Direction.DOWN)
							setLayoutOption(CoreOptions::NODE_SIZE_CONSTRAINTS, EnumSet.of(SizeConstraint.MINIMUM_SIZE))
							addOverviewRendering("«overview»", «overview.toFirstLower»OverviewContext.overviewText, false, usedContext)
							
							// remove the padding of the invisible container.
							addLayoutParam(CoreOptions.PADDING, new ElkPadding(0, 0, 0, 0))
							
							// Add all simple «overview.toFirstLower» renderings in a first subgraph (top)
							val collapsedOverviewNode = transformCollapsed«overview»Overview(«overview.toFirstLower»OverviewContext)
							children += collapsedOverviewNode
							
							// Add all detailed «overview.toFirstLower» renderings and their connections in a second subgraph (bottom)
							val detailedOverviewNode = transformDetailed«overview»Overview(«overview.toFirstLower»OverviewContext)
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
				 * The top part of the «overview.toFirstLower» overview rendering containing all collapsed «overview.toFirstLower» renderings in a box layout.
				 * 
				 * @param «overview.toFirstLower»OverviewContext The overview context for all «overview.toFirstLower»s in this subsynthesis.
				 */
				private def KNode transformCollapsed«overview»Overview(«overview»OverviewContext «overview.toFirstLower»OverviewContext) {
					createNode => [
						associateWith(«overview.toFirstLower»OverviewContext)
						configureBoxLayout
						addInvisibleContainerRendering
						tooltip = «overview.toFirstLower»OverviewContext.overviewText
						
						«FOR artifact : spviz.getDisplayedArtifacts(overview)»
							// all «artifact»s
							«overview.toFirstLower»OverviewContext.collapsed«artifact»Contexts.sortBy [
								modelElement.getName].forEach [ collapsed«artifact»Context, index |
								children += simple«artifact»Synthesis.transform(
									collapsed«artifact»Context as «artifact»Context, -index)
							]
						«ENDFOR»
					]
				}
				
				/**
				 * The bottom part of the «overview.toFirstLower» overview rendering containing all detailed «overview.toFirstLower» renderings and their
				 * connections in a layered layout.
				 * 
				 * @param «overview.toFirstLower»OverviewContext The overview context for all «overview.toFirstLower»s in this subsynthesis.
				 */
				private def KNode transformDetailed«overview»Overview(«overview»OverviewContext «overview.toFirstLower»OverviewContext) {
					createNode => [
						associateWith(«overview.toFirstLower»OverviewContext)
						configureOverviewLayout
						addInvisibleContainerRendering
						tooltip = «overview.toFirstLower»OverviewContext.overviewText
						
						«FOR artifact : spviz.getDisplayedArtifacts(overview)»
							children += «overview.toFirstLower»OverviewContext.detailed«artifact»Contexts.flatMap [
								return «artifact.toFirstLower»Synthesis.transform(it as «artifact»Context)
							]
						«ENDFOR»
						
						«FOR connection : spviz.getOverviewConnections(overview)»
						// Add all by «connection.get(1).toFirstLower»s required «connection.get(2).toFirstLower»s edges.
						«overview.toFirstLower»OverviewContext.required«connection.get(0)»«connection.get(2)»Edges.forEach [
«««							// Connects the {@code sourceBundleNode} and the {@code usedByBundleNode} via an arrow in UML style,
«««							// so [usedByBundleNode] ----- uses -----> [sourceBundleNode]
							val requiring = key
							val required = value
							if (!nodeExists(requiring) || !nodeExists(required)) {
								// Only Add edges if the nodes are actually shown.
								return
							}
							val requiringNode = requiring.node
							val requiredNode = required.node
							val requiringPort = requiringNode.ports.findFirst [
								data.filter(KIdentifier).head?.id === "required«connection.get(0)»«connection.get(2)»s"
							]
							val requiredPort = requiredNode.ports.findFirst [
								data.filter(KIdentifier).head?.id === "requiring«connection.get(0)»«connection.get(2)»s"
							]
							
							val edge = createEdge(requiring, required) => [
								addRequired«connection.get(0)»«connection.get(2)»EdgeRendering
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
	 * 		the artifact name as a string
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateSynthesis(String artifact, DataAccess spviz){
		val overview = spviz.getOverview(artifact)
		return '''
			package «spviz.packageName».viz.subsyntheses
			
			import com.google.inject.Inject
			import de.cau.cs.kieler.klighd.kgraph.KGraphFactory
			import de.cau.cs.kieler.klighd.kgraph.KNode
			import de.cau.cs.kieler.klighd.krendering.extensions.KNodeExtensions
			import de.cau.cs.kieler.klighd.krendering.extensions.KPortExtensions
			import de.cau.cs.kieler.klighd.syntheses.AbstractSubSynthesis
			import «spviz.importedNamespace».model.«artifact»
			«FOR required : spviz.getRequiredArtifacts(artifact)»
				«IF required.get(1) != artifact»
					import «spviz.importedNamespace».model.«required.get(1)»
				«ENDIF»
			«ENDFOR»
			«FOR requiring : spviz.getRequiredArtifacts(artifact)»
				«IF requiring.get(1) != artifact»
					import «spviz.importedNamespace».model.«requiring.get(1)»
				«ENDIF»
			«ENDFOR»
			import «spviz.importedNamespace».model.«spviz.projectName»
			import «spviz.packageName».viz.SynthesisUtils
			import «spviz.packageName».viz.Styles
			import «spviz.packageName».model.«artifact»Context
			import «spviz.packageName».model.IOverviewVisualizationContext
			«IF overview != ""»
				import «spviz.packageName».model.«overview»OverviewContext
			«ENDIF»
			import org.eclipse.elk.core.options.CoreOptions
			import org.eclipse.elk.core.options.PortSide
			
			/**
			 * Sub-synthesis of {@link «spviz.projectName»}s that handles expanded {@link «artifact»} views.
			 */
			class «artifact»Synthesis extends AbstractSubSynthesis<«artifact»Context, KNode> {
				@Inject extension KNodeExtensions
				@Inject extension KPortExtensions
				@Inject extension Styles
				extension KGraphFactory = KGraphFactory.eINSTANCE
				
				override transform(«artifact»Context context) {
					val «artifact.toFirstLower» = context.modelElement
					return #[
						context.createNode() => [
							associateWith(context)
							data += createKIdentifier => [ it.id = context.hashCode.toString ]
							
							«FOR required : spviz.getRequiredArtifacts(artifact)»
							val filteredRequired«required.get(1)»s = SynthesisUtils.filteredElements(«artifact.toFirstLower».required«required.get(0)»«required.get(1)»s,
								context.parent as IOverviewVisualizationContext<«required.get(1)»>, usedContext)
							if (!filteredRequired«required.get(1)»s.empty) {
								ports += createPort(context, "required«required.get(0)»«required.get(1)»s") => [
									associateWith(context)
									data += createKIdentifier => [ it.id = "required«required.get(0)»«required.get(1)»s" ]
									// Required «artifact.toFirstLower»s are always shown and expanded to the east with the drawing direction.
									addLayoutParam(CoreOptions::PORT_SIDE, PortSide::EAST)
									addLayoutParam(CoreOptions::PORT_INDEX, 0)
									addRequired«required.get(0)»«required.get(1)»sActionPortRendering(filteredRequired«required.get(1)»s.size, context.allRequired«required.get(0)»«required.get(1)»sShown)
									width = 12
									height = 12
								]
							}
							
							«ENDFOR»
							«FOR requiring : spviz.getRequiringArtifacts(artifact)»
							val filteredRequiring«requiring.get(1)»s = SynthesisUtils.filteredElements(«artifact.toFirstLower».requiring«requiring.get(0)»«requiring.get(1)»s,
								context.parent as IOverviewVisualizationContext<«requiring.get(1)»>, usedContext)
							if (!filteredRequiring«requiring.get(1)»s.empty) {
								ports += createPort(context, "requiring«requiring.get(0)»«requiring.get(1)»s") => [
									associateWith(context)
									data += createKIdentifier => [ it.id = "requiring«requiring.get(0)»«requiring.get(1)»s" ]
									// Requiring «artifact.toFirstLower»s are always shown and expanded to the west against the drawing direction.
									addLayoutParam(CoreOptions::PORT_SIDE, PortSide::WEST)
									addLayoutParam(CoreOptions::PORT_INDEX, 1)
									addRequiring«requiring.get(0)»«requiring.get(1)»sActionPortRendering(filteredRequiring«requiring.get(1)»s.size, context.allRequiring«requiring.get(0)»«requiring.get(1)»sShown)
									width = 12
									height = 12
								]
							}
							
							«ENDFOR»
							// Add the rendering.
							val hasChildren = !children.empty
							«IF overview != ""»
								add«artifact»Rendering(«artifact.toFirstLower»,
									context.parent instanceof «overview»OverviewContext, hasChildren, usedContext)
							«ELSE»
								add«artifact»Rendering(«artifact.toFirstLower», false, hasChildren, usedContext)
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
	 * @param artifact
	 * 		the artifact name as a string
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateSimpleSynthesis(String packageName, String artifact){
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
			import «packageName».model.«artifact»Context
			
			import static extension de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses.*
			
			/**
			 * Transformation of a simple view of a «artifact» that provides functionality to be expanded, when the specific 
			 * synthesis for «artifact» is called.
			 */
			class Simple«artifact»Synthesis extends AbstractSubSynthesis<«artifact»Context, KNode> {
				@Inject extension KNodeExtensions
				@Inject extension Styles
				extension KGraphFactory = KGraphFactory.eINSTANCE
				
				override transform(«artifact»Context context) {
					transform(context, 0)
				}
				
				def transform(«artifact»Context context, int priority) {
					val «artifact.toFirstLower» = context.modelElement
					return #[
						context.createNode() => [
							associateWith(context)
							data += createKIdentifier => [ it.id = context.hashCode.toString ]
							val label = «artifact.toFirstLower».getName ?: ""
							setLayoutOption(CoreOptions::PRIORITY, priority)
							add«artifact»InOverviewRendering(«artifact.toFirstLower», label, usedContext)
						]
					]
				}
			}
			
		'''
	}
	
}
