/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2026 by
 * + Scheidt & Bachmann System Technik GmbH, 24109 Melsdorf
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import java.io.File

/**
 * Generates the {@code .gitignore} files used by projects created by SPViz.
 * Existing {@code .gitignore} files are left unchanged.
 */
class GeneratedProjectGitIgnore {
    
    /**
     * Generates a {@code .gitignore} that ignores every file in the project.
     *
     * @param projectDirectory the generated project directory
     */
    static def void generated(File projectDirectory) {
        FileGenerator.generateFile(projectDirectory, ".gitignore", '''
            /*
        ''')
    }
    
    /**
     * Generates a {@code .gitignore} for the visualization project.
     * The project is ignored by default, with its custom source files and the style service declaration retained.
     *
     * @param projectDirectory the generated visualization project directory
     * @param packageName the base package name
     */
    static def void visualization(File projectDirectory, String packageName) {
        FileGenerator.generateFile(projectDirectory, ".gitignore", '''
            /*
            !/src/
            !/META-INF/
            /META-INF/*
            !/META-INF/services/
            /META-INF/services/*
            !/META-INF/services/«packageName».viz.Styles
        ''')
    }
    
    /**
     * Generates a {@code .gitignore} for a model generator project, excluding only build files.
     *
     * @param projectDirectory the generated model generator project directory
     */
    static def void generator(File projectDirectory) {
        FileGenerator.generateFile(projectDirectory, ".gitignore", '''
            /bin/
            /target/
            /xtend-gen/
            /test-bin/
            /dependencies.txt
        ''')
    }
    
    /**
     * Generates catch-all {@code .gitignore} files for the generated Xtext projects associated with the given base name.
     *
     * @param rootDirectory the directory containing the Xtext projects
     * @param baseName the base project name of the Xtext project
     */
    static def void xtextProjects(File rootDirectory, String baseName) {
        for (suffix : #["", ".ide", ".parent", ".target", ".ui"]) {
            val projectDirectory = new File(rootDirectory, baseName + suffix)
            if (projectDirectory.isDirectory) {
                generated(projectDirectory)
            }
        }
    }
}
