/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021-2022 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import java.io.ByteArrayInputStream
import java.util.Collections
import java.util.List
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IProjectDescription
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.emf.codegen.ecore.Generator
import org.eclipse.emf.codegen.util.CodeGenUtil

/**
 * Generator for Xcore projects. Configure it with chained configure[...] methods and start with
 * {@link #generate(IProgressMonitor)}.
 * 
 * @author nre
 */
class XCoreProjectGenerator {
    
    /** path of the project to be generated */
    val String projectPath
    
    /** Name of the to-be-generated Xcore file */
    var String xCoreFileName = null
    
    /** Content of the to-be-generated Xcore file */
    var String xCoreFileContent = null
    
    /** The additional required bundles for this new project. */
    val List<String> requiredBundles = newArrayList
    
    /** If this project should have Maven nature. */
    var boolean mavenNature = false

    /**
     * Create a new generator.
     */
    new(String projectName) {
        this.projectPath = projectName
        configureRequiredBundles(#["org.eclipse.emf.ecore", "org.eclipse.xtext.xbase.lib",
            "org.eclipse.emf.ecore.xcore.lib"])
    }
    
    /**
     * Configure the file name and content of the Xcore file in the /model folder of the generated project.
     * 
     * @param fileName The name of the Xcore file
     * @param fileContent The content for that Xcore file.
     * @return This generator, for chaining configurations.
     */
    def XCoreProjectGenerator configureXCoreFile(String fileName, String fileContent) {
        this.xCoreFileName = fileName
        this.xCoreFileContent = fileContent
        
        return this
    }
    
    /**
     * Adds the given bundles as requirements to be written into the manifest as plug-in dependencies.
     * 
     * @param requiredBundles The IDs of the bundles to be added as dependencies.
     * @return This generator, for chaining configurations.
     */
    def XCoreProjectGenerator configureRequiredBundles(Iterable<String> requiredBundles) {
        for (requiredBundle : requiredBundles) {
            if (!this.requiredBundles.contains(requiredBundle)) {
                this.requiredBundles.add(requiredBundle)
            }
        }
        
        return this
    }
    
    /**
     * Configures if this generator should generate this project with Maven nature.
     * 
     * @param mavenNature {@code true} if this should have the Maven nature.
     * @return This generator, for chaining configurations.
     */
    def configureMaven(boolean mavenNature) {
        this.mavenNature = mavenNature
        return this
    }

    /**
     * Starts the generation of this generator and returns the fully generated XCore project.
     * 
     * @param progressMonitor The progressMonitor
     * @returns The new XCore project that was generated on the file system.
     */
    def IProject generate(IProgressMonitor progressMonitor) {
        val genModelContainerPath = new Path("/" + projectPath + "/src")
        val IPath genModelProjectLocation = null

        // Code taken and adapted from the org.eclipse.emf.ecore.xcore.ui.EmptyXcoreProjectWizard and
        // org.eclipse.emf.codegen.ecore.ui.EmptyProjectWizard.
        // Create the project as an EMF project.
        val project = Generator.createEMFProject(new Path(genModelContainerPath.toString()), genModelProjectLocation,
            Collections.<IProject>emptyList(), progressMonitor,
            Generator.EMF_MODEL_PROJECT_STYLE.bitwiseOr(Generator.EMF_PLUGIN_PROJECT_STYLE))

        // Create the /model folder
        val IFolder modelContainer = CodeGenUtil.EclipseUtil.findOrCreateContainer(
            new Path("/" + genModelContainerPath.segment(0) + "/model"), true, genModelProjectLocation,
            progressMonitor) as IFolder;
            
        // Create/Update the Xcore file in the project.
        val xcoreFile = modelContainer.getFile(xCoreFileName)
        val inputStream = new ByteArrayInputStream(xCoreFileContent.bytes)
        if (xcoreFile.exists) {
            xcoreFile.setContents(inputStream, IResource.NONE, progressMonitor)
        } else {
            xcoreFile.create(inputStream, IResource.NONE, progressMonitor)
        }
        
        // Generate the manifest
        FileGenerator.generateOrUpdateFile(project, "/META-INF/MANIFEST.MF",
            FileGenerator.manifestContent(genModelContainerPath.segment(0), requiredBundles), progressMonitor)

        // Add the Xtext nature and possibly Maven nature to the project
        val IProjectDescription projectDescription = project.getDescription();
        var String[] natureIds = projectDescription.getNatureIds();
        if (natureIds === null) {
            natureIds = #[ "org.eclipse.xtext.ui.shared.xtextNature" ]

            if (mavenNature) {
                val oldNatureIds = natureIds
                natureIds = newArrayOfSize(oldNatureIds.length + 1)
                System.arraycopy(oldNatureIds, 0, natureIds, 0, oldNatureIds.length)
                natureIds.set(oldNatureIds.length, "org.eclipse.m2e.core.maven2Nature")
            }
        } else {
            // Add the Xtext nature to the project
            if (!project.hasNature("org.eclipse.xtext.ui.shared.xtextNature")) {
                val oldNatureIds = natureIds
                natureIds = newArrayOfSize(oldNatureIds.length + 1)
                System.arraycopy(oldNatureIds, 0, natureIds, 0, oldNatureIds.length)
                natureIds.set(oldNatureIds.length, "org.eclipse.xtext.ui.shared.xtextNature")
            }
            // Add the Maven nature to the project
            if (mavenNature && !project.hasNature("org.eclipse.m2e.core.maven2Nature")) {
                val oldNatureIds = natureIds
                natureIds = newArrayOfSize(oldNatureIds.length + 1)
                System.arraycopy(oldNatureIds, 0, natureIds, 0, oldNatureIds.length)
                natureIds.set(oldNatureIds.length, "org.eclipse.m2e.core.maven2Nature")
            }
        }
        projectDescription.setNatureIds(natureIds);
        project.setDescription(projectDescription, progressMonitor);

        return project
    }

}
