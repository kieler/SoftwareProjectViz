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



import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class InternalSPVizParser extends AbstractInternalAntlrParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_STRING", "RULE_ID", "RULE_INT", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'package'", "'import'", "'SPViz'", "'{'", "'}'", "'shows'", "'with'", "'from'", "'>'", "'show'", "'in'", "'connect'", "'via'", "'.'"
    };
    public static final int RULE_STRING=4;
    public static final int RULE_SL_COMMENT=8;
    public static final int T__19=19;
    public static final int T__15=15;
    public static final int T__16=16;
    public static final int T__17=17;
    public static final int T__18=18;
    public static final int T__11=11;
    public static final int T__12=12;
    public static final int T__13=13;
    public static final int T__14=14;
    public static final int EOF=-1;
    public static final int RULE_ID=5;
    public static final int RULE_WS=9;
    public static final int RULE_ANY_OTHER=10;
    public static final int RULE_INT=6;
    public static final int T__22=22;
    public static final int RULE_ML_COMMENT=7;
    public static final int T__23=23;
    public static final int T__24=24;
    public static final int T__20=20;
    public static final int T__21=21;

    // delegates
    // delegators


        public InternalSPVizParser(TokenStream input) {
            this(input, new RecognizerSharedState());
        }
        public InternalSPVizParser(TokenStream input, RecognizerSharedState state) {
            super(input, state);
             
        }
        

    public String[] getTokenNames() { return InternalSPVizParser.tokenNames; }
    public String getGrammarFileName() { return "InternalSPViz.g"; }



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




    // $ANTLR start "entryRuleSPViz"
    // InternalSPViz.g:79:1: entryRuleSPViz returns [EObject current=null] : iv_ruleSPViz= ruleSPViz EOF ;
    public final EObject entryRuleSPViz() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleSPViz = null;


        try {
            // InternalSPViz.g:79:46: (iv_ruleSPViz= ruleSPViz EOF )
            // InternalSPViz.g:80:2: iv_ruleSPViz= ruleSPViz EOF
            {
             newCompositeNode(grammarAccess.getSPVizRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleSPViz=ruleSPViz();

            state._fsp--;

             current =iv_ruleSPViz; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleSPViz"


    // $ANTLR start "ruleSPViz"
    // InternalSPViz.g:86:1: ruleSPViz returns [EObject current=null] : (otherlv_0= 'package' ( (lv_package_1_0= ruleQualifiedName ) ) otherlv_2= 'import' ( (lv_importURI_3_0= RULE_STRING ) ) otherlv_4= 'SPViz' ( (lv_name_5_0= RULE_ID ) ) otherlv_6= '{' ( (lv_views_7_0= ruleView ) )* ( (lv_artifactShows_8_0= ruleArtifactShows ) )* otherlv_9= '}' ) ;
    public final EObject ruleSPViz() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_2=null;
        Token lv_importURI_3_0=null;
        Token otherlv_4=null;
        Token lv_name_5_0=null;
        Token otherlv_6=null;
        Token otherlv_9=null;
        AntlrDatatypeRuleToken lv_package_1_0 = null;

        EObject lv_views_7_0 = null;

        EObject lv_artifactShows_8_0 = null;



        	enterRule();

        try {
            // InternalSPViz.g:92:2: ( (otherlv_0= 'package' ( (lv_package_1_0= ruleQualifiedName ) ) otherlv_2= 'import' ( (lv_importURI_3_0= RULE_STRING ) ) otherlv_4= 'SPViz' ( (lv_name_5_0= RULE_ID ) ) otherlv_6= '{' ( (lv_views_7_0= ruleView ) )* ( (lv_artifactShows_8_0= ruleArtifactShows ) )* otherlv_9= '}' ) )
            // InternalSPViz.g:93:2: (otherlv_0= 'package' ( (lv_package_1_0= ruleQualifiedName ) ) otherlv_2= 'import' ( (lv_importURI_3_0= RULE_STRING ) ) otherlv_4= 'SPViz' ( (lv_name_5_0= RULE_ID ) ) otherlv_6= '{' ( (lv_views_7_0= ruleView ) )* ( (lv_artifactShows_8_0= ruleArtifactShows ) )* otherlv_9= '}' )
            {
            // InternalSPViz.g:93:2: (otherlv_0= 'package' ( (lv_package_1_0= ruleQualifiedName ) ) otherlv_2= 'import' ( (lv_importURI_3_0= RULE_STRING ) ) otherlv_4= 'SPViz' ( (lv_name_5_0= RULE_ID ) ) otherlv_6= '{' ( (lv_views_7_0= ruleView ) )* ( (lv_artifactShows_8_0= ruleArtifactShows ) )* otherlv_9= '}' )
            // InternalSPViz.g:94:3: otherlv_0= 'package' ( (lv_package_1_0= ruleQualifiedName ) ) otherlv_2= 'import' ( (lv_importURI_3_0= RULE_STRING ) ) otherlv_4= 'SPViz' ( (lv_name_5_0= RULE_ID ) ) otherlv_6= '{' ( (lv_views_7_0= ruleView ) )* ( (lv_artifactShows_8_0= ruleArtifactShows ) )* otherlv_9= '}'
            {
            otherlv_0=(Token)match(input,11,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getSPVizAccess().getPackageKeyword_0());
            		
            // InternalSPViz.g:98:3: ( (lv_package_1_0= ruleQualifiedName ) )
            // InternalSPViz.g:99:4: (lv_package_1_0= ruleQualifiedName )
            {
            // InternalSPViz.g:99:4: (lv_package_1_0= ruleQualifiedName )
            // InternalSPViz.g:100:5: lv_package_1_0= ruleQualifiedName
            {

            					newCompositeNode(grammarAccess.getSPVizAccess().getPackageQualifiedNameParserRuleCall_1_0());
            				
            pushFollow(FOLLOW_4);
            lv_package_1_0=ruleQualifiedName();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getSPVizRule());
            					}
            					set(
            						current,
            						"package",
            						lv_package_1_0,
            						"de.cau.cs.kieler.spviz.spviz.SPViz.QualifiedName");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_2=(Token)match(input,12,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getSPVizAccess().getImportKeyword_2());
            		
            // InternalSPViz.g:121:3: ( (lv_importURI_3_0= RULE_STRING ) )
            // InternalSPViz.g:122:4: (lv_importURI_3_0= RULE_STRING )
            {
            // InternalSPViz.g:122:4: (lv_importURI_3_0= RULE_STRING )
            // InternalSPViz.g:123:5: lv_importURI_3_0= RULE_STRING
            {
            lv_importURI_3_0=(Token)match(input,RULE_STRING,FOLLOW_6); 

            					newLeafNode(lv_importURI_3_0, grammarAccess.getSPVizAccess().getImportURISTRINGTerminalRuleCall_3_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getSPVizRule());
            					}
            					setWithLastConsumed(
            						current,
            						"importURI",
            						lv_importURI_3_0,
            						"org.eclipse.xtext.common.Terminals.STRING");
            				

            }


            }

            otherlv_4=(Token)match(input,13,FOLLOW_3); 

            			newLeafNode(otherlv_4, grammarAccess.getSPVizAccess().getSPVizKeyword_4());
            		
            // InternalSPViz.g:143:3: ( (lv_name_5_0= RULE_ID ) )
            // InternalSPViz.g:144:4: (lv_name_5_0= RULE_ID )
            {
            // InternalSPViz.g:144:4: (lv_name_5_0= RULE_ID )
            // InternalSPViz.g:145:5: lv_name_5_0= RULE_ID
            {
            lv_name_5_0=(Token)match(input,RULE_ID,FOLLOW_7); 

            					newLeafNode(lv_name_5_0, grammarAccess.getSPVizAccess().getNameIDTerminalRuleCall_5_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getSPVizRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            otherlv_6=(Token)match(input,14,FOLLOW_8); 

            			newLeafNode(otherlv_6, grammarAccess.getSPVizAccess().getLeftCurlyBracketKeyword_6());
            		
            // InternalSPViz.g:165:3: ( (lv_views_7_0= ruleView ) )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==RULE_ID) ) {
                    int LA1_1 = input.LA(2);

                    if ( (LA1_1==14) ) {
                        alt1=1;
                    }


                }


                switch (alt1) {
            	case 1 :
            	    // InternalSPViz.g:166:4: (lv_views_7_0= ruleView )
            	    {
            	    // InternalSPViz.g:166:4: (lv_views_7_0= ruleView )
            	    // InternalSPViz.g:167:5: lv_views_7_0= ruleView
            	    {

            	    					newCompositeNode(grammarAccess.getSPVizAccess().getViewsViewParserRuleCall_7_0());
            	    				
            	    pushFollow(FOLLOW_8);
            	    lv_views_7_0=ruleView();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getSPVizRule());
            	    					}
            	    					add(
            	    						current,
            	    						"views",
            	    						lv_views_7_0,
            	    						"de.cau.cs.kieler.spviz.spviz.SPViz.View");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

            // InternalSPViz.g:184:3: ( (lv_artifactShows_8_0= ruleArtifactShows ) )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==RULE_ID) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // InternalSPViz.g:185:4: (lv_artifactShows_8_0= ruleArtifactShows )
            	    {
            	    // InternalSPViz.g:185:4: (lv_artifactShows_8_0= ruleArtifactShows )
            	    // InternalSPViz.g:186:5: lv_artifactShows_8_0= ruleArtifactShows
            	    {

            	    					newCompositeNode(grammarAccess.getSPVizAccess().getArtifactShowsArtifactShowsParserRuleCall_8_0());
            	    				
            	    pushFollow(FOLLOW_8);
            	    lv_artifactShows_8_0=ruleArtifactShows();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getSPVizRule());
            	    					}
            	    					add(
            	    						current,
            	    						"artifactShows",
            	    						lv_artifactShows_8_0,
            	    						"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactShows");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop2;
                }
            } while (true);

            otherlv_9=(Token)match(input,15,FOLLOW_2); 

            			newLeafNode(otherlv_9, grammarAccess.getSPVizAccess().getRightCurlyBracketKeyword_9());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleSPViz"


    // $ANTLR start "entryRuleView"
    // InternalSPViz.g:211:1: entryRuleView returns [EObject current=null] : iv_ruleView= ruleView EOF ;
    public final EObject entryRuleView() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleView = null;


        try {
            // InternalSPViz.g:211:45: (iv_ruleView= ruleView EOF )
            // InternalSPViz.g:212:2: iv_ruleView= ruleView EOF
            {
             newCompositeNode(grammarAccess.getViewRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleView=ruleView();

            state._fsp--;

             current =iv_ruleView; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleView"


    // $ANTLR start "ruleView"
    // InternalSPViz.g:218:1: ruleView returns [EObject current=null] : ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= '{' ( (lv_shownElements_2_0= ruleShownElement ) )* ( (lv_shownConnections_3_0= ruleShownConnection ) )* ( (lv_shownCategoryConnections_4_0= ruleShownCategoryConnection ) )* otherlv_5= '}' ) ;
    public final EObject ruleView() throws RecognitionException {
        EObject current = null;

        Token lv_name_0_0=null;
        Token otherlv_1=null;
        Token otherlv_5=null;
        EObject lv_shownElements_2_0 = null;

        EObject lv_shownConnections_3_0 = null;

        EObject lv_shownCategoryConnections_4_0 = null;



        	enterRule();

        try {
            // InternalSPViz.g:224:2: ( ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= '{' ( (lv_shownElements_2_0= ruleShownElement ) )* ( (lv_shownConnections_3_0= ruleShownConnection ) )* ( (lv_shownCategoryConnections_4_0= ruleShownCategoryConnection ) )* otherlv_5= '}' ) )
            // InternalSPViz.g:225:2: ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= '{' ( (lv_shownElements_2_0= ruleShownElement ) )* ( (lv_shownConnections_3_0= ruleShownConnection ) )* ( (lv_shownCategoryConnections_4_0= ruleShownCategoryConnection ) )* otherlv_5= '}' )
            {
            // InternalSPViz.g:225:2: ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= '{' ( (lv_shownElements_2_0= ruleShownElement ) )* ( (lv_shownConnections_3_0= ruleShownConnection ) )* ( (lv_shownCategoryConnections_4_0= ruleShownCategoryConnection ) )* otherlv_5= '}' )
            // InternalSPViz.g:226:3: ( (lv_name_0_0= RULE_ID ) ) otherlv_1= '{' ( (lv_shownElements_2_0= ruleShownElement ) )* ( (lv_shownConnections_3_0= ruleShownConnection ) )* ( (lv_shownCategoryConnections_4_0= ruleShownCategoryConnection ) )* otherlv_5= '}'
            {
            // InternalSPViz.g:226:3: ( (lv_name_0_0= RULE_ID ) )
            // InternalSPViz.g:227:4: (lv_name_0_0= RULE_ID )
            {
            // InternalSPViz.g:227:4: (lv_name_0_0= RULE_ID )
            // InternalSPViz.g:228:5: lv_name_0_0= RULE_ID
            {
            lv_name_0_0=(Token)match(input,RULE_ID,FOLLOW_7); 

            					newLeafNode(lv_name_0_0, grammarAccess.getViewAccess().getNameIDTerminalRuleCall_0_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getViewRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_0_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            otherlv_1=(Token)match(input,14,FOLLOW_9); 

            			newLeafNode(otherlv_1, grammarAccess.getViewAccess().getLeftCurlyBracketKeyword_1());
            		
            // InternalSPViz.g:248:3: ( (lv_shownElements_2_0= ruleShownElement ) )*
            loop3:
            do {
                int alt3=2;
                int LA3_0 = input.LA(1);

                if ( (LA3_0==20) ) {
                    alt3=1;
                }


                switch (alt3) {
            	case 1 :
            	    // InternalSPViz.g:249:4: (lv_shownElements_2_0= ruleShownElement )
            	    {
            	    // InternalSPViz.g:249:4: (lv_shownElements_2_0= ruleShownElement )
            	    // InternalSPViz.g:250:5: lv_shownElements_2_0= ruleShownElement
            	    {

            	    					newCompositeNode(grammarAccess.getViewAccess().getShownElementsShownElementParserRuleCall_2_0());
            	    				
            	    pushFollow(FOLLOW_9);
            	    lv_shownElements_2_0=ruleShownElement();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getViewRule());
            	    					}
            	    					add(
            	    						current,
            	    						"shownElements",
            	    						lv_shownElements_2_0,
            	    						"de.cau.cs.kieler.spviz.spviz.SPViz.ShownElement");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop3;
                }
            } while (true);

            // InternalSPViz.g:267:3: ( (lv_shownConnections_3_0= ruleShownConnection ) )*
            loop4:
            do {
                int alt4=2;
                alt4 = dfa4.predict(input);
                switch (alt4) {
            	case 1 :
            	    // InternalSPViz.g:268:4: (lv_shownConnections_3_0= ruleShownConnection )
            	    {
            	    // InternalSPViz.g:268:4: (lv_shownConnections_3_0= ruleShownConnection )
            	    // InternalSPViz.g:269:5: lv_shownConnections_3_0= ruleShownConnection
            	    {

            	    					newCompositeNode(grammarAccess.getViewAccess().getShownConnectionsShownConnectionParserRuleCall_3_0());
            	    				
            	    pushFollow(FOLLOW_10);
            	    lv_shownConnections_3_0=ruleShownConnection();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getViewRule());
            	    					}
            	    					add(
            	    						current,
            	    						"shownConnections",
            	    						lv_shownConnections_3_0,
            	    						"de.cau.cs.kieler.spviz.spviz.SPViz.ShownConnection");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop4;
                }
            } while (true);

            // InternalSPViz.g:286:3: ( (lv_shownCategoryConnections_4_0= ruleShownCategoryConnection ) )*
            loop5:
            do {
                int alt5=2;
                int LA5_0 = input.LA(1);

                if ( (LA5_0==22) ) {
                    alt5=1;
                }


                switch (alt5) {
            	case 1 :
            	    // InternalSPViz.g:287:4: (lv_shownCategoryConnections_4_0= ruleShownCategoryConnection )
            	    {
            	    // InternalSPViz.g:287:4: (lv_shownCategoryConnections_4_0= ruleShownCategoryConnection )
            	    // InternalSPViz.g:288:5: lv_shownCategoryConnections_4_0= ruleShownCategoryConnection
            	    {

            	    					newCompositeNode(grammarAccess.getViewAccess().getShownCategoryConnectionsShownCategoryConnectionParserRuleCall_4_0());
            	    				
            	    pushFollow(FOLLOW_10);
            	    lv_shownCategoryConnections_4_0=ruleShownCategoryConnection();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getViewRule());
            	    					}
            	    					add(
            	    						current,
            	    						"shownCategoryConnections",
            	    						lv_shownCategoryConnections_4_0,
            	    						"de.cau.cs.kieler.spviz.spviz.SPViz.ShownCategoryConnection");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop5;
                }
            } while (true);

            otherlv_5=(Token)match(input,15,FOLLOW_2); 

            			newLeafNode(otherlv_5, grammarAccess.getViewAccess().getRightCurlyBracketKeyword_5());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleView"


    // $ANTLR start "entryRuleArtifactShows"
    // InternalSPViz.g:313:1: entryRuleArtifactShows returns [EObject current=null] : iv_ruleArtifactShows= ruleArtifactShows EOF ;
    public final EObject entryRuleArtifactShows() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleArtifactShows = null;


        try {
            // InternalSPViz.g:313:54: (iv_ruleArtifactShows= ruleArtifactShows EOF )
            // InternalSPViz.g:314:2: iv_ruleArtifactShows= ruleArtifactShows EOF
            {
             newCompositeNode(grammarAccess.getArtifactShowsRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleArtifactShows=ruleArtifactShows();

            state._fsp--;

             current =iv_ruleArtifactShows; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleArtifactShows"


    // $ANTLR start "ruleArtifactShows"
    // InternalSPViz.g:320:1: ruleArtifactShows returns [EObject current=null] : ( ( ( ruleQualifiedName ) ) otherlv_1= 'shows' otherlv_2= '{' ( (lv_views_3_0= ruleArtifactView ) )* otherlv_4= '}' ) ;
    public final EObject ruleArtifactShows() throws RecognitionException {
        EObject current = null;

        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        EObject lv_views_3_0 = null;



        	enterRule();

        try {
            // InternalSPViz.g:326:2: ( ( ( ( ruleQualifiedName ) ) otherlv_1= 'shows' otherlv_2= '{' ( (lv_views_3_0= ruleArtifactView ) )* otherlv_4= '}' ) )
            // InternalSPViz.g:327:2: ( ( ( ruleQualifiedName ) ) otherlv_1= 'shows' otherlv_2= '{' ( (lv_views_3_0= ruleArtifactView ) )* otherlv_4= '}' )
            {
            // InternalSPViz.g:327:2: ( ( ( ruleQualifiedName ) ) otherlv_1= 'shows' otherlv_2= '{' ( (lv_views_3_0= ruleArtifactView ) )* otherlv_4= '}' )
            // InternalSPViz.g:328:3: ( ( ruleQualifiedName ) ) otherlv_1= 'shows' otherlv_2= '{' ( (lv_views_3_0= ruleArtifactView ) )* otherlv_4= '}'
            {
            // InternalSPViz.g:328:3: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:329:4: ( ruleQualifiedName )
            {
            // InternalSPViz.g:329:4: ( ruleQualifiedName )
            // InternalSPViz.g:330:5: ruleQualifiedName
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getArtifactShowsRule());
            					}
            				

            					newCompositeNode(grammarAccess.getArtifactShowsAccess().getArtifactShowsArtifactCrossReference_0_0());
            				
            pushFollow(FOLLOW_11);
            ruleQualifiedName();

            state._fsp--;


            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_1=(Token)match(input,16,FOLLOW_7); 

            			newLeafNode(otherlv_1, grammarAccess.getArtifactShowsAccess().getShowsKeyword_1());
            		
            otherlv_2=(Token)match(input,14,FOLLOW_8); 

            			newLeafNode(otherlv_2, grammarAccess.getArtifactShowsAccess().getLeftCurlyBracketKeyword_2());
            		
            // InternalSPViz.g:352:3: ( (lv_views_3_0= ruleArtifactView ) )*
            loop6:
            do {
                int alt6=2;
                int LA6_0 = input.LA(1);

                if ( (LA6_0==RULE_ID) ) {
                    alt6=1;
                }


                switch (alt6) {
            	case 1 :
            	    // InternalSPViz.g:353:4: (lv_views_3_0= ruleArtifactView )
            	    {
            	    // InternalSPViz.g:353:4: (lv_views_3_0= ruleArtifactView )
            	    // InternalSPViz.g:354:5: lv_views_3_0= ruleArtifactView
            	    {

            	    					newCompositeNode(grammarAccess.getArtifactShowsAccess().getViewsArtifactViewParserRuleCall_3_0());
            	    				
            	    pushFollow(FOLLOW_8);
            	    lv_views_3_0=ruleArtifactView();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getArtifactShowsRule());
            	    					}
            	    					add(
            	    						current,
            	    						"views",
            	    						lv_views_3_0,
            	    						"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactView");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop6;
                }
            } while (true);

            otherlv_4=(Token)match(input,15,FOLLOW_2); 

            			newLeafNode(otherlv_4, grammarAccess.getArtifactShowsAccess().getRightCurlyBracketKeyword_4());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleArtifactShows"


    // $ANTLR start "entryRuleArtifactView"
    // InternalSPViz.g:379:1: entryRuleArtifactView returns [EObject current=null] : iv_ruleArtifactView= ruleArtifactView EOF ;
    public final EObject entryRuleArtifactView() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleArtifactView = null;


        try {
            // InternalSPViz.g:379:53: (iv_ruleArtifactView= ruleArtifactView EOF )
            // InternalSPViz.g:380:2: iv_ruleArtifactView= ruleArtifactView EOF
            {
             newCompositeNode(grammarAccess.getArtifactViewRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleArtifactView=ruleArtifactView();

            state._fsp--;

             current =iv_ruleArtifactView; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleArtifactView"


    // $ANTLR start "ruleArtifactView"
    // InternalSPViz.g:386:1: ruleArtifactView returns [EObject current=null] : ( ( (otherlv_0= RULE_ID ) ) otherlv_1= 'with' otherlv_2= '{' ( (lv_sources_3_0= ruleArtifactSource ) )* otherlv_4= '}' ) ;
    public final EObject ruleArtifactView() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        EObject lv_sources_3_0 = null;



        	enterRule();

        try {
            // InternalSPViz.g:392:2: ( ( ( (otherlv_0= RULE_ID ) ) otherlv_1= 'with' otherlv_2= '{' ( (lv_sources_3_0= ruleArtifactSource ) )* otherlv_4= '}' ) )
            // InternalSPViz.g:393:2: ( ( (otherlv_0= RULE_ID ) ) otherlv_1= 'with' otherlv_2= '{' ( (lv_sources_3_0= ruleArtifactSource ) )* otherlv_4= '}' )
            {
            // InternalSPViz.g:393:2: ( ( (otherlv_0= RULE_ID ) ) otherlv_1= 'with' otherlv_2= '{' ( (lv_sources_3_0= ruleArtifactSource ) )* otherlv_4= '}' )
            // InternalSPViz.g:394:3: ( (otherlv_0= RULE_ID ) ) otherlv_1= 'with' otherlv_2= '{' ( (lv_sources_3_0= ruleArtifactSource ) )* otherlv_4= '}'
            {
            // InternalSPViz.g:394:3: ( (otherlv_0= RULE_ID ) )
            // InternalSPViz.g:395:4: (otherlv_0= RULE_ID )
            {
            // InternalSPViz.g:395:4: (otherlv_0= RULE_ID )
            // InternalSPViz.g:396:5: otherlv_0= RULE_ID
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getArtifactViewRule());
            					}
            				
            otherlv_0=(Token)match(input,RULE_ID,FOLLOW_12); 

            					newLeafNode(otherlv_0, grammarAccess.getArtifactViewAccess().getViewViewCrossReference_0_0());
            				

            }


            }

            otherlv_1=(Token)match(input,17,FOLLOW_7); 

            			newLeafNode(otherlv_1, grammarAccess.getArtifactViewAccess().getWithKeyword_1());
            		
            otherlv_2=(Token)match(input,14,FOLLOW_8); 

            			newLeafNode(otherlv_2, grammarAccess.getArtifactViewAccess().getLeftCurlyBracketKeyword_2());
            		
            // InternalSPViz.g:415:3: ( (lv_sources_3_0= ruleArtifactSource ) )*
            loop7:
            do {
                int alt7=2;
                int LA7_0 = input.LA(1);

                if ( (LA7_0==RULE_ID) ) {
                    alt7=1;
                }


                switch (alt7) {
            	case 1 :
            	    // InternalSPViz.g:416:4: (lv_sources_3_0= ruleArtifactSource )
            	    {
            	    // InternalSPViz.g:416:4: (lv_sources_3_0= ruleArtifactSource )
            	    // InternalSPViz.g:417:5: lv_sources_3_0= ruleArtifactSource
            	    {

            	    					newCompositeNode(grammarAccess.getArtifactViewAccess().getSourcesArtifactSourceParserRuleCall_3_0());
            	    				
            	    pushFollow(FOLLOW_8);
            	    lv_sources_3_0=ruleArtifactSource();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getArtifactViewRule());
            	    					}
            	    					add(
            	    						current,
            	    						"sources",
            	    						lv_sources_3_0,
            	    						"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactSource");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop7;
                }
            } while (true);

            otherlv_4=(Token)match(input,15,FOLLOW_2); 

            			newLeafNode(otherlv_4, grammarAccess.getArtifactViewAccess().getRightCurlyBracketKeyword_4());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleArtifactView"


    // $ANTLR start "entryRuleArtifactSource"
    // InternalSPViz.g:442:1: entryRuleArtifactSource returns [EObject current=null] : iv_ruleArtifactSource= ruleArtifactSource EOF ;
    public final EObject entryRuleArtifactSource() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleArtifactSource = null;


        try {
            // InternalSPViz.g:442:55: (iv_ruleArtifactSource= ruleArtifactSource EOF )
            // InternalSPViz.g:443:2: iv_ruleArtifactSource= ruleArtifactSource EOF
            {
             newCompositeNode(grammarAccess.getArtifactSourceRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleArtifactSource=ruleArtifactSource();

            state._fsp--;

             current =iv_ruleArtifactSource; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleArtifactSource"


    // $ANTLR start "ruleArtifactSource"
    // InternalSPViz.g:449:1: ruleArtifactSource returns [EObject current=null] : ( ( ( ruleQualifiedName ) ) otherlv_1= 'from' ( (lv_sourceChain_2_0= ruleArtifactChain ) ) ) ;
    public final EObject ruleArtifactSource() throws RecognitionException {
        EObject current = null;

        Token otherlv_1=null;
        EObject lv_sourceChain_2_0 = null;



        	enterRule();

        try {
            // InternalSPViz.g:455:2: ( ( ( ( ruleQualifiedName ) ) otherlv_1= 'from' ( (lv_sourceChain_2_0= ruleArtifactChain ) ) ) )
            // InternalSPViz.g:456:2: ( ( ( ruleQualifiedName ) ) otherlv_1= 'from' ( (lv_sourceChain_2_0= ruleArtifactChain ) ) )
            {
            // InternalSPViz.g:456:2: ( ( ( ruleQualifiedName ) ) otherlv_1= 'from' ( (lv_sourceChain_2_0= ruleArtifactChain ) ) )
            // InternalSPViz.g:457:3: ( ( ruleQualifiedName ) ) otherlv_1= 'from' ( (lv_sourceChain_2_0= ruleArtifactChain ) )
            {
            // InternalSPViz.g:457:3: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:458:4: ( ruleQualifiedName )
            {
            // InternalSPViz.g:458:4: ( ruleQualifiedName )
            // InternalSPViz.g:459:5: ruleQualifiedName
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getArtifactSourceRule());
            					}
            				

            					newCompositeNode(grammarAccess.getArtifactSourceAccess().getArtifactArtifactCrossReference_0_0());
            				
            pushFollow(FOLLOW_13);
            ruleQualifiedName();

            state._fsp--;


            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_1=(Token)match(input,18,FOLLOW_3); 

            			newLeafNode(otherlv_1, grammarAccess.getArtifactSourceAccess().getFromKeyword_1());
            		
            // InternalSPViz.g:477:3: ( (lv_sourceChain_2_0= ruleArtifactChain ) )
            // InternalSPViz.g:478:4: (lv_sourceChain_2_0= ruleArtifactChain )
            {
            // InternalSPViz.g:478:4: (lv_sourceChain_2_0= ruleArtifactChain )
            // InternalSPViz.g:479:5: lv_sourceChain_2_0= ruleArtifactChain
            {

            					newCompositeNode(grammarAccess.getArtifactSourceAccess().getSourceChainArtifactChainParserRuleCall_2_0());
            				
            pushFollow(FOLLOW_2);
            lv_sourceChain_2_0=ruleArtifactChain();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getArtifactSourceRule());
            					}
            					set(
            						current,
            						"sourceChain",
            						lv_sourceChain_2_0,
            						"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactChain");
            					afterParserOrEnumRuleCall();
            				

            }


            }


            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleArtifactSource"


    // $ANTLR start "entryRuleArtifactChain"
    // InternalSPViz.g:500:1: entryRuleArtifactChain returns [EObject current=null] : iv_ruleArtifactChain= ruleArtifactChain EOF ;
    public final EObject entryRuleArtifactChain() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleArtifactChain = null;


        try {
            // InternalSPViz.g:500:54: (iv_ruleArtifactChain= ruleArtifactChain EOF )
            // InternalSPViz.g:501:2: iv_ruleArtifactChain= ruleArtifactChain EOF
            {
             newCompositeNode(grammarAccess.getArtifactChainRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleArtifactChain=ruleArtifactChain();

            state._fsp--;

             current =iv_ruleArtifactChain; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleArtifactChain"


    // $ANTLR start "ruleArtifactChain"
    // InternalSPViz.g:507:1: ruleArtifactChain returns [EObject current=null] : ( ( ( ruleQualifiedName ) ) (otherlv_1= '>' ( (lv_further_2_0= ruleArtifactChain ) ) )? ) ;
    public final EObject ruleArtifactChain() throws RecognitionException {
        EObject current = null;

        Token otherlv_1=null;
        EObject lv_further_2_0 = null;



        	enterRule();

        try {
            // InternalSPViz.g:513:2: ( ( ( ( ruleQualifiedName ) ) (otherlv_1= '>' ( (lv_further_2_0= ruleArtifactChain ) ) )? ) )
            // InternalSPViz.g:514:2: ( ( ( ruleQualifiedName ) ) (otherlv_1= '>' ( (lv_further_2_0= ruleArtifactChain ) ) )? )
            {
            // InternalSPViz.g:514:2: ( ( ( ruleQualifiedName ) ) (otherlv_1= '>' ( (lv_further_2_0= ruleArtifactChain ) ) )? )
            // InternalSPViz.g:515:3: ( ( ruleQualifiedName ) ) (otherlv_1= '>' ( (lv_further_2_0= ruleArtifactChain ) ) )?
            {
            // InternalSPViz.g:515:3: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:516:4: ( ruleQualifiedName )
            {
            // InternalSPViz.g:516:4: ( ruleQualifiedName )
            // InternalSPViz.g:517:5: ruleQualifiedName
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getArtifactChainRule());
            					}
            				

            					newCompositeNode(grammarAccess.getArtifactChainAccess().getSourceArtifactCrossReference_0_0());
            				
            pushFollow(FOLLOW_14);
            ruleQualifiedName();

            state._fsp--;


            					afterParserOrEnumRuleCall();
            				

            }


            }

            // InternalSPViz.g:531:3: (otherlv_1= '>' ( (lv_further_2_0= ruleArtifactChain ) ) )?
            int alt8=2;
            int LA8_0 = input.LA(1);

            if ( (LA8_0==19) ) {
                alt8=1;
            }
            switch (alt8) {
                case 1 :
                    // InternalSPViz.g:532:4: otherlv_1= '>' ( (lv_further_2_0= ruleArtifactChain ) )
                    {
                    otherlv_1=(Token)match(input,19,FOLLOW_3); 

                    				newLeafNode(otherlv_1, grammarAccess.getArtifactChainAccess().getGreaterThanSignKeyword_1_0());
                    			
                    // InternalSPViz.g:536:4: ( (lv_further_2_0= ruleArtifactChain ) )
                    // InternalSPViz.g:537:5: (lv_further_2_0= ruleArtifactChain )
                    {
                    // InternalSPViz.g:537:5: (lv_further_2_0= ruleArtifactChain )
                    // InternalSPViz.g:538:6: lv_further_2_0= ruleArtifactChain
                    {

                    						newCompositeNode(grammarAccess.getArtifactChainAccess().getFurtherArtifactChainParserRuleCall_1_1_0());
                    					
                    pushFollow(FOLLOW_2);
                    lv_further_2_0=ruleArtifactChain();

                    state._fsp--;


                    						if (current==null) {
                    							current = createModelElementForParent(grammarAccess.getArtifactChainRule());
                    						}
                    						set(
                    							current,
                    							"further",
                    							lv_further_2_0,
                    							"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactChain");
                    						afterParserOrEnumRuleCall();
                    					

                    }


                    }


                    }
                    break;

            }


            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleArtifactChain"


    // $ANTLR start "entryRuleShownElement"
    // InternalSPViz.g:560:1: entryRuleShownElement returns [EObject current=null] : iv_ruleShownElement= ruleShownElement EOF ;
    public final EObject entryRuleShownElement() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleShownElement = null;


        try {
            // InternalSPViz.g:560:53: (iv_ruleShownElement= ruleShownElement EOF )
            // InternalSPViz.g:561:2: iv_ruleShownElement= ruleShownElement EOF
            {
             newCompositeNode(grammarAccess.getShownElementRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleShownElement=ruleShownElement();

            state._fsp--;

             current =iv_ruleShownElement; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleShownElement"


    // $ANTLR start "ruleShownElement"
    // InternalSPViz.g:567:1: ruleShownElement returns [EObject current=null] : (otherlv_0= 'show' ( ( ruleQualifiedName ) ) (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )? ) ;
    public final EObject ruleShownElement() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_2=null;


        	enterRule();

        try {
            // InternalSPViz.g:573:2: ( (otherlv_0= 'show' ( ( ruleQualifiedName ) ) (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )? ) )
            // InternalSPViz.g:574:2: (otherlv_0= 'show' ( ( ruleQualifiedName ) ) (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )? )
            {
            // InternalSPViz.g:574:2: (otherlv_0= 'show' ( ( ruleQualifiedName ) ) (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )? )
            // InternalSPViz.g:575:3: otherlv_0= 'show' ( ( ruleQualifiedName ) ) (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )?
            {
            otherlv_0=(Token)match(input,20,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getShownElementAccess().getShowKeyword_0());
            		
            // InternalSPViz.g:579:3: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:580:4: ( ruleQualifiedName )
            {
            // InternalSPViz.g:580:4: ( ruleQualifiedName )
            // InternalSPViz.g:581:5: ruleQualifiedName
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getShownElementRule());
            					}
            				

            					newCompositeNode(grammarAccess.getShownElementAccess().getShownElementArtifactCrossReference_1_0());
            				
            pushFollow(FOLLOW_15);
            ruleQualifiedName();

            state._fsp--;


            					afterParserOrEnumRuleCall();
            				

            }


            }

            // InternalSPViz.g:595:3: (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )?
            int alt9=2;
            int LA9_0 = input.LA(1);

            if ( (LA9_0==21) ) {
                alt9=1;
            }
            switch (alt9) {
                case 1 :
                    // InternalSPViz.g:596:4: otherlv_2= 'in' ( ( ruleQualifiedName ) )
                    {
                    otherlv_2=(Token)match(input,21,FOLLOW_3); 

                    				newLeafNode(otherlv_2, grammarAccess.getShownElementAccess().getInKeyword_2_0());
                    			
                    // InternalSPViz.g:600:4: ( ( ruleQualifiedName ) )
                    // InternalSPViz.g:601:5: ( ruleQualifiedName )
                    {
                    // InternalSPViz.g:601:5: ( ruleQualifiedName )
                    // InternalSPViz.g:602:6: ruleQualifiedName
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getShownElementRule());
                    						}
                    					

                    						newCompositeNode(grammarAccess.getShownElementAccess().getContainedInArtifactCrossReference_2_1_0());
                    					
                    pushFollow(FOLLOW_2);
                    ruleQualifiedName();

                    state._fsp--;


                    						afterParserOrEnumRuleCall();
                    					

                    }


                    }


                    }
                    break;

            }


            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleShownElement"


    // $ANTLR start "entryRuleShownConnection"
    // InternalSPViz.g:621:1: entryRuleShownConnection returns [EObject current=null] : iv_ruleShownConnection= ruleShownConnection EOF ;
    public final EObject entryRuleShownConnection() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleShownConnection = null;


        try {
            // InternalSPViz.g:621:56: (iv_ruleShownConnection= ruleShownConnection EOF )
            // InternalSPViz.g:622:2: iv_ruleShownConnection= ruleShownConnection EOF
            {
             newCompositeNode(grammarAccess.getShownConnectionRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleShownConnection=ruleShownConnection();

            state._fsp--;

             current =iv_ruleShownConnection; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleShownConnection"


    // $ANTLR start "ruleShownConnection"
    // InternalSPViz.g:628:1: ruleShownConnection returns [EObject current=null] : (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) ) ;
    public final EObject ruleShownConnection() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;


        	enterRule();

        try {
            // InternalSPViz.g:634:2: ( (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) ) )
            // InternalSPViz.g:635:2: (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) )
            {
            // InternalSPViz.g:635:2: (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:636:3: otherlv_0= 'connect' ( ( ruleQualifiedName ) )
            {
            otherlv_0=(Token)match(input,22,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getShownConnectionAccess().getConnectKeyword_0());
            		
            // InternalSPViz.g:640:3: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:641:4: ( ruleQualifiedName )
            {
            // InternalSPViz.g:641:4: ( ruleQualifiedName )
            // InternalSPViz.g:642:5: ruleQualifiedName
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getShownConnectionRule());
            					}
            				

            					newCompositeNode(grammarAccess.getShownConnectionAccess().getShownConnectionConnectionCrossReference_1_0());
            				
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;


            					afterParserOrEnumRuleCall();
            				

            }


            }


            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleShownConnection"


    // $ANTLR start "entryRuleShownCategoryConnection"
    // InternalSPViz.g:660:1: entryRuleShownCategoryConnection returns [EObject current=null] : iv_ruleShownCategoryConnection= ruleShownCategoryConnection EOF ;
    public final EObject entryRuleShownCategoryConnection() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleShownCategoryConnection = null;


        try {
            // InternalSPViz.g:660:64: (iv_ruleShownCategoryConnection= ruleShownCategoryConnection EOF )
            // InternalSPViz.g:661:2: iv_ruleShownCategoryConnection= ruleShownCategoryConnection EOF
            {
             newCompositeNode(grammarAccess.getShownCategoryConnectionRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleShownCategoryConnection=ruleShownCategoryConnection();

            state._fsp--;

             current =iv_ruleShownCategoryConnection; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleShownCategoryConnection"


    // $ANTLR start "ruleShownCategoryConnection"
    // InternalSPViz.g:667:1: ruleShownCategoryConnection returns [EObject current=null] : (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) otherlv_2= 'via' ( (lv_sourceChain_3_0= ruleArtifactChain ) ) ) ;
    public final EObject ruleShownCategoryConnection() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_2=null;
        EObject lv_sourceChain_3_0 = null;



        	enterRule();

        try {
            // InternalSPViz.g:673:2: ( (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) otherlv_2= 'via' ( (lv_sourceChain_3_0= ruleArtifactChain ) ) ) )
            // InternalSPViz.g:674:2: (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) otherlv_2= 'via' ( (lv_sourceChain_3_0= ruleArtifactChain ) ) )
            {
            // InternalSPViz.g:674:2: (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) otherlv_2= 'via' ( (lv_sourceChain_3_0= ruleArtifactChain ) ) )
            // InternalSPViz.g:675:3: otherlv_0= 'connect' ( ( ruleQualifiedName ) ) otherlv_2= 'via' ( (lv_sourceChain_3_0= ruleArtifactChain ) )
            {
            otherlv_0=(Token)match(input,22,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getShownCategoryConnectionAccess().getConnectKeyword_0());
            		
            // InternalSPViz.g:679:3: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:680:4: ( ruleQualifiedName )
            {
            // InternalSPViz.g:680:4: ( ruleQualifiedName )
            // InternalSPViz.g:681:5: ruleQualifiedName
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getShownCategoryConnectionRule());
            					}
            				

            					newCompositeNode(grammarAccess.getShownCategoryConnectionAccess().getConnectionConnectionCrossReference_1_0());
            				
            pushFollow(FOLLOW_16);
            ruleQualifiedName();

            state._fsp--;


            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_2=(Token)match(input,23,FOLLOW_3); 

            			newLeafNode(otherlv_2, grammarAccess.getShownCategoryConnectionAccess().getViaKeyword_2());
            		
            // InternalSPViz.g:699:3: ( (lv_sourceChain_3_0= ruleArtifactChain ) )
            // InternalSPViz.g:700:4: (lv_sourceChain_3_0= ruleArtifactChain )
            {
            // InternalSPViz.g:700:4: (lv_sourceChain_3_0= ruleArtifactChain )
            // InternalSPViz.g:701:5: lv_sourceChain_3_0= ruleArtifactChain
            {

            					newCompositeNode(grammarAccess.getShownCategoryConnectionAccess().getSourceChainArtifactChainParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_2);
            lv_sourceChain_3_0=ruleArtifactChain();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getShownCategoryConnectionRule());
            					}
            					set(
            						current,
            						"sourceChain",
            						lv_sourceChain_3_0,
            						"de.cau.cs.kieler.spviz.spviz.SPViz.ArtifactChain");
            					afterParserOrEnumRuleCall();
            				

            }


            }


            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleShownCategoryConnection"


    // $ANTLR start "entryRuleQualifiedName"
    // InternalSPViz.g:722:1: entryRuleQualifiedName returns [String current=null] : iv_ruleQualifiedName= ruleQualifiedName EOF ;
    public final String entryRuleQualifiedName() throws RecognitionException {
        String current = null;

        AntlrDatatypeRuleToken iv_ruleQualifiedName = null;


        try {
            // InternalSPViz.g:722:53: (iv_ruleQualifiedName= ruleQualifiedName EOF )
            // InternalSPViz.g:723:2: iv_ruleQualifiedName= ruleQualifiedName EOF
            {
             newCompositeNode(grammarAccess.getQualifiedNameRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleQualifiedName=ruleQualifiedName();

            state._fsp--;

             current =iv_ruleQualifiedName.getText(); 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleQualifiedName"


    // $ANTLR start "ruleQualifiedName"
    // InternalSPViz.g:729:1: ruleQualifiedName returns [AntlrDatatypeRuleToken current=new AntlrDatatypeRuleToken()] : (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* ) ;
    public final AntlrDatatypeRuleToken ruleQualifiedName() throws RecognitionException {
        AntlrDatatypeRuleToken current = new AntlrDatatypeRuleToken();

        Token this_ID_0=null;
        Token kw=null;
        Token this_ID_2=null;


        	enterRule();

        try {
            // InternalSPViz.g:735:2: ( (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* ) )
            // InternalSPViz.g:736:2: (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* )
            {
            // InternalSPViz.g:736:2: (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* )
            // InternalSPViz.g:737:3: this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )*
            {
            this_ID_0=(Token)match(input,RULE_ID,FOLLOW_17); 

            			current.merge(this_ID_0);
            		

            			newLeafNode(this_ID_0, grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_0());
            		
            // InternalSPViz.g:744:3: (kw= '.' this_ID_2= RULE_ID )*
            loop10:
            do {
                int alt10=2;
                int LA10_0 = input.LA(1);

                if ( (LA10_0==24) ) {
                    alt10=1;
                }


                switch (alt10) {
            	case 1 :
            	    // InternalSPViz.g:745:4: kw= '.' this_ID_2= RULE_ID
            	    {
            	    kw=(Token)match(input,24,FOLLOW_3); 

            	    				current.merge(kw);
            	    				newLeafNode(kw, grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0());
            	    			
            	    this_ID_2=(Token)match(input,RULE_ID,FOLLOW_17); 

            	    				current.merge(this_ID_2);
            	    			

            	    				newLeafNode(this_ID_2, grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_1_1());
            	    			

            	    }
            	    break;

            	default :
            	    break loop10;
                }
            } while (true);


            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleQualifiedName"

    // Delegated rules


    protected DFA4 dfa4 = new DFA4(this);
    static final String dfa_1s = "\7\uffff";
    static final String dfa_2s = "\1\17\1\5\1\uffff\1\17\1\5\1\uffff\1\17";
    static final String dfa_3s = "\1\26\1\5\1\uffff\1\30\1\5\1\uffff\1\30";
    static final String dfa_4s = "\2\uffff\1\2\2\uffff\1\1\1\uffff";
    static final String dfa_5s = "\7\uffff}>";
    static final String[] dfa_6s = {
            "\1\2\6\uffff\1\1",
            "\1\3",
            "",
            "\1\5\6\uffff\1\5\1\2\1\4",
            "\1\6",
            "",
            "\1\5\6\uffff\1\5\1\2\1\4"
    };

    static final short[] dfa_1 = DFA.unpackEncodedString(dfa_1s);
    static final char[] dfa_2 = DFA.unpackEncodedStringToUnsignedChars(dfa_2s);
    static final char[] dfa_3 = DFA.unpackEncodedStringToUnsignedChars(dfa_3s);
    static final short[] dfa_4 = DFA.unpackEncodedString(dfa_4s);
    static final short[] dfa_5 = DFA.unpackEncodedString(dfa_5s);
    static final short[][] dfa_6 = unpackEncodedStringArray(dfa_6s);

    class DFA4 extends DFA {

        public DFA4(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 4;
            this.eot = dfa_1;
            this.eof = dfa_1;
            this.min = dfa_2;
            this.max = dfa_3;
            this.accept = dfa_4;
            this.special = dfa_5;
            this.transition = dfa_6;
        }
        public String getDescription() {
            return "()* loopback of 267:3: ( (lv_shownConnections_3_0= ruleShownConnection ) )*";
        }
    }
 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000020L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000004000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000000008020L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000508000L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000000408000L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000000020000L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x0000000000040000L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000000080002L});
    public static final BitSet FOLLOW_15 = new BitSet(new long[]{0x0000000000200002L});
    public static final BitSet FOLLOW_16 = new BitSet(new long[]{0x0000000000800000L});
    public static final BitSet FOLLOW_17 = new BitSet(new long[]{0x0000000001000002L});

}