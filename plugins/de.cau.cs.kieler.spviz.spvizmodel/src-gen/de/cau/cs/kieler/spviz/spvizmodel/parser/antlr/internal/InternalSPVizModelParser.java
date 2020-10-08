package de.cau.cs.kieler.spviz.spvizmodel.parser.antlr.internal;

import org.eclipse.xtext.*;
import org.eclipse.xtext.parser.*;
import org.eclipse.xtext.parser.impl.*;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.parser.antlr.AbstractInternalAntlrParser;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.parser.antlr.AntlrDatatypeRuleToken;
import de.cau.cs.kieler.spviz.spvizmodel.services.SPVizModelGrammarAccess;



import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class InternalSPVizModelParser extends AbstractInternalAntlrParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'package'", "'SPVizModel'", "'{'", "'}'", "'contains'", "'connects'", "'.'"
    };
    public static final int RULE_ID=4;
    public static final int RULE_WS=9;
    public static final int RULE_STRING=6;
    public static final int RULE_ANY_OTHER=10;
    public static final int RULE_SL_COMMENT=8;
    public static final int T__15=15;
    public static final int T__16=16;
    public static final int T__17=17;
    public static final int RULE_INT=5;
    public static final int T__11=11;
    public static final int RULE_ML_COMMENT=7;
    public static final int T__12=12;
    public static final int T__13=13;
    public static final int T__14=14;
    public static final int EOF=-1;

    // delegates
    // delegators


        public InternalSPVizModelParser(TokenStream input) {
            this(input, new RecognizerSharedState());
        }
        public InternalSPVizModelParser(TokenStream input, RecognizerSharedState state) {
            super(input, state);
             
        }
        

    public String[] getTokenNames() { return InternalSPVizModelParser.tokenNames; }
    public String getGrammarFileName() { return "InternalSPVizModel.g"; }



     	private SPVizModelGrammarAccess grammarAccess;

        public InternalSPVizModelParser(TokenStream input, SPVizModelGrammarAccess grammarAccess) {
            this(input);
            this.grammarAccess = grammarAccess;
            registerRules(grammarAccess.getGrammar());
        }

        @Override
        protected String getFirstRuleName() {
        	return "SPVizModel";
       	}

       	@Override
       	protected SPVizModelGrammarAccess getGrammarAccess() {
       		return grammarAccess;
       	}




    // $ANTLR start "entryRuleSPVizModel"
    // InternalSPVizModel.g:64:1: entryRuleSPVizModel returns [EObject current=null] : iv_ruleSPVizModel= ruleSPVizModel EOF ;
    public final EObject entryRuleSPVizModel() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleSPVizModel = null;


        try {
            // InternalSPVizModel.g:64:51: (iv_ruleSPVizModel= ruleSPVizModel EOF )
            // InternalSPVizModel.g:65:2: iv_ruleSPVizModel= ruleSPVizModel EOF
            {
             newCompositeNode(grammarAccess.getSPVizModelRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleSPVizModel=ruleSPVizModel();

            state._fsp--;

             current =iv_ruleSPVizModel; 
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
    // $ANTLR end "entryRuleSPVizModel"


    // $ANTLR start "ruleSPVizModel"
    // InternalSPVizModel.g:71:1: ruleSPVizModel returns [EObject current=null] : (otherlv_0= 'package' ( (lv_package_1_0= ruleQualifiedName ) ) otherlv_2= 'SPVizModel' ( (lv_name_3_0= RULE_ID ) ) otherlv_4= '{' ( (lv_artifacts_5_0= ruleArtifact ) )* otherlv_6= '}' ) ;
    public final EObject ruleSPVizModel() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_2=null;
        Token lv_name_3_0=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        AntlrDatatypeRuleToken lv_package_1_0 = null;

        EObject lv_artifacts_5_0 = null;



        	enterRule();

        try {
            // InternalSPVizModel.g:77:2: ( (otherlv_0= 'package' ( (lv_package_1_0= ruleQualifiedName ) ) otherlv_2= 'SPVizModel' ( (lv_name_3_0= RULE_ID ) ) otherlv_4= '{' ( (lv_artifacts_5_0= ruleArtifact ) )* otherlv_6= '}' ) )
            // InternalSPVizModel.g:78:2: (otherlv_0= 'package' ( (lv_package_1_0= ruleQualifiedName ) ) otherlv_2= 'SPVizModel' ( (lv_name_3_0= RULE_ID ) ) otherlv_4= '{' ( (lv_artifacts_5_0= ruleArtifact ) )* otherlv_6= '}' )
            {
            // InternalSPVizModel.g:78:2: (otherlv_0= 'package' ( (lv_package_1_0= ruleQualifiedName ) ) otherlv_2= 'SPVizModel' ( (lv_name_3_0= RULE_ID ) ) otherlv_4= '{' ( (lv_artifacts_5_0= ruleArtifact ) )* otherlv_6= '}' )
            // InternalSPVizModel.g:79:3: otherlv_0= 'package' ( (lv_package_1_0= ruleQualifiedName ) ) otherlv_2= 'SPVizModel' ( (lv_name_3_0= RULE_ID ) ) otherlv_4= '{' ( (lv_artifacts_5_0= ruleArtifact ) )* otherlv_6= '}'
            {
            otherlv_0=(Token)match(input,11,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getSPVizModelAccess().getPackageKeyword_0());
            		
            // InternalSPVizModel.g:83:3: ( (lv_package_1_0= ruleQualifiedName ) )
            // InternalSPVizModel.g:84:4: (lv_package_1_0= ruleQualifiedName )
            {
            // InternalSPVizModel.g:84:4: (lv_package_1_0= ruleQualifiedName )
            // InternalSPVizModel.g:85:5: lv_package_1_0= ruleQualifiedName
            {

            					newCompositeNode(grammarAccess.getSPVizModelAccess().getPackageQualifiedNameParserRuleCall_1_0());
            				
            pushFollow(FOLLOW_4);
            lv_package_1_0=ruleQualifiedName();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getSPVizModelRule());
            					}
            					set(
            						current,
            						"package",
            						lv_package_1_0,
            						"de.cau.cs.kieler.spviz.spvizmodel.SPVizModel.QualifiedName");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_2=(Token)match(input,12,FOLLOW_3); 

            			newLeafNode(otherlv_2, grammarAccess.getSPVizModelAccess().getSPVizModelKeyword_2());
            		
            // InternalSPVizModel.g:106:3: ( (lv_name_3_0= RULE_ID ) )
            // InternalSPVizModel.g:107:4: (lv_name_3_0= RULE_ID )
            {
            // InternalSPVizModel.g:107:4: (lv_name_3_0= RULE_ID )
            // InternalSPVizModel.g:108:5: lv_name_3_0= RULE_ID
            {
            lv_name_3_0=(Token)match(input,RULE_ID,FOLLOW_5); 

            					newLeafNode(lv_name_3_0, grammarAccess.getSPVizModelAccess().getNameIDTerminalRuleCall_3_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getSPVizModelRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_3_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            otherlv_4=(Token)match(input,13,FOLLOW_6); 

            			newLeafNode(otherlv_4, grammarAccess.getSPVizModelAccess().getLeftCurlyBracketKeyword_4());
            		
            // InternalSPVizModel.g:128:3: ( (lv_artifacts_5_0= ruleArtifact ) )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==RULE_ID) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // InternalSPVizModel.g:129:4: (lv_artifacts_5_0= ruleArtifact )
            	    {
            	    // InternalSPVizModel.g:129:4: (lv_artifacts_5_0= ruleArtifact )
            	    // InternalSPVizModel.g:130:5: lv_artifacts_5_0= ruleArtifact
            	    {

            	    					newCompositeNode(grammarAccess.getSPVizModelAccess().getArtifactsArtifactParserRuleCall_5_0());
            	    				
            	    pushFollow(FOLLOW_6);
            	    lv_artifacts_5_0=ruleArtifact();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getSPVizModelRule());
            	    					}
            	    					add(
            	    						current,
            	    						"artifacts",
            	    						lv_artifacts_5_0,
            	    						"de.cau.cs.kieler.spviz.spvizmodel.SPVizModel.Artifact");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

            otherlv_6=(Token)match(input,14,FOLLOW_2); 

            			newLeafNode(otherlv_6, grammarAccess.getSPVizModelAccess().getRightCurlyBracketKeyword_6());
            		

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
    // $ANTLR end "ruleSPVizModel"


    // $ANTLR start "entryRuleArtifact"
    // InternalSPVizModel.g:155:1: entryRuleArtifact returns [EObject current=null] : iv_ruleArtifact= ruleArtifact EOF ;
    public final EObject entryRuleArtifact() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleArtifact = null;


        try {
            // InternalSPVizModel.g:155:49: (iv_ruleArtifact= ruleArtifact EOF )
            // InternalSPVizModel.g:156:2: iv_ruleArtifact= ruleArtifact EOF
            {
             newCompositeNode(grammarAccess.getArtifactRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleArtifact=ruleArtifact();

            state._fsp--;

             current =iv_ruleArtifact; 
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
    // $ANTLR end "entryRuleArtifact"


    // $ANTLR start "ruleArtifact"
    // InternalSPVizModel.g:162:1: ruleArtifact returns [EObject current=null] : ( ( (lv_name_0_0= RULE_ID ) ) (otherlv_1= '{' ( (lv_references_2_0= ruleReference ) )* otherlv_3= '}' )? ) ;
    public final EObject ruleArtifact() throws RecognitionException {
        EObject current = null;

        Token lv_name_0_0=null;
        Token otherlv_1=null;
        Token otherlv_3=null;
        EObject lv_references_2_0 = null;



        	enterRule();

        try {
            // InternalSPVizModel.g:168:2: ( ( ( (lv_name_0_0= RULE_ID ) ) (otherlv_1= '{' ( (lv_references_2_0= ruleReference ) )* otherlv_3= '}' )? ) )
            // InternalSPVizModel.g:169:2: ( ( (lv_name_0_0= RULE_ID ) ) (otherlv_1= '{' ( (lv_references_2_0= ruleReference ) )* otherlv_3= '}' )? )
            {
            // InternalSPVizModel.g:169:2: ( ( (lv_name_0_0= RULE_ID ) ) (otherlv_1= '{' ( (lv_references_2_0= ruleReference ) )* otherlv_3= '}' )? )
            // InternalSPVizModel.g:170:3: ( (lv_name_0_0= RULE_ID ) ) (otherlv_1= '{' ( (lv_references_2_0= ruleReference ) )* otherlv_3= '}' )?
            {
            // InternalSPVizModel.g:170:3: ( (lv_name_0_0= RULE_ID ) )
            // InternalSPVizModel.g:171:4: (lv_name_0_0= RULE_ID )
            {
            // InternalSPVizModel.g:171:4: (lv_name_0_0= RULE_ID )
            // InternalSPVizModel.g:172:5: lv_name_0_0= RULE_ID
            {
            lv_name_0_0=(Token)match(input,RULE_ID,FOLLOW_7); 

            					newLeafNode(lv_name_0_0, grammarAccess.getArtifactAccess().getNameIDTerminalRuleCall_0_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getArtifactRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_0_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            // InternalSPVizModel.g:188:3: (otherlv_1= '{' ( (lv_references_2_0= ruleReference ) )* otherlv_3= '}' )?
            int alt3=2;
            int LA3_0 = input.LA(1);

            if ( (LA3_0==13) ) {
                alt3=1;
            }
            switch (alt3) {
                case 1 :
                    // InternalSPVizModel.g:189:4: otherlv_1= '{' ( (lv_references_2_0= ruleReference ) )* otherlv_3= '}'
                    {
                    otherlv_1=(Token)match(input,13,FOLLOW_8); 

                    				newLeafNode(otherlv_1, grammarAccess.getArtifactAccess().getLeftCurlyBracketKeyword_1_0());
                    			
                    // InternalSPVizModel.g:193:4: ( (lv_references_2_0= ruleReference ) )*
                    loop2:
                    do {
                        int alt2=2;
                        int LA2_0 = input.LA(1);

                        if ( (LA2_0==RULE_ID||LA2_0==15) ) {
                            alt2=1;
                        }


                        switch (alt2) {
                    	case 1 :
                    	    // InternalSPVizModel.g:194:5: (lv_references_2_0= ruleReference )
                    	    {
                    	    // InternalSPVizModel.g:194:5: (lv_references_2_0= ruleReference )
                    	    // InternalSPVizModel.g:195:6: lv_references_2_0= ruleReference
                    	    {

                    	    						newCompositeNode(grammarAccess.getArtifactAccess().getReferencesReferenceParserRuleCall_1_1_0());
                    	    					
                    	    pushFollow(FOLLOW_8);
                    	    lv_references_2_0=ruleReference();

                    	    state._fsp--;


                    	    						if (current==null) {
                    	    							current = createModelElementForParent(grammarAccess.getArtifactRule());
                    	    						}
                    	    						add(
                    	    							current,
                    	    							"references",
                    	    							lv_references_2_0,
                    	    							"de.cau.cs.kieler.spviz.spvizmodel.SPVizModel.Reference");
                    	    						afterParserOrEnumRuleCall();
                    	    					

                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop2;
                        }
                    } while (true);

                    otherlv_3=(Token)match(input,14,FOLLOW_2); 

                    				newLeafNode(otherlv_3, grammarAccess.getArtifactAccess().getRightCurlyBracketKeyword_1_2());
                    			

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
    // $ANTLR end "ruleArtifact"


    // $ANTLR start "entryRuleReference"
    // InternalSPVizModel.g:221:1: entryRuleReference returns [EObject current=null] : iv_ruleReference= ruleReference EOF ;
    public final EObject entryRuleReference() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleReference = null;


        try {
            // InternalSPVizModel.g:221:50: (iv_ruleReference= ruleReference EOF )
            // InternalSPVizModel.g:222:2: iv_ruleReference= ruleReference EOF
            {
             newCompositeNode(grammarAccess.getReferenceRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleReference=ruleReference();

            state._fsp--;

             current =iv_ruleReference; 
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
    // $ANTLR end "entryRuleReference"


    // $ANTLR start "ruleReference"
    // InternalSPVizModel.g:228:1: ruleReference returns [EObject current=null] : (this_Containment_0= ruleContainment | this_Connection_1= ruleConnection ) ;
    public final EObject ruleReference() throws RecognitionException {
        EObject current = null;

        EObject this_Containment_0 = null;

        EObject this_Connection_1 = null;



        	enterRule();

        try {
            // InternalSPVizModel.g:234:2: ( (this_Containment_0= ruleContainment | this_Connection_1= ruleConnection ) )
            // InternalSPVizModel.g:235:2: (this_Containment_0= ruleContainment | this_Connection_1= ruleConnection )
            {
            // InternalSPVizModel.g:235:2: (this_Containment_0= ruleContainment | this_Connection_1= ruleConnection )
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( (LA4_0==15) ) {
                alt4=1;
            }
            else if ( (LA4_0==RULE_ID) ) {
                alt4=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 4, 0, input);

                throw nvae;
            }
            switch (alt4) {
                case 1 :
                    // InternalSPVizModel.g:236:3: this_Containment_0= ruleContainment
                    {

                    			newCompositeNode(grammarAccess.getReferenceAccess().getContainmentParserRuleCall_0());
                    		
                    pushFollow(FOLLOW_2);
                    this_Containment_0=ruleContainment();

                    state._fsp--;


                    			current = this_Containment_0;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 2 :
                    // InternalSPVizModel.g:245:3: this_Connection_1= ruleConnection
                    {

                    			newCompositeNode(grammarAccess.getReferenceAccess().getConnectionParserRuleCall_1());
                    		
                    pushFollow(FOLLOW_2);
                    this_Connection_1=ruleConnection();

                    state._fsp--;


                    			current = this_Connection_1;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;

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
    // $ANTLR end "ruleReference"


    // $ANTLR start "entryRuleContainment"
    // InternalSPVizModel.g:257:1: entryRuleContainment returns [EObject current=null] : iv_ruleContainment= ruleContainment EOF ;
    public final EObject entryRuleContainment() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleContainment = null;


        try {
            // InternalSPVizModel.g:257:52: (iv_ruleContainment= ruleContainment EOF )
            // InternalSPVizModel.g:258:2: iv_ruleContainment= ruleContainment EOF
            {
             newCompositeNode(grammarAccess.getContainmentRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleContainment=ruleContainment();

            state._fsp--;

             current =iv_ruleContainment; 
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
    // $ANTLR end "entryRuleContainment"


    // $ANTLR start "ruleContainment"
    // InternalSPVizModel.g:264:1: ruleContainment returns [EObject current=null] : (otherlv_0= 'contains' ( (otherlv_1= RULE_ID ) ) ) ;
    public final EObject ruleContainment() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;


        	enterRule();

        try {
            // InternalSPVizModel.g:270:2: ( (otherlv_0= 'contains' ( (otherlv_1= RULE_ID ) ) ) )
            // InternalSPVizModel.g:271:2: (otherlv_0= 'contains' ( (otherlv_1= RULE_ID ) ) )
            {
            // InternalSPVizModel.g:271:2: (otherlv_0= 'contains' ( (otherlv_1= RULE_ID ) ) )
            // InternalSPVizModel.g:272:3: otherlv_0= 'contains' ( (otherlv_1= RULE_ID ) )
            {
            otherlv_0=(Token)match(input,15,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getContainmentAccess().getContainsKeyword_0());
            		
            // InternalSPVizModel.g:276:3: ( (otherlv_1= RULE_ID ) )
            // InternalSPVizModel.g:277:4: (otherlv_1= RULE_ID )
            {
            // InternalSPVizModel.g:277:4: (otherlv_1= RULE_ID )
            // InternalSPVizModel.g:278:5: otherlv_1= RULE_ID
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getContainmentRule());
            					}
            				
            otherlv_1=(Token)match(input,RULE_ID,FOLLOW_2); 

            					newLeafNode(otherlv_1, grammarAccess.getContainmentAccess().getContainsArtifactCrossReference_1_0());
            				

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
    // $ANTLR end "ruleContainment"


    // $ANTLR start "entryRuleConnection"
    // InternalSPVizModel.g:293:1: entryRuleConnection returns [EObject current=null] : iv_ruleConnection= ruleConnection EOF ;
    public final EObject entryRuleConnection() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleConnection = null;


        try {
            // InternalSPVizModel.g:293:51: (iv_ruleConnection= ruleConnection EOF )
            // InternalSPVizModel.g:294:2: iv_ruleConnection= ruleConnection EOF
            {
             newCompositeNode(grammarAccess.getConnectionRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleConnection=ruleConnection();

            state._fsp--;

             current =iv_ruleConnection; 
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
    // $ANTLR end "entryRuleConnection"


    // $ANTLR start "ruleConnection"
    // InternalSPVizModel.g:300:1: ruleConnection returns [EObject current=null] : ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= 'connects' ( (otherlv_2= RULE_ID ) ) ) ;
    public final EObject ruleConnection() throws RecognitionException {
        EObject current = null;

        Token lv_name_0_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;


        	enterRule();

        try {
            // InternalSPVizModel.g:306:2: ( ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= 'connects' ( (otherlv_2= RULE_ID ) ) ) )
            // InternalSPVizModel.g:307:2: ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= 'connects' ( (otherlv_2= RULE_ID ) ) )
            {
            // InternalSPVizModel.g:307:2: ( ( (lv_name_0_0= RULE_ID ) ) otherlv_1= 'connects' ( (otherlv_2= RULE_ID ) ) )
            // InternalSPVizModel.g:308:3: ( (lv_name_0_0= RULE_ID ) ) otherlv_1= 'connects' ( (otherlv_2= RULE_ID ) )
            {
            // InternalSPVizModel.g:308:3: ( (lv_name_0_0= RULE_ID ) )
            // InternalSPVizModel.g:309:4: (lv_name_0_0= RULE_ID )
            {
            // InternalSPVizModel.g:309:4: (lv_name_0_0= RULE_ID )
            // InternalSPVizModel.g:310:5: lv_name_0_0= RULE_ID
            {
            lv_name_0_0=(Token)match(input,RULE_ID,FOLLOW_9); 

            					newLeafNode(lv_name_0_0, grammarAccess.getConnectionAccess().getNameIDTerminalRuleCall_0_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getConnectionRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_0_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            otherlv_1=(Token)match(input,16,FOLLOW_3); 

            			newLeafNode(otherlv_1, grammarAccess.getConnectionAccess().getConnectsKeyword_1());
            		
            // InternalSPVizModel.g:330:3: ( (otherlv_2= RULE_ID ) )
            // InternalSPVizModel.g:331:4: (otherlv_2= RULE_ID )
            {
            // InternalSPVizModel.g:331:4: (otherlv_2= RULE_ID )
            // InternalSPVizModel.g:332:5: otherlv_2= RULE_ID
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getConnectionRule());
            					}
            				
            otherlv_2=(Token)match(input,RULE_ID,FOLLOW_2); 

            					newLeafNode(otherlv_2, grammarAccess.getConnectionAccess().getConnectsToArtifactCrossReference_2_0());
            				

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
    // $ANTLR end "ruleConnection"


    // $ANTLR start "entryRuleQualifiedName"
    // InternalSPVizModel.g:347:1: entryRuleQualifiedName returns [String current=null] : iv_ruleQualifiedName= ruleQualifiedName EOF ;
    public final String entryRuleQualifiedName() throws RecognitionException {
        String current = null;

        AntlrDatatypeRuleToken iv_ruleQualifiedName = null;


        try {
            // InternalSPVizModel.g:347:53: (iv_ruleQualifiedName= ruleQualifiedName EOF )
            // InternalSPVizModel.g:348:2: iv_ruleQualifiedName= ruleQualifiedName EOF
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
    // InternalSPVizModel.g:354:1: ruleQualifiedName returns [AntlrDatatypeRuleToken current=new AntlrDatatypeRuleToken()] : (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* ) ;
    public final AntlrDatatypeRuleToken ruleQualifiedName() throws RecognitionException {
        AntlrDatatypeRuleToken current = new AntlrDatatypeRuleToken();

        Token this_ID_0=null;
        Token kw=null;
        Token this_ID_2=null;


        	enterRule();

        try {
            // InternalSPVizModel.g:360:2: ( (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* ) )
            // InternalSPVizModel.g:361:2: (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* )
            {
            // InternalSPVizModel.g:361:2: (this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )* )
            // InternalSPVizModel.g:362:3: this_ID_0= RULE_ID (kw= '.' this_ID_2= RULE_ID )*
            {
            this_ID_0=(Token)match(input,RULE_ID,FOLLOW_10); 

            			current.merge(this_ID_0);
            		

            			newLeafNode(this_ID_0, grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_0());
            		
            // InternalSPVizModel.g:369:3: (kw= '.' this_ID_2= RULE_ID )*
            loop5:
            do {
                int alt5=2;
                int LA5_0 = input.LA(1);

                if ( (LA5_0==17) ) {
                    alt5=1;
                }


                switch (alt5) {
            	case 1 :
            	    // InternalSPVizModel.g:370:4: kw= '.' this_ID_2= RULE_ID
            	    {
            	    kw=(Token)match(input,17,FOLLOW_3); 

            	    				current.merge(kw);
            	    				newLeafNode(kw, grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0());
            	    			
            	    this_ID_2=(Token)match(input,RULE_ID,FOLLOW_10); 

            	    				current.merge(this_ID_2);
            	    			

            	    				newLeafNode(this_ID_2, grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_1_1());
            	    			

            	    }
            	    break;

            	default :
            	    break loop5;
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
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000002002L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x000000000000C010L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000000020002L});

}