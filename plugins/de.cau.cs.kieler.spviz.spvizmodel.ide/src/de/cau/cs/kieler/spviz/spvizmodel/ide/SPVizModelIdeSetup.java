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
package de.cau.cs.kieler.spviz.spvizmodel.ide;

import com.google.inject.Guice;
import com.google.inject.Injector;
import de.cau.cs.kieler.spviz.spvizmodel.SPVizModelRuntimeModule;
import de.cau.cs.kieler.spviz.spvizmodel.SPVizModelStandaloneSetup;
import org.eclipse.xtext.util.Modules2;

/**
 * Initialization support for running Xtext languages as language servers.
 */
public class SPVizModelIdeSetup extends SPVizModelStandaloneSetup {

    @Override
    public Injector createInjector() {
        return Guice.createInjector(Modules2.mixin(new SPVizModelRuntimeModule(), new SPVizModelIdeModule()));
    }
    
}
