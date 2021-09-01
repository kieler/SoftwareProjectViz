/**
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 * 
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021 by
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
     * Returns the required artifact of a connection.
     * 
     * @param connection The connection
     * @return the required artifact.
     */
    static def Artifact getRequired(Connection connection) {
        return connection.dependsOn
    }
    
    /**
     * Returns the requiring artifact of a connection.
     * 
     * @param connection The connection
     * @return the requiring artifact.
     */
    static def Artifact getRequiring(Connection connection) {
        return connection.eContainer as Artifact
    }
    
}