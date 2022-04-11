/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021-2022 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactView
import de.cau.cs.kieler.spviz.spviz.sPViz.SPViz
import de.cau.cs.kieler.spviz.spviz.sPViz.View
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtend.lib.annotations.Accessors

import static extension de.cau.cs.kieler.spviz.spvizmodel.util.SPVizModelExtension.*

/**
 * Simplifies access to the data in a SPViz representation.
 * 
 * @author leo, nre
 */
class DataAccess {
    
    /** Direct access to the spviz visualization. Contains all the views. */
    @Accessors(PUBLIC_GETTER)
    SPViz spviz
    /** Direct access to the required spvizmodel. Contains all the artifacts. */
    @Accessors(PUBLIC_GETTER)
    SPVizModel spvizModel
    
    /** The bundle and package prefix for the generated visualization bundles. */
    @Accessors(PUBLIC_GETTER)
    String bundleNamePrefix
    /** The imported model bundle and package prefix of the required {@link SPVizModel}. */
    @Accessors(PUBLIC_GETTER)
    String modelBundleNamePrefix
    /** The name of the visualization */
    @Accessors(PUBLIC_GETTER)
    String visualizationName
    /** The name of the root object of the required {@link SPVizModel} instance, usually its name + 'Project' */
    @Accessors(PUBLIC_GETTER)
    String projectName
    /** 
     * A convenient map to show all {@link Connection}s with the key of the map as the connecting {@link Artifact}.
     */
    Map<Artifact, List<Connection>> connectedArtifacts
    /**
     * A convenient map to show all {@link Connection}s with the key of the map as the connected {@link Artifact}.
     */
    Map<Artifact, List<Connection>> connectingArtifacts
    /** A convenient map to show all {@link ArtifactView}s that may be shown within the key {@link Artifact}. */
    Map<Artifact, List<ArtifactView>> containedViews
    /** A convenient map to show all {@link Artifact}s that show the key {@link View}. */
    Map<View, List<Artifact>> artifactsShowing
    
    /**
     * Constructor
     * 
     * @param resource
     *         The resource for the {@link SPViz} model loaded in the editor.
     */
    new(Resource resource) {
        spviz = resource.contents.head as SPViz
        bundleNamePrefix = spviz.package
        
        spvizModel = resource.resourceSet.resources.findFirst[
            it.contents.head instanceof SPVizModel && it.URI.toString.endsWith(spviz.importURI)
        ]?.contents?.head as SPVizModel
        if (spvizModel === null) {
            println("No SPVizModel found to import with the name " + spviz.importURI)
        }
        modelBundleNamePrefix = spvizModel.package
        visualizationName = spviz.name
        projectName = spvizModel.name + "Project"
        connectedArtifacts = newHashMap
        connectingArtifacts = newHashMap
        containedViews = newHashMap
        artifactsShowing = newHashMap
        
        for (view : spviz.views) {
            // find all connections between artifacts
            for (shownConnection : view.shownConnections) {
                val connection = shownConnection.shownConnection
                val connecting = connection.connecting
                val connected = connection.connected

                if (!connectedArtifacts.containsKey(connecting)) {
                    connectedArtifacts.put(connecting, newArrayList)
                }
                connectedArtifacts.get(connecting).add(connection)
                
                if (!connectingArtifacts.containsKey(connected)) {
                    connectingArtifacts.put(connected, newArrayList)
                }
                connectingArtifacts.get(connected).add(connection)
            }
        }
        
        for (artifact : spvizModel.artifacts) {
            val artifactShows = spviz.artifactShows.findFirst[it.artifactShows === artifact]
            if (artifactShows !== null) {
                containedViews.put(artifact, artifactShows.views)
            }
        }
        
        for (artifactShows : spviz.artifactShows) {
            val artifact = artifactShows.artifactShows
            for (view : artifactShows.views) {
                var theArtifactsShowing = artifactsShowing.get(view.view)
                if (theArtifactsShowing === null) {
                    theArtifactsShowing = newArrayList
                    artifactsShowing.put(view.view, theArtifactsShowing)
                }
                theArtifactsShowing.add(artifact)
            }
        }
    }
    
    /** 
     * All views displayable in this SPViz.
     * 
     * @return The views
     */
    def List<View> getViews() {
        return this.spviz.views
    }
    
    /** 
     * All artifacts displayable in this SPViz.
     * 
     * @return all artifact names as a string array
     */
    def List<Artifact> getArtifacts() {
        return this.spvizModel.artifacts
    }
    
    /** 
     * Returns all connections with the connected artifacts for a given connecting artifact. 
     * 
     * @param connecting
     *         the artifact which connects other artifacts
     * @return
     *         List of the connections
     */
    def List<Connection> getConnectedArtifacts(Artifact connecting) { 
        if (!connectedArtifacts.containsKey(connecting)) {
            return newArrayList
        }
        return connectedArtifacts.get(connecting)
    }
    
    /** 
     * Returns all connections with the connecting artifacts for a given connected artifact. 
     * 
     * @param connected
     *         the artifact which is connected by other artifacts
     * @return
     *         List of the connections
     */
    def List<Connection>getConnectingArtifacts(Artifact connected) {
        if (!connectingArtifacts.containsKey(connected)) {
            return newArrayList
        }
        return connectingArtifacts.get(connected)
    }
    
    /** 
     * Returns all connections with the connected artifacts for a given connecting artifact, if displayed in the view.
     * 
     * @param connecting
     *         the artifact which connects other artifacts
     * @param view
     *      the view showing this connection
     * @return
     *         List of the connections.
     */
    def List<Connection> getConnectedArtifactsInOverview(Artifact connecting, View view) {
        val List<Connection> connections = newArrayList
        for (connectedConnection : connectedArtifacts.get(connecting) ?: #[]) {
            if (isConnectionDisplayedInOverview(connectedConnection, view)) {
                connections.add(connectedConnection)
            }
        }
        return connections
    }
    
    /** 
     * Returns all connections with the connecting artifacts for a given connected artifact, if displayed in the view.
     * 
     * @param connected
     *         the artifact which is connected by other artifacts
     * @param view
     *      the view showing this connection
     * @return
     *         List of the connections.
     */
    def List<Connection> getConnectingArtifactsInOverview(Artifact connected, View view) {
        val List<Connection> connections = newArrayList
        for (connectingConnection : connectingArtifacts.get(connected) ?: #[]) {
            if (isConnectionDisplayedInOverview(connectingConnection, view)) {
                connections.add(connectingConnection)
            }
        }
        return connections
    }
    
    /** 
     * For a given artifact, finds the overviews, it can be contained in.
     * 
     * @param artifact
     *         The artifact to find all possible views for.
     * @return
     *         A list of all views that may contain the artifact.
     */
    def List<View> getContainingViews(Artifact artifact) {
        val possibleViews = newArrayList
        for (view : views) {
            for (shownElement : view.shownElements) {
                if (shownElement.shownElement === artifact) {
                    possibleViews.add(view)
                }
            }
        }
        return possibleViews 
    }
    
    /**
     * For a given artifact, finds the overviews that may be shown in this artifact.
     * 
     * @param artifact
     *      The artifact that may contain further overviews.
     * @return
     *      A list of all views with their source configuration that may be contained in this artifact.
     */
    def List<ArtifactView> getContainedViews(Artifact artifact) {
        return containedViews.get(artifact) ?: #[]
    }

    /**
     * Determines if the given connection is shown in the provided view.
     * 
     * @param connection The connection to check for containment
     * @param view The view to check if the connection is part of it.
     * @return if this connection is in the view.
     */
    def boolean isConnectionDisplayedInOverview(Connection connection, View view) {
        for (overviewConnection : view.shownConnections) {
            if (overviewConnection.shownConnection === connection) {
                return true
            }
        }
        return false
    }
    
    /**
     * Returns which artifacts show the given overview.
     * 
     * @param view The view that is shown in all returned artifacts.
     * @return The artifacts showing the view. 
     */
    def List<Artifact> getArtifactsShowing(View view) {
        return artifactsShowing.get(view) ?: #[]
    }
    
}