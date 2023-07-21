/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 * 
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021-2023 by
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
package de.cau.cs.kieler.spviz.spvizmodel.util

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection

/** 
 * Utility extension class for usability of the SPVizmodel classes.
 * 
 * @author nre
 */
class SPVizModelExtension {
    
    /**
     * Returns the connected artifact of a connection.
     * 
     * @param connection The connection
     * @return the connected artifact.
     */
    static def Artifact getConnected(Connection connection) {
        return connection.connects
    }
    
    /**
     * Returns the connecting artifact of a connection.
     * 
     * @param connection The connection
     * @return the connecting artifact.
     */
    static def Artifact getConnecting(Connection connection) {
        return connection.eContainer as Artifact
    }
    
    /**
     * Default equals method for connections.
     * 
     * @param c1 The first connection
     * @param c2 The other connection
     * @return whether the connections are equal.
     */
    static def boolean equals(Connection c1, Connection c2) {
        if (c1 === null || c2 === null) {
            return false
        }
        return c1.name == c2.name
            && c1.connected.name.equals(c2.connected.name)
            && c1.connecting.name.equals(c2.connecting.name)
    }
    
}