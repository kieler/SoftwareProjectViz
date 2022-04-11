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
package de.cau.cs.kieler.spviz.spviz.ui.labeling

import com.google.inject.Inject
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider

/**
 * Provides labels for EObjects.
 * 
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#label-provider
 */
class SPVizLabelProvider extends DefaultEObjectLabelProvider {

    @Inject
    new(AdapterFactoryLabelProvider delegate) {
        super(delegate);
    }

    // Labels and icons can be computed like this:
    
//    def text(Greeting ele) {
//        'A greeting to ' + ele.name
//    }
//
//    def image(Greeting ele) {
//        'Greeting.gif'
//    }
}
