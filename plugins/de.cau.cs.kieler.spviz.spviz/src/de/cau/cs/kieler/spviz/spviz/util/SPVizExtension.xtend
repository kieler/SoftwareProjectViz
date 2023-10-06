/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 * 
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2023 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 */
package de.cau.cs.kieler.spviz.spviz.util

import de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactChain
import de.cau.cs.kieler.spviz.spviz.sPViz.ShownCategoryConnection
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact
import java.util.List

import static extension de.cau.cs.kieler.spviz.spvizmodel.util.SPVizModelExtension.*

/** 
 * Utility extension class for usability of the SPViz classes.
 * 
 * @author nre
 */
class SPVizExtension {
    
    /**
     * Returns the connected category artifact of a category connection.
     * 
     * @param connection The connection
     * @return the connected category artifact.
     */
    static def Artifact getConnectedCategory(ShownCategoryConnection connection) {
        return connection.sourceChain.source
    }
    
    /**
     * Returns the connecting category artifact of a category connection.
     * 
     * @param connection The connection
     * @return the connecting category artifact.
     */
    static def Artifact getConnectingCategory(ShownCategoryConnection connection) {
        return connection.sourceChain.source
    }
    
    /**
     * Returns the connected artifact of a category connection.
     * 
     * @param connection The connection
     * @return the connected artifact.
     */
    static def Artifact getConnectedArtifact(ShownCategoryConnection connection) {
        return connection.connection.connected
    }
    
    /**
     * Returns the connecting artifact of a category connection.
     * 
     * @param connection The connection
     * @return the connecting artifact.
     */
    static def Artifact getConnectingArtifact(ShownCategoryConnection connection) {
        return connection.connection.connecting
    }
    
    /**
     * The target artifact (i.e. the last artifact in the chain) of this artifact chain.
     * 
     * @param the artifact chain to find the last artifact in.
     * @return the target artifact or the last artifact of this chain.
     */
    static def Artifact target(ArtifactChain chain) {
        var current = chain
        var Artifact artifact = null
        while (current !== null) {
            artifact = current.source
            current = current.further
        }
        return artifact
    }
    
    /**
     * Filters the category connections by uniqueness. Category connections with a different container, but equal
     * connection, inner view etc. are seen as equal. 
     * 
     * @param unfiltered a list of the unfiltered and possibly non-unique category connections.
     * @return a new, filtered list.
     */
    static def List<ShownCategoryConnection> uniqueCategoryConnections(List<ShownCategoryConnection> unfiltered) {
        val List<ShownCategoryConnection> filtered = newArrayList
        for (categoryConnection : unfiltered) {
            if (!filtered.exists[equals(it, categoryConnection)]) {
                filtered.add(categoryConnection)
            }
        }
        return filtered
    }
    
    /**
     * Default equals method for category connections.
     * 
     * @param c1 The first category connection
     * @param c2 The other category connection
     * @return whether the category connections are equal.
     */
    static def boolean equals(ShownCategoryConnection c1, ShownCategoryConnection c2) {
        if (c1 === null || c2 === null) {
            return false
        }
        return equals(c1.connection, c2.connection)
            && equals(c1.sourceChain, c2.sourceChain)
            && c1.innerView ==  c2.innerView
    }
    
    /**
     * Default equals method for artifact chains.
     * 
     * @param c1 The first artifact chain
     * @param c2 The other artifact chain
     * @return whether the artifact chains are equal.
     */
    static def boolean equals(ArtifactChain a1, ArtifactChain a2) {
        if (a1 === null && a2 === null) {
            return true
        }
        if (a1 === null || a2 === null) {
            return false
        }
        if (a1.source !== a2.source) return false
        return equals(a1.further, a2.further)
    }
    
}