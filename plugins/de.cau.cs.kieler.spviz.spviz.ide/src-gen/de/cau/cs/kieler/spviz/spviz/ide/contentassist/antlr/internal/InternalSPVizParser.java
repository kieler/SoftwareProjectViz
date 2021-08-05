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
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'package'", "'use'", "'SPViz'", "'{'", "'}'", "'show'", "'in'", "'connect'", "'via'", "'.'"
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
    public static final int T__20=20;

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


    // $ANTLR start "entryRuleShownElement"
    // InternalSPViz.g:118:1: entryRuleShownElement : ruleShownElement EOF ;
    public final void entryRuleShownElement() throws RecognitionException {
        try {
            // InternalSPViz.g:119:1: ( ruleShownElement EOF )
            // InternalSPViz.g:120:1: ruleShownElement EOF
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
    // InternalSPViz.g:127:1: ruleShownElement : ( ( rule__ShownElement__Group__0 ) ) ;
    public final void ruleShownElement() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:131:2: ( ( ( rule__ShownElement__Group__0 ) ) )
            // InternalSPViz.g:132:2: ( ( rule__ShownElement__Group__0 ) )
            {
            // InternalSPViz.g:132:2: ( ( rule__ShownElement__Group__0 ) )
            // InternalSPViz.g:133:3: ( rule__ShownElement__Group__0 )
            {
             before(grammarAccess.getShownElementAccess().getGroup()); 
            // InternalSPViz.g:134:3: ( rule__ShownElement__Group__0 )
            // InternalSPViz.g:134:4: rule__ShownElement__Group__0
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
    // InternalSPViz.g:143:1: entryRuleShownConnection : ruleShownConnection EOF ;
    public final void entryRuleShownConnection() throws RecognitionException {
        try {
            // InternalSPViz.g:144:1: ( ruleShownConnection EOF )
            // InternalSPViz.g:145:1: ruleShownConnection EOF
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
    // InternalSPViz.g:152:1: ruleShownConnection : ( ( rule__ShownConnection__Group__0 ) ) ;
    public final void ruleShownConnection() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:156:2: ( ( ( rule__ShownConnection__Group__0 ) ) )
            // InternalSPViz.g:157:2: ( ( rule__ShownConnection__Group__0 ) )
            {
            // InternalSPViz.g:157:2: ( ( rule__ShownConnection__Group__0 ) )
            // InternalSPViz.g:158:3: ( rule__ShownConnection__Group__0 )
            {
             before(grammarAccess.getShownConnectionAccess().getGroup()); 
            // InternalSPViz.g:159:3: ( rule__ShownConnection__Group__0 )
            // InternalSPViz.g:159:4: rule__ShownConnection__Group__0
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


    // $ANTLR start "entryRuleQualifiedName"
    // InternalSPViz.g:168:1: entryRuleQualifiedName : ruleQualifiedName EOF ;
    public final void entryRuleQualifiedName() throws RecognitionException {
        try {
            // InternalSPViz.g:169:1: ( ruleQualifiedName EOF )
            // InternalSPViz.g:170:1: ruleQualifiedName EOF
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
    // InternalSPViz.g:177:1: ruleQualifiedName : ( ( rule__QualifiedName__Group__0 ) ) ;
    public final void ruleQualifiedName() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:181:2: ( ( ( rule__QualifiedName__Group__0 ) ) )
            // InternalSPViz.g:182:2: ( ( rule__QualifiedName__Group__0 ) )
            {
            // InternalSPViz.g:182:2: ( ( rule__QualifiedName__Group__0 ) )
            // InternalSPViz.g:183:3: ( rule__QualifiedName__Group__0 )
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup()); 
            // InternalSPViz.g:184:3: ( rule__QualifiedName__Group__0 )
            // InternalSPViz.g:184:4: rule__QualifiedName__Group__0
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
    // InternalSPViz.g:192:1: rule__SPViz__Group__0 : rule__SPViz__Group__0__Impl rule__SPViz__Group__1 ;
    public final void rule__SPViz__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:196:1: ( rule__SPViz__Group__0__Impl rule__SPViz__Group__1 )
            // InternalSPViz.g:197:2: rule__SPViz__Group__0__Impl rule__SPViz__Group__1
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
    // InternalSPViz.g:204:1: rule__SPViz__Group__0__Impl : ( 'package' ) ;
    public final void rule__SPViz__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:208:1: ( ( 'package' ) )
            // InternalSPViz.g:209:1: ( 'package' )
            {
            // InternalSPViz.g:209:1: ( 'package' )
            // InternalSPViz.g:210:2: 'package'
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
    // InternalSPViz.g:219:1: rule__SPViz__Group__1 : rule__SPViz__Group__1__Impl rule__SPViz__Group__2 ;
    public final void rule__SPViz__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:223:1: ( rule__SPViz__Group__1__Impl rule__SPViz__Group__2 )
            // InternalSPViz.g:224:2: rule__SPViz__Group__1__Impl rule__SPViz__Group__2
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
    // InternalSPViz.g:231:1: rule__SPViz__Group__1__Impl : ( ( rule__SPViz__PackageAssignment_1 ) ) ;
    public final void rule__SPViz__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:235:1: ( ( ( rule__SPViz__PackageAssignment_1 ) ) )
            // InternalSPViz.g:236:1: ( ( rule__SPViz__PackageAssignment_1 ) )
            {
            // InternalSPViz.g:236:1: ( ( rule__SPViz__PackageAssignment_1 ) )
            // InternalSPViz.g:237:2: ( rule__SPViz__PackageAssignment_1 )
            {
             before(grammarAccess.getSPVizAccess().getPackageAssignment_1()); 
            // InternalSPViz.g:238:2: ( rule__SPViz__PackageAssignment_1 )
            // InternalSPViz.g:238:3: rule__SPViz__PackageAssignment_1
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
    // InternalSPViz.g:246:1: rule__SPViz__Group__2 : rule__SPViz__Group__2__Impl rule__SPViz__Group__3 ;
    public final void rule__SPViz__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:250:1: ( rule__SPViz__Group__2__Impl rule__SPViz__Group__3 )
            // InternalSPViz.g:251:2: rule__SPViz__Group__2__Impl rule__SPViz__Group__3
            {
            pushFollow(FOLLOW_3);
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
    // InternalSPViz.g:258:1: rule__SPViz__Group__2__Impl : ( 'use' ) ;
    public final void rule__SPViz__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:262:1: ( ( 'use' ) )
            // InternalSPViz.g:263:1: ( 'use' )
            {
            // InternalSPViz.g:263:1: ( 'use' )
            // InternalSPViz.g:264:2: 'use'
            {
             before(grammarAccess.getSPVizAccess().getUseKeyword_2()); 
            match(input,12,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getUseKeyword_2()); 

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
    // InternalSPViz.g:273:1: rule__SPViz__Group__3 : rule__SPViz__Group__3__Impl rule__SPViz__Group__4 ;
    public final void rule__SPViz__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:277:1: ( rule__SPViz__Group__3__Impl rule__SPViz__Group__4 )
            // InternalSPViz.g:278:2: rule__SPViz__Group__3__Impl rule__SPViz__Group__4
            {
            pushFollow(FOLLOW_5);
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
    // InternalSPViz.g:285:1: rule__SPViz__Group__3__Impl : ( ( rule__SPViz__ImportedNamespaceAssignment_3 ) ) ;
    public final void rule__SPViz__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:289:1: ( ( ( rule__SPViz__ImportedNamespaceAssignment_3 ) ) )
            // InternalSPViz.g:290:1: ( ( rule__SPViz__ImportedNamespaceAssignment_3 ) )
            {
            // InternalSPViz.g:290:1: ( ( rule__SPViz__ImportedNamespaceAssignment_3 ) )
            // InternalSPViz.g:291:2: ( rule__SPViz__ImportedNamespaceAssignment_3 )
            {
             before(grammarAccess.getSPVizAccess().getImportedNamespaceAssignment_3()); 
            // InternalSPViz.g:292:2: ( rule__SPViz__ImportedNamespaceAssignment_3 )
            // InternalSPViz.g:292:3: rule__SPViz__ImportedNamespaceAssignment_3
            {
            pushFollow(FOLLOW_2);
            rule__SPViz__ImportedNamespaceAssignment_3();

            state._fsp--;


            }

             after(grammarAccess.getSPVizAccess().getImportedNamespaceAssignment_3()); 

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
    // InternalSPViz.g:300:1: rule__SPViz__Group__4 : rule__SPViz__Group__4__Impl rule__SPViz__Group__5 ;
    public final void rule__SPViz__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:304:1: ( rule__SPViz__Group__4__Impl rule__SPViz__Group__5 )
            // InternalSPViz.g:305:2: rule__SPViz__Group__4__Impl rule__SPViz__Group__5
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
    // InternalSPViz.g:312:1: rule__SPViz__Group__4__Impl : ( 'SPViz' ) ;
    public final void rule__SPViz__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:316:1: ( ( 'SPViz' ) )
            // InternalSPViz.g:317:1: ( 'SPViz' )
            {
            // InternalSPViz.g:317:1: ( 'SPViz' )
            // InternalSPViz.g:318:2: 'SPViz'
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
    // InternalSPViz.g:327:1: rule__SPViz__Group__5 : rule__SPViz__Group__5__Impl rule__SPViz__Group__6 ;
    public final void rule__SPViz__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:331:1: ( rule__SPViz__Group__5__Impl rule__SPViz__Group__6 )
            // InternalSPViz.g:332:2: rule__SPViz__Group__5__Impl rule__SPViz__Group__6
            {
            pushFollow(FOLLOW_6);
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
    // InternalSPViz.g:339:1: rule__SPViz__Group__5__Impl : ( ( rule__SPViz__NameAssignment_5 ) ) ;
    public final void rule__SPViz__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:343:1: ( ( ( rule__SPViz__NameAssignment_5 ) ) )
            // InternalSPViz.g:344:1: ( ( rule__SPViz__NameAssignment_5 ) )
            {
            // InternalSPViz.g:344:1: ( ( rule__SPViz__NameAssignment_5 ) )
            // InternalSPViz.g:345:2: ( rule__SPViz__NameAssignment_5 )
            {
             before(grammarAccess.getSPVizAccess().getNameAssignment_5()); 
            // InternalSPViz.g:346:2: ( rule__SPViz__NameAssignment_5 )
            // InternalSPViz.g:346:3: rule__SPViz__NameAssignment_5
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
    // InternalSPViz.g:354:1: rule__SPViz__Group__6 : rule__SPViz__Group__6__Impl rule__SPViz__Group__7 ;
    public final void rule__SPViz__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:358:1: ( rule__SPViz__Group__6__Impl rule__SPViz__Group__7 )
            // InternalSPViz.g:359:2: rule__SPViz__Group__6__Impl rule__SPViz__Group__7
            {
            pushFollow(FOLLOW_7);
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
    // InternalSPViz.g:366:1: rule__SPViz__Group__6__Impl : ( '{' ) ;
    public final void rule__SPViz__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:370:1: ( ( '{' ) )
            // InternalSPViz.g:371:1: ( '{' )
            {
            // InternalSPViz.g:371:1: ( '{' )
            // InternalSPViz.g:372:2: '{'
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
    // InternalSPViz.g:381:1: rule__SPViz__Group__7 : rule__SPViz__Group__7__Impl rule__SPViz__Group__8 ;
    public final void rule__SPViz__Group__7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:385:1: ( rule__SPViz__Group__7__Impl rule__SPViz__Group__8 )
            // InternalSPViz.g:386:2: rule__SPViz__Group__7__Impl rule__SPViz__Group__8
            {
            pushFollow(FOLLOW_7);
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
    // InternalSPViz.g:393:1: rule__SPViz__Group__7__Impl : ( ( rule__SPViz__ViewsAssignment_7 )* ) ;
    public final void rule__SPViz__Group__7__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:397:1: ( ( ( rule__SPViz__ViewsAssignment_7 )* ) )
            // InternalSPViz.g:398:1: ( ( rule__SPViz__ViewsAssignment_7 )* )
            {
            // InternalSPViz.g:398:1: ( ( rule__SPViz__ViewsAssignment_7 )* )
            // InternalSPViz.g:399:2: ( rule__SPViz__ViewsAssignment_7 )*
            {
             before(grammarAccess.getSPVizAccess().getViewsAssignment_7()); 
            // InternalSPViz.g:400:2: ( rule__SPViz__ViewsAssignment_7 )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==RULE_ID) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // InternalSPViz.g:400:3: rule__SPViz__ViewsAssignment_7
            	    {
            	    pushFollow(FOLLOW_8);
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
    // InternalSPViz.g:408:1: rule__SPViz__Group__8 : rule__SPViz__Group__8__Impl ;
    public final void rule__SPViz__Group__8() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:412:1: ( rule__SPViz__Group__8__Impl )
            // InternalSPViz.g:413:2: rule__SPViz__Group__8__Impl
            {
            pushFollow(FOLLOW_2);
            rule__SPViz__Group__8__Impl();

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
    // InternalSPViz.g:419:1: rule__SPViz__Group__8__Impl : ( '}' ) ;
    public final void rule__SPViz__Group__8__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:423:1: ( ( '}' ) )
            // InternalSPViz.g:424:1: ( '}' )
            {
            // InternalSPViz.g:424:1: ( '}' )
            // InternalSPViz.g:425:2: '}'
            {
             before(grammarAccess.getSPVizAccess().getRightCurlyBracketKeyword_8()); 
            match(input,15,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getRightCurlyBracketKeyword_8()); 

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


    // $ANTLR start "rule__View__Group__0"
    // InternalSPViz.g:435:1: rule__View__Group__0 : rule__View__Group__0__Impl rule__View__Group__1 ;
    public final void rule__View__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:439:1: ( rule__View__Group__0__Impl rule__View__Group__1 )
            // InternalSPViz.g:440:2: rule__View__Group__0__Impl rule__View__Group__1
            {
            pushFollow(FOLLOW_6);
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
    // InternalSPViz.g:447:1: rule__View__Group__0__Impl : ( ( rule__View__NameAssignment_0 ) ) ;
    public final void rule__View__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:451:1: ( ( ( rule__View__NameAssignment_0 ) ) )
            // InternalSPViz.g:452:1: ( ( rule__View__NameAssignment_0 ) )
            {
            // InternalSPViz.g:452:1: ( ( rule__View__NameAssignment_0 ) )
            // InternalSPViz.g:453:2: ( rule__View__NameAssignment_0 )
            {
             before(grammarAccess.getViewAccess().getNameAssignment_0()); 
            // InternalSPViz.g:454:2: ( rule__View__NameAssignment_0 )
            // InternalSPViz.g:454:3: rule__View__NameAssignment_0
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
    // InternalSPViz.g:462:1: rule__View__Group__1 : rule__View__Group__1__Impl rule__View__Group__2 ;
    public final void rule__View__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:466:1: ( rule__View__Group__1__Impl rule__View__Group__2 )
            // InternalSPViz.g:467:2: rule__View__Group__1__Impl rule__View__Group__2
            {
            pushFollow(FOLLOW_9);
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
    // InternalSPViz.g:474:1: rule__View__Group__1__Impl : ( '{' ) ;
    public final void rule__View__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:478:1: ( ( '{' ) )
            // InternalSPViz.g:479:1: ( '{' )
            {
            // InternalSPViz.g:479:1: ( '{' )
            // InternalSPViz.g:480:2: '{'
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
    // InternalSPViz.g:489:1: rule__View__Group__2 : rule__View__Group__2__Impl rule__View__Group__3 ;
    public final void rule__View__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:493:1: ( rule__View__Group__2__Impl rule__View__Group__3 )
            // InternalSPViz.g:494:2: rule__View__Group__2__Impl rule__View__Group__3
            {
            pushFollow(FOLLOW_9);
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
    // InternalSPViz.g:501:1: rule__View__Group__2__Impl : ( ( rule__View__ShownElementsAssignment_2 )* ) ;
    public final void rule__View__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:505:1: ( ( ( rule__View__ShownElementsAssignment_2 )* ) )
            // InternalSPViz.g:506:1: ( ( rule__View__ShownElementsAssignment_2 )* )
            {
            // InternalSPViz.g:506:1: ( ( rule__View__ShownElementsAssignment_2 )* )
            // InternalSPViz.g:507:2: ( rule__View__ShownElementsAssignment_2 )*
            {
             before(grammarAccess.getViewAccess().getShownElementsAssignment_2()); 
            // InternalSPViz.g:508:2: ( rule__View__ShownElementsAssignment_2 )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==16) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // InternalSPViz.g:508:3: rule__View__ShownElementsAssignment_2
            	    {
            	    pushFollow(FOLLOW_10);
            	    rule__View__ShownElementsAssignment_2();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop2;
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
    // InternalSPViz.g:516:1: rule__View__Group__3 : rule__View__Group__3__Impl rule__View__Group__4 ;
    public final void rule__View__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:520:1: ( rule__View__Group__3__Impl rule__View__Group__4 )
            // InternalSPViz.g:521:2: rule__View__Group__3__Impl rule__View__Group__4
            {
            pushFollow(FOLLOW_9);
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
    // InternalSPViz.g:528:1: rule__View__Group__3__Impl : ( ( rule__View__ShownConnectionsAssignment_3 )* ) ;
    public final void rule__View__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:532:1: ( ( ( rule__View__ShownConnectionsAssignment_3 )* ) )
            // InternalSPViz.g:533:1: ( ( rule__View__ShownConnectionsAssignment_3 )* )
            {
            // InternalSPViz.g:533:1: ( ( rule__View__ShownConnectionsAssignment_3 )* )
            // InternalSPViz.g:534:2: ( rule__View__ShownConnectionsAssignment_3 )*
            {
             before(grammarAccess.getViewAccess().getShownConnectionsAssignment_3()); 
            // InternalSPViz.g:535:2: ( rule__View__ShownConnectionsAssignment_3 )*
            loop3:
            do {
                int alt3=2;
                int LA3_0 = input.LA(1);

                if ( (LA3_0==18) ) {
                    alt3=1;
                }


                switch (alt3) {
            	case 1 :
            	    // InternalSPViz.g:535:3: rule__View__ShownConnectionsAssignment_3
            	    {
            	    pushFollow(FOLLOW_11);
            	    rule__View__ShownConnectionsAssignment_3();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop3;
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
    // InternalSPViz.g:543:1: rule__View__Group__4 : rule__View__Group__4__Impl ;
    public final void rule__View__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:547:1: ( rule__View__Group__4__Impl )
            // InternalSPViz.g:548:2: rule__View__Group__4__Impl
            {
            pushFollow(FOLLOW_2);
            rule__View__Group__4__Impl();

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
    // InternalSPViz.g:554:1: rule__View__Group__4__Impl : ( '}' ) ;
    public final void rule__View__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:558:1: ( ( '}' ) )
            // InternalSPViz.g:559:1: ( '}' )
            {
            // InternalSPViz.g:559:1: ( '}' )
            // InternalSPViz.g:560:2: '}'
            {
             before(grammarAccess.getViewAccess().getRightCurlyBracketKeyword_4()); 
            match(input,15,FOLLOW_2); 
             after(grammarAccess.getViewAccess().getRightCurlyBracketKeyword_4()); 

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


    // $ANTLR start "rule__ShownElement__Group__0"
    // InternalSPViz.g:570:1: rule__ShownElement__Group__0 : rule__ShownElement__Group__0__Impl rule__ShownElement__Group__1 ;
    public final void rule__ShownElement__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:574:1: ( rule__ShownElement__Group__0__Impl rule__ShownElement__Group__1 )
            // InternalSPViz.g:575:2: rule__ShownElement__Group__0__Impl rule__ShownElement__Group__1
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
    // InternalSPViz.g:582:1: rule__ShownElement__Group__0__Impl : ( 'show' ) ;
    public final void rule__ShownElement__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:586:1: ( ( 'show' ) )
            // InternalSPViz.g:587:1: ( 'show' )
            {
            // InternalSPViz.g:587:1: ( 'show' )
            // InternalSPViz.g:588:2: 'show'
            {
             before(grammarAccess.getShownElementAccess().getShowKeyword_0()); 
            match(input,16,FOLLOW_2); 
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
    // InternalSPViz.g:597:1: rule__ShownElement__Group__1 : rule__ShownElement__Group__1__Impl rule__ShownElement__Group__2 ;
    public final void rule__ShownElement__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:601:1: ( rule__ShownElement__Group__1__Impl rule__ShownElement__Group__2 )
            // InternalSPViz.g:602:2: rule__ShownElement__Group__1__Impl rule__ShownElement__Group__2
            {
            pushFollow(FOLLOW_12);
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
    // InternalSPViz.g:609:1: rule__ShownElement__Group__1__Impl : ( ( rule__ShownElement__ShownElementAssignment_1 ) ) ;
    public final void rule__ShownElement__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:613:1: ( ( ( rule__ShownElement__ShownElementAssignment_1 ) ) )
            // InternalSPViz.g:614:1: ( ( rule__ShownElement__ShownElementAssignment_1 ) )
            {
            // InternalSPViz.g:614:1: ( ( rule__ShownElement__ShownElementAssignment_1 ) )
            // InternalSPViz.g:615:2: ( rule__ShownElement__ShownElementAssignment_1 )
            {
             before(grammarAccess.getShownElementAccess().getShownElementAssignment_1()); 
            // InternalSPViz.g:616:2: ( rule__ShownElement__ShownElementAssignment_1 )
            // InternalSPViz.g:616:3: rule__ShownElement__ShownElementAssignment_1
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
    // InternalSPViz.g:624:1: rule__ShownElement__Group__2 : rule__ShownElement__Group__2__Impl ;
    public final void rule__ShownElement__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:628:1: ( rule__ShownElement__Group__2__Impl )
            // InternalSPViz.g:629:2: rule__ShownElement__Group__2__Impl
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
    // InternalSPViz.g:635:1: rule__ShownElement__Group__2__Impl : ( ( rule__ShownElement__Group_2__0 )? ) ;
    public final void rule__ShownElement__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:639:1: ( ( ( rule__ShownElement__Group_2__0 )? ) )
            // InternalSPViz.g:640:1: ( ( rule__ShownElement__Group_2__0 )? )
            {
            // InternalSPViz.g:640:1: ( ( rule__ShownElement__Group_2__0 )? )
            // InternalSPViz.g:641:2: ( rule__ShownElement__Group_2__0 )?
            {
             before(grammarAccess.getShownElementAccess().getGroup_2()); 
            // InternalSPViz.g:642:2: ( rule__ShownElement__Group_2__0 )?
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( (LA4_0==17) ) {
                alt4=1;
            }
            switch (alt4) {
                case 1 :
                    // InternalSPViz.g:642:3: rule__ShownElement__Group_2__0
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
    // InternalSPViz.g:651:1: rule__ShownElement__Group_2__0 : rule__ShownElement__Group_2__0__Impl rule__ShownElement__Group_2__1 ;
    public final void rule__ShownElement__Group_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:655:1: ( rule__ShownElement__Group_2__0__Impl rule__ShownElement__Group_2__1 )
            // InternalSPViz.g:656:2: rule__ShownElement__Group_2__0__Impl rule__ShownElement__Group_2__1
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
    // InternalSPViz.g:663:1: rule__ShownElement__Group_2__0__Impl : ( 'in' ) ;
    public final void rule__ShownElement__Group_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:667:1: ( ( 'in' ) )
            // InternalSPViz.g:668:1: ( 'in' )
            {
            // InternalSPViz.g:668:1: ( 'in' )
            // InternalSPViz.g:669:2: 'in'
            {
             before(grammarAccess.getShownElementAccess().getInKeyword_2_0()); 
            match(input,17,FOLLOW_2); 
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
    // InternalSPViz.g:678:1: rule__ShownElement__Group_2__1 : rule__ShownElement__Group_2__1__Impl ;
    public final void rule__ShownElement__Group_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:682:1: ( rule__ShownElement__Group_2__1__Impl )
            // InternalSPViz.g:683:2: rule__ShownElement__Group_2__1__Impl
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
    // InternalSPViz.g:689:1: rule__ShownElement__Group_2__1__Impl : ( ( rule__ShownElement__ContainedInAssignment_2_1 ) ) ;
    public final void rule__ShownElement__Group_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:693:1: ( ( ( rule__ShownElement__ContainedInAssignment_2_1 ) ) )
            // InternalSPViz.g:694:1: ( ( rule__ShownElement__ContainedInAssignment_2_1 ) )
            {
            // InternalSPViz.g:694:1: ( ( rule__ShownElement__ContainedInAssignment_2_1 ) )
            // InternalSPViz.g:695:2: ( rule__ShownElement__ContainedInAssignment_2_1 )
            {
             before(grammarAccess.getShownElementAccess().getContainedInAssignment_2_1()); 
            // InternalSPViz.g:696:2: ( rule__ShownElement__ContainedInAssignment_2_1 )
            // InternalSPViz.g:696:3: rule__ShownElement__ContainedInAssignment_2_1
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
    // InternalSPViz.g:705:1: rule__ShownConnection__Group__0 : rule__ShownConnection__Group__0__Impl rule__ShownConnection__Group__1 ;
    public final void rule__ShownConnection__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:709:1: ( rule__ShownConnection__Group__0__Impl rule__ShownConnection__Group__1 )
            // InternalSPViz.g:710:2: rule__ShownConnection__Group__0__Impl rule__ShownConnection__Group__1
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
    // InternalSPViz.g:717:1: rule__ShownConnection__Group__0__Impl : ( 'connect' ) ;
    public final void rule__ShownConnection__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:721:1: ( ( 'connect' ) )
            // InternalSPViz.g:722:1: ( 'connect' )
            {
            // InternalSPViz.g:722:1: ( 'connect' )
            // InternalSPViz.g:723:2: 'connect'
            {
             before(grammarAccess.getShownConnectionAccess().getConnectKeyword_0()); 
            match(input,18,FOLLOW_2); 
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
    // InternalSPViz.g:732:1: rule__ShownConnection__Group__1 : rule__ShownConnection__Group__1__Impl rule__ShownConnection__Group__2 ;
    public final void rule__ShownConnection__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:736:1: ( rule__ShownConnection__Group__1__Impl rule__ShownConnection__Group__2 )
            // InternalSPViz.g:737:2: rule__ShownConnection__Group__1__Impl rule__ShownConnection__Group__2
            {
            pushFollow(FOLLOW_13);
            rule__ShownConnection__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ShownConnection__Group__2();

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
    // InternalSPViz.g:744:1: rule__ShownConnection__Group__1__Impl : ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) ) ;
    public final void rule__ShownConnection__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:748:1: ( ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) ) )
            // InternalSPViz.g:749:1: ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) )
            {
            // InternalSPViz.g:749:1: ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) )
            // InternalSPViz.g:750:2: ( rule__ShownConnection__ShownConnectionAssignment_1 )
            {
             before(grammarAccess.getShownConnectionAccess().getShownConnectionAssignment_1()); 
            // InternalSPViz.g:751:2: ( rule__ShownConnection__ShownConnectionAssignment_1 )
            // InternalSPViz.g:751:3: rule__ShownConnection__ShownConnectionAssignment_1
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


    // $ANTLR start "rule__ShownConnection__Group__2"
    // InternalSPViz.g:759:1: rule__ShownConnection__Group__2 : rule__ShownConnection__Group__2__Impl ;
    public final void rule__ShownConnection__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:763:1: ( rule__ShownConnection__Group__2__Impl )
            // InternalSPViz.g:764:2: rule__ShownConnection__Group__2__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ShownConnection__Group__2__Impl();

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
    // $ANTLR end "rule__ShownConnection__Group__2"


    // $ANTLR start "rule__ShownConnection__Group__2__Impl"
    // InternalSPViz.g:770:1: rule__ShownConnection__Group__2__Impl : ( ( rule__ShownConnection__Group_2__0 )? ) ;
    public final void rule__ShownConnection__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:774:1: ( ( ( rule__ShownConnection__Group_2__0 )? ) )
            // InternalSPViz.g:775:1: ( ( rule__ShownConnection__Group_2__0 )? )
            {
            // InternalSPViz.g:775:1: ( ( rule__ShownConnection__Group_2__0 )? )
            // InternalSPViz.g:776:2: ( rule__ShownConnection__Group_2__0 )?
            {
             before(grammarAccess.getShownConnectionAccess().getGroup_2()); 
            // InternalSPViz.g:777:2: ( rule__ShownConnection__Group_2__0 )?
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0==19) ) {
                alt5=1;
            }
            switch (alt5) {
                case 1 :
                    // InternalSPViz.g:777:3: rule__ShownConnection__Group_2__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__ShownConnection__Group_2__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getShownConnectionAccess().getGroup_2()); 

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
    // $ANTLR end "rule__ShownConnection__Group__2__Impl"


    // $ANTLR start "rule__ShownConnection__Group_2__0"
    // InternalSPViz.g:786:1: rule__ShownConnection__Group_2__0 : rule__ShownConnection__Group_2__0__Impl rule__ShownConnection__Group_2__1 ;
    public final void rule__ShownConnection__Group_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:790:1: ( rule__ShownConnection__Group_2__0__Impl rule__ShownConnection__Group_2__1 )
            // InternalSPViz.g:791:2: rule__ShownConnection__Group_2__0__Impl rule__ShownConnection__Group_2__1
            {
            pushFollow(FOLLOW_3);
            rule__ShownConnection__Group_2__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__ShownConnection__Group_2__1();

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
    // $ANTLR end "rule__ShownConnection__Group_2__0"


    // $ANTLR start "rule__ShownConnection__Group_2__0__Impl"
    // InternalSPViz.g:798:1: rule__ShownConnection__Group_2__0__Impl : ( 'via' ) ;
    public final void rule__ShownConnection__Group_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:802:1: ( ( 'via' ) )
            // InternalSPViz.g:803:1: ( 'via' )
            {
            // InternalSPViz.g:803:1: ( 'via' )
            // InternalSPViz.g:804:2: 'via'
            {
             before(grammarAccess.getShownConnectionAccess().getViaKeyword_2_0()); 
            match(input,19,FOLLOW_2); 
             after(grammarAccess.getShownConnectionAccess().getViaKeyword_2_0()); 

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
    // $ANTLR end "rule__ShownConnection__Group_2__0__Impl"


    // $ANTLR start "rule__ShownConnection__Group_2__1"
    // InternalSPViz.g:813:1: rule__ShownConnection__Group_2__1 : rule__ShownConnection__Group_2__1__Impl ;
    public final void rule__ShownConnection__Group_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:817:1: ( rule__ShownConnection__Group_2__1__Impl )
            // InternalSPViz.g:818:2: rule__ShownConnection__Group_2__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__ShownConnection__Group_2__1__Impl();

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
    // $ANTLR end "rule__ShownConnection__Group_2__1"


    // $ANTLR start "rule__ShownConnection__Group_2__1__Impl"
    // InternalSPViz.g:824:1: rule__ShownConnection__Group_2__1__Impl : ( ( rule__ShownConnection__ViaAssignment_2_1 ) ) ;
    public final void rule__ShownConnection__Group_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:828:1: ( ( ( rule__ShownConnection__ViaAssignment_2_1 ) ) )
            // InternalSPViz.g:829:1: ( ( rule__ShownConnection__ViaAssignment_2_1 ) )
            {
            // InternalSPViz.g:829:1: ( ( rule__ShownConnection__ViaAssignment_2_1 ) )
            // InternalSPViz.g:830:2: ( rule__ShownConnection__ViaAssignment_2_1 )
            {
             before(grammarAccess.getShownConnectionAccess().getViaAssignment_2_1()); 
            // InternalSPViz.g:831:2: ( rule__ShownConnection__ViaAssignment_2_1 )
            // InternalSPViz.g:831:3: rule__ShownConnection__ViaAssignment_2_1
            {
            pushFollow(FOLLOW_2);
            rule__ShownConnection__ViaAssignment_2_1();

            state._fsp--;


            }

             after(grammarAccess.getShownConnectionAccess().getViaAssignment_2_1()); 

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
    // $ANTLR end "rule__ShownConnection__Group_2__1__Impl"


    // $ANTLR start "rule__QualifiedName__Group__0"
    // InternalSPViz.g:840:1: rule__QualifiedName__Group__0 : rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 ;
    public final void rule__QualifiedName__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:844:1: ( rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 )
            // InternalSPViz.g:845:2: rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1
            {
            pushFollow(FOLLOW_14);
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
    // InternalSPViz.g:852:1: rule__QualifiedName__Group__0__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:856:1: ( ( RULE_ID ) )
            // InternalSPViz.g:857:1: ( RULE_ID )
            {
            // InternalSPViz.g:857:1: ( RULE_ID )
            // InternalSPViz.g:858:2: RULE_ID
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
    // InternalSPViz.g:867:1: rule__QualifiedName__Group__1 : rule__QualifiedName__Group__1__Impl ;
    public final void rule__QualifiedName__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:871:1: ( rule__QualifiedName__Group__1__Impl )
            // InternalSPViz.g:872:2: rule__QualifiedName__Group__1__Impl
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
    // InternalSPViz.g:878:1: rule__QualifiedName__Group__1__Impl : ( ( rule__QualifiedName__Group_1__0 )* ) ;
    public final void rule__QualifiedName__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:882:1: ( ( ( rule__QualifiedName__Group_1__0 )* ) )
            // InternalSPViz.g:883:1: ( ( rule__QualifiedName__Group_1__0 )* )
            {
            // InternalSPViz.g:883:1: ( ( rule__QualifiedName__Group_1__0 )* )
            // InternalSPViz.g:884:2: ( rule__QualifiedName__Group_1__0 )*
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup_1()); 
            // InternalSPViz.g:885:2: ( rule__QualifiedName__Group_1__0 )*
            loop6:
            do {
                int alt6=2;
                int LA6_0 = input.LA(1);

                if ( (LA6_0==20) ) {
                    alt6=1;
                }


                switch (alt6) {
            	case 1 :
            	    // InternalSPViz.g:885:3: rule__QualifiedName__Group_1__0
            	    {
            	    pushFollow(FOLLOW_15);
            	    rule__QualifiedName__Group_1__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop6;
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
    // InternalSPViz.g:894:1: rule__QualifiedName__Group_1__0 : rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 ;
    public final void rule__QualifiedName__Group_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:898:1: ( rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 )
            // InternalSPViz.g:899:2: rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1
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
    // InternalSPViz.g:906:1: rule__QualifiedName__Group_1__0__Impl : ( '.' ) ;
    public final void rule__QualifiedName__Group_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:910:1: ( ( '.' ) )
            // InternalSPViz.g:911:1: ( '.' )
            {
            // InternalSPViz.g:911:1: ( '.' )
            // InternalSPViz.g:912:2: '.'
            {
             before(grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0()); 
            match(input,20,FOLLOW_2); 
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
    // InternalSPViz.g:921:1: rule__QualifiedName__Group_1__1 : rule__QualifiedName__Group_1__1__Impl ;
    public final void rule__QualifiedName__Group_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:925:1: ( rule__QualifiedName__Group_1__1__Impl )
            // InternalSPViz.g:926:2: rule__QualifiedName__Group_1__1__Impl
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
    // InternalSPViz.g:932:1: rule__QualifiedName__Group_1__1__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:936:1: ( ( RULE_ID ) )
            // InternalSPViz.g:937:1: ( RULE_ID )
            {
            // InternalSPViz.g:937:1: ( RULE_ID )
            // InternalSPViz.g:938:2: RULE_ID
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
    // InternalSPViz.g:948:1: rule__SPViz__PackageAssignment_1 : ( ruleQualifiedName ) ;
    public final void rule__SPViz__PackageAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:952:1: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:953:2: ( ruleQualifiedName )
            {
            // InternalSPViz.g:953:2: ( ruleQualifiedName )
            // InternalSPViz.g:954:3: ruleQualifiedName
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


    // $ANTLR start "rule__SPViz__ImportedNamespaceAssignment_3"
    // InternalSPViz.g:963:1: rule__SPViz__ImportedNamespaceAssignment_3 : ( ruleQualifiedName ) ;
    public final void rule__SPViz__ImportedNamespaceAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:967:1: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:968:2: ( ruleQualifiedName )
            {
            // InternalSPViz.g:968:2: ( ruleQualifiedName )
            // InternalSPViz.g:969:3: ruleQualifiedName
            {
             before(grammarAccess.getSPVizAccess().getImportedNamespaceQualifiedNameParserRuleCall_3_0()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getSPVizAccess().getImportedNamespaceQualifiedNameParserRuleCall_3_0()); 

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
    // $ANTLR end "rule__SPViz__ImportedNamespaceAssignment_3"


    // $ANTLR start "rule__SPViz__NameAssignment_5"
    // InternalSPViz.g:978:1: rule__SPViz__NameAssignment_5 : ( RULE_ID ) ;
    public final void rule__SPViz__NameAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:982:1: ( ( RULE_ID ) )
            // InternalSPViz.g:983:2: ( RULE_ID )
            {
            // InternalSPViz.g:983:2: ( RULE_ID )
            // InternalSPViz.g:984:3: RULE_ID
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
    // InternalSPViz.g:993:1: rule__SPViz__ViewsAssignment_7 : ( ruleView ) ;
    public final void rule__SPViz__ViewsAssignment_7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:997:1: ( ( ruleView ) )
            // InternalSPViz.g:998:2: ( ruleView )
            {
            // InternalSPViz.g:998:2: ( ruleView )
            // InternalSPViz.g:999:3: ruleView
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


    // $ANTLR start "rule__View__NameAssignment_0"
    // InternalSPViz.g:1008:1: rule__View__NameAssignment_0 : ( RULE_ID ) ;
    public final void rule__View__NameAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1012:1: ( ( RULE_ID ) )
            // InternalSPViz.g:1013:2: ( RULE_ID )
            {
            // InternalSPViz.g:1013:2: ( RULE_ID )
            // InternalSPViz.g:1014:3: RULE_ID
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
    // InternalSPViz.g:1023:1: rule__View__ShownElementsAssignment_2 : ( ruleShownElement ) ;
    public final void rule__View__ShownElementsAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1027:1: ( ( ruleShownElement ) )
            // InternalSPViz.g:1028:2: ( ruleShownElement )
            {
            // InternalSPViz.g:1028:2: ( ruleShownElement )
            // InternalSPViz.g:1029:3: ruleShownElement
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
    // InternalSPViz.g:1038:1: rule__View__ShownConnectionsAssignment_3 : ( ruleShownConnection ) ;
    public final void rule__View__ShownConnectionsAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1042:1: ( ( ruleShownConnection ) )
            // InternalSPViz.g:1043:2: ( ruleShownConnection )
            {
            // InternalSPViz.g:1043:2: ( ruleShownConnection )
            // InternalSPViz.g:1044:3: ruleShownConnection
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


    // $ANTLR start "rule__ShownElement__ShownElementAssignment_1"
    // InternalSPViz.g:1053:1: rule__ShownElement__ShownElementAssignment_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownElement__ShownElementAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1057:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1058:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1058:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1059:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownElementAccess().getShownElementArtifactCrossReference_1_0()); 
            // InternalSPViz.g:1060:3: ( ruleQualifiedName )
            // InternalSPViz.g:1061:4: ruleQualifiedName
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
    // InternalSPViz.g:1072:1: rule__ShownElement__ContainedInAssignment_2_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownElement__ContainedInAssignment_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1076:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1077:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1077:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1078:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownElementAccess().getContainedInArtifactCrossReference_2_1_0()); 
            // InternalSPViz.g:1079:3: ( ruleQualifiedName )
            // InternalSPViz.g:1080:4: ruleQualifiedName
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
    // InternalSPViz.g:1091:1: rule__ShownConnection__ShownConnectionAssignment_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownConnection__ShownConnectionAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1095:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1096:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1096:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1097:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownConnectionAccess().getShownConnectionConnectionCrossReference_1_0()); 
            // InternalSPViz.g:1098:3: ( ruleQualifiedName )
            // InternalSPViz.g:1099:4: ruleQualifiedName
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


    // $ANTLR start "rule__ShownConnection__ViaAssignment_2_1"
    // InternalSPViz.g:1110:1: rule__ShownConnection__ViaAssignment_2_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownConnection__ViaAssignment_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1114:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1115:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1115:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1116:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownConnectionAccess().getViaArtifactCrossReference_2_1_0()); 
            // InternalSPViz.g:1117:3: ( ruleQualifiedName )
            // InternalSPViz.g:1118:4: ruleQualifiedName
            {
             before(grammarAccess.getShownConnectionAccess().getViaArtifactQualifiedNameParserRuleCall_2_1_0_1()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getShownConnectionAccess().getViaArtifactQualifiedNameParserRuleCall_2_1_0_1()); 

            }

             after(grammarAccess.getShownConnectionAccess().getViaArtifactCrossReference_2_1_0()); 

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
    // $ANTLR end "rule__ShownConnection__ViaAssignment_2_1"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000004000L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000008010L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000000000012L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000058000L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000000010002L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000000040002L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000000020000L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x0000000000080000L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000000100000L});
    public static final BitSet FOLLOW_15 = new BitSet(new long[]{0x0000000000100002L});

}