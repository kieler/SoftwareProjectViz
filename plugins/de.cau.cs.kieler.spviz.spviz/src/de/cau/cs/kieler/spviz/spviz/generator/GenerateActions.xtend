package de.cau.cs.kieler.spviz.spviz.generator

import org.eclipse.xtext.generator.IFileSystemAccess2

/**
 * Generates action classes for the visualisation.
 */
class GenerateActions {
	def static void generate(IFileSystemAccess2 fsa, DataAccess spviz){
		
		val String packageName = spviz.packageName
		val String folder = "viz/" + packageName.replace('.','/') + "/viz/actions/"
		
		var String content = generateAbstractVisualizationContextChangingAction(spviz)
		fsa.generateFile(folder + "AbstractVisualizationContextChangingAction.xtend", content)
		content = generateContextCollapseExpandAction(spviz)
		fsa.generateFile(folder + "ContextCollapseExpandAction.xtend", content)
		content = generateOverviewContextCollapseExpandAction(spviz)
		fsa.generateFile(folder + "OverviewContextCollapseExpandAction.xtend", content)
		content = generateUndoAction(spviz)
		fsa.generateFile(folder + "UndoAction.xtend", content)
		content = generateRedoAction(spviz)
		fsa.generateFile(folder + "RedoAction.xtend", content)
		content = generateResetViewAction(spviz)
		fsa.generateFile(folder + "ResetViewAction.xtend", content)
		
		for (overview : spviz.overviews)
		for (connection : spviz.getOverviewConnections(overview)) {
			// reveal required artifacts	
			content = generateRevealAction(spviz, overview, connection.get(0), connection.get(1), connection.get(2), true)
			fsa.generateFile(folder + "RevealRequired" + connection.get(0) + connection.get(2) + "sAction.xtend", content)
			// reveal requiring artifacts
			content = generateRevealAction(spviz, overview, connection.get(0), connection.get(2), connection.get(1), false)
			fsa.generateFile(folder + "RevealRequiring" + connection.get(0) + connection.get(2) + "sAction.xtend", content)
		}
	}
	
	/**
	 * Generates the contend for a reveal action class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @param overview
	 * 		an overview name as a string
	 * @param connectionName
	 * 		name of the connection to reveal as a string
	 * @param artifactFrom
	 * 		name of an artifact as a string
	 * @param artifactTo
	 * 		name of an artifact as a string
	 * @param isRequired
	 * 		boolean which defines the direction of the connection
	 * @return
	 * 		the generated file content as a string
	 */
	def static generateRevealAction(DataAccess spviz, String overview, String connectionName, String artifactFrom, String artifactTo, boolean isRequired) {
		val String requiringOrRequired = isRequired ? "Required" : "Requiring"  
		val className = "Reveal" + requiringOrRequired + connectionName + (isRequired ? artifactTo : artifactFrom) + "sAction"
		
		return '''
		package «spviz.packageName».viz.actions
		
		import «spviz.packageName».model.«overview»OverviewContext
		import «spviz.packageName».model.«artifactFrom»Context
		«IF artifactFrom != artifactTo»
			import «spviz.packageName».model.«artifactTo»Context
		«ENDIF»
		import «spviz.packageName».model.IVisualizationContext
		
		import static extension «spviz.packageName».model.util.ContextExtensions.*
		
		/**
		 * Expands the «requiringOrRequired.toFirstLower» «artifactTo.toFirstLower»s of any «artifactFrom.toFirstLower» and connects them with an edge from the new «artifactTo.toFirstLower»'s
		 * 'usedBy«artifactFrom»s' port to this «artifactFrom.toFirstLower»'s '«requiringOrRequired.toFirstLower»«artifactTo»' port. 
		 * If all «requiringOrRequired.toFirstLower» «artifactTo.toFirstLower»s are already shown, this action reverses its functionality and removes all «artifactTo.toFirstLower»s again.
		 * 
		 * @author nre
		 */
		class «className» extends AbstractVisualizationContextChangingAction {
			
			/**
			 * This action's ID.
			 */
			public static val String ID = «className».name
			
			override <M> changeVisualization(IVisualizationContext<M> modelVisualizationContext, ActionContext actionContext) {
				// The «artifactFrom»Context element for the element that was clicked on.
				val «artifactFrom.toFirstLower»Context = modelVisualizationContext as «artifactFrom»Context
				
				// The «artifactFrom.toFirstLower» itself from the context.
				val «artifactFrom.toFirstLower» = «artifactFrom.toFirstLower»Context.modelElement
				
				// The «overview.toFirstLower» overview context this «artifactFrom.toFirstLower» is shown in.
				val «overview.toFirstLower»OverviewContext = «artifactFrom.toFirstLower»Context.parent as «overview»OverviewContext
				
				// The «requiringOrRequired.toFirstLower» «artifactTo.toFirstLower»s that are currently not yet in their detailed view need to be put in that state first.
				val collapsed«requiringOrRequired»«artifactTo»Contexts = «overview.toFirstLower»OverviewContext.collapsedElements.filter [
					«artifactFrom.toFirstLower».«requiringOrRequired.toFirstLower + connectionName + artifactTo»s.contains(it.modelElement)
				].toList
				collapsed«requiringOrRequired»«artifactTo»Contexts.forEach [
					«overview.toFirstLower»OverviewContext.makeDetailed(it)
				]
				
				// The «artifactTo.toFirstLower» contexts in the overview that the «connectionName.toFirstLower» connection can connect to.
				// Use the detailed «artifactTo.toFirstLower» contexts only, as they are all made detailed above.
				val «requiringOrRequired.toFirstLower»«artifactTo»Contexts = «overview.toFirstLower»OverviewContext.detailedElements.filter [
					«artifactFrom.toFirstLower».«requiringOrRequired.toFirstLower + connectionName + artifactTo»s.contains(it.modelElement)
				].toList
				
«««				// If all are already connected, remove them all. Otherwise, connect them all.
«««		//		if (ContextUtils.allConnected(«artifactFrom.toFirstLower»Context, «requiringOrRequired.toFirstLower»«artifactTo»Contexts, «view.toFirstLower»OverviewContext, true)) {
«««		//			«requiringOrRequired.toFirstLower»«artifactTo»Contexts.forEach [ «requiringOrRequired.toFirstLower»«artifactTo»Context |
«««		//				ContextUtils.remove«connectionName»«artifactTo»Edge(«artifactFrom.toFirstLower»Context, «requiringOrRequired.toFirstLower»«artifactTo»Context as «artifactTo»Context)
«««		//			]
«««		//		} else {
				«requiringOrRequired.toFirstLower»«artifactTo»Contexts.forEach [ «requiringOrRequired.toFirstLower»«artifactTo»Context |
					«IF isRequired»
						«artifactFrom.toFirstLower»Context.add«connectionName»«artifactTo»Edge(«requiringOrRequired.toFirstLower»«artifactTo»Context as «artifactTo»Context)
					«ELSE»
						(«requiringOrRequired.toFirstLower»«artifactTo»Context as «artifactTo»Context).add«connectionName»«artifactFrom»Edge(«artifactFrom.toFirstLower»Context)
					«ENDIF»
				]
«««		//		}
			}
			
		}
		'''
	}
	
	/**
	 * Generates the contend for the AbstractVisualizationContextChangingAction class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateAbstractVisualizationContextChangingAction (DataAccess spviz) {
		return '''
			package «spviz.packageName».viz.actions
			
			import de.cau.cs.kieler.klighd.IAction
			import de.cau.cs.kieler.klighd.kgraph.util.KGraphUtil
			import «spviz.packageName».viz.SynthesisProperties
			import «spviz.packageName».viz.SynthesisUtils
			import «spviz.packageName».model.IVisualizationContext
			import «spviz.packageName».model.«spviz.vizName»
			import org.eclipse.core.runtime.Status
			import org.eclipse.emf.ecore.util.EcoreUtil.Copier
			import org.eclipse.ui.statushandlers.StatusManager
			
			import static extension «spviz.packageName».model.util.ContextExtensions.*
			
			/**
			 * An abstract action that allows to change the {@link IVisualizationContext} for a model so that the old one is still
			 * remembered for undo/redo functionality.
			 * An action implementing this class should not override the {@code execute} method, but only the
			 * {@code changeVisualization} method to modify the visualization context that will be used during the next synthesis.
			 * This action will cause KLighD to issue a new synthesis of the base model that will consider the new changed
			 * visualization context.
			 * 
			 * @author nre
			 */
			abstract class AbstractVisualizationContextChangingAction implements IAction {
				
				final override execute(ActionContext context) {
					val visualizationContexts = context.viewContext.getProperty(SynthesisProperties.VISUALIZATION_CONTEXTS)
					val index = context.viewContext.getProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX).intValue
					
					val currentVisualizationContext = visualizationContexts.get(index)
					
					// Make a deep-copy of the current context and store it for the action to be the next canditate for the undo
					// function.
					
					// Copy the root context and the currently shown one from the same Copier to guarantee a completely copied
					// context with only the needed view on that.
					val Copier copier = new Copier
					val copiedVisualizationContext = copier.copy(currentVisualizationContext) as «spviz.vizName»
					copier.copyReferences
					
					// Remove this visualization context and all after that, a redo after an action is not possible anymore.
					while (visualizationContexts.size > index) {
						visualizationContexts.remove(index)
					}
					// Put the copy at the old index.
					visualizationContexts.add(index, copiedVisualizationContext)
					
					// The visualization context of the element that this action is performed on.
					val modelVisualizationContext = SynthesisUtils.getDomainElement(context) as IVisualizationContext<?>
					if (!currentVisualizationContext.isChildContextOrEqual(modelVisualizationContext)) {
«««						TODO: visualisation becomes unresponsive from here sometimes. why?
						throw new IllegalStateException("This action is performed on an element that is not currently in the " +
							"currently displayed visualization context:" + this.class
							+ "\nSomething during the clone process by the undo action probably went wrong.")
					}
					
					// Change the visualization.
					try {
						changeVisualization(modelVisualizationContext, context)
						
						// Put the old context, that will be updated below at the at index + 1 and remember that new index as the
						// current index.
						visualizationContexts.add(index + 1, currentVisualizationContext)
						context.viewContext.setProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX, index + 1)
						
						return getActionResult(context)
						
					} catch (Exception e) {
«««						TODO:
«««						// Put an error model in the context and show that.
«««						val errorModel = new ErrorModel("The action failed to execute and threw an exception.", e)
«««						visualizationContexts.add(index + 1, errorModel) // TODO: Vis context of that.
«««						context.viewContext.setProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX, index + 1)
«««						// Show the exception, but continue normally.
«««						e.printStackTrace
«««						TODO: remove this eclipse ui dependency once this is possible via a service.
						
						StatusManager.getManager().handle(new Status(Status.ERROR, "«spviz.packageName».viz",
							"Something went wrong while executing the " + this.class.canonicalName + " action.\n" + 
							"Please view the error log and send the stack trace and the way to " +
							"reproduce this error to the developer.", e), 
							StatusManager.SHOW.bitwiseOr(StatusManager.LOG));
						return getActionResult(context)
					}
				}
				
				/**
				 * Modifies the visualization context towards a state that represents what this action should perform.
				 * 
				 * @param modelVisualizationContext The visualization context of the element that this action is performed on.
				 */
				abstract def <M> void changeVisualization(
					IVisualizationContext<M> modelVisualizationContext, ActionContext actionContext)
				
				/**
				 * Returns a new {@link ActionResult} this action will return when executed. Should be overriden by individual
				 * actions, if additional layout or animation settings need to be set.
				 */
				protected def ActionResult getActionResult(ActionContext context) {
					return ActionResult.createResult(true).doSynthesis.doZoomToStay(
						KGraphUtil.getAbsolute(context.KGraphElement), context.KGraphElement)
				}
				
			}
			
		'''
	}
	
	/**
	 * Generates the contend for the ContextCollapseExpandAction class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateContextCollapseExpandAction (DataAccess spviz) {
		return '''
			package «spviz.packageName».viz.actions
			
			import «spviz.packageName».model.IOverviewVisualizationContext
			import «spviz.packageName».model.IVisualizationContext
			
			import static extension «spviz.packageName».model.util.ContextExtensions.*
			
			/**
			 * An action that collapses or expands an element by making it detailed in an {@link IOverviewVisualizationContext}.
			 * 
			 * @author nre
			 */
			class ContextCollapseExpandAction extends AbstractVisualizationContextChangingAction {
				/**
				 * This action's ID.
				 */
				public static val String ID = ContextCollapseExpandAction.name
				
				override <M> changeVisualization(IVisualizationContext<M> modelVisualizationContext, ActionContext actionContext) {
					// This action will always be performed on a child visualization context of a IOverviewVisualizationContext.
					val overviewVisContext = modelVisualizationContext.parent
					if (!(overviewVisContext instanceof IOverviewVisualizationContext)) {
						throw new IllegalStateException("This action is performed on an element that is not inside an overview " +
							"visualization!")
					}
					val ovc = (overviewVisContext as IOverviewVisualizationContext<M>)
					
					if (ovc.collapsedElements.contains(modelVisualizationContext)) {
						ovc.makeDetailed(modelVisualizationContext)
					} else if (ovc.detailedElements.contains(modelVisualizationContext)) {
						ovc.collapse(modelVisualizationContext)
						// Remove all edges incident to the now collapsed context.
						ovc.removeEdges(modelVisualizationContext)
					} else { // This error should not be reachable.
						throw new IllegalStateException("Bug in code detected. This context has to be either contained within " +
							"the collapsed or the contained elements")
					}
				}
				
			}
			
		'''
	}
	
	/**
	 * Generates the contend for the OverviewContextCollapseExpandAction class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateOverviewContextCollapseExpandAction (DataAccess spviz) {
		return '''
			package «spviz.packageName».viz.actions
			
			import «spviz.packageName».model.IOverviewVisualizationContext
			import «spviz.packageName».model.IVisualizationContext
			
			import static extension «spviz.packageName».model.util.ContextExtensions.*
			
			/**
			 * An action that collapses or expands an overview by setting its {@link IOverviewVisualizationContext} that way.
			 * 
			 * @author nre
			 */
			class OverviewContextCollapseExpandAction extends AbstractVisualizationContextChangingAction {
				/**
				 * This action's ID.
				 */
				public static val String ID = OverviewContextCollapseExpandAction.name 
				
				override <M> changeVisualization(IVisualizationContext<M> modelVisualizationContext, ActionContext actionContext) {
					if (!(modelVisualizationContext instanceof IOverviewVisualizationContext)) {
						throw new IllegalArgumentException("This action can only be called on a IOverviewVisualizationContext. "
							+ "Was called on " + modelVisualizationContext.class)
					}
					// Just invert the expanded state.
					val c = modelVisualizationContext as IOverviewVisualizationContext<M>
					c.expanded = !c.expanded
					
					// Also, toggle the expansion state in the viewer.
					actionContext.getActiveViewer().toggleExpansion(actionContext.getKNode());
				}
				
			}
			
		'''
	}
	
	/**
	 * Generates the contend for the UndoAction class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateUndoAction (DataAccess spviz) {
		return '''
		package «spviz.packageName».viz.actions
		
		import de.cau.cs.kieler.klighd.IAction
		import «spviz.packageName».viz.SynthesisProperties
		
		/**
		 * Undoes the last action performed on the view model.
		 * 
		 * @author nre
		 */
		class UndoAction implements IAction {
			/**
			 * This action's ID.
			 */
			public static val String ID = UndoAction.name
			
			override execute(ActionContext context) {
				// Just decrement the current index pointing towards the current visualization by one.
				var index = context.viewContext.getProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX).intValue
				index = Math.max(index - 1, 0)
				context.viewContext.setProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX, Integer.valueOf(index))
				
				return ActionResult.createResult(true).doSynthesis
			}
			
		}
		
		'''	
	}
	
	/**
	 * Generates the contend for the RedoAction class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateRedoAction (DataAccess spviz) {
		return '''
		package «spviz.packageName».viz.actions
		
		import de.cau.cs.kieler.klighd.IAction
		import «spviz.packageName».viz.SynthesisProperties
		
		/**
		 * Redoes the last action that was undone on the view model.
		 * 
		 * @author nre
		 */
		class RedoAction implements IAction {
			/**
			 * This action's ID.
			 */
			public static val String ID = RedoAction.name
			
			override execute(ActionContext context) {
				// Just increment the current index pointing towards the current visualization by one.
				var index = context.viewContext.getProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX).intValue
				val visualizationContexts = context.viewContext.getProperty(SynthesisProperties.VISUALIZATION_CONTEXTS)
				index = Math.min(index + 1, visualizationContexts.size - 1)
				context.viewContext.setProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX, Integer.valueOf(index))
				
				return ActionResult.createResult(true).doSynthesis
			}
			
		}
		
		'''
	}
	
	/**
	 * Generates the contend for the ResetViewAction class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateResetViewAction (DataAccess spviz) {
		return '''
		package «spviz.packageName».viz.actions
		
		import de.cau.cs.kieler.klighd.IAction
		import «spviz.packageName».viz.SynthesisProperties
		
		/**
		 * Resets the view to its default overview state.
		 * 
		 * @author nre
		 */
		class ResetViewAction implements IAction {
			/**
			 * This action's ID.
			 */
			public static val String ID = ResetViewAction.name
			
			override execute(ActionContext context) {
				// Just set the current index pointing towards the current visualization to 0.
				context.viewContext.setProperty(SynthesisProperties.CURRENT_VISUALIZATION_CONTEXT_INDEX, Integer.valueOf(0))
				
				return ActionResult.createResult(true).doSynthesis.doZoomToFit
			}
			
		}
		
		'''
	}
}
