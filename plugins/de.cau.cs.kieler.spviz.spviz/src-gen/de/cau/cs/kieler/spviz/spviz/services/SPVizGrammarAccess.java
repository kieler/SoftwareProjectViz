/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 *
 * Generated by Xtext 2.25.0
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 */
package de.cau.cs.kieler.spviz.spviz.services;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import java.util.List;
import org.eclipse.xtext.Assignment;
import org.eclipse.xtext.CrossReference;
import org.eclipse.xtext.Grammar;
import org.eclipse.xtext.GrammarUtil;
import org.eclipse.xtext.Group;
import org.eclipse.xtext.Keyword;
import org.eclipse.xtext.ParserRule;
import org.eclipse.xtext.RuleCall;
import org.eclipse.xtext.TerminalRule;
import org.eclipse.xtext.common.services.TerminalsGrammarAccess;
import org.eclipse.xtext.service.AbstractElementFinder;
import org.eclipse.xtext.service.GrammarProvider;

@Singleton
public class SPVizGrammarAccess extends AbstractElementFinder.AbstractGrammarElementFinder {
	
	public class SPVizElements extends AbstractParserRuleElementFinder {
		private final ParserRule rule = (ParserRule) GrammarUtil.findRuleForName(getGrammar(), "de.cau.cs.kieler.spviz.spviz.SPViz.SPViz");
		private final Group cGroup = (Group)rule.eContents().get(1);
		private final Keyword cPackageKeyword_0 = (Keyword)cGroup.eContents().get(0);
		private final Assignment cPackageAssignment_1 = (Assignment)cGroup.eContents().get(1);
		private final RuleCall cPackageQualifiedNameParserRuleCall_1_0 = (RuleCall)cPackageAssignment_1.eContents().get(0);
		private final Keyword cUseKeyword_2 = (Keyword)cGroup.eContents().get(2);
		private final Assignment cImportedNamespaceAssignment_3 = (Assignment)cGroup.eContents().get(3);
		private final RuleCall cImportedNamespaceQualifiedNameParserRuleCall_3_0 = (RuleCall)cImportedNamespaceAssignment_3.eContents().get(0);
		private final Keyword cSPVizKeyword_4 = (Keyword)cGroup.eContents().get(4);
		private final Assignment cNameAssignment_5 = (Assignment)cGroup.eContents().get(5);
		private final RuleCall cNameIDTerminalRuleCall_5_0 = (RuleCall)cNameAssignment_5.eContents().get(0);
		private final Keyword cLeftCurlyBracketKeyword_6 = (Keyword)cGroup.eContents().get(6);
		private final Assignment cViewsAssignment_7 = (Assignment)cGroup.eContents().get(7);
		private final RuleCall cViewsViewParserRuleCall_7_0 = (RuleCall)cViewsAssignment_7.eContents().get(0);
		private final Keyword cRightCurlyBracketKeyword_8 = (Keyword)cGroup.eContents().get(8);
		
		//SPViz returns SPViz:
		//    'package' package=QualifiedName
		//    'use' importedNamespace=QualifiedName
		//    'SPViz' name=ID '{'
		//        views += View*
		//    '}'
		//;
		@Override public ParserRule getRule() { return rule; }
		
		//'package' package=QualifiedName
		//'use' importedNamespace=QualifiedName
		//'SPViz' name=ID '{'
		//    views += View*
		//'}'
		public Group getGroup() { return cGroup; }
		
		//'package'
		public Keyword getPackageKeyword_0() { return cPackageKeyword_0; }
		
		//package=QualifiedName
		public Assignment getPackageAssignment_1() { return cPackageAssignment_1; }
		
		//QualifiedName
		public RuleCall getPackageQualifiedNameParserRuleCall_1_0() { return cPackageQualifiedNameParserRuleCall_1_0; }
		
		//'use'
		public Keyword getUseKeyword_2() { return cUseKeyword_2; }
		
		//importedNamespace=QualifiedName
		public Assignment getImportedNamespaceAssignment_3() { return cImportedNamespaceAssignment_3; }
		
		//QualifiedName
		public RuleCall getImportedNamespaceQualifiedNameParserRuleCall_3_0() { return cImportedNamespaceQualifiedNameParserRuleCall_3_0; }
		
		//'SPViz'
		public Keyword getSPVizKeyword_4() { return cSPVizKeyword_4; }
		
		//name=ID
		public Assignment getNameAssignment_5() { return cNameAssignment_5; }
		
		//ID
		public RuleCall getNameIDTerminalRuleCall_5_0() { return cNameIDTerminalRuleCall_5_0; }
		
		//'{'
		public Keyword getLeftCurlyBracketKeyword_6() { return cLeftCurlyBracketKeyword_6; }
		
		//views += View*
		public Assignment getViewsAssignment_7() { return cViewsAssignment_7; }
		
		//View
		public RuleCall getViewsViewParserRuleCall_7_0() { return cViewsViewParserRuleCall_7_0; }
		
		//'}'
		public Keyword getRightCurlyBracketKeyword_8() { return cRightCurlyBracketKeyword_8; }
	}
	public class ViewElements extends AbstractParserRuleElementFinder {
		private final ParserRule rule = (ParserRule) GrammarUtil.findRuleForName(getGrammar(), "de.cau.cs.kieler.spviz.spviz.SPViz.View");
		private final Group cGroup = (Group)rule.eContents().get(1);
		private final Assignment cNameAssignment_0 = (Assignment)cGroup.eContents().get(0);
		private final RuleCall cNameIDTerminalRuleCall_0_0 = (RuleCall)cNameAssignment_0.eContents().get(0);
		private final Keyword cLeftCurlyBracketKeyword_1 = (Keyword)cGroup.eContents().get(1);
		private final Assignment cShownElementsAssignment_2 = (Assignment)cGroup.eContents().get(2);
		private final RuleCall cShownElementsShownElementParserRuleCall_2_0 = (RuleCall)cShownElementsAssignment_2.eContents().get(0);
		private final Assignment cShownConnectionsAssignment_3 = (Assignment)cGroup.eContents().get(3);
		private final RuleCall cShownConnectionsShownConnectionParserRuleCall_3_0 = (RuleCall)cShownConnectionsAssignment_3.eContents().get(0);
		private final Keyword cRightCurlyBracketKeyword_4 = (Keyword)cGroup.eContents().get(4);
		
		//View returns View:
		//    name=ID '{'
		//        shownElements+=ShownElement*
		//        shownConnections+=ShownConnection*
		//    '}'
		//;
		@Override public ParserRule getRule() { return rule; }
		
		//name=ID '{'
		//    shownElements+=ShownElement*
		//    shownConnections+=ShownConnection*
		//'}'
		public Group getGroup() { return cGroup; }
		
		//name=ID
		public Assignment getNameAssignment_0() { return cNameAssignment_0; }
		
		//ID
		public RuleCall getNameIDTerminalRuleCall_0_0() { return cNameIDTerminalRuleCall_0_0; }
		
		//'{'
		public Keyword getLeftCurlyBracketKeyword_1() { return cLeftCurlyBracketKeyword_1; }
		
		//shownElements+=ShownElement*
		public Assignment getShownElementsAssignment_2() { return cShownElementsAssignment_2; }
		
		//ShownElement
		public RuleCall getShownElementsShownElementParserRuleCall_2_0() { return cShownElementsShownElementParserRuleCall_2_0; }
		
		//shownConnections+=ShownConnection*
		public Assignment getShownConnectionsAssignment_3() { return cShownConnectionsAssignment_3; }
		
		//ShownConnection
		public RuleCall getShownConnectionsShownConnectionParserRuleCall_3_0() { return cShownConnectionsShownConnectionParserRuleCall_3_0; }
		
		//'}'
		public Keyword getRightCurlyBracketKeyword_4() { return cRightCurlyBracketKeyword_4; }
	}
	public class ShownElementElements extends AbstractParserRuleElementFinder {
		private final ParserRule rule = (ParserRule) GrammarUtil.findRuleForName(getGrammar(), "de.cau.cs.kieler.spviz.spviz.SPViz.ShownElement");
		private final Group cGroup = (Group)rule.eContents().get(1);
		private final Keyword cShowKeyword_0 = (Keyword)cGroup.eContents().get(0);
		private final Assignment cShownElementAssignment_1 = (Assignment)cGroup.eContents().get(1);
		private final CrossReference cShownElementArtifactCrossReference_1_0 = (CrossReference)cShownElementAssignment_1.eContents().get(0);
		private final RuleCall cShownElementArtifactQualifiedNameParserRuleCall_1_0_1 = (RuleCall)cShownElementArtifactCrossReference_1_0.eContents().get(1);
		private final Group cGroup_2 = (Group)cGroup.eContents().get(2);
		private final Keyword cInKeyword_2_0 = (Keyword)cGroup_2.eContents().get(0);
		private final Assignment cContainedInAssignment_2_1 = (Assignment)cGroup_2.eContents().get(1);
		private final CrossReference cContainedInArtifactCrossReference_2_1_0 = (CrossReference)cContainedInAssignment_2_1.eContents().get(0);
		private final RuleCall cContainedInArtifactQualifiedNameParserRuleCall_2_1_0_1 = (RuleCall)cContainedInArtifactCrossReference_2_1_0.eContents().get(1);
		
		//ShownElement returns ShownElement:
		//    'show' shownElement=[spvizmodel::Artifact|QualifiedName]
		//    (
		//        'in' containedIn=[spvizmodel::Artifact|QualifiedName]
		//    )?
		//;
		@Override public ParserRule getRule() { return rule; }
		
		//'show' shownElement=[spvizmodel::Artifact|QualifiedName]
		//(
		//    'in' containedIn=[spvizmodel::Artifact|QualifiedName]
		//)?
		public Group getGroup() { return cGroup; }
		
		//'show'
		public Keyword getShowKeyword_0() { return cShowKeyword_0; }
		
		//shownElement=[spvizmodel::Artifact|QualifiedName]
		public Assignment getShownElementAssignment_1() { return cShownElementAssignment_1; }
		
		//[spvizmodel::Artifact|QualifiedName]
		public CrossReference getShownElementArtifactCrossReference_1_0() { return cShownElementArtifactCrossReference_1_0; }
		
		//QualifiedName
		public RuleCall getShownElementArtifactQualifiedNameParserRuleCall_1_0_1() { return cShownElementArtifactQualifiedNameParserRuleCall_1_0_1; }
		
		//(
		//    'in' containedIn=[spvizmodel::Artifact|QualifiedName]
		//)?
		public Group getGroup_2() { return cGroup_2; }
		
		//'in'
		public Keyword getInKeyword_2_0() { return cInKeyword_2_0; }
		
		//containedIn=[spvizmodel::Artifact|QualifiedName]
		public Assignment getContainedInAssignment_2_1() { return cContainedInAssignment_2_1; }
		
		//[spvizmodel::Artifact|QualifiedName]
		public CrossReference getContainedInArtifactCrossReference_2_1_0() { return cContainedInArtifactCrossReference_2_1_0; }
		
		//QualifiedName
		public RuleCall getContainedInArtifactQualifiedNameParserRuleCall_2_1_0_1() { return cContainedInArtifactQualifiedNameParserRuleCall_2_1_0_1; }
	}
	public class ShownConnectionElements extends AbstractParserRuleElementFinder {
		private final ParserRule rule = (ParserRule) GrammarUtil.findRuleForName(getGrammar(), "de.cau.cs.kieler.spviz.spviz.SPViz.ShownConnection");
		private final Group cGroup = (Group)rule.eContents().get(1);
		private final Keyword cConnectKeyword_0 = (Keyword)cGroup.eContents().get(0);
		private final Assignment cShownConnectionAssignment_1 = (Assignment)cGroup.eContents().get(1);
		private final CrossReference cShownConnectionConnectionCrossReference_1_0 = (CrossReference)cShownConnectionAssignment_1.eContents().get(0);
		private final RuleCall cShownConnectionConnectionQualifiedNameParserRuleCall_1_0_1 = (RuleCall)cShownConnectionConnectionCrossReference_1_0.eContents().get(1);
		private final Group cGroup_2 = (Group)cGroup.eContents().get(2);
		private final Keyword cViaKeyword_2_0 = (Keyword)cGroup_2.eContents().get(0);
		private final Assignment cViaAssignment_2_1 = (Assignment)cGroup_2.eContents().get(1);
		private final CrossReference cViaArtifactCrossReference_2_1_0 = (CrossReference)cViaAssignment_2_1.eContents().get(0);
		private final RuleCall cViaArtifactQualifiedNameParserRuleCall_2_1_0_1 = (RuleCall)cViaArtifactCrossReference_2_1_0.eContents().get(1);
		
		//ShownConnection returns ShownConnection:
		//    'connect' shownConnection=[spvizmodel::Connection|QualifiedName]
		//    (
		//        'via' via=[spvizmodel::Artifact|QualifiedName]
		//    )?
		//;
		@Override public ParserRule getRule() { return rule; }
		
		//'connect' shownConnection=[spvizmodel::Connection|QualifiedName]
		//(
		//    'via' via=[spvizmodel::Artifact|QualifiedName]
		//)?
		public Group getGroup() { return cGroup; }
		
		//'connect'
		public Keyword getConnectKeyword_0() { return cConnectKeyword_0; }
		
		//shownConnection=[spvizmodel::Connection|QualifiedName]
		public Assignment getShownConnectionAssignment_1() { return cShownConnectionAssignment_1; }
		
		//[spvizmodel::Connection|QualifiedName]
		public CrossReference getShownConnectionConnectionCrossReference_1_0() { return cShownConnectionConnectionCrossReference_1_0; }
		
		//QualifiedName
		public RuleCall getShownConnectionConnectionQualifiedNameParserRuleCall_1_0_1() { return cShownConnectionConnectionQualifiedNameParserRuleCall_1_0_1; }
		
		//(
		//    'via' via=[spvizmodel::Artifact|QualifiedName]
		//)?
		public Group getGroup_2() { return cGroup_2; }
		
		//'via'
		public Keyword getViaKeyword_2_0() { return cViaKeyword_2_0; }
		
		//via=[spvizmodel::Artifact|QualifiedName]
		public Assignment getViaAssignment_2_1() { return cViaAssignment_2_1; }
		
		//[spvizmodel::Artifact|QualifiedName]
		public CrossReference getViaArtifactCrossReference_2_1_0() { return cViaArtifactCrossReference_2_1_0; }
		
		//QualifiedName
		public RuleCall getViaArtifactQualifiedNameParserRuleCall_2_1_0_1() { return cViaArtifactQualifiedNameParserRuleCall_2_1_0_1; }
	}
	public class QualifiedNameElements extends AbstractParserRuleElementFinder {
		private final ParserRule rule = (ParserRule) GrammarUtil.findRuleForName(getGrammar(), "de.cau.cs.kieler.spviz.spviz.SPViz.QualifiedName");
		private final Group cGroup = (Group)rule.eContents().get(1);
		private final RuleCall cIDTerminalRuleCall_0 = (RuleCall)cGroup.eContents().get(0);
		private final Group cGroup_1 = (Group)cGroup.eContents().get(1);
		private final Keyword cFullStopKeyword_1_0 = (Keyword)cGroup_1.eContents().get(0);
		private final RuleCall cIDTerminalRuleCall_1_1 = (RuleCall)cGroup_1.eContents().get(1);
		
		//QualifiedName:
		//    ID ('.' ID)*
		//;
		@Override public ParserRule getRule() { return rule; }
		
		//ID ('.' ID)*
		public Group getGroup() { return cGroup; }
		
		//ID
		public RuleCall getIDTerminalRuleCall_0() { return cIDTerminalRuleCall_0; }
		
		//('.' ID)*
		public Group getGroup_1() { return cGroup_1; }
		
		//'.'
		public Keyword getFullStopKeyword_1_0() { return cFullStopKeyword_1_0; }
		
		//ID
		public RuleCall getIDTerminalRuleCall_1_1() { return cIDTerminalRuleCall_1_1; }
	}
	
	
	private final SPVizElements pSPViz;
	private final ViewElements pView;
	private final ShownElementElements pShownElement;
	private final ShownConnectionElements pShownConnection;
	private final QualifiedNameElements pQualifiedName;
	
	private final Grammar grammar;
	
	private final TerminalsGrammarAccess gaTerminals;

	@Inject
	public SPVizGrammarAccess(GrammarProvider grammarProvider,
			TerminalsGrammarAccess gaTerminals) {
		this.grammar = internalFindGrammar(grammarProvider);
		this.gaTerminals = gaTerminals;
		this.pSPViz = new SPVizElements();
		this.pView = new ViewElements();
		this.pShownElement = new ShownElementElements();
		this.pShownConnection = new ShownConnectionElements();
		this.pQualifiedName = new QualifiedNameElements();
	}
	
	protected Grammar internalFindGrammar(GrammarProvider grammarProvider) {
		Grammar grammar = grammarProvider.getGrammar(this);
		while (grammar != null) {
			if ("de.cau.cs.kieler.spviz.spviz.SPViz".equals(grammar.getName())) {
				return grammar;
			}
			List<Grammar> grammars = grammar.getUsedGrammars();
			if (!grammars.isEmpty()) {
				grammar = grammars.iterator().next();
			} else {
				return null;
			}
		}
		return grammar;
	}
	
	@Override
	public Grammar getGrammar() {
		return grammar;
	}
	
	
	public TerminalsGrammarAccess getTerminalsGrammarAccess() {
		return gaTerminals;
	}

	
	//SPViz returns SPViz:
	//    'package' package=QualifiedName
	//    'use' importedNamespace=QualifiedName
	//    'SPViz' name=ID '{'
	//        views += View*
	//    '}'
	//;
	public SPVizElements getSPVizAccess() {
		return pSPViz;
	}
	
	public ParserRule getSPVizRule() {
		return getSPVizAccess().getRule();
	}
	
	//View returns View:
	//    name=ID '{'
	//        shownElements+=ShownElement*
	//        shownConnections+=ShownConnection*
	//    '}'
	//;
	public ViewElements getViewAccess() {
		return pView;
	}
	
	public ParserRule getViewRule() {
		return getViewAccess().getRule();
	}
	
	//ShownElement returns ShownElement:
	//    'show' shownElement=[spvizmodel::Artifact|QualifiedName]
	//    (
	//        'in' containedIn=[spvizmodel::Artifact|QualifiedName]
	//    )?
	//;
	public ShownElementElements getShownElementAccess() {
		return pShownElement;
	}
	
	public ParserRule getShownElementRule() {
		return getShownElementAccess().getRule();
	}
	
	//ShownConnection returns ShownConnection:
	//    'connect' shownConnection=[spvizmodel::Connection|QualifiedName]
	//    (
	//        'via' via=[spvizmodel::Artifact|QualifiedName]
	//    )?
	//;
	public ShownConnectionElements getShownConnectionAccess() {
		return pShownConnection;
	}
	
	public ParserRule getShownConnectionRule() {
		return getShownConnectionAccess().getRule();
	}
	
	//QualifiedName:
	//    ID ('.' ID)*
	//;
	public QualifiedNameElements getQualifiedNameAccess() {
		return pQualifiedName;
	}
	
	public ParserRule getQualifiedNameRule() {
		return getQualifiedNameAccess().getRule();
	}
	
	//terminal ID: '^'?('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*;
	public TerminalRule getIDRule() {
		return gaTerminals.getIDRule();
	}
	
	//terminal INT returns ecore::EInt: ('0'..'9')+;
	public TerminalRule getINTRule() {
		return gaTerminals.getINTRule();
	}
	
	//terminal STRING:
	//            '"' ( '\\' . /* 'b'|'t'|'n'|'f'|'r'|'u'|'"'|"'"|'\\' */ | !('\\'|'"') )* '"' |
	//            "'" ( '\\' . /* 'b'|'t'|'n'|'f'|'r'|'u'|'"'|"'"|'\\' */ | !('\\'|"'") )* "'"
	//        ;
	public TerminalRule getSTRINGRule() {
		return gaTerminals.getSTRINGRule();
	}
	
	//terminal ML_COMMENT : '/*' -> '*/';
	public TerminalRule getML_COMMENTRule() {
		return gaTerminals.getML_COMMENTRule();
	}
	
	//terminal SL_COMMENT : '//' !('\n'|'\r')* ('\r'? '\n')?;
	public TerminalRule getSL_COMMENTRule() {
		return gaTerminals.getSL_COMMENTRule();
	}
	
	//terminal WS         : (' '|'\t'|'\r'|'\n')+;
	public TerminalRule getWSRule() {
		return gaTerminals.getWSRule();
	}
	
	//terminal ANY_OTHER: .;
	public TerminalRule getANY_OTHERRule() {
		return gaTerminals.getANY_OTHERRule();
	}
}
