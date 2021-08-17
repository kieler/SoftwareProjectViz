/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import java.io.ByteArrayInputStream
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.emf.codegen.util.CodeGenUtil

/**
 * Utility for generating files in Eclipse projects.
 * 
 * @author nre
 */
class FileGenerator {
    
    /**
     * Generates or updates the file with the given content.
     * 
     * @param sourceFolder The Java source folder where all sources need to be placed.
     * @param filePath The relative file path to the file that should be generated or updated.
     * @param fileContent The new file content.
     */
    def static void generateOrUpdateFile(IFolder sourceFolder, String filePath, String fileContent,
        IProgressMonitor progressMonitor) {
        val file = sourceFolder.getFile(filePath);
        val inputStream = new ByteArrayInputStream(fileContent.bytes)
        if (!file.exists) {
            create(file, progressMonitor)
        } 
        file.setContents(inputStream, IResource.NONE, progressMonitor)
    }
    
    /**
     * Generates or updates the file with the given content.
     * 
     * @param sourceProject The project where the file needs to be placed.
     * @param filePath The relative file path to the file that should be generated or updated.
     * @param fileContent The new file content.
     */
    def static void generateOrUpdateFile(IProject sourceProject, String filePath, String fileContent,
        IProgressMonitor progressMonitor) {
        val file = sourceProject.getFile(filePath);
        val inputStream = new ByteArrayInputStream(fileContent.bytes)
        if (!file.exists) {
            create(file, progressMonitor)
        } 
        file.setContents(inputStream, IResource.NONE, progressMonitor)
    }
    
    /**
     * Creates the given resource recursively up, so this resource and any parent folders not yet created are created.
     * 
     * @param resource The resource to create
     * @param progressMonitor The progressMonitor
     */
    def static void create(IResource resource, IProgressMonitor progressMonitor) {
        if (resource === null || resource.exists()) {
            return;
        }
        if (!resource.parent.exists()) {
            create(resource.parent, progressMonitor);
        }
        switch (resource.type) {
            case IResource.FILE: {
                (resource as IFile).create(new ByteArrayInputStream(#[]), false, progressMonitor)
            }
            case IResource.FOLDER: {
                (resource as IFolder).create(IResource.NONE, true, progressMonitor)
            }
        }
    }
    
    /**
     * Generates the content for the MANIFEST.MF file
     * 
     * @param identifier
     *      the fully qualified identifier of the generated bundle.
     * @param requiredBundles
     *      the Bundles this Bundle requires and should be added to the manifest.
     * @return
     *      the generated content for the manifest as a String.
     */
    def static String manifestContent(String identifier, Iterable<String> requiredBundles) {
        return '''
        Manifest-Version: 1.0
        Bundle-ManifestVersion: 2
        Bundle-Name: «identifier»
        Bundle-SymbolicName: «CodeGenUtil.validPluginID(identifier)»; singleton:=true
        Bundle-Version: 0.1.0.qualifier
        Require-Bundle: 
        «FOR requiredBundle : requiredBundles SEPARATOR ','»
            «" " + requiredBundle»
        «ENDFOR»
        '''
    }
    
}