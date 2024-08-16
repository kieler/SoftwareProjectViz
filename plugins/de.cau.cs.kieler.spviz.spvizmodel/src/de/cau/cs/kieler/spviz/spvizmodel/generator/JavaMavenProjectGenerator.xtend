/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2022-2024 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import de.cau.cs.kieler.spviz.spvizmodel.generator.maven.Dependency
import java.io.File
import java.util.List

/**
 * Generator for Java projects using Maven dependencies. Configure it with chained configure[...] methods and start with
 * {@link #generate()}.
 * 
 * @author nre
 */
class JavaMavenProjectGenerator {
    
    /** directory of the project to be generated */
    val File projectDirectory
    
    /** Group ID of the project to be generated. */
    val String groupId
    
    /** Artifact ID and project path of the project to be generated */
    val String artifactId
    
    /** The dependencies for this new project. */
    val List<Dependency> dependencies = newArrayList
    
    /** Additional dependency management to be added to the project pom, as formatted String. */
    var String dependencyManagement = ""
    
    /** The sub-folder name of the source folder */
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
    new(String groupId, String projectName, String projectPath) {
        this.groupId = groupId
        this.artifactId = projectName
        this.projectDirectory = FileGenerator.createDirectory(projectPath)
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
     */
    def void generate() {
        val File settingsDirectory = FileGenerator.createDirectory(projectDirectory, ".settings")
        
        // Create the .classpath file
        FileGenerator.generateFile(new File(projectDirectory,  ".classpath"), classpathContent)
        
        // Create the .project file
        FileGenerator.generateFile(new File(projectDirectory, ".project"), projectContent)
        
        // Create the settings/org.eclipse.core.resources.prefs file
        FileGenerator.generateFile(new File(settingsDirectory, "org.eclipse.core.resources.prefs"), eclipseCoreResourcesPrefsContent)
        
        // Generate the pom.xml file
        FileGenerator.generateFile(new File(projectDirectory, "pom.xml"), pomXmlContent)
        
        // The source folders
        FileGenerator.createDirectory(projectDirectory, sourceFolderName)
        if (xtendSources) {
            FileGenerator.createDirectory(projectDirectory, "xtend-gen")
        }
    }
    
    private def classpathContent() {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <classpath>
                <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-17"/>
                <classpathentry kind="con" path="org.eclipse.m2e.MAVEN2_CLASSPATH_CONTAINER"/>
                <classpathentry kind="src" path="«sourceFolderName»"/>
                «IF xtendSources»
                    <classpathentry kind="src" path="xtend-gen"/>
                «ENDIF»
                <classpathentry kind="output" path="bin"/>
            </classpath>
            
        '''
    }
    
    private def projectContent() {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <projectDescription>
                <name>«artifactId»</name>
                <comment></comment>
                <projects>
                </projects>
                <buildSpec>
                    <buildCommand>
                        <name>org.eclipse.jdt.core.javabuilder</name>
                        <arguments>
                        </arguments>
                    </buildCommand>
                    <buildCommand>
                        <name>org.eclipse.m2e.core.maven2Builder</name>
                        <arguments>
                        </arguments>
                    </buildCommand>
                </buildSpec>
                <natures>
                    <nature>org.eclipse.jdt.core.javanature</nature>
                    <nature>org.eclipse.m2e.core.maven2Nature</nature>
                </natures>
            </projectDescription>
            
        '''
    }
    
    private def eclipseCoreResourcesPrefsContent() {
        return '''
            eclipse.preferences.version=1
            encoding/<project>=UTF-8
            
        '''
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
                    <plugins>
                        <plugin>
                            <artifactId>maven-compiler-plugin</artifactId>
                            <version>3.10.0</version>
                            <configuration>
                                <source>17</source>
                                <target>17</target>
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
