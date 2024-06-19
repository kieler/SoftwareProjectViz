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
package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.IProgressMonitor

class GenerateMavenBuild {
    /* 
     * TODO: 
     * - generate a full .gitignore for each project/feature/other main folder for an easier build process
     *   (/bin, /target, dependencies.txt, ...)
     */
    
    static String[] bundleSuffixes = #["viz", "model", "language.server"]
    
    /**
     * Generates the entire Maven build for this visualization.
     * 
     * @param groupId The prefix group ID for this visualization project.
     * @param modelId The ID prefix of the model bundle.
     * @param artifactIdPrefix The individual bundle's prefix artifact ID
     */
    static def generate(String artifactIdPrefix, String vizName, String modelIdPrefix, String version, IProgressMonitor progressMonitor) {
        // A pom for each sub-module
        for (bundleSuffix : bundleSuffixes) {
            addProjectPom(artifactIdPrefix, bundleSuffix, version, progressMonitor)
        }
        // The main build folder with the main pom to build this viz, an Eclipse feature, LS CLI build, and Tycho update site config
        addBuildFolder(artifactIdPrefix, vizName, modelIdPrefix, version, progressMonitor)
    }
    
    private static def addProjectPom(String artifactIdPrefix, String bundleSuffix, String version, IProgressMonitor progressMonitor) {
        val projectId = artifactIdPrefix + "." + bundleSuffix
        // Find the project
        val workspace = ResourcesPlugin.getWorkspace()
        val IProject project = workspace.getRoot().getProject(projectId)
        if (!project.exists || !project.open) {
            throw new IllegalStateException("The project does either not exist or is not open, but should be: " + projectId)
        }
        val content = pomXmlContent(artifactIdPrefix, bundleSuffix, version)
        FileGenerator.generateFile(project, "pom.xml", content, progressMonitor)
    }
    
    private static def addBuildFolder(String artifactIdPrefix, String vizName, String modelIdPrefix, String version, IProgressMonitor progressMonitor) {
        val String modelId = modelIdPrefix + ".model"
        
        // The main build folder with an Eclipse feature, LS CLI build, and Tycho update site config
        // Create a project to hold the build artifacts.
        val buildProjectName = artifactIdPrefix + ".build"
        val workspace = ResourcesPlugin.getWorkspace()
        val IProject project = workspace.getRoot().getProject(buildProjectName)
        if (!project.exists()) {
            val projectDescription = ResourcesPlugin.getWorkspace().newProjectDescription(buildProjectName)
            project.create(projectDescription, progressMonitor)
        }
        project.open(progressMonitor)
        
        // Put the pom.xml in the project.
        val content = spvizPomXmlContent(artifactIdPrefix, modelIdPrefix, version)
        FileGenerator.generateFile(project, "pom.xml", content, progressMonitor)
        
        // Generate the Eclipse feature
        addEclipseFeature(project, artifactIdPrefix, modelId, version, progressMonitor)
        
        // Generate the Tycho update site config
        addTychoUpdateSiteConfig(project, artifactIdPrefix, modelId, version, progressMonitor)
    }
    
    private static def addEclipseFeature(IProject project, String artifactIdPrefix, String modelId, String version, IProgressMonitor progressMonitor) {
        val featureFolder = project.getFolder("feature")
        if (!featureFolder.exists) {
            featureFolder.create(false, true, progressMonitor)
        }
        
        var String content = featureXmlContent(artifactIdPrefix, modelId, version)
        FileGenerator.generateFile(featureFolder, "feature.xml", content, progressMonitor)
        content = featurePomXmlContent(artifactIdPrefix, version)
        FileGenerator.generateFile(featureFolder, "pom.xml", content, progressMonitor)
        content = featureBuildPropertiesContent
        FileGenerator.generateFile(featureFolder, "build.properties", content, progressMonitor)
    }
    
    private static def addTychoUpdateSiteConfig(IProject project, String artifactIdPrefix, String modelId, String version, IProgressMonitor progressMonitor) {
        val repositoryFolder = project.getFolder(artifactIdPrefix + ".repository")
        if (!repositoryFolder.exists) {
            repositoryFolder.create(false, true, progressMonitor)
        }
        
        var String content = repositoryCategoryXmlContent(artifactIdPrefix, version)
        FileGenerator.generateFile(repositoryFolder, "category.xml", content, progressMonitor)
        content = repositoryPomXmlContent(artifactIdPrefix, version)
        FileGenerator.generateFile(repositoryFolder, "pom.xml", content, progressMonitor)
        
        val siteTemplateFolder = project.getFolder(artifactIdPrefix + ".repository/siteTemplate")
        if (!siteTemplateFolder.exists) {
            siteTemplateFolder.create(false, true, progressMonitor)
        }
        
        content = repositoryIndexHtmlContent(artifactIdPrefix)
        FileGenerator.generateFile(siteTemplateFolder, "index.html", content, progressMonitor)
        content = repositoryP2IndexContent()
        FileGenerator.generateFile(siteTemplateFolder, "p2.index", content, progressMonitor)
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
                    «FOR bundleSuffix : bundleSuffixes»
                        <module>../«vizArtifactIdPrefix».«bundleSuffix»</module>
                    «ENDFOR»
                    <module>../«modelIdPrefix».model</module>
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
    private static def pomXmlContent(String vizArtifactIdPrefix, String bundleSuffix, String version) {
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