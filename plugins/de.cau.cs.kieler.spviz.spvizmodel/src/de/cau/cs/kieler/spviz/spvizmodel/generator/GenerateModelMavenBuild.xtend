/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2022-2026 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import java.io.File
import org.slf4j.Logger
import org.slf4j.LoggerFactory

/**
 * Helper methods to generate Maven build artifacts for plugins.
 * 
 * @author nre
 */
class GenerateModelMavenBuild {
    
    static final Logger LOGGER = LoggerFactory.getLogger(GenerateModelMavenBuild)
    
    /* 
     * TODO:
     * - generate a full .gitignore for an easier build process (/bin, /target, dependencies.txt, ...)
     */
     
    /**
     * Generates a pom.xml file for the given project and model.
     * 
     * @param projectDirectory The generated project directory for that the pom.xml file should be added.
     * @param model The source model
     */
    static def addPluginPom(File projectDirectory, SPVizModel model, String version) {
        FileGenerator.generateFile(projectDirectory, "pom.xml", pomXmlContent(model.package, "model", version))
    }
    
    /**
     * Generates the pom.xml in an own folder, working as the parent pom configuration for all
     * builds of projects using SPViz. Also adds a general target platform for all SPViz projects
     */
    static def addSpvizBuildProject(File rootDirectoy, String version) {
        val spvizPath = "spviz.build"
        // Create a project to hold the build pom.
        val existingDirectory = new File(rootDirectoy, spvizPath)
        if (existingDirectory.isDirectory) {
            LOGGER.info("Skipped generating build project, folder already exists. {}", existingDirectory.absolutePath)
            return
        } else {
            LOGGER.info("Generating project {}", existingDirectory.absolutePath)
        }
        val buildDirectory = FileGenerator.createDirectory(rootDirectoy, spvizPath)
        
        // Put the pom.xml in the project.
        val content = spvizPomXmlContent(version)
        FileGenerator.generateFile(buildDirectory, "pom.xml", content)
        
        // Generate the P2 update site config
        addP2Config(buildDirectory, version)
    }
    
    private static def addP2Config(File buildDirectory, String version) {
        val targetPlatformDirectory = FileGenerator.createDirectory(buildDirectory, "de.cau.cs.kieler.spviz.targetplatform")
        
        FileGenerator.generateFile(targetPlatformDirectory, "de.cau.cs.kieler.spviz.targetplatform.target", targetContent)
        FileGenerator.generateFile(targetPlatformDirectory, "pom.xml", targetPlatformPomXmlContent(version))
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
                <sourceDirectory>src-gen</sourceDirectory>
                <plugins>
                  <plugin>
                    <groupId>org.eclipse.xtext</groupId>
                    <artifactId>xtext-maven-plugin</artifactId>
                    <version>${xtext-version}</version>
                    <executions>
                        <execution>
                            <phase>generate-sources</phase>
                            <goals>
                                <goal>generate</goal>
                            </goals>
                        </execution>
                    </executions>
                    <configuration>
                        <languages>
                            <language>
                                <setup>org.eclipse.xtext.ecore.EcoreSupport</setup>
                            </language>
                            <language>
                                <setup>org.eclipse.emf.codegen.ecore.xtext.GenModelSupport</setup>
                            </language>
                            <language>
                                <setup>org.eclipse.emf.ecore.xcore.XcoreStandaloneSetup</setup>
                                <outputConfigurations>
                                    <outputConfiguration>
                                        <outputDirectory>${project.basedir}/src-gen</outputDirectory>
                                    </outputConfiguration>
                                </outputConfigurations>
                            </language>
                        </languages>
                        <sourceRoots>
                            <root>${basedir}/model</root>
                        </sourceRoots>
                    </configuration>
                    <dependencies>
                        <dependency>
                            <groupId>org.eclipse.platform</groupId>
                            <artifactId>org.eclipse.text</artifactId>
                            <version>3.14.500</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.platform</groupId>
                            <artifactId>org.eclipse.core.resources</artifactId>
                            <version>3.23.100</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.xtext</groupId>
                            <artifactId>org.eclipse.xtext.ecore</artifactId>
                            <version>${xtext-version}</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.xtext</groupId>
                            <artifactId>org.eclipse.xtext.xtext.generator</artifactId>
                            <version>${xtext-version}</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.xtext</groupId>
                            <artifactId>org.eclipse.xtext.builder.standalone</artifactId>
                            <version>${xtext-version}</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.emf</groupId>
                            <artifactId>org.eclipse.emf.codegen.ecore.xtext</artifactId>
                            <version>1.8.0</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.emf</groupId>
                            <artifactId>org.eclipse.emf.common</artifactId>
                            <version>2.44.0</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.emf</groupId>
                            <artifactId>org.eclipse.emf.ecore</artifactId>
                            <version>2.41.0</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.emf</groupId>
                            <artifactId>org.eclipse.emf.ecore.xmi</artifactId>
                            <version>2.39.0</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.emf</groupId>
                            <artifactId>org.eclipse.emf.codegen</artifactId>
                            <version>2.27.0</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.emf</groupId>
                            <artifactId>org.eclipse.emf.codegen.ecore</artifactId>
                            <version>2.44.0</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.emf</groupId>
                            <artifactId>org.eclipse.emf.ecore.xcore</artifactId>
                            <version>1.35.0</version>
                        </dependency>
                        <dependency>
                            <groupId>org.eclipse.emf</groupId>
                            <artifactId>org.eclipse.emf.ecore.xcore.lib</artifactId>
                            <version>1.7.1</version>
                        </dependency>
                    </dependencies>
                  </plugin>
                </plugins>
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
                <targetJdk>21</targetJdk>
                <maven.compiler.source>21</maven.compiler.source>
                <maven.compiler.target>21</maven.compiler.target>
                
                <elk-version>0.11.0</elk-version>
                <gson-version>2.13.2</gson-version>
                <guice-version>7.0.0</guice-version>
                <klighd-version>3.1.0.v20250428</klighd-version>
                <lsp4j-version>0.24.0</lsp4j-version>
                <tycho-version>4.0.13</tycho-version>
                <xtext-version>2.41.0</xtext-version>
                <xtend-version>2.41.0</xtend-version>
                
                <sourceFeatureLabelSuffix>&#xA0;(Sources)</sourceFeatureLabelSuffix>
                <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
                <project.build.resourceEncoding>UTF-8</project.build.resourceEncoding>
                <maven.compiler.encoding>UTF-8</maven.compiler.encoding>
              </properties>
            
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
                    <version>3.9.0</version>
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
                      <groupId>org.eclipse.xtext</groupId>
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
                      <version>3.6.1</version>
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
                      <version>3.5.0</version>
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
                  <unit id="org.eclipse.m2e.feature.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.m2e.sdk.feature.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.lsp4j.sdk.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.wildwebdeveloper.xml.feature.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.sdk.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.xtext.sdk.feature.group" version="0.0.0"/>
                  <unit id="org.eclipse.emf.ecore.xcore.sdk.feature.group" version="0.0.0"/> 
                  <repository location="https://download.eclipse.org/releases/2025-12"/>
                </location>
«««                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="false" type="InstallableUnit">
«««                  <unit id="org.sonatype.tycho.m2e.feature.feature.group" version="0.0.0"/>
«««                  <repository location="https://repo1.maven.org/maven2/.m2e/connectors/m2eclipse-tycho/0.8.1/N/0.8.1.201704211436/"/>
«««                </location>
                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="false" type="InstallableUnit">
                  <unit id="org.eclipse.elk.sdk.feature.feature.group" version="0.0.0"/>
                  <repository location="https://download.eclipse.org/elk/updates/releases/0.11.0/"/>
                </location>
                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="false" type="InstallableUnit">
                  <unit id="de.cau.cs.kieler.kgraph.text.ide" version="0.0.0"/>
                  <unit id="de.cau.cs.kieler.klighd.view.feature.feature.group" version="0.0.0"/>
                  <repository location="https://kieler.github.io/KLighD/v3.1.0/"/>
                </location>
                <location includeAllPlatforms="false" includeConfigurePhase="true" includeMode="planner" includeSource="false" type="InstallableUnit">
                  <unit id="com.google.gson" version="0.0.0"/>
                  <unit id="com.google.inject" version="0.0.0"/>
                  <unit id="slf4j.api" version="0.0.0"/> 
                  <repository location="https://download.eclipse.org/tools/orbit/simrel/orbit-aggregation/release/4.38.0/"/>
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
              
              <build>
                <plugins>
                  <!-- do not publish this artifact to Maven repositories -->
                  <plugin>
                    <artifactId>maven-deploy-plugin</artifactId>
                    <version>3.1.4</version>
                    <configuration>
                      <skip>true</skip>
                    </configuration>
                  </plugin>
                </plugins>
              </build>
            
            </project>
            
        '''
    }
}