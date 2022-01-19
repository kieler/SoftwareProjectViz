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
import org.eclipse.jdt.core.IClasspathEntry
import org.eclipse.jdt.core.IJavaProject
import org.eclipse.jdt.core.JavaCore

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

        // Add the Xtext nature to the project
        val IProjectDescription projectDescription = project.getDescription();
        var String[] natureIds = projectDescription.getNatureIds();
        if (natureIds === null) {
            natureIds = #[ "org.eclipse.xtext.ui.shared.xtextNature" ]
        } else if (!project.hasNature("org.eclipse.xtext.ui.shared.xtextNature")) {
            val oldNatureIds = natureIds
            natureIds = newArrayOfSize(oldNatureIds.length + 1)
            System.arraycopy(oldNatureIds, 0, natureIds, 0, oldNatureIds.length)
            natureIds.set(oldNatureIds.length, "org.eclipse.xtext.ui.shared.xtextNature")
        }
        projectDescription.setNatureIds(natureIds);
        project.setDescription(projectDescription, progressMonitor);

        // Configure as a Java project with src-gen folder
        val IJavaProject javaProject = JavaCore.create(project);
        val IClasspathEntry[] classpath = javaProject.getRawClasspath();
        if (classpath.findFirst[it.path.lastSegment.toString.equals("src-gen")] === null) {
            val IClasspathEntry[] newClasspath = newArrayOfSize(classpath.length + 1);
            for (var int i = 0, var int index = 0, val int length = newClasspath.length; index < length; i++, index++) {
                newClasspath.set(index, classpath.get(i));
                if (classpath.get(i).getEntryKind() == IClasspathEntry.CPE_SOURCE) {
                    val IPath path = classpath.get(i).getPath();
                    val IPath srcGenPath = path.removeLastSegments(1).append(path.lastSegment() + "-gen");
                    val IClasspathEntry srcGen = JavaCore.newSourceEntry(srcGenPath);
                    CodeGenUtil.EclipseUtil.findOrCreateContainer(srcGenPath, true, genModelProjectLocation,
                        progressMonitor);
                    index++;
                    newClasspath.set(index, srcGen);
                }
            }
            javaProject.setRawClasspath(newClasspath, progressMonitor);
        }

        return project
    }

}
