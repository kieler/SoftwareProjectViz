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
    
    /** {@code .gitignore} content for automatically generated projects. */
    public static val String GENERATED = '''
        /*
    '''
    
    /** {@code .gitignore} content for project model generator projects. */
    public static val String GENERATOR = '''
        /bin/
        /target/
        /xtend-gen/
        /test-bin/
        /dependencies.txt
    '''
    
    /**
     * Generates a {@code .gitignore} that ignores every file in the project.
     *
     * @param projectDirectory the generated project directory
     */
    static def void generated(File projectDirectory) {
        FileGenerator.generateFile(projectDirectory, ".gitignore", GENERATED)
    }
    
    /**
     * Returns the {@code .gitignore} content for the visualization project.
     * The project is ignored by default, with its custom source files and the style service declaration retained.
     *
     * @param packageName the base package name
     */
    static def String visualizationContent(String packageName) {
        return '''
            /*
            !/src/
            !/META-INF/
            /META-INF/*
            !/META-INF/services/
            /META-INF/services/*
            !/META-INF/services/«packageName».viz.Styles
        '''
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
