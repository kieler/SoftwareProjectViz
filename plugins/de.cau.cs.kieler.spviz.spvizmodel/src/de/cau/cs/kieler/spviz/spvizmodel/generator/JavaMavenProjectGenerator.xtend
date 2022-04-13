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

import de.cau.cs.kieler.spviz.spvizmodel.generator.maven.Dependency
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
import org.eclipse.m2e.core.internal.IMavenConstants

/**
 * Generator for Java projects using Maven dependencies. Configure it with chained configure[...] methods and start with
 * {@link #generate(IProgressMonitor)}.
 * 
 * @author nre
 */
class JavaMavenProjectGenerator {
    
    /** path of the project to be generated */
    val String projectPath
    
    /** The dependencies for this new project. */
    val List<Dependency> dependencies = newArrayList
    
    /** The subfolder name of the source folder */
    var String sourceFolderName = "src-gen"

    /**
     * Create a new generator.
     */
    new(String projectName) {
        this.projectPath = projectName
    }
    
    /**
     * Adds the given dependencies to be written into the pom.xml.
     * 
     * @param dependencies The dependencies to be added.
     * @return This generator, for chaining configurations.
     */
    def JavaMavenProjectGenerator configureDependencies(Iterable<Dependency> dependencies) {
        for (requiredBundle : dependencies) {
            if (!this.dependencies.contains(requiredBundle)) {
                this.dependencies.add(requiredBundle)
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
    def JavaMavenProjectGenerator configureSourceFolderName(String sourceFolderName) {
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

        // Add the Java nature to the project
        var String[] natureIds = projectDescription.getNatureIds()
        if (natureIds === null) {
            natureIds = #[ JavaCore.NATURE_ID, IMavenConstants.NATURE_ID ]
        } else {
            if (!project.hasNature(JavaCore.NATURE_ID)) {
                val oldNatureIds = natureIds
                natureIds = newArrayOfSize(oldNatureIds.length + 1)
                System.arraycopy(oldNatureIds, 0, natureIds, 0, oldNatureIds.length)
                natureIds.set(oldNatureIds.length, JavaCore.NATURE_ID)
            }
            if (!project.hasNature(IMavenConstants.NATURE_ID)) {
                val oldNatureIds = natureIds
                natureIds = newArrayOfSize(oldNatureIds.length + 1)
                System.arraycopy(oldNatureIds, 0, natureIds, 0, oldNatureIds.length)
                natureIds.set(oldNatureIds.length, IMavenConstants.NATURE_ID)
            }
        }
        projectDescription.setNatureIds(natureIds)
        project.setDescription(projectDescription, BasicMonitor.subProgress(progressMonitor, 1));
        
        // Configure the Java project 
        val IJavaProject javaProject = JavaCore.create(project)
        
        val targetFolder = project.getFolder("target")
        if (!targetFolder.exists) {
            targetFolder.create(false, true, BasicMonitor.subProgress(progressMonitor, 1))
        }
        javaProject.setOutputLocation(targetFolder.fullPath, BasicMonitor.subProgress(progressMonitor, 1))
        
        // Configure classpath
        val entries = <IClasspathEntry>newArrayList
        entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-11")));
        entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.m2e.MAVEN2_CLASSPATH_CONTAINER")))
        
        // The source folder
        val sourceFolder = project.getFolder(sourceFolderName)
        if (!sourceFolder.exists) {
            sourceFolder.create(false, true, BasicMonitor.subProgress(progressMonitor, 1))
        }
        
        val sourceFolderRoot = javaProject.getPackageFragmentRoot(sourceFolder)
        entries.add(JavaCore.newSourceEntry(sourceFolderRoot.path))
        javaProject.setRawClasspath(entries.toArray(<IClasspathEntry>newArrayOfSize(entries.size)), null)
        
        // Generate the pom.xml file
        FileGenerator.generateFile(project, "/pom.xml", pomXmlContent, progressMonitor)
        
        return project
    }
    
    private def getPomXmlContent() {
        return '''
            <project xmlns="http://maven.apache.org/POM/4.0.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
                
                <parent>
                   <groupId>de.cau.cs.kieler.spviz</groupId>
                   <artifactId>parent</artifactId>
                   <version>0.1.0-SNAPSHOT</version>
                </parent>
              
                <modelVersion>4.0.0</modelVersion>
                <groupId>de.cau.cs.kieler.spviz.gradle.generate</groupId>
                <artifactId>de.cau.cs.kieler.spviz.gradle.generate</artifactId>
                <version>0.0.1-SNAPSHOT</version>
            
                <dependencies>
                    «FOR dependency : dependencies»
                        «dependency.toPom»
                    «ENDFOR»
                </dependencies>
            
                <build>
                    <sourceDirectory>«sourceFolderName»</sourceDirectory>
                    <resources>
                        <resource>
                            <directory>«sourceFolderName»</directory>
                            <excludes>
                                <exclude>**/*.java</exclude>
                            </excludes>
                        </resource>
                    </resources>
                    <plugins>
                        <plugin>
                            <artifactId>maven-compiler-plugin</artifactId>
                            <version>3.10.0</version>
                            <configuration>
                                <source>11</source>
                                <target>11</target>
                            </configuration>
                        </plugin>
                        <plugin>
                            <groupId>org.apache.maven.plugins</groupId>
                            <artifactId>maven-shade-plugin</artifactId>
                            <version>3.2.4</version>
                            <executions>
                                <execution>
                                    <phase>package</phase>
                                    <goals>
                                    <goal>shade</goal>
                                    </goals>
                                    <configuration>
                                        <transformers>
                                            <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                                <mainClass>«projectPath».ConfigAndExecuteCli</mainClass>
                                            </transformer>
                                        </transformers>
                                        <filters>
                                            <filter>
                                            <artifact>*:*</artifact>
                                            <excludes>
                                                <exclude>META-INF/*.SF</exclude>
                                                <exclude>META-INF/*.DSA</exclude>
                                                <exclude>META-INF/*.RSA</exclude>
                                                <exclude>META-INF/MANIFEST.MF</exclude>
                                                <exclude>schema/*.exsd</exclude>
                                                <exclude>about.*</exclude>
                                                <exclude>modeling32.png</exclude>
                                                <exclude>plugin.*</exclude>
                                            </excludes>
                                            </filter>
                                        </filters>
                                        <createDependencyReducedPom>false</createDependencyReducedPom>
                                    </configuration>
                                </execution>
                            </executions>
                        </plugin>
                    </plugins>
                </build>
            </project>
            
        '''
    }
    
    

}
