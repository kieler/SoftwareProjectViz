/*
 * generated by Xtext 2.22.0
 */
package de.cau.cs.kieler.spviz.spviz.ui;

import com.google.inject.Injector;
import de.cau.cs.kieler.spviz.spviz.ui.internal.SpvizActivator;
import org.eclipse.core.runtime.Platform;
import org.eclipse.xtext.ui.guice.AbstractGuiceAwareExecutableExtensionFactory;
import org.osgi.framework.Bundle;

/**
 * This class was generated. Customizations should only happen in a newly
 * introduced subclass. 
 */
public class SPVizExecutableExtensionFactory extends AbstractGuiceAwareExecutableExtensionFactory {

	@Override
	protected Bundle getBundle() {
		return Platform.getBundle(SpvizActivator.PLUGIN_ID);
	}
	
	@Override
	protected Injector getInjector() {
		SpvizActivator activator = SpvizActivator.getInstance();
		return activator != null ? activator.getInjector(SpvizActivator.DE_CAU_CS_KIELER_SPVIZ_SPVIZ_SPVIZ) : null;
	}

}
