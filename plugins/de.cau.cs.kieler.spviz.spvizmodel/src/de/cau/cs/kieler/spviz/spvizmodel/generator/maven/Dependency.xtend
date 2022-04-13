/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2022 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator.maven

import org.eclipse.xtend.lib.annotations.Data

/**
 * Data class for a simple dependency as stated in a Maven pom.
 */
@Data
class Dependency {
    /** The group ID of the dependency. */
    String groupId
    /** The artifact ID of the dependency. */
    String artifactId
    /** The version number of the dependency. */
    String version
    
    /**
     * Turns this dependency into the string defining this dependency in a pom.xml file.
     */
    def String toPom() {
        return '''
            <dependency>
                <groupId>«groupId»</groupId>
                <artifactId>«artifactId»</artifactId>
                <version>«version»</version>
            </dependency>
        '''
    }
}