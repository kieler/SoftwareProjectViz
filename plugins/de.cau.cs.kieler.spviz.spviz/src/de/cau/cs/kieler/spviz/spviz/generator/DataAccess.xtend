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
	 * A convenient map to show all {@link Connection}s with the key of the map as the requiring {@link Artifact}.
	 */
	Map<Artifact, List<Connection>> requiredArtifacts
    /**
     * A convenient map to show all {@link Connection}s with the key of the map as the required {@link Artifact}.
     */
	Map<Artifact, List<Connection>> requiringArtifacts
	
	/**
	 * Constructor
	 * 
	 * @param resource
	 * 		The resource for the {@link SPViz} model loaded in the editor.
	 */
	new(Resource resource) {
	    spviz = resource.contents.head as SPViz
        bundleNamePrefix = spviz.package
        
        spvizModel = resource.resourceSet.resources.findFirst[
            it.contents.head instanceof SPVizModel
        ]?.contents?.head as SPVizModel
        if (spvizModel === null) {
            println("No SPVizModel found to import with the name " + spviz.importURI)
        }
        modelBundleNamePrefix = spvizModel.package
        visualizationName = spviz.name
		projectName = spvizModel.name + "Project"
		requiredArtifacts = newHashMap
		requiringArtifacts = newHashMap
		
		for (view : spviz.views) {
            // find all connections between artifacts
            for (shownConnection : view.shownConnections) {
                val connection = shownConnection.shownConnection
                val requiring = connection.requiring
                val required = connection.required

                if (!requiredArtifacts.containsKey(requiring)) {
                    requiredArtifacts.put(requiring, newArrayList)
                }
                requiredArtifacts.get(requiring).add(connection)
                
                if (!requiringArtifacts.containsKey(required)) {
                    requiringArtifacts.put(required, newArrayList)
                }
                requiringArtifacts.get(required).add(connection)
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
	 * Returns all connections with the required artifacts for a given requiring artifact. 
	 * 
	 * @param requiring
	 * 		the artifact which requires other artifacts
	 * @return
	 * 		List of the connections
	 */
	def List<Connection> getRequiredArtifacts(Artifact requiring) { 
		if (!requiredArtifacts.containsKey(requiring)) {
			return newArrayList
		}
		return requiredArtifacts.get(requiring)
	}
	
	/** 
	 * Returns all connections with the requiring artifacts for a given required artifact. 
	 * 
	 * @param required
	 * 		the artifact which is required by other artifacts
	 * @return
	 * 		List of the connections
	 */
	def List<Connection>getRequiringArtifacts(Artifact required) {
		if (!requiringArtifacts.containsKey(required)) {
			return newArrayList
		}
		return requiringArtifacts.get(required)
	}
	
	/** 
	 * Returns all connections with the required artifacts for a given requiring artifact, if displayed in the view.
	 * 
	 * @param requiring
	 * 		the artifact which requires other artifacts
	 * @param view
	 *      the view showing this connection
	 * @return
	 * 		List of the connections.
	 */
	def List<Connection> getRequiredArtifactsInOverview(Artifact requiring, View view) {
		val List<Connection> connections = newArrayList
		for (requiredConnection : requiredArtifacts.get(requiring) ?: #[]) {
			if (isConnectionDisplayedInOverview(requiredConnection, view)) {
				connections.add(requiredConnection)
			}
		}
		return connections
	}
	
	/** 
     * Returns all connections with the requiring artifacts for a given required artifact, if displayed in the view.
	 * 
	 * @param required
	 * 		the artifact which is required by other artifacts
     * @param view
     *      the view showing this connection
	 * @return
	 * 		List of the connections.
	 */
	def List<Connection> getRequiringArtifactsInOverview(Artifact required, View view) {
        val List<Connection> connections = newArrayList
        for (requiringConnection : requiringArtifacts.get(required ?: #[])) {
            if (isConnectionDisplayedInOverview(requiringConnection, view)) {
                connections.add(requiringConnection)
            }
        }
        return connections
    }
	
	/** 
	 * For a given artifact, finds the overviews, it can be contained in.
	 * 
	 * @param artifact
	 * 		The artifact to find all possible views for.
	 * @return
	 * 		A list of all views that may contain the artifact.
	 */
    def List<View> getViews(Artifact artifact) {
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
	
}