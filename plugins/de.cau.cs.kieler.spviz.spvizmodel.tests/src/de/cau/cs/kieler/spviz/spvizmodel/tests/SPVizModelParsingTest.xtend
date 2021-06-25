/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.tests

import com.google.inject.Inject
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

@ExtendWith(InjectionExtension)
@InjectWith(SPVizModelInjectorProvider)
class SPVizModelParsingTest {
	@Inject
	ParseHelper<SPVizModel> parseHelper
	
	@Test
	def void loadModel() {
		val result = parseHelper.parse('''
			package de.cau.cs.kieler.osgi
			SPVizModel OSGi { 
			    Product {
			        contains Feature
			        contains Bundle
			    }
			    Feature
			    Bundle {
			        Dependency connects Bundle
			        PackageDependency connects Package
			        contains ServiceInterface
			        contains ServiceComponent
			    }
			    ServiceInterface
			    ServiceComponent {
			        Required connects ServiceInterface
			        Provided connects ServiceInterface
			    }
			    Package
			}
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
}
