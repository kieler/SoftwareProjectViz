/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 * 
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020-2021 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz

import de.cau.cs.kieler.spviz.spviz.scoping.SPVizGlobalScopeProvider
import org.eclipse.xtext.resource.IDefaultResourceDescriptionStrategy
import org.eclipse.xtext.scoping.IGlobalScopeProvider

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 * 
 * @author nre
 */
class SPVizRuntimeModule extends AbstractSPVizRuntimeModule {
    def Class<? extends IDefaultResourceDescriptionStrategy> bindIDefaultResourceDescriptionStrategy() {
        SPVizResourceDescriptionStrategy
    }
    
    override Class<? extends IGlobalScopeProvider> bindIGlobalScopeProvider() {
        SPVizGlobalScopeProvider
    }
}
