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
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.core.resources.IFolder
import org.eclipse.core.runtime.IProgressMonitor

import static extension de.cau.cs.kieler.spviz.spvizmodel.util.SPVizModelExtension.*

/**
 * Generates action classes for the visualization.
 * 
 * @author leo, nre
 */
class GenerateActions {
    
	def static void generate(IFolder sourceFolder, DataAccess data, IProgressMonitor progressMonitor) {
		
		val String bundleNamePrefix = data.getBundleNamePrefix
		val String folder = bundleNamePrefix.replace('.','/') + "/viz/actions/"
		
		var String content = generateAbstractVisualizationContextChangingAction(data)
		FileGenerator.generateOrUpdateFile(sourceFolder, folder + "AbstractVisualizationContextChangingAction.xtend", content, progressMonitor)
		content = generateContextCollapseExpandAction(data)
		FileGenerator.generateOrUpdateFile(sourceFolder, folder + "ContextCollapseExpandAction.xtend", content, progressMonitor)
		content = generateOverviewContextCollapseExpandAction(data)
		FileGenerator.generateOrUpdateFile(sourceFolder, folder + "OverviewContextCollapseExpandAction.xtend", content, progressMonitor)
		content = generateUndoAction(data)
		FileGenerator.generateOrUpdateFile(sourceFolder, folder + "UndoAction.xtend", content, progressMonitor)
		content = generateRedoAction(data)
		FileGenerator.generateOrUpdateFile(sourceFolder, folder + "RedoAction.xtend", content, progressMonitor)
		content = generateResetViewAction(data)
		FileGenerator.generateOrUpdateFile(sourceFolder, folder + "ResetViewAction.xtend", content, progressMonitor)
		content = generateContextExpandAllAction(data)
		FileGenerator.generateOrUpdateFile(sourceFolder, folder + "ContextExpandAllAction.xtend", content, progressMonitor)
		content = generateConnectAllAction(data)
		FileGenerator.generateOrUpdateFile(sourceFolder, folder + "ConnectAllAction.xtend", content, progressMonitor)
        content = generateSelectRelatedAction(data)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "SelectRelatedAction.xtend", content, progressMonitor)
        content = generateShowHideCollapsedAction(data)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "ShowHideCollapsedAction.xtend", content, progressMonitor)
		content = generateStoreModelAction(data)
		FileGenerator.generateOrUpdateFile(sourceFolder, folder + "StoreModelAction.xtend", content, progressMonitor)
		
		for (view : data.views) {
    		for (shownConnection : view.shownConnections) {
    		    val connection = shownConnection.shownConnection
    			// reveal required artifacts
    			content = generateRevealAction(data, view, connection, true)
    			FileGenerator.generateOrUpdateFile(sourceFolder,
    			    folder + "RevealRequired" + connection.requiring.name + "Requires" + connection.required.name + "Named" + connection.name + "Action.xtend",
    			    content, progressMonitor)
    			// reveal requiring artifacts
    			content = generateRevealAction(data, view, connection, false)
    			FileGenerator.generateOrUpdateFile(sourceFolder,
    			    folder + "RevealRequiring" + connection.requiring.name + "Requires" + connection.required.name + "Named" + connection.name + "Action.xtend",
    			    content, progressMonitor)
    		}
		}
	}
	
	def static generateContextExpandAllAction(DataAccess data) {
		return '''
		package «data.getBundleNamePrefix».viz.actions
		
		import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
		import «data.getBundleNamePrefix».model.IVisualizationContext
		
		import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
		
		/**
		 * An action that expands all element by making them detailed in an {@link IOverviewVisualizationContext}.
		 * 
		 * @author nre
		 */
		class ContextExpandAllAction extends AbstractVisualizationContextChangingAction {
		    /**
		     * This action's ID.
		     */
		    public static val String ID = ContextExpandAllAction.name
		    
		    override <M> changeVisualization(IVisualizationContext<M> modelVisualizationContext, ActionContext actionContext) {
		        // This action will always be performed on an IOverviewVisualizationContext.
		        if (!(modelVisualizationContext instanceof IOverviewVisualizationContext)) {
		            throw new IllegalStateException("This action is performed on an element that is not inside an overview " +
		                "visualization!")
		        }
		        val ovc = (modelVisualizationContext as IOverviewVisualizationContext<M>)
		        
		        val collapsedElements = ovc.collapsedElements.clone
		        collapsedElements.forEach [
		            ovc.makeDetailed(it)
		        ]
		    }
		    
		}
		
		'''
	}
	
	/**
	 * Generates the content for a reveal action class.
	 * 
	 * @param data
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
	def static generateRevealAction(DataAccess data, View view, Connection connection, boolean isRequired) {
		val String requiringOrRequired = isRequired ? "Required" : "Requiring"
		val connectionName = connection.name
        val artifactFrom = isRequired ? connection.requiring  : connection.required
        val artifactTo   = isRequired ? connection.required : connection.requiring
        val artifactFromName = artifactFrom.name
        val artifactToName = artifactTo.name
		val className = "Reveal" + requiringOrRequired + connection.requiring.name + "Requires" + connection.required.name + "Named" + connection.name + "Action"
		val viewName = view.name
		// TODO: I think the view is irrelevant here, we could also just cast it to IOverviewVisualizationContext<?>
		// and name the variable accordingly, no need to specify which overview this is in.
		
		return '''
		package «data.getBundleNamePrefix».viz.actions
		
		import «data.getBundleNamePrefix».model.«viewName»OverviewContext
		import «data.getBundleNamePrefix».model.«artifactFromName»Context
		«IF artifactFromName != artifactToName»
			import «data.getBundleNamePrefix».model.«artifactToName»Context
		«ENDIF»
		import «data.getBundleNamePrefix».model.IVisualizationContext
		
		import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
		
		/**
		 * Expands the «requiringOrRequired.toFirstLower» «artifactToName.toFirstLower»s of any «artifactFromName.toFirstLower» and connects them with an edge from the new «artifactToName.toFirstLower»'s
		 * 'usedBy«artifactFromName»s' port to this «artifactFromName.toFirstLower»'s '«requiringOrRequired.toFirstLower»«artifactToName»' port. 
		 * If all «requiringOrRequired.toFirstLower» «artifactToName.toFirstLower»s are already shown, this action reverses its functionality and removes all «artifactToName.toFirstLower»s again.
		 * 
		 * @author nre
		 */
		class «className» extends AbstractVisualizationContextChangingAction {
			
			/**
			 * This action's ID.
			 */
			public static val String ID = «className».name
			
			override <M> changeVisualization(IVisualizationContext<M> modelVisualizationContext, ActionContext actionContext) {
				// The «artifactFromName»Context element for the element that was clicked on.
				val «artifactFromName.toFirstLower»Context = modelVisualizationContext as «artifactFromName»Context
				
				// The «artifactFromName.toFirstLower» itself from the context.
				val «artifactFromName.toFirstLower» = «artifactFromName.toFirstLower»Context.modelElement
				
				// The «viewName.toFirstLower» overview context this «artifactFromName.toFirstLower» is shown in.
				val «viewName.toFirstLower»OverviewContext = «artifactFromName.toFirstLower»Context.parent as «viewName»OverviewContext
				
				// The «requiringOrRequired.toFirstLower» «artifactToName.toFirstLower»s that are currently not yet in their detailed view need to be put in that state first.
				val collapsed«requiringOrRequired»«artifactToName»Contexts = «viewName.toFirstLower»OverviewContext.collapsedElements.filter [
					«artifactFromName.toFirstLower».«requiringOrRequired.toFirstLower + connectionName + artifactToName»s.contains(it.modelElement)
				].toList
				collapsed«requiringOrRequired»«artifactToName»Contexts.forEach [
					«viewName.toFirstLower»OverviewContext.makeDetailed(it)
				]
				
				// The «artifactToName.toFirstLower» contexts in the overview that the «connectionName.toFirstLower» connection can connect to.
				// Use the detailed «artifactToName.toFirstLower» contexts only, as they are all made detailed above.
				val «requiringOrRequired.toFirstLower»«artifactToName»Contexts = «viewName.toFirstLower»OverviewContext.detailedElements.filter [
					«artifactFromName.toFirstLower».«requiringOrRequired.toFirstLower + connectionName + artifactToName»s.contains(it.modelElement)
				].toList
				
«««				// If all are already connected, remove them all. Otherwise, connect them all.
«««		//		if (ContextUtils.allConnected(«artifactFrom.toFirstLower»Context, «requiringOrRequired.toFirstLower»«artifactTo»Contexts, «view.toFirstLower»OverviewContext, true)) {
«««		//			«requiringOrRequired.toFirstLower»«artifactTo»Contexts.forEach [ «requiringOrRequired.toFirstLower»«artifactTo»Context |
«««		//				ContextUtils.remove«connectionName»«artifactTo»Edge(«artifactFrom.toFirstLower»Context, «requiringOrRequired.toFirstLower»«artifactTo»Context as «artifactTo»Context)
«««		//			]
«««		//		} else {
				«requiringOrRequired.toFirstLower»«artifactToName»Contexts.forEach [ «requiringOrRequired.toFirstLower»«artifactToName»Context |
					«IF isRequired»
						«artifactFromName.toFirstLower»Context.add«connectionName»«artifactToName»Edge(«requiringOrRequired.toFirstLower»«artifactToName»Context as «artifactToName»Context)
					«ELSE»
						(«requiringOrRequired.toFirstLower»«artifactToName»Context as «artifactToName»Context).add«connectionName»«artifactFromName»Edge(«artifactFromName.toFirstLower»Context)
					«ENDIF»
				]
«««		//		}
			}
			
		}
		'''
	}
	
	/**
	 * Generates the content for the AbstractVisualizationContextChangingAction class.
	 * 
	 * @param data
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateAbstractVisualizationContextChangingAction (DataAccess data) {
		return '''
			package «data.getBundleNamePrefix».viz.actions
			
			import de.cau.cs.kieler.klighd.IAction
			import de.cau.cs.kieler.klighd.kgraph.util.KGraphUtil
			import «data.getBundleNamePrefix».viz.SynthesisProperties
			import «data.getBundleNamePrefix».model.IVisualizationContext
			import «data.getBundleNamePrefix».model.«data.visualizationName»
			import org.eclipse.core.runtime.Status
			import org.eclipse.emf.ecore.util.EcoreUtil.Copier
			import org.eclipse.ui.statushandlers.StatusManager
			
			import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
			
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
					val copiedVisualizationContext = copier.copy(currentVisualizationContext) as «data.visualizationName»
					copier.copyReferences
					
					// Remove this visualization context and all after that, a redo after an action is not possible anymore.
					while (visualizationContexts.size > index) {
						visualizationContexts.remove(index)
					}
					// Put the copy at the old index.
					visualizationContexts.add(index, copiedVisualizationContext)
					
					// The visualization context of the element that this action is performed on.
					val modelVisualizationContext = context.getDomainElement(context.KNode) as IVisualizationContext<?>
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
						
						StatusManager.getManager().handle(new Status(Status.ERROR, "«data.getBundleNamePrefix».viz",
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
	 * Generates the content for the ContextCollapseExpandAction class.
	 * 
	 * @param data
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateContextCollapseExpandAction (DataAccess data) {
		return '''
			package «data.getBundleNamePrefix».viz.actions
			
			import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
			import «data.getBundleNamePrefix».model.IVisualizationContext
			
			import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
			
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
	 * Generates the content for the OverviewContextCollapseExpandAction class.
	 * 
	 * @param spviz
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateOverviewContextCollapseExpandAction (DataAccess data) {
		return '''
			package «data.getBundleNamePrefix».viz.actions
			
			import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
			import «data.getBundleNamePrefix».model.IVisualizationContext
			
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
	 * Generates the content for the UndoAction class.
	 * 
	 * @param data
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateUndoAction (DataAccess data) {
		return '''
		package «data.getBundleNamePrefix».viz.actions
		
		import de.cau.cs.kieler.klighd.IAction
		import «data.getBundleNamePrefix».viz.SynthesisProperties
		
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
	 * Generates the content for the RedoAction class.
	 * 
	 * @param data
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateRedoAction (DataAccess data) {
		return '''
		package «data.getBundleNamePrefix».viz.actions
		
		import de.cau.cs.kieler.klighd.IAction
		import «data.getBundleNamePrefix».viz.SynthesisProperties
		
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
	 * Generates the content for the ResetViewAction class.
	 * 
	 * @param data
	 * 		a DataAccess to easily get the information from
	 * @return
	 * 		the generated file content as a string
	 */
	def static String generateResetViewAction (DataAccess data) {
		return '''
		package «data.getBundleNamePrefix».viz.actions
		
		import de.cau.cs.kieler.klighd.IAction
		import «data.getBundleNamePrefix».viz.SynthesisProperties
		
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
    
    /**
     * Generates the content for the ConnectAllAction class.
     * 
     * @param data
     *      a DataAccess to easily get the information from
     * @return
     *      the generated file content as a string
     */
    def static generateConnectAllAction(DataAccess data) {
        val Map<Artifact, List<String>> revealActions = new HashMap
        for (view : data.views) {
            for (shownConnection : view.shownConnections) {
                val connection = shownConnection.shownConnection
                // Reveal required actions
                var List<String> actionNames = revealActions.get(connection.requiring)
                if (actionNames === null) {
                    actionNames = new ArrayList
                    revealActions.put(connection.requiring, actionNames)
                }
                actionNames.add("RevealRequired"  + connection.requiring.name + "Requires" + connection.required.name + "Named" + connection.name + "Action")
                
                // Reveal requiring actions
                actionNames = revealActions.get(connection.required)
                if (actionNames === null) {
                    actionNames = new ArrayList
                    revealActions.put(connection.required, actionNames)
                }
                actionNames.add("RevealRequiring" + connection.requiring.name + "Requires" + connection.required.name + "Named" + connection.name + "Action")
            }
        }
        
        
        return '''
            package «data.getBundleNamePrefix».viz.actions
            
            import de.cau.cs.kieler.klighd.KlighdDataManager

            import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
            import «data.getBundleNamePrefix».model.IVisualizationContext
            «FOR artifact : revealActions.keySet»
                import «data.bundleNamePrefix».model.«artifact.name»Context
            «ENDFOR»
            
            import static extension «data.bundleNamePrefix».model.util.ContextExtensions.*
            
            /**
             * Calls the corresponding reveal*Actions for all elements visualized in this overview.
             * 
             * @author nre
             */
            class ConnectAllAction extends AbstractVisualizationContextChangingAction {
                
                /**
                 * This action's ID.
                 */
                public static val String ID = ConnectAllAction.name
                
                override <M> changeVisualization(IVisualizationContext<M> modelVisualizationContext, ActionContext actionContext) {
                    val kdm = KlighdDataManager.instance
                    «FOR actionNames : revealActions.values»
                        «FOR actionName : actionNames»
                            val «actionName.toFirstLower» = kdm.getActionById(«actionName».ID) as «actionName»
                        «ENDFOR»
                    «ENDFOR»
                    
                    if (!(modelVisualizationContext instanceof IOverviewVisualizationContext)) {
                        throw new IllegalStateException("The ConnectAllAction is only callable on IOverviewVisualizationContexts,"
                            + " but was called on a " + modelVisualizationContext.class)
                    }
                    val ovc = modelVisualizationContext as IOverviewVisualizationContext<?>
                    
                    // Expand all contexts that are not yet in their detailed form.
                    val collapsedContexts = ovc.collapsedElements.clone
                    collapsedContexts.forEach [ collapsed |
                        (ovc as IOverviewVisualizationContext<Object>).makeDetailed(collapsed as IVisualizationContext<Object>)
                    ]
                    
                    // For each child context, call actions on all their connections.
                    ovc.childContexts.clone.forEach [ childContext |
                        switch (childContext) {
                            «FOR artifact : revealActions.keySet»
                                «artifact.name»Context: {
                                    // Connect all artifacts that may connect to this one.
                                    «FOR actionName : revealActions.get(artifact)»
                                        «actionName.toFirstLower».changeVisualization(childContext, actionContext)
                                    «ENDFOR»
                                }
                            «ENDFOR»
                            default: {
                                throw new IllegalStateException("Unknown child context. " + childContext.class)
                            }
                        }
                    ]
                }
            }
            
        '''
    }
    
    /**
     * Generates the content for the SelectRelatedAction class.
     * 
     * @param data
     *      a DataAccess to easily get the information from
     * @return
     *      the generated file content as a string
     */
    def static generateSelectRelatedAction(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».viz.actions
            
            import de.cau.cs.kieler.klighd.IAction
            import de.cau.cs.kieler.klighd.kgraph.KEdge
            import de.cau.cs.kieler.klighd.kgraph.KLabel
            import de.cau.cs.kieler.klighd.kgraph.KNode
            import java.util.ArrayList
            import java.util.List
            import org.eclipse.emf.ecore.EObject
            import «data.bundleNamePrefix».model.IVisualizationContext
            
            /**
             * Selects all elements incident to the clicked element and elements representing the same model element.
             * 
             * @author nre
             */
            class SelectRelatedAction implements IAction {
                /**
                 * This action's ID.
                 */
                public static val String ID = SelectRelatedAction.name
                
                override execute(ActionContext context) {
                    val viewer = context.activeViewer
                    val elementsToSelect = new ArrayList<EObject>
                    val clickedElement = context.KGraphElement
                    elementsToSelect.add(clickedElement)
                    
                    // If the element is an edge, also select all incident nodes and labels.
                    switch clickedElement {
                        KEdge: {
                            elementsToSelect.add(clickedElement.source)
                            elementsToSelect.add(clickedElement.target)
                            elementsToSelect.addAll(clickedElement.labels)
                        }
                        KNode: {
                            // If the element is a node, also select all incident edges and their nodes.
                            clickedElement.outgoingEdges.forEach [
                                elementsToSelect.add(it)
                                elementsToSelect.add(it.target)
                            ]
                            clickedElement.incomingEdges.forEach [
                                elementsToSelect.add(it)
                                elementsToSelect.add(it.source)
                            ]
                            
                            // Also select all nodes representing the same element.
                            var clickedModelElement = context.getDomainElement(clickedElement)
                            if (clickedModelElement instanceof IVisualizationContext<?>) {
                                clickedModelElement = clickedModelElement.modelElement
                            }
                            
                            var rootKNode = clickedElement
                            while (rootKNode.parent !== null) {
                                rootKNode = rootKNode.parent
                            }
                            val sameDomainElements = new ArrayList<KNode>
                            sameDomainElement(rootKNode, clickedModelElement, sameDomainElements, context)
                            elementsToSelect.addAll(sameDomainElements)
                        }
                        KLabel: {
                            // If the element is an edge label, also select the edge.
                            if (clickedElement.parent instanceof KEdge) {
                                elementsToSelect.add(clickedElement.parent)
                            }
                        }
                    }
                    
                    viewer.resetSelectionToDiagramElements(elementsToSelect)
                    return ActionResult.createResult(false)
                }
                
                /**
                 * Recursively add all nodes representing the same domain element as the given one from the {@link KNode} into the
                 * given return list.
                 * 
                 * @param node The root of the node tree from where to start looking for equal domain elements.
                 * @param domainElement The domain model element to check against for equality.
                 * @param returnList A modifiable list in that all nodes with the same domain element are put in.
                 */
                private def void sameDomainElement(KNode node, Object domainElement, List<KNode> returnList,
                    ActionContext context) {
                    var nodeDomainElement = context.getDomainElement(node)
                    if (nodeDomainElement instanceof IVisualizationContext<?>) {
                       nodeDomainElement = nodeDomainElement.modelElement 
                    }
                    if (nodeDomainElement === domainElement) {
                        returnList.add(node)
                    }
                    for (childNode : node.children) {
                        sameDomainElement(childNode, domainElement, returnList, context)
                    }
                }
                
            }
        '''
    }
    
    /**
     * Generates the content for the ShowHideCollapsedAction class.
     * 
     * @param data
     *      a DataAccess to easily get the information from
     * @return
     *      the generated file content as a string
     */
    def static generateShowHideCollapsedAction(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».viz.actions
            
            import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
            import «data.getBundleNamePrefix».model.IVisualizationContext
            
            /**
             * An action that shows or hides collapsed elements in an {@link IOverviewVisualizationContext}.
             * 
             * @author nre
             */
            class ShowHideCollapsedAction extends AbstractVisualizationContextChangingAction {
                /**
                 * This action's ID.
                 */
                public static val String ID = ShowHideCollapsedAction.name
                
                override <M> changeVisualization(IVisualizationContext<M> modelVisualizationContext, ActionContext actionContext) {
                    if (!(modelVisualizationContext instanceof IOverviewVisualizationContext)) {
                        throw new IllegalStateException("This action is not performed on an overview visualization!")
                    }
                    val ovc = (modelVisualizationContext as IOverviewVisualizationContext<M>)
                    
                    ovc.showCollapsedElements = !ovc.showCollapsedElements
                }
                
            }
            
        '''
    }
    
    /**
     * Generates the content for the StoreModelAction class.
     * 
     * @param data
     *      a DataAccess to easily get the information from
     * @return
     *      the generated file content as a string
     */
    def static generateStoreModelAction(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».viz.actions
            
            import de.cau.cs.kieler.klighd.IAction
            import «data.getBundleNamePrefix».viz.FileHandler
            import «data.getBundleNamePrefix».model.IVisualizationContext
            
            /*
             * Persists the currently viewed {@link IVisualizationContext} and the model it belongs to to disk.
             * Uses the path relative to the execution of this model
             * "models/[projectName]-visualization-[yyyyMMddHHmmss].«data.spviz.name.toLowerCase»".
             * The .«data.spviz.name.toLowerCase» file can then be opened and viewed and will generate the exact view on the underlying .«data.spvizModel.name.toLowerCase» file as
             * visualized when saved.
             * Note that the .«data.spvizModel.name.toLowerCase» file needs to be located next to the .«data.spvizModel.name.toLowerCase» file when opening.
             * 
             * @author nre, ldi
             */
            class StoreModelAction implements IAction {
                
                
                /**
                 * This action's ID.
                 */
                public static val String ID = StoreModelAction.name
                
                override execute(ActionContext context) {
                    FileHandler.writeCurrentModelToFile(context.viewContext, false)
                    return ActionResult.createResult(false)
                }
            }
            
        '''
    }
    
}
