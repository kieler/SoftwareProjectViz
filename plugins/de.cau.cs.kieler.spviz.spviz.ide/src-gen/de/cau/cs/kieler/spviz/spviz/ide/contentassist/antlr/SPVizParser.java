/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2022 by
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
package de.cau.cs.kieler.spviz.spviz.ide.contentassist.antlr;

import com.google.common.collect.ImmutableMap;
import com.google.inject.Inject;
import com.google.inject.Singleton;
import de.cau.cs.kieler.spviz.spviz.ide.contentassist.antlr.internal.InternalSPVizParser;
import de.cau.cs.kieler.spviz.spviz.services.SPVizGrammarAccess;
import java.util.Map;
import org.eclipse.xtext.AbstractElement;
import org.eclipse.xtext.ide.editor.contentassist.antlr.AbstractContentAssistParser;

public class SPVizParser extends AbstractContentAssistParser {

	@Singleton
	public static final class NameMappings {
		
		private final Map<AbstractElement, String> mappings;
		
		@Inject
		public NameMappings(SPVizGrammarAccess grammarAccess) {
			ImmutableMap.Builder<AbstractElement, String> builder = ImmutableMap.builder();
			init(builder, grammarAccess);
			this.mappings = builder.build();
		}
		
		public String getRuleName(AbstractElement element) {
			return mappings.get(element);
		}
		
		private static void init(ImmutableMap.Builder<AbstractElement, String> builder, SPVizGrammarAccess grammarAccess) {
			builder.put(grammarAccess.getSPVizAccess().getGroup(), "rule__SPViz__Group__0");
			builder.put(grammarAccess.getViewAccess().getGroup(), "rule__View__Group__0");
			builder.put(grammarAccess.getArtifactShowsAccess().getGroup(), "rule__ArtifactShows__Group__0");
			builder.put(grammarAccess.getArtifactViewAccess().getGroup(), "rule__ArtifactView__Group__0");
			builder.put(grammarAccess.getArtifactSourceAccess().getGroup(), "rule__ArtifactSource__Group__0");
			builder.put(grammarAccess.getArtifactChainAccess().getGroup(), "rule__ArtifactChain__Group__0");
			builder.put(grammarAccess.getArtifactChainAccess().getGroup_1(), "rule__ArtifactChain__Group_1__0");
			builder.put(grammarAccess.getShownElementAccess().getGroup(), "rule__ShownElement__Group__0");
			builder.put(grammarAccess.getShownElementAccess().getGroup_2(), "rule__ShownElement__Group_2__0");
			builder.put(grammarAccess.getShownConnectionAccess().getGroup(), "rule__ShownConnection__Group__0");
			builder.put(grammarAccess.getShownConnectionAccess().getGroup_2(), "rule__ShownConnection__Group_2__0");
			builder.put(grammarAccess.getQualifiedNameAccess().getGroup(), "rule__QualifiedName__Group__0");
			builder.put(grammarAccess.getQualifiedNameAccess().getGroup_1(), "rule__QualifiedName__Group_1__0");
			builder.put(grammarAccess.getSPVizAccess().getPackageAssignment_1(), "rule__SPViz__PackageAssignment_1");
			builder.put(grammarAccess.getSPVizAccess().getImportURIAssignment_3(), "rule__SPViz__ImportURIAssignment_3");
			builder.put(grammarAccess.getSPVizAccess().getNameAssignment_5(), "rule__SPViz__NameAssignment_5");
			builder.put(grammarAccess.getSPVizAccess().getViewsAssignment_7(), "rule__SPViz__ViewsAssignment_7");
			builder.put(grammarAccess.getSPVizAccess().getArtifactShowsAssignment_8(), "rule__SPViz__ArtifactShowsAssignment_8");
			builder.put(grammarAccess.getViewAccess().getNameAssignment_0(), "rule__View__NameAssignment_0");
			builder.put(grammarAccess.getViewAccess().getShownElementsAssignment_2(), "rule__View__ShownElementsAssignment_2");
			builder.put(grammarAccess.getViewAccess().getShownConnectionsAssignment_3(), "rule__View__ShownConnectionsAssignment_3");
			builder.put(grammarAccess.getArtifactShowsAccess().getArtifactShowsAssignment_0(), "rule__ArtifactShows__ArtifactShowsAssignment_0");
			builder.put(grammarAccess.getArtifactShowsAccess().getViewsAssignment_3(), "rule__ArtifactShows__ViewsAssignment_3");
			builder.put(grammarAccess.getArtifactViewAccess().getViewAssignment_0(), "rule__ArtifactView__ViewAssignment_0");
			builder.put(grammarAccess.getArtifactViewAccess().getSourcesAssignment_3(), "rule__ArtifactView__SourcesAssignment_3");
			builder.put(grammarAccess.getArtifactSourceAccess().getArtifactAssignment_0(), "rule__ArtifactSource__ArtifactAssignment_0");
			builder.put(grammarAccess.getArtifactSourceAccess().getSourceChainAssignment_2(), "rule__ArtifactSource__SourceChainAssignment_2");
			builder.put(grammarAccess.getArtifactChainAccess().getSourceAssignment_0(), "rule__ArtifactChain__SourceAssignment_0");
			builder.put(grammarAccess.getArtifactChainAccess().getFurtherAssignment_1_1(), "rule__ArtifactChain__FurtherAssignment_1_1");
			builder.put(grammarAccess.getShownElementAccess().getShownElementAssignment_1(), "rule__ShownElement__ShownElementAssignment_1");
			builder.put(grammarAccess.getShownElementAccess().getContainedInAssignment_2_1(), "rule__ShownElement__ContainedInAssignment_2_1");
			builder.put(grammarAccess.getShownConnectionAccess().getShownConnectionAssignment_1(), "rule__ShownConnection__ShownConnectionAssignment_1");
			builder.put(grammarAccess.getShownConnectionAccess().getViaAssignment_2_1(), "rule__ShownConnection__ViaAssignment_2_1");
		}
	}
	
	@Inject
	private NameMappings nameMappings;

	@Inject
	private SPVizGrammarAccess grammarAccess;

	@Override
	protected InternalSPVizParser createParser() {
		InternalSPVizParser result = new InternalSPVizParser(null);
		result.setGrammarAccess(grammarAccess);
		return result;
	}

	@Override
	protected String getRuleName(AbstractElement element) {
		return nameMappings.getRuleName(element);
	}

	@Override
	protected String[] getInitialHiddenTokens() {
		return new String[] { "RULE_WS", "RULE_ML_COMMENT", "RULE_SL_COMMENT" };
	}

	public SPVizGrammarAccess getGrammarAccess() {
		return this.grammarAccess;
	}

	public void setGrammarAccess(SPVizGrammarAccess grammarAccess) {
		this.grammarAccess = grammarAccess;
	}
	
	public NameMappings getNameMappings() {
		return nameMappings;
	}
	
	public void setNameMappings(NameMappings nameMappings) {
		this.nameMappings = nameMappings;
	}
}
