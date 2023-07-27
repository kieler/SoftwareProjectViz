package de.cau.cs.kieler.spviz.spviz.ide.contentassist.antlr.internal;

import java.io.InputStream;
import org.eclipse.xtext.*;
import org.eclipse.xtext.parser.*;
import org.eclipse.xtext.parser.impl.*;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.ide.editor.contentassist.antlr.internal.AbstractInternalContentAssistParser;
import org.eclipse.xtext.ide.editor.contentassist.antlr.internal.DFA;
import de.cau.cs.kieler.spviz.spviz.services.SPVizGrammarAccess;



import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class InternalSPVizParser extends AbstractInternalContentAssistParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_STRING", "RULE_INT", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'package'", "'import'", "'SPViz'", "'{'", "'}'", "'shows'", "'with'", "'from'", "'>'", "'show'", "'in'", "'connect'", "'via'", "'.'"
    };
    public static final int RULE_STRING=5;
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

    	public void setGrammarAccess(SPVizGrammarAccess grammarAccess) {
    		this.grammarAccess = grammarAccess;
    	}

    	@Override
    	protected Grammar getGrammar() {
    		return grammarAccess.getGrammar();
    	}

    	@Override
    	protected String getValueForTokenName(String tokenName) {
    		return tokenName;
    	}



    // $ANTLR start "entryRuleSPViz"
    // InternalSPViz.g:68:1: entryRuleSPViz : ruleSPViz EOF ;
    public final void entryRuleSPViz() throws RecognitionException {
        try {
            // InternalSPViz.g:69:1: ( ruleSPViz EOF )
            // InternalSPViz.g:70:1: ruleSPViz EOF
            {
             before(grammarAccess.getSPVizRule()); 
            pushFollow(FOLLOW_1);
            ruleSPViz();

            state._fsp--;

             after(grammarAccess.getSPVizRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleSPViz"


    // $ANTLR start "ruleSPViz"
    // InternalSPViz.g:77:1: ruleSPViz : ( ( rule__SPViz__Group__0 ) ) ;
    public final void ruleSPViz() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:81:2: ( ( ( rule__SPViz__Group__0 ) ) )
            // InternalSPViz.g:82:2: ( ( rule__SPViz__Group__0 ) )
            {
            // InternalSPViz.g:82:2: ( ( rule__SPViz__Group__0 ) )
            // InternalSPViz.g:83:3: ( rule__SPViz__Group__0 )
            {
             before(grammarAccess.getSPVizAccess().getGroup()); 
            // InternalSPViz.g:84:3: ( rule__SPViz__Group__0 )
            // InternalSPViz.g:84:4: rule__SPViz__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__SPViz__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getSPVizAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleSPViz"


    // $ANTLR start "entryRuleView"
    // InternalSPViz.g:93:1: entryRuleView : ruleView EOF ;
    public final void entryRuleView() throws RecognitionException {
        try {
            // InternalSPViz.g:94:1: ( ruleView EOF )
            // InternalSPViz.g:95:1: ruleView EOF
            {
             before(grammarAccess.getViewRule()); 
            pushFollow(FOLLOW_1);
            ruleView();

            state._fsp--;

             after(grammarAccess.getViewRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleView"


    // $ANTLR start "ruleView"
    // InternalSPViz.g:102:1: ruleView : ( ( rule__View__Group__0 ) ) ;
    public final void ruleView() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:106:2: ( ( ( rule__View__Group__0 ) ) )
            // InternalSPViz.g:107:2: ( ( rule__View__Group__0 ) )
            {
            // InternalSPViz.g:107:2: ( ( rule__View__Group__0 ) )
            // InternalSPViz.g:108:3: ( rule__View__Group__0 )
            {
             before(grammarAccess.getViewAccess().getGroup()); 
            // InternalSPViz.g:109:3: ( rule__View__Group__0 )
            // InternalSPViz.g:109:4: rule__View__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__View__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getViewAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleView"


    // $ANTLR start "entryRuleArtifactShows"
    // InternalSPViz.g:118:1: entryRuleArtifactShows : ruleArtifactShows EOF ;
    public final void entryRuleArtifactShows() throws RecognitionException {
        try {
            // InternalSPViz.g:119:1: ( ruleArtifactShows EOF )
            // InternalSPViz.g:120:1: ruleArtifactShows EOF
            {
             before(grammarAccess.getArtifactShowsRule()); 
            pushFollow(FOLLOW_1);
            ruleArtifactShows();

            state._fsp--;

             after(grammarAccess.getArtifactShowsRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleArtifactShows"


    // $ANTLR start "ruleArtifactShows"
    // InternalSPViz.g:127:1: ruleArtifactShows : ( ( rule__ArtifactShows__Group__0 ) ) ;
    public final void ruleArtifactShows() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:131:2: ( ( ( rule__ArtifactShows__Group__0 ) ) )
            // InternalSPViz.g:132:2: ( ( rule__ArtifactShows__Group__0 ) )
            {
            // InternalSPViz.g:132:2: ( ( rule__ArtifactShows__Group__0 ) )
            // InternalSPViz.g:133:3: ( rule__ArtifactShows__Group__0 )
            {
             before(grammarAccess.getArtifactShowsAccess().getGroup()); 
            // InternalSPViz.g:134:3: ( rule__ArtifactShows__Group__0 )
            // InternalSPViz.g:134:4: rule__ArtifactShows__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactShows__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getArtifactShowsAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleArtifactShows"


    // $ANTLR start "entryRuleArtifactView"
    // InternalSPViz.g:143:1: entryRuleArtifactView : ruleArtifactView EOF ;
    public final void entryRuleArtifactView() throws RecognitionException {
        try {
            // InternalSPViz.g:144:1: ( ruleArtifactView EOF )
            // InternalSPViz.g:145:1: ruleArtifactView EOF
            {
             before(grammarAccess.getArtifactViewRule()); 
            pushFollow(FOLLOW_1);
            ruleArtifactView();

            state._fsp--;

             after(grammarAccess.getArtifactViewRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleArtifactView"


    // $ANTLR start "ruleArtifactView"
    // InternalSPViz.g:152:1: ruleArtifactView : ( ( rule__ArtifactView__Group__0 ) ) ;
    public final void ruleArtifactView() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:156:2: ( ( ( rule__ArtifactView__Group__0 ) ) )
            // InternalSPViz.g:157:2: ( ( rule__ArtifactView__Group__0 ) )
            {
            // InternalSPViz.g:157:2: ( ( rule__ArtifactView__Group__0 ) )
            // InternalSPViz.g:158:3: ( rule__ArtifactView__Group__0 )
            {
             before(grammarAccess.getArtifactViewAccess().getGroup()); 
            // InternalSPViz.g:159:3: ( rule__ArtifactView__Group__0 )
            // InternalSPViz.g:159:4: rule__ArtifactView__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactView__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getArtifactViewAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleArtifactView"


    // $ANTLR start "entryRuleArtifactSource"
    // InternalSPViz.g:168:1: entryRuleArtifactSource : ruleArtifactSource EOF ;
    public final void entryRuleArtifactSource() throws RecognitionException {
        try {
            // InternalSPViz.g:169:1: ( ruleArtifactSource EOF )
            // InternalSPViz.g:170:1: ruleArtifactSource EOF
            {
             before(grammarAccess.getArtifactSourceRule()); 
            pushFollow(FOLLOW_1);
            ruleArtifactSource();

            state._fsp--;

             after(grammarAccess.getArtifactSourceRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleArtifactSource"


    // $ANTLR start "ruleArtifactSource"
    // InternalSPViz.g:177:1: ruleArtifactSource : ( ( rule__ArtifactSource__Group__0 ) ) ;
    public final void ruleArtifactSource() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:181:2: ( ( ( rule__ArtifactSource__Group__0 ) ) )
            // InternalSPViz.g:182:2: ( ( rule__ArtifactSource__Group__0 ) )
            {
            // InternalSPViz.g:182:2: ( ( rule__ArtifactSource__Group__0 ) )
            // InternalSPViz.g:183:3: ( rule__ArtifactSource__Group__0 )
            {
             before(grammarAccess.getArtifactSourceAccess().getGroup()); 
            // InternalSPViz.g:184:3: ( rule__ArtifactSource__Group__0 )
            // InternalSPViz.g:184:4: rule__ArtifactSource__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactSource__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getArtifactSourceAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleArtifactSource"


    // $ANTLR start "entryRuleArtifactChain"
    // InternalSPViz.g:193:1: entryRuleArtifactChain : ruleArtifactChain EOF ;
    public final void entryRuleArtifactChain() throws RecognitionException {
        try {
            // InternalSPViz.g:194:1: ( ruleArtifactChain EOF )
            // InternalSPViz.g:195:1: ruleArtifactChain EOF
            {
             before(grammarAccess.getArtifactChainRule()); 
            pushFollow(FOLLOW_1);
            ruleArtifactChain();

            state._fsp--;

             after(grammarAccess.getArtifactChainRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleArtifactChain"


    // $ANTLR start "ruleArtifactChain"
    // InternalSPViz.g:202:1: ruleArtifactChain : ( ( rule__ArtifactChain__Group__0 ) ) ;
    public final void ruleArtifactChain() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:206:2: ( ( ( rule__ArtifactChain__Group__0 ) ) )
            // InternalSPViz.g:207:2: ( ( rule__ArtifactChain__Group__0 ) )
            {
            // InternalSPViz.g:207:2: ( ( rule__ArtifactChain__Group__0 ) )
            // InternalSPViz.g:208:3: ( rule__ArtifactChain__Group__0 )
            {
             before(grammarAccess.getArtifactChainAccess().getGroup()); 
            // InternalSPViz.g:209:3: ( rule__ArtifactChain__Group__0 )
            // InternalSPViz.g:209:4: rule__ArtifactChain__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactChain__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getArtifactChainAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleArtifactChain"


    // $ANTLR start "entryRuleShownElement"
    // InternalSPViz.g:218:1: entryRuleShownElement : ruleShownElement EOF ;
    public final void entryRuleShownElement() throws RecognitionException {
        try {
            // InternalSPViz.g:219:1: ( ruleShownElement EOF )
            // InternalSPViz.g:220:1: ruleShownElement EOF
            {
             before(grammarAccess.getShownElementRule()); 
            pushFollow(FOLLOW_1);
            ruleShownElement();

            state._fsp--;

             after(grammarAccess.getShownElementRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleShownElement"


    // $ANTLR start "ruleShownElement"
    // InternalSPViz.g:227:1: ruleShownElement : ( ( rule__ShownElement__Group__0 ) ) ;
    public final void ruleShownElement() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:231:2: ( ( ( rule__ShownElement__Group__0 ) ) )
            // InternalSPViz.g:232:2: ( ( rule__ShownElement__Group__0 ) )
            {
            // InternalSPViz.g:232:2: ( ( rule__ShownElement__Group__0 ) )
            // InternalSPViz.g:233:3: ( rule__ShownElement__Group__0 )
            {
             before(grammarAccess.getShownElementAccess().getGroup()); 
            // InternalSPViz.g:234:3: ( rule__ShownElement__Group__0 )
            // InternalSPViz.g:234:4: rule__ShownElement__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__ShownElement__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getShownElementAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleShownElement"


    // $ANTLR start "entryRuleShownConnection"
    // InternalSPViz.g:243:1: entryRuleShownConnection : ruleShownConnection EOF ;
    public final void entryRuleShownConnection() throws RecognitionException {
        try {
            // InternalSPViz.g:244:1: ( ruleShownConnection EOF )
            // InternalSPViz.g:245:1: ruleShownConnection EOF
            {
             before(grammarAccess.getShownConnectionRule()); 
            pushFollow(FOLLOW_1);
            ruleShownConnection();

            state._fsp--;

             after(grammarAccess.getShownConnectionRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleShownConnection"


    // $ANTLR start "ruleShownConnection"
    // InternalSPViz.g:252:1: ruleShownConnection : ( ( rule__ShownConnection__Group__0 ) ) ;
    public final void ruleShownConnection() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:256:2: ( ( ( rule__ShownConnection__Group__0 ) ) )
            // InternalSPViz.g:257:2: ( ( rule__ShownConnection__Group__0 ) )
            {
            // InternalSPViz.g:257:2: ( ( rule__ShownConnection__Group__0 ) )
            // InternalSPViz.g:258:3: ( rule__ShownConnection__Group__0 )
            {
             before(grammarAccess.getShownConnectionAccess().getGroup()); 
            // InternalSPViz.g:259:3: ( rule__ShownConnection__Group__0 )
            // InternalSPViz.g:259:4: rule__ShownConnection__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__ShownConnection__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getShownConnectionAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleShownConnection"


    // $ANTLR start "entryRuleShownCategoryConnection"
    // InternalSPViz.g:268:1: entryRuleShownCategoryConnection : ruleShownCategoryConnection EOF ;
    public final void entryRuleShownCategoryConnection() throws RecognitionException {
        try {
            // InternalSPViz.g:269:1: ( ruleShownCategoryConnection EOF )
            // InternalSPViz.g:270:1: ruleShownCategoryConnection EOF
            {
             before(grammarAccess.getShownCategoryConnectionRule()); 
            pushFollow(FOLLOW_1);
            ruleShownCategoryConnection();

            state._fsp--;

             after(grammarAccess.getShownCategoryConnectionRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleShownCategoryConnection"


    // $ANTLR start "ruleShownCategoryConnection"
    // InternalSPViz.g:277:1: ruleShownCategoryConnection : ( ( rule__ShownCategoryConnection__Group__0 ) ) ;
    public final void ruleShownCategoryConnection() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:281:2: ( ( ( rule__ShownCategoryConnection__Group__0 ) ) )
            // InternalSPViz.g:282:2: ( ( rule__ShownCategoryConnection__Group__0 ) )
            {
            // InternalSPViz.g:282:2: ( ( rule__ShownCategoryConnection__Group__0 ) )
            // InternalSPViz.g:283:3: ( rule__ShownCategoryConnection__Group__0 )
            {
             before(grammarAccess.getShownCategoryConnectionAccess().getGroup()); 
            // InternalSPViz.g:284:3: ( rule__ShownCategoryConnection__Group__0 )
            // InternalSPViz.g:284:4: rule__ShownCategoryConnection__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__ShownCategoryConnection__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getShownCategoryConnectionAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleShownCategoryConnection"


    // $ANTLR start "entryRuleQualifiedName"
    // InternalSPViz.g:293:1: entryRuleQualifiedName : ruleQualifiedName EOF ;
    public final void entryRuleQualifiedName() throws RecognitionException {
        try {
            // InternalSPViz.g:294:1: ( ruleQualifiedName EOF )
            // InternalSPViz.g:295:1: ruleQualifiedName EOF
            {
             before(grammarAccess.getQualifiedNameRule()); 
            pushFollow(FOLLOW_1);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getQualifiedNameRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleQualifiedName"


    // $ANTLR start "ruleQualifiedName"
    // InternalSPViz.g:302:1: ruleQualifiedName : ( ( rule__QualifiedName__Group__0 ) ) ;
    public final void ruleQualifiedName() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:306:2: ( ( ( rule__QualifiedName__Group__0 ) ) )
            // InternalSPViz.g:307:2: ( ( rule__QualifiedName__Group__0 ) )
            {
            // InternalSPViz.g:307:2: ( ( rule__QualifiedName__Group__0 ) )
            // InternalSPViz.g:308:3: ( rule__QualifiedName__Group__0 )
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup()); 
            // InternalSPViz.g:309:3: ( rule__QualifiedName__Group__0 )
            // InternalSPViz.g:309:4: rule__QualifiedName__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__QualifiedName__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getQualifiedNameAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleQualifiedName"


    // $ANTLR start "rule__SPViz__Group__0"
    // InternalSPViz.g:317:1: rule__SPViz__Group__0 : rule__SPViz__Group__0__Impl rule__SPViz__Group__1 ;
    public final void rule__SPViz__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:321:1: ( rule__SPViz__Group__0__Impl rule__SPViz__Group__1 )
            // InternalSPViz.g:322:2: rule__SPViz__Group__0__Impl rule__SPViz__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__SPViz__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPViz__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__0"


    // $ANTLR start "rule__SPViz__Group__0__Impl"
    // InternalSPViz.g:329:1: rule__SPViz__Group__0__Impl : ( 'package' ) ;
    public final void rule__SPViz__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:333:1: ( ( 'package' ) )
            // InternalSPViz.g:334:1: ( 'package' )
            {
            // InternalSPViz.g:334:1: ( 'package' )
            // InternalSPViz.g:335:2: 'package'
            {
             before(grammarAccess.getSPVizAccess().getPackageKeyword_0()); 
            match(input,11,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getPackageKeyword_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__0__Impl"


    // $ANTLR start "rule__SPViz__Group__1"
    // InternalSPViz.g:344:1: rule__SPViz__Group__1 : rule__SPViz__Group__1__Impl rule__SPViz__Group__2 ;
    public final void rule__SPViz__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:348:1: ( rule__SPViz__Group__1__Impl rule__SPViz__Group__2 )
            // InternalSPViz.g:349:2: rule__SPViz__Group__1__Impl rule__SPViz__Group__2
            {
            pushFollow(FOLLOW_4);
            rule__SPViz__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPViz__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__1"


    // $ANTLR start "rule__SPViz__Group__1__Impl"
    // InternalSPViz.g:356:1: rule__SPViz__Group__1__Impl : ( ( rule__SPViz__PackageAssignment_1 ) ) ;
    public final void rule__SPViz__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:360:1: ( ( ( rule__SPViz__PackageAssignment_1 ) ) )
            // InternalSPViz.g:361:1: ( ( rule__SPViz__PackageAssignment_1 ) )
            {
            // InternalSPViz.g:361:1: ( ( rule__SPViz__PackageAssignment_1 ) )
            // InternalSPViz.g:362:2: ( rule__SPViz__PackageAssignment_1 )
            {
             before(grammarAccess.getSPVizAccess().getPackageAssignment_1()); 
            // InternalSPViz.g:363:2: ( rule__SPViz__PackageAssignment_1 )
            // InternalSPViz.g:363:3: rule__SPViz__PackageAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__SPViz__PackageAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getSPVizAccess().getPackageAssignment_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__1__Impl"


    // $ANTLR start "rule__SPViz__Group__2"
    // InternalSPViz.g:371:1: rule__SPViz__Group__2 : rule__SPViz__Group__2__Impl rule__SPViz__Group__3 ;
    public final void rule__SPViz__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:375:1: ( rule__SPViz__Group__2__Impl rule__SPViz__Group__3 )
            // InternalSPViz.g:376:2: rule__SPViz__Group__2__Impl rule__SPViz__Group__3
            {
            pushFollow(FOLLOW_5);
            rule__SPViz__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPViz__Group__3();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__2"


    // $ANTLR start "rule__SPViz__Group__2__Impl"
    // InternalSPViz.g:383:1: rule__SPViz__Group__2__Impl : ( 'import' ) ;
    public final void rule__SPViz__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:387:1: ( ( 'import' ) )
            // InternalSPViz.g:388:1: ( 'import' )
            {
            // InternalSPViz.g:388:1: ( 'import' )
            // InternalSPViz.g:389:2: 'import'
            {
             before(grammarAccess.getSPVizAccess().getImportKeyword_2()); 
            match(input,12,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getImportKeyword_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__2__Impl"


    // $ANTLR start "rule__SPViz__Group__3"
    // InternalSPViz.g:398:1: rule__SPViz__Group__3 : rule__SPViz__Group__3__Impl rule__SPViz__Group__4 ;
    public final void rule__SPViz__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:402:1: ( rule__SPViz__Group__3__Impl rule__SPViz__Group__4 )
            // InternalSPViz.g:403:2: rule__SPViz__Group__3__Impl rule__SPViz__Group__4
            {
            pushFollow(FOLLOW_6);
            rule__SPViz__Group__3__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPViz__Group__4();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__3"


    // $ANTLR start "rule__SPViz__Group__3__Impl"
    // InternalSPViz.g:410:1: rule__SPViz__Group__3__Impl : ( ( rule__SPViz__ImportURIAssignment_3 ) ) ;
    public final void rule__SPViz__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:414:1: ( ( ( rule__SPViz__ImportURIAssignment_3 ) ) )
            // InternalSPViz.g:415:1: ( ( rule__SPViz__ImportURIAssignment_3 ) )
            {
            // InternalSPViz.g:415:1: ( ( rule__SPViz__ImportURIAssignment_3 ) )
            // InternalSPViz.g:416:2: ( rule__SPViz__ImportURIAssignment_3 )
            {
             before(grammarAccess.getSPVizAccess().getImportURIAssignment_3()); 
            // InternalSPViz.g:417:2: ( rule__SPViz__ImportURIAssignment_3 )
            // InternalSPViz.g:417:3: rule__SPViz__ImportURIAssignment_3
            {
            pushFollow(FOLLOW_2);
            rule__SPViz__ImportURIAssignment_3();

            state._fsp--;


            }

             after(grammarAccess.getSPVizAccess().getImportURIAssignment_3()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__3__Impl"


    // $ANTLR start "rule__SPViz__Group__4"
    // InternalSPViz.g:425:1: rule__SPViz__Group__4 : rule__SPViz__Group__4__Impl rule__SPViz__Group__5 ;
    public final void rule__SPViz__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:429:1: ( rule__SPViz__Group__4__Impl rule__SPViz__Group__5 )
            // InternalSPViz.g:430:2: rule__SPViz__Group__4__Impl rule__SPViz__Group__5
            {
            pushFollow(FOLLOW_3);
            rule__SPViz__Group__4__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPViz__Group__5();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__4"


    // $ANTLR start "rule__SPViz__Group__4__Impl"
    // InternalSPViz.g:437:1: rule__SPViz__Group__4__Impl : ( 'SPViz' ) ;
    public final void rule__SPViz__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:441:1: ( ( 'SPViz' ) )
            // InternalSPViz.g:442:1: ( 'SPViz' )
            {
            // InternalSPViz.g:442:1: ( 'SPViz' )
            // InternalSPViz.g:443:2: 'SPViz'
            {
             before(grammarAccess.getSPVizAccess().getSPVizKeyword_4()); 
            match(input,13,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getSPVizKeyword_4()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__4__Impl"


    // $ANTLR start "rule__SPViz__Group__5"
    // InternalSPViz.g:452:1: rule__SPViz__Group__5 : rule__SPViz__Group__5__Impl rule__SPViz__Group__6 ;
    public final void rule__SPViz__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:456:1: ( rule__SPViz__Group__5__Impl rule__SPViz__Group__6 )
            // InternalSPViz.g:457:2: rule__SPViz__Group__5__Impl rule__SPViz__Group__6
            {
            pushFollow(FOLLOW_7);
            rule__SPViz__Group__5__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPViz__Group__6();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__5"


    // $ANTLR start "rule__SPViz__Group__5__Impl"
    // InternalSPViz.g:464:1: rule__SPViz__Group__5__Impl : ( ( rule__SPViz__NameAssignment_5 ) ) ;
    public final void rule__SPViz__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:468:1: ( ( ( rule__SPViz__NameAssignment_5 ) ) )
            // InternalSPViz.g:469:1: ( ( rule__SPViz__NameAssignment_5 ) )
            {
            // InternalSPViz.g:469:1: ( ( rule__SPViz__NameAssignment_5 ) )
            // InternalSPViz.g:470:2: ( rule__SPViz__NameAssignment_5 )
            {
             before(grammarAccess.getSPVizAccess().getNameAssignment_5()); 
            // InternalSPViz.g:471:2: ( rule__SPViz__NameAssignment_5 )
            // InternalSPViz.g:471:3: rule__SPViz__NameAssignment_5
            {
            pushFollow(FOLLOW_2);
            rule__SPViz__NameAssignment_5();

            state._fsp--;


            }

             after(grammarAccess.getSPVizAccess().getNameAssignment_5()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__5__Impl"


    // $ANTLR start "rule__SPViz__Group__6"
    // InternalSPViz.g:479:1: rule__SPViz__Group__6 : rule__SPViz__Group__6__Impl rule__SPViz__Group__7 ;
    public final void rule__SPViz__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:483:1: ( rule__SPViz__Group__6__Impl rule__SPViz__Group__7 )
            // InternalSPViz.g:484:2: rule__SPViz__Group__6__Impl rule__SPViz__Group__7
            {
            pushFollow(FOLLOW_8);
            rule__SPViz__Group__6__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPViz__Group__7();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__6"


    // $ANTLR start "rule__SPViz__Group__6__Impl"
    // InternalSPViz.g:491:1: rule__SPViz__Group__6__Impl : ( '{' ) ;
    public final void rule__SPViz__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:495:1: ( ( '{' ) )
            // InternalSPViz.g:496:1: ( '{' )
            {
            // InternalSPViz.g:496:1: ( '{' )
            // InternalSPViz.g:497:2: '{'
            {
             before(grammarAccess.getSPVizAccess().getLeftCurlyBracketKeyword_6()); 
            match(input,14,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getLeftCurlyBracketKeyword_6()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__6__Impl"


    // $ANTLR start "rule__SPViz__Group__7"
    // InternalSPViz.g:506:1: rule__SPViz__Group__7 : rule__SPViz__Group__7__Impl rule__SPViz__Group__8 ;
    public final void rule__SPViz__Group__7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:510:1: ( rule__SPViz__Group__7__Impl rule__SPViz__Group__8 )
            // InternalSPViz.g:511:2: rule__SPViz__Group__7__Impl rule__SPViz__Group__8
            {
            pushFollow(FOLLOW_8);
            rule__SPViz__Group__7__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPViz__Group__8();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__7"


    // $ANTLR start "rule__SPViz__Group__7__Impl"
    // InternalSPViz.g:518:1: rule__SPViz__Group__7__Impl : ( ( rule__SPViz__ViewsAssignment_7 )* ) ;
    public final void rule__SPViz__Group__7__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:522:1: ( ( ( rule__SPViz__ViewsAssignment_7 )* ) )
            // InternalSPViz.g:523:1: ( ( rule__SPViz__ViewsAssignment_7 )* )
            {
            // InternalSPViz.g:523:1: ( ( rule__SPViz__ViewsAssignment_7 )* )
            // InternalSPViz.g:524:2: ( rule__SPViz__ViewsAssignment_7 )*
            {
             before(grammarAccess.getSPVizAccess().getViewsAssignment_7()); 
            // InternalSPViz.g:525:2: ( rule__SPViz__ViewsAssignment_7 )*
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
            	    // InternalSPViz.g:525:3: rule__SPViz__ViewsAssignment_7
            	    {
            	    pushFollow(FOLLOW_9);
            	    rule__SPViz__ViewsAssignment_7();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

             after(grammarAccess.getSPVizAccess().getViewsAssignment_7()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__7__Impl"


    // $ANTLR start "rule__SPViz__Group__8"
    // InternalSPViz.g:533:1: rule__SPViz__Group__8 : rule__SPViz__Group__8__Impl rule__SPViz__Group__9 ;
    public final void rule__SPViz__Group__8() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:537:1: ( rule__SPViz__Group__8__Impl rule__SPViz__Group__9 )
            // InternalSPViz.g:538:2: rule__SPViz__Group__8__Impl rule__SPViz__Group__9
            {
            pushFollow(FOLLOW_8);
            rule__SPViz__Group__8__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPViz__Group__9();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__8"


    // $ANTLR start "rule__SPViz__Group__8__Impl"
    // InternalSPViz.g:545:1: rule__SPViz__Group__8__Impl : ( ( rule__SPViz__ArtifactShowsAssignment_8 )* ) ;
    public final void rule__SPViz__Group__8__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:549:1: ( ( ( rule__SPViz__ArtifactShowsAssignment_8 )* ) )
            // InternalSPViz.g:550:1: ( ( rule__SPViz__ArtifactShowsAssignment_8 )* )
            {
            // InternalSPViz.g:550:1: ( ( rule__SPViz__ArtifactShowsAssignment_8 )* )
            // InternalSPViz.g:551:2: ( rule__SPViz__ArtifactShowsAssignment_8 )*
            {
             before(grammarAccess.getSPVizAccess().getArtifactShowsAssignment_8()); 
            // InternalSPViz.g:552:2: ( rule__SPViz__ArtifactShowsAssignment_8 )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==RULE_ID) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // InternalSPViz.g:552:3: rule__SPViz__ArtifactShowsAssignment_8
            	    {
            	    pushFollow(FOLLOW_9);
            	    rule__SPViz__ArtifactShowsAssignment_8();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop2;
                }
            } while (true);

             after(grammarAccess.getSPVizAccess().getArtifactShowsAssignment_8()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__8__Impl"


    // $ANTLR start "rule__SPViz__Group__9"
    // InternalSPViz.g:560:1: rule__SPViz__Group__9 : rule__SPViz__Group__9__Impl ;
    public final void rule__SPViz__Group__9() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:564:1: ( rule__SPViz__Group__9__Impl )
            // InternalSPViz.g:565:2: rule__SPViz__Group__9__Impl
            {
            pushFollow(FOLLOW_2);
            rule__SPViz__Group__9__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__9"


    // $ANTLR start "rule__SPViz__Group__9__Impl"
    // InternalSPViz.g:571:1: rule__SPViz__Group__9__Impl : ( '}' ) ;
    public final void rule__SPViz__Group__9__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:575:1: ( ( '}' ) )
            // InternalSPViz.g:576:1: ( '}' )
            {
            // InternalSPViz.g:576:1: ( '}' )
            // InternalSPViz.g:577:2: '}'
            {
             before(grammarAccess.getSPVizAccess().getRightCurlyBracketKeyword_9()); 
            match(input,15,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getRightCurlyBracketKeyword_9()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__Group__9__Impl"


    // $ANTLR start "rule__View__Group__0"
    // InternalSPViz.g:587:1: rule__View__Group__0 : rule__View__Group__0__Impl rule__View__Group__1 ;
    public final void rule__View__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:591:1: ( rule__View__Group__0__Impl rule__View__Group__1 )
            // InternalSPViz.g:592:2: rule__View__Group__0__Impl rule__View__Group__1
            {
            pushFollow(FOLLOW_7);
            rule__View__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__View__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__0"


    // $ANTLR start "rule__View__Group__0__Impl"
    // InternalSPViz.g:599:1: rule__View__Group__0__Impl : ( ( rule__View__NameAssignment_0 ) ) ;
    public final void rule__View__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:603:1: ( ( ( rule__View__NameAssignment_0 ) ) )
            // InternalSPViz.g:604:1: ( ( rule__View__NameAssignment_0 ) )
            {
            // InternalSPViz.g:604:1: ( ( rule__View__NameAssignment_0 ) )
            // InternalSPViz.g:605:2: ( rule__View__NameAssignment_0 )
            {
             before(grammarAccess.getViewAccess().getNameAssignment_0()); 
            // InternalSPViz.g:606:2: ( rule__View__NameAssignment_0 )
            // InternalSPViz.g:606:3: rule__View__NameAssignment_0
            {
            pushFollow(FOLLOW_2);
            rule__View__NameAssignment_0();

            state._fsp--;


            }

             after(grammarAccess.getViewAccess().getNameAssignment_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__0__Impl"


    // $ANTLR start "rule__View__Group__1"
    // InternalSPViz.g:614:1: rule__View__Group__1 : rule__View__Group__1__Impl rule__View__Group__2 ;
    public final void rule__View__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:618:1: ( rule__View__Group__1__Impl rule__View__Group__2 )
            // InternalSPViz.g:619:2: rule__View__Group__1__Impl rule__View__Group__2
            {
            pushFollow(FOLLOW_10);
            rule__View__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__View__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__1"


    // $ANTLR start "rule__View__Group__1__Impl"
    // InternalSPViz.g:626:1: rule__View__Group__1__Impl : ( '{' ) ;
    public final void rule__View__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:630:1: ( ( '{' ) )
            // InternalSPViz.g:631:1: ( '{' )
            {
            // InternalSPViz.g:631:1: ( '{' )
            // InternalSPViz.g:632:2: '{'
            {
             before(grammarAccess.getViewAccess().getLeftCurlyBracketKeyword_1()); 
            match(input,14,FOLLOW_2); 
             after(grammarAccess.getViewAccess().getLeftCurlyBracketKeyword_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__1__Impl"


    // $ANTLR start "rule__View__Group__2"
    // InternalSPViz.g:641:1: rule__View__Group__2 : rule__View__Group__2__Impl rule__View__Group__3 ;
    public final void rule__View__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:645:1: ( rule__View__Group__2__Impl rule__View__Group__3 )
            // InternalSPViz.g:646:2: rule__View__Group__2__Impl rule__View__Group__3
            {
            pushFollow(FOLLOW_10);
            rule__View__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__View__Group__3();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__2"


    // $ANTLR start "rule__View__Group__2__Impl"
    // InternalSPViz.g:653:1: rule__View__Group__2__Impl : ( ( rule__View__ShownElementsAssignment_2 )* ) ;
    public final void rule__View__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:657:1: ( ( ( rule__View__ShownElementsAssignment_2 )* ) )
            // InternalSPViz.g:658:1: ( ( rule__View__ShownElementsAssignment_2 )* )
            {
            // InternalSPViz.g:658:1: ( ( rule__View__ShownElementsAssignment_2 )* )
            // InternalSPViz.g:659:2: ( rule__View__ShownElementsAssignment_2 )*
            {
             before(grammarAccess.getViewAccess().getShownElementsAssignment_2()); 
            // InternalSPViz.g:660:2: ( rule__View__ShownElementsAssignment_2 )*
            loop3:
            do {
                int alt3=2;
                int LA3_0 = input.LA(1);

                if ( (LA3_0==20) ) {
                    alt3=1;
                }


                switch (alt3) {
            	case 1 :
            	    // InternalSPViz.g:660:3: rule__View__ShownElementsAssignment_2
            	    {
            	    pushFollow(FOLLOW_11);
            	    rule__View__ShownElementsAssignment_2();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop3;
                }
            } while (true);

             after(grammarAccess.getViewAccess().getShownElementsAssignment_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__2__Impl"


    // $ANTLR start "rule__View__Group__3"
    // InternalSPViz.g:668:1: rule__View__Group__3 : rule__View__Group__3__Impl rule__View__Group__4 ;
    public final void rule__View__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:672:1: ( rule__View__Group__3__Impl rule__View__Group__4 )
            // InternalSPViz.g:673:2: rule__View__Group__3__Impl rule__View__Group__4
            {
            pushFollow(FOLLOW_10);
            rule__View__Group__3__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__View__Group__4();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__3"


    // $ANTLR start "rule__View__Group__3__Impl"
    // InternalSPViz.g:680:1: rule__View__Group__3__Impl : ( ( rule__View__ShownConnectionsAssignment_3 )* ) ;
    public final void rule__View__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:684:1: ( ( ( rule__View__ShownConnectionsAssignment_3 )* ) )
            // InternalSPViz.g:685:1: ( ( rule__View__ShownConnectionsAssignment_3 )* )
            {
            // InternalSPViz.g:685:1: ( ( rule__View__ShownConnectionsAssignment_3 )* )
            // InternalSPViz.g:686:2: ( rule__View__ShownConnectionsAssignment_3 )*
            {
             before(grammarAccess.getViewAccess().getShownConnectionsAssignment_3()); 
            // InternalSPViz.g:687:2: ( rule__View__ShownConnectionsAssignment_3 )*
            loop4:
            do {
                int alt4=2;
                alt4 = dfa4.predict(input);
                switch (alt4) {
            	case 1 :
            	    // InternalSPViz.g:687:3: rule__View__ShownConnectionsAssignment_3
            	    {
            	    pushFollow(FOLLOW_12);
            	    rule__View__ShownConnectionsAssignment_3();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop4;
                }
            } while (true);

             after(grammarAccess.getViewAccess().getShownConnectionsAssignment_3()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__3__Impl"


    // $ANTLR start "rule__View__Group__4"
    // InternalSPViz.g:695:1: rule__View__Group__4 : rule__View__Group__4__Impl rule__View__Group__5 ;
    public final void rule__View__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:699:1: ( rule__View__Group__4__Impl rule__View__Group__5 )
            // InternalSPViz.g:700:2: rule__View__Group__4__Impl rule__View__Group__5
            {
            pushFollow(FOLLOW_10);
            rule__View__Group__4__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__View__Group__5();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__4"


    // $ANTLR start "rule__View__Group__4__Impl"
    // InternalSPViz.g:707:1: rule__View__Group__4__Impl : ( ( rule__View__ShownCategoryConnectionsAssignment_4 )* ) ;
    public final void rule__View__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:711:1: ( ( ( rule__View__ShownCategoryConnectionsAssignment_4 )* ) )
            // InternalSPViz.g:712:1: ( ( rule__View__ShownCategoryConnectionsAssignment_4 )* )
            {
            // InternalSPViz.g:712:1: ( ( rule__View__ShownCategoryConnectionsAssignment_4 )* )
            // InternalSPViz.g:713:2: ( rule__View__ShownCategoryConnectionsAssignment_4 )*
            {
             before(grammarAccess.getViewAccess().getShownCategoryConnectionsAssignment_4()); 
            // InternalSPViz.g:714:2: ( rule__View__ShownCategoryConnectionsAssignment_4 )*
            loop5:
            do {
                int alt5=2;
                int LA5_0 = input.LA(1);

                if ( (LA5_0==22) ) {
                    alt5=1;
                }


                switch (alt5) {
            	case 1 :
            	    // InternalSPViz.g:714:3: rule__View__ShownCategoryConnectionsAssignment_4
            	    {
            	    pushFollow(FOLLOW_12);
            	    rule__View__ShownCategoryConnectionsAssignment_4();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop5;
                }
            } while (true);

             after(grammarAccess.getViewAccess().getShownCategoryConnectionsAssignment_4()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__4__Impl"


    // $ANTLR start "rule__View__Group__5"
    // InternalSPViz.g:722:1: rule__View__Group__5 : rule__View__Group__5__Impl ;
    public final void rule__View__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:726:1: ( rule__View__Group__5__Impl )
            // InternalSPViz.g:727:2: rule__View__Group__5__Impl
            {
            pushFollow(FOLLOW_2);
            rule__View__Group__5__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__5"


    // $ANTLR start "rule__View__Group__5__Impl"
    // InternalSPViz.g:733:1: rule__View__Group__5__Impl : ( '}' ) ;
    public final void rule__View__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:737:1: ( ( '}' ) )
            // InternalSPViz.g:738:1: ( '}' )
            {
            // InternalSPViz.g:738:1: ( '}' )
            // InternalSPViz.g:739:2: '}'
            {
             before(grammarAccess.getViewAccess().getRightCurlyBracketKeyword_5()); 
            match(input,15,FOLLOW_2); 
             after(grammarAccess.getViewAccess().getRightCurlyBracketKeyword_5()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__Group__5__Impl"


    // $ANTLR start "rule__ArtifactShows__Group__0"
    // InternalSPViz.g:749:1: rule__ArtifactShows__Group__0 : rule__ArtifactShows__Group__0__Impl rule__ArtifactShows__Group__1 ;
    public final void rule__ArtifactShows__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:753:1: ( rule__ArtifactShows__Group__0__Impl rule__ArtifactShows__Group__1 )
            // InternalSPViz.g:754:2: rule__ArtifactShows__Group__0__Impl rule__ArtifactShows__Group__1
            {
            pushFollow(FOLLOW_13);
            rule__ArtifactShows__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactShows__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__Group__0"


    // $ANTLR start "rule__ArtifactShows__Group__0__Impl"
    // InternalSPViz.g:761:1: rule__ArtifactShows__Group__0__Impl : ( ( rule__ArtifactShows__ArtifactShowsAssignment_0 ) ) ;
    public final void rule__ArtifactShows__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:765:1: ( ( ( rule__ArtifactShows__ArtifactShowsAssignment_0 ) ) )
            // InternalSPViz.g:766:1: ( ( rule__ArtifactShows__ArtifactShowsAssignment_0 ) )
            {
            // InternalSPViz.g:766:1: ( ( rule__ArtifactShows__ArtifactShowsAssignment_0 ) )
            // InternalSPViz.g:767:2: ( rule__ArtifactShows__ArtifactShowsAssignment_0 )
            {
             before(grammarAccess.getArtifactShowsAccess().getArtifactShowsAssignment_0()); 
            // InternalSPViz.g:768:2: ( rule__ArtifactShows__ArtifactShowsAssignment_0 )
            // InternalSPViz.g:768:3: rule__ArtifactShows__ArtifactShowsAssignment_0
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactShows__ArtifactShowsAssignment_0();

            state._fsp--;


            }

             after(grammarAccess.getArtifactShowsAccess().getArtifactShowsAssignment_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__Group__0__Impl"


    // $ANTLR start "rule__ArtifactShows__Group__1"
    // InternalSPViz.g:776:1: rule__ArtifactShows__Group__1 : rule__ArtifactShows__Group__1__Impl rule__ArtifactShows__Group__2 ;
    public final void rule__ArtifactShows__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:780:1: ( rule__ArtifactShows__Group__1__Impl rule__ArtifactShows__Group__2 )
            // InternalSPViz.g:781:2: rule__ArtifactShows__Group__1__Impl rule__ArtifactShows__Group__2
            {
            pushFollow(FOLLOW_7);
            rule__ArtifactShows__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactShows__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__Group__1"


    // $ANTLR start "rule__ArtifactShows__Group__1__Impl"
    // InternalSPViz.g:788:1: rule__ArtifactShows__Group__1__Impl : ( 'shows' ) ;
    public final void rule__ArtifactShows__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:792:1: ( ( 'shows' ) )
            // InternalSPViz.g:793:1: ( 'shows' )
            {
            // InternalSPViz.g:793:1: ( 'shows' )
            // InternalSPViz.g:794:2: 'shows'
            {
             before(grammarAccess.getArtifactShowsAccess().getShowsKeyword_1()); 
            match(input,16,FOLLOW_2); 
             after(grammarAccess.getArtifactShowsAccess().getShowsKeyword_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__Group__1__Impl"


    // $ANTLR start "rule__ArtifactShows__Group__2"
    // InternalSPViz.g:803:1: rule__ArtifactShows__Group__2 : rule__ArtifactShows__Group__2__Impl rule__ArtifactShows__Group__3 ;
    public final void rule__ArtifactShows__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:807:1: ( rule__ArtifactShows__Group__2__Impl rule__ArtifactShows__Group__3 )
            // InternalSPViz.g:808:2: rule__ArtifactShows__Group__2__Impl rule__ArtifactShows__Group__3
            {
            pushFollow(FOLLOW_8);
            rule__ArtifactShows__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactShows__Group__3();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__Group__2"


    // $ANTLR start "rule__ArtifactShows__Group__2__Impl"
    // InternalSPViz.g:815:1: rule__ArtifactShows__Group__2__Impl : ( '{' ) ;
    public final void rule__ArtifactShows__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:819:1: ( ( '{' ) )
            // InternalSPViz.g:820:1: ( '{' )
            {
            // InternalSPViz.g:820:1: ( '{' )
            // InternalSPViz.g:821:2: '{'
            {
             before(grammarAccess.getArtifactShowsAccess().getLeftCurlyBracketKeyword_2()); 
            match(input,14,FOLLOW_2); 
             after(grammarAccess.getArtifactShowsAccess().getLeftCurlyBracketKeyword_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__Group__2__Impl"


    // $ANTLR start "rule__ArtifactShows__Group__3"
    // InternalSPViz.g:830:1: rule__ArtifactShows__Group__3 : rule__ArtifactShows__Group__3__Impl rule__ArtifactShows__Group__4 ;
    public final void rule__ArtifactShows__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:834:1: ( rule__ArtifactShows__Group__3__Impl rule__ArtifactShows__Group__4 )
            // InternalSPViz.g:835:2: rule__ArtifactShows__Group__3__Impl rule__ArtifactShows__Group__4
            {
            pushFollow(FOLLOW_8);
            rule__ArtifactShows__Group__3__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactShows__Group__4();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__Group__3"


    // $ANTLR start "rule__ArtifactShows__Group__3__Impl"
    // InternalSPViz.g:842:1: rule__ArtifactShows__Group__3__Impl : ( ( rule__ArtifactShows__ViewsAssignment_3 )* ) ;
    public final void rule__ArtifactShows__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:846:1: ( ( ( rule__ArtifactShows__ViewsAssignment_3 )* ) )
            // InternalSPViz.g:847:1: ( ( rule__ArtifactShows__ViewsAssignment_3 )* )
            {
            // InternalSPViz.g:847:1: ( ( rule__ArtifactShows__ViewsAssignment_3 )* )
            // InternalSPViz.g:848:2: ( rule__ArtifactShows__ViewsAssignment_3 )*
            {
             before(grammarAccess.getArtifactShowsAccess().getViewsAssignment_3()); 
            // InternalSPViz.g:849:2: ( rule__ArtifactShows__ViewsAssignment_3 )*
            loop6:
            do {
                int alt6=2;
                int LA6_0 = input.LA(1);

                if ( (LA6_0==RULE_ID) ) {
                    alt6=1;
                }


                switch (alt6) {
            	case 1 :
            	    // InternalSPViz.g:849:3: rule__ArtifactShows__ViewsAssignment_3
            	    {
            	    pushFollow(FOLLOW_9);
            	    rule__ArtifactShows__ViewsAssignment_3();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop6;
                }
            } while (true);

             after(grammarAccess.getArtifactShowsAccess().getViewsAssignment_3()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__Group__3__Impl"


    // $ANTLR start "rule__ArtifactShows__Group__4"
    // InternalSPViz.g:857:1: rule__ArtifactShows__Group__4 : rule__ArtifactShows__Group__4__Impl ;
    public final void rule__ArtifactShows__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:861:1: ( rule__ArtifactShows__Group__4__Impl )
            // InternalSPViz.g:862:2: rule__ArtifactShows__Group__4__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactShows__Group__4__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__Group__4"


    // $ANTLR start "rule__ArtifactShows__Group__4__Impl"
    // InternalSPViz.g:868:1: rule__ArtifactShows__Group__4__Impl : ( '}' ) ;
    public final void rule__ArtifactShows__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:872:1: ( ( '}' ) )
            // InternalSPViz.g:873:1: ( '}' )
            {
            // InternalSPViz.g:873:1: ( '}' )
            // InternalSPViz.g:874:2: '}'
            {
             before(grammarAccess.getArtifactShowsAccess().getRightCurlyBracketKeyword_4()); 
            match(input,15,FOLLOW_2); 
             after(grammarAccess.getArtifactShowsAccess().getRightCurlyBracketKeyword_4()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__Group__4__Impl"


    // $ANTLR start "rule__ArtifactView__Group__0"
    // InternalSPViz.g:884:1: rule__ArtifactView__Group__0 : rule__ArtifactView__Group__0__Impl rule__ArtifactView__Group__1 ;
    public final void rule__ArtifactView__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:888:1: ( rule__ArtifactView__Group__0__Impl rule__ArtifactView__Group__1 )
            // InternalSPViz.g:889:2: rule__ArtifactView__Group__0__Impl rule__ArtifactView__Group__1
            {
            pushFollow(FOLLOW_14);
            rule__ArtifactView__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactView__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__Group__0"


    // $ANTLR start "rule__ArtifactView__Group__0__Impl"
    // InternalSPViz.g:896:1: rule__ArtifactView__Group__0__Impl : ( ( rule__ArtifactView__ViewAssignment_0 ) ) ;
    public final void rule__ArtifactView__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:900:1: ( ( ( rule__ArtifactView__ViewAssignment_0 ) ) )
            // InternalSPViz.g:901:1: ( ( rule__ArtifactView__ViewAssignment_0 ) )
            {
            // InternalSPViz.g:901:1: ( ( rule__ArtifactView__ViewAssignment_0 ) )
            // InternalSPViz.g:902:2: ( rule__ArtifactView__ViewAssignment_0 )
            {
             before(grammarAccess.getArtifactViewAccess().getViewAssignment_0()); 
            // InternalSPViz.g:903:2: ( rule__ArtifactView__ViewAssignment_0 )
            // InternalSPViz.g:903:3: rule__ArtifactView__ViewAssignment_0
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactView__ViewAssignment_0();

            state._fsp--;


            }

             after(grammarAccess.getArtifactViewAccess().getViewAssignment_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__Group__0__Impl"


    // $ANTLR start "rule__ArtifactView__Group__1"
    // InternalSPViz.g:911:1: rule__ArtifactView__Group__1 : rule__ArtifactView__Group__1__Impl rule__ArtifactView__Group__2 ;
    public final void rule__ArtifactView__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:915:1: ( rule__ArtifactView__Group__1__Impl rule__ArtifactView__Group__2 )
            // InternalSPViz.g:916:2: rule__ArtifactView__Group__1__Impl rule__ArtifactView__Group__2
            {
            pushFollow(FOLLOW_7);
            rule__ArtifactView__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactView__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__Group__1"


    // $ANTLR start "rule__ArtifactView__Group__1__Impl"
    // InternalSPViz.g:923:1: rule__ArtifactView__Group__1__Impl : ( 'with' ) ;
    public final void rule__ArtifactView__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:927:1: ( ( 'with' ) )
            // InternalSPViz.g:928:1: ( 'with' )
            {
            // InternalSPViz.g:928:1: ( 'with' )
            // InternalSPViz.g:929:2: 'with'
            {
             before(grammarAccess.getArtifactViewAccess().getWithKeyword_1()); 
            match(input,17,FOLLOW_2); 
             after(grammarAccess.getArtifactViewAccess().getWithKeyword_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__Group__1__Impl"


    // $ANTLR start "rule__ArtifactView__Group__2"
    // InternalSPViz.g:938:1: rule__ArtifactView__Group__2 : rule__ArtifactView__Group__2__Impl rule__ArtifactView__Group__3 ;
    public final void rule__ArtifactView__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:942:1: ( rule__ArtifactView__Group__2__Impl rule__ArtifactView__Group__3 )
            // InternalSPViz.g:943:2: rule__ArtifactView__Group__2__Impl rule__ArtifactView__Group__3
            {
            pushFollow(FOLLOW_8);
            rule__ArtifactView__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactView__Group__3();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__Group__2"


    // $ANTLR start "rule__ArtifactView__Group__2__Impl"
    // InternalSPViz.g:950:1: rule__ArtifactView__Group__2__Impl : ( '{' ) ;
    public final void rule__ArtifactView__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:954:1: ( ( '{' ) )
            // InternalSPViz.g:955:1: ( '{' )
            {
            // InternalSPViz.g:955:1: ( '{' )
            // InternalSPViz.g:956:2: '{'
            {
             before(grammarAccess.getArtifactViewAccess().getLeftCurlyBracketKeyword_2()); 
            match(input,14,FOLLOW_2); 
             after(grammarAccess.getArtifactViewAccess().getLeftCurlyBracketKeyword_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__Group__2__Impl"


    // $ANTLR start "rule__ArtifactView__Group__3"
    // InternalSPViz.g:965:1: rule__ArtifactView__Group__3 : rule__ArtifactView__Group__3__Impl rule__ArtifactView__Group__4 ;
    public final void rule__ArtifactView__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:969:1: ( rule__ArtifactView__Group__3__Impl rule__ArtifactView__Group__4 )
            // InternalSPViz.g:970:2: rule__ArtifactView__Group__3__Impl rule__ArtifactView__Group__4
            {
            pushFollow(FOLLOW_8);
            rule__ArtifactView__Group__3__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactView__Group__4();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__Group__3"


    // $ANTLR start "rule__ArtifactView__Group__3__Impl"
    // InternalSPViz.g:977:1: rule__ArtifactView__Group__3__Impl : ( ( rule__ArtifactView__SourcesAssignment_3 )* ) ;
    public final void rule__ArtifactView__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:981:1: ( ( ( rule__ArtifactView__SourcesAssignment_3 )* ) )
            // InternalSPViz.g:982:1: ( ( rule__ArtifactView__SourcesAssignment_3 )* )
            {
            // InternalSPViz.g:982:1: ( ( rule__ArtifactView__SourcesAssignment_3 )* )
            // InternalSPViz.g:983:2: ( rule__ArtifactView__SourcesAssignment_3 )*
            {
             before(grammarAccess.getArtifactViewAccess().getSourcesAssignment_3()); 
            // InternalSPViz.g:984:2: ( rule__ArtifactView__SourcesAssignment_3 )*
            loop7:
            do {
                int alt7=2;
                int LA7_0 = input.LA(1);

                if ( (LA7_0==RULE_ID) ) {
                    alt7=1;
                }


                switch (alt7) {
            	case 1 :
            	    // InternalSPViz.g:984:3: rule__ArtifactView__SourcesAssignment_3
            	    {
            	    pushFollow(FOLLOW_9);
            	    rule__ArtifactView__SourcesAssignment_3();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop7;
                }
            } while (true);

             after(grammarAccess.getArtifactViewAccess().getSourcesAssignment_3()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__Group__3__Impl"


    // $ANTLR start "rule__ArtifactView__Group__4"
    // InternalSPViz.g:992:1: rule__ArtifactView__Group__4 : rule__ArtifactView__Group__4__Impl ;
    public final void rule__ArtifactView__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:996:1: ( rule__ArtifactView__Group__4__Impl )
            // InternalSPViz.g:997:2: rule__ArtifactView__Group__4__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactView__Group__4__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__Group__4"


    // $ANTLR start "rule__ArtifactView__Group__4__Impl"
    // InternalSPViz.g:1003:1: rule__ArtifactView__Group__4__Impl : ( '}' ) ;
    public final void rule__ArtifactView__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1007:1: ( ( '}' ) )
            // InternalSPViz.g:1008:1: ( '}' )
            {
            // InternalSPViz.g:1008:1: ( '}' )
            // InternalSPViz.g:1009:2: '}'
            {
             before(grammarAccess.getArtifactViewAccess().getRightCurlyBracketKeyword_4()); 
            match(input,15,FOLLOW_2); 
             after(grammarAccess.getArtifactViewAccess().getRightCurlyBracketKeyword_4()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__Group__4__Impl"


    // $ANTLR start "rule__ArtifactSource__Group__0"
    // InternalSPViz.g:1019:1: rule__ArtifactSource__Group__0 : rule__ArtifactSource__Group__0__Impl rule__ArtifactSource__Group__1 ;
    public final void rule__ArtifactSource__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1023:1: ( rule__ArtifactSource__Group__0__Impl rule__ArtifactSource__Group__1 )
            // InternalSPViz.g:1024:2: rule__ArtifactSource__Group__0__Impl rule__ArtifactSource__Group__1
            {
            pushFollow(FOLLOW_15);
            rule__ArtifactSource__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactSource__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactSource__Group__0"


    // $ANTLR start "rule__ArtifactSource__Group__0__Impl"
    // InternalSPViz.g:1031:1: rule__ArtifactSource__Group__0__Impl : ( ( rule__ArtifactSource__ArtifactAssignment_0 ) ) ;
    public final void rule__ArtifactSource__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1035:1: ( ( ( rule__ArtifactSource__ArtifactAssignment_0 ) ) )
            // InternalSPViz.g:1036:1: ( ( rule__ArtifactSource__ArtifactAssignment_0 ) )
            {
            // InternalSPViz.g:1036:1: ( ( rule__ArtifactSource__ArtifactAssignment_0 ) )
            // InternalSPViz.g:1037:2: ( rule__ArtifactSource__ArtifactAssignment_0 )
            {
             before(grammarAccess.getArtifactSourceAccess().getArtifactAssignment_0()); 
            // InternalSPViz.g:1038:2: ( rule__ArtifactSource__ArtifactAssignment_0 )
            // InternalSPViz.g:1038:3: rule__ArtifactSource__ArtifactAssignment_0
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactSource__ArtifactAssignment_0();

            state._fsp--;


            }

             after(grammarAccess.getArtifactSourceAccess().getArtifactAssignment_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactSource__Group__0__Impl"


    // $ANTLR start "rule__ArtifactSource__Group__1"
    // InternalSPViz.g:1046:1: rule__ArtifactSource__Group__1 : rule__ArtifactSource__Group__1__Impl rule__ArtifactSource__Group__2 ;
    public final void rule__ArtifactSource__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1050:1: ( rule__ArtifactSource__Group__1__Impl rule__ArtifactSource__Group__2 )
            // InternalSPViz.g:1051:2: rule__ArtifactSource__Group__1__Impl rule__ArtifactSource__Group__2
            {
            pushFollow(FOLLOW_3);
            rule__ArtifactSource__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactSource__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactSource__Group__1"


    // $ANTLR start "rule__ArtifactSource__Group__1__Impl"
    // InternalSPViz.g:1058:1: rule__ArtifactSource__Group__1__Impl : ( 'from' ) ;
    public final void rule__ArtifactSource__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1062:1: ( ( 'from' ) )
            // InternalSPViz.g:1063:1: ( 'from' )
            {
            // InternalSPViz.g:1063:1: ( 'from' )
            // InternalSPViz.g:1064:2: 'from'
            {
             before(grammarAccess.getArtifactSourceAccess().getFromKeyword_1()); 
            match(input,18,FOLLOW_2); 
             after(grammarAccess.getArtifactSourceAccess().getFromKeyword_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactSource__Group__1__Impl"


    // $ANTLR start "rule__ArtifactSource__Group__2"
    // InternalSPViz.g:1073:1: rule__ArtifactSource__Group__2 : rule__ArtifactSource__Group__2__Impl ;
    public final void rule__ArtifactSource__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1077:1: ( rule__ArtifactSource__Group__2__Impl )
            // InternalSPViz.g:1078:2: rule__ArtifactSource__Group__2__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactSource__Group__2__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactSource__Group__2"


    // $ANTLR start "rule__ArtifactSource__Group__2__Impl"
    // InternalSPViz.g:1084:1: rule__ArtifactSource__Group__2__Impl : ( ( rule__ArtifactSource__SourceChainAssignment_2 ) ) ;
    public final void rule__ArtifactSource__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1088:1: ( ( ( rule__ArtifactSource__SourceChainAssignment_2 ) ) )
            // InternalSPViz.g:1089:1: ( ( rule__ArtifactSource__SourceChainAssignment_2 ) )
            {
            // InternalSPViz.g:1089:1: ( ( rule__ArtifactSource__SourceChainAssignment_2 ) )
            // InternalSPViz.g:1090:2: ( rule__ArtifactSource__SourceChainAssignment_2 )
            {
             before(grammarAccess.getArtifactSourceAccess().getSourceChainAssignment_2()); 
            // InternalSPViz.g:1091:2: ( rule__ArtifactSource__SourceChainAssignment_2 )
            // InternalSPViz.g:1091:3: rule__ArtifactSource__SourceChainAssignment_2
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactSource__SourceChainAssignment_2();

            state._fsp--;


            }

             after(grammarAccess.getArtifactSourceAccess().getSourceChainAssignment_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactSource__Group__2__Impl"


    // $ANTLR start "rule__ArtifactChain__Group__0"
    // InternalSPViz.g:1100:1: rule__ArtifactChain__Group__0 : rule__ArtifactChain__Group__0__Impl rule__ArtifactChain__Group__1 ;
    public final void rule__ArtifactChain__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1104:1: ( rule__ArtifactChain__Group__0__Impl rule__ArtifactChain__Group__1 )
            // InternalSPViz.g:1105:2: rule__ArtifactChain__Group__0__Impl rule__ArtifactChain__Group__1
            {
            pushFollow(FOLLOW_16);
            rule__ArtifactChain__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactChain__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactChain__Group__0"


    // $ANTLR start "rule__ArtifactChain__Group__0__Impl"
    // InternalSPViz.g:1112:1: rule__ArtifactChain__Group__0__Impl : ( ( rule__ArtifactChain__SourceAssignment_0 ) ) ;
    public final void rule__ArtifactChain__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1116:1: ( ( ( rule__ArtifactChain__SourceAssignment_0 ) ) )
            // InternalSPViz.g:1117:1: ( ( rule__ArtifactChain__SourceAssignment_0 ) )
            {
            // InternalSPViz.g:1117:1: ( ( rule__ArtifactChain__SourceAssignment_0 ) )
            // InternalSPViz.g:1118:2: ( rule__ArtifactChain__SourceAssignment_0 )
            {
             before(grammarAccess.getArtifactChainAccess().getSourceAssignment_0()); 
            // InternalSPViz.g:1119:2: ( rule__ArtifactChain__SourceAssignment_0 )
            // InternalSPViz.g:1119:3: rule__ArtifactChain__SourceAssignment_0
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactChain__SourceAssignment_0();

            state._fsp--;


            }

             after(grammarAccess.getArtifactChainAccess().getSourceAssignment_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactChain__Group__0__Impl"


    // $ANTLR start "rule__ArtifactChain__Group__1"
    // InternalSPViz.g:1127:1: rule__ArtifactChain__Group__1 : rule__ArtifactChain__Group__1__Impl ;
    public final void rule__ArtifactChain__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1131:1: ( rule__ArtifactChain__Group__1__Impl )
            // InternalSPViz.g:1132:2: rule__ArtifactChain__Group__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactChain__Group__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactChain__Group__1"


    // $ANTLR start "rule__ArtifactChain__Group__1__Impl"
    // InternalSPViz.g:1138:1: rule__ArtifactChain__Group__1__Impl : ( ( rule__ArtifactChain__Group_1__0 )? ) ;
    public final void rule__ArtifactChain__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1142:1: ( ( ( rule__ArtifactChain__Group_1__0 )? ) )
            // InternalSPViz.g:1143:1: ( ( rule__ArtifactChain__Group_1__0 )? )
            {
            // InternalSPViz.g:1143:1: ( ( rule__ArtifactChain__Group_1__0 )? )
            // InternalSPViz.g:1144:2: ( rule__ArtifactChain__Group_1__0 )?
            {
             before(grammarAccess.getArtifactChainAccess().getGroup_1()); 
            // InternalSPViz.g:1145:2: ( rule__ArtifactChain__Group_1__0 )?
            int alt8=2;
            int LA8_0 = input.LA(1);

            if ( (LA8_0==19) ) {
                alt8=1;
            }
            switch (alt8) {
                case 1 :
                    // InternalSPViz.g:1145:3: rule__ArtifactChain__Group_1__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__ArtifactChain__Group_1__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getArtifactChainAccess().getGroup_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactChain__Group__1__Impl"


    // $ANTLR start "rule__ArtifactChain__Group_1__0"
    // InternalSPViz.g:1154:1: rule__ArtifactChain__Group_1__0 : rule__ArtifactChain__Group_1__0__Impl rule__ArtifactChain__Group_1__1 ;
    public final void rule__ArtifactChain__Group_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1158:1: ( rule__ArtifactChain__Group_1__0__Impl rule__ArtifactChain__Group_1__1 )
            // InternalSPViz.g:1159:2: rule__ArtifactChain__Group_1__0__Impl rule__ArtifactChain__Group_1__1
            {
            pushFollow(FOLLOW_3);
            rule__ArtifactChain__Group_1__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ArtifactChain__Group_1__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactChain__Group_1__0"


    // $ANTLR start "rule__ArtifactChain__Group_1__0__Impl"
    // InternalSPViz.g:1166:1: rule__ArtifactChain__Group_1__0__Impl : ( '>' ) ;
    public final void rule__ArtifactChain__Group_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1170:1: ( ( '>' ) )
            // InternalSPViz.g:1171:1: ( '>' )
            {
            // InternalSPViz.g:1171:1: ( '>' )
            // InternalSPViz.g:1172:2: '>'
            {
             before(grammarAccess.getArtifactChainAccess().getGreaterThanSignKeyword_1_0()); 
            match(input,19,FOLLOW_2); 
             after(grammarAccess.getArtifactChainAccess().getGreaterThanSignKeyword_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactChain__Group_1__0__Impl"


    // $ANTLR start "rule__ArtifactChain__Group_1__1"
    // InternalSPViz.g:1181:1: rule__ArtifactChain__Group_1__1 : rule__ArtifactChain__Group_1__1__Impl ;
    public final void rule__ArtifactChain__Group_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1185:1: ( rule__ArtifactChain__Group_1__1__Impl )
            // InternalSPViz.g:1186:2: rule__ArtifactChain__Group_1__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactChain__Group_1__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactChain__Group_1__1"


    // $ANTLR start "rule__ArtifactChain__Group_1__1__Impl"
    // InternalSPViz.g:1192:1: rule__ArtifactChain__Group_1__1__Impl : ( ( rule__ArtifactChain__FurtherAssignment_1_1 ) ) ;
    public final void rule__ArtifactChain__Group_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1196:1: ( ( ( rule__ArtifactChain__FurtherAssignment_1_1 ) ) )
            // InternalSPViz.g:1197:1: ( ( rule__ArtifactChain__FurtherAssignment_1_1 ) )
            {
            // InternalSPViz.g:1197:1: ( ( rule__ArtifactChain__FurtherAssignment_1_1 ) )
            // InternalSPViz.g:1198:2: ( rule__ArtifactChain__FurtherAssignment_1_1 )
            {
             before(grammarAccess.getArtifactChainAccess().getFurtherAssignment_1_1()); 
            // InternalSPViz.g:1199:2: ( rule__ArtifactChain__FurtherAssignment_1_1 )
            // InternalSPViz.g:1199:3: rule__ArtifactChain__FurtherAssignment_1_1
            {
            pushFollow(FOLLOW_2);
            rule__ArtifactChain__FurtherAssignment_1_1();

            state._fsp--;


            }

             after(grammarAccess.getArtifactChainAccess().getFurtherAssignment_1_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactChain__Group_1__1__Impl"


    // $ANTLR start "rule__ShownElement__Group__0"
    // InternalSPViz.g:1208:1: rule__ShownElement__Group__0 : rule__ShownElement__Group__0__Impl rule__ShownElement__Group__1 ;
    public final void rule__ShownElement__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1212:1: ( rule__ShownElement__Group__0__Impl rule__ShownElement__Group__1 )
            // InternalSPViz.g:1213:2: rule__ShownElement__Group__0__Impl rule__ShownElement__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__ShownElement__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ShownElement__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__Group__0"


    // $ANTLR start "rule__ShownElement__Group__0__Impl"
    // InternalSPViz.g:1220:1: rule__ShownElement__Group__0__Impl : ( 'show' ) ;
    public final void rule__ShownElement__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1224:1: ( ( 'show' ) )
            // InternalSPViz.g:1225:1: ( 'show' )
            {
            // InternalSPViz.g:1225:1: ( 'show' )
            // InternalSPViz.g:1226:2: 'show'
            {
             before(grammarAccess.getShownElementAccess().getShowKeyword_0()); 
            match(input,20,FOLLOW_2); 
             after(grammarAccess.getShownElementAccess().getShowKeyword_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__Group__0__Impl"


    // $ANTLR start "rule__ShownElement__Group__1"
    // InternalSPViz.g:1235:1: rule__ShownElement__Group__1 : rule__ShownElement__Group__1__Impl rule__ShownElement__Group__2 ;
    public final void rule__ShownElement__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1239:1: ( rule__ShownElement__Group__1__Impl rule__ShownElement__Group__2 )
            // InternalSPViz.g:1240:2: rule__ShownElement__Group__1__Impl rule__ShownElement__Group__2
            {
            pushFollow(FOLLOW_17);
            rule__ShownElement__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ShownElement__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__Group__1"


    // $ANTLR start "rule__ShownElement__Group__1__Impl"
    // InternalSPViz.g:1247:1: rule__ShownElement__Group__1__Impl : ( ( rule__ShownElement__ShownElementAssignment_1 ) ) ;
    public final void rule__ShownElement__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1251:1: ( ( ( rule__ShownElement__ShownElementAssignment_1 ) ) )
            // InternalSPViz.g:1252:1: ( ( rule__ShownElement__ShownElementAssignment_1 ) )
            {
            // InternalSPViz.g:1252:1: ( ( rule__ShownElement__ShownElementAssignment_1 ) )
            // InternalSPViz.g:1253:2: ( rule__ShownElement__ShownElementAssignment_1 )
            {
             before(grammarAccess.getShownElementAccess().getShownElementAssignment_1()); 
            // InternalSPViz.g:1254:2: ( rule__ShownElement__ShownElementAssignment_1 )
            // InternalSPViz.g:1254:3: rule__ShownElement__ShownElementAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__ShownElement__ShownElementAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getShownElementAccess().getShownElementAssignment_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__Group__1__Impl"


    // $ANTLR start "rule__ShownElement__Group__2"
    // InternalSPViz.g:1262:1: rule__ShownElement__Group__2 : rule__ShownElement__Group__2__Impl ;
    public final void rule__ShownElement__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1266:1: ( rule__ShownElement__Group__2__Impl )
            // InternalSPViz.g:1267:2: rule__ShownElement__Group__2__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ShownElement__Group__2__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__Group__2"


    // $ANTLR start "rule__ShownElement__Group__2__Impl"
    // InternalSPViz.g:1273:1: rule__ShownElement__Group__2__Impl : ( ( rule__ShownElement__Group_2__0 )? ) ;
    public final void rule__ShownElement__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1277:1: ( ( ( rule__ShownElement__Group_2__0 )? ) )
            // InternalSPViz.g:1278:1: ( ( rule__ShownElement__Group_2__0 )? )
            {
            // InternalSPViz.g:1278:1: ( ( rule__ShownElement__Group_2__0 )? )
            // InternalSPViz.g:1279:2: ( rule__ShownElement__Group_2__0 )?
            {
             before(grammarAccess.getShownElementAccess().getGroup_2()); 
            // InternalSPViz.g:1280:2: ( rule__ShownElement__Group_2__0 )?
            int alt9=2;
            int LA9_0 = input.LA(1);

            if ( (LA9_0==21) ) {
                alt9=1;
            }
            switch (alt9) {
                case 1 :
                    // InternalSPViz.g:1280:3: rule__ShownElement__Group_2__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__ShownElement__Group_2__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getShownElementAccess().getGroup_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__Group__2__Impl"


    // $ANTLR start "rule__ShownElement__Group_2__0"
    // InternalSPViz.g:1289:1: rule__ShownElement__Group_2__0 : rule__ShownElement__Group_2__0__Impl rule__ShownElement__Group_2__1 ;
    public final void rule__ShownElement__Group_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1293:1: ( rule__ShownElement__Group_2__0__Impl rule__ShownElement__Group_2__1 )
            // InternalSPViz.g:1294:2: rule__ShownElement__Group_2__0__Impl rule__ShownElement__Group_2__1
            {
            pushFollow(FOLLOW_3);
            rule__ShownElement__Group_2__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ShownElement__Group_2__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__Group_2__0"


    // $ANTLR start "rule__ShownElement__Group_2__0__Impl"
    // InternalSPViz.g:1301:1: rule__ShownElement__Group_2__0__Impl : ( 'in' ) ;
    public final void rule__ShownElement__Group_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1305:1: ( ( 'in' ) )
            // InternalSPViz.g:1306:1: ( 'in' )
            {
            // InternalSPViz.g:1306:1: ( 'in' )
            // InternalSPViz.g:1307:2: 'in'
            {
             before(grammarAccess.getShownElementAccess().getInKeyword_2_0()); 
            match(input,21,FOLLOW_2); 
             after(grammarAccess.getShownElementAccess().getInKeyword_2_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__Group_2__0__Impl"


    // $ANTLR start "rule__ShownElement__Group_2__1"
    // InternalSPViz.g:1316:1: rule__ShownElement__Group_2__1 : rule__ShownElement__Group_2__1__Impl ;
    public final void rule__ShownElement__Group_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1320:1: ( rule__ShownElement__Group_2__1__Impl )
            // InternalSPViz.g:1321:2: rule__ShownElement__Group_2__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ShownElement__Group_2__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__Group_2__1"


    // $ANTLR start "rule__ShownElement__Group_2__1__Impl"
    // InternalSPViz.g:1327:1: rule__ShownElement__Group_2__1__Impl : ( ( rule__ShownElement__ContainedInAssignment_2_1 ) ) ;
    public final void rule__ShownElement__Group_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1331:1: ( ( ( rule__ShownElement__ContainedInAssignment_2_1 ) ) )
            // InternalSPViz.g:1332:1: ( ( rule__ShownElement__ContainedInAssignment_2_1 ) )
            {
            // InternalSPViz.g:1332:1: ( ( rule__ShownElement__ContainedInAssignment_2_1 ) )
            // InternalSPViz.g:1333:2: ( rule__ShownElement__ContainedInAssignment_2_1 )
            {
             before(grammarAccess.getShownElementAccess().getContainedInAssignment_2_1()); 
            // InternalSPViz.g:1334:2: ( rule__ShownElement__ContainedInAssignment_2_1 )
            // InternalSPViz.g:1334:3: rule__ShownElement__ContainedInAssignment_2_1
            {
            pushFollow(FOLLOW_2);
            rule__ShownElement__ContainedInAssignment_2_1();

            state._fsp--;


            }

             after(grammarAccess.getShownElementAccess().getContainedInAssignment_2_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__Group_2__1__Impl"


    // $ANTLR start "rule__ShownConnection__Group__0"
    // InternalSPViz.g:1343:1: rule__ShownConnection__Group__0 : rule__ShownConnection__Group__0__Impl rule__ShownConnection__Group__1 ;
    public final void rule__ShownConnection__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1347:1: ( rule__ShownConnection__Group__0__Impl rule__ShownConnection__Group__1 )
            // InternalSPViz.g:1348:2: rule__ShownConnection__Group__0__Impl rule__ShownConnection__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__ShownConnection__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ShownConnection__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownConnection__Group__0"


    // $ANTLR start "rule__ShownConnection__Group__0__Impl"
    // InternalSPViz.g:1355:1: rule__ShownConnection__Group__0__Impl : ( 'connect' ) ;
    public final void rule__ShownConnection__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1359:1: ( ( 'connect' ) )
            // InternalSPViz.g:1360:1: ( 'connect' )
            {
            // InternalSPViz.g:1360:1: ( 'connect' )
            // InternalSPViz.g:1361:2: 'connect'
            {
             before(grammarAccess.getShownConnectionAccess().getConnectKeyword_0()); 
            match(input,22,FOLLOW_2); 
             after(grammarAccess.getShownConnectionAccess().getConnectKeyword_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownConnection__Group__0__Impl"


    // $ANTLR start "rule__ShownConnection__Group__1"
    // InternalSPViz.g:1370:1: rule__ShownConnection__Group__1 : rule__ShownConnection__Group__1__Impl ;
    public final void rule__ShownConnection__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1374:1: ( rule__ShownConnection__Group__1__Impl )
            // InternalSPViz.g:1375:2: rule__ShownConnection__Group__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ShownConnection__Group__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownConnection__Group__1"


    // $ANTLR start "rule__ShownConnection__Group__1__Impl"
    // InternalSPViz.g:1381:1: rule__ShownConnection__Group__1__Impl : ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) ) ;
    public final void rule__ShownConnection__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1385:1: ( ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) ) )
            // InternalSPViz.g:1386:1: ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) )
            {
            // InternalSPViz.g:1386:1: ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) )
            // InternalSPViz.g:1387:2: ( rule__ShownConnection__ShownConnectionAssignment_1 )
            {
             before(grammarAccess.getShownConnectionAccess().getShownConnectionAssignment_1()); 
            // InternalSPViz.g:1388:2: ( rule__ShownConnection__ShownConnectionAssignment_1 )
            // InternalSPViz.g:1388:3: rule__ShownConnection__ShownConnectionAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__ShownConnection__ShownConnectionAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getShownConnectionAccess().getShownConnectionAssignment_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownConnection__Group__1__Impl"


    // $ANTLR start "rule__ShownCategoryConnection__Group__0"
    // InternalSPViz.g:1397:1: rule__ShownCategoryConnection__Group__0 : rule__ShownCategoryConnection__Group__0__Impl rule__ShownCategoryConnection__Group__1 ;
    public final void rule__ShownCategoryConnection__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1401:1: ( rule__ShownCategoryConnection__Group__0__Impl rule__ShownCategoryConnection__Group__1 )
            // InternalSPViz.g:1402:2: rule__ShownCategoryConnection__Group__0__Impl rule__ShownCategoryConnection__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__ShownCategoryConnection__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ShownCategoryConnection__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownCategoryConnection__Group__0"


    // $ANTLR start "rule__ShownCategoryConnection__Group__0__Impl"
    // InternalSPViz.g:1409:1: rule__ShownCategoryConnection__Group__0__Impl : ( 'connect' ) ;
    public final void rule__ShownCategoryConnection__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1413:1: ( ( 'connect' ) )
            // InternalSPViz.g:1414:1: ( 'connect' )
            {
            // InternalSPViz.g:1414:1: ( 'connect' )
            // InternalSPViz.g:1415:2: 'connect'
            {
             before(grammarAccess.getShownCategoryConnectionAccess().getConnectKeyword_0()); 
            match(input,22,FOLLOW_2); 
             after(grammarAccess.getShownCategoryConnectionAccess().getConnectKeyword_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownCategoryConnection__Group__0__Impl"


    // $ANTLR start "rule__ShownCategoryConnection__Group__1"
    // InternalSPViz.g:1424:1: rule__ShownCategoryConnection__Group__1 : rule__ShownCategoryConnection__Group__1__Impl rule__ShownCategoryConnection__Group__2 ;
    public final void rule__ShownCategoryConnection__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1428:1: ( rule__ShownCategoryConnection__Group__1__Impl rule__ShownCategoryConnection__Group__2 )
            // InternalSPViz.g:1429:2: rule__ShownCategoryConnection__Group__1__Impl rule__ShownCategoryConnection__Group__2
            {
            pushFollow(FOLLOW_18);
            rule__ShownCategoryConnection__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ShownCategoryConnection__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownCategoryConnection__Group__1"


    // $ANTLR start "rule__ShownCategoryConnection__Group__1__Impl"
    // InternalSPViz.g:1436:1: rule__ShownCategoryConnection__Group__1__Impl : ( ( rule__ShownCategoryConnection__ConnectionAssignment_1 ) ) ;
    public final void rule__ShownCategoryConnection__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1440:1: ( ( ( rule__ShownCategoryConnection__ConnectionAssignment_1 ) ) )
            // InternalSPViz.g:1441:1: ( ( rule__ShownCategoryConnection__ConnectionAssignment_1 ) )
            {
            // InternalSPViz.g:1441:1: ( ( rule__ShownCategoryConnection__ConnectionAssignment_1 ) )
            // InternalSPViz.g:1442:2: ( rule__ShownCategoryConnection__ConnectionAssignment_1 )
            {
             before(grammarAccess.getShownCategoryConnectionAccess().getConnectionAssignment_1()); 
            // InternalSPViz.g:1443:2: ( rule__ShownCategoryConnection__ConnectionAssignment_1 )
            // InternalSPViz.g:1443:3: rule__ShownCategoryConnection__ConnectionAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__ShownCategoryConnection__ConnectionAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getShownCategoryConnectionAccess().getConnectionAssignment_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownCategoryConnection__Group__1__Impl"


    // $ANTLR start "rule__ShownCategoryConnection__Group__2"
    // InternalSPViz.g:1451:1: rule__ShownCategoryConnection__Group__2 : rule__ShownCategoryConnection__Group__2__Impl rule__ShownCategoryConnection__Group__3 ;
    public final void rule__ShownCategoryConnection__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1455:1: ( rule__ShownCategoryConnection__Group__2__Impl rule__ShownCategoryConnection__Group__3 )
            // InternalSPViz.g:1456:2: rule__ShownCategoryConnection__Group__2__Impl rule__ShownCategoryConnection__Group__3
            {
            pushFollow(FOLLOW_3);
            rule__ShownCategoryConnection__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ShownCategoryConnection__Group__3();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownCategoryConnection__Group__2"


    // $ANTLR start "rule__ShownCategoryConnection__Group__2__Impl"
    // InternalSPViz.g:1463:1: rule__ShownCategoryConnection__Group__2__Impl : ( 'via' ) ;
    public final void rule__ShownCategoryConnection__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1467:1: ( ( 'via' ) )
            // InternalSPViz.g:1468:1: ( 'via' )
            {
            // InternalSPViz.g:1468:1: ( 'via' )
            // InternalSPViz.g:1469:2: 'via'
            {
             before(grammarAccess.getShownCategoryConnectionAccess().getViaKeyword_2()); 
            match(input,23,FOLLOW_2); 
             after(grammarAccess.getShownCategoryConnectionAccess().getViaKeyword_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownCategoryConnection__Group__2__Impl"


    // $ANTLR start "rule__ShownCategoryConnection__Group__3"
    // InternalSPViz.g:1478:1: rule__ShownCategoryConnection__Group__3 : rule__ShownCategoryConnection__Group__3__Impl ;
    public final void rule__ShownCategoryConnection__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1482:1: ( rule__ShownCategoryConnection__Group__3__Impl )
            // InternalSPViz.g:1483:2: rule__ShownCategoryConnection__Group__3__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ShownCategoryConnection__Group__3__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownCategoryConnection__Group__3"


    // $ANTLR start "rule__ShownCategoryConnection__Group__3__Impl"
    // InternalSPViz.g:1489:1: rule__ShownCategoryConnection__Group__3__Impl : ( ( rule__ShownCategoryConnection__SourceChainAssignment_3 ) ) ;
    public final void rule__ShownCategoryConnection__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1493:1: ( ( ( rule__ShownCategoryConnection__SourceChainAssignment_3 ) ) )
            // InternalSPViz.g:1494:1: ( ( rule__ShownCategoryConnection__SourceChainAssignment_3 ) )
            {
            // InternalSPViz.g:1494:1: ( ( rule__ShownCategoryConnection__SourceChainAssignment_3 ) )
            // InternalSPViz.g:1495:2: ( rule__ShownCategoryConnection__SourceChainAssignment_3 )
            {
             before(grammarAccess.getShownCategoryConnectionAccess().getSourceChainAssignment_3()); 
            // InternalSPViz.g:1496:2: ( rule__ShownCategoryConnection__SourceChainAssignment_3 )
            // InternalSPViz.g:1496:3: rule__ShownCategoryConnection__SourceChainAssignment_3
            {
            pushFollow(FOLLOW_2);
            rule__ShownCategoryConnection__SourceChainAssignment_3();

            state._fsp--;


            }

             after(grammarAccess.getShownCategoryConnectionAccess().getSourceChainAssignment_3()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownCategoryConnection__Group__3__Impl"


    // $ANTLR start "rule__QualifiedName__Group__0"
    // InternalSPViz.g:1505:1: rule__QualifiedName__Group__0 : rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 ;
    public final void rule__QualifiedName__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1509:1: ( rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 )
            // InternalSPViz.g:1510:2: rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1
            {
            pushFollow(FOLLOW_19);
            rule__QualifiedName__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__QualifiedName__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group__0"


    // $ANTLR start "rule__QualifiedName__Group__0__Impl"
    // InternalSPViz.g:1517:1: rule__QualifiedName__Group__0__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1521:1: ( ( RULE_ID ) )
            // InternalSPViz.g:1522:1: ( RULE_ID )
            {
            // InternalSPViz.g:1522:1: ( RULE_ID )
            // InternalSPViz.g:1523:2: RULE_ID
            {
             before(grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group__0__Impl"


    // $ANTLR start "rule__QualifiedName__Group__1"
    // InternalSPViz.g:1532:1: rule__QualifiedName__Group__1 : rule__QualifiedName__Group__1__Impl ;
    public final void rule__QualifiedName__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1536:1: ( rule__QualifiedName__Group__1__Impl )
            // InternalSPViz.g:1537:2: rule__QualifiedName__Group__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__QualifiedName__Group__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group__1"


    // $ANTLR start "rule__QualifiedName__Group__1__Impl"
    // InternalSPViz.g:1543:1: rule__QualifiedName__Group__1__Impl : ( ( rule__QualifiedName__Group_1__0 )* ) ;
    public final void rule__QualifiedName__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1547:1: ( ( ( rule__QualifiedName__Group_1__0 )* ) )
            // InternalSPViz.g:1548:1: ( ( rule__QualifiedName__Group_1__0 )* )
            {
            // InternalSPViz.g:1548:1: ( ( rule__QualifiedName__Group_1__0 )* )
            // InternalSPViz.g:1549:2: ( rule__QualifiedName__Group_1__0 )*
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup_1()); 
            // InternalSPViz.g:1550:2: ( rule__QualifiedName__Group_1__0 )*
            loop10:
            do {
                int alt10=2;
                int LA10_0 = input.LA(1);

                if ( (LA10_0==24) ) {
                    alt10=1;
                }


                switch (alt10) {
            	case 1 :
            	    // InternalSPViz.g:1550:3: rule__QualifiedName__Group_1__0
            	    {
            	    pushFollow(FOLLOW_20);
            	    rule__QualifiedName__Group_1__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop10;
                }
            } while (true);

             after(grammarAccess.getQualifiedNameAccess().getGroup_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group__1__Impl"


    // $ANTLR start "rule__QualifiedName__Group_1__0"
    // InternalSPViz.g:1559:1: rule__QualifiedName__Group_1__0 : rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 ;
    public final void rule__QualifiedName__Group_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1563:1: ( rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 )
            // InternalSPViz.g:1564:2: rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1
            {
            pushFollow(FOLLOW_3);
            rule__QualifiedName__Group_1__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__QualifiedName__Group_1__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group_1__0"


    // $ANTLR start "rule__QualifiedName__Group_1__0__Impl"
    // InternalSPViz.g:1571:1: rule__QualifiedName__Group_1__0__Impl : ( '.' ) ;
    public final void rule__QualifiedName__Group_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1575:1: ( ( '.' ) )
            // InternalSPViz.g:1576:1: ( '.' )
            {
            // InternalSPViz.g:1576:1: ( '.' )
            // InternalSPViz.g:1577:2: '.'
            {
             before(grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0()); 
            match(input,24,FOLLOW_2); 
             after(grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group_1__0__Impl"


    // $ANTLR start "rule__QualifiedName__Group_1__1"
    // InternalSPViz.g:1586:1: rule__QualifiedName__Group_1__1 : rule__QualifiedName__Group_1__1__Impl ;
    public final void rule__QualifiedName__Group_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1590:1: ( rule__QualifiedName__Group_1__1__Impl )
            // InternalSPViz.g:1591:2: rule__QualifiedName__Group_1__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__QualifiedName__Group_1__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group_1__1"


    // $ANTLR start "rule__QualifiedName__Group_1__1__Impl"
    // InternalSPViz.g:1597:1: rule__QualifiedName__Group_1__1__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1601:1: ( ( RULE_ID ) )
            // InternalSPViz.g:1602:1: ( RULE_ID )
            {
            // InternalSPViz.g:1602:1: ( RULE_ID )
            // InternalSPViz.g:1603:2: RULE_ID
            {
             before(grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_1_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_1_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group_1__1__Impl"


    // $ANTLR start "rule__SPViz__PackageAssignment_1"
    // InternalSPViz.g:1613:1: rule__SPViz__PackageAssignment_1 : ( ruleQualifiedName ) ;
    public final void rule__SPViz__PackageAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1617:1: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1618:2: ( ruleQualifiedName )
            {
            // InternalSPViz.g:1618:2: ( ruleQualifiedName )
            // InternalSPViz.g:1619:3: ruleQualifiedName
            {
             before(grammarAccess.getSPVizAccess().getPackageQualifiedNameParserRuleCall_1_0()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getSPVizAccess().getPackageQualifiedNameParserRuleCall_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__PackageAssignment_1"


    // $ANTLR start "rule__SPViz__ImportURIAssignment_3"
    // InternalSPViz.g:1628:1: rule__SPViz__ImportURIAssignment_3 : ( RULE_STRING ) ;
    public final void rule__SPViz__ImportURIAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1632:1: ( ( RULE_STRING ) )
            // InternalSPViz.g:1633:2: ( RULE_STRING )
            {
            // InternalSPViz.g:1633:2: ( RULE_STRING )
            // InternalSPViz.g:1634:3: RULE_STRING
            {
             before(grammarAccess.getSPVizAccess().getImportURISTRINGTerminalRuleCall_3_0()); 
            match(input,RULE_STRING,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getImportURISTRINGTerminalRuleCall_3_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__ImportURIAssignment_3"


    // $ANTLR start "rule__SPViz__NameAssignment_5"
    // InternalSPViz.g:1643:1: rule__SPViz__NameAssignment_5 : ( RULE_ID ) ;
    public final void rule__SPViz__NameAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1647:1: ( ( RULE_ID ) )
            // InternalSPViz.g:1648:2: ( RULE_ID )
            {
            // InternalSPViz.g:1648:2: ( RULE_ID )
            // InternalSPViz.g:1649:3: RULE_ID
            {
             before(grammarAccess.getSPVizAccess().getNameIDTerminalRuleCall_5_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getNameIDTerminalRuleCall_5_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__NameAssignment_5"


    // $ANTLR start "rule__SPViz__ViewsAssignment_7"
    // InternalSPViz.g:1658:1: rule__SPViz__ViewsAssignment_7 : ( ruleView ) ;
    public final void rule__SPViz__ViewsAssignment_7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1662:1: ( ( ruleView ) )
            // InternalSPViz.g:1663:2: ( ruleView )
            {
            // InternalSPViz.g:1663:2: ( ruleView )
            // InternalSPViz.g:1664:3: ruleView
            {
             before(grammarAccess.getSPVizAccess().getViewsViewParserRuleCall_7_0()); 
            pushFollow(FOLLOW_2);
            ruleView();

            state._fsp--;

             after(grammarAccess.getSPVizAccess().getViewsViewParserRuleCall_7_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__ViewsAssignment_7"


    // $ANTLR start "rule__SPViz__ArtifactShowsAssignment_8"
    // InternalSPViz.g:1673:1: rule__SPViz__ArtifactShowsAssignment_8 : ( ruleArtifactShows ) ;
    public final void rule__SPViz__ArtifactShowsAssignment_8() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1677:1: ( ( ruleArtifactShows ) )
            // InternalSPViz.g:1678:2: ( ruleArtifactShows )
            {
            // InternalSPViz.g:1678:2: ( ruleArtifactShows )
            // InternalSPViz.g:1679:3: ruleArtifactShows
            {
             before(grammarAccess.getSPVizAccess().getArtifactShowsArtifactShowsParserRuleCall_8_0()); 
            pushFollow(FOLLOW_2);
            ruleArtifactShows();

            state._fsp--;

             after(grammarAccess.getSPVizAccess().getArtifactShowsArtifactShowsParserRuleCall_8_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__SPViz__ArtifactShowsAssignment_8"


    // $ANTLR start "rule__View__NameAssignment_0"
    // InternalSPViz.g:1688:1: rule__View__NameAssignment_0 : ( RULE_ID ) ;
    public final void rule__View__NameAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1692:1: ( ( RULE_ID ) )
            // InternalSPViz.g:1693:2: ( RULE_ID )
            {
            // InternalSPViz.g:1693:2: ( RULE_ID )
            // InternalSPViz.g:1694:3: RULE_ID
            {
             before(grammarAccess.getViewAccess().getNameIDTerminalRuleCall_0_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getViewAccess().getNameIDTerminalRuleCall_0_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__NameAssignment_0"


    // $ANTLR start "rule__View__ShownElementsAssignment_2"
    // InternalSPViz.g:1703:1: rule__View__ShownElementsAssignment_2 : ( ruleShownElement ) ;
    public final void rule__View__ShownElementsAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1707:1: ( ( ruleShownElement ) )
            // InternalSPViz.g:1708:2: ( ruleShownElement )
            {
            // InternalSPViz.g:1708:2: ( ruleShownElement )
            // InternalSPViz.g:1709:3: ruleShownElement
            {
             before(grammarAccess.getViewAccess().getShownElementsShownElementParserRuleCall_2_0()); 
            pushFollow(FOLLOW_2);
            ruleShownElement();

            state._fsp--;

             after(grammarAccess.getViewAccess().getShownElementsShownElementParserRuleCall_2_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__ShownElementsAssignment_2"


    // $ANTLR start "rule__View__ShownConnectionsAssignment_3"
    // InternalSPViz.g:1718:1: rule__View__ShownConnectionsAssignment_3 : ( ruleShownConnection ) ;
    public final void rule__View__ShownConnectionsAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1722:1: ( ( ruleShownConnection ) )
            // InternalSPViz.g:1723:2: ( ruleShownConnection )
            {
            // InternalSPViz.g:1723:2: ( ruleShownConnection )
            // InternalSPViz.g:1724:3: ruleShownConnection
            {
             before(grammarAccess.getViewAccess().getShownConnectionsShownConnectionParserRuleCall_3_0()); 
            pushFollow(FOLLOW_2);
            ruleShownConnection();

            state._fsp--;

             after(grammarAccess.getViewAccess().getShownConnectionsShownConnectionParserRuleCall_3_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__ShownConnectionsAssignment_3"


    // $ANTLR start "rule__View__ShownCategoryConnectionsAssignment_4"
    // InternalSPViz.g:1733:1: rule__View__ShownCategoryConnectionsAssignment_4 : ( ruleShownCategoryConnection ) ;
    public final void rule__View__ShownCategoryConnectionsAssignment_4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1737:1: ( ( ruleShownCategoryConnection ) )
            // InternalSPViz.g:1738:2: ( ruleShownCategoryConnection )
            {
            // InternalSPViz.g:1738:2: ( ruleShownCategoryConnection )
            // InternalSPViz.g:1739:3: ruleShownCategoryConnection
            {
             before(grammarAccess.getViewAccess().getShownCategoryConnectionsShownCategoryConnectionParserRuleCall_4_0()); 
            pushFollow(FOLLOW_2);
            ruleShownCategoryConnection();

            state._fsp--;

             after(grammarAccess.getViewAccess().getShownCategoryConnectionsShownCategoryConnectionParserRuleCall_4_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__View__ShownCategoryConnectionsAssignment_4"


    // $ANTLR start "rule__ArtifactShows__ArtifactShowsAssignment_0"
    // InternalSPViz.g:1748:1: rule__ArtifactShows__ArtifactShowsAssignment_0 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ArtifactShows__ArtifactShowsAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1752:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1753:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1753:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1754:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getArtifactShowsAccess().getArtifactShowsArtifactCrossReference_0_0()); 
            // InternalSPViz.g:1755:3: ( ruleQualifiedName )
            // InternalSPViz.g:1756:4: ruleQualifiedName
            {
             before(grammarAccess.getArtifactShowsAccess().getArtifactShowsArtifactQualifiedNameParserRuleCall_0_0_1()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getArtifactShowsAccess().getArtifactShowsArtifactQualifiedNameParserRuleCall_0_0_1()); 

            }

             after(grammarAccess.getArtifactShowsAccess().getArtifactShowsArtifactCrossReference_0_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__ArtifactShowsAssignment_0"


    // $ANTLR start "rule__ArtifactShows__ViewsAssignment_3"
    // InternalSPViz.g:1767:1: rule__ArtifactShows__ViewsAssignment_3 : ( ruleArtifactView ) ;
    public final void rule__ArtifactShows__ViewsAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1771:1: ( ( ruleArtifactView ) )
            // InternalSPViz.g:1772:2: ( ruleArtifactView )
            {
            // InternalSPViz.g:1772:2: ( ruleArtifactView )
            // InternalSPViz.g:1773:3: ruleArtifactView
            {
             before(grammarAccess.getArtifactShowsAccess().getViewsArtifactViewParserRuleCall_3_0()); 
            pushFollow(FOLLOW_2);
            ruleArtifactView();

            state._fsp--;

             after(grammarAccess.getArtifactShowsAccess().getViewsArtifactViewParserRuleCall_3_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactShows__ViewsAssignment_3"


    // $ANTLR start "rule__ArtifactView__ViewAssignment_0"
    // InternalSPViz.g:1782:1: rule__ArtifactView__ViewAssignment_0 : ( ( RULE_ID ) ) ;
    public final void rule__ArtifactView__ViewAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1786:1: ( ( ( RULE_ID ) ) )
            // InternalSPViz.g:1787:2: ( ( RULE_ID ) )
            {
            // InternalSPViz.g:1787:2: ( ( RULE_ID ) )
            // InternalSPViz.g:1788:3: ( RULE_ID )
            {
             before(grammarAccess.getArtifactViewAccess().getViewViewCrossReference_0_0()); 
            // InternalSPViz.g:1789:3: ( RULE_ID )
            // InternalSPViz.g:1790:4: RULE_ID
            {
             before(grammarAccess.getArtifactViewAccess().getViewViewIDTerminalRuleCall_0_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getArtifactViewAccess().getViewViewIDTerminalRuleCall_0_0_1()); 

            }

             after(grammarAccess.getArtifactViewAccess().getViewViewCrossReference_0_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__ViewAssignment_0"


    // $ANTLR start "rule__ArtifactView__SourcesAssignment_3"
    // InternalSPViz.g:1801:1: rule__ArtifactView__SourcesAssignment_3 : ( ruleArtifactSource ) ;
    public final void rule__ArtifactView__SourcesAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1805:1: ( ( ruleArtifactSource ) )
            // InternalSPViz.g:1806:2: ( ruleArtifactSource )
            {
            // InternalSPViz.g:1806:2: ( ruleArtifactSource )
            // InternalSPViz.g:1807:3: ruleArtifactSource
            {
             before(grammarAccess.getArtifactViewAccess().getSourcesArtifactSourceParserRuleCall_3_0()); 
            pushFollow(FOLLOW_2);
            ruleArtifactSource();

            state._fsp--;

             after(grammarAccess.getArtifactViewAccess().getSourcesArtifactSourceParserRuleCall_3_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactView__SourcesAssignment_3"


    // $ANTLR start "rule__ArtifactSource__ArtifactAssignment_0"
    // InternalSPViz.g:1816:1: rule__ArtifactSource__ArtifactAssignment_0 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ArtifactSource__ArtifactAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1820:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1821:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1821:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1822:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getArtifactSourceAccess().getArtifactArtifactCrossReference_0_0()); 
            // InternalSPViz.g:1823:3: ( ruleQualifiedName )
            // InternalSPViz.g:1824:4: ruleQualifiedName
            {
             before(grammarAccess.getArtifactSourceAccess().getArtifactArtifactQualifiedNameParserRuleCall_0_0_1()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getArtifactSourceAccess().getArtifactArtifactQualifiedNameParserRuleCall_0_0_1()); 

            }

             after(grammarAccess.getArtifactSourceAccess().getArtifactArtifactCrossReference_0_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactSource__ArtifactAssignment_0"


    // $ANTLR start "rule__ArtifactSource__SourceChainAssignment_2"
    // InternalSPViz.g:1835:1: rule__ArtifactSource__SourceChainAssignment_2 : ( ruleArtifactChain ) ;
    public final void rule__ArtifactSource__SourceChainAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1839:1: ( ( ruleArtifactChain ) )
            // InternalSPViz.g:1840:2: ( ruleArtifactChain )
            {
            // InternalSPViz.g:1840:2: ( ruleArtifactChain )
            // InternalSPViz.g:1841:3: ruleArtifactChain
            {
             before(grammarAccess.getArtifactSourceAccess().getSourceChainArtifactChainParserRuleCall_2_0()); 
            pushFollow(FOLLOW_2);
            ruleArtifactChain();

            state._fsp--;

             after(grammarAccess.getArtifactSourceAccess().getSourceChainArtifactChainParserRuleCall_2_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactSource__SourceChainAssignment_2"


    // $ANTLR start "rule__ArtifactChain__SourceAssignment_0"
    // InternalSPViz.g:1850:1: rule__ArtifactChain__SourceAssignment_0 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ArtifactChain__SourceAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1854:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1855:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1855:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1856:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getArtifactChainAccess().getSourceArtifactCrossReference_0_0()); 
            // InternalSPViz.g:1857:3: ( ruleQualifiedName )
            // InternalSPViz.g:1858:4: ruleQualifiedName
            {
             before(grammarAccess.getArtifactChainAccess().getSourceArtifactQualifiedNameParserRuleCall_0_0_1()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getArtifactChainAccess().getSourceArtifactQualifiedNameParserRuleCall_0_0_1()); 

            }

             after(grammarAccess.getArtifactChainAccess().getSourceArtifactCrossReference_0_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactChain__SourceAssignment_0"


    // $ANTLR start "rule__ArtifactChain__FurtherAssignment_1_1"
    // InternalSPViz.g:1869:1: rule__ArtifactChain__FurtherAssignment_1_1 : ( ruleArtifactChain ) ;
    public final void rule__ArtifactChain__FurtherAssignment_1_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1873:1: ( ( ruleArtifactChain ) )
            // InternalSPViz.g:1874:2: ( ruleArtifactChain )
            {
            // InternalSPViz.g:1874:2: ( ruleArtifactChain )
            // InternalSPViz.g:1875:3: ruleArtifactChain
            {
             before(grammarAccess.getArtifactChainAccess().getFurtherArtifactChainParserRuleCall_1_1_0()); 
            pushFollow(FOLLOW_2);
            ruleArtifactChain();

            state._fsp--;

             after(grammarAccess.getArtifactChainAccess().getFurtherArtifactChainParserRuleCall_1_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ArtifactChain__FurtherAssignment_1_1"


    // $ANTLR start "rule__ShownElement__ShownElementAssignment_1"
    // InternalSPViz.g:1884:1: rule__ShownElement__ShownElementAssignment_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownElement__ShownElementAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1888:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1889:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1889:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1890:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownElementAccess().getShownElementArtifactCrossReference_1_0()); 
            // InternalSPViz.g:1891:3: ( ruleQualifiedName )
            // InternalSPViz.g:1892:4: ruleQualifiedName
            {
             before(grammarAccess.getShownElementAccess().getShownElementArtifactQualifiedNameParserRuleCall_1_0_1()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getShownElementAccess().getShownElementArtifactQualifiedNameParserRuleCall_1_0_1()); 

            }

             after(grammarAccess.getShownElementAccess().getShownElementArtifactCrossReference_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__ShownElementAssignment_1"


    // $ANTLR start "rule__ShownElement__ContainedInAssignment_2_1"
    // InternalSPViz.g:1903:1: rule__ShownElement__ContainedInAssignment_2_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownElement__ContainedInAssignment_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1907:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1908:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1908:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1909:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownElementAccess().getContainedInArtifactCrossReference_2_1_0()); 
            // InternalSPViz.g:1910:3: ( ruleQualifiedName )
            // InternalSPViz.g:1911:4: ruleQualifiedName
            {
             before(grammarAccess.getShownElementAccess().getContainedInArtifactQualifiedNameParserRuleCall_2_1_0_1()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getShownElementAccess().getContainedInArtifactQualifiedNameParserRuleCall_2_1_0_1()); 

            }

             after(grammarAccess.getShownElementAccess().getContainedInArtifactCrossReference_2_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownElement__ContainedInAssignment_2_1"


    // $ANTLR start "rule__ShownConnection__ShownConnectionAssignment_1"
    // InternalSPViz.g:1922:1: rule__ShownConnection__ShownConnectionAssignment_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownConnection__ShownConnectionAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1926:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1927:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1927:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1928:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownConnectionAccess().getShownConnectionConnectionCrossReference_1_0()); 
            // InternalSPViz.g:1929:3: ( ruleQualifiedName )
            // InternalSPViz.g:1930:4: ruleQualifiedName
            {
             before(grammarAccess.getShownConnectionAccess().getShownConnectionConnectionQualifiedNameParserRuleCall_1_0_1()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getShownConnectionAccess().getShownConnectionConnectionQualifiedNameParserRuleCall_1_0_1()); 

            }

             after(grammarAccess.getShownConnectionAccess().getShownConnectionConnectionCrossReference_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownConnection__ShownConnectionAssignment_1"


    // $ANTLR start "rule__ShownCategoryConnection__ConnectionAssignment_1"
    // InternalSPViz.g:1941:1: rule__ShownCategoryConnection__ConnectionAssignment_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownCategoryConnection__ConnectionAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1945:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1946:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1946:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1947:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownCategoryConnectionAccess().getConnectionConnectionCrossReference_1_0()); 
            // InternalSPViz.g:1948:3: ( ruleQualifiedName )
            // InternalSPViz.g:1949:4: ruleQualifiedName
            {
             before(grammarAccess.getShownCategoryConnectionAccess().getConnectionConnectionQualifiedNameParserRuleCall_1_0_1()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getShownCategoryConnectionAccess().getConnectionConnectionQualifiedNameParserRuleCall_1_0_1()); 

            }

             after(grammarAccess.getShownCategoryConnectionAccess().getConnectionConnectionCrossReference_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownCategoryConnection__ConnectionAssignment_1"


    // $ANTLR start "rule__ShownCategoryConnection__SourceChainAssignment_3"
    // InternalSPViz.g:1960:1: rule__ShownCategoryConnection__SourceChainAssignment_3 : ( ruleArtifactChain ) ;
    public final void rule__ShownCategoryConnection__SourceChainAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1964:1: ( ( ruleArtifactChain ) )
            // InternalSPViz.g:1965:2: ( ruleArtifactChain )
            {
            // InternalSPViz.g:1965:2: ( ruleArtifactChain )
            // InternalSPViz.g:1966:3: ruleArtifactChain
            {
             before(grammarAccess.getShownCategoryConnectionAccess().getSourceChainArtifactChainParserRuleCall_3_0()); 
            pushFollow(FOLLOW_2);
            ruleArtifactChain();

            state._fsp--;

             after(grammarAccess.getShownCategoryConnectionAccess().getSourceChainArtifactChainParserRuleCall_3_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ShownCategoryConnection__SourceChainAssignment_3"

    // Delegated rules


    protected DFA4 dfa4 = new DFA4(this);
    static final String dfa_1s = "\7\uffff";
    static final String dfa_2s = "\1\17\1\4\1\uffff\1\17\1\4\1\uffff\1\17";
    static final String dfa_3s = "\1\26\1\4\1\uffff\1\30\1\4\1\uffff\1\30";
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
            return "()* loopback of 687:2: ( rule__View__ShownConnectionsAssignment_3 )*";
        }
    }
 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000000020L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000004000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000000008010L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000000012L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000000508000L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000000100002L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000000400002L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000000020000L});
    public static final BitSet FOLLOW_15 = new BitSet(new long[]{0x0000000000040000L});
    public static final BitSet FOLLOW_16 = new BitSet(new long[]{0x0000000000080000L});
    public static final BitSet FOLLOW_17 = new BitSet(new long[]{0x0000000000200000L});
    public static final BitSet FOLLOW_18 = new BitSet(new long[]{0x0000000000800000L});
    public static final BitSet FOLLOW_19 = new BitSet(new long[]{0x0000000001000000L});
    public static final BitSet FOLLOW_20 = new BitSet(new long[]{0x0000000001000002L});

}