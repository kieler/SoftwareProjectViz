/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2022-2025 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import java.io.File

class GenerateMavenBuild {
    /* 
     * TODO: 
     * - generate a full .gitignore for each project/feature/other main folder for an easier build process
     *   (/bin, /target, dependencies.txt, ...)
     */
    
    static String[] vizBundleSuffixes = #["viz", "model", "language.server", "diffviz"]
//    TODO: comment in when DSL generation works.
    static String[] modelBundleSuffixes = #["model", /*"model.dsl.parent", */"diff.dsl.parent"]
    
    /**
     * Generates the entire Maven build for this visualization.
     * 
     * @param rootPath the root path were all generated projects can be found.
     * @param artifactIdPrefix The individual bundle's prefix artifact ID
     * @param vizName The name of the visualization.
     * @param modelIdPrefix The ID prefix of the spvizmodel.
     * @param version The version the generated project should be generated with.
     */
    static def generate(String rootPath, String artifactIdPrefix, String vizName, String modelIdPrefix, String version) {
        val root = new File (rootPath)
        // A pom for each sub-module
        for (bundleSuffix : de.cau.cs.kieler.spviz.spviz.generator.GenerateMavenBuild.vizBundleSuffixes) {
            addProjectPom(root, artifactIdPrefix, bundleSuffix, version)
        }
        // The main build folder with the main pom to build this viz, an Eclipse feature, LS CLI build, and Tycho update site config
        addBuildFolder(root, artifactIdPrefix, vizName, modelIdPrefix, version)
    }
    
    private static def addProjectPom(File root, String artifactIdPrefix, String bundleSuffix, String version) {
        val projectId = artifactIdPrefix + "." + bundleSuffix
        // Find the folder
        val project = new File(root, projectId)
        if (!project.exists || !project.isDirectory) {
            throw new IllegalStateException("The project does either not exist or is not a directory, but should be: " + projectId)
        }
        val content = pomXmlContent(artifactIdPrefix, bundleSuffix, version, bundleSuffix.equals("model"))
        FileGenerator.generateFile(project, "pom.xml", content)
    }
    
    private static def addBuildFolder(File root, String artifactIdPrefix, String vizName, String modelIdPrefix, String version) {
        val String modelId = modelIdPrefix + ".model"
        
        // The main build folder with an Eclipse feature, LS CLI build, and Tycho update site config
        // Create a project to hold the build artifacts.
        val buildProjectName = artifactIdPrefix + ".build"
        val project = FileGenerator.createDirectory(root, buildProjectName)
        
        // Put the pom.xml in the project.
        val content = spvizPomXmlContent(artifactIdPrefix, modelIdPrefix, version)
        FileGenerator.generateFile(project, "pom.xml", content)
        
        // Generate the Eclipse feature
        addEclipseFeature(project, artifactIdPrefix, modelId, version)
        
        // Generate the Tycho update site config
        addTychoUpdateSiteConfig(project, artifactIdPrefix, modelId, version)
    }
    
    private static def addEclipseFeature(File project, String artifactIdPrefix, String modelId, String version) {
        val featureFolder = FileGenerator.createDirectory(project, "feature")
        
        var String content = featureXmlContent(artifactIdPrefix, modelId, version)
        FileGenerator.generateFile(featureFolder, "feature.xml", content)
        content = featurePomXmlContent(artifactIdPrefix, version)
        FileGenerator.generateFile(featureFolder, "pom.xml", content)
        content = featureBuildPropertiesContent
        FileGenerator.generateFile(featureFolder, "build.properties", content)
    }
    
    private static def addTychoUpdateSiteConfig(File project, String artifactIdPrefix, String modelId, String version) {
        val repositoryFolder = FileGenerator.createDirectory(project, artifactIdPrefix + ".repository")
        
        var String content = repositoryCategoryXmlContent(artifactIdPrefix, version)
        FileGenerator.generateFile(repositoryFolder, "category.xml", content)
        content = repositoryPomXmlContent(artifactIdPrefix, version)
        FileGenerator.generateFile(repositoryFolder, "pom.xml", content)
        
        val siteTemplateFolder = FileGenerator.createDirectory(project, artifactIdPrefix + ".repository/siteTemplate")
        
        content = repositoryIndexHtmlContent(artifactIdPrefix)
        FileGenerator.generateFile(siteTemplateFolder, "index.html", content)
        content = repositoryP2IndexContent()
        FileGenerator.generateFile(siteTemplateFolder, "p2.index", content)
    }
    
    private static def spvizPomXmlContent(String vizArtifactIdPrefix, String modelIdPrefix, String version) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
              <modelVersion>4.0.0</modelVersion>
              <groupId>«vizArtifactIdPrefix»</groupId>
              <artifactId>parent</artifactId>
              <version>«version»-SNAPSHOT</version>
              <packaging>pom</packaging>
              <parent>
                <groupId>de.cau.cs.kieler.spviz</groupId>
                <artifactId>parent</artifactId>
                <version>«version»-SNAPSHOT</version>
                <relativePath>../spviz.build/pom.xml</relativePath>
              </parent>
              
              <!-- Define one profile for each output target we have -->
              <profiles>
                <profile>
                  <id>repo</id>
            
                  <activation>
                    <activeByDefault>true</activeByDefault>
                  </activation>
                  
                  <modules>
                    <module>../spviz.build</module>
                    <module>../spviz.build/de.cau.cs.kieler.spviz.targetplatform</module>
                    «FOR bundleSuffix : GenerateMavenBuild.vizBundleSuffixes»
                        <module>../«vizArtifactIdPrefix».«bundleSuffix»</module>
                    «ENDFOR»
                    «FOR modelBundleSuffix : GenerateMavenBuild.modelBundleSuffixes»
                        <module>../«modelIdPrefix».«modelBundleSuffix»</module>
                    «ENDFOR»
                    <module>feature</module>
                    <module>«vizArtifactIdPrefix».repository</module>
                  </modules>
                </profile>
                
                <!-- build just the model generator. -->
                <profile>
                  <id>generator</id>
                  <modules>
                    <module>../spviz.build/de.cau.cs.kieler.spviz.targetplatform</module>
                    <module>../«modelIdPrefix».model</module>
                    <module>../«modelIdPrefix».generate</module>
                  </modules>
                </profile>
              </profiles>
            
            </project>
            
        '''
    }
    private static def pomXmlContent(String vizArtifactIdPrefix, String bundleSuffix, String version, boolean modelXcoreBuild) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
              <modelVersion>4.0.0</modelVersion>
              <parent>
                <groupId>«vizArtifactIdPrefix»</groupId>
                <artifactId>parent</artifactId>
                <version>«version»-SNAPSHOT</version>
                <relativePath>../«vizArtifactIdPrefix».build/pom.xml</relativePath>
              </parent>
            
              <artifactId>«vizArtifactIdPrefix».«bundleSuffix»</artifactId>
              <packaging>eclipse-plugin</packaging>
            
              <build>
                  <sourceDirectory>src-gen</sourceDirectory>
                  <plugins>
                    «IF modelXcoreBuild»
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
                                    <version>3.14.100</version>
                                </dependency>
                                <dependency>
                                    <groupId>org.eclipse.platform</groupId>
                                    <artifactId>org.eclipse.core.resources</artifactId>
                                    <version>3.20.200</version>
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
                                    <version>2.30.0</version>
                                </dependency>
                                <dependency>
                                    <groupId>org.eclipse.emf</groupId>
                                    <artifactId>org.eclipse.emf.ecore</artifactId>
                                    <version>2.36.0</version>
                                </dependency>
                                <dependency>
                                    <groupId>org.eclipse.emf</groupId>
                                    <artifactId>org.eclipse.emf.ecore.xmi</artifactId>
                                    <version>2.37.0</version>
                                </dependency>
                                <dependency>
                                    <groupId>org.eclipse.emf</groupId>
                                    <artifactId>org.eclipse.emf.codegen</artifactId>
                                    <version>2.14.0</version>
                                </dependency>
                                <dependency>
                                    <groupId>org.eclipse.emf</groupId>
                                    <artifactId>org.eclipse.emf.codegen.ecore</artifactId>
                                    <version>2.23.0</version>
                                </dependency>
                                <dependency>
                                    <groupId>org.eclipse.emf</groupId>
                                    <artifactId>org.eclipse.emf.ecore.xcore</artifactId>
                                    <version>1.29.0</version>
                                </dependency>
                                <dependency>
                                    <groupId>org.eclipse.emf</groupId>
                                    <artifactId>org.eclipse.emf.ecore.xcore.lib</artifactId>
                                    <version>1.7.0</version>
                                </dependency>
                            </dependencies>
                          </plugin>
                    «ENDIF»
                    <!-- Compile Xtend code -->
                    <plugin>
                      <groupId>org.eclipse.xtend</groupId>
                      <artifactId>xtend-maven-plugin</artifactId>
                    </plugin>
                  </plugins>
                </build>
            </project>
            
        '''
    }
    
    private static def featureXmlContent(String artifactIdPrefix, String modelId, String version) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <feature
                  id="«artifactIdPrefix».feature"
                  label="«artifactIdPrefix»"
                  version="«version».qualifier"
                  provider-name="Software Project Visualization">
            
               <description url="https://github.com/kieler">
                  Visualization of diagrams for «artifactIdPrefix» using KIELER Lightweight Diagrams (KLighD).
               </description>
            
               <requires>
                  <import plugin="org.eclipse.core.runtime"/>
                  <import plugin="org.eclipse.emf.ecore"/>
                  <import plugin="org.eclipse.xtext.xbase.lib"/>
                  <import plugin="org.eclipse.emf.ecore.xcore.lib"/>
                  <import plugin="org.eclipse.emf.edit"/>
                  <import plugin="org.eclipse.emf.ecore.edit"/>
                  <import plugin="org.eclipse.osgi"/>
                  <import plugin="org.eclipse.core.resources"/>
                  <import plugin="org.eclipse.emf.ecore.xmi"/>
                  <import plugin="org.eclipse.emf.edit.ui"/>
                  <import plugin="org.eclipse.jface.text"/>
                  <import plugin="org.eclipse.ui.ide"/>
                  <import plugin="de.cau.cs.kieler.klighd"/>
                  <import plugin="«modelId»"/>
                  <import plugin="de.cau.cs.kieler.klighd.krendering.extensions"/>
                  <import plugin="com.google.inject"/>
                  <import plugin="org.eclipse.elk.core"/>
                  <import plugin="org.eclipse.elk.alg.layered"/>
                  <import plugin="org.eclipse.elk.alg.rectpacking"/>
               </requires>
            
               <plugin
                     id="«artifactIdPrefix».viz"
                     download-size="0"
                     install-size="0"
                     version="0.0.0"
                     unpack="false"/>
            
               <plugin
                     id="«artifactIdPrefix».model"
                     download-size="0"
                     install-size="0"
                     version="0.0.0"
                     unpack="false"/>
            
               <plugin
                     id="«modelId»"
                     download-size="0"
                     install-size="0"
                     version="0.0.0"
                     unpack="false"/>
            
               <plugin
                     id="org.eclipse.emf.ecore.editor"
                     download-size="0"
                     install-size="0"
                     version="0.0.0"
                     unpack="false"/>
            
            </feature>
            
        '''
    }
    
    private static def featurePomXmlContent(String artifactIdPrefix, String version) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
              <modelVersion>4.0.0</modelVersion>
              <parent>
                <groupId>«artifactIdPrefix»</groupId>
                <artifactId>parent</artifactId>
                <version>«version»-SNAPSHOT</version>
                <relativePath>../pom.xml</relativePath>
              </parent>
              
              <artifactId>«artifactIdPrefix».feature</artifactId>
              <packaging>eclipse-feature</packaging>
            </project>
            
        '''
    }
    
    private static def featureBuildPropertiesContent() {
        return '''
            bin.includes = feature.xml
            
        '''
    }
    
    private static def repositoryCategoryXmlContent(String artifactIdPrefix, String version) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <site>
            
                <description name="P2 Update site">
                    Update site for diagram visualization for «artifactIdPrefix» with SPViz.
                </description>
            
                <category-def name="viz" label="Diagram Visualization for «artifactIdPrefix»">
                    <description>
                        Components for the generation of diagrams for «artifactIdPrefix».
                    </description>
                </category-def>
            
                <feature url="features/«artifactIdPrefix»_«version».qualifier.jar" id="«artifactIdPrefix».feature" version="«version».qualifier"> 
                    <category name="viz"/>
                </feature>
               
                <repository-reference location="https://download.eclipse.org/releases/2023-12" enabled="true" />
                <repository-reference location="https://download.eclipse.org/tools/orbit/simrel/orbit-aggregation/release/4.30.0/" enabled="true" />
                <repository-reference location="https://download.eclipse.org/elk/updates/releases/0.9.1/" enabled="true" />
                <repository-reference location="https://kieler.github.io/KLighD/v3.0.1/" enabled="true" />
            
            </site>
            
        '''
    }
    
    private static def repositoryPomXmlContent(String artifactIdPrefix, String version) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
              <modelVersion>4.0.0</modelVersion>
            
              <version>«version»-SNAPSHOT</version>
              <artifactId>«artifactIdPrefix».repository</artifactId>
              <packaging>eclipse-repository</packaging>
              <name>Repository for «artifactIdPrefix»</name>
            
              <parent>
                <groupId>de.cau.cs.kieler.spviz</groupId>
                <artifactId>parent</artifactId>
                <version>«version»-SNAPSHOT</version>
                <relativePath>../../spviz.build/pom.xml</relativePath>
              </parent>
            
              <build>
                <resources>
                  <resource>
                    <directory>siteTemplate</directory>
                  </resource>
                </resources>
                
                <plugins>
                  <plugin>
                    <groupId>org.eclipse.tycho</groupId>
                    <artifactId>tycho-p2-repository-plugin</artifactId>
                    <version>${tycho-version}</version>
                  </plugin>
                  <!-- do not publish this artifact to Maven repositories -->
                  <plugin>
                    <artifactId>maven-deploy-plugin</artifactId>
                    <configuration>
                      <skip>true</skip>
                    </configuration>
                  </plugin>
                </plugins>
              </build>
            </project>
            
        '''
    }
    
    private static def repositoryIndexHtmlContent(String artifactIdPrefix) {
        return '''
            <html>
            <head>
            <title>«artifactIdPrefix» - P2 Update Site</title>
            <link rel="stylesheet" type="text/css" href="web/site.css">
            </head>
            <body marginheight="0" marginwidth="0" leftmargin="0" topmargin="0">
            <center>
            <table cellspacing="0" cellpadding="0" class="table">
              <tr>
                <td>
                <h2 class="title"><br/><br/>${update.site.name} - ${update.site.description} Update Site</h2>
                <table width="100%">
                  <tr class="light-row" style="height: 30px">
                    <td class="bodyText">
                      <p class="bodyText">
                        This is the Update Site for «artifactIdPrefix».
                        <blockquote style="border: 1px dashed #1778be; padding: 2px">
                          <ol>
                            <li>To install from this site, start up Eclipse, then do:
                              <ul>
                                <code><strong>Help > Install New Software... ></strong></code>
                              </ul>
                            </li>
                            <li>Copy this site's URL into Eclipse, and hit Enter.</li>
                            <li>
                              When the site loads, select the features to install,
                              or click the <code><strong>Select All</strong></code> button.</li>
                            <li>
                              To properly resolve all dependencies, check
                              <ul><code><strong>[x] Contact all update sites during install to find required software</strong></code></ul>
                            </li>
                            <li>Click <code><strong>Next</strong></code>, agree to the license terms, and install.</li>
                          </ol>
                        </blockquote>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
            </center>
            </html>
            
        '''
    }
    
    private static def repositoryP2IndexContent() {
        return '''
            version = 1
            metadata.repository.factory.order = content.xml,\!
            artifact.repository.factory.order = artifacts.xml,\!
            
        '''
    }
     
}