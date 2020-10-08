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
    // InternalSPViz.g:53:1: entryRuleSPViz : ruleSPViz EOF ;
    public final void entryRuleSPViz() throws RecognitionException {
        try {
            // InternalSPViz.g:54:1: ( ruleSPViz EOF )
            // InternalSPViz.g:55:1: ruleSPViz EOF
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
    // InternalSPViz.g:62:1: ruleSPViz : ( ( rule__SPViz__Group__0 ) ) ;
    public final void ruleSPViz() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:66:2: ( ( ( rule__SPViz__Group__0 ) ) )
            // InternalSPViz.g:67:2: ( ( rule__SPViz__Group__0 ) )
            {
            // InternalSPViz.g:67:2: ( ( rule__SPViz__Group__0 ) )
            // InternalSPViz.g:68:3: ( rule__SPViz__Group__0 )
            {
             before(grammarAccess.getSPVizAccess().getGroup()); 
            // InternalSPViz.g:69:3: ( rule__SPViz__Group__0 )
            // InternalSPViz.g:69:4: rule__SPViz__Group__0
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
    // InternalSPViz.g:78:1: entryRuleView : ruleView EOF ;
    public final void entryRuleView() throws RecognitionException {
        try {
            // InternalSPViz.g:79:1: ( ruleView EOF )
            // InternalSPViz.g:80:1: ruleView EOF
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
    // InternalSPViz.g:87:1: ruleView : ( ( rule__View__Group__0 ) ) ;
    public final void ruleView() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:91:2: ( ( ( rule__View__Group__0 ) ) )
            // InternalSPViz.g:92:2: ( ( rule__View__Group__0 ) )
            {
            // InternalSPViz.g:92:2: ( ( rule__View__Group__0 ) )
            // InternalSPViz.g:93:3: ( rule__View__Group__0 )
            {
             before(grammarAccess.getViewAccess().getGroup()); 
            // InternalSPViz.g:94:3: ( rule__View__Group__0 )
            // InternalSPViz.g:94:4: rule__View__Group__0
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
    // InternalSPViz.g:103:1: entryRuleShownElement : ruleShownElement EOF ;
    public final void entryRuleShownElement() throws RecognitionException {
        try {
            // InternalSPViz.g:104:1: ( ruleShownElement EOF )
            // InternalSPViz.g:105:1: ruleShownElement EOF
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
    // InternalSPViz.g:112:1: ruleShownElement : ( ( rule__ShownElement__Group__0 ) ) ;
    public final void ruleShownElement() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:116:2: ( ( ( rule__ShownElement__Group__0 ) ) )
            // InternalSPViz.g:117:2: ( ( rule__ShownElement__Group__0 ) )
            {
            // InternalSPViz.g:117:2: ( ( rule__ShownElement__Group__0 ) )
            // InternalSPViz.g:118:3: ( rule__ShownElement__Group__0 )
            {
             before(grammarAccess.getShownElementAccess().getGroup()); 
            // InternalSPViz.g:119:3: ( rule__ShownElement__Group__0 )
            // InternalSPViz.g:119:4: rule__ShownElement__Group__0
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
    // InternalSPViz.g:128:1: entryRuleShownConnection : ruleShownConnection EOF ;
    public final void entryRuleShownConnection() throws RecognitionException {
        try {
            // InternalSPViz.g:129:1: ( ruleShownConnection EOF )
            // InternalSPViz.g:130:1: ruleShownConnection EOF
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
    // InternalSPViz.g:137:1: ruleShownConnection : ( ( rule__ShownConnection__Group__0 ) ) ;
    public final void ruleShownConnection() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:141:2: ( ( ( rule__ShownConnection__Group__0 ) ) )
            // InternalSPViz.g:142:2: ( ( rule__ShownConnection__Group__0 ) )
            {
            // InternalSPViz.g:142:2: ( ( rule__ShownConnection__Group__0 ) )
            // InternalSPViz.g:143:3: ( rule__ShownConnection__Group__0 )
            {
             before(grammarAccess.getShownConnectionAccess().getGroup()); 
            // InternalSPViz.g:144:3: ( rule__ShownConnection__Group__0 )
            // InternalSPViz.g:144:4: rule__ShownConnection__Group__0
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
    // InternalSPViz.g:153:1: entryRuleQualifiedName : ruleQualifiedName EOF ;
    public final void entryRuleQualifiedName() throws RecognitionException {
        try {
            // InternalSPViz.g:154:1: ( ruleQualifiedName EOF )
            // InternalSPViz.g:155:1: ruleQualifiedName EOF
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
    // InternalSPViz.g:162:1: ruleQualifiedName : ( ( rule__QualifiedName__Group__0 ) ) ;
    public final void ruleQualifiedName() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:166:2: ( ( ( rule__QualifiedName__Group__0 ) ) )
            // InternalSPViz.g:167:2: ( ( rule__QualifiedName__Group__0 ) )
            {
            // InternalSPViz.g:167:2: ( ( rule__QualifiedName__Group__0 ) )
            // InternalSPViz.g:168:3: ( rule__QualifiedName__Group__0 )
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup()); 
            // InternalSPViz.g:169:3: ( rule__QualifiedName__Group__0 )
            // InternalSPViz.g:169:4: rule__QualifiedName__Group__0
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
    // InternalSPViz.g:177:1: rule__SPViz__Group__0 : rule__SPViz__Group__0__Impl rule__SPViz__Group__1 ;
    public final void rule__SPViz__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:181:1: ( rule__SPViz__Group__0__Impl rule__SPViz__Group__1 )
            // InternalSPViz.g:182:2: rule__SPViz__Group__0__Impl rule__SPViz__Group__1
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
    // InternalSPViz.g:189:1: rule__SPViz__Group__0__Impl : ( 'use' ) ;
    public final void rule__SPViz__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:193:1: ( ( 'use' ) )
            // InternalSPViz.g:194:1: ( 'use' )
            {
            // InternalSPViz.g:194:1: ( 'use' )
            // InternalSPViz.g:195:2: 'use'
            {
             before(grammarAccess.getSPVizAccess().getUseKeyword_0()); 
            match(input,11,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getUseKeyword_0()); 

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
    // InternalSPViz.g:204:1: rule__SPViz__Group__1 : rule__SPViz__Group__1__Impl rule__SPViz__Group__2 ;
    public final void rule__SPViz__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:208:1: ( rule__SPViz__Group__1__Impl rule__SPViz__Group__2 )
            // InternalSPViz.g:209:2: rule__SPViz__Group__1__Impl rule__SPViz__Group__2
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
    // InternalSPViz.g:216:1: rule__SPViz__Group__1__Impl : ( ( rule__SPViz__ImportedNamespaceAssignment_1 ) ) ;
    public final void rule__SPViz__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:220:1: ( ( ( rule__SPViz__ImportedNamespaceAssignment_1 ) ) )
            // InternalSPViz.g:221:1: ( ( rule__SPViz__ImportedNamespaceAssignment_1 ) )
            {
            // InternalSPViz.g:221:1: ( ( rule__SPViz__ImportedNamespaceAssignment_1 ) )
            // InternalSPViz.g:222:2: ( rule__SPViz__ImportedNamespaceAssignment_1 )
            {
             before(grammarAccess.getSPVizAccess().getImportedNamespaceAssignment_1()); 
            // InternalSPViz.g:223:2: ( rule__SPViz__ImportedNamespaceAssignment_1 )
            // InternalSPViz.g:223:3: rule__SPViz__ImportedNamespaceAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__SPViz__ImportedNamespaceAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getSPVizAccess().getImportedNamespaceAssignment_1()); 

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
    // InternalSPViz.g:231:1: rule__SPViz__Group__2 : rule__SPViz__Group__2__Impl rule__SPViz__Group__3 ;
    public final void rule__SPViz__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:235:1: ( rule__SPViz__Group__2__Impl rule__SPViz__Group__3 )
            // InternalSPViz.g:236:2: rule__SPViz__Group__2__Impl rule__SPViz__Group__3
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
    // InternalSPViz.g:243:1: rule__SPViz__Group__2__Impl : ( 'SPViz' ) ;
    public final void rule__SPViz__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:247:1: ( ( 'SPViz' ) )
            // InternalSPViz.g:248:1: ( 'SPViz' )
            {
            // InternalSPViz.g:248:1: ( 'SPViz' )
            // InternalSPViz.g:249:2: 'SPViz'
            {
             before(grammarAccess.getSPVizAccess().getSPVizKeyword_2()); 
            match(input,12,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getSPVizKeyword_2()); 

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
    // InternalSPViz.g:258:1: rule__SPViz__Group__3 : rule__SPViz__Group__3__Impl rule__SPViz__Group__4 ;
    public final void rule__SPViz__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:262:1: ( rule__SPViz__Group__3__Impl rule__SPViz__Group__4 )
            // InternalSPViz.g:263:2: rule__SPViz__Group__3__Impl rule__SPViz__Group__4
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
    // InternalSPViz.g:270:1: rule__SPViz__Group__3__Impl : ( ( rule__SPViz__NameAssignment_3 ) ) ;
    public final void rule__SPViz__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:274:1: ( ( ( rule__SPViz__NameAssignment_3 ) ) )
            // InternalSPViz.g:275:1: ( ( rule__SPViz__NameAssignment_3 ) )
            {
            // InternalSPViz.g:275:1: ( ( rule__SPViz__NameAssignment_3 ) )
            // InternalSPViz.g:276:2: ( rule__SPViz__NameAssignment_3 )
            {
             before(grammarAccess.getSPVizAccess().getNameAssignment_3()); 
            // InternalSPViz.g:277:2: ( rule__SPViz__NameAssignment_3 )
            // InternalSPViz.g:277:3: rule__SPViz__NameAssignment_3
            {
            pushFollow(FOLLOW_2);
            rule__SPViz__NameAssignment_3();

            state._fsp--;


            }

             after(grammarAccess.getSPVizAccess().getNameAssignment_3()); 

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
    // InternalSPViz.g:285:1: rule__SPViz__Group__4 : rule__SPViz__Group__4__Impl rule__SPViz__Group__5 ;
    public final void rule__SPViz__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:289:1: ( rule__SPViz__Group__4__Impl rule__SPViz__Group__5 )
            // InternalSPViz.g:290:2: rule__SPViz__Group__4__Impl rule__SPViz__Group__5
            {
            pushFollow(FOLLOW_6);
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
    // InternalSPViz.g:297:1: rule__SPViz__Group__4__Impl : ( '{' ) ;
    public final void rule__SPViz__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:301:1: ( ( '{' ) )
            // InternalSPViz.g:302:1: ( '{' )
            {
            // InternalSPViz.g:302:1: ( '{' )
            // InternalSPViz.g:303:2: '{'
            {
             before(grammarAccess.getSPVizAccess().getLeftCurlyBracketKeyword_4()); 
            match(input,13,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getLeftCurlyBracketKeyword_4()); 

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
    // InternalSPViz.g:312:1: rule__SPViz__Group__5 : rule__SPViz__Group__5__Impl rule__SPViz__Group__6 ;
    public final void rule__SPViz__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:316:1: ( rule__SPViz__Group__5__Impl rule__SPViz__Group__6 )
            // InternalSPViz.g:317:2: rule__SPViz__Group__5__Impl rule__SPViz__Group__6
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
    // InternalSPViz.g:324:1: rule__SPViz__Group__5__Impl : ( ( rule__SPViz__ViewsAssignment_5 )* ) ;
    public final void rule__SPViz__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:328:1: ( ( ( rule__SPViz__ViewsAssignment_5 )* ) )
            // InternalSPViz.g:329:1: ( ( rule__SPViz__ViewsAssignment_5 )* )
            {
            // InternalSPViz.g:329:1: ( ( rule__SPViz__ViewsAssignment_5 )* )
            // InternalSPViz.g:330:2: ( rule__SPViz__ViewsAssignment_5 )*
            {
             before(grammarAccess.getSPVizAccess().getViewsAssignment_5()); 
            // InternalSPViz.g:331:2: ( rule__SPViz__ViewsAssignment_5 )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==RULE_ID) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // InternalSPViz.g:331:3: rule__SPViz__ViewsAssignment_5
            	    {
            	    pushFollow(FOLLOW_7);
            	    rule__SPViz__ViewsAssignment_5();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

             after(grammarAccess.getSPVizAccess().getViewsAssignment_5()); 

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
    // InternalSPViz.g:339:1: rule__SPViz__Group__6 : rule__SPViz__Group__6__Impl ;
    public final void rule__SPViz__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:343:1: ( rule__SPViz__Group__6__Impl )
            // InternalSPViz.g:344:2: rule__SPViz__Group__6__Impl
            {
            pushFollow(FOLLOW_2);
            rule__SPViz__Group__6__Impl();

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
    // InternalSPViz.g:350:1: rule__SPViz__Group__6__Impl : ( '}' ) ;
    public final void rule__SPViz__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:354:1: ( ( '}' ) )
            // InternalSPViz.g:355:1: ( '}' )
            {
            // InternalSPViz.g:355:1: ( '}' )
            // InternalSPViz.g:356:2: '}'
            {
             before(grammarAccess.getSPVizAccess().getRightCurlyBracketKeyword_6()); 
            match(input,14,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getRightCurlyBracketKeyword_6()); 

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


    // $ANTLR start "rule__View__Group__0"
    // InternalSPViz.g:366:1: rule__View__Group__0 : rule__View__Group__0__Impl rule__View__Group__1 ;
    public final void rule__View__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:370:1: ( rule__View__Group__0__Impl rule__View__Group__1 )
            // InternalSPViz.g:371:2: rule__View__Group__0__Impl rule__View__Group__1
            {
            pushFollow(FOLLOW_5);
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
    // InternalSPViz.g:378:1: rule__View__Group__0__Impl : ( ( rule__View__NameAssignment_0 ) ) ;
    public final void rule__View__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:382:1: ( ( ( rule__View__NameAssignment_0 ) ) )
            // InternalSPViz.g:383:1: ( ( rule__View__NameAssignment_0 ) )
            {
            // InternalSPViz.g:383:1: ( ( rule__View__NameAssignment_0 ) )
            // InternalSPViz.g:384:2: ( rule__View__NameAssignment_0 )
            {
             before(grammarAccess.getViewAccess().getNameAssignment_0()); 
            // InternalSPViz.g:385:2: ( rule__View__NameAssignment_0 )
            // InternalSPViz.g:385:3: rule__View__NameAssignment_0
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
    // InternalSPViz.g:393:1: rule__View__Group__1 : rule__View__Group__1__Impl rule__View__Group__2 ;
    public final void rule__View__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:397:1: ( rule__View__Group__1__Impl rule__View__Group__2 )
            // InternalSPViz.g:398:2: rule__View__Group__1__Impl rule__View__Group__2
            {
            pushFollow(FOLLOW_8);
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
    // InternalSPViz.g:405:1: rule__View__Group__1__Impl : ( '{' ) ;
    public final void rule__View__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:409:1: ( ( '{' ) )
            // InternalSPViz.g:410:1: ( '{' )
            {
            // InternalSPViz.g:410:1: ( '{' )
            // InternalSPViz.g:411:2: '{'
            {
             before(grammarAccess.getViewAccess().getLeftCurlyBracketKeyword_1()); 
            match(input,13,FOLLOW_2); 
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
    // InternalSPViz.g:420:1: rule__View__Group__2 : rule__View__Group__2__Impl rule__View__Group__3 ;
    public final void rule__View__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:424:1: ( rule__View__Group__2__Impl rule__View__Group__3 )
            // InternalSPViz.g:425:2: rule__View__Group__2__Impl rule__View__Group__3
            {
            pushFollow(FOLLOW_8);
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
    // InternalSPViz.g:432:1: rule__View__Group__2__Impl : ( ( rule__View__ShownElementsAssignment_2 )* ) ;
    public final void rule__View__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:436:1: ( ( ( rule__View__ShownElementsAssignment_2 )* ) )
            // InternalSPViz.g:437:1: ( ( rule__View__ShownElementsAssignment_2 )* )
            {
            // InternalSPViz.g:437:1: ( ( rule__View__ShownElementsAssignment_2 )* )
            // InternalSPViz.g:438:2: ( rule__View__ShownElementsAssignment_2 )*
            {
             before(grammarAccess.getViewAccess().getShownElementsAssignment_2()); 
            // InternalSPViz.g:439:2: ( rule__View__ShownElementsAssignment_2 )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==15) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // InternalSPViz.g:439:3: rule__View__ShownElementsAssignment_2
            	    {
            	    pushFollow(FOLLOW_9);
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
    // InternalSPViz.g:447:1: rule__View__Group__3 : rule__View__Group__3__Impl rule__View__Group__4 ;
    public final void rule__View__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:451:1: ( rule__View__Group__3__Impl rule__View__Group__4 )
            // InternalSPViz.g:452:2: rule__View__Group__3__Impl rule__View__Group__4
            {
            pushFollow(FOLLOW_8);
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
    // InternalSPViz.g:459:1: rule__View__Group__3__Impl : ( ( rule__View__ShownConnectionsAssignment_3 )* ) ;
    public final void rule__View__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:463:1: ( ( ( rule__View__ShownConnectionsAssignment_3 )* ) )
            // InternalSPViz.g:464:1: ( ( rule__View__ShownConnectionsAssignment_3 )* )
            {
            // InternalSPViz.g:464:1: ( ( rule__View__ShownConnectionsAssignment_3 )* )
            // InternalSPViz.g:465:2: ( rule__View__ShownConnectionsAssignment_3 )*
            {
             before(grammarAccess.getViewAccess().getShownConnectionsAssignment_3()); 
            // InternalSPViz.g:466:2: ( rule__View__ShownConnectionsAssignment_3 )*
            loop3:
            do {
                int alt3=2;
                int LA3_0 = input.LA(1);

                if ( (LA3_0==17) ) {
                    alt3=1;
                }


                switch (alt3) {
            	case 1 :
            	    // InternalSPViz.g:466:3: rule__View__ShownConnectionsAssignment_3
            	    {
            	    pushFollow(FOLLOW_10);
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
    // InternalSPViz.g:474:1: rule__View__Group__4 : rule__View__Group__4__Impl ;
    public final void rule__View__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:478:1: ( rule__View__Group__4__Impl )
            // InternalSPViz.g:479:2: rule__View__Group__4__Impl
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
    // InternalSPViz.g:485:1: rule__View__Group__4__Impl : ( '}' ) ;
    public final void rule__View__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:489:1: ( ( '}' ) )
            // InternalSPViz.g:490:1: ( '}' )
            {
            // InternalSPViz.g:490:1: ( '}' )
            // InternalSPViz.g:491:2: '}'
            {
             before(grammarAccess.getViewAccess().getRightCurlyBracketKeyword_4()); 
            match(input,14,FOLLOW_2); 
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
    // InternalSPViz.g:501:1: rule__ShownElement__Group__0 : rule__ShownElement__Group__0__Impl rule__ShownElement__Group__1 ;
    public final void rule__ShownElement__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:505:1: ( rule__ShownElement__Group__0__Impl rule__ShownElement__Group__1 )
            // InternalSPViz.g:506:2: rule__ShownElement__Group__0__Impl rule__ShownElement__Group__1
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
    // InternalSPViz.g:513:1: rule__ShownElement__Group__0__Impl : ( 'show' ) ;
    public final void rule__ShownElement__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:517:1: ( ( 'show' ) )
            // InternalSPViz.g:518:1: ( 'show' )
            {
            // InternalSPViz.g:518:1: ( 'show' )
            // InternalSPViz.g:519:2: 'show'
            {
             before(grammarAccess.getShownElementAccess().getShowKeyword_0()); 
            match(input,15,FOLLOW_2); 
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
    // InternalSPViz.g:528:1: rule__ShownElement__Group__1 : rule__ShownElement__Group__1__Impl rule__ShownElement__Group__2 ;
    public final void rule__ShownElement__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:532:1: ( rule__ShownElement__Group__1__Impl rule__ShownElement__Group__2 )
            // InternalSPViz.g:533:2: rule__ShownElement__Group__1__Impl rule__ShownElement__Group__2
            {
            pushFollow(FOLLOW_11);
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
    // InternalSPViz.g:540:1: rule__ShownElement__Group__1__Impl : ( ( rule__ShownElement__ShownElementAssignment_1 ) ) ;
    public final void rule__ShownElement__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:544:1: ( ( ( rule__ShownElement__ShownElementAssignment_1 ) ) )
            // InternalSPViz.g:545:1: ( ( rule__ShownElement__ShownElementAssignment_1 ) )
            {
            // InternalSPViz.g:545:1: ( ( rule__ShownElement__ShownElementAssignment_1 ) )
            // InternalSPViz.g:546:2: ( rule__ShownElement__ShownElementAssignment_1 )
            {
             before(grammarAccess.getShownElementAccess().getShownElementAssignment_1()); 
            // InternalSPViz.g:547:2: ( rule__ShownElement__ShownElementAssignment_1 )
            // InternalSPViz.g:547:3: rule__ShownElement__ShownElementAssignment_1
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
    // InternalSPViz.g:555:1: rule__ShownElement__Group__2 : rule__ShownElement__Group__2__Impl ;
    public final void rule__ShownElement__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:559:1: ( rule__ShownElement__Group__2__Impl )
            // InternalSPViz.g:560:2: rule__ShownElement__Group__2__Impl
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
    // InternalSPViz.g:566:1: rule__ShownElement__Group__2__Impl : ( ( rule__ShownElement__Group_2__0 )? ) ;
    public final void rule__ShownElement__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:570:1: ( ( ( rule__ShownElement__Group_2__0 )? ) )
            // InternalSPViz.g:571:1: ( ( rule__ShownElement__Group_2__0 )? )
            {
            // InternalSPViz.g:571:1: ( ( rule__ShownElement__Group_2__0 )? )
            // InternalSPViz.g:572:2: ( rule__ShownElement__Group_2__0 )?
            {
             before(grammarAccess.getShownElementAccess().getGroup_2()); 
            // InternalSPViz.g:573:2: ( rule__ShownElement__Group_2__0 )?
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( (LA4_0==16) ) {
                alt4=1;
            }
            switch (alt4) {
                case 1 :
                    // InternalSPViz.g:573:3: rule__ShownElement__Group_2__0
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
    // InternalSPViz.g:582:1: rule__ShownElement__Group_2__0 : rule__ShownElement__Group_2__0__Impl rule__ShownElement__Group_2__1 ;
    public final void rule__ShownElement__Group_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:586:1: ( rule__ShownElement__Group_2__0__Impl rule__ShownElement__Group_2__1 )
            // InternalSPViz.g:587:2: rule__ShownElement__Group_2__0__Impl rule__ShownElement__Group_2__1
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
    // InternalSPViz.g:594:1: rule__ShownElement__Group_2__0__Impl : ( 'in' ) ;
    public final void rule__ShownElement__Group_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:598:1: ( ( 'in' ) )
            // InternalSPViz.g:599:1: ( 'in' )
            {
            // InternalSPViz.g:599:1: ( 'in' )
            // InternalSPViz.g:600:2: 'in'
            {
             before(grammarAccess.getShownElementAccess().getInKeyword_2_0()); 
            match(input,16,FOLLOW_2); 
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
    // InternalSPViz.g:609:1: rule__ShownElement__Group_2__1 : rule__ShownElement__Group_2__1__Impl ;
    public final void rule__ShownElement__Group_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:613:1: ( rule__ShownElement__Group_2__1__Impl )
            // InternalSPViz.g:614:2: rule__ShownElement__Group_2__1__Impl
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
    // InternalSPViz.g:620:1: rule__ShownElement__Group_2__1__Impl : ( ( rule__ShownElement__ContainedInAssignment_2_1 ) ) ;
    public final void rule__ShownElement__Group_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:624:1: ( ( ( rule__ShownElement__ContainedInAssignment_2_1 ) ) )
            // InternalSPViz.g:625:1: ( ( rule__ShownElement__ContainedInAssignment_2_1 ) )
            {
            // InternalSPViz.g:625:1: ( ( rule__ShownElement__ContainedInAssignment_2_1 ) )
            // InternalSPViz.g:626:2: ( rule__ShownElement__ContainedInAssignment_2_1 )
            {
             before(grammarAccess.getShownElementAccess().getContainedInAssignment_2_1()); 
            // InternalSPViz.g:627:2: ( rule__ShownElement__ContainedInAssignment_2_1 )
            // InternalSPViz.g:627:3: rule__ShownElement__ContainedInAssignment_2_1
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
    // InternalSPViz.g:636:1: rule__ShownConnection__Group__0 : rule__ShownConnection__Group__0__Impl rule__ShownConnection__Group__1 ;
    public final void rule__ShownConnection__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:640:1: ( rule__ShownConnection__Group__0__Impl rule__ShownConnection__Group__1 )
            // InternalSPViz.g:641:2: rule__ShownConnection__Group__0__Impl rule__ShownConnection__Group__1
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
    // InternalSPViz.g:648:1: rule__ShownConnection__Group__0__Impl : ( 'connect' ) ;
    public final void rule__ShownConnection__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:652:1: ( ( 'connect' ) )
            // InternalSPViz.g:653:1: ( 'connect' )
            {
            // InternalSPViz.g:653:1: ( 'connect' )
            // InternalSPViz.g:654:2: 'connect'
            {
             before(grammarAccess.getShownConnectionAccess().getConnectKeyword_0()); 
            match(input,17,FOLLOW_2); 
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
    // InternalSPViz.g:663:1: rule__ShownConnection__Group__1 : rule__ShownConnection__Group__1__Impl rule__ShownConnection__Group__2 ;
    public final void rule__ShownConnection__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:667:1: ( rule__ShownConnection__Group__1__Impl rule__ShownConnection__Group__2 )
            // InternalSPViz.g:668:2: rule__ShownConnection__Group__1__Impl rule__ShownConnection__Group__2
            {
            pushFollow(FOLLOW_12);
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
    // InternalSPViz.g:675:1: rule__ShownConnection__Group__1__Impl : ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) ) ;
    public final void rule__ShownConnection__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:679:1: ( ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) ) )
            // InternalSPViz.g:680:1: ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) )
            {
            // InternalSPViz.g:680:1: ( ( rule__ShownConnection__ShownConnectionAssignment_1 ) )
            // InternalSPViz.g:681:2: ( rule__ShownConnection__ShownConnectionAssignment_1 )
            {
             before(grammarAccess.getShownConnectionAccess().getShownConnectionAssignment_1()); 
            // InternalSPViz.g:682:2: ( rule__ShownConnection__ShownConnectionAssignment_1 )
            // InternalSPViz.g:682:3: rule__ShownConnection__ShownConnectionAssignment_1
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
    // InternalSPViz.g:690:1: rule__ShownConnection__Group__2 : rule__ShownConnection__Group__2__Impl ;
    public final void rule__ShownConnection__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:694:1: ( rule__ShownConnection__Group__2__Impl )
            // InternalSPViz.g:695:2: rule__ShownConnection__Group__2__Impl
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
    // InternalSPViz.g:701:1: rule__ShownConnection__Group__2__Impl : ( ( rule__ShownConnection__Group_2__0 )? ) ;
    public final void rule__ShownConnection__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:705:1: ( ( ( rule__ShownConnection__Group_2__0 )? ) )
            // InternalSPViz.g:706:1: ( ( rule__ShownConnection__Group_2__0 )? )
            {
            // InternalSPViz.g:706:1: ( ( rule__ShownConnection__Group_2__0 )? )
            // InternalSPViz.g:707:2: ( rule__ShownConnection__Group_2__0 )?
            {
             before(grammarAccess.getShownConnectionAccess().getGroup_2()); 
            // InternalSPViz.g:708:2: ( rule__ShownConnection__Group_2__0 )?
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0==18) ) {
                alt5=1;
            }
            switch (alt5) {
                case 1 :
                    // InternalSPViz.g:708:3: rule__ShownConnection__Group_2__0
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
    // InternalSPViz.g:717:1: rule__ShownConnection__Group_2__0 : rule__ShownConnection__Group_2__0__Impl rule__ShownConnection__Group_2__1 ;
    public final void rule__ShownConnection__Group_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:721:1: ( rule__ShownConnection__Group_2__0__Impl rule__ShownConnection__Group_2__1 )
            // InternalSPViz.g:722:2: rule__ShownConnection__Group_2__0__Impl rule__ShownConnection__Group_2__1
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
    // InternalSPViz.g:729:1: rule__ShownConnection__Group_2__0__Impl : ( 'via' ) ;
    public final void rule__ShownConnection__Group_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:733:1: ( ( 'via' ) )
            // InternalSPViz.g:734:1: ( 'via' )
            {
            // InternalSPViz.g:734:1: ( 'via' )
            // InternalSPViz.g:735:2: 'via'
            {
             before(grammarAccess.getShownConnectionAccess().getViaKeyword_2_0()); 
            match(input,18,FOLLOW_2); 
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
    // InternalSPViz.g:744:1: rule__ShownConnection__Group_2__1 : rule__ShownConnection__Group_2__1__Impl ;
    public final void rule__ShownConnection__Group_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:748:1: ( rule__ShownConnection__Group_2__1__Impl )
            // InternalSPViz.g:749:2: rule__ShownConnection__Group_2__1__Impl
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
    // InternalSPViz.g:755:1: rule__ShownConnection__Group_2__1__Impl : ( ( rule__ShownConnection__ViaAssignment_2_1 ) ) ;
    public final void rule__ShownConnection__Group_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:759:1: ( ( ( rule__ShownConnection__ViaAssignment_2_1 ) ) )
            // InternalSPViz.g:760:1: ( ( rule__ShownConnection__ViaAssignment_2_1 ) )
            {
            // InternalSPViz.g:760:1: ( ( rule__ShownConnection__ViaAssignment_2_1 ) )
            // InternalSPViz.g:761:2: ( rule__ShownConnection__ViaAssignment_2_1 )
            {
             before(grammarAccess.getShownConnectionAccess().getViaAssignment_2_1()); 
            // InternalSPViz.g:762:2: ( rule__ShownConnection__ViaAssignment_2_1 )
            // InternalSPViz.g:762:3: rule__ShownConnection__ViaAssignment_2_1
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
    // InternalSPViz.g:771:1: rule__QualifiedName__Group__0 : rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 ;
    public final void rule__QualifiedName__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:775:1: ( rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 )
            // InternalSPViz.g:776:2: rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1
            {
            pushFollow(FOLLOW_13);
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
    // InternalSPViz.g:783:1: rule__QualifiedName__Group__0__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:787:1: ( ( RULE_ID ) )
            // InternalSPViz.g:788:1: ( RULE_ID )
            {
            // InternalSPViz.g:788:1: ( RULE_ID )
            // InternalSPViz.g:789:2: RULE_ID
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
    // InternalSPViz.g:798:1: rule__QualifiedName__Group__1 : rule__QualifiedName__Group__1__Impl ;
    public final void rule__QualifiedName__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:802:1: ( rule__QualifiedName__Group__1__Impl )
            // InternalSPViz.g:803:2: rule__QualifiedName__Group__1__Impl
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
    // InternalSPViz.g:809:1: rule__QualifiedName__Group__1__Impl : ( ( rule__QualifiedName__Group_1__0 )* ) ;
    public final void rule__QualifiedName__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:813:1: ( ( ( rule__QualifiedName__Group_1__0 )* ) )
            // InternalSPViz.g:814:1: ( ( rule__QualifiedName__Group_1__0 )* )
            {
            // InternalSPViz.g:814:1: ( ( rule__QualifiedName__Group_1__0 )* )
            // InternalSPViz.g:815:2: ( rule__QualifiedName__Group_1__0 )*
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup_1()); 
            // InternalSPViz.g:816:2: ( rule__QualifiedName__Group_1__0 )*
            loop6:
            do {
                int alt6=2;
                int LA6_0 = input.LA(1);

                if ( (LA6_0==19) ) {
                    alt6=1;
                }


                switch (alt6) {
            	case 1 :
            	    // InternalSPViz.g:816:3: rule__QualifiedName__Group_1__0
            	    {
            	    pushFollow(FOLLOW_14);
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
    // InternalSPViz.g:825:1: rule__QualifiedName__Group_1__0 : rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 ;
    public final void rule__QualifiedName__Group_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:829:1: ( rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 )
            // InternalSPViz.g:830:2: rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1
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
    // InternalSPViz.g:837:1: rule__QualifiedName__Group_1__0__Impl : ( '.' ) ;
    public final void rule__QualifiedName__Group_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:841:1: ( ( '.' ) )
            // InternalSPViz.g:842:1: ( '.' )
            {
            // InternalSPViz.g:842:1: ( '.' )
            // InternalSPViz.g:843:2: '.'
            {
             before(grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0()); 
            match(input,19,FOLLOW_2); 
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
    // InternalSPViz.g:852:1: rule__QualifiedName__Group_1__1 : rule__QualifiedName__Group_1__1__Impl ;
    public final void rule__QualifiedName__Group_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:856:1: ( rule__QualifiedName__Group_1__1__Impl )
            // InternalSPViz.g:857:2: rule__QualifiedName__Group_1__1__Impl
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
    // InternalSPViz.g:863:1: rule__QualifiedName__Group_1__1__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:867:1: ( ( RULE_ID ) )
            // InternalSPViz.g:868:1: ( RULE_ID )
            {
            // InternalSPViz.g:868:1: ( RULE_ID )
            // InternalSPViz.g:869:2: RULE_ID
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


    // $ANTLR start "rule__SPViz__ImportedNamespaceAssignment_1"
    // InternalSPViz.g:879:1: rule__SPViz__ImportedNamespaceAssignment_1 : ( ruleQualifiedName ) ;
    public final void rule__SPViz__ImportedNamespaceAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:883:1: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:884:2: ( ruleQualifiedName )
            {
            // InternalSPViz.g:884:2: ( ruleQualifiedName )
            // InternalSPViz.g:885:3: ruleQualifiedName
            {
             before(grammarAccess.getSPVizAccess().getImportedNamespaceQualifiedNameParserRuleCall_1_0()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getSPVizAccess().getImportedNamespaceQualifiedNameParserRuleCall_1_0()); 

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
    // $ANTLR end "rule__SPViz__ImportedNamespaceAssignment_1"


    // $ANTLR start "rule__SPViz__NameAssignment_3"
    // InternalSPViz.g:894:1: rule__SPViz__NameAssignment_3 : ( RULE_ID ) ;
    public final void rule__SPViz__NameAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:898:1: ( ( RULE_ID ) )
            // InternalSPViz.g:899:2: ( RULE_ID )
            {
            // InternalSPViz.g:899:2: ( RULE_ID )
            // InternalSPViz.g:900:3: RULE_ID
            {
             before(grammarAccess.getSPVizAccess().getNameIDTerminalRuleCall_3_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getSPVizAccess().getNameIDTerminalRuleCall_3_0()); 

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
    // $ANTLR end "rule__SPViz__NameAssignment_3"


    // $ANTLR start "rule__SPViz__ViewsAssignment_5"
    // InternalSPViz.g:909:1: rule__SPViz__ViewsAssignment_5 : ( ruleView ) ;
    public final void rule__SPViz__ViewsAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:913:1: ( ( ruleView ) )
            // InternalSPViz.g:914:2: ( ruleView )
            {
            // InternalSPViz.g:914:2: ( ruleView )
            // InternalSPViz.g:915:3: ruleView
            {
             before(grammarAccess.getSPVizAccess().getViewsViewParserRuleCall_5_0()); 
            pushFollow(FOLLOW_2);
            ruleView();

            state._fsp--;

             after(grammarAccess.getSPVizAccess().getViewsViewParserRuleCall_5_0()); 

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
    // $ANTLR end "rule__SPViz__ViewsAssignment_5"


    // $ANTLR start "rule__View__NameAssignment_0"
    // InternalSPViz.g:924:1: rule__View__NameAssignment_0 : ( RULE_ID ) ;
    public final void rule__View__NameAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:928:1: ( ( RULE_ID ) )
            // InternalSPViz.g:929:2: ( RULE_ID )
            {
            // InternalSPViz.g:929:2: ( RULE_ID )
            // InternalSPViz.g:930:3: RULE_ID
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
    // InternalSPViz.g:939:1: rule__View__ShownElementsAssignment_2 : ( ruleShownElement ) ;
    public final void rule__View__ShownElementsAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:943:1: ( ( ruleShownElement ) )
            // InternalSPViz.g:944:2: ( ruleShownElement )
            {
            // InternalSPViz.g:944:2: ( ruleShownElement )
            // InternalSPViz.g:945:3: ruleShownElement
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
    // InternalSPViz.g:954:1: rule__View__ShownConnectionsAssignment_3 : ( ruleShownConnection ) ;
    public final void rule__View__ShownConnectionsAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:958:1: ( ( ruleShownConnection ) )
            // InternalSPViz.g:959:2: ( ruleShownConnection )
            {
            // InternalSPViz.g:959:2: ( ruleShownConnection )
            // InternalSPViz.g:960:3: ruleShownConnection
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
    // InternalSPViz.g:969:1: rule__ShownElement__ShownElementAssignment_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownElement__ShownElementAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:973:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:974:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:974:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:975:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownElementAccess().getShownElementArtifactCrossReference_1_0()); 
            // InternalSPViz.g:976:3: ( ruleQualifiedName )
            // InternalSPViz.g:977:4: ruleQualifiedName
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
    // InternalSPViz.g:988:1: rule__ShownElement__ContainedInAssignment_2_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownElement__ContainedInAssignment_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:992:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:993:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:993:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:994:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownElementAccess().getContainedInArtifactCrossReference_2_1_0()); 
            // InternalSPViz.g:995:3: ( ruleQualifiedName )
            // InternalSPViz.g:996:4: ruleQualifiedName
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
    // InternalSPViz.g:1007:1: rule__ShownConnection__ShownConnectionAssignment_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownConnection__ShownConnectionAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1011:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1012:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1012:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1013:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownConnectionAccess().getShownConnectionConnectionCrossReference_1_0()); 
            // InternalSPViz.g:1014:3: ( ruleQualifiedName )
            // InternalSPViz.g:1015:4: ruleQualifiedName
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
    // InternalSPViz.g:1026:1: rule__ShownConnection__ViaAssignment_2_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__ShownConnection__ViaAssignment_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPViz.g:1030:1: ( ( ( ruleQualifiedName ) ) )
            // InternalSPViz.g:1031:2: ( ( ruleQualifiedName ) )
            {
            // InternalSPViz.g:1031:2: ( ( ruleQualifiedName ) )
            // InternalSPViz.g:1032:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getShownConnectionAccess().getViaArtifactCrossReference_2_1_0()); 
            // InternalSPViz.g:1033:3: ( ruleQualifiedName )
            // InternalSPViz.g:1034:4: ruleQualifiedName
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
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000004010L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000000012L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x000000000002C000L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000008002L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000000020002L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000000040000L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x0000000000080000L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000000080002L});

}