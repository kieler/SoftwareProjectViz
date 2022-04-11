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
package de.cau.cs.kieler.spviz.spvizmodel.ui.quickfix;

import org.eclipse.xtext.ui.editor.quickfix.DefaultQuickfixProvider;

/**
 * Custom quickfixes.
 *
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#quick-fixes
 */
public class SPVizModelQuickfixProvider extends DefaultQuickfixProvider {

//    @Fix(SPVizModelValidator.INVALID_NAME)
//    public void capitalizeName(final Issue issue, IssueResolutionAcceptor acceptor) {
//        acceptor.accept(issue, "Capitalize name", "Capitalize the name.", "upcase.png", new IModification() {
//            public void apply(IModificationContext context) throws BadLocationException {
//                IXtextDocument xtextDocument = context.getXtextDocument();
//                String firstLetter = xtextDocument.get(issue.getOffset(), 1);
//                xtextDocument.replace(issue.getOffset(), 1, firstLetter.toUpperCase());
//            }
//        });
//    }

}
