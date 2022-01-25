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
import java.io.File
import java.io.InputStream
import java.nio.file.Files
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Platform
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
     * Copies the files at the source location to the target folder.
     * 
     * @param sourceBundle The bundle containing the folder to copy the files from.
     * @param sourceFolder The sub-folder ini the bundle to copy from.
     * @param targetFolder The folder to copy the files to.
     */
    def static void copyFiles(String sourceBundle, String sourceFolder, IFolder targetFolder,
        IProgressMonitor progressMonitor) {
        if (!targetFolder.exists) {
            targetFolder.create(progressMonitor)
        }
        if (Platform.isRunning()) {
            // If the platform is running, the folder can be found in the bundle under the resource path.
            val url = Platform.getBundle(sourceBundle)
                ?.getEntry(sourceFolder)
            val folder = new File(FileLocator.toFileURL(url).toURI.path)
            for (file : folder.listFiles) {
                val fileName = file.name
                val newFile = new File(targetFolder.rawLocation.toString + "/" + fileName)
                if (!newFile.exists) {
                    Files.copy(file.toPath, newFile.toPath)
                }
            }
            
            
        } else {
            // In the jar or plain Java application case, the bundle is ignored and the file path
            // is searched on the classpath directly
            val fileNames = #["icons/connect.svg", "icons/connect128.png",
                "icons/expand.svg", "icons/expand128.png",
                "icons/loupe.svg", "icons/loupe128.png",
                "icons/minimize.svg", "icons/minimize128.png",
                "icons/restore.svg", "icons/restore128.png"]
            // TODO: this has to be tested from a standalone application.
            for (fileName : fileNames) {
                val InputStream source = FileGenerator.getResourceAsStream("/" + sourceFolder + "/" + fileName)
                val newFile = new File(targetFolder.rawLocation.toString + "/" + fileName)
                if (!newFile.exists) {
                    Files.copy(source, newFile.toPath)
                }
            }
        }
        
        
        
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
        Automatic-Module-Name: «CodeGenUtil.validPluginID(identifier)»
        Bundle-Name: «identifier»
        Bundle-SymbolicName: «CodeGenUtil.validPluginID(identifier)»; singleton:=true
        Bundle-Version: 0.1.0.qualifier
        Bundle-RequiredExecutionEnvironment: JavaSE-11
        Require-Bundle: 
        «FOR requiredBundle : requiredBundles SEPARATOR ','»
            «" " + requiredBundle»
        «ENDFOR»
        '''
    }
    
    def static String buildPropertiesContent(boolean isViz) {
        return '''
            source.. = src/,\
                       xtend-gen/
            bin.includes = META-INF/,\
                           «IF isViz»
                               .,\
                               plugin.xml,\
                               icons/
                           «ELSE»
                               .
                           «ENDIF»
            
        '''
    }
    
    def static modelBuildPropertiesContent() {
        return '''
            bin.includes = .,\
                           model/,\
                           META-INF/,\
                           plugin.xml,\
                           plugin.properties
            jars.compile.order = .
            source.. = src/,\
                       xtend-gen/
            output.. = bin/
            
        '''
    }
    
}