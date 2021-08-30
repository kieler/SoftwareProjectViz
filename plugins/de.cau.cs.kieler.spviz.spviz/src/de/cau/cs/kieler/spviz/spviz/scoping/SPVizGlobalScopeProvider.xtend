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
package de.cau.cs.kieler.spviz.spviz.scoping

import com.google.inject.Inject
import com.google.inject.Provider
import de.cau.cs.kieler.spviz.spviz.SPVizResourceDescriptionStrategy
import de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import java.util.LinkedHashSet
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.resource.IResourceDescription
import org.eclipse.xtext.scoping.impl.ImportUriGlobalScopeProvider
import org.eclipse.xtext.util.IResourceScopeCache

/**
 * Only scopes the imported {@link SPVizModel} of all possibly available models
 * 
 * @see https://blogs.itemis.com/in-5-minuten-zur-dsl-mit-transitiven-importen-in-xtext
 * @author nre
 */
class SPVizGlobalScopeProvider extends ImportUriGlobalScopeProvider {
    @Inject
    IResourceDescription.Manager descriptionManager;

    @Inject
    IResourceScopeCache cache;

    override protected getImportedUris(Resource resource) {
        return cache.get(SPVizScopeProvider.getSimpleName(), resource, new Provider<LinkedHashSet<URI>>() {
            override get() {
                val uniqueImportURIs = collectImportUris(resource, new LinkedHashSet<URI>(5))

                val uriIter = uniqueImportURIs.iterator()
                while (uriIter.hasNext()) {
                    if (!EcoreUtil2.isValidUri(resource, uriIter.next()))
                        uriIter.remove()
                }
                return uniqueImportURIs
            }

            def LinkedHashSet<URI> collectImportUris(Resource resource, LinkedHashSet<URI> uniqueImportURIs) {
                val resourceDescription = descriptionManager.getResourceDescription(resource)
                val models = resourceDescription.getExportedObjectsByType(SPVizPackage.Literals.SP_VIZ)
                
                models.forEach[
                    val uri = getUserData(SPVizResourceDescriptionStrategy.IMPORT)
                    if (uri !== null) {
                        var includedUri = URI.createURI(uri)
                        includedUri = includedUri.resolve(resource.URI)
                        if (uniqueImportURIs.add(includedUri)) {
                            collectImportUris(resource.getResourceSet().getResource(includedUri, true), uniqueImportURIs)
                        }
                    }
                ]
                
                return uniqueImportURIs
            }
        });
    }
}