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

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.IProgressMonitor

/**
 * Helper methods to generate Maven build artifacts for plugins.
 */
class GenerateModelMavenBuild {
    /* 
     * TODO:
     * - generate a full .gitignore for an easier build process (/bin, /target, dependencies.txt, ...)
     */
     
    /**
     * Generates a pom.xml file for the given project and model.
     * 
     * @param project The generated Eclipse project for that the pom.xml file should be added.
     * @param model The source model
     */
    static def addPluginPom(IProject project, SPVizModel model, String version, IProgressMonitor progressMonitor) {
        val groupId = model.package
        val content = pomXmlContent(groupId, "model", version)
        FileGenerator.generateOrUpdateFile(project, "pom.xml", content, progressMonitor)
    }
    
    /**
     * Generates the pom.xml in an own folder, working as the parent pom configuration for all
     * builds of projects using SPViz. Also adds a general target platform for all SPViz projects
     */
    static def addSpvizBuildProjectPom(String version, IProgressMonitor progressMonitor) {
        val spvizPath = "spviz.build"
        // Create a project to hold the build pom.
        val workspace = ResourcesPlugin.getWorkspace()
        val IProject project = workspace.getRoot().getProject(spvizPath)
        if (!project.exists()) {
            val projectDescription = ResourcesPlugin.getWorkspace().newProjectDescription(spvizPath)
            project.create(projectDescription, progressMonitor)
        }
        project.open(progressMonitor)
        
        // Put the pom.xml in the project.
        val content = spvizPomXmlContent(version)
        FileGenerator.generateOrUpdateFile(project, "pom.xml", content, progressMonitor)
        
        // Generate the P2 update site config
        addP2Config(project, version, progressMonitor)
    }
    
    private static def addP2Config(IProject project, String version, IProgressMonitor progressMonitor) {
        val targetPlatformFolder = project.getFolder("de.cau.cs.kieler.spviz.targetplatform")
        if (!targetPlatformFolder.exists) {
            targetPlatformFolder.create(false, true, progressMonitor)
        }
        
        var String content = targetContent
        FileGenerator.generateOrUpdateFile(targetPlatformFolder, "de.cau.cs.kieler.spviz.targetplatform.target", content, progressMonitor)
        content = targetPlatformPomXmlContent(version)
        FileGenerator.generateOrUpdateFile(targetPlatformFolder, "pom.xml", content, progressMonitor)
    }
    
    private static def pomXmlContent(String groupId, String artifactId, String version) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
              <modelVersion>4.0.0</modelVersion>
              <parent>
                <groupId>de.cau.cs.kieler.spviz</groupId>
                <artifactId>parent</artifactId>
                <version>«version»-SNAPSHOT</version>
                <relativePath>../spviz.build/pom.xml</relativePath>
              </parent>
            
              <groupId>«groupId»</groupId>
              <artifactId>«groupId».«artifactId»</artifactId>
              <version>«version»-SNAPSHOT</version>
              <packaging>eclipse-plugin</packaging>
            
              <build>
                <sourceDirectory>src</sourceDirectory>
              </build>
            </project>
            
        '''
    }
    
    private static def spvizPomXmlContent(String version) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <!-- General parent pom with configuration for all spviz builds -->
            <project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
              <modelVersion>4.0.0</modelVersion>
              <groupId>de.cau.cs.kieler.spviz</groupId>
              <artifactId>parent</artifactId>
              <version>«version»-SNAPSHOT</version>
              <packaging>pom</packaging>
              
              
              <!-- Define a few properties used throughout all build profiles. -->
              <properties>
                <targetJdk>11</targetJdk>
                <tycho-version>1.7.0</tycho-version>
                <xtext-version>2.25.0</xtext-version>
                <kieler-version>${project.version}</kieler-version>
                <sourceFeatureLabelSuffix>&#xA0;(Sources)</sourceFeatureLabelSuffix>
                <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
                <project.build.resourceEncoding>UTF-8</project.build.resourceEncoding>
                <maven.compiler.encoding>UTF-8</maven.compiler.encoding>
              </properties>
              
              <!-- Additional plug-in repositories. -->
              <pluginRepositories>
                <pluginRepository>
                  <id>jboss-public-repository-group</id>
                  <name>JBoss Public Repository Group</name>
                  <url>http://repository.jboss.org/nexus/content/groups/public/</url>
                </pluginRepository>
                <pluginRepository>
                  <id>jboss-snapshots-repository</id>
                  <name>JBoss Snapshots Repository</name>
                  <url>https://repository.jboss.org/nexus/content/repositories/snapshots/</url>
                </pluginRepository>
              </pluginRepositories>
            
            
              <!-- Modify the build process to add Tycho and configure some utility plug-ins. -->
              <build>
                <plugins>
            
                  <!-- We need tycho to build eclipse plugins -->
                  <plugin>
                    <groupId>org.eclipse.tycho</groupId>
                    <artifactId>tycho-maven-plugin</artifactId>
                    <version>${tycho-version}</version>
                    <extensions>true</extensions>
                  </plugin>
            
                  <!-- Setup our target platform for the build -->
                  <plugin>
                    <groupId>org.eclipse.tycho</groupId>
                    <artifactId>target-platform-configuration</artifactId>
                    <version>${tycho-version}</version>
                    <configuration>
                      <target>
                        <artifact>
                          <groupId>de.cau.cs.kieler.spviz</groupId>
                          <artifactId>de.cau.cs.kieler.spviz.targetplatform</artifactId>
                          <version>${project.version}</version>
                        </artifact>
                      </target>
                      <environments>
                        <environment>
                          <os>win32</os>
                          <ws>win32</ws>
                          <arch>x86_64</arch>
                        </environment>
                        <environment>
                          <os>linux</os>
                          <ws>gtk</ws>
                          <arch>x86_64</arch>
                        </environment>
                        <environment>
                          <os>macosx</os>
                          <ws>cocoa</ws>
                          <arch>x86_64</arch>
                        </environment>
                      </environments>
                    </configuration>
                  </plugin>
            
                  <!-- Build source plugin bundles -->
                  <plugin>
                    <groupId>org.eclipse.tycho</groupId>
                    <artifactId>tycho-source-plugin</artifactId>
                    <version>${tycho-version}</version>
                    <executions>
                      <execution>
                        <id>plugin-source</id>
                        <goals>
                          <goal>plugin-source</goal>
                        </goals>
                      </execution>
                    </executions>
                  </plugin>
            
                  <!-- Produces a list of all direct and transient dependencies for each module -->
                  <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-dependency-plugin</artifactId>
                    <version>3.1.1</version>
                    <executions>
                      <execution>
                        <id>tree</id>
                        <phase>initialize</phase>
                        <goals>
                          <goal>tree</goal>
                        </goals>
                        <configuration>
                          <outputFile>dependencies.txt</outputFile>
                        </configuration>
                      </execution>
                    </executions>
                  </plugin>
            
                </plugins>
            
                <pluginManagement>
                  <plugins>
            
                    <!-- Maven Xtend plugin to tell maven how to compile Xtend code -->
                    <plugin>
                      <groupId>org.eclipse.xtend</groupId>
                      <artifactId>xtend-maven-plugin</artifactId>
                      <version>${xtext-version}</version>
                      <configuration>
                        <outputDirectory>${basedir}/xtend-gen</outputDirectory>
                      </configuration>
                      <executions>
                        <execution>
                          <goals>
                            <goal>compile</goal>
                          </goals>
                        </execution>
                      </executions>
                    </plugin>
            
                    <!-- Add src-gen and xtend-gen to source-directories -->
                    <plugin>
                      <groupId>org.codehaus.mojo</groupId>
                      <artifactId>build-helper-maven-plugin</artifactId>
                      <version>1.3</version>
                      <executions>
                        <execution>
                          <id>add-source</id>
                          <phase>generate-sources</phase>
                          <goals>
                            <goal>add-source</goal>
                          </goals>
                          <configuration>
                            <sources>
                              <source>src-gen</source>
                              <source>${project.build.directory}/xtend-gen</source>
                            </sources>
                          </configuration>
                        </execution>
                      </executions>
                    </plugin>
            
                    <!-- Generated code needs cleanup too -->
                    <plugin>
                      <artifactId>maven-clean-plugin</artifactId>
                      <version>3.0.0</version>
                      <configuration>
                        <filesets>
                          <fileset>
                            <directory>xtend-gen</directory>
                            <includes>
                              <include>**</include>
                            </includes>
                          </fileset>
                        </filesets>
                      </configuration>
                    </plugin>
            
                  </plugins>
                </pluginManagement>
              </build>
            
            </project>
            
        '''
    }
    
    private static def targetContent() {
        return '''
            <?xml version="1.0" encoding="UTF-8" standalone="no"?>
            <?pde version="3.8"?>
            <target name="SPViz Target" sequenceNumber="1">
              <locations>
                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="false" type="InstallableUnit">
                  <unit id="org.eclipse.emf.mwe2.language.sdk.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.emf.sdk.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.emf.ecore.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.emf.ecore.xcore.lib.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.emf.transaction" version="0.0.0"/>
                  <unit id="org.eclipse.equinox.executable.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.sdk.feature.group" version="0.0.0"/>
                  <repository location="https://download.eclipse.org/releases/2021-06"/>
                </location>
                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="false" type="InstallableUnit">
                  <unit id="org.eclipse.lsp4j.sdk.feature.group" version="0.0.0"/>
                  <repository location="https://archive.eclipse.org/lsp4j/updates/releases/0.10.0/"/>
                </location>
                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="false" type="InstallableUnit">
                  <unit id="org.eclipse.xtext.sdk.feature.group" version="0.0.0"/>
                  <repository location="https://download.eclipse.org/modeling/tmf/xtext/updates/releases/2.25.0/"/>
                </location>
                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="false" type="InstallableUnit">
                  <unit id="org.eclipse.elk.sdk.feature.feature.group" version="0.0.0"/>
                  <repository location="https://download.eclipse.org/elk/updates/releases/0.7.1/"/>
                </location>
                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="false" type="InstallableUnit">
                  <unit id="de.cau.cs.kieler.klighd.lsp" version="0.0.0"/>
                  <unit id="de.cau.cs.kieler.kgraph.text.ide" version="0.0.0"/>
                  <unit id="de.cau.cs.kieler.klighd.view.feature.feature.group" version="0.0.0"/>
                  <repository location="https://rtsys.informatik.uni-kiel.de/~kieler/updatesite/nightly/klighd/"/>
                </location>
                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="false" type="InstallableUnit">
                  <unit id="com.google.gson" version="0.0.0"/>
                  <unit id="com.google.inject" version="0.0.0"/>
                  <unit id="javax.xml.bind" version="0.0.0"/>
                  <repository location="https://download.eclipse.org/tools/orbit/downloads/drops/R20210602031627/repository/"/>
                </location>
                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="true" type="InstallableUnit">
                  <unit id="org.eclipse.sprotty" version="0.0.0"/>
                  <repository location="https://rtsys.informatik.uni-kiel.de/~kieler/updatesite/sprotty/0.9.0/"/>
                </location>
              </locations>
            </target>
            
        '''
    }
    
    private static def targetPlatformPomXmlContent(String version) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
              <modelVersion>4.0.0</modelVersion>
            
              <version>«version»-SNAPSHOT</version>
              <artifactId>de.cau.cs.kieler.spviz.targetplatform</artifactId>
              <packaging>eclipse-target-definition</packaging>
              <name>SPViz Target Platform</name>
            
              <parent>
                <groupId>de.cau.cs.kieler.spviz</groupId>
                <artifactId>parent</artifactId>
                <version>«version»-SNAPSHOT</version>
                <relativePath>../pom.xml</relativePath>
              </parent>
            
            </project>
            
        '''
    }
}