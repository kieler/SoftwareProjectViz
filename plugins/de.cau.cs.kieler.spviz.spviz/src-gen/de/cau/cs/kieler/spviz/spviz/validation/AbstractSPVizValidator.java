/*
 * generated by Xtext 2.22.0
 */
package de.cau.cs.kieler.spviz.spviz.validation;

import java.util.ArrayList;
import java.util.List;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.xtext.validation.AbstractDeclarativeValidator;

public abstract class AbstractSPVizValidator extends AbstractDeclarativeValidator {
	
	@Override
	protected List<EPackage> getEPackages() {
		List<EPackage> result = new ArrayList<EPackage>();
		result.add(de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage.eINSTANCE);
		return result;
	}
}
