package de.cau.cs.kieler.spviz.spviz.generator

import org.eclipse.xtext.generator.IFileSystemAccess2

/**
 * Generates utility classes for the model and visualisation model.
 */
class GenerateModelUtils {
	def static void generate(IFileSystemAccess2 fsa, DataAccess spviz){
		var folder = "modelUtil/" + spviz.importedNamespace.replace('.','/') + "/model/util/"
		fsa.generateFile(folder + "ModelUtil.java", generateModelUtil(spviz.projectName, spviz.importedNamespace))
		
		folder = "vizmodelUtil/" + spviz.packageName.replace('.','/') + "/model/util/"
		fsa.generateFile(folder + "VizModelUtil.xtend", generateVizModelUtil(spviz))
		fsa.generateFile(folder + "ContextExtensions.xtend", generateContextExtensions(spviz))
		
	}
	
	/**
	 * Generates the contend for the ModelUtil.java file contained inside the model package
	 * 
	 * @param projectName
	 *  	the model project name
	 * @param importedNamespace
	 * 		the model package name
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateModelUtil(String projectName, String importedNamespace){
		return '''
			package «importedNamespace».model.util;

			import «importedNamespace».model.«projectName»;
			import org.eclipse.emf.ecore.EObject;
			
			/**
			 * Handy methods for handling with OSGi model elements.
			 */
			public final class ModelUtil {
				
				/**
				 * Returns the «projectName» this model element belongs to.
				 * 
				 * @param element The element to find the project for.
				 * @return The project containing the element.
				 */
				public static «projectName» parentProject(EObject element) {
					EObject current = element;
					while (!(current instanceof «projectName») && current != null) {
						current = current.eContainer();
					}
					if (current instanceof «projectName») {
						return («projectName») current;
					} else {
						return null;
					}
				}
				
			}
			
		'''
	}
	
	/**
	 * Generates the contend for the VizModelUtil.xtend file contained inside the visualisation model package
	 * 
	 * @param spviz
	 *  	a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateVizModelUtil(DataAccess spviz){
		return '''
			package «spviz.packageName».model.util
			
			import «spviz.importedNamespace».model.«spviz.projectName»
			«FOR artifact : spviz.artifacts»
				import «spviz.importedNamespace».model.«artifact»
			«ENDFOR»
			import «spviz.packageName».model.«spviz.vizName»
			«FOR artifact : spviz.artifacts»
				import «spviz.packageName».model.«artifact»Context
			«ENDFOR»
			«FOR view : spviz.overviews»
				import «spviz.packageName».model.«view»OverviewContext
			«ENDFOR»
			import «spviz.packageName».model.Pair
			import «spviz.packageName».model.IVisualizationContext
			import «spviz.packageName».model.IOverviewVisualizationContext
			import «spviz.packageName».model.ModelFactory
			import java.util.List
			
			import static extension «spviz.packageName».model.util.ContextExtensions.*
			
			final class VizModelUtil {
				
				/** The factory to create visualization model element instances */
				static val ModelFactory FACTORY = ModelFactory.eINSTANCE
				
				/** Utility classes are not meant to be instantiated. */
				private new() {
					throw new IllegalAccessError
				}
			
			«FOR artifact : spviz.artifacts»
				/**
				 * Creates an initialized «artifact.toFirstLower» context.
				 * 
				 * @param «artifact.toFirstLower» The «artifact.toFirstLower» this visualization is for.
				 * @param parent The visualization context this element should be added to.
				 * @return The initialized visualization context.
				 */
				static def «artifact»Context create«artifact»Context(«artifact» the«artifact»,
					IOverviewVisualizationContext<?> parent) {
					return FACTORY.create«artifact»Context.initialize(the«artifact», parent)
				}
				
			«ENDFOR»
			
			«FOR overview : spviz.overviews»
				/**
				 * Creates an initialized «overview.toFirstLower» overview context.
				 * 
				 * @param «overview.toFirstLower»s The «overview.toFirstLower»s this visualization is for.
				 * @param parent The visualization context this element should be added to.
				 * @return The initialized visualization context.
				 */
				static def «overview»OverviewContext create«overview»OverviewContext(
					«FOR artifact : spviz.getDisplayedArtifacts(overview)»List<«artifact»> «artifact.toFirstLower»s, «ENDFOR»
					IVisualizationContext<?> parent) {
					return FACTORY.create«overview»OverviewContext.initialize(
						«FOR artifact : spviz.getDisplayedArtifacts(overview)»«artifact.toFirstLower»s, «ENDFOR» parent)
				}
				
			«ENDFOR»
				/**
				 * Creates an initialized visualization context.
				 * 
				 * @param project The project this visualization is for.
				 * @return The initialized visualization context.
				 */
				static def «spviz.vizName» create«spviz.vizName»(«spviz.projectName» project) {
					return FACTORY.create«spviz.vizName».initialize(project, null)
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
	 * Generates the contend for the ContextExtensions.xtend file contained inside the visualisation model package
	 * 
	 * @param spviz
	 *  	a DataAccess to easily get the information from
	 * @return 
	 * 		the generated file content as a string
	 */
	def static String generateContextExtensions(DataAccess spviz){
		return '''
			package «spviz.packageName».model.util
			
			«FOR overview : spviz.overviews»
				import «spviz.packageName».model.«overview»OverviewContext
			«ENDFOR»
			import «spviz.packageName».model.IOverviewVisualizationContext
			import «spviz.packageName».model.IVisualizationContext
			import «spviz.packageName».model.«spviz.vizName»
			«FOR artifact : spviz.artifacts»
				import «spviz.packageName».model.«artifact»Context
			«ENDFOR»
			import «spviz.importedNamespace».model.«spviz.projectName»
			«FOR artifact : spviz.artifacts»
				import «spviz.importedNamespace».model.«artifact»
			«ENDFOR»
			import java.util.List
			
			import static extension org.eclipse.emf.common.util.ECollections.*
			
			
			/**
			 * Extension class that contains some static methods commonly used in the OSGi synthesis for modifying the visualization
			 * context.
			 */
			class ContextExtensions {
				
				static val ALREADY_INITIALIZED_ERROR_MSG = "This object was already initialized and cannot be initialized a " +
				"second time."
				
				«FOR artifact : spviz.artifacts»
					/**
					 * Initializes this context as if this was a constructor initializing the given parameters. Workaround as XCore does
					 * not support individual class constructors with parameters in the generated factory.
					 */
					def static «artifact»Context initialize(«artifact»Context «artifact.toFirstLower»Context, «artifact» the«artifact»,
						IOverviewVisualizationContext<?> parent) {
						«artifact.toFirstLower»Context.parent = parent
						«artifact.toFirstLower»Context.modelElement = the«artifact»
						
						return «artifact.toFirstLower»Context
					}
					
				«ENDFOR»
				«FOR overview : spviz.overviews»
					/**
					 * Initializes this context as if this was a constructor initializing the given parameters. Workaround as XCore does
					 * not support individual class constructors with parameters in the generated factory.
					 */
					def static «overview»OverviewContext initialize(«overview»OverviewContext overviewContext,
						«FOR artifact : spviz.getDisplayedArtifacts(overview)»List<«artifact»> «artifact.toFirstLower»s, «ENDFOR»
						IVisualizationContext<?> parent) {
						if («concatenateStringArray(spviz.getDisplayedArtifacts(overview), "&&", true, "overviewContext.", "s.empty")») {
							«FOR artifact : spviz.getDisplayedArtifacts(overview)»
								overviewContext.«artifact.toFirstLower»s += «artifact.toFirstLower»s
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
				def static «spviz.vizName» initialize(«spviz.vizName» viz, «spviz.projectName» project, IVisualizationContext<?> parent) {
					viz.parent = parent
					viz.modelElement = project
					viz.initializeChildVisualizationContexts
					
					return viz
				}

				«FOR artifact : spviz.artifacts»
					/**
					 * Initializes all child contexts needed for this element, once it is displayed in a detailed fashion.
					 */
					def static dispatch void initializeChildVisualizationContexts(«artifact»Context the«artifact»Context) {
«««					TODO: initialize child context here
						the«artifact»Context.childrenInitialized = true
					}
					
				«ENDFOR»
				/**
				 * Initializes all child contexts needed for this element, once it is displayed in a detailed fashion.
				 */
				def static dispatch void initializeChildVisualizationContexts(«spviz.vizName» viz) {
					«FOR overview : spviz.overviews»
						viz.«overview.toFirstLower»OverviewContext = VizModelUtil.create«overview»OverviewContext(
							«FOR artifact : spviz.getDisplayedArtifacts(overview)»viz.modelElement.«artifact.toFirstLower»s, «ENDFOR»viz)
					«ENDFOR»
					viz.childrenInitialized = true
				}
				
				«FOR overview : spviz.overviews»
					/**
					 * Initializes all child contexts needed for this element, once it is displayed in a detailed fashion.
					 */
					def static dispatch void initializeChildVisualizationContexts(«overview»OverviewContext overviewContext) {
						«FOR artifact : spviz.getDisplayedArtifacts(overview)»
							overviewContext.«artifact.toFirstLower»s.forEach [
								overviewContext.collapsed«artifact»Contexts += VizModelUtil.create«artifact»Context(it, overviewContext)
							]
						«ENDFOR»
						overviewContext.childrenInitialized = true
					}
					
				«ENDFOR»
				«FOR overview : spviz.overviews»
					/**
					 * A descriptive text about what is contained in this overview visualization.
					 */
					def static dispatch String overviewText(«overview»OverviewContext overviewContext) {
						switch (overviewContext.parent) {
«««							TODO: add more cases for nested views
							«spviz.vizName»: {
								"All «overview.toFirstLower»s contained in this project."
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
				
«««				TODO: implement remove edges for all artifacts
«««				«FOR view : spviz.overviews»
«««					def dispatch static void removeEdges(«overview»OverviewContext overviewContext, «check edges»Context context) {
				def static void removeEdges(IOverviewVisualizationContext<?> overviewContext, IVisualizationContext<?> context){
					// do nothing yet.
				}	
«««				«ENDFOR»

				/**
				 * Determines whether the {@code project} is the root model this {@code context} comes from.
				 * 
				 * @param context The visualization context in question.
				 * @param project The potential root model.
				 * @return If the context comes from the project.
				 */
				def static boolean isRootModel(IVisualizationContext<?> context, «spviz.projectName» project) {
					val root = rootVisualization(context)
					
					if (root instanceof «spviz.vizName») {
						return root.modelElement === project
					} else {
						// If the parent hierarchy on the context does end in an «spviz.vizName», it was lost in some focus
						// action. But that also indicates that the root model has not changed and this context has to come from
						// that.
						return true
					}
				}
				
				/**
				 * Returns the root context of the given visualization context.
				 * 
				 * @param context The visualization context to find the root for.
				 * @return The root «spviz.vizName», or {@code null} if the root is not of that type.
				 */
				def static «spviz.vizName» rootVisualization(IVisualizationContext<?> context) {
					var IVisualizationContext<?> currentContext = context
					while (currentContext.parent !== null) {
						currentContext = currentContext.parent
					}
					
					if (currentContext instanceof «spviz.vizName») {
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
				
				«FOR overview : spviz.overviews»
					def static dispatch makeDetailed(«overview»OverviewContext overview, IVisualizationContext<?> collapsedContext) {
						if (collapsedContext === null) {
							return
						}
						var List<? extends IVisualizationContext<Object>> detailed
						var List<? extends IVisualizationContext<Object>> collapsed
						switch (collapsedContext) {
							«FOR artifact : spviz.getDisplayedArtifacts(overview)»
								«artifact»Context: {
								detailed = overview.detailed«artifact»Contexts as List<? extends IVisualizationContext<Object>>
								collapsed = overview.collapsed«artifact»Contexts as List<? extends IVisualizationContext<Object>>
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
				
				«FOR overview : spviz.overviews»
					«detailedOrCollapsedMethods(overview, "detailed", spviz.getDisplayedArtifacts(overview))»
					
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
				
				«FOR overview : spviz.overviews»
					def static dispatch collapse(«overview»OverviewContext overview, IVisualizationContext<?> detailedContext) {
						if (detailedContext === null) {
							return
						}
						var List<? extends IVisualizationContext<Object>> detailed
						var List<? extends IVisualizationContext<Object>> collapsed
						switch (detailedContext) {
							«FOR artifact : spviz.getDisplayedArtifacts(overview)»
								«artifact»Context: {
									detailed = overview.detailed«artifact»Contexts as List<? extends IVisualizationContext<Object>>
									collapsed = overview.collapsed«artifact»Contexts as List<? extends IVisualizationContext<Object>>
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
				
				«FOR overview : spviz.overviews»
					«detailedOrCollapsedMethods(overview, "collapsed", spviz.getDisplayedArtifacts(overview))»
				
				«ENDFOR»
				
				/**
				 * The elements of the model represented by this overview visualization.
				 */
				def static dispatch List<? extends IVisualizationContext<?>> modelElements(IOverviewVisualizationContext<?> overviewContext) {
					return null
				}
				
				«FOR overview : spviz.overviews»
					«IF spviz.getDisplayedArtifacts(overview).size > 1»
						def static dispatch List<?> modelElements(«overview»OverviewContext overviewContext) {
							return («concatenateStringArray(spviz.getDisplayedArtifacts(overview), "+", true, "overviewContext.", "s")»).toList
						}
					«ELSE»
						def static dispatch List<«spviz.getDisplayedArtifacts(overview).get(0)»> modelElements(«overview»OverviewContext overviewContext) {
							return overviewContext.«spviz.getDisplayedArtifacts(overview).get(0).toFirstLower»s
						}
					«ENDIF»
					
				«ENDFOR»
				
				«FOR overview : spviz.overviews»
				«FOR connection : spviz.getOverviewConnections(overview)»
					/**
					 * Adds a required edge to the parent overview context of the two given contexts.
					 * The direction of the edge indicates that the «connection.get(1).toFirstLower» of the {@code requiringContext} requires the «connection.get(2).toFirstLower» of the
					 * {@code requiredContext}.
					 * [requiring] ---requires---> [required]
					 * 
					 * @param requiringContext The «connection.get(1).toFirstLower» context with the «connection.get(1).toFirstLower» requiring the other «connection.get(2).toFirstLower».
					 * @param requiredContext The «connection.get(2).toFirstLower» context with the «connection.get(2).toFirstLower» required by the other «connection.get(1).toFirstLower».
					 */
					def static void add«connection.get(0)»«connection.get(2)»Edge(«connection.get(1)»Context requiringContext, «connection.get(2)»Context requiredContext) {
						val parentContext = requiringContext.parent as «overview»OverviewContext
						if (requiredContext.parent !== parentContext) {
							throw new IllegalArgumentException("The requiring and the required context both have to have the same " +
								"parent context!")
						}
						// Only if this edge does not exist yet, add it to the list of required «connection.get(2).toFirstLower» edges.
						if (!parentContext.required«connection.get(0)»«connection.get(2)»Edges.exists [ key === requiringContext && value === requiredContext ]) {
							parentContext.required«connection.get(0)»«connection.get(2)»Edges += VizModelUtil.createPair(requiringContext, requiredContext)
							
							// Check for both the requiring «connection.get(1).toFirstLower» and the required «connection.get(2).toFirstLower» if all connections are now shown in the 
							// parent context. If they are, remember it in the corresponding «connection.get(1).toFirstLower» context.
							// Requiring context:
							if (requiringContext.modelElement.required«connection.get(0)»«connection.get(2)»s.forall [ required |
								!parentContext.modelElements.contains(required) ||
								parentContext.required«connection.get(0)»«connection.get(2)»Edges.exists [ key === requiringContext && value.modelElement === required ]
							]) {
								requiringContext.allRequired«connection.get(0)»«connection.get(2)»sShown = true
							}
							// Required context:
							if (requiredContext.modelElement.requiring«connection.get(0)»«connection.get(1)»s.forall [ requiring |
								!parentContext.modelElements.contains(requiring) ||
								parentContext.requiring«connection.get(0)»«connection.get(1)»Edges.exists [ key === requiredContext && value.modelElement === requiring ]
							]) {
								requiredContext.allRequiring«connection.get(0)»«connection.get(1)»sShown = true
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
	 * 		
	 * @return 
	 * 		the method definition as a String
	 */
	def static String detailedOrCollapsedMethods(String overviewName, String kind, String[] artifacts) {
		if (artifacts.empty || kind != "detailed" && kind != "collapsed") return ""
		val returnType = artifacts.size == 1 ? "List<" + artifacts.get(0) + "Context>" : "List<? extends IVisualizationContext<?>>"
		var res = "def static dispatch " + returnType + " get" + kind.toFirstUpper + "Elements(" + overviewName + "OverviewContext overviewContext) {\n"
		if (artifacts.size == 1){
			res += "\treturn overviewContext."+ kind + artifacts.get(0) +"Contexts\n}"
		} else {
			res += "\tvar Iterable<IVisualizationContext<? extends Object>> " + kind + "Elements = overviewContext." + kind + artifacts.get(0) +"Contexts\n"
			for (i : 1 ..< artifacts.size)
				res += "\t\t+ overviewContext." + kind + artifacts.get(i) + "Contexts\n"
			res += "\treturn " + kind + "Elements.toList as List<? extends IVisualizationContext<?>>\n}"
		}
		return res
	}
	
	/**
	 * Concatenates the elements of the given string array, while adding a 
	 * given prefix and suffix to each element
	 * 
	 * @param elements
	 *  	array of strings
	 * @param symbol
	 * 		the symbol to put between each element
	 * @param lowercase
	 *  	boolean to decide if the elements should be made lower case before 
	 * 		they are combined with the prefix and suffix
	 * @param prefix
	 *  	a prefix string
	 * @param suffix
	 *  	a suffix string
	 * @return 
	 * 		the concatenated string
	 */
	def static String concatenateStringArray(String[] elements, String symbol, boolean lowercase, String prefix, String suffix){
		var res = prefix + (lowercase ? elements.get(0).toFirstLower : elements.get(0)) + suffix
		for (i : 1 ..< elements.size){
			res += "\n"+ symbol +" " + prefix + (lowercase ? elements.get(i).toFirstLower : elements.get(i)) + suffix
		}
		return res
	}

}
