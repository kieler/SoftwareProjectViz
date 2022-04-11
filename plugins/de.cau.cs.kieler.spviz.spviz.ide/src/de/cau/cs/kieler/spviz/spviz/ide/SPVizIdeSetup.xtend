/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.ide

import com.google.inject.Guice
import de.cau.cs.kieler.spviz.spviz.SPVizRuntimeModule
import de.cau.cs.kieler.spviz.spviz.SPVizStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class SPVizIdeSetup extends SPVizStandaloneSetup {

    override createInjector() {
        Guice.createInjector(Modules2.mixin(new SPVizRuntimeModule, new SPVizIdeModule))
    }
    
}
