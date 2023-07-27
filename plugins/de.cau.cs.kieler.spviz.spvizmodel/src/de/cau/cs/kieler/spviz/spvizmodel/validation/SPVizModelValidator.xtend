/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2023 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 */
package de.cau.cs.kieler.spviz.spvizmodel.validation

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Containment
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModelPackage
import org.eclipse.xtext.validation.Check

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class SPVizModelValidator extends AbstractSPVizModelValidator {
    
    // Artifacts are not allowed to contain the same containment more than once.
    @Check
    def checkNoDuplicateContainedArtifacts(Containment containment) {
        val containedArtifact = containment.contains
        val containingArtifact = containment.eContainer as Artifact
        if (containingArtifact.references.filter(Containment).filter[ it.contains === containedArtifact ].size > 1) {
            error('Artifacts cannot contain artifacts multiple times.', containment, SPVizModelPackage.Literals.CONTAINMENT__CONTAINS)
        }
    }
    
    // Artifacts are not allowed to contain themselves.
    @Check
    def checkNoSelfContainment(Containment containment) {
        val containedArtifact = containment.contains
        val containingArtifact = containment.eContainer as Artifact
        if (containedArtifact === containingArtifact) {
            error('Artifacts cannot contain themselves.', containment, SPVizModelPackage.Literals.CONTAINMENT__CONTAINS)
        }
    }
	
}
