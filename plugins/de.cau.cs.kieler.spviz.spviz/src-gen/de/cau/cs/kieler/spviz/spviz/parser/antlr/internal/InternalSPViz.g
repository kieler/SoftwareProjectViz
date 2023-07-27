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
grammar InternalSPViz;

options {
	superClass=AbstractInternalAntlrParser;
}

@lexer::header {
package de.cau.cs.kieler.spviz.spviz.parser.antlr.internal;

// Hack: Use our own Lexer superclass by means of import. 
// Currently there is no other way to specify the superclass for the lexer.
import org.eclipse.xtext.parser.antlr.Lexer;
}

@parser::header {
package de.cau.cs.kieler.spviz.spviz.parser.antlr.internal;

import org.eclipse.xtext.*;
import org.eclipse.xtext.parser.*;
import org.eclipse.xtext.parser.impl.*;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.parser.antlr.AbstractInternalAntlrParser;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.parser.antlr.AntlrDatatypeRuleToken;
import de.cau.cs.kieler.spviz.spviz.services.SPVizGrammarAccess;

}

@parser::members {

 	private SPVizGrammarAccess grammarAccess;

    public InternalSPVizParser(TokenStream input, SPVizGrammarAccess grammarAccess) {
        this(input);
        this.grammarAccess = grammarAccess;
        registerRules(grammarAccess.getGrammar());
    }

    @Override
    protected String getFirstRuleName() {
    	return "SPViz";
   	}

   	@Override
   	protected SPVizGrammarAccess getGrammarAccess() {
   		return grammarAccess;
   	}

}

@rulecatch {
    catch (RecognitionException re) {
        recover(input,re);
        appendSkippedTokens();
    }
}

// Entry rule entryRuleSPViz
entryRuleSPViz returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getSPVizRule()); }
	iv_ruleSPViz=ruleSPViz
	{ $current=$iv_ruleSPViz.current; }
	EOF;

// Rule SPViz
ruleSPViz returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		otherlv_0='package'
		{
			newLeafNode(otherlv_0, grammarAccess.getSPVizAccess().getPackageKeyword_0());
		}
		(
			(
				{
					newCompositeNode(grammarAccess.getSPVizAccess().getPackageQualifiedNameParserRuleCall_1_0());
				}
				lv_package_1_0=ruleQualifiedName
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getSPVizRule());
					}
					set(
						$current,
						"package",
						lv_package_1_0,
						"de.cau.cs.kieler.spviz.spviz.SPViz.QualifiedName");
					afterParserOrEnumRuleCall();
				}
			)
		)
		otherlv_2='import'
		{
			newLeafNode(otherlv_2, grammarAccess.getSPVizAccess().getImportKeyword_2());
		}
		(
			(
				lv_importURI_3_0=RULE_STRING
				{
					newLeafNode(lv_importURI_3_0, grammarAccess.getSPVizAccess().getImportURISTRINGTerminalRuleCall_3_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getSPVizRule());
					}
					setWithLastConsumed(
						$current,
						"importURI",
						lv_importURI_3_0,
						"org.eclipse.xtext.common.Terminals.STRING");
				}
			)
		)
		otherlv_4='SPViz'
		{
			newLeafNode(otherlv_4, grammarAccess.getSPVizAccess().getSPVizKeyword_4());
		}
		(
			(
				lv_name_5_0=RULE_ID
				{
					newLeafNode(lv_name_5_0, grammarAccess.getSPVizAccess().getNameIDTerminalRuleCall_5_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getSPVizRule());
					}
					setWithLastConsumed(
						$current,
						"name",
						lv_name_5_0,
						"org.eclipse.xtext.common.Terminals.ID");
				}
			)
		)
		otherlv_6='{'
		{
			newLeafNode(otherlv_6, grammarAccess.getSPVizAccess().getLeftCurlyBracketKeyword_6());
		}
		(
			(
				{
					newCompositeNode(grammarAccess.getSPVizAccess().getViewsViewParserRuleCall_7_0());
				}
				lv_views_7_0=ruleView
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getSPVizRule());
					}
					add(
						$current,
						"views",
						lv_views_7_0,
						"de.cau.cs.kieler.spviz.spviz.SPViz.View");
					afterParserOrEnumRuleCall();
				}
			)
		)*
		(
			(
				{
					newCompositeNode(grammarAccess.getSPVizAccess().getArtifactShowsArtifactShowsParserRuleCall_8_0());
				}
				lv_artifactShows_8_0=ruleArtifactShows
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getSPVizRule());
					}
					add(
						$current,
						"artifactShows",
						lv_artifactShows_8_0,
						"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactShows");
					afterParserOrEnumRuleCall();
				}
			)
		)*
		otherlv_9='}'
		{
			newLeafNode(otherlv_9, grammarAccess.getSPVizAccess().getRightCurlyBracketKeyword_9());
		}
	)
;

// Entry rule entryRuleView
entryRuleView returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getViewRule()); }
	iv_ruleView=ruleView
	{ $current=$iv_ruleView.current; }
	EOF;

// Rule View
ruleView returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		(
			(
				lv_name_0_0=RULE_ID
				{
					newLeafNode(lv_name_0_0, grammarAccess.getViewAccess().getNameIDTerminalRuleCall_0_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getViewRule());
					}
					setWithLastConsumed(
						$current,
						"name",
						lv_name_0_0,
						"org.eclipse.xtext.common.Terminals.ID");
				}
			)
		)
		otherlv_1='{'
		{
			newLeafNode(otherlv_1, grammarAccess.getViewAccess().getLeftCurlyBracketKeyword_1());
		}
		(
			(
				{
					newCompositeNode(grammarAccess.getViewAccess().getShownElementsShownElementParserRuleCall_2_0());
				}
				lv_shownElements_2_0=ruleShownElement
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getViewRule());
					}
					add(
						$current,
						"shownElements",
						lv_shownElements_2_0,
						"de.cau.cs.kieler.spviz.spviz.SPViz.ShownElement");
					afterParserOrEnumRuleCall();
				}
			)
		)*
		(
			(
				{
					newCompositeNode(grammarAccess.getViewAccess().getShownConnectionsShownConnectionParserRuleCall_3_0());
				}
				lv_shownConnections_3_0=ruleShownConnection
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getViewRule());
					}
					add(
						$current,
						"shownConnections",
						lv_shownConnections_3_0,
						"de.cau.cs.kieler.spviz.spviz.SPViz.ShownConnection");
					afterParserOrEnumRuleCall();
				}
			)
		)*
		(
			(
				{
					newCompositeNode(grammarAccess.getViewAccess().getShownCategoryConnectionsShownCategoryConnectionParserRuleCall_4_0());
				}
				lv_shownCategoryConnections_4_0=ruleShownCategoryConnection
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getViewRule());
					}
					add(
						$current,
						"shownCategoryConnections",
						lv_shownCategoryConnections_4_0,
						"de.cau.cs.kieler.spviz.spviz.SPViz.ShownCategoryConnection");
					afterParserOrEnumRuleCall();
				}
			)
		)*
		otherlv_5='}'
		{
			newLeafNode(otherlv_5, grammarAccess.getViewAccess().getRightCurlyBracketKeyword_5());
		}
	)
;

// Entry rule entryRuleArtifactShows
entryRuleArtifactShows returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getArtifactShowsRule()); }
	iv_ruleArtifactShows=ruleArtifactShows
	{ $current=$iv_ruleArtifactShows.current; }
	EOF;

// Rule ArtifactShows
ruleArtifactShows returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		(
			(
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getArtifactShowsRule());
					}
				}
				{
					newCompositeNode(grammarAccess.getArtifactShowsAccess().getArtifactShowsArtifactCrossReference_0_0());
				}
				ruleQualifiedName
				{
					afterParserOrEnumRuleCall();
				}
			)
		)
		otherlv_1='shows'
		{
			newLeafNode(otherlv_1, grammarAccess.getArtifactShowsAccess().getShowsKeyword_1());
		}
		otherlv_2='{'
		{
			newLeafNode(otherlv_2, grammarAccess.getArtifactShowsAccess().getLeftCurlyBracketKeyword_2());
		}
		(
			(
				{
					newCompositeNode(grammarAccess.getArtifactShowsAccess().getViewsArtifactViewParserRuleCall_3_0());
				}
				lv_views_3_0=ruleArtifactView
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getArtifactShowsRule());
					}
					add(
						$current,
						"views",
						lv_views_3_0,
						"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactView");
					afterParserOrEnumRuleCall();
				}
			)
		)*
		otherlv_4='}'
		{
			newLeafNode(otherlv_4, grammarAccess.getArtifactShowsAccess().getRightCurlyBracketKeyword_4());
		}
	)
;

// Entry rule entryRuleArtifactView
entryRuleArtifactView returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getArtifactViewRule()); }
	iv_ruleArtifactView=ruleArtifactView
	{ $current=$iv_ruleArtifactView.current; }
	EOF;

// Rule ArtifactView
ruleArtifactView returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		(
			(
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getArtifactViewRule());
					}
				}
				otherlv_0=RULE_ID
				{
					newLeafNode(otherlv_0, grammarAccess.getArtifactViewAccess().getViewViewCrossReference_0_0());
				}
			)
		)
		otherlv_1='with'
		{
			newLeafNode(otherlv_1, grammarAccess.getArtifactViewAccess().getWithKeyword_1());
		}
		otherlv_2='{'
		{
			newLeafNode(otherlv_2, grammarAccess.getArtifactViewAccess().getLeftCurlyBracketKeyword_2());
		}
		(
			(
				{
					newCompositeNode(grammarAccess.getArtifactViewAccess().getSourcesArtifactSourceParserRuleCall_3_0());
				}
				lv_sources_3_0=ruleArtifactSource
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getArtifactViewRule());
					}
					add(
						$current,
						"sources",
						lv_sources_3_0,
						"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactSource");
					afterParserOrEnumRuleCall();
				}
			)
		)*
		otherlv_4='}'
		{
			newLeafNode(otherlv_4, grammarAccess.getArtifactViewAccess().getRightCurlyBracketKeyword_4());
		}
	)
;

// Entry rule entryRuleArtifactSource
entryRuleArtifactSource returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getArtifactSourceRule()); }
	iv_ruleArtifactSource=ruleArtifactSource
	{ $current=$iv_ruleArtifactSource.current; }
	EOF;

// Rule ArtifactSource
ruleArtifactSource returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		(
			(
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getArtifactSourceRule());
					}
				}
				{
					newCompositeNode(grammarAccess.getArtifactSourceAccess().getArtifactArtifactCrossReference_0_0());
				}
				ruleQualifiedName
				{
					afterParserOrEnumRuleCall();
				}
			)
		)
		otherlv_1='from'
		{
			newLeafNode(otherlv_1, grammarAccess.getArtifactSourceAccess().getFromKeyword_1());
		}
		(
			(
				{
					newCompositeNode(grammarAccess.getArtifactSourceAccess().getSourceChainArtifactChainParserRuleCall_2_0());
				}
				lv_sourceChain_2_0=ruleArtifactChain
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getArtifactSourceRule());
					}
					set(
						$current,
						"sourceChain",
						lv_sourceChain_2_0,
						"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactChain");
					afterParserOrEnumRuleCall();
				}
			)
		)
	)
;

// Entry rule entryRuleArtifactChain
entryRuleArtifactChain returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getArtifactChainRule()); }
	iv_ruleArtifactChain=ruleArtifactChain
	{ $current=$iv_ruleArtifactChain.current; }
	EOF;

// Rule ArtifactChain
ruleArtifactChain returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		(
			(
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getArtifactChainRule());
					}
				}
				{
					newCompositeNode(grammarAccess.getArtifactChainAccess().getSourceArtifactCrossReference_0_0());
				}
				ruleQualifiedName
				{
					afterParserOrEnumRuleCall();
				}
			)
		)
		(
			otherlv_1='>'
			{
				newLeafNode(otherlv_1, grammarAccess.getArtifactChainAccess().getGreaterThanSignKeyword_1_0());
			}
			(
				(
					{
						newCompositeNode(grammarAccess.getArtifactChainAccess().getFurtherArtifactChainParserRuleCall_1_1_0());
					}
					lv_further_2_0=ruleArtifactChain
					{
						if ($current==null) {
							$current = createModelElementForParent(grammarAccess.getArtifactChainRule());
						}
						set(
							$current,
							"further",
							lv_further_2_0,
							"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactChain");
						afterParserOrEnumRuleCall();
					}
				)
			)
		)?
	)
;

// Entry rule entryRuleShownElement
entryRuleShownElement returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getShownElementRule()); }
	iv_ruleShownElement=ruleShownElement
	{ $current=$iv_ruleShownElement.current; }
	EOF;

// Rule ShownElement
ruleShownElement returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		otherlv_0='show'
		{
			newLeafNode(otherlv_0, grammarAccess.getShownElementAccess().getShowKeyword_0());
		}
		(
			(
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getShownElementRule());
					}
				}
				{
					newCompositeNode(grammarAccess.getShownElementAccess().getShownElementArtifactCrossReference_1_0());
				}
				ruleQualifiedName
				{
					afterParserOrEnumRuleCall();
				}
			)
		)
		(
			otherlv_2='in'
			{
				newLeafNode(otherlv_2, grammarAccess.getShownElementAccess().getInKeyword_2_0());
			}
			(
				(
					{
						if ($current==null) {
							$current = createModelElement(grammarAccess.getShownElementRule());
						}
					}
					{
						newCompositeNode(grammarAccess.getShownElementAccess().getContainedInArtifactCrossReference_2_1_0());
					}
					ruleQualifiedName
					{
						afterParserOrEnumRuleCall();
					}
				)
			)
		)?
	)
;

// Entry rule entryRuleShownConnection
entryRuleShownConnection returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getShownConnectionRule()); }
	iv_ruleShownConnection=ruleShownConnection
	{ $current=$iv_ruleShownConnection.current; }
	EOF;

// Rule ShownConnection
ruleShownConnection returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		otherlv_0='connect'
		{
			newLeafNode(otherlv_0, grammarAccess.getShownConnectionAccess().getConnectKeyword_0());
		}
		(
			(
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getShownConnectionRule());
					}
				}
				{
					newCompositeNode(grammarAccess.getShownConnectionAccess().getShownConnectionConnectionCrossReference_1_0());
				}
				ruleQualifiedName
				{
					afterParserOrEnumRuleCall();
				}
			)
		)
	)
;

// Entry rule entryRuleShownCategoryConnection
entryRuleShownCategoryConnection returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getShownCategoryConnectionRule()); }
	iv_ruleShownCategoryConnection=ruleShownCategoryConnection
	{ $current=$iv_ruleShownCategoryConnection.current; }
	EOF;

// Rule ShownCategoryConnection
ruleShownCategoryConnection returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		otherlv_0='connect'
		{
			newLeafNode(otherlv_0, grammarAccess.getShownCategoryConnectionAccess().getConnectKeyword_0());
		}
		(
			(
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getShownCategoryConnectionRule());
					}
				}
				{
					newCompositeNode(grammarAccess.getShownCategoryConnectionAccess().getConnectionConnectionCrossReference_1_0());
				}
				ruleQualifiedName
				{
					afterParserOrEnumRuleCall();
				}
			)
		)
		otherlv_2='via'
		{
			newLeafNode(otherlv_2, grammarAccess.getShownCategoryConnectionAccess().getViaKeyword_2());
		}
		(
			(
				{
					newCompositeNode(grammarAccess.getShownCategoryConnectionAccess().getSourceChainArtifactChainParserRuleCall_3_0());
				}
				lv_sourceChain_3_0=ruleArtifactChain
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getShownCategoryConnectionRule());
					}
					set(
						$current,
						"sourceChain",
						lv_sourceChain_3_0,
						"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactChain");
					afterParserOrEnumRuleCall();
				}
			)
		)
	)
;

// Entry rule entryRuleQualifiedName
entryRuleQualifiedName returns [String current=null]:
	{ newCompositeNode(grammarAccess.getQualifiedNameRule()); }
	iv_ruleQualifiedName=ruleQualifiedName
	{ $current=$iv_ruleQualifiedName.current.getText(); }
	EOF;

// Rule QualifiedName
ruleQualifiedName returns [AntlrDatatypeRuleToken current=new AntlrDatatypeRuleToken()]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		this_ID_0=RULE_ID
		{
			$current.merge(this_ID_0);
		}
		{
			newLeafNode(this_ID_0, grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_0());
		}
		(
			kw='.'
			{
				$current.merge(kw);
				newLeafNode(kw, grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0());
			}
			this_ID_2=RULE_ID
			{
				$current.merge(this_ID_2);
			}
			{
				newLeafNode(this_ID_2, grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_1_1());
			}
		)*
	)
;

RULE_ID : '^'? ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*;

RULE_INT : ('0'..'9')+;

RULE_STRING : ('"' ('\\' .|~(('\\'|'"')))* '"'|'\'' ('\\' .|~(('\\'|'\'')))* '\'');

RULE_ML_COMMENT : '/*' ( options {greedy=false;} : . )*'*/';

RULE_SL_COMMENT : '//' ~(('\n'|'\r'))* ('\r'? '\n')?;

RULE_WS : (' '|'\t'|'\r'|'\n')+;

RULE_ANY_OTHER : .;
