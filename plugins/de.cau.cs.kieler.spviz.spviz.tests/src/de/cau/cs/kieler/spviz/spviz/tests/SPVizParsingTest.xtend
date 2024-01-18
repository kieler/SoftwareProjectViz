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
package de.cau.cs.kieler.spviz.spviz.tests

import com.google.inject.Inject
import de.cau.cs.kieler.spviz.spviz.sPViz.SPViz
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

@ExtendWith(InjectionExtension)
@InjectWith(SPVizInjectorProvider)
class SPVizParsingTest {
    @Inject
    ParseHelper<SPViz> parseHelper
    
    @Test
    def void loadModel() {
        val result = parseHelper.parse('''
            package de.cau.cs.kieler.spviz.osgiviz
            import "osgi.spvizmodel"
            
            SPViz OSGiViz {
                Services {
                    show OSGi.ServiceInterface
                    show OSGi.ServiceComponent
                    connect OSGi.ServiceComponent.Required
                    connect OSGi.ServiceInterface.ProvidedBy
                }
                BundleServices {
                    show OSGi.Bundle
                    
                    connect OSGi.ServiceComponent.Required via OSGi.Bundle in Services
                    connect OSGi.ServiceInterface.ProvidedBy via OSGi.Bundle in Services
                }
                BundleDependencies {
                    show OSGi.Bundle
                    connect OSGi.Bundle.Dependency
                }
                Products {
                    show OSGi.Product
                }
                Features {
                    show OSGi.Feature
                    connect OSGi.Bundle.Dependency via OSGi.Feature in BundleDependencies
                    // connect Feature to Feature via source Feature>Bundle and target Feature>Bundle >Dep
                }
                
                OSGi.Product shows {
                    Services with {
                        OSGi.ServiceInterface from OSGi.Product>OSGi.Bundle>OSGi.ServiceInterface
                        OSGi.ServiceComponent from OSGi.Product>OSGi.Bundle>OSGi.ServiceComponent
                    }
                    BundleDependencies with {
                        OSGi.Bundle from OSGi.Product>OSGi.Bundle
                    }
                }
                
                OSGi.Feature shows {
                    BundleDependencies with {
                        OSGi.Bundle from OSGi.Feature>OSGi.Bundle
                    }
                }
                
                OSGi.Bundle shows {
                    Services with {
                        OSGi.ServiceInterface from OSGi.Bundle>OSGi.ServiceInterface
                        OSGi.ServiceComponent from OSGi.Bundle>OSGi.ServiceComponent
                    }
                }
            }
        ''')
        Assertions.assertNotNull(result)
        val errors = result.eResource.errors
        Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
    }
}
