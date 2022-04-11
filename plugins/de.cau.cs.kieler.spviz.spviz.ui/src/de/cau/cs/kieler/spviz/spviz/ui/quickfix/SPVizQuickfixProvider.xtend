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
package de.cau.cs.kieler.spviz.spviz.ui.quickfix

import de.cau.cs.kieler.spviz.spvizmodel.ui.quickfix.SPVizModelQuickfixProvider

/**
 * Custom quickfixes.
 *
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#quick-fixes
 */
class SPVizQuickfixProvider extends SPVizModelQuickfixProvider {

//    @Fix(SPVizValidator.INVALID_NAME)
//    def capitalizeName(Issue issue, IssueResolutionAcceptor acceptor) {
//        acceptor.accept(issue, 'Capitalize name', 'Capitalize the name.', 'upcase.png') [
//            context |
//            val xtextDocument = context.xtextDocument
//            val firstLetter = xtextDocument.get(issue.offset, 1)
//            xtextDocument.replace(issue.offset, 1, firstLetter.toUpperCase)
//        ]
//    }
}
