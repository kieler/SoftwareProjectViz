/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2022 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import java.util.List
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IProjectDescription
import org.eclipse.core.resources.IWorkspace
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.emf.common.util.BasicMonitor
import org.eclipse.jdt.core.IClasspathEntry
import org.eclipse.jdt.core.IJavaProject
import org.eclipse.jdt.core.JavaCore

/**
 * Generator for Java projects. Configure it with chained configure[...] methods and start with
 * {@link #generate(IProgressMonitor)}.
 * 
 * @author nre
 */
class JavaProjectGenerator {
    
    /** path of the project to be generated */
    val String projectPath
    
    /** The additional required bundles for this new project. */
    val List<String> requiredBundles = newArrayList
    
    /** The exported packages for this new project. */
    val List<String> exportedPackages = newArrayList
    
    /** The subfolder name of the source folder */
    var String sourceFolderName = "src-gen"

    /**
     * Create a new generator.
     */
    new(String projectName) {
        this.projectPath = projectName
    }
    
    /**
     * Adds the given bundles as requirements to be written into the manifest as plug-in dependencies.
     * 
     * @param requiredBundles The IDs of the bundles to be added as dependencies.
     * @return This generator, for chaining configurations.
     */
    def JavaProjectGenerator configureRequiredBundles(Iterable<String> requiredBundles) {
        for (requiredBundle : requiredBundles) {
            if (!this.requiredBundles.contains(requiredBundle)) {
                this.requiredBundles.add(requiredBundle)
            }
        }
        
        return this
    }
    
    /**
     * Adds the given exported packages to be written into the manifest.
     * 
     * @param exportedPackages The IDs of the exported packages.
     * @return This generator, for chaining configurations.
     */
    def JavaProjectGenerator configureExportedPackages(Iterable<String> exportedPackages) {
        for (exportedPackage : exportedPackages) {
            if (!this.exportedPackages.contains(exportedPackage)) {
                this.exportedPackages.add(exportedPackage)
            }
        }
        
        return this
    }
    
    /**
     * Configure the source folder where the files should be generated into. Defaults to "src-gen".
     * 
     * @param sourceFolderName the source folder to generate and configure.
     * @return This generator, for chaining configurations.
     */
    def JavaProjectGenerator configureSourceFolderName(String sourceFolderName) {
        this.sourceFolderName = sourceFolderName
        return this
    }

    /**
     * Starts the generation of this generator and returns the fully generated Java project.
     * 
     * @param progressMonitor The progressMonitor
     * @returns The new Java project that was generated on the file system.
     */
    def IProject generate(IProgressMonitor progressMonitor) {
        val genModelContainerPath = new Path("/" + projectPath + "/" + sourceFolderName)

        // Create the project.
        val IWorkspace workspace = ResourcesPlugin.getWorkspace()
        val IProject project = workspace.getRoot().getProject(projectPath)
        var IProjectDescription projectDescription = null
        
        if (!project.exists()) {
            projectDescription = ResourcesPlugin.getWorkspace().newProjectDescription(projectPath)
            project.create(projectDescription, BasicMonitor.subProgress(progressMonitor, 1))
        } else {
            projectDescription = project.description
        }
        project.open(BasicMonitor.subProgress(progressMonitor, 1))

        // Add the Java and Xtext natures to the project
        var String[] natureIds = projectDescription.getNatureIds()
        if (natureIds === null) {
            natureIds = #[ JavaCore.NATURE_ID, "org.eclipse.xtext.ui.shared.xtextNature" ]
        } else {
            if (!project.hasNature(JavaCore.NATURE_ID)) {
                val oldNatureIds = natureIds
                natureIds = newArrayOfSize(oldNatureIds.length + 1)
                System.arraycopy(oldNatureIds, 0, natureIds, 0, oldNatureIds.length)
                natureIds.set(oldNatureIds.length, JavaCore.NATURE_ID)
            }
            if (!project.hasNature("org.eclipse.xtext.ui.shared.xtextNature")) {
                val oldNatureIds = natureIds
                natureIds = newArrayOfSize(oldNatureIds.length + 1)
                System.arraycopy(oldNatureIds, 0, natureIds, 0, oldNatureIds.length)
                natureIds.set(oldNatureIds.length, "org.eclipse.xtext.ui.shared.xtextNature")
            }
        }
        projectDescription.setNatureIds(natureIds)
        project.setDescription(projectDescription, BasicMonitor.subProgress(progressMonitor, 1));
        
        // Configure the Java project 
        val IJavaProject javaProject = JavaCore.create(project)
        
        val binFolder = project.getFolder("bin")
        if (!binFolder.exists) {
            binFolder.create(false, true, BasicMonitor.subProgress(progressMonitor, 1))
        }
        javaProject.setOutputLocation(binFolder.fullPath, BasicMonitor.subProgress(progressMonitor, 1))
        
        // Configure classpath
        val entries = <IClasspathEntry>newArrayList
        entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.xtend.XTEND_CONTAINER")))
        entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-17")));
        entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.pde.core.requiredPlugins")))
        
        // The source and xtend-gen folders
        val sourceFolder = project.getFolder(sourceFolderName)
        if (!sourceFolder.exists) {
            sourceFolder.create(false, true, BasicMonitor.subProgress(progressMonitor, 1))
        }
        val xtendGenFolder = project.getFolder("xtend-gen")
        if (!xtendGenFolder.exists) {
            xtendGenFolder.create(false, true, BasicMonitor.subProgress(progressMonitor, 1))
        }
        
        val sourceFolderRoot = javaProject.getPackageFragmentRoot(sourceFolder)
        val xtendGenFolderRoot = javaProject.getPackageFragmentRoot(xtendGenFolder)
        entries.add(JavaCore.newSourceEntry(sourceFolderRoot.path))
        entries.add(JavaCore.newSourceEntry(xtendGenFolderRoot.path))
        javaProject.setRawClasspath(entries.toArray(<IClasspathEntry>newArrayOfSize(entries.size)), null)
        
        // Generate the manifest
        FileGenerator.generateFile(project, "/META-INF/MANIFEST.MF",
            FileGenerator.manifestContent(genModelContainerPath.segment(0), requiredBundles, exportedPackages), progressMonitor)
        
        // Generate the build.properties file
        FileGenerator.generateFile(project, "/build.properties",
            FileGenerator.buildPropertiesContent(false), progressMonitor)
        
        return project
    }

}
