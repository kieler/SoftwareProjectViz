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
import java.util.List
import org.eclipse.core.resources.IFolder
import org.eclipse.core.runtime.IProgressMonitor

import static extension de.cau.cs.kieler.spviz.spvizmodel.util.SPVizModelExtension.*

/**
 * Generates utility classes for the visualization model.
 * 
 * @author leo, nre
 */
class GenerateVizModelUtils {
    
	def static void generate(IFolder sourceFolder, DataAccess spviz, IProgressMonitor progressMonitor) {
        val folder = spviz.getBundleNamePrefix.replace('.', '/') + "/model/util/"
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "VizModelUtil.xtend", generateVizModelUtil(spviz),
            progressMonitor)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "ContextExtensions.xtend",
            generateContextExtensions(spviz), progressMonitor)
	}
	
	/**
	 * Generates the content for the VizModelUtil.xtend file contained inside the visualization model package
	 * 
	 * @param data
	 *  	a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateVizModelUtil(DataAccess data) {
		return '''
			package «data.getBundleNamePrefix».model.util
			
			import «data.modelBundleNamePrefix».model.«data.projectName»
			«FOR artifact : data.artifacts»
				import «data.modelBundleNamePrefix».model.«artifact.name»
			«ENDFOR»
			import «data.getBundleNamePrefix».model.«data.visualizationName»
			«FOR artifact : data.artifacts»
				import «data.getBundleNamePrefix».model.«artifact.name»Context
			«ENDFOR»
			«FOR view : data.views»
				import «data.getBundleNamePrefix».model.«view.name»OverviewContext
			«ENDFOR»
			import «data.getBundleNamePrefix».model.Pair
			import «data.getBundleNamePrefix».model.IVisualizationContext
			import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
			import «data.getBundleNamePrefix».model.«data.visualizationName»Factory
			import java.util.List
			
			import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
			
			final class VizModelUtil {
				
				/** The factory to create visualization model element instances */
				static val «data.visualizationName»Factory FACTORY = «data.visualizationName»Factory.eINSTANCE
				
				/** Utility classes are not meant to be instantiated. */
				private new() {
					throw new IllegalAccessError
				}
			
			«FOR artifact : data.artifacts»
				/**
				 * Creates an initialized «artifact.name.toFirstLower» context.
				 * 
				 * @param «artifact.name.toFirstLower» The «artifact.name.toFirstLower» this visualization is for.
				 * @param parent The visualization context this element should be added to.
				 * @return The initialized visualization context.
				 */
				static def «artifact.name»Context create«artifact.name»Context(«artifact.name» the«artifact.name»,
					IOverviewVisualizationContext<?> parent) {
					return FACTORY.create«artifact.name»Context.initialize(the«artifact.name», parent)
				}
				
			«ENDFOR»
			
			«FOR view : data.views»
				/**
				 * Creates an initialized «view.name.toFirstLower» overview context.
				 * 
				 * @param «view.name.toFirstLower»s The «view.name.toFirstLower»s this visualization is for.
				 * @param parent The visualization context this element should be added to.
				 * @return The initialized visualization context.
				 */
				static def «view.name»OverviewContext create«view.name»OverviewContext(
					«FOR shownElement : view.shownElements»List<«shownElement.shownElement.name»> «shownElement.shownElement.name.toFirstLower»s, «ENDFOR»
					IVisualizationContext<?> parent) {
					return FACTORY.create«view.name»OverviewContext.initialize(
						«FOR shownElement : view.shownElements»«shownElement.shownElement.name.toFirstLower»s, «ENDFOR» parent)
				}
				
			«ENDFOR»
				/**
				 * Creates an initialized visualization context.
				 * 
				 * @param project The project this visualization is for.
				 * @return The initialized visualization context.
				 */
				static def «data.visualizationName» create«data.visualizationName»(«data.projectName» project) {
					return FACTORY.create«data.visualizationName».initialize(project, null)
				}
			
				/**
				 * Create a Pair with the given key and value.
				 * 
				 * @param <K> The key's class.
				 * @param <V> The value's class.
				 * @param key The key or the first value of the pair.
				 * @param value The value or the second value of the pair.
				 * @return The initialized pair.
				 */
				static def <K, V> Pair<K, V> createPair(K key, V value) {
					val Pair<K, V> pair = FACTORY.createPair
					pair.key = key
					pair.value = value
					
					return pair
				}
			
			}
			
		'''
	}
	
	/**
	 * Generates the content for the ContextExtensions.xtend file contained inside the visualization model package
	 * 
	 * @param data
	 *  	a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateContextExtensions(DataAccess data) {
		return '''
			package «data.getBundleNamePrefix».model.util
			
			«FOR view : data.views»
				import «data.getBundleNamePrefix».model.«view.name»OverviewContext
			«ENDFOR»
			import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
			import «data.getBundleNamePrefix».model.IVisualizationContext
			import «data.getBundleNamePrefix».model.«data.visualizationName»
			«FOR artifact : data.artifacts»
				import «data.getBundleNamePrefix».model.«artifact.name»Context
			«ENDFOR»
			import «data.modelBundleNamePrefix».model.«data.projectName»
			«FOR artifact : data.artifacts»
				import «data.modelBundleNamePrefix».model.«artifact.name»
			«ENDFOR»
			import java.util.List
			
			/**
			 * Extension class that contains some static methods commonly used in the OSGi synthesis for modifying the visualization
			 * context.
			 */
			class ContextExtensions {
				
				static val ALREADY_INITIALIZED_ERROR_MSG = "This object was already initialized and cannot be initialized a " +
				"second time."
				
				«FOR artifact : data.artifacts»
					/**
					 * Initializes this context as if this was a constructor initializing the given parameters. Workaround as XCore does
					 * not support individual class constructors with parameters in the generated factory.
					 */
					def static «artifact.name»Context initialize(«artifact.name»Context «artifact.name.toFirstLower»Context, «artifact.name» the«artifact.name»,
						IOverviewVisualizationContext<?> parent) {
						«artifact.name.toFirstLower»Context.parent = parent
						«artifact.name.toFirstLower»Context.modelElement = the«artifact.name»
						
						return «artifact.name.toFirstLower»Context
					}
					
				«ENDFOR»
				«FOR view : data.views»
					/**
					 * Initializes this context as if this was a constructor initializing the given parameters. Workaround as XCore does
					 * not support individual class constructors with parameters in the generated factory.
					 */
					def static «view.name»OverviewContext initialize(«view.name»OverviewContext overviewContext,
						«FOR shownElement : view.shownElements»List<«shownElement.shownElement.name»> «shownElement.shownElement.name.toFirstLower»s, «ENDFOR»
						IVisualizationContext<?> parent) {
						«FOR shownElement : view.shownElements BEFORE "if (" SEPARATOR " && " AFTER ") {"»
							overviewContext.«shownElement.shownElement.name.toFirstLower»s.empty
						«ENDFOR»
						«FOR shownElement : view.shownElements»
							overviewContext.«shownElement.shownElement.name.toFirstLower»s += «shownElement.shownElement.name.toFirstLower»s
						«ENDFOR»
						} else {
							throw new RuntimeException(ALREADY_INITIALIZED_ERROR_MSG)
						}
						overviewContext.parent = parent
						overviewContext.initializeChildVisualizationContexts
						
						return overviewContext
					}
					
				«ENDFOR»
				/**
				 * Initializes this context as if this was a constructor initializing the given parameters. Workaround as XCore does
				 * not support individual class constructors with parameters in the generated factory.
				 */
				def static «data.visualizationName» initialize(«data.visualizationName» viz, «data.projectName» project, IVisualizationContext<?> parent) {
					viz.parent = parent
					viz.modelElement = project
					viz.initializeChildVisualizationContexts
					
					return viz
				}

				«FOR artifact : data.artifacts»
					/**
					 * Initializes all child contexts needed for this element, once it is displayed in a detailed fashion.
					 */
					def static dispatch void initializeChildVisualizationContexts(«artifact.name»Context the«artifact.name»Context) {
«««					TODO: initialize child context here
						the«artifact.name»Context.childrenInitialized = true
					}
					
				«ENDFOR»
				/**
				 * Initializes all child contexts needed for this element, once it is displayed in a detailed fashion.
				 */
				def static dispatch void initializeChildVisualizationContexts(«data.visualizationName» viz) {
					«FOR view : data.views»
						viz.«view.name.toFirstLower»OverviewContext = VizModelUtil.create«view.name»OverviewContext(
							«FOR shownElement : view.shownElements»viz.modelElement.«shownElement.shownElement.name.toFirstLower»s, «ENDFOR»viz)
					«ENDFOR»
					viz.childrenInitialized = true
				}
				
				«FOR view : data.views»
					/**
					 * Initializes all child contexts needed for this element, once it is displayed in a detailed fashion.
					 */
					def static dispatch void initializeChildVisualizationContexts(«view.name»OverviewContext overviewContext) {
						«FOR shownElement : view.shownElements»
							overviewContext.«shownElement.shownElement.name.toFirstLower»s.forEach [
								overviewContext.collapsed«shownElement.shownElement.name»Contexts += VizModelUtil.create«shownElement.shownElement.name»Context(it, overviewContext)
							]
						«ENDFOR»
						overviewContext.childrenInitialized = true
					}
					
				«ENDFOR»
				«FOR view : data.views»
					/**
					 * A descriptive text about what is contained in this overview visualization.
					 */
					def static dispatch String overviewText(«view.name»OverviewContext overviewContext) {
						switch (overviewContext.parent) {
«««							TODO: add more cases for nested views
							«data.visualizationName»: {
								"All «view.name.toFirstLower»s contained in this project."
							}
							default: {
								"No descriptive text for this product overview available yet."
							}
						}
					}
					
				«ENDFOR»
				/**
				 * Returns true if {@code childContext} is a child visualization context contained in the {@code rootContext} or the
				 * contexts are equal.
				 * Uses the {@link IVisualizationContext#getParent()} to find out if it is contained.
				 * 
				 * @param rootContext The root context that may contain the child context.
				 * @param childContext The child context that should be checked if it is contained in the rootContext.
				 * @return If {@code rootContext} is a parent of {@code childContext}.
				 */
				def static boolean isChildContextOrEqual(IVisualizationContext<?> rootContext, IVisualizationContext<?> childContext) {
					if (rootContext === childContext) {
						return true
					}
					var currentContext = childContext
					while(currentContext !== null) {
						if (currentContext === rootContext) {
							return true
						}
						currentContext = currentContext.parent
					}
					return false
				}
				
				def static dispatch void removeEdges(IOverviewVisualizationContext<?> ovc, String s) {
					// This method's purpose is just to tell Xtend that the second paramater's inherited class should be 'Object'
				}
				
				«FOR view : data.views»
					«IF view.shownConnections.empty»
						/**
						 * Removes all edges incident to the context.
						 * 
						 * @param overviewContext The overview context containing the edge.
						 * @param context The context of that all incoming or outgoing edges should be removed (not internal ones).
						 */
						def dispatch static void removeEdges(«view.name»OverviewContext overviewContext, IVisualizationContext<?> context) {
							// There are no edges in «view.name.toFirstLower» overview contexts. So do nothing.
						}
						
					«ELSE»
						«FOR shownElement : view.shownElements»
							def dispatch static void removeEdges(«view.name»OverviewContext overviewContext, «shownElement.shownElement.name»Context context) {
								«FOR requiredConnection : data.getRequiredArtifactsInOverview(shownElement.shownElement, view)»
									overviewContext.required«requiredConnection.requiring.name»Requires«requiredConnection.required.name»Named«requiredConnection.name»Edges.clone.forEach[
										if (key === context) {
											overviewContext.required«requiredConnection.requiring.name»Requires«requiredConnection.required.name»Named«requiredConnection.name»Edges.remove(it)
											key.allRequired«requiredConnection.requiring.name»Requires«requiredConnection.required.name»Named«requiredConnection.name»Shown = false
											value.allRequiring«requiredConnection.requiring.name»Requires«requiredConnection.required.name»Named«requiredConnection.name»Shown = false
										}
									]
									
								«ENDFOR»
								«FOR requiringConnection : data.getRequiringArtifactsInOverview(shownElement.shownElement, view)»
									overviewContext.requiring«requiringConnection.requiring.name»Requires«requiringConnection.required.name»Named«requiringConnection.name»Edges.clone.forEach[
										if (value === context) {
											overviewContext.requiring«requiringConnection.requiring.name»Requires«requiringConnection.required.name»Named«requiringConnection.name»Edges.remove(it)
											key.allRequired«requiringConnection.requiring.name»Requires«requiringConnection.required.name»Named«requiringConnection.name»Shown = false
											value.allRequiring«requiringConnection.requiring.name»Requires«requiringConnection.required.name»Named«requiringConnection.name»Shown = false
										}
									]
									
								«ENDFOR»
							}
							
						«ENDFOR»
					«ENDIF»
				«ENDFOR»
				/**
				 * Determines whether the {@code project} is the root model this {@code context} comes from.
				 * 
				 * @param context The visualization context in question.
				 * @param project The potential root model.
				 * @return If the context comes from the project.
				 */
				def static boolean isRootModel(IVisualizationContext<?> context, «data.projectName» project) {
					val root = rootVisualization(context)
					
					if (root instanceof «data.visualizationName») {
						return root.modelElement === project
					} else {
						// If the parent hierarchy on the context does end in an «data.visualizationName», it was lost in some focus
						// action. But that also indicates that the root model has not changed and this context has to come from
						// that.
						return true
					}
				}
				
				/**
				 * Returns the root context of the given visualization context.
				 * 
				 * @param context The visualization context to find the root for.
				 * @return The root «data.visualizationName», or {@code null} if the root is not of that type.
				 */
				def static «data.visualizationName» rootVisualization(IVisualizationContext<?> context) {
					var IVisualizationContext<?> currentContext = context
					while (currentContext.parent !== null) {
						currentContext = currentContext.parent
					}
					
					if (currentContext instanceof «data.visualizationName») {
						return currentContext
					} else {
						return null
					}
				}
				
				/**
				 * Makes the {@code collapsedContext} that is a collapsed visualization context within this overview context
				 * so it is detailed and handles the initialization of the child visualization contexts of that now detailed
				 * context.
				 * 
				 * @param overview The parent overview context that contains the collapsed context in its collapsedElements
				 * field.
				 * @param collapsedContext The context that is now a collapsed element in the parent overview and should be put in
				 * the detailed elements as well as be initialized for its child contexts.
				 */
				def static dispatch makeDetailed(IOverviewVisualizationContext<?> overview, IVisualizationContext<?> collapsedContext) {
					// Only execute this if the element is not already detailed.
					if (overview.detailedElements.contains(collapsedContext)) {
						return
					}
					
					// This element was previously collapsed, so put it in the detailed list now and initialize its child
					// visualization contexts.
					overview.collapsedElements.remove(collapsedContext)
					// Only this cast will allow to add the context. We know this adding is type-safe, as the collapsed- and
					// the detailed elements list are always of the same type. If they are not, the collapsed/detailed state
					// here would not make any sense.
					(overview.detailedElements as List<IVisualizationContext<?>>).add(collapsedContext)
					if (!collapsedContext.childrenInitialized) {
						collapsedContext.initializeChildVisualizationContexts
					}
				}
				
				«FOR view : data.views»
					def static dispatch makeDetailed(«view.name»OverviewContext overview, IVisualizationContext<?> collapsedContext) {
						if (collapsedContext === null) {
							return
						}
						var List<? extends IVisualizationContext<Object>> detailed
						var List<? extends IVisualizationContext<Object>> collapsed
						switch (collapsedContext) {
							«FOR shownElement: view.shownElements»
								«shownElement.shownElement.name»Context: {
								detailed = overview.detailed«shownElement.shownElement.name»Contexts as List<? extends IVisualizationContext<Object>>
								collapsed = overview.collapsed«shownElement.shownElement.name»Contexts as List<? extends IVisualizationContext<Object>>
								}
							«ENDFOR»
						}
						
						// Only execute this if the element is not already detailed.
						if (detailed.contains(collapsedContext)) {
							return
						}
						
						// This element was previously collapsed, so put it in the detailed list now and initialize its child
						// visualization contexts.
						collapsed.remove(collapsedContext)
						// Only this cast will allow to add the context. We know this adding is type-safe, as the collapsed- and
						// the detailed elements list are always of the same type. If they are not, the collapsed/detailed state
						// here would not make any sense.
						(detailed as List<IVisualizationContext<?>>).add(collapsedContext)
						collapsedContext.initializeChildVisualizationContexts
					}
					
				«ENDFOR»
				
				/**
				 * The visualization contexts of the detailed elements.
				 */
				def static dispatch List<? extends IVisualizationContext<?>> getDetailedElements(IOverviewVisualizationContext<?> overviewContext) {
					return null
				}
				
				«FOR view : data.views»
					«detailedOrCollapsedMethods(view.name, "detailed", view.shownElements.map[shownElement.name])»
					
				«ENDFOR»
				/**
				 * Collapses the {@code expandedContext} that is an expanded visualization context within this overview context
				 * so it is collapsed after this method.
				 * Also removes any edges connected to the now collapsed element.
				 * 
				 * @param overview The parent overview context that contains the expanded context in its detailedElements
				 * field.
				 * @param detailedContext The context that is now a detailed element in the parent overview and should be put in
				 * the collapsed elements.
				 */
				def static dispatch collapse(IOverviewVisualizationContext<?> overview, IVisualizationContext<?> detailedContext) {
					// Only execute this if the element is not already collapsed
					if (overview.collapsedElements.contains(detailedContext)) {
						return
					}
				
					// This element was previously detailed, so put it in the collapsed list now.
					overview.detailedElements.remove(detailedContext)
					// Only this cast will allow to add the context. We know this adding is type-safe, as the collapsed- and
					// the detailed elements list are always of the same type. If they are not, the collapsed/detailed state
					// here would not make any sense.
					(overview.collapsedElements as List<IVisualizationContext<?>>).add(detailedContext)
				}
				
				«FOR view : data.views»
					def static dispatch collapse(«view.name»OverviewContext overview, IVisualizationContext<?> detailedContext) {
						if (detailedContext === null) {
							return
						}
						var List<? extends IVisualizationContext<Object>> detailed
						var List<? extends IVisualizationContext<Object>> collapsed
						switch (detailedContext) {
							«FOR shownElement : view.shownElements»
								«shownElement.shownElement.name»Context: {
									detailed = overview.detailed«shownElement.shownElement.name»Contexts as List<? extends IVisualizationContext<Object>>
									collapsed = overview.collapsed«shownElement.shownElement.name»Contexts as List<? extends IVisualizationContext<Object>>
								}
							«ENDFOR»
						}
						
						// Only execute this if the element is not already collapsed
						if (collapsed.contains(detailedContext)) {
							return
						}
						
						// This element was previously detailed, so put it in the collapsed list now.
						detailed.remove(detailedContext)
						// Only this cast will allow to add the context. We know this adding is type-safe, as the collapsed- and
						// the detailed elements list are always of the same type. If they are not, the collapsed/detailed state
						// here would not make any sense.
						(collapsed as List<IVisualizationContext<?>>).add(detailedContext)
					}
					
				«ENDFOR»
				/**
				 * The visualization contexts of the collapsed elements.
				 */
				def static dispatch List<? extends IVisualizationContext<?>> getCollapsedElements(IOverviewVisualizationContext<?> overviewContext) {
					return null
				}
				
				«FOR view : data.views»
					«detailedOrCollapsedMethods(view.name, "collapsed", view.shownElements.map[shownElement.name])»
				
				«ENDFOR»
				
				/**
				 * The elements of the model represented by this overview visualization.
				 */
				def static dispatch List<? extends IVisualizationContext<?>> modelElements(IOverviewVisualizationContext<?> overviewContext) {
					return null
				}
				
				«FOR view : data.views»
					«IF view.shownElements.size > 1»
						def static dispatch List<?> modelElements(«view.name»OverviewContext overviewContext) {
							«FOR shownElement : view.shownElements BEFORE 'return(' SEPARATOR " + " AFTER ').toList'»
								overviewContext.«shownElement.shownElement.name.toFirstLower»s
							«ENDFOR»
						}
					«ELSE»
						def static dispatch List<«view.shownElements.get(0).shownElement.name»> modelElements(«view.name»OverviewContext overviewContext) {
							return overviewContext.«view.shownElements.get(0).shownElement.name.toFirstLower»s
						}
					«ENDIF»
					
				«ENDFOR»
				
				«FOR view : data.views»
					«FOR shownConnection : view.shownConnections»
						/**
						 * Adds a required edge to the parent overview context of the two given contexts.
						 * The direction of the edge indicates that the «shownConnection.shownConnection.requiring.name.toFirstLower» of the {@code requiringContext} requires the «shownConnection.shownConnection.required.name.toFirstLower» of the
						 * {@code requiredContext}.
						 * [requiring] ---requires---> [required]
						 * 
						 * @param requiringContext The «shownConnection.shownConnection.requiring.name.toFirstLower» context with the «shownConnection.shownConnection.requiring.name.toFirstLower» requiring the other «shownConnection.shownConnection.required.name.toFirstLower».
						 * @param requiredContext The «shownConnection.shownConnection.required.name.toFirstLower» context with the «shownConnection.shownConnection.required.name.toFirstLower» required by the other «shownConnection.shownConnection.requiring.name.toFirstLower».
						 */
						def static void add«shownConnection.shownConnection.name»«shownConnection.shownConnection.required.name»Edge(«shownConnection.shownConnection.requiring.name»Context requiringContext, «shownConnection.shownConnection.required.name»Context requiredContext) {
							val parentContext = requiringContext.parent as «view.name»OverviewContext
							if (requiredContext.parent !== parentContext) {
								throw new IllegalArgumentException("The requiring and the required context both have to have the same " +
									"parent context!")
							}
							// Only if this edge does not exist yet, add it to the list of required «shownConnection.shownConnection.required.name.toFirstLower» edges.
							if (!parentContext.required«shownConnection.shownConnection.requiring.name»Requires«shownConnection.shownConnection.required.name»Named«shownConnection.shownConnection.name»Edges.exists [ key === requiringContext && value === requiredContext ]) {
								parentContext.required«shownConnection.shownConnection.requiring.name»Requires«shownConnection.shownConnection.required.name»Named«shownConnection.shownConnection.name»Edges += VizModelUtil.createPair(requiringContext, requiredContext)
								
								// Check for both the requiring «shownConnection.shownConnection.requiring.name.toFirstLower» and the required «shownConnection.shownConnection.required.name.toFirstLower» if all connections are now shown in the 
								// parent context. If they are, remember it in the corresponding «shownConnection.shownConnection.requiring.name.toFirstLower» context.
								// Requiring context:
								if (requiringContext.modelElement.required«shownConnection.shownConnection.name»«shownConnection.shownConnection.required.name»s.forall [ required |
									!parentContext.modelElements.contains(required) ||
									parentContext.required«shownConnection.shownConnection.requiring.name»Requires«shownConnection.shownConnection.required.name»Named«shownConnection.shownConnection.name»Edges.exists [ key === requiringContext && value.modelElement === required ]
								]) {
									requiringContext.allRequired«shownConnection.shownConnection.requiring.name»Requires«shownConnection.shownConnection.required.name»Named«shownConnection.shownConnection.name»Shown = true
								}
								// Required context:
								if (requiredContext.modelElement.requiring«shownConnection.shownConnection.name»«shownConnection.shownConnection.requiring.name»s.forall [ requiring |
									!parentContext.modelElements.contains(requiring) ||
									parentContext.requiring«shownConnection.shownConnection.requiring.name»Requires«shownConnection.shownConnection.required.name»Named«shownConnection.shownConnection.name»Edges.exists [ value === requiredContext && value.modelElement === requiring ]
								]) {
									requiredContext.allRequiring«shownConnection.shownConnection.requiring.name»Requires«shownConnection.shownConnection.required.name»Named«shownConnection.shownConnection.name»Shown = true
								}
							}
						}
					«ENDFOR»
				«ENDFOR»
			}
		'''
	}
	
	
	/**
	 * Creates a getDetailedElements or getCollapsedElements method definition 
	 * for the given overview
	 * 
	 * @param overviewName
	 * 		the name of an overview
	 * @param kind
	 * 		string either "detailed" or "collapsed
	 * @param artifacts
	 * 		the names of the artifacts shown in the overview
	 * @return 
	 * 		the method definition as a String
	 */
	def static String detailedOrCollapsedMethods(String overviewName, String kind, List<String> artifacts) {
		if (artifacts.empty || kind != "detailed" && kind != "collapsed") {
		    return ""
	    }
		val returnType = artifacts.size == 1 ? "List<" + artifacts.get(0) + "Context>" : "List<? extends IVisualizationContext<?>>"
		var res = "def static dispatch " + returnType + " get" + kind.toFirstUpper + "Elements(" + overviewName + "OverviewContext overviewContext) {\n"
		if (artifacts.size == 1) {
			res += "\treturn overviewContext."+ kind + artifacts.get(0) +"Contexts\n}"
		} else {
			res += "\tvar Iterable<IVisualizationContext<? extends Object>> " + kind + "Elements = overviewContext." + kind + artifacts.get(0) +"Contexts\n"
			for (i : 1 ..< artifacts.size)
				res += "\t\t+ overviewContext." + kind + artifacts.get(i) + "Contexts\n"
			res += "\treturn " + kind + "Elements.toList as List<? extends IVisualizationContext<?>>\n}"
		}
		return res
	}

}
