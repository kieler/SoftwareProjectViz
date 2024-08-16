/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021-2024 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import java.io.File
import java.io.InputStream
import java.nio.file.Files
import java.nio.file.Paths

/**
 * Utility for generating files in Eclipse projects.
 * 
 * @author nre
 */
class FileGenerator {
    
    /**
     * Updates the file with the given content. Generates it first if it does not exist yet.
     * 
     * @param base The directory to write to.
     * @param fileName the name of the file.
     * @param fileContent The content to write to the file.
     */
    def static void updateFile(File base, String fileName, String fileContent) {
        generateOrUpdateFile(base, fileName, fileContent, true)
    }
    
    /**
     * Updates the file with the given content. Generates it first if it does not exist yet.
     * 
     * @param file The file to write to.
     * @param fileContent The content to write to the file.
     */
    def static void updateFile(File file, String fileContent) {
        generateOrUpdateFile(file, fileContent, true)
    }
    
    /**
     * Generates the file with the given content. Does not update the file if it already exists.
     * 
     * @param base The directory to write to.
     * @param fileName the name of the file.
     * @param fileContent The content to write to the file.
     */
    def static void generateFile(File base, String fileName, String fileContent) {
        generateOrUpdateFile(base, fileName, fileContent, false)
    }
    
    /**
     * Generates the file with the given content. Does not update the file if it already exists.
     * 
     * @param file The file to write to.
     * @param fileContent The content to write to the file.
     */
    def static void generateFile(File file, String fileContent) {
        generateOrUpdateFile(file, fileContent, false)
    }
    
    /**
     * Generates or updates the file with the given content.
     * 
     * @param base The directory to write to.
     * @param fileName the name of the file.
     * @param fileContent The content to write to the file.
     * @param force If existing content should be overwritten.
     */
    def static void generateOrUpdateFile(File base, String fileName, String fileContent, boolean force) {
        generateOrUpdateFile(new File(base, fileName), fileContent, force)
    }
    
    /**
     * Generates or updates the file with the given content.
     * 
     * @param file The file to write to.
     * @param fileContent The content to write to the file.
     * @param force If existing content should be overwritten.
     */
    def static void generateOrUpdateFile(File file, String fileContent, boolean force) {
        // Only overwrite the file if `force` is true.
        if (file.exists && !force) {
            return
        }
        Files.write(Paths.get(file.path), fileContent.bytes)
    }
    
    /**
     * Copies the files at the source location to the target folder.
     * 
     * @param sourceFolder The folder to copy the files from.
     * @param targetFolder The folder to copy the files to.
     */
    def static void copyIcons(File targetFolder) {
        targetFolder.mkdirs
        // The file path is searched on the classpath directly
        // TODO: this has to be tested.
        val fileNames = #["connect.svg", "connect128.png",
            "expand.svg", "expand128.png",
            "loupe.svg", "loupe128.png",
            "loupe-crossed.svg", "loupe-crossed128.png",
            "minimize.svg", "minimize128.png",
            "restore.svg", "restore128.png"]
        for (fileName : fileNames) {
            val InputStream source = FileGenerator.classLoader.getResourceAsStream("icons/" + fileName)
            val newFile = new File(targetFolder, fileName)
            if (!newFile.exists) {
                Files.copy(source, newFile.toPath)
            }
        }
    }

    /**
     * Creates a directory under the given filePath.
     * 
     * @param filePath the path to the directory
     * @return The file object for that directory.
     */
    def static File createDirectory(String filePath) {
        val directory = new File(filePath)
        directory.mkdirs
        return directory
    }
    
    /**
     * Creates a directory under the given filePath based on the given base.
     * 
     * @param base the base path where to create this directory.
     * @param filePath the path to the directory
     * @return The file object for that directory.
     */
    def static File createDirectory(File base, String path) {
        val File directory = new File(base, path)
        directory.mkdirs
        return directory
    }
    
}