/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2020-2022 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.validation

import de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactChain
import de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactShows
import de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactSource
import de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactView
import de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage
import de.cau.cs.kieler.spviz.spviz.sPViz.ShownConnection
import de.cau.cs.kieler.spviz.spviz.sPViz.ShownElement
import de.cau.cs.kieler.spviz.spviz.sPViz.View
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Containment
import org.eclipse.xtext.validation.Check

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class SPVizValidator extends AbstractSPVizValidator {
    
    // Views are not allowed to contain the same shown artifact more than once.
    @Check
    def checkNoDuplicateViewShownElements(ShownElement shownElement) {
        if ((shownElement.eContainer as View).shownElements
            .filter[ it.shownElement === shownElement.shownElement ].size > 1) {
            error('Views cannot contain duplicate show entries.', shownElement, SPVizPackage.Literals.SHOWN_ELEMENT__SHOWN_ELEMENT)
        }
    }
    
    // Views are not allowed to contain the same shown connection more than once.
    @Check
    def checkNoDuplicateViewShownConnection(ShownConnection shownConnection) {
        if ((shownConnection.eContainer as View).shownConnections
            .filter[ it.shownConnection === shownConnection.shownConnection].size > 1) {
            error('Views cannot contain duplicate connect entries.', shownConnection, SPVizPackage.Literals.SHOWN_CONNECTION__SHOWN_CONNECTION)
        }
    }
    
    // For each shown connection in a view, the view must also show the artifacts connected by that connection.
    @Check
    def checkViewConnectionsHaveShownElements(ShownConnection shownConnection) {
        val parentView = shownConnection.eContainer as View
        val shownElements = parentView.shownElements.map[shownElement]
        if (!shownElements.contains(shownConnection.shownConnection.connects) ||
            !shownElements.contains(shownConnection.shownConnection.eContainer)) { // the connecting part
            error('Artifacts connected by this connection need to be shown in this view.', shownConnection, SPVizPackage.Literals.SHOWN_CONNECTION__SHOWN_CONNECTION)
        }
    }
    
    // For views within artifacts all shown elements need to be configured.
    @Check
    def checkArtifactViewAllSourcesCovered(ArtifactView artifactView) {
        val shownElements = artifactView.view.shownElements.map[it.shownElement]
        val configuredElements = artifactView.sources.map[it.artifact]
        if (shownElements.size !== configuredElements.size || !configuredElements.containsAll(shownElements)) {
            error('The source for all elements shown in a nested view need to be configured.', artifactView, SPVizPackage.Literals.ARTIFACT_VIEW__VIEW)
        }
    }
    
    // For views within artifacts the source artifact to search from needs to match the showing artifact.
    @Check
    def checkArtifactViewMatchingSource(ArtifactSource artifactSource) {
        val source = (artifactSource.eContainer.eContainer as ArtifactShows).artifactShows
        if (artifactSource.sourceChain.source !== source) {
            error('The configuration for this element needs to start at the same artifact showing its elements', artifactSource.sourceChain, SPVizPackage.Literals.ARTIFACT_CHAIN__SOURCE)
        }
    }
    
    // For views within artifacts the target artifact to search from needs to match the shown artifact.
    @Check
    def checkArtifactViewMatchingTarget(ArtifactSource artifactSource) {
        val target = artifactSource.artifact
        var checkTarget = artifactSource.sourceChain.source
        var next = artifactSource.sourceChain.further
        while (next !== null) {
            checkTarget = next.source
            next = next.further
        }
        if (target !== checkTarget) {
            error('The configuration for this element needs to end at the same artifact that is being configured', artifactSource, SPVizPackage.Literals.ARTIFACT_SOURCE__ARTIFACT)
        }
    }
    
    // For every part in the artifact chain, any next element needs to be a child of the previous artifact.
    @Check
    def checkSourceChainMatchingNext(ArtifactChain chain) {
        val source = chain.source
        val next = chain.further?.source
        if (next !== null && !source.references.filter(Containment).map[ contains ].contains(next)) {
            error('The artifact following in the source chain needs to be contained in this artifact.', chain, SPVizPackage.Literals.ARTIFACT_CHAIN__SOURCE)
        }
    }
}
