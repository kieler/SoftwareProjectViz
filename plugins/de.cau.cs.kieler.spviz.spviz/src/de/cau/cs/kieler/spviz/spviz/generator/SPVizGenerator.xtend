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
package de.cau.cs.kieler.spviz.spviz.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SPVizGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
        println("Generate visualization for " + resource.contents.head?.class)
        
        // TODO: generate an xcore model to define the visualization context model akin to osgiviz.
        // TODO: generate a visualization context model project from this xcore file and build it.
        // Template files that are then filled with data from here are probably the way to go.
        // TODO: generate a visualization project based on the model project and the visualization context project.
        // Start with a shallow cut through this to get a visualization going, work on details and more functionality
        // later.
	}
}
