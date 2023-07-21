/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021-2023 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.generator

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
        content = generateFocusAction(data)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "FocusAction.xtend", content, progressMonitor)
        content = generateDefocusAction(data)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "DefocusAction.xtend", content, progressMonitor)
        content = generateSelectRelatedAction(data)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "SelectRelatedAction.xtend", content, progressMonitor)
        content = generateShowHideCollapsedAction(data)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "ShowHideCollapsedAction.xtend", content, progressMonitor)
        content = generateStoreModelAction(data)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "StoreModelAction.xtend", content, progressMonitor)
        
        content = generateRecursiveRevealAction(data)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "RecursiveRevealAction.xtend", content, progressMonitor)
        content = generateRevealAction(data)
        FileGenerator.generateOrUpdateFile(sourceFolder, folder + "RevealAction.xtend", content, progressMonitor)
        
        for (connection : data.connections) {
            val actionNameInfix = connection.connecting.name + "Connects" + connection.connected.name + "Named" + connection.name
            // reveal connected artifacts
            content = generateRevealAction(data, connection, true)
            FileGenerator.generateOrUpdateFile(sourceFolder,
                folder + "RevealConnected" + actionNameInfix + "Action.xtend", content, progressMonitor)
            // remove connected artifacts
            content = generateRemoveAction(data, connection, true)
            FileGenerator.generateOrUpdateFile(sourceFolder,
                folder + "RemoveConnected" + actionNameInfix + "Action.xtend", content, progressMonitor)
            // reveal connecting artifacts
            content = generateRevealAction(data, connection, false)
            FileGenerator.generateOrUpdateFile(sourceFolder,
                folder + "RevealConnecting" + actionNameInfix + "Action.xtend", content, progressMonitor)
            // remove connecting artifacts
            content = generateRemoveAction(data, connection, false)
            FileGenerator.generateOrUpdateFile(sourceFolder,
                folder + "RemoveConnecting" + actionNameInfix + "Action.xtend", content, progressMonitor)
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
            
            override changeVisualization(IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext) {
                // This action will always be performed on an IOverviewVisualizationContext.
                if (!(modelVisualizationContext instanceof IOverviewVisualizationContext)) {
                    throw new IllegalStateException("This action is performed on an element that is not inside an overview " +
                        "visualization!")
                }
                val ovc = (modelVisualizationContext as IOverviewVisualizationContext<?>)
                
                val collapsedElements = ovc.collapsedElements.clone
                collapsedElements.forEach [
                    ovc.makeDetailed(it)
                ]
            }
            
        }
        
        '''
    }
    
    /**
     * Generates the content for the RecursiveRevealAction.
     */
    def static generateRecursiveRevealAction(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».viz.actions
            
            import de.cau.cs.kieler.klighd.KlighdDataManager
            import java.util.HashSet
            import java.util.LinkedList
            import java.util.Queue
            import java.util.Set
            import «data.getBundleNamePrefix».model.IVisualizationContext
            
            /**
             * Recursive version of a reveal action, revealing all elements using the same connection type connected.
             * 
             * @param <C> The visualization context's class to click on and recursively reveal.
             * @param <R> The reveal action revealing all connections for a single source context, called recursively by this.
             */
            abstract class RecursiveRevealAction<C extends IVisualizationContext<?>, R extends RevealAction<C>> extends AbstractVisualizationContextChangingAction {
                
                override changeVisualization(IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext) {
                    val revealAction = KlighdDataManager.instance.getActionById(revealActionClass.name) as R
                    
                    // Go through all visualization contexts via BFS to execute the reveal action on.
                    // Queue containing all revealed contexts for that the action has not been executed yet.
                    val Queue<C> toVisit = new LinkedList
                    // All contexts already visited that should not be pushed into the queue anymore.
                    val Set<C> visited = new HashSet
                    toVisit.add(modelVisualizationContext as C)
                    // 'visit' the start context as we start with that directly. 
                    visited.add(modelVisualizationContext as C)
                    
                    while (!toVisit.empty) {
                        val current = toVisit.remove
                        revealAction.changeVisualization(current, actionContext)
                        
                        // Fetch the newly connected bundles from the action.
                        val newlyConnected = revealAction.newlyConnectedContextsOfSameType
                        
                        // Add the not yet visited contexts to our queue and visited set for the next iteration.
                        for (n : newlyConnected) {
                            if (!visited.contains(n)) {
                                toVisit.add(n)
                                visited.add(n)
                            }
                        }
                    }
                }
                
                /**
                 * The reveal action that this action calls recursively. Duplicate of the type parameter, as Java cannot directly
                 * read that during runtime.
                 */
                abstract def Class<R> revealActionClass()
                
            }
            
        '''
    }
    
    /**
     * Generates the content for the RevealAction
     */
    def static generateRevealAction(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».viz.actions
            
            import java.util.List
            import «data.getBundleNamePrefix».model.IVisualizationContext
            
            /**
             * Abstract action to reveal and connect any new contexts. Requires an extending action to write a new list to the
             * {@link #newlyConnectedContexts} field with all contexts that got connected during its implementation of the
             * {@link #changeVisualization} method.
             * 
             * @author nre
             */
            abstract class RevealAction<C extends IVisualizationContext<?>> extends AbstractVisualizationContextChangingAction {
                
                /**
                 * All contexts that get connected. Only valid immediately after calling {@link #changeVisualization} on this action.
                 */
                protected List<? extends IVisualizationContext<?>> newlyConnectedContexts
                
                /**
                 * The context this reveal action can be applied to. Duplicate of the type parameter, as Java cannot directly
                 * read that during runtime.
                 */
                abstract def Class<C> applicableContext()
                
                /**
                 * All contexts of the same type this action is defined for that get connected. Only valid immediately after calling
                 * #changeVisualization on this action.
                 */
                def Iterable<C> newlyConnectedContextsOfSameType() {
                    return newlyConnectedContexts.filter(applicableContext)
                }
                
            }
            
        '''
    }
    
    
    /**
     * Generates the content for a reveal action class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @param connection
     *         the connection to reveal
     * @param isConnected
     *         boolean which defines the direction of the connection
     * @return
     *         the generated file content as a string
     */
    def static generateRevealAction(DataAccess data, Connection connection, boolean isConnected) {
        val String connectingOrConnected = isConnected ? "Connected" : "Connecting"
        val connectionName = connection.name
        val artifactFrom = isConnected ? connection.connecting  : connection.connected
        val artifactTo   = isConnected ? connection.connected : connection.connecting
        val artifactFromName = artifactFrom.name
        val artifactToName = artifactTo.name
        val className = "Reveal" + connectingOrConnected + connection.connecting.name + "Connects" + connection.connected.name + "Named" + connection.name + "Action"
        
        return '''
            package «data.getBundleNamePrefix».viz.actions
            
            import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
            import «data.getBundleNamePrefix».model.«artifactFromName»Context
            «IF artifactFromName != artifactToName»
                import «data.getBundleNamePrefix».model.«artifactToName»Context
            «ENDIF»
            import «data.getBundleNamePrefix».model.IVisualizationContext
            
            import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
            
            /**
             * Expands the «connectingOrConnected.toFirstLower» «artifactToName.toFirstLower»s of any «artifactFromName.toFirstLower» and connects them with an edge from the new «artifactToName.toFirstLower»'s
             * 'usedBy«artifactFromName»s' port to this «artifactFromName.toFirstLower»'s '«connectingOrConnected.toFirstLower»«artifactToName»' port.
             * 
             * @author nre
             */
            class «className» extends RevealAction<«artifactFromName»Context> {
                
                /**
                 * This action's ID.
                 */
                public static val String ID = «className».name
                
                override changeVisualization(IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext) {
                    // The «artifactFromName»Context element for the element that was clicked on.
                    val «artifactFromName.toFirstLower»Context = modelVisualizationContext as «artifactFromName»Context
                    
                    // The «artifactFromName.toFirstLower» itself from the context.
                    val «artifactFromName.toFirstLower» = «artifactFromName.toFirstLower»Context.modelElement
                    
                    // The overview context this «artifactFromName.toFirstLower» is shown in.
                    val overviewContext = «artifactFromName.toFirstLower»Context.parent as IOverviewVisualizationContext<?>
                    
                    // The «connectingOrConnected.toFirstLower» «artifactToName.toFirstLower»s that are currently not yet in their detailed view need to be put in that state first.
                    val collapsed«connectingOrConnected»«artifactToName»Contexts = overviewContext.collapsedElements.filter [
                        «artifactFromName.toFirstLower».«connectingOrConnected.toFirstLower + connectionName + artifactToName»s.contains(it.modelElement)
                    ].toList
                    collapsed«connectingOrConnected»«artifactToName»Contexts.forEach [
                        overviewContext.makeDetailed(it)
                    ]
                    
                    // The «artifactToName.toFirstLower» contexts in the overview that the «connectionName.toFirstLower» connection can connect to.
                    // Use the detailed «artifactToName.toFirstLower» contexts only, as they are all made detailed above.
                    newlyConnectedContexts = overviewContext.detailedElements.filter [
                        «artifactFromName.toFirstLower».«connectingOrConnected.toFirstLower + connectionName + artifactToName»s.contains(it.modelElement)
                    ].toList
                    
                    newlyConnectedContexts.forEach [ «connectingOrConnected.toFirstLower»«artifactToName»Context |
                        «IF isConnected»
                            «artifactFromName.toFirstLower»Context.add«connectionName»«artifactToName»Edge(«connectingOrConnected.toFirstLower»«artifactToName»Context as «artifactToName»Context)
                        «ELSE»
                            («connectingOrConnected.toFirstLower»«artifactToName»Context as «artifactToName»Context).add«connectionName»«artifactFromName»Edge(«artifactFromName.toFirstLower»Context)
                        «ENDIF»
                    ]
                }
                    
                override applicableContext() {
                    return «artifactFromName»Context
                }
                
                /**
                 * Recursive version of the parent class's action, revealing all elements using the same connection type connected.
                 */
                static class Recursive extends RecursiveRevealAction<«artifactFromName»Context, «className»> {
                    
                    /**
                     * This action's ID.
                     */
                    public static val String ID = Recursive.name
                    
                    override revealActionClass() {
                        return «className»
                    }
                    
                }
                
            }
            
        '''
    }
    
    /**
     * Generates the content for a remove action class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @param connection
     *         the connection to remove
     * @param isConnected
     *         boolean which defines the direction of the connection
     * @return
     *         the generated file content as a string
     */
    def static generateRemoveAction(DataAccess data, Connection connection, boolean isConnected) {
        val String connectingOrConnected = isConnected ? "Connected" : "Connecting"
        val connectionName = connection.name
        val artifactFrom = isConnected ? connection.connecting  : connection.connected
        val artifactTo   = isConnected ? connection.connected : connection.connecting
        val artifactFromName = artifactFrom.name
        val artifactToName = artifactTo.name
        val className = "Remove" + connectingOrConnected + connection.connecting.name + "Connects" + connection.connected.name + "Named" + connection.name + "Action"
        
        return '''
            package «data.getBundleNamePrefix».viz.actions
            
            import java.util.List
            
            import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
            import «data.getBundleNamePrefix».model.«artifactFromName»Context
            «IF artifactFromName != artifactToName»
                import «data.getBundleNamePrefix».model.«artifactToName»Context
            «ENDIF»
            import «data.getBundleNamePrefix».model.IVisualizationContext
            
            import static extension «data.getBundleNamePrefix».model.util.ContextExtensions.*
            
            /**
             * Disconnects the «connectingOrConnected.toFirstLower» «artifactToName.toFirstLower»s of any «artifactFromName.toFirstLower» and collapses them if they are not
             * connected to anything anymore.
             * 
             * @author nre
             */
            class «className» extends AbstractVisualizationContextChangingAction {
                
                /**
                 * This action's ID.
                 */
                public static val String ID = «className».name
                
                override changeVisualization(IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext) {
                        // The «artifactFromName»Context element for the element that was clicked on.
                        val «artifactFromName.toFirstLower»Context = modelVisualizationContext as «artifactFromName»Context
                        
                        // The «artifactFromName.toFirstLower» itself from the context.
                        val «artifactFromName.toFirstLower» = «artifactFromName.toFirstLower»Context.modelElement
                        
                        // The overview context this «artifactFromName.toFirstLower» is shown in.
                        val overviewContext = «artifactFromName.toFirstLower»Context.parent as IOverviewVisualizationContext<?>
                        
                        // The «connectingOrConnected.toFirstLower» «artifactToName.toFirstLower»s that are currently in their detailed view.
                        val detailed«connectingOrConnected»«artifactToName»Contexts = overviewContext.detailedElements.filter [
                            «artifactFromName.toFirstLower».«connectingOrConnected.toFirstLower + connectionName + artifactToName»s.contains(it.modelElement)
                        ].toList as List<«artifactToName»Context>
                        detailed«connectingOrConnected»«artifactToName»Contexts.forEach [
                            «IF isConnected»
                                «artifactFromName.toFirstLower»Context.remove«connectionName»«artifactToName»Edge(it)
                            «ELSE»
                                it.remove«connectionName»«artifactFromName»Edge(«artifactFromName.toFirstLower»Context)
                            «ENDIF»
                            if (overviewContext.hasNoConnections(it)) {
                                overviewContext.collapse(it)
                            }
                        ]
                    }
                
            }
            
        '''
    }
    
    /**
     * Generates the content for the AbstractVisualizationContextChangingAction class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return
     *         the generated file content as a string
     */
    def static String generateAbstractVisualizationContextChangingAction (DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».viz.actions
            
            import de.cau.cs.kieler.klighd.IAction
            import de.cau.cs.kieler.klighd.kgraph.util.KGraphUtil
            import de.cau.cs.kieler.klighd.Klighd
            import «data.getBundleNamePrefix».viz.SynthesisProperties
            import «data.getBundleNamePrefix».model.IVisualizationContext
            import «data.getBundleNamePrefix».model.«data.visualizationName»
            import org.eclipse.core.runtime.Status
            import org.eclipse.emf.ecore.util.EcoreUtil.Copier
            
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
                        val errorStatus = new Status(Status.ERROR, "«data.getBundleNamePrefix».viz",
                            "Something went wrong while executing the " + this.class.canonicalName + " action.\n" + 
                            "Please view the error log and send the stack trace and the way to " +
                            "reproduce this error to the developer.", e)
                        Klighd.show(errorStatus)
                        Klighd.log(errorStatus)
                        return getActionResult(context)
                    }
                }
                
                /**
                 * Modifies the visualization context towards a state that represents what this action should perform.
                 * 
                 * @param modelVisualizationContext The visualization context of the element that this action is performed on.
                 */
                abstract def void changeVisualization(
                    IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext)
                
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
     *         a DataAccess to easily get the information from
     * @return
     *         the generated file content as a string
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
                
                override changeVisualization(IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext) {
                    // This action will always be performed on a child visualization context of a IOverviewVisualizationContext.
                    val overviewVisContext = modelVisualizationContext.parent
                    if (!(overviewVisContext instanceof IOverviewVisualizationContext)) {
                        throw new IllegalStateException("This action is performed on an element that is not inside an overview " +
                            "visualization!")
                    }
                    val ovc = (overviewVisContext as IOverviewVisualizationContext<?>)
                    
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
     *         a DataAccess to easily get the information from
     * @return
     *         the generated file content as a string
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
                
                override changeVisualization(IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext) {
                    if (!(modelVisualizationContext instanceof IOverviewVisualizationContext)) {
                        throw new IllegalArgumentException("This action can only be called on a IOverviewVisualizationContext. "
                            + "Was called on " + modelVisualizationContext.class)
                    }
                    // Just invert the expanded state.
                    val c = modelVisualizationContext as IOverviewVisualizationContext<?>
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
     *         a DataAccess to easily get the information from
     * @return
     *         the generated file content as a string
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
     *         a DataAccess to easily get the information from
     * @return
     *         the generated file content as a string
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
     *         a DataAccess to easily get the information from
     * @return
     *         the generated file content as a string
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
        // Map for each artifact to the connections and the names of the reveal actions that they support.
        val Map<Artifact, List<Pair<Connection, String>>> revealActions = new HashMap
        for (connection : data.connections) {
            // Reveal connected actions
            var List<Pair<Connection, String>> connectionActions = revealActions.get(connection.connecting)
            if (connectionActions === null) {
                connectionActions = new ArrayList
                revealActions.put(connection.connecting, connectionActions)
            }
            connectionActions.add(Pair.of(connection, "RevealConnected"  + connection.connecting.name + "Connects" + connection.connected.name + "Named" + connection.name + "Action"))
            
            // Reveal connecting actions
            connectionActions = revealActions.get(connection.connected)
            if (connectionActions === null) {
                connectionActions = new ArrayList
                revealActions.put(connection.connected, connectionActions)
            }
            connectionActions.add(Pair.of(connection, "RevealConnecting" + connection.connecting.name + "Connects" + connection.connected.name + "Named" + connection.name + "Action"))
        }
        
        
        return '''
            package «data.getBundleNamePrefix».viz.actions
            
            import de.cau.cs.kieler.klighd.KlighdDataManager

            import «data.getBundleNamePrefix».model.IOverviewVisualizationContext
            import «data.getBundleNamePrefix».model.IVisualizationContext
            «FOR artifact : revealActions.keySet»
                import «data.bundleNamePrefix».model.«artifact.name»Context
            «ENDFOR»
            import «data.getBundleNamePrefix».viz.SynthesisUtils
            
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
                
                override changeVisualization(IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext) {
                    val kdm = KlighdDataManager.instance
                    «FOR connectionActions : revealActions.values»
                        «FOR connectionAction : connectionActions»
                            val «connectionAction.value.toFirstLower» = kdm.getActionById(«connectionAction.value».ID) as «connectionAction.value»
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
                                    «FOR connectionAction : revealActions.get(artifact)»
                                        // Only try to connect using this connection type if the parent overview context supports it.
                                        if (SynthesisUtils.overviewContainsConnection(ovc, "«connectionAction.key.name»")) {
                                            «connectionAction.value.toFirstLower».changeVisualization(childContext, actionContext)
                                        }
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
     * Generates the content for the FocusAction class.
     * 
     * @param data
     *      the DataAccess to easily get the information from.
     * @return
     *      the generated file content as a String.
     */
    def static generateFocusAction(DataAccess data) {
        return '''
            package «data.bundleNamePrefix».viz.actions
            
            import «data.bundleNamePrefix».model.IVisualizationContext
            
            import static extension «data.bundleNamePrefix».model.util.ContextExtensions.*
            
            /**
             * Focuses the element this action is issued on by setting the 'focus' attribute on the root visualization.
             * 
             * @author nre
             */
            class FocusAction extends AbstractVisualizationContextChangingAction {
                /**
                 * This action's ID.
                 */
                public static val String ID = FocusAction.name
                
                override changeVisualization(IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext) {
                    val rootVisualization = modelVisualizationContext.rootVisualization
                    rootVisualization.focus = modelVisualizationContext
                }
                
                override protected ActionResult getActionResult(ActionContext context) {
                    return super.getActionResult(context).doZoomToFit
                }
                
            }
            
        '''
    }
    
    /**
     * Generates the content for the DefocusAction class.
     * 
     * @param data
     *      the DataAccess to easily get the information from.
     * @return
     *      the generated file content as a String.
     */
    def static generateDefocusAction(DataAccess data) {
        return '''
            package «data.bundleNamePrefix».viz.actions
            
            import «data.bundleNamePrefix».model.IVisualizationContext
            
            import static extension «data.bundleNamePrefix».model.util.ContextExtensions.*
            
            /**
             * Defocuses the element this action is issued on by unsetting the 'focus' attribute on the root visualization.
             * 
             * @author nre
             */
            class DefocusAction extends AbstractVisualizationContextChangingAction {
                /**
                 * This action's ID.
                 */
                public static val String ID = DefocusAction.name
                
                override changeVisualization(IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext) {
                    val rootVisualization = modelVisualizationContext.rootVisualization
                    if (!(rootVisualization.focus === modelVisualizationContext)) {
                        throw new IllegalStateException("Defocus called on an overview that was not focused!")
                    }
                    rootVisualization.focus = null
                }
                
                override protected ActionResult getActionResult(ActionContext context) {
                    return super.getActionResult(context).doZoomToFit
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
                
                override changeVisualization(IVisualizationContext<?> modelVisualizationContext, ActionContext actionContext) {
                    if (!(modelVisualizationContext instanceof IOverviewVisualizationContext)) {
                        throw new IllegalStateException("This action is not performed on an overview visualization!")
                    }
                    val ovc = (modelVisualizationContext as IOverviewVisualizationContext<?>)
                    
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
