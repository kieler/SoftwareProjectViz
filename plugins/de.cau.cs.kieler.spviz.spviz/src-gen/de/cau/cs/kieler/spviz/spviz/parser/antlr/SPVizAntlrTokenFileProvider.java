/*
 * generated by Xtext 2.22.0
 */
package de.cau.cs.kieler.spviz.spviz.parser.antlr;

import java.io.InputStream;
import org.eclipse.xtext.parser.antlr.IAntlrTokenFileProvider;

public class SPVizAntlrTokenFileProvider implements IAntlrTokenFileProvider {

	@Override
	public InputStream getAntlrTokenFile() {
		ClassLoader classLoader = getClass().getClassLoader();
		return classLoader.getResourceAsStream("de/cau/cs/kieler/spviz/spviz/parser/antlr/internal/InternalSPViz.tokens");
	}
}
