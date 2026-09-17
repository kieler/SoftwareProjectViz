/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021-2026 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * + and Scheidt & Bachmann System Technik GmbH, 24109 Melsdorf
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import java.io.File
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
    
    /**
     * Adds content after the given match when the check string is missing.
     *
     * @param file The file to update.
     * @param checkString A string to check if the content is already present.
     * @param match The marker after which content is inserted.
     * @param content The content to add.
     */
    def static void addIfMissing(File file, String checkString, String match, String content) {
        addIfMissing(file, checkString, match, content, false)
    }
    
    /**
     * Adds content to an existing file when the given check string is missing.
     * The content is inserted before the match or after it, depending on {@code insertBeforeMatch}.
     *
     * @param file The file to update.
     * @param checkString A string to check if the content is already present.
     * @param match The marker before or after which content is inserted.
     * @param content The content to add.
     * @param insertBeforeMatch Whether to insert before {@code match} instead of after it.
     */
    def static void addIfMissing(File file, String checkString, String match, String content, boolean insertBeforeMatch) {
        if (!file.isFile) {
            throw new IllegalStateException("Cannot update missing file: " + file)
        }
        
        val fileContent = Files.readString(file.toPath)
        if (fileContent.contains(checkString)) {
            return
        }
        
        val matchIndex = fileContent.indexOf(match)
        if (matchIndex < 0) {
            throw new IllegalStateException("Cannot add content to " + file + ": insertion match is missing.")
        }
        
        val insertionIndex = insertBeforeMatch ? matchIndex : matchIndex + match.length
        val updatedContent = fileContent.substring(0, insertionIndex)
            + content
            + fileContent.substring(insertionIndex)
        updateFile(file, updatedContent)
    }
    
    /**
     * Indents the given string by the indentation level.
     * Each level introduces 4 space characters.
     *
     * @param content The string to indent.
     * @param indentationLevel The number of indentation levels to be added.
     * @return A new indented string representing {@code content}.
     */
    def static String indent(String content, int indentationLevel) {
        val indentation = " ".repeat(indentationLevel * 4)
        return indentation + content.replace("\n", "\n" + indentation)
    }
    
}