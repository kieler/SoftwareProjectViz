/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 * 
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz

import com.google.inject.Inject
import de.cau.cs.kieler.spviz.spviz.sPViz.SPViz
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.resource.impl.DefaultResourceDescriptionStrategy
import org.eclipse.xtext.scoping.impl.ImportUriResolver
import org.eclipse.xtext.util.IAcceptor

/**
 * Custom resource description to store information about the imported {@link SPVizModel}.
 * 
 * @see https://blogs.itemis.com/in-5-minuten-zur-dsl-mit-transitiven-importen-in-xtext
 * @author nre
 */
class SPVizResourceDescriptionStrategy extends DefaultResourceDescriptionStrategy {
    public static final String IMPORT = "import"
    @Inject
    ImportUriResolver uriResolver

    override createEObjectDescriptions(EObject eObject, IAcceptor<IEObjectDescription> acceptor) {
        if (eObject instanceof SPViz) {
            this.createEObjectDescriptionForModel(eObject, acceptor)
            return true
        } else {
            super.createEObjectDescriptions(eObject, acceptor)
        }
    }

    def void createEObjectDescriptionForModel(SPViz model, IAcceptor<IEObjectDescription> acceptor) {
        val uri = uriResolver.apply(model)
        val userData = new HashMap<String, String>
        userData.put(IMPORT, uri)
        acceptor.accept(EObjectDescription.create(QualifiedName.create(model.eResource.URI.toString), model, userData))
    }
}
