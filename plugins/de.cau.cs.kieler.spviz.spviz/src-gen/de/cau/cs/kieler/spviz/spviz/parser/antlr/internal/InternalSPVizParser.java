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
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'use'", "'SPViz'", "'{'", "'}'", "'show'", "'in'", "'connect'", "'via'", "'.'"
    };
    public static final int RULE_STRING=6;
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
    public static final int RULE_ID=4;
    public static final int RULE_WS=9;
    public static final int RULE_ANY_OTHER=10;
    public static final int RULE_INT=5;
    public static final int RULE_ML_COMMENT=7;

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
    // InternalSPViz.g:64:1: entryRuleSPViz returns [EObject current=null] : iv_ruleSPViz= ruleSPViz EOF ;
    public final EObject entryRuleSPViz() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleSPViz = null;


        try {
            // InternalSPViz.g:64:46: (iv_ruleSPViz= ruleSPViz EOF )
            // InternalSPViz.g:65:2: iv_ruleSPViz= ruleSPViz EOF
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
    // InternalSPViz.g:71:1: ruleSPViz returns [EObject current=null] : (otherlv_0= 'use' ( (lv_importedNamespace_1_0= ruleQualifiedName ) ) otherlv_2= 'SPViz' ( (lv_name_3_0= RULE_ID ) ) otherlv_4= '{' ( (lv_views_5_0= ruleView ) )* otherlv_6= '}' ) ;
    public final EObject ruleSPViz() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_2=null;
        Token lv_name_3_0=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        AntlrDatatypeRuleToken lv_importedNamespace_1_0 = null;

        EObject lv_views_5_0 = null;



        	enterRule();

        try {
            // InternalSPViz.g:77:2: ( (otherlv_0= 'use' ( (lv_importedNamespace_1_0= ruleQualifiedName ) ) otherlv_2= 'SPViz' ( (lv_name_3_0= RULE_ID ) ) otherlv_4= '{' ( (lv_views_5_0= ruleView ) )* otherlv_6= '}' ) )
            // InternalSPViz.g:78:2: (otherlv_0= 'use' ( (lv_importedNamespace_1_0= ruleQualifiedName ) ) otherlv_2= 'SPViz' ( (lv_name_3_0= RULE_ID ) ) otherlv_4= '{' ( (lv_views_5_0= ruleView ) )* otherlv_6= '}' )
            {
            // InternalSPViz.g:78:2: (otherlv_0= 'use' ( (lv_importedNamespace_1_0= ruleQualifiedName ) ) otherlv_2= 'SPViz' ( (lv_name_3_0= RULE_ID ) ) otherlv_4= '{' ( (lv_views_5_0= ruleView ) )* otherlv_6= '}' )
            // InternalSPViz.g:79:3: otherlv_0= 'use' ( (lv_importedNamespace_1_0= ruleQualifiedName ) ) otherlv_2= 'SPViz' ( (lv_name_3_0= RULE_ID ) ) otherlv_4= '{' ( (lv_views_5_0= ruleView ) )* otherlv_6= '}'
            {
            otherlv_0=(Token)match(input,11,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getSPVizAccess().getUseKeyword_0());
            		
            // InternalSPViz.g:83:3: ( (lv_importedNamespace_1_0= ruleQualifiedName ) )
            // InternalSPViz.g:84:4: (lv_importedNamespace_1_0= ruleQualifiedName )
            {
            // InternalSPViz.g:84:4: (lv_importedNamespace_1_0= ruleQualifiedName )
            // InternalSPViz.g:85:5: lv_importedNamespace_1_0= ruleQualifiedName
            {

            					newCompositeNode(grammarAccess.getSPVizAccess().getImportedNamespaceQualifiedNameParserRuleCall_1_0());
            				
            pushFollow(FOLLOW_4);
            lv_importedNamespace_1_0=ruleQualifiedName();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getSPVizRule());
            					}
            					set(
            						current,
            						"importedNamespace",
            						lv_importedNamespace_1_0,
            						"de.cau.cs.kieler.spviz.spviz.SPViz.QualifiedName");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_2=(Token)match(input,12,FOLLOW_3); 

            			newLeafNode(otherlv_2, grammarAccess.getSPVizAccess().getSPVizKeyword_2());
            		
            // InternalSPViz.g:106:3: ( (lv_name_3_0= RULE_ID ) )
            // InternalSPViz.g:107:4: (lv_name_3_0= RULE_ID )
            {
            // InternalSPViz.g:107:4: (lv_name_3_0= RULE_ID )
            // InternalSPViz.g:108:5: lv_name_3_0= RULE_ID
            {
            lv_name_3_0=(Token)match(input,RULE_ID,FOLLOW_5); 

            					newLeafNode(lv_name_3_0, grammarAccess.getSPVizAccess().getNameIDTerminalRuleCall_3_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getSPVizRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_3_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            otherlv_4=(Token)match(input,13,FOLLOW_6); 

            			newLeafNode(otherlv_4, grammarAccess.getSPVizAccess().getLeftCurlyBracketKeyword_4());
            		
            // InternalSPViz.g:128:3: ( (lv_views_5_0= ruleView ) )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==RULE_ID) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // InternalSPViz.g:129:4: (lv_views_5_0= ruleView )
            	    {
            	    // InternalSPViz.g:129:4: (lv_views_5_0= ruleView )
            	    // InternalSPViz.g:130:5: lv_views_5_0= ruleView
            	    {

            	    					newCompositeNode(grammarAccess.getSPVizAccess().getViewsViewParserRuleCall_5_0());
            	    				
            	    pushFollow(FOLLOW_6);
            	    lv_views_5_0=ruleView();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getSPVizRule());
            	    					}
            	    					add(
            	    						current,
            	    						"views",
            	    						lv_views_5_0,
            	    						"de.cau.cs.kieler.spviz.spviz.SPViz.View");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

            otherlv_6=(Token)match(input,14,FOLLOW_2); 

            			newLeafNode(otherlv_6, grammarAccess.getSPVizAccess().getRightCurlyBracketKeyword_6());
            		

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
    // InternalSPViz.g:155:1: entryRuleView returns [EObject current=null] : iv_ruleView= ruleView EOF ;
    public final EObject entryRuleView() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleView = null;


        try {
            // InternalSPViz.g:155:45: (iv_ruleView= ruleView EOF )
            // InternalSPViz.g:156:2: iv_ruleView= ruleView EOF
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
    // InternalSPViz.g:162:1: ruleView returns [EObject current=null] : ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= '{' ( (lv_shownElements_2_0= ruleShownElement ) )* ( (lv_shownConnections_3_0= ruleShownConnection ) )* otherlv_4= '}' ) ;
    public final EObject ruleView() throws RecognitionException {
        EObject current = null;

        Token lv_name_0_0=null;
        Token otherlv_1=null;
        Token otherlv_4=null;
        EObject lv_shownElements_2_0 = null;

        EObject lv_shownConnections_3_0 = null;



        	enterRule();

        try {
            // InternalSPViz.g:168:2: ( ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= '{' ( (lv_shownElements_2_0= ruleShownElement ) )* ( (lv_shownConnections_3_0= ruleShownConnection ) )* otherlv_4= '}' ) )
            // InternalSPViz.g:169:2: ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= '{' ( (lv_shownElements_2_0= ruleShownElement ) )* ( (lv_shownConnections_3_0= ruleShownConnection ) )* otherlv_4= '}' )
            {
            // InternalSPViz.g:169:2: ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= '{' ( (lv_shownElements_2_0= ruleShownElement ) )* ( (lv_shownConnections_3_0= ruleShownConnection ) )* otherlv_4= '}' )
            // InternalSPViz.g:170:3: ( (lv_name_0_0= RULE_ID ) ) otherlv_1= '{' ( (lv_shownElements_2_0= ruleShownElement ) )* ( (lv_shownConnections_3_0= ruleShownConnection ) )* otherlv_4= '}'
            {
            // InternalSPViz.g:170:3: ( (lv_name_0_0= RULE_ID ) )
            // InternalSPViz.g:171:4: (lv_name_0_0= RULE_ID )
            {
            // InternalSPViz.g:171:4: (lv_name_0_0= RULE_ID )
            // InternalSPViz.g:172:5: lv_name_0_0= RULE_ID
            {
            lv_name_0_0=(Token)match(input,RULE_ID,FOLLOW_5); 

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

            otherlv_1=(Token)match(input,13,FOLLOW_7); 

            			newLeafNode(otherlv_1, grammarAccess.getViewAccess().getLeftCurlyBracketKeyword_1());
            		
            // InternalSPViz.g:192:3: ( (lv_shownElements_2_0= ruleShownElement ) )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==15) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // InternalSPViz.g:193:4: (lv_shownElements_2_0= ruleShownElement )
            	    {
            	    // InternalSPViz.g:193:4: (lv_shownElements_2_0= ruleShownElement )
            	    // InternalSPViz.g:194:5: lv_shownElements_2_0= ruleShownElement
            	    {

            	    					newCompositeNode(grammarAccess.getViewAccess().getShownElementsShownElementParserRuleCall_2_0());
            	    				
            	    pushFollow(FOLLOW_7);
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
            	    break loop2;
                }
            } while (true);

            // InternalSPViz.g:211:3: ( (lv_shownConnections_3_0= ruleShownConnection ) )*
            loop3:
            do {
                int alt3=2;
                int LA3_0 = input.LA(1);

                if ( (LA3_0==17) ) {
                    alt3=1;
                }


                switch (alt3) {
            	case 1 :
            	    // InternalSPViz.g:212:4: (lv_shownConnections_3_0= ruleShownConnection )
            	    {
            	    // InternalSPViz.g:212:4: (lv_shownConnections_3_0= ruleShownConnection )
            	    // InternalSPViz.g:213:5: lv_shownConnections_3_0= ruleShownConnection
            	    {

            	    					newCompositeNode(grammarAccess.getViewAccess().getShownConnectionsShownConnectionParserRuleCall_3_0());
            	    				
            	    pushFollow(FOLLOW_8);
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
            	    break loop3;
                }
            } while (true);

            otherlv_4=(Token)match(input,14,FOLLOW_2); 

            			newLeafNode(otherlv_4, grammarAccess.getViewAccess().getRightCurlyBracketKeyword_4());
            		

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


    // $ANTLR start "entryRuleShownElement"
    // InternalSPViz.g:238:1: entryRuleShownElement returns [EObject current=null] : iv_ruleShownElement= ruleShownElement EOF ;
    public final EObject entryRuleShownElement() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleShownElement = null;


        try {
            // InternalSPViz.g:238:53: (iv_ruleShownElement= ruleShownElement EOF )
            // InternalSPViz.g:239:2: iv_ruleShownElement= ruleShownElement EOF
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
    // InternalSPViz.g:245:1: ruleShownElement returns [EObject current=null] : (otherlv_0= 'show' ( ( ruleQualifiedName ) ) (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )? ) ;
    public final EObject ruleShownElement() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_2=null;


        	enterRule();

        try {
            // InternalSPViz.g:251:2: ( (otherlv_0= 'show' ( ( ruleQualifiedName ) ) (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )? ) )
            // InternalSPViz.g:252:2: (otherlv_0= 'show' ( ( ruleQualifiedName ) ) (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )? )
            {
            // InternalSPViz.g:252:2: (otherlv_0= 'show' ( ( ruleQualifiedName ) ) (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )? )
            // InternalSPViz.g:253:3: otherlv_0= 'show' ( ( ruleQualifiedName ) ) (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )?
            {
            otherlv_0=(Token)match(input,15,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getShownElementAccess().getShowKeyword_0());
            		
            // InternalSPViz.g:257:3: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:258:4: ( ruleQualifiedName )
            {
            // InternalSPViz.g:258:4: ( ruleQualifiedName )
            // InternalSPViz.g:259:5: ruleQualifiedName
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getShownElementRule());
            					}
            				

            					newCompositeNode(grammarAccess.getShownElementAccess().getShownElementArtifactCrossReference_1_0());
            				
            pushFollow(FOLLOW_9);
            ruleQualifiedName();

            state._fsp--;


            					afterParserOrEnumRuleCall();
            				

            }


            }

            // InternalSPViz.g:273:3: (otherlv_2= 'in' ( ( ruleQualifiedName ) ) )?
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( (LA4_0==16) ) {
                alt4=1;
            }
            switch (alt4) {
                case 1 :
                    // InternalSPViz.g:274:4: otherlv_2= 'in' ( ( ruleQualifiedName ) )
                    {
                    otherlv_2=(Token)match(input,16,FOLLOW_3); 

                    				newLeafNode(otherlv_2, grammarAccess.getShownElementAccess().getInKeyword_2_0());
                    			
                    // InternalSPViz.g:278:4: ( ( ruleQualifiedName ) )
                    // InternalSPViz.g:279:5: ( ruleQualifiedName )
                    {
                    // InternalSPViz.g:279:5: ( ruleQualifiedName )
                    // InternalSPViz.g:280:6: ruleQualifiedName
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
    // InternalSPViz.g:299:1: entryRuleShownConnection returns [EObject current=null] : iv_ruleShownConnection= ruleShownConnection EOF ;
    public final EObject entryRuleShownConnection() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleShownConnection = null;


        try {
            // InternalSPViz.g:299:56: (iv_ruleShownConnection= ruleShownConnection EOF )
            // InternalSPViz.g:300:2: iv_ruleShownConnection= ruleShownConnection EOF
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
    // InternalSPViz.g:306:1: ruleShownConnection returns [EObject current=null] : (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) (otherlv_2= 'via' ( ( ruleQualifiedName ) ) )? ) ;
    public final EObject ruleShownConnection() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_2=null;


        	enterRule();

        try {
            // InternalSPViz.g:312:2: ( (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) (otherlv_2= 'via' ( ( ruleQualifiedName ) ) )? ) )
            // InternalSPViz.g:313:2: (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) (otherlv_2= 'via' ( ( ruleQualifiedName ) ) )? )
            {
            // InternalSPViz.g:313:2: (otherlv_0= 'connect' ( ( ruleQualifiedName ) ) (otherlv_2= 'via' ( ( ruleQualifiedName ) ) )? )
            // InternalSPViz.g:314:3: otherlv_0= 'connect' ( ( ruleQualifiedName ) ) (otherlv_2= 'via' ( ( ruleQualifiedName ) ) )?
            {
            otherlv_0=(Token)match(input,17,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getShownConnectionAccess().getConnectKeyword_0());
            		
            // InternalSPViz.g:318:3: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:319:4: ( ruleQualifiedName )
            {
            // InternalSPViz.g:319:4: ( ruleQualifiedName )
            // InternalSPViz.g:320:5: ruleQualifiedName
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getShownConnectionRule());
            					}
            				

            					newCompositeNode(grammarAccess.getShownConnectionAccess().getShownConnectionConnectionCrossReference_1_0());
            				
            pushFollow(FOLLOW_10);
            ruleQualifiedName();

            state._fsp--;


            					afterParserOrEnumRuleCall();
            				

            }


            }

            // InternalSPViz.g:334:3: (otherlv_2= 'via' ( ( ruleQualifiedName ) ) )?
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0==18) ) {
                alt5=1;
            }
            switch (alt5) {
                case 1 :
                    // InternalSPViz.g:335:4: otherlv_2= 'via' ( ( ruleQualifiedName ) )
                    {
                    otherlv_2=(Token)match(input,18,FOLLOW_3); 

                    				newLeafNode(otherlv_2, grammarAccess.getShownConnectionAccess().getViaKeyword_2_0());
                    			
                    // InternalSPViz.g:339:4: ( ( ruleQualifiedName ) )
                    // InternalSPViz.g:340:5: ( ruleQualifiedName )
                    {
                    // InternalSPViz.g:340:5: ( ruleQualifiedName )
                    // InternalSPViz.g:341:6: ruleQualifiedName
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getShownConnectionRule());
                    						}
                    					

                    						newCompositeNode(grammarAccess.getShownConnectionAccess().getViaArtifactCrossReference_2_1_0());
                    					
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
    // $ANTLR end "ruleShownConnection"


    // $ANTLR start "entryRuleQualifiedName"
    // InternalSPViz.g:360:1: entryRuleQualifiedName returns [String current=null] : iv_ruleQualifiedName= ruleQualifiedName EOF ;
    public final String entryRuleQualifiedName() throws RecognitionException {
        String current = null;

        AntlrDatatypeRuleToken iv_ruleQualifiedName = null;


        try {
            // InternalSPViz.g:360:53: (iv_ruleQualifiedName= ruleQualifiedName EOF )
            // InternalSPViz.g:361:2: iv_ruleQualifiedName= ruleQualifiedName EOF
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
    // InternalSPViz.g:367:1: ruleQualifiedName returns [AntlrDatatypeRuleToken current=new AntlrDatatypeRuleToken()] : (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* ) ;
    public final AntlrDatatypeRuleToken ruleQualifiedName() throws RecognitionException {
        AntlrDatatypeRuleToken current = new AntlrDatatypeRuleToken();

        Token this_ID_0=null;
        Token kw=null;
        Token this_ID_2=null;


        	enterRule();

        try {
            // InternalSPViz.g:373:2: ( (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* ) )
            // InternalSPViz.g:374:2: (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* )
            {
            // InternalSPViz.g:374:2: (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* )
            // InternalSPViz.g:375:3: this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )*
            {
            this_ID_0=(Token)match(input,RULE_ID,FOLLOW_11); 

            			current.merge(this_ID_0);
            		

            			newLeafNode(this_ID_0, grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_0());
            		
            // InternalSPViz.g:382:3: (kw= '.' this_ID_2= RULE_ID )*
            loop6:
            do {
                int alt6=2;
                int LA6_0 = input.LA(1);

                if ( (LA6_0==19) ) {
                    alt6=1;
                }


                switch (alt6) {
            	case 1 :
            	    // InternalSPViz.g:383:4: kw= '.' this_ID_2= RULE_ID
            	    {
            	    kw=(Token)match(input,19,FOLLOW_3); 

            	    				current.merge(kw);
            	    				newLeafNode(kw, grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0());
            	    			
            	    this_ID_2=(Token)match(input,RULE_ID,FOLLOW_11); 

            	    				current.merge(this_ID_2);
            	    			

            	    				newLeafNode(this_ID_2, grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_1_1());
            	    			

            	    }
            	    break;

            	default :
            	    break loop6;
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


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000004010L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x000000000002C000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000000024000L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000010002L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000000040002L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000000080002L});

}