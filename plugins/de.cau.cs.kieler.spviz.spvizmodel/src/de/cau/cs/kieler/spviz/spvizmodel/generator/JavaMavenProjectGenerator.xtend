/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2022-2023 by
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
    
    /** Group ID of the project to be generated. */
    val String groupId
    
    /** Artifact ID and project path of the project to be generated */
    val String artifactId
    
    /** The dependencies for this new project. */
    val List<Dependency> dependencies = newArrayList
    
    /** Additional dependency management to be added to the project pom, as formatted String. */
    var String dependencyManagement = ""
    
    /** The subfolder name of the source folder */
    var String sourceFolderName = "src-gen"
    
    /**
     * The name of the main class to be executed if a shaded jar should be built for this project.
     * See {@code generateShadedJar}.
     */
    var String mainClass
    
    /** Indicates if a shaded jar with all dependencies should be built during the Maven build of this project. */
    var boolean generateShadedJar = false
    
    /** Indicates whether this project contains xtend sources that need to be compiled as well. */
    var boolean xtendSources = false

    /**
     * Create a new generator.
     */
    new(String groupId, String artifactId) {
        this.groupId = groupId
        this.artifactId = artifactId
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
    
    def JavaMavenProjectGenerator configureDependencyManagement(String formattedManagementString) {
        if (formattedManagementString !== null) {
            this.dependencyManagement = formattedManagementString
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
     * Configure the project to also contain Xtend sources. Configures the project to compile and use them from the
     * default "xtend-gen" folder.
     * 
     * @param hasXtendSources If this project should be able to handle Xtend sources.
     * @return This generator, for chaining configurations.
     */
    def JavaMavenProjectGenerator configureXtendSources(boolean hasXtendSources) {
        this.xtendSources = hasXtendSources
        return this
    }
    
    /**
     * Configure the Maven build of this project to also generate a shaded Jar file of this project with all
     * dependencies using maven-shade.
     * 
     * @param doGenerate If this project should generate such a shaded Jar. {@code false} by default.
     * @return This generator, for chaining configurations.
     */
    def JavaMavenProjectGenerator configureGenerateShadedJar(boolean doGenerateShadedJar) {
        this.generateShadedJar = doGenerateShadedJar
        return this
    }
    
    /**
     * Configure the main class to be executed in the generated shaded Jar file. See {@link #configureGenerateShadedJar}.
     * The main class should only be its name, excluding the fully qualified package prefix.
     * 
     * @param mainClass the main class to be configured
     * @return This generator, for chaining configurations.
     */
    def JavaMavenProjectGenerator configureMainClass(String mainClass) {
        this.mainClass = mainClass
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
        val IProject project = workspace.getRoot().getProject(artifactId)
        var IProjectDescription projectDescription = null
        
        if (!project.exists()) {
            projectDescription = ResourcesPlugin.getWorkspace().newProjectDescription(artifactId)
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
        
        // Configure classpath
        val entries = <IClasspathEntry>newArrayList
        entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-11")));
        entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.m2e.MAVEN2_CLASSPATH_CONTAINER")))
        
        // The source folders
        val sourceFolder = project.getFolder(sourceFolderName)
        if (!sourceFolder.exists) {
            sourceFolder.create(false, true, BasicMonitor.subProgress(progressMonitor, 1))
        }
        val sourceFolderRoot = javaProject.getPackageFragmentRoot(sourceFolder)
        entries.add(JavaCore.newSourceEntry(sourceFolderRoot.path))
        
        if (xtendSources) {
            val xtendGenFolder = project.getFolder("xtend-gen")
            if (!xtendGenFolder.exists) {
                xtendGenFolder.create(false, true, BasicMonitor.subProgress(progressMonitor, 1))
            }
            val xtendGenFolderRoot = javaProject.getPackageFragmentRoot(xtendGenFolder)
            entries.add(JavaCore.newSourceEntry(xtendGenFolderRoot.path))
        }
        
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
                   <relativePath>../spviz.build/pom.xml</relativePath>
                </parent>
              
                <modelVersion>4.0.0</modelVersion>
                <groupId>«groupId»</groupId>
                <artifactId>«artifactId»</artifactId>
                <version>0.1.0-SNAPSHOT</version>
            
                «dependencyManagement»
            
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
                        «IF xtendSources»
                            <!-- Compile Xtend code -->
                            <plugin>
                              <groupId>org.eclipse.xtend</groupId>
                              <artifactId>xtend-maven-plugin</artifactId>
                            </plugin>
                        «ENDIF»
                        «IF generateShadedJar»
                            <plugin>
                                <groupId>org.apache.maven.plugins</groupId>
                                <artifactId>maven-shade-plugin</artifactId>
                                <version>3.2.4</version>
                                <configuration>
                                  <transformers>
                                    <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                      <mainClass>«artifactId».«mainClass»</mainClass>
                                    </transformer>
                                    <transformer implementation="org.apache.maven.plugins.shade.resource.AppendingTransformer">
                                      <resource>plugin.properties</resource>
                                    </transformer>
                                    <transformer implementation="org.apache.maven.plugins.shade.resource.ApacheNoticeResourceTransformer">
                                    <addHeader>false</addHeader>
                                    </transformer>
                                    <transformer implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer" />
                                    <transformer implementation="org.apache.maven.plugins.shade.resource.ApacheLicenseResourceTransformer" />
                                  </transformers>
                                  <filters>
                                    <filter>
                                    <artifact>*:*</artifact>
                                    <excludes>
                                      <exclude>**/*._trace</exclude>
                                      <exclude>**/*.ecore</exclude>
                                      <exclude>**/*.g</exclude>
                                      <exclude>**/*.genmodel</exclude>
                                      <exclude>**/*.mwe2</exclude>
                                      <exclude>**/*.xsd</exclude>
                                      <exclude>**/*.xtext</exclude>
                                      <exclude>*.profile</exclude>
                                      <exclude>*.html</exclude>
                                      <exclude>.api_description</exclude>
                                      <exclude>.genmodel</exclude>
                                      <exclude>.options</exclude>
                                      <exclude>about.*</exclude>
                                      <exclude>about_files/*</exclude>
                                      <exclude>fragment.properties</exclude>
                                      <exclude>META-INF/*.inf</exclude>
                                      <exclude>META-INF/*.RSA</exclude>
                                      <exclude>META-INF/*.SF</exclude>
                                      <exclude>META-INF/INDEX.LIST</exclude>
                                      <exclude>META-INF/MANIFEST.MF</exclude>
                                      <exclude>modeling32.png</exclude>
                                      <exclude>OSGI-INF/l10n/bundle.properties</exclude>
                                      <exclude>plugin.xml</exclude>
                                      <exclude>profile.list</exclude>
                                      <exclude>schema/*.exsd</exclude>
                                      <exclude>systembundle.properties</exclude>
                                      <exclude>xtext32.png</exclude>
                                      </excludes>
                                    </filter>
                                    <filter>
                                      <artifact>org.eclipse.platform:*</artifact>
                                      <excludes>
                                        <exclude>**/*.png</exclude>
                                      </excludes>
                                    </filter>
                                  </filters>
                                  <shadedArtifactAttached>true</shadedArtifactAttached>
                                  <minimizeJar>false</minimizeJar>
                                </configuration>
                                <executions>
                                  <execution>
                                    <goals>
                                      <goal>shade</goal>
                                    </goals>
                                  </execution>
                                </executions>
                            </plugin>
                        «ENDIF»
                    </plugins>
                </build>
            </project>
            
        '''
    }
    
    

}
