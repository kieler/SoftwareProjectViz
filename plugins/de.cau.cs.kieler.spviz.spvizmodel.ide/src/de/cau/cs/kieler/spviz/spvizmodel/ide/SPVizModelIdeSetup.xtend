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
 * Generated by Xtext 2.27.0
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 */
package de.cau.cs.kieler.spviz.spvizmodel.ide

import com.google.inject.Guice
import de.cau.cs.kieler.spviz.spvizmodel.SPVizModelRuntimeModule
import de.cau.cs.kieler.spviz.spvizmodel.SPVizModelStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class SPVizModelIdeSetup extends SPVizModelStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new SPVizModelRuntimeModule, new SPVizModelIdeModule))
	}
	
}
