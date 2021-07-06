package de.cau.cs.kieler.spviz.spvizmodel.ide.contentassist.antlr.internal;

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
import de.cau.cs.kieler.spviz.spvizmodel.services.SPVizModelGrammarAccess;



import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class InternalSPVizModelParser extends AbstractInternalContentAssistParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'package'", "'SPVizModel'", "'{'", "'}'", "'contains'", "'depends'", "'.'"
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

    	public void setGrammarAccess(SPVizModelGrammarAccess grammarAccess) {
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



    // $ANTLR start "entryRuleSPVizModel"
    // InternalSPVizModel.g:53:1: entryRuleSPVizModel : ruleSPVizModel EOF ;
    public final void entryRuleSPVizModel() throws RecognitionException {
        try {
            // InternalSPVizModel.g:54:1: ( ruleSPVizModel EOF )
            // InternalSPVizModel.g:55:1: ruleSPVizModel EOF
            {
             before(grammarAccess.getSPVizModelRule()); 
            pushFollow(FOLLOW_1);
            ruleSPVizModel();

            state._fsp--;

             after(grammarAccess.getSPVizModelRule()); 
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
    // $ANTLR end "entryRuleSPVizModel"


    // $ANTLR start "ruleSPVizModel"
    // InternalSPVizModel.g:62:1: ruleSPVizModel : ( ( rule__SPVizModel__Group__0 ) ) ;
    public final void ruleSPVizModel() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:66:2: ( ( ( rule__SPVizModel__Group__0 ) ) )
            // InternalSPVizModel.g:67:2: ( ( rule__SPVizModel__Group__0 ) )
            {
            // InternalSPVizModel.g:67:2: ( ( rule__SPVizModel__Group__0 ) )
            // InternalSPVizModel.g:68:3: ( rule__SPVizModel__Group__0 )
            {
             before(grammarAccess.getSPVizModelAccess().getGroup()); 
            // InternalSPVizModel.g:69:3: ( rule__SPVizModel__Group__0 )
            // InternalSPVizModel.g:69:4: rule__SPVizModel__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__SPVizModel__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getSPVizModelAccess().getGroup()); 

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
    // $ANTLR end "ruleSPVizModel"


    // $ANTLR start "entryRuleArtifact"
    // InternalSPVizModel.g:78:1: entryRuleArtifact : ruleArtifact EOF ;
    public final void entryRuleArtifact() throws RecognitionException {
        try {
            // InternalSPVizModel.g:79:1: ( ruleArtifact EOF )
            // InternalSPVizModel.g:80:1: ruleArtifact EOF
            {
             before(grammarAccess.getArtifactRule()); 
            pushFollow(FOLLOW_1);
            ruleArtifact();

            state._fsp--;

             after(grammarAccess.getArtifactRule()); 
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
    // $ANTLR end "entryRuleArtifact"


    // $ANTLR start "ruleArtifact"
    // InternalSPVizModel.g:87:1: ruleArtifact : ( ( rule__Artifact__Group__0 ) ) ;
    public final void ruleArtifact() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:91:2: ( ( ( rule__Artifact__Group__0 ) ) )
            // InternalSPVizModel.g:92:2: ( ( rule__Artifact__Group__0 ) )
            {
            // InternalSPVizModel.g:92:2: ( ( rule__Artifact__Group__0 ) )
            // InternalSPVizModel.g:93:3: ( rule__Artifact__Group__0 )
            {
             before(grammarAccess.getArtifactAccess().getGroup()); 
            // InternalSPVizModel.g:94:3: ( rule__Artifact__Group__0 )
            // InternalSPVizModel.g:94:4: rule__Artifact__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__Artifact__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getArtifactAccess().getGroup()); 

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
    // $ANTLR end "ruleArtifact"


    // $ANTLR start "entryRuleReference"
    // InternalSPVizModel.g:103:1: entryRuleReference : ruleReference EOF ;
    public final void entryRuleReference() throws RecognitionException {
        try {
            // InternalSPVizModel.g:104:1: ( ruleReference EOF )
            // InternalSPVizModel.g:105:1: ruleReference EOF
            {
             before(grammarAccess.getReferenceRule()); 
            pushFollow(FOLLOW_1);
            ruleReference();

            state._fsp--;

             after(grammarAccess.getReferenceRule()); 
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
    // $ANTLR end "entryRuleReference"


    // $ANTLR start "ruleReference"
    // InternalSPVizModel.g:112:1: ruleReference : ( ( rule__Reference__Alternatives ) ) ;
    public final void ruleReference() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:116:2: ( ( ( rule__Reference__Alternatives ) ) )
            // InternalSPVizModel.g:117:2: ( ( rule__Reference__Alternatives ) )
            {
            // InternalSPVizModel.g:117:2: ( ( rule__Reference__Alternatives ) )
            // InternalSPVizModel.g:118:3: ( rule__Reference__Alternatives )
            {
             before(grammarAccess.getReferenceAccess().getAlternatives()); 
            // InternalSPVizModel.g:119:3: ( rule__Reference__Alternatives )
            // InternalSPVizModel.g:119:4: rule__Reference__Alternatives
            {
            pushFollow(FOLLOW_2);
            rule__Reference__Alternatives();

            state._fsp--;


            }

             after(grammarAccess.getReferenceAccess().getAlternatives()); 

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
    // $ANTLR end "ruleReference"


    // $ANTLR start "entryRuleContainment"
    // InternalSPVizModel.g:128:1: entryRuleContainment : ruleContainment EOF ;
    public final void entryRuleContainment() throws RecognitionException {
        try {
            // InternalSPVizModel.g:129:1: ( ruleContainment EOF )
            // InternalSPVizModel.g:130:1: ruleContainment EOF
            {
             before(grammarAccess.getContainmentRule()); 
            pushFollow(FOLLOW_1);
            ruleContainment();

            state._fsp--;

             after(grammarAccess.getContainmentRule()); 
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
    // $ANTLR end "entryRuleContainment"


    // $ANTLR start "ruleContainment"
    // InternalSPVizModel.g:137:1: ruleContainment : ( ( rule__Containment__Group__0 ) ) ;
    public final void ruleContainment() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:141:2: ( ( ( rule__Containment__Group__0 ) ) )
            // InternalSPVizModel.g:142:2: ( ( rule__Containment__Group__0 ) )
            {
            // InternalSPVizModel.g:142:2: ( ( rule__Containment__Group__0 ) )
            // InternalSPVizModel.g:143:3: ( rule__Containment__Group__0 )
            {
             before(grammarAccess.getContainmentAccess().getGroup()); 
            // InternalSPVizModel.g:144:3: ( rule__Containment__Group__0 )
            // InternalSPVizModel.g:144:4: rule__Containment__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__Containment__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getContainmentAccess().getGroup()); 

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
    // $ANTLR end "ruleContainment"


    // $ANTLR start "entryRuleConnection"
    // InternalSPVizModel.g:153:1: entryRuleConnection : ruleConnection EOF ;
    public final void entryRuleConnection() throws RecognitionException {
        try {
            // InternalSPVizModel.g:154:1: ( ruleConnection EOF )
            // InternalSPVizModel.g:155:1: ruleConnection EOF
            {
             before(grammarAccess.getConnectionRule()); 
            pushFollow(FOLLOW_1);
            ruleConnection();

            state._fsp--;

             after(grammarAccess.getConnectionRule()); 
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
    // $ANTLR end "entryRuleConnection"


    // $ANTLR start "ruleConnection"
    // InternalSPVizModel.g:162:1: ruleConnection : ( ( rule__Connection__Group__0 ) ) ;
    public final void ruleConnection() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:166:2: ( ( ( rule__Connection__Group__0 ) ) )
            // InternalSPVizModel.g:167:2: ( ( rule__Connection__Group__0 ) )
            {
            // InternalSPVizModel.g:167:2: ( ( rule__Connection__Group__0 ) )
            // InternalSPVizModel.g:168:3: ( rule__Connection__Group__0 )
            {
             before(grammarAccess.getConnectionAccess().getGroup()); 
            // InternalSPVizModel.g:169:3: ( rule__Connection__Group__0 )
            // InternalSPVizModel.g:169:4: rule__Connection__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__Connection__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getConnectionAccess().getGroup()); 

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
    // $ANTLR end "ruleConnection"


    // $ANTLR start "entryRuleQualifiedName"
    // InternalSPVizModel.g:178:1: entryRuleQualifiedName : ruleQualifiedName EOF ;
    public final void entryRuleQualifiedName() throws RecognitionException {
        try {
            // InternalSPVizModel.g:179:1: ( ruleQualifiedName EOF )
            // InternalSPVizModel.g:180:1: ruleQualifiedName EOF
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
    // InternalSPVizModel.g:187:1: ruleQualifiedName : ( ( rule__QualifiedName__Group__0 ) ) ;
    public final void ruleQualifiedName() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:191:2: ( ( ( rule__QualifiedName__Group__0 ) ) )
            // InternalSPVizModel.g:192:2: ( ( rule__QualifiedName__Group__0 ) )
            {
            // InternalSPVizModel.g:192:2: ( ( rule__QualifiedName__Group__0 ) )
            // InternalSPVizModel.g:193:3: ( rule__QualifiedName__Group__0 )
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup()); 
            // InternalSPVizModel.g:194:3: ( rule__QualifiedName__Group__0 )
            // InternalSPVizModel.g:194:4: rule__QualifiedName__Group__0
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


    // $ANTLR start "rule__Reference__Alternatives"
    // InternalSPVizModel.g:202:1: rule__Reference__Alternatives : ( ( ruleContainment ) | ( ruleConnection ) );
    public final void rule__Reference__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:206:1: ( ( ruleContainment ) | ( ruleConnection ) )
            int alt1=2;
            int LA1_0 = input.LA(1);

            if ( (LA1_0==15) ) {
                alt1=1;
            }
            else if ( (LA1_0==RULE_ID) ) {
                alt1=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 1, 0, input);

                throw nvae;
            }
            switch (alt1) {
                case 1 :
                    // InternalSPVizModel.g:207:2: ( ruleContainment )
                    {
                    // InternalSPVizModel.g:207:2: ( ruleContainment )
                    // InternalSPVizModel.g:208:3: ruleContainment
                    {
                     before(grammarAccess.getReferenceAccess().getContainmentParserRuleCall_0()); 
                    pushFollow(FOLLOW_2);
                    ruleContainment();

                    state._fsp--;

                     after(grammarAccess.getReferenceAccess().getContainmentParserRuleCall_0()); 

                    }


                    }
                    break;
                case 2 :
                    // InternalSPVizModel.g:213:2: ( ruleConnection )
                    {
                    // InternalSPVizModel.g:213:2: ( ruleConnection )
                    // InternalSPVizModel.g:214:3: ruleConnection
                    {
                     before(grammarAccess.getReferenceAccess().getConnectionParserRuleCall_1()); 
                    pushFollow(FOLLOW_2);
                    ruleConnection();

                    state._fsp--;

                     after(grammarAccess.getReferenceAccess().getConnectionParserRuleCall_1()); 

                    }


                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Reference__Alternatives"


    // $ANTLR start "rule__SPVizModel__Group__0"
    // InternalSPVizModel.g:223:1: rule__SPVizModel__Group__0 : rule__SPVizModel__Group__0__Impl rule__SPVizModel__Group__1 ;
    public final void rule__SPVizModel__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:227:1: ( rule__SPVizModel__Group__0__Impl rule__SPVizModel__Group__1 )
            // InternalSPVizModel.g:228:2: rule__SPVizModel__Group__0__Impl rule__SPVizModel__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__SPVizModel__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPVizModel__Group__1();

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
    // $ANTLR end "rule__SPVizModel__Group__0"


    // $ANTLR start "rule__SPVizModel__Group__0__Impl"
    // InternalSPVizModel.g:235:1: rule__SPVizModel__Group__0__Impl : ( 'package' ) ;
    public final void rule__SPVizModel__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:239:1: ( ( 'package' ) )
            // InternalSPVizModel.g:240:1: ( 'package' )
            {
            // InternalSPVizModel.g:240:1: ( 'package' )
            // InternalSPVizModel.g:241:2: 'package'
            {
             before(grammarAccess.getSPVizModelAccess().getPackageKeyword_0()); 
            match(input,11,FOLLOW_2); 
             after(grammarAccess.getSPVizModelAccess().getPackageKeyword_0()); 

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
    // $ANTLR end "rule__SPVizModel__Group__0__Impl"


    // $ANTLR start "rule__SPVizModel__Group__1"
    // InternalSPVizModel.g:250:1: rule__SPVizModel__Group__1 : rule__SPVizModel__Group__1__Impl rule__SPVizModel__Group__2 ;
    public final void rule__SPVizModel__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:254:1: ( rule__SPVizModel__Group__1__Impl rule__SPVizModel__Group__2 )
            // InternalSPVizModel.g:255:2: rule__SPVizModel__Group__1__Impl rule__SPVizModel__Group__2
            {
            pushFollow(FOLLOW_4);
            rule__SPVizModel__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPVizModel__Group__2();

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
    // $ANTLR end "rule__SPVizModel__Group__1"


    // $ANTLR start "rule__SPVizModel__Group__1__Impl"
    // InternalSPVizModel.g:262:1: rule__SPVizModel__Group__1__Impl : ( ( rule__SPVizModel__PackageAssignment_1 ) ) ;
    public final void rule__SPVizModel__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:266:1: ( ( ( rule__SPVizModel__PackageAssignment_1 ) ) )
            // InternalSPVizModel.g:267:1: ( ( rule__SPVizModel__PackageAssignment_1 ) )
            {
            // InternalSPVizModel.g:267:1: ( ( rule__SPVizModel__PackageAssignment_1 ) )
            // InternalSPVizModel.g:268:2: ( rule__SPVizModel__PackageAssignment_1 )
            {
             before(grammarAccess.getSPVizModelAccess().getPackageAssignment_1()); 
            // InternalSPVizModel.g:269:2: ( rule__SPVizModel__PackageAssignment_1 )
            // InternalSPVizModel.g:269:3: rule__SPVizModel__PackageAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__SPVizModel__PackageAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getSPVizModelAccess().getPackageAssignment_1()); 

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
    // $ANTLR end "rule__SPVizModel__Group__1__Impl"


    // $ANTLR start "rule__SPVizModel__Group__2"
    // InternalSPVizModel.g:277:1: rule__SPVizModel__Group__2 : rule__SPVizModel__Group__2__Impl rule__SPVizModel__Group__3 ;
    public final void rule__SPVizModel__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:281:1: ( rule__SPVizModel__Group__2__Impl rule__SPVizModel__Group__3 )
            // InternalSPVizModel.g:282:2: rule__SPVizModel__Group__2__Impl rule__SPVizModel__Group__3
            {
            pushFollow(FOLLOW_3);
            rule__SPVizModel__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPVizModel__Group__3();

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
    // $ANTLR end "rule__SPVizModel__Group__2"


    // $ANTLR start "rule__SPVizModel__Group__2__Impl"
    // InternalSPVizModel.g:289:1: rule__SPVizModel__Group__2__Impl : ( 'SPVizModel' ) ;
    public final void rule__SPVizModel__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:293:1: ( ( 'SPVizModel' ) )
            // InternalSPVizModel.g:294:1: ( 'SPVizModel' )
            {
            // InternalSPVizModel.g:294:1: ( 'SPVizModel' )
            // InternalSPVizModel.g:295:2: 'SPVizModel'
            {
             before(grammarAccess.getSPVizModelAccess().getSPVizModelKeyword_2()); 
            match(input,12,FOLLOW_2); 
             after(grammarAccess.getSPVizModelAccess().getSPVizModelKeyword_2()); 

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
    // $ANTLR end "rule__SPVizModel__Group__2__Impl"


    // $ANTLR start "rule__SPVizModel__Group__3"
    // InternalSPVizModel.g:304:1: rule__SPVizModel__Group__3 : rule__SPVizModel__Group__3__Impl rule__SPVizModel__Group__4 ;
    public final void rule__SPVizModel__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:308:1: ( rule__SPVizModel__Group__3__Impl rule__SPVizModel__Group__4 )
            // InternalSPVizModel.g:309:2: rule__SPVizModel__Group__3__Impl rule__SPVizModel__Group__4
            {
            pushFollow(FOLLOW_5);
            rule__SPVizModel__Group__3__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPVizModel__Group__4();

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
    // $ANTLR end "rule__SPVizModel__Group__3"


    // $ANTLR start "rule__SPVizModel__Group__3__Impl"
    // InternalSPVizModel.g:316:1: rule__SPVizModel__Group__3__Impl : ( ( rule__SPVizModel__NameAssignment_3 ) ) ;
    public final void rule__SPVizModel__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:320:1: ( ( ( rule__SPVizModel__NameAssignment_3 ) ) )
            // InternalSPVizModel.g:321:1: ( ( rule__SPVizModel__NameAssignment_3 ) )
            {
            // InternalSPVizModel.g:321:1: ( ( rule__SPVizModel__NameAssignment_3 ) )
            // InternalSPVizModel.g:322:2: ( rule__SPVizModel__NameAssignment_3 )
            {
             before(grammarAccess.getSPVizModelAccess().getNameAssignment_3()); 
            // InternalSPVizModel.g:323:2: ( rule__SPVizModel__NameAssignment_3 )
            // InternalSPVizModel.g:323:3: rule__SPVizModel__NameAssignment_3
            {
            pushFollow(FOLLOW_2);
            rule__SPVizModel__NameAssignment_3();

            state._fsp--;


            }

             after(grammarAccess.getSPVizModelAccess().getNameAssignment_3()); 

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
    // $ANTLR end "rule__SPVizModel__Group__3__Impl"


    // $ANTLR start "rule__SPVizModel__Group__4"
    // InternalSPVizModel.g:331:1: rule__SPVizModel__Group__4 : rule__SPVizModel__Group__4__Impl rule__SPVizModel__Group__5 ;
    public final void rule__SPVizModel__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:335:1: ( rule__SPVizModel__Group__4__Impl rule__SPVizModel__Group__5 )
            // InternalSPVizModel.g:336:2: rule__SPVizModel__Group__4__Impl rule__SPVizModel__Group__5
            {
            pushFollow(FOLLOW_6);
            rule__SPVizModel__Group__4__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPVizModel__Group__5();

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
    // $ANTLR end "rule__SPVizModel__Group__4"


    // $ANTLR start "rule__SPVizModel__Group__4__Impl"
    // InternalSPVizModel.g:343:1: rule__SPVizModel__Group__4__Impl : ( '{' ) ;
    public final void rule__SPVizModel__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:347:1: ( ( '{' ) )
            // InternalSPVizModel.g:348:1: ( '{' )
            {
            // InternalSPVizModel.g:348:1: ( '{' )
            // InternalSPVizModel.g:349:2: '{'
            {
             before(grammarAccess.getSPVizModelAccess().getLeftCurlyBracketKeyword_4()); 
            match(input,13,FOLLOW_2); 
             after(grammarAccess.getSPVizModelAccess().getLeftCurlyBracketKeyword_4()); 

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
    // $ANTLR end "rule__SPVizModel__Group__4__Impl"


    // $ANTLR start "rule__SPVizModel__Group__5"
    // InternalSPVizModel.g:358:1: rule__SPVizModel__Group__5 : rule__SPVizModel__Group__5__Impl rule__SPVizModel__Group__6 ;
    public final void rule__SPVizModel__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:362:1: ( rule__SPVizModel__Group__5__Impl rule__SPVizModel__Group__6 )
            // InternalSPVizModel.g:363:2: rule__SPVizModel__Group__5__Impl rule__SPVizModel__Group__6
            {
            pushFollow(FOLLOW_6);
            rule__SPVizModel__Group__5__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__SPVizModel__Group__6();

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
    // $ANTLR end "rule__SPVizModel__Group__5"


    // $ANTLR start "rule__SPVizModel__Group__5__Impl"
    // InternalSPVizModel.g:370:1: rule__SPVizModel__Group__5__Impl : ( ( rule__SPVizModel__ArtifactsAssignment_5 )* ) ;
    public final void rule__SPVizModel__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:374:1: ( ( ( rule__SPVizModel__ArtifactsAssignment_5 )* ) )
            // InternalSPVizModel.g:375:1: ( ( rule__SPVizModel__ArtifactsAssignment_5 )* )
            {
            // InternalSPVizModel.g:375:1: ( ( rule__SPVizModel__ArtifactsAssignment_5 )* )
            // InternalSPVizModel.g:376:2: ( rule__SPVizModel__ArtifactsAssignment_5 )*
            {
             before(grammarAccess.getSPVizModelAccess().getArtifactsAssignment_5()); 
            // InternalSPVizModel.g:377:2: ( rule__SPVizModel__ArtifactsAssignment_5 )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==RULE_ID) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // InternalSPVizModel.g:377:3: rule__SPVizModel__ArtifactsAssignment_5
            	    {
            	    pushFollow(FOLLOW_7);
            	    rule__SPVizModel__ArtifactsAssignment_5();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop2;
                }
            } while (true);

             after(grammarAccess.getSPVizModelAccess().getArtifactsAssignment_5()); 

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
    // $ANTLR end "rule__SPVizModel__Group__5__Impl"


    // $ANTLR start "rule__SPVizModel__Group__6"
    // InternalSPVizModel.g:385:1: rule__SPVizModel__Group__6 : rule__SPVizModel__Group__6__Impl ;
    public final void rule__SPVizModel__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:389:1: ( rule__SPVizModel__Group__6__Impl )
            // InternalSPVizModel.g:390:2: rule__SPVizModel__Group__6__Impl
            {
            pushFollow(FOLLOW_2);
            rule__SPVizModel__Group__6__Impl();

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
    // $ANTLR end "rule__SPVizModel__Group__6"


    // $ANTLR start "rule__SPVizModel__Group__6__Impl"
    // InternalSPVizModel.g:396:1: rule__SPVizModel__Group__6__Impl : ( '}' ) ;
    public final void rule__SPVizModel__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:400:1: ( ( '}' ) )
            // InternalSPVizModel.g:401:1: ( '}' )
            {
            // InternalSPVizModel.g:401:1: ( '}' )
            // InternalSPVizModel.g:402:2: '}'
            {
             before(grammarAccess.getSPVizModelAccess().getRightCurlyBracketKeyword_6()); 
            match(input,14,FOLLOW_2); 
             after(grammarAccess.getSPVizModelAccess().getRightCurlyBracketKeyword_6()); 

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
    // $ANTLR end "rule__SPVizModel__Group__6__Impl"


    // $ANTLR start "rule__Artifact__Group__0"
    // InternalSPVizModel.g:412:1: rule__Artifact__Group__0 : rule__Artifact__Group__0__Impl rule__Artifact__Group__1 ;
    public final void rule__Artifact__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:416:1: ( rule__Artifact__Group__0__Impl rule__Artifact__Group__1 )
            // InternalSPVizModel.g:417:2: rule__Artifact__Group__0__Impl rule__Artifact__Group__1
            {
            pushFollow(FOLLOW_5);
            rule__Artifact__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Artifact__Group__1();

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
    // $ANTLR end "rule__Artifact__Group__0"


    // $ANTLR start "rule__Artifact__Group__0__Impl"
    // InternalSPVizModel.g:424:1: rule__Artifact__Group__0__Impl : ( ( rule__Artifact__NameAssignment_0 ) ) ;
    public final void rule__Artifact__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:428:1: ( ( ( rule__Artifact__NameAssignment_0 ) ) )
            // InternalSPVizModel.g:429:1: ( ( rule__Artifact__NameAssignment_0 ) )
            {
            // InternalSPVizModel.g:429:1: ( ( rule__Artifact__NameAssignment_0 ) )
            // InternalSPVizModel.g:430:2: ( rule__Artifact__NameAssignment_0 )
            {
             before(grammarAccess.getArtifactAccess().getNameAssignment_0()); 
            // InternalSPVizModel.g:431:2: ( rule__Artifact__NameAssignment_0 )
            // InternalSPVizModel.g:431:3: rule__Artifact__NameAssignment_0
            {
            pushFollow(FOLLOW_2);
            rule__Artifact__NameAssignment_0();

            state._fsp--;


            }

             after(grammarAccess.getArtifactAccess().getNameAssignment_0()); 

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
    // $ANTLR end "rule__Artifact__Group__0__Impl"


    // $ANTLR start "rule__Artifact__Group__1"
    // InternalSPVizModel.g:439:1: rule__Artifact__Group__1 : rule__Artifact__Group__1__Impl ;
    public final void rule__Artifact__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:443:1: ( rule__Artifact__Group__1__Impl )
            // InternalSPVizModel.g:444:2: rule__Artifact__Group__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Artifact__Group__1__Impl();

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
    // $ANTLR end "rule__Artifact__Group__1"


    // $ANTLR start "rule__Artifact__Group__1__Impl"
    // InternalSPVizModel.g:450:1: rule__Artifact__Group__1__Impl : ( ( rule__Artifact__Group_1__0 )? ) ;
    public final void rule__Artifact__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:454:1: ( ( ( rule__Artifact__Group_1__0 )? ) )
            // InternalSPVizModel.g:455:1: ( ( rule__Artifact__Group_1__0 )? )
            {
            // InternalSPVizModel.g:455:1: ( ( rule__Artifact__Group_1__0 )? )
            // InternalSPVizModel.g:456:2: ( rule__Artifact__Group_1__0 )?
            {
             before(grammarAccess.getArtifactAccess().getGroup_1()); 
            // InternalSPVizModel.g:457:2: ( rule__Artifact__Group_1__0 )?
            int alt3=2;
            int LA3_0 = input.LA(1);

            if ( (LA3_0==13) ) {
                alt3=1;
            }
            switch (alt3) {
                case 1 :
                    // InternalSPVizModel.g:457:3: rule__Artifact__Group_1__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__Artifact__Group_1__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getArtifactAccess().getGroup_1()); 

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
    // $ANTLR end "rule__Artifact__Group__1__Impl"


    // $ANTLR start "rule__Artifact__Group_1__0"
    // InternalSPVizModel.g:466:1: rule__Artifact__Group_1__0 : rule__Artifact__Group_1__0__Impl rule__Artifact__Group_1__1 ;
    public final void rule__Artifact__Group_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:470:1: ( rule__Artifact__Group_1__0__Impl rule__Artifact__Group_1__1 )
            // InternalSPVizModel.g:471:2: rule__Artifact__Group_1__0__Impl rule__Artifact__Group_1__1
            {
            pushFollow(FOLLOW_8);
            rule__Artifact__Group_1__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Artifact__Group_1__1();

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
    // $ANTLR end "rule__Artifact__Group_1__0"


    // $ANTLR start "rule__Artifact__Group_1__0__Impl"
    // InternalSPVizModel.g:478:1: rule__Artifact__Group_1__0__Impl : ( '{' ) ;
    public final void rule__Artifact__Group_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:482:1: ( ( '{' ) )
            // InternalSPVizModel.g:483:1: ( '{' )
            {
            // InternalSPVizModel.g:483:1: ( '{' )
            // InternalSPVizModel.g:484:2: '{'
            {
             before(grammarAccess.getArtifactAccess().getLeftCurlyBracketKeyword_1_0()); 
            match(input,13,FOLLOW_2); 
             after(grammarAccess.getArtifactAccess().getLeftCurlyBracketKeyword_1_0()); 

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
    // $ANTLR end "rule__Artifact__Group_1__0__Impl"


    // $ANTLR start "rule__Artifact__Group_1__1"
    // InternalSPVizModel.g:493:1: rule__Artifact__Group_1__1 : rule__Artifact__Group_1__1__Impl rule__Artifact__Group_1__2 ;
    public final void rule__Artifact__Group_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:497:1: ( rule__Artifact__Group_1__1__Impl rule__Artifact__Group_1__2 )
            // InternalSPVizModel.g:498:2: rule__Artifact__Group_1__1__Impl rule__Artifact__Group_1__2
            {
            pushFollow(FOLLOW_8);
            rule__Artifact__Group_1__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Artifact__Group_1__2();

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
    // $ANTLR end "rule__Artifact__Group_1__1"


    // $ANTLR start "rule__Artifact__Group_1__1__Impl"
    // InternalSPVizModel.g:505:1: rule__Artifact__Group_1__1__Impl : ( ( rule__Artifact__ReferencesAssignment_1_1 )* ) ;
    public final void rule__Artifact__Group_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:509:1: ( ( ( rule__Artifact__ReferencesAssignment_1_1 )* ) )
            // InternalSPVizModel.g:510:1: ( ( rule__Artifact__ReferencesAssignment_1_1 )* )
            {
            // InternalSPVizModel.g:510:1: ( ( rule__Artifact__ReferencesAssignment_1_1 )* )
            // InternalSPVizModel.g:511:2: ( rule__Artifact__ReferencesAssignment_1_1 )*
            {
             before(grammarAccess.getArtifactAccess().getReferencesAssignment_1_1()); 
            // InternalSPVizModel.g:512:2: ( rule__Artifact__ReferencesAssignment_1_1 )*
            loop4:
            do {
                int alt4=2;
                int LA4_0 = input.LA(1);

                if ( (LA4_0==RULE_ID||LA4_0==15) ) {
                    alt4=1;
                }


                switch (alt4) {
            	case 1 :
            	    // InternalSPVizModel.g:512:3: rule__Artifact__ReferencesAssignment_1_1
            	    {
            	    pushFollow(FOLLOW_9);
            	    rule__Artifact__ReferencesAssignment_1_1();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop4;
                }
            } while (true);

             after(grammarAccess.getArtifactAccess().getReferencesAssignment_1_1()); 

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
    // $ANTLR end "rule__Artifact__Group_1__1__Impl"


    // $ANTLR start "rule__Artifact__Group_1__2"
    // InternalSPVizModel.g:520:1: rule__Artifact__Group_1__2 : rule__Artifact__Group_1__2__Impl ;
    public final void rule__Artifact__Group_1__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:524:1: ( rule__Artifact__Group_1__2__Impl )
            // InternalSPVizModel.g:525:2: rule__Artifact__Group_1__2__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Artifact__Group_1__2__Impl();

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
    // $ANTLR end "rule__Artifact__Group_1__2"


    // $ANTLR start "rule__Artifact__Group_1__2__Impl"
    // InternalSPVizModel.g:531:1: rule__Artifact__Group_1__2__Impl : ( '}' ) ;
    public final void rule__Artifact__Group_1__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:535:1: ( ( '}' ) )
            // InternalSPVizModel.g:536:1: ( '}' )
            {
            // InternalSPVizModel.g:536:1: ( '}' )
            // InternalSPVizModel.g:537:2: '}'
            {
             before(grammarAccess.getArtifactAccess().getRightCurlyBracketKeyword_1_2()); 
            match(input,14,FOLLOW_2); 
             after(grammarAccess.getArtifactAccess().getRightCurlyBracketKeyword_1_2()); 

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
    // $ANTLR end "rule__Artifact__Group_1__2__Impl"


    // $ANTLR start "rule__Containment__Group__0"
    // InternalSPVizModel.g:547:1: rule__Containment__Group__0 : rule__Containment__Group__0__Impl rule__Containment__Group__1 ;
    public final void rule__Containment__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:551:1: ( rule__Containment__Group__0__Impl rule__Containment__Group__1 )
            // InternalSPVizModel.g:552:2: rule__Containment__Group__0__Impl rule__Containment__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__Containment__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Containment__Group__1();

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
    // $ANTLR end "rule__Containment__Group__0"


    // $ANTLR start "rule__Containment__Group__0__Impl"
    // InternalSPVizModel.g:559:1: rule__Containment__Group__0__Impl : ( 'contains' ) ;
    public final void rule__Containment__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:563:1: ( ( 'contains' ) )
            // InternalSPVizModel.g:564:1: ( 'contains' )
            {
            // InternalSPVizModel.g:564:1: ( 'contains' )
            // InternalSPVizModel.g:565:2: 'contains'
            {
             before(grammarAccess.getContainmentAccess().getContainsKeyword_0()); 
            match(input,15,FOLLOW_2); 
             after(grammarAccess.getContainmentAccess().getContainsKeyword_0()); 

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
    // $ANTLR end "rule__Containment__Group__0__Impl"


    // $ANTLR start "rule__Containment__Group__1"
    // InternalSPVizModel.g:574:1: rule__Containment__Group__1 : rule__Containment__Group__1__Impl ;
    public final void rule__Containment__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:578:1: ( rule__Containment__Group__1__Impl )
            // InternalSPVizModel.g:579:2: rule__Containment__Group__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Containment__Group__1__Impl();

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
    // $ANTLR end "rule__Containment__Group__1"


    // $ANTLR start "rule__Containment__Group__1__Impl"
    // InternalSPVizModel.g:585:1: rule__Containment__Group__1__Impl : ( ( rule__Containment__ContainsAssignment_1 ) ) ;
    public final void rule__Containment__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:589:1: ( ( ( rule__Containment__ContainsAssignment_1 ) ) )
            // InternalSPVizModel.g:590:1: ( ( rule__Containment__ContainsAssignment_1 ) )
            {
            // InternalSPVizModel.g:590:1: ( ( rule__Containment__ContainsAssignment_1 ) )
            // InternalSPVizModel.g:591:2: ( rule__Containment__ContainsAssignment_1 )
            {
             before(grammarAccess.getContainmentAccess().getContainsAssignment_1()); 
            // InternalSPVizModel.g:592:2: ( rule__Containment__ContainsAssignment_1 )
            // InternalSPVizModel.g:592:3: rule__Containment__ContainsAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__Containment__ContainsAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getContainmentAccess().getContainsAssignment_1()); 

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
    // $ANTLR end "rule__Containment__Group__1__Impl"


    // $ANTLR start "rule__Connection__Group__0"
    // InternalSPVizModel.g:601:1: rule__Connection__Group__0 : rule__Connection__Group__0__Impl rule__Connection__Group__1 ;
    public final void rule__Connection__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:605:1: ( rule__Connection__Group__0__Impl rule__Connection__Group__1 )
            // InternalSPVizModel.g:606:2: rule__Connection__Group__0__Impl rule__Connection__Group__1
            {
            pushFollow(FOLLOW_10);
            rule__Connection__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Connection__Group__1();

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
    // $ANTLR end "rule__Connection__Group__0"


    // $ANTLR start "rule__Connection__Group__0__Impl"
    // InternalSPVizModel.g:613:1: rule__Connection__Group__0__Impl : ( ( rule__Connection__NameAssignment_0 ) ) ;
    public final void rule__Connection__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:617:1: ( ( ( rule__Connection__NameAssignment_0 ) ) )
            // InternalSPVizModel.g:618:1: ( ( rule__Connection__NameAssignment_0 ) )
            {
            // InternalSPVizModel.g:618:1: ( ( rule__Connection__NameAssignment_0 ) )
            // InternalSPVizModel.g:619:2: ( rule__Connection__NameAssignment_0 )
            {
             before(grammarAccess.getConnectionAccess().getNameAssignment_0()); 
            // InternalSPVizModel.g:620:2: ( rule__Connection__NameAssignment_0 )
            // InternalSPVizModel.g:620:3: rule__Connection__NameAssignment_0
            {
            pushFollow(FOLLOW_2);
            rule__Connection__NameAssignment_0();

            state._fsp--;


            }

             after(grammarAccess.getConnectionAccess().getNameAssignment_0()); 

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
    // $ANTLR end "rule__Connection__Group__0__Impl"


    // $ANTLR start "rule__Connection__Group__1"
    // InternalSPVizModel.g:628:1: rule__Connection__Group__1 : rule__Connection__Group__1__Impl rule__Connection__Group__2 ;
    public final void rule__Connection__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:632:1: ( rule__Connection__Group__1__Impl rule__Connection__Group__2 )
            // InternalSPVizModel.g:633:2: rule__Connection__Group__1__Impl rule__Connection__Group__2
            {
            pushFollow(FOLLOW_3);
            rule__Connection__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Connection__Group__2();

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
    // $ANTLR end "rule__Connection__Group__1"


    // $ANTLR start "rule__Connection__Group__1__Impl"
    // InternalSPVizModel.g:640:1: rule__Connection__Group__1__Impl : ( 'depends' ) ;
    public final void rule__Connection__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:644:1: ( ( 'depends' ) )
            // InternalSPVizModel.g:645:1: ( 'depends' )
            {
            // InternalSPVizModel.g:645:1: ( 'depends' )
            // InternalSPVizModel.g:646:2: 'depends'
            {
             before(grammarAccess.getConnectionAccess().getDependsKeyword_1()); 
            match(input,16,FOLLOW_2); 
             after(grammarAccess.getConnectionAccess().getDependsKeyword_1()); 

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
    // $ANTLR end "rule__Connection__Group__1__Impl"


    // $ANTLR start "rule__Connection__Group__2"
    // InternalSPVizModel.g:655:1: rule__Connection__Group__2 : rule__Connection__Group__2__Impl ;
    public final void rule__Connection__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:659:1: ( rule__Connection__Group__2__Impl )
            // InternalSPVizModel.g:660:2: rule__Connection__Group__2__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Connection__Group__2__Impl();

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
    // $ANTLR end "rule__Connection__Group__2"


    // $ANTLR start "rule__Connection__Group__2__Impl"
    // InternalSPVizModel.g:666:1: rule__Connection__Group__2__Impl : ( ( rule__Connection__DependsOnAssignment_2 ) ) ;
    public final void rule__Connection__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:670:1: ( ( ( rule__Connection__DependsOnAssignment_2 ) ) )
            // InternalSPVizModel.g:671:1: ( ( rule__Connection__DependsOnAssignment_2 ) )
            {
            // InternalSPVizModel.g:671:1: ( ( rule__Connection__DependsOnAssignment_2 ) )
            // InternalSPVizModel.g:672:2: ( rule__Connection__DependsOnAssignment_2 )
            {
             before(grammarAccess.getConnectionAccess().getDependsOnAssignment_2()); 
            // InternalSPVizModel.g:673:2: ( rule__Connection__DependsOnAssignment_2 )
            // InternalSPVizModel.g:673:3: rule__Connection__DependsOnAssignment_2
            {
            pushFollow(FOLLOW_2);
            rule__Connection__DependsOnAssignment_2();

            state._fsp--;


            }

             after(grammarAccess.getConnectionAccess().getDependsOnAssignment_2()); 

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
    // $ANTLR end "rule__Connection__Group__2__Impl"


    // $ANTLR start "rule__QualifiedName__Group__0"
    // InternalSPVizModel.g:682:1: rule__QualifiedName__Group__0 : rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 ;
    public final void rule__QualifiedName__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:686:1: ( rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 )
            // InternalSPVizModel.g:687:2: rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1
            {
            pushFollow(FOLLOW_11);
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
    // InternalSPVizModel.g:694:1: rule__QualifiedName__Group__0__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:698:1: ( ( RULE_ID ) )
            // InternalSPVizModel.g:699:1: ( RULE_ID )
            {
            // InternalSPVizModel.g:699:1: ( RULE_ID )
            // InternalSPVizModel.g:700:2: RULE_ID
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
    // InternalSPVizModel.g:709:1: rule__QualifiedName__Group__1 : rule__QualifiedName__Group__1__Impl ;
    public final void rule__QualifiedName__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:713:1: ( rule__QualifiedName__Group__1__Impl )
            // InternalSPVizModel.g:714:2: rule__QualifiedName__Group__1__Impl
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
    // InternalSPVizModel.g:720:1: rule__QualifiedName__Group__1__Impl : ( ( rule__QualifiedName__Group_1__0 )* ) ;
    public final void rule__QualifiedName__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:724:1: ( ( ( rule__QualifiedName__Group_1__0 )* ) )
            // InternalSPVizModel.g:725:1: ( ( rule__QualifiedName__Group_1__0 )* )
            {
            // InternalSPVizModel.g:725:1: ( ( rule__QualifiedName__Group_1__0 )* )
            // InternalSPVizModel.g:726:2: ( rule__QualifiedName__Group_1__0 )*
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup_1()); 
            // InternalSPVizModel.g:727:2: ( rule__QualifiedName__Group_1__0 )*
            loop5:
            do {
                int alt5=2;
                int LA5_0 = input.LA(1);

                if ( (LA5_0==17) ) {
                    alt5=1;
                }


                switch (alt5) {
            	case 1 :
            	    // InternalSPVizModel.g:727:3: rule__QualifiedName__Group_1__0
            	    {
            	    pushFollow(FOLLOW_12);
            	    rule__QualifiedName__Group_1__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop5;
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
    // InternalSPVizModel.g:736:1: rule__QualifiedName__Group_1__0 : rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 ;
    public final void rule__QualifiedName__Group_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:740:1: ( rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 )
            // InternalSPVizModel.g:741:2: rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1
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
    // InternalSPVizModel.g:748:1: rule__QualifiedName__Group_1__0__Impl : ( '.' ) ;
    public final void rule__QualifiedName__Group_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:752:1: ( ( '.' ) )
            // InternalSPVizModel.g:753:1: ( '.' )
            {
            // InternalSPVizModel.g:753:1: ( '.' )
            // InternalSPVizModel.g:754:2: '.'
            {
             before(grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0()); 
            match(input,17,FOLLOW_2); 
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
    // InternalSPVizModel.g:763:1: rule__QualifiedName__Group_1__1 : rule__QualifiedName__Group_1__1__Impl ;
    public final void rule__QualifiedName__Group_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:767:1: ( rule__QualifiedName__Group_1__1__Impl )
            // InternalSPVizModel.g:768:2: rule__QualifiedName__Group_1__1__Impl
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
    // InternalSPVizModel.g:774:1: rule__QualifiedName__Group_1__1__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:778:1: ( ( RULE_ID ) )
            // InternalSPVizModel.g:779:1: ( RULE_ID )
            {
            // InternalSPVizModel.g:779:1: ( RULE_ID )
            // InternalSPVizModel.g:780:2: RULE_ID
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


    // $ANTLR start "rule__SPVizModel__PackageAssignment_1"
    // InternalSPVizModel.g:790:1: rule__SPVizModel__PackageAssignment_1 : ( ruleQualifiedName ) ;
    public final void rule__SPVizModel__PackageAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:794:1: ( ( ruleQualifiedName ) )
            // InternalSPVizModel.g:795:2: ( ruleQualifiedName )
            {
            // InternalSPVizModel.g:795:2: ( ruleQualifiedName )
            // InternalSPVizModel.g:796:3: ruleQualifiedName
            {
             before(grammarAccess.getSPVizModelAccess().getPackageQualifiedNameParserRuleCall_1_0()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getSPVizModelAccess().getPackageQualifiedNameParserRuleCall_1_0()); 

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
    // $ANTLR end "rule__SPVizModel__PackageAssignment_1"


    // $ANTLR start "rule__SPVizModel__NameAssignment_3"
    // InternalSPVizModel.g:805:1: rule__SPVizModel__NameAssignment_3 : ( RULE_ID ) ;
    public final void rule__SPVizModel__NameAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:809:1: ( ( RULE_ID ) )
            // InternalSPVizModel.g:810:2: ( RULE_ID )
            {
            // InternalSPVizModel.g:810:2: ( RULE_ID )
            // InternalSPVizModel.g:811:3: RULE_ID
            {
             before(grammarAccess.getSPVizModelAccess().getNameIDTerminalRuleCall_3_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getSPVizModelAccess().getNameIDTerminalRuleCall_3_0()); 

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
    // $ANTLR end "rule__SPVizModel__NameAssignment_3"


    // $ANTLR start "rule__SPVizModel__ArtifactsAssignment_5"
    // InternalSPVizModel.g:820:1: rule__SPVizModel__ArtifactsAssignment_5 : ( ruleArtifact ) ;
    public final void rule__SPVizModel__ArtifactsAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:824:1: ( ( ruleArtifact ) )
            // InternalSPVizModel.g:825:2: ( ruleArtifact )
            {
            // InternalSPVizModel.g:825:2: ( ruleArtifact )
            // InternalSPVizModel.g:826:3: ruleArtifact
            {
             before(grammarAccess.getSPVizModelAccess().getArtifactsArtifactParserRuleCall_5_0()); 
            pushFollow(FOLLOW_2);
            ruleArtifact();

            state._fsp--;

             after(grammarAccess.getSPVizModelAccess().getArtifactsArtifactParserRuleCall_5_0()); 

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
    // $ANTLR end "rule__SPVizModel__ArtifactsAssignment_5"


    // $ANTLR start "rule__Artifact__NameAssignment_0"
    // InternalSPVizModel.g:835:1: rule__Artifact__NameAssignment_0 : ( RULE_ID ) ;
    public final void rule__Artifact__NameAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:839:1: ( ( RULE_ID ) )
            // InternalSPVizModel.g:840:2: ( RULE_ID )
            {
            // InternalSPVizModel.g:840:2: ( RULE_ID )
            // InternalSPVizModel.g:841:3: RULE_ID
            {
             before(grammarAccess.getArtifactAccess().getNameIDTerminalRuleCall_0_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getArtifactAccess().getNameIDTerminalRuleCall_0_0()); 

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
    // $ANTLR end "rule__Artifact__NameAssignment_0"


    // $ANTLR start "rule__Artifact__ReferencesAssignment_1_1"
    // InternalSPVizModel.g:850:1: rule__Artifact__ReferencesAssignment_1_1 : ( ruleReference ) ;
    public final void rule__Artifact__ReferencesAssignment_1_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:854:1: ( ( ruleReference ) )
            // InternalSPVizModel.g:855:2: ( ruleReference )
            {
            // InternalSPVizModel.g:855:2: ( ruleReference )
            // InternalSPVizModel.g:856:3: ruleReference
            {
             before(grammarAccess.getArtifactAccess().getReferencesReferenceParserRuleCall_1_1_0()); 
            pushFollow(FOLLOW_2);
            ruleReference();

            state._fsp--;

             after(grammarAccess.getArtifactAccess().getReferencesReferenceParserRuleCall_1_1_0()); 

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
    // $ANTLR end "rule__Artifact__ReferencesAssignment_1_1"


    // $ANTLR start "rule__Containment__ContainsAssignment_1"
    // InternalSPVizModel.g:865:1: rule__Containment__ContainsAssignment_1 : ( ( RULE_ID ) ) ;
    public final void rule__Containment__ContainsAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:869:1: ( ( ( RULE_ID ) ) )
            // InternalSPVizModel.g:870:2: ( ( RULE_ID ) )
            {
            // InternalSPVizModel.g:870:2: ( ( RULE_ID ) )
            // InternalSPVizModel.g:871:3: ( RULE_ID )
            {
             before(grammarAccess.getContainmentAccess().getContainsArtifactCrossReference_1_0()); 
            // InternalSPVizModel.g:872:3: ( RULE_ID )
            // InternalSPVizModel.g:873:4: RULE_ID
            {
             before(grammarAccess.getContainmentAccess().getContainsArtifactIDTerminalRuleCall_1_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getContainmentAccess().getContainsArtifactIDTerminalRuleCall_1_0_1()); 

            }

             after(grammarAccess.getContainmentAccess().getContainsArtifactCrossReference_1_0()); 

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
    // $ANTLR end "rule__Containment__ContainsAssignment_1"


    // $ANTLR start "rule__Connection__NameAssignment_0"
    // InternalSPVizModel.g:884:1: rule__Connection__NameAssignment_0 : ( RULE_ID ) ;
    public final void rule__Connection__NameAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:888:1: ( ( RULE_ID ) )
            // InternalSPVizModel.g:889:2: ( RULE_ID )
            {
            // InternalSPVizModel.g:889:2: ( RULE_ID )
            // InternalSPVizModel.g:890:3: RULE_ID
            {
             before(grammarAccess.getConnectionAccess().getNameIDTerminalRuleCall_0_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getConnectionAccess().getNameIDTerminalRuleCall_0_0()); 

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
    // $ANTLR end "rule__Connection__NameAssignment_0"


    // $ANTLR start "rule__Connection__DependsOnAssignment_2"
    // InternalSPVizModel.g:899:1: rule__Connection__DependsOnAssignment_2 : ( ( RULE_ID ) ) ;
    public final void rule__Connection__DependsOnAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalSPVizModel.g:903:1: ( ( ( RULE_ID ) ) )
            // InternalSPVizModel.g:904:2: ( ( RULE_ID ) )
            {
            // InternalSPVizModel.g:904:2: ( ( RULE_ID ) )
            // InternalSPVizModel.g:905:3: ( RULE_ID )
            {
             before(grammarAccess.getConnectionAccess().getDependsOnArtifactCrossReference_2_0()); 
            // InternalSPVizModel.g:906:3: ( RULE_ID )
            // InternalSPVizModel.g:907:4: RULE_ID
            {
             before(grammarAccess.getConnectionAccess().getDependsOnArtifactIDTerminalRuleCall_2_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getConnectionAccess().getDependsOnArtifactIDTerminalRuleCall_2_0_1()); 

            }

             after(grammarAccess.getConnectionAccess().getDependsOnArtifactCrossReference_2_0()); 

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
    // $ANTLR end "rule__Connection__DependsOnAssignment_2"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000004010L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000000012L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x000000000000C010L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000008012L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000000020000L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000000020002L});

}