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
     * @param modelId The ID of the model bundle.
     * @param artifactIdPrefix The individual bundle's prefix artifact ID
     */
    static def generate(String artifactIdPrefix, String vizName, String modelId, String version, IProgressMonitor progressMonitor) {
        // A pom for each sub-module
        for (bundleSuffix : bundleSuffixes) {
            addProjectPom(artifactIdPrefix, bundleSuffix, version, progressMonitor)
        }
        // The main build folder with the main pom to build this viz, an Eclipse feature, LS CLI build, and Tycho update site config
        addBuildFolder(artifactIdPrefix, vizName, modelId, version, progressMonitor)
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
        FileGenerator.generateOrUpdateFile(project, "pom.xml", content, progressMonitor)
    }
    
    private static def addBuildFolder(String artifactIdPrefix, String vizName, String modelId, String version, IProgressMonitor progressMonitor) {
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
        val content = spvizPomXmlContent(artifactIdPrefix, modelId, version)
        FileGenerator.generateOrUpdateFile(project, "pom.xml", content, progressMonitor)
        
        // Generate the Eclipse feature
        addEclipseFeature(project, artifactIdPrefix, modelId, version, progressMonitor)
        
        // Generate the LS CLI build config
        addLSCLI(project, vizName, artifactIdPrefix, modelId, version, progressMonitor)
        
        // Generate the Tycho update site config
        addTychoUpdateSiteConfig(project, artifactIdPrefix, modelId, version, progressMonitor)
    }
    
    private static def addEclipseFeature(IProject project, String artifactIdPrefix, String modelId, String version, IProgressMonitor progressMonitor) {
        val featureFolder = project.getFolder("feature")
        if (!featureFolder.exists) {
            featureFolder.create(false, true, progressMonitor)
        }
        
        var String content = featureXmlContent(artifactIdPrefix, modelId, version)
        FileGenerator.generateOrUpdateFile(featureFolder, "feature.xml", content, progressMonitor)
        content = featurePomXmlContent(artifactIdPrefix, version)
        FileGenerator.generateOrUpdateFile(featureFolder, "pom.xml", content, progressMonitor)
        content = featureBuildPropertiesContent
        FileGenerator.generateOrUpdateFile(featureFolder, "build.properties", content, progressMonitor)
    }
    
    private static def addLSCLI(IProject project, String vizName, String artifactIdPrefix, String modelId, String version, IProgressMonitor progressMonitor) {
        val lscliFolder = project.getFolder(artifactIdPrefix + ".language.server.cli")
        if (!lscliFolder.exists) {
            lscliFolder.create(false, true, progressMonitor)
        }
        
        var String content = cliCategoryXmlContent(artifactIdPrefix, modelId)
        FileGenerator.generateOrUpdateFile(lscliFolder, "category.xml", content, progressMonitor)
        content = cliPomXmlContent(artifactIdPrefix, vizName, modelId, version)
        FileGenerator.generateOrUpdateFile(lscliFolder, "pom.xml", content, progressMonitor)
        content = cliUberJarPyContent(artifactIdPrefix, modelId, version)
        FileGenerator.generateOrUpdateFile(lscliFolder, "uberjar.py", content, progressMonitor)
    }
    
    private static def addTychoUpdateSiteConfig(IProject project, String artifactIdPrefix, String modelId, String version, IProgressMonitor progressMonitor) {
        val repositoryFolder = project.getFolder(artifactIdPrefix + ".repository")
        if (!repositoryFolder.exists) {
            repositoryFolder.create(false, true, progressMonitor)
        }
        
        var String content = repositoryCategoryXmlContent(artifactIdPrefix, version)
        FileGenerator.generateOrUpdateFile(repositoryFolder, "category.xml", content, progressMonitor)
        content = repositoryPomXmlContent(artifactIdPrefix, modelId, version)
        FileGenerator.generateOrUpdateFile(repositoryFolder, "pom.xml", content, progressMonitor)
        
        val siteTemplateFolder = project.getFolder(artifactIdPrefix + ".repository/siteTemplate")
        if (!siteTemplateFolder.exists) {
            siteTemplateFolder.create(false, true, progressMonitor)
        }
        
        content = repositoryIndexHtmlContent()
        FileGenerator.generateOrUpdateFile(siteTemplateFolder, "index.html", content, progressMonitor)
        content = repositoryP2IndexContent()
        FileGenerator.generateOrUpdateFile(siteTemplateFolder, "p2.index", content, progressMonitor)
    }
    
    private static def spvizPomXmlContent(String vizArtifactIdPrefix, String modelId, String version) {
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
                    <module>../spviz.build/de.cau.cs.kieler.spviz.targetplatform</module>
                    «FOR bundleSuffix : bundleSuffixes»
                        <module>../«vizArtifactIdPrefix».«bundleSuffix»</module>
                    «ENDFOR»
                    <module>../«modelId»</module>
                    <module>feature</module>
                    <module>«vizArtifactIdPrefix».repository</module>
                  </modules>
                </profile>
            
                <!-- The language server product. -->
                <profile>
                  <id>ls</id>
                  <modules>
                    <module>../spviz.build/de.cau.cs.kieler.spviz.targetplatform</module>
                    «FOR bundleSuffix : bundleSuffixes»
                        <module>../«vizArtifactIdPrefix».«bundleSuffix»</module>
                    «ENDFOR»
                    <module>../«modelId»</module>
                    <module>«vizArtifactIdPrefix».language.server.cli</module>
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
            
              <groupId>«vizArtifactIdPrefix»</groupId>
              <artifactId>«vizArtifactIdPrefix».«bundleSuffix»</artifactId>
              <version>«version»-SNAPSHOT</version>
              <packaging>eclipse-plugin</packaging>
            
              <build>
                  <sourceDirectory>src</sourceDirectory>
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
                  <import plugin="org.eclipse.core.runtime" version="3.12.0" match="compatible"/>
                  <import plugin="org.eclipse.emf.ecore"/>
                  <import plugin="org.eclipse.xtext.xbase.lib" version="2.16.0" match="greaterOrEqual"/>
                  <import plugin="org.eclipse.emf.ecore.xcore.lib"/>
                  <import plugin="org.eclipse.emf.edit"/>
                  <import plugin="org.eclipse.emf.ecore.edit"/>
                  <import plugin="org.eclipse.osgi" version="3.7.0" match="compatible"/>
                  <import plugin="org.eclipse.core.resources"/>
                  <import plugin="org.eclipse.emf.ecore.xmi" version="2.11.0" match="greaterOrEqual"/>
                  <import plugin="org.eclipse.emf.edit.ui"/>
                  <import plugin="org.eclipse.jface.text" version="3.2.0" match="compatible"/>
                  <import plugin="org.eclipse.ui.ide"/>
                  <import plugin="de.cau.cs.kieler.klighd" version="0.45.0" match="greaterOrEqual"/>
                  <import plugin="«modelId»" version="0.1.0" match="greaterOrEqual"/>
                  <import plugin="de.cau.cs.kieler.klighd.krendering.extensions" version="0.45.0" match="greaterOrEqual"/>
                  <import plugin="com.google.inject" version="3.0.0" match="greaterOrEqual"/>
                  <import plugin="org.eclipse.elk.core" version="0.5.0" match="greaterOrEqual"/>
                  <import plugin="org.eclipse.elk.alg.layered" version="0.6.0" match="greaterOrEqual"/>
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
              
              <groupId>«artifactIdPrefix»</groupId>
              <artifactId>«artifactIdPrefix».feature</artifactId>
              <version>«version»-SNAPSHOT</version>
              <packaging>eclipse-feature</packaging>
            </project>
            
        '''
    }
    
    private static def featureBuildPropertiesContent() {
        return '''
            bin.includes = feature.xml
            
        '''
    }
    
    private static def cliCategoryXmlContent(String artifactIdPrefix, String modelId) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <site>
               <description name="Language Server CLI for «artifactIdPrefix»">
                  Artificial Update site for the Language Server CLI.
               </description>
               <bundle id="de.cau.cs.kieler.klighd.ide"/>
               <bundle id="de.cau.cs.kieler.klighd.incremental"/>
               <bundle id="de.cau.cs.kieler.klighd.lsp"/>
               <bundle id="«artifactIdPrefix».viz"/>
               <bundle id="«artifactIdPrefix».language.server"/>
               <bundle id="«artifactIdPrefix».model"/>
               <bundle id="«modelId»"/>
            </site>
            
        '''
    }
    
    private static def cliPomXmlContent(String artifactIdPrefix, String vizName, String modelId, String version) {
        return '''
            <?xml version="1.0" encoding="UTF-8"?>
            <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
              <modelVersion>4.0.0</modelVersion>
            
              <version>«version»-SNAPSHOT</version>
              <artifactId>«artifactIdPrefix».language.server.cli</artifactId>
              <packaging>eclipse-repository</packaging>
              <name>Language Server CLI for «artifactIdPrefix»</name>
            
              <parent>
                <groupId>«artifactIdPrefix»</groupId>
                <artifactId>parent</artifactId>
                <version>«version»-SNAPSHOT</version>
                <relativePath>../pom.xml</relativePath>
              </parent>
            
              <properties>
                <category.file>${basedir}/category.xml</category.file>
                <update.site.jars>${project.build.directory}/repository/plugins</update.site.jars>

                <python.script>${basedir}/uberjar.py</python.script>
                <executableName>«artifactIdPrefix.split("\\.").last»-language-server</executableName>
                <mainClass>«artifactIdPrefix».language.server.«vizName»LanguageServer</mainClass>
                <python.script.output>${project.build.directory}/exe</python.script.output>
              </properties>
            
              <!-- See uberjar.py on the concept behind this build process -->
            
              <build>
                <plugins>
                  <plugin>
                    <groupId>org.eclipse.tycho</groupId>
                    <artifactId>tycho-p2-repository-plugin</artifactId>
                    <version>${tycho-version}</version>
                    <configuration>
                      <skipArchive>true</skipArchive>
                      <!-- Build self-contained update site for uber-jar -->
                      <includeAllDependencies>true</includeAllDependencies>
                    </configuration>
                  </plugin>
            
                  <plugin>
                    <groupId>org.codehaus.mojo</groupId>
                    <artifactId>exec-maven-plugin</artifactId>
                    <version>1.6.0</version>
                    <executions>
                      <execution>
                        <phase>package</phase>
                        <goals>
                          <goal>exec</goal>
                        </goals>
                      </execution>
                    </executions>
                    <configuration>
                      <executable>python</executable>
                      <workingDirectory>${project.build.directory}</workingDirectory>
                      <arguments>
                        <argument>${python.script}</argument>
                        <argument>${update.site.jars}</argument>
                        <argument>${executableName}</argument>
                        <argument>${mainClass}</argument>
                        <argument>${python.script.output}</argument>
                        <argument>${project.build.directory}</argument>
                      </arguments>
                    </configuration>
                  </plugin>
                </plugins>
              </build>
            </project>
            
        '''
    }
    
    private static def cliUberJarPyContent(String artifactIdPrefix, String modelId, String version) {
        return '''
            # KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
            # http://www.informatik.uni-kiel.de/rtsys/kieler/
            #
            # Copyright 2019 by
            # + Kiel University
            #   + Department of Computer Science
            #     + Real-Time and Embedded Systems Group
            #
            # This program and the accompanying materials are made available under the
            # terms of the Eclipse Public License 2.0 which is available at
            # http://www.eclipse.org/legal/epl-2.0.
            #
            # SPDX-License-Identifier: EPL-2.0
            
            #
            # This script bundles a self-contained eclipse update site into an executable uber-jar (no shading!) and several platform specific executable scripts bundling the jar.
            # Author: Alexander Schulz-Rosengarten <als@informatik.uni-kiel.de>
            #
            
            # General Documentation:
            # The idea of having an executable non-eclipse application with eclipse plugins is to bundle them into a uber/fat jar containing all dependencies.
            # Usually this job is done by the maven-shade-plugin. However, since we build our plugins with tycho and have a defined target platform for dependency resolution, this system is incompatible with maven-shade. maven-shade would require to redefine each dependency explicitly and from a maven repository.
            # Hence, we build a self-contained update side using tycho, this way we have all our dependencies automatically and correctly resolve without any redefinitions and we can build only specific plugins into the executable.
            # Then this script bundles the jars in the update side into one uber jar.
            # In contrast to maven-shade this script cannot 'shade' dependencies. If this should be necessary in the future, it might be a solution to process the update side by another build run using maven-shade and some pom file generated by a script to correctly defining the dependencies to include.
            
            from __future__ import print_function # python3 print
            
            import os
            import sys
            import shutil
            import argparse
            from subprocess import check_call
            from fnmatch import fnmatch
            from os.path import isfile, isdir, join, abspath, relpath, dirname, basename
            
            IGNORED_JARS = [
                'org.apache.ant*',
            ]
            IGNORE_NESTED_JARS = [
            ]
            IGNORED_FILES = [
                'org/*/*.java',
                'com/*/*.java',
                'de/*/*.java',
                'module-info.class',
                '*._trace',
                '*.g',
                '*.mwe2',
                '*.xtext',
                '*.genmodel',
                '*.ecore',
                '*.ecorediag',
                '*.html',
                '*.profile',
                '.api_description',
                '.options',
                'log4j.properties',
                'about.*',
                'about_*',
                'about_files/*',
                'cheatsheets/*',
                'META-INF/*.DSA',
                'META-INF/*.RSA',
                'META-INF/*.SF',
                'META-INF/changelog.txt',
                'META-INF/DEPENDENCIES',
                'META-INF/eclipse.inf',
                'META-INF/INDEX.LIST',
                'META-INF/MANIFEST.MF', # not sure if we have to merge the content somehow?
                'META-INF/maven/*',
                'META-INF/NOTICE.txt',
                'META-INF/NOTICE',
                'META-INF/p2.inf',
                'OSGI-INF/l10n/bundle.properties',
                'docs/*',
                '*readme.txt',
                'plugin.xml',
                'schema/*',
                'profile.list',
                'systembundle.properties',
                'version.txt',
                'xtend-gen/*',
            ]
            APPEND_MERGE = [
                'plugin.properties',
                'META-INF/services/*',
                'META-INF/LICENSE.txt',
                'META-INF/LICENSE',
            ]
            IGNORE_MERGE = [
                'eclipse32.png',
                'modeling32.png',
                'icons/*.png', # Assuming icons are always the same if they have the same name or de.* overrides org.*
                'icons/*.gif',
                'epl-v20.html',
                'org/osgi/service/log/*', # known duplicate in org.eclipse.osgi and org.eclipse.osgi.services,
                'META-INF/AL*',
                'META-INF/LGPL*',
                'META-INF/GPL*',
            ]
            
            # Special klighd handling
            KLIGHD_JARS_BLACKLIST = [
                'org.eclipse.ui*',
                'org.eclipse.e4*',
                'org.eclipse.*.ui*',
            ]
            KLIGHD_JARS_WHITELIST = [
                'org.eclipse.ui.workbench_*',
                'org.eclipse.ui.ide_*', # For some reason IStorageEditorInput is required
            ]
            KLIGHD_IGNORED_FILES = [
                'org/eclipse/ui/[!I]*', # Keep Interfaces for Klighd
                'org/eclipse/ui/*/*',
                'org.eclipse.ui.ide*/icons/*',
                'fragment.properties',
            ]
            klighd_swt = {}
            
            def main(args):
                print('-- Creating uber jar --')
            
                extracted = abspath(join(args.build, 'extracted'))
                merged = abspath(join(args.build, 'merged'))
            
                # Check input
                if not isdir(args.source):
                    stop('%s is not a directory' % args.source)
            
                # Create build folders
                if isdir(extracted):
                    shutil.rmtree(extracted)
                else:
                    os.mkdir(extracted)
                if isdir(merged):
                    shutil.rmtree(merged)
                else:
                    os.mkdir(merged)
            
                target_dir = abspath(args.target)
            
                # Check klighd
                jars = os.listdir(args.source)
                klighd = any(jar.startswith('de.cau.cs.kieler.klighd') for jar in jars)
                if klighd:
                    print('Detected Klighd. Activated special handling of Eclipse UI and SWT dependencies.')
            
                # Extract
                conflicts = extract(args, extracted, merged, klighd)
                if conflicts and not args.ignore_conflicts:
                    stop('Stopping build due to merge conflicts.')
            
                # Bundle into jar
                bundle(args, target_dir, merged, klighd)
            
            def extract(args, extracted, merged, klighd):
                conflicts = False
                jars = sorted(os.listdir(args.source))
                processed_jars = [] # Tuples of plugin name and jar
                for jar in jars:
                    if not jar.endswith('.jar') or any(fnmatch(jar, ign) for ign in IGNORED_JARS):
                        print('Skipping file:', jar)
                        continue
                    elif klighd and any(fnmatch(jar, ign) for ign in KLIGHD_JARS_BLACKLIST) and not any(fnmatch(jar, req) for req in KLIGHD_JARS_WHITELIST):
                        print('Skipping file (special klighd handling):', jar)
                        continue
                    elif jar.split("_")[0] in (p[0] for p in processed_jars):
                        print('Multiple versions of the same plugin detected.')
                        print('WARNING: This script does not support shading. Only the lower version of this plugin will be used (%s). This will cause runtime errors if any plugin requires a higher version API.' % next((p[1] for p in processed_jars if p[0] == jar.split("_")[0]), None))
                        print('Skipping file:', jar)
                        continue
                    else:
                        print('Extracting jar:', jar)
                        target = abspath(join(extracted, jar[:-4]))
                        if not isdir(target):
                            os.makedirs(target)
            
                        # Unpack jar
                        check_call([args.jar, 'xf', abspath(join(args.source, jar))], cwd=target)
            
                        if klighd and jar.startswith('org.eclipse.swt.'): # Do not merge swt fragments
                            if 'gtk.linux.x86_64' in jar:
                                klighd_swt['linux'] = target
                            elif 'win32.win32.x86_64' in jar:
                                klighd_swt['win'] = target
                            elif 'cocoa.macosx.x86_64' in jar:
                                klighd_swt['osx'] = target
                            else:
                                stop('Unknown platform-specific SWT fragment: ', jar)
                            # Remove unwanted files from fragment directory
                            for root, dirs, files in os.walk(target):
                                for file in (relpath(join(root, f), target) for f in files):
                                    if any(fnmatch(file, pattern) for pattern in IGNORED_FILES) or any(fnmatch(file, pattern) for pattern in KLIGHD_IGNORED_FILES):
                                        os.remove(join(target, file))
                        else: # Merge content
                            if not any(fnmatch(jar, ign) for ign in IGNORE_NESTED_JARS):
                                # Append nested jars for later unpacking
                                jars.extend(j for j in handleNestedJarsOnClasspath(target, args.source) if j not in jars)
                            # Merge jar content into single folder
                            for root, dirs, files in os.walk(target):
                                for file in (relpath(join(root, f), target) for f in files):
                                    if any(fnmatch(file, pattern) for pattern in IGNORED_FILES):
                                        continue #skip
                                    if klighd and any(fnmatch(file, pattern) for pattern in KLIGHD_IGNORED_FILES):
                                        continue #skip
            
                                    src = join(target, file)
                                    dest = join(merged, file)
            
                                    if isfile(dest): # potential conflict
                                        if any(fnmatch(file, match) for match in APPEND_MERGE): # merge by append
                                            with open(src, 'r') as i:
                                                with open(dest, 'a') as o:
                                                    o.write('\n')
                                                    o.write(i.read())
                                        elif any(fnmatch(file, match) for match in IGNORE_MERGE): # merge by ignoring overriders, assuming identical files ;)
                                            pass
                                        else:
                                            errPrint('[ERROR] Could not merge', jar, 'Conflicting file:', file)
                                            conflicts = True
                                    else:
                                        if not isdir(dirname(dest)):
                                            os.makedirs(dirname(dest))
                                        os.rename(src, dest)
                            processed_jars.append((jar.split("_")[0], jar))
                return conflicts
            
            def handleNestedJarsOnClasspath(dir, jars_dir):
                jars = []
                manifest = join(dir, join('META-INF', 'MANIFEST.MF'))
                if isfile(manifest):
                    with open(manifest, 'r') as file:
                        lines = file.readlines()
                        classpath = None
                        for line in lines:
                            if 'Bundle-ClassPath:' in line: # start of classpath
                                startCP = line[17:].strip()
                                classpath = startCP if startCP else " " # assure truthy content if found
                            elif classpath and ':' in line: # end of classpath
                                break
                            elif classpath: # continue classpath collection
                                classpath += line.strip()
                        if classpath:
                            for cp in classpath.split(','):
                                cpFile = cp.strip()
                                if cpFile and cpFile != '.' and '.jar' in cpFile:
                                    jarFile = join(dir, cpFile)
                                    if isfile(jarFile):
                                        print('Found nested jar on bundle class path: ', cpFile)
                                        os.rename(jarFile, join(jars_dir, basename(jarFile))) # Move to input folder
                                        jars.append(basename(jarFile))
                                    else:
                                        print('[Warning] Could not find file for nested jar on bundle class path: ', cpFile)
                return jars
            
            
            def bundle(args, target_dir, merged, klighd):
                jar = join(target_dir, args.name + '.jar')
                print('Creating jar:', relpath(jar, target_dir))
                if not isdir(dirname(jar)):
                    os.makedirs(dirname(jar))
            
                check_call([args.jar, 'cfe', jar, args.main, '.'], cwd=merged)
            
                if klighd: # Include SWT
                    jars = {}
                    for platform in klighd_swt.keys():
                        pjar = jar[:-4] + '.' + platform + '.jar'
                        print('Creating jar:', relpath(pjar, target_dir))
            
                        shutil.copy(jar, pjar) # copy SWT-less base jar
                        check_call([args.jar, 'uf', pjar, '.'], cwd=klighd_swt[platform]) # Bundle platform-spefic SWT into new platform-spefic jar
                        
                        jars[platform] = pjar
            
                    print('Removing jar:', relpath(jar, target_dir))
                    os.remove(jar) # remove SWT-less base jar
                    return jars
                else:
                    return jar
            
            def stop(msg):
                errPrint('[ERROR] ' + msg)
                sys.exit(2)
            
            def errPrint(*args, **kwargs):
                sys.stdout.flush() # ensure the context is clear
                print(*args, file=sys.stderr, **kwargs)
                sys.stderr.flush()
            
            if __name__ == '__main__':
                argParser = argparse.ArgumentParser(description='This script bundles a self-contained eclipse update site into an executable uber-jar (no shading!).')
                argParser.add_argument('-jar', default='jar', help='override jar command to adjust java version, e.g. /usr/lib/jvm/java-11-openjdk-amd64/bin/jar')
                argParser.add_argument('--java8', dest='java8', action='store_true', help='activate Java 8 support')
                argParser.add_argument('--ignore-conflicts', dest='ignore_conflicts', action='store_true', help='prevents failing if merge fail due to a conflict.')
                argParser.add_argument('source', help='directory containing all plugins that should be bundled (self-contained update site)')
                argParser.add_argument('name', help='name of the generated executable jar')
                argParser.add_argument('main', help='main class of the generated jar')
                argParser.add_argument('target', help='target directory to store generated jars')
                argParser.add_argument('build', help='directory for storing intermediate results')
                try:
                    main(argParser.parse_args())
                except KeyboardInterrupt:
                    print('\nAbort')
                    sys.exit(0)
            
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
               
                <repository-reference location="https://download.eclipse.org/releases/2021-06/" enabled="true" />
                <repository-reference location="https://archive.eclipse.org/lsp4j/updates/releases/0.10.0/" enabled="true" />
                <repository-reference location="https://download.eclipse.org/tools/orbit/downloads/drops/R20210602031627/repository/" enabled="true" />
                <repository-reference location="https://download.eclipse.org/modeling/tmf/xtext/updates/releases/2.25.0/" enabled="true" />
                <repository-reference location="https://download.eclipse.org/elk/updates/releases/0.7.1/" enabled="true" />
                <repository-reference location="https://rtsys.informatik.uni-kiel.de/~kieler/updatesite/nightly/klighd/" enabled="true" />
                <repository-reference location="https://rtsys.informatik.uni-kiel.de/~kieler/updatesite/sprotty/0.9.0/" enabled="true" />
            
            </site>
            
        '''
    }
    
    private static def repositoryPomXmlContent(String artifactIdPrefix, String modelId, String version) {
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
              
              <properties>
                <update.site.name>«artifactIdPrefix»</update.site.name>
                <update.site.description>P2 Update Site for «artifactIdPrefix»</update.site.description>
                <update.site.version>${kieler-version}</update.site.version>
                <target.eclipse.version>2021-06</target.eclipse.version>
              </properties>
            
              <build>
                <plugins>
                  <plugin>
                    <groupId>org.jboss.tools.tycho-plugins</groupId>
                    <artifactId>repository-utils</artifactId>
                    <version>1.1.1-SNAPSHOT</version>
                    <executions>
                    
                      <!-- creates index.html and other artifacts -->
                      <execution>
                        <id>generate-facade</id>
                        <phase>package</phase>
                        <goals>
                          <goal>generate-repository-facade</goal>
                        </goals>
                        <configuration>
                          <siteTemplateFolder>siteTemplate</siteTemplateFolder>
                          <symbols>
                            <update.site.name>${update.site.name}</update.site.name>
                            <update.site.description>${update.site.description}</update.site.description>
                            <update.site.version>${update.site.version}</update.site.version>
                            <target.eclipse.version>${target.eclipse.version}</target.eclipse.version>
                          </symbols>
                        
                          <!-- this adds repository references to the update site's content.xml -->
                          <associateSites>
                            <associateSite>https://download.eclipse.org/releases/2021-06</associateSite>
                            <associateSite>https://download.eclipse.org/modeling/tmf/xtext/updates/releases/2.25.0/</associateSite>
                            <associateSite>https://download.eclipse.org/elk/updates/releases/0.7.1/</associateSite>
                            <associateSite>https://kieler.github.io/KLighD/v2.1.0/</associateSite>
                            <associateSite>https://download.eclipse.org/tools/orbit/downloads/drops/R20210602031627/repository/</associateSite>
                          </associateSites>
                        </configuration>
                      </execution>
                    </executions>
                  </plugin>
                </plugins>
              </build>
            </project>
            
        '''
    }
    
    private static def repositoryIndexHtmlContent() {
        return '''
            <html>
            <head>
            <title>${update.site.name} - ${update.site.description} Update Site: ${update.site.version}</title>
            <link rel="stylesheet" type="text/css" href="web/site.css">
            </head>
            <body marginheight="0" marginwidth="0" leftmargin="0" topmargin="0">
            <center>
            <table cellspacing="0" cellpadding="0" class="table">
              <tr>
                <td>
                <h2 class="title"><br/><br/>${update.site.name} - ${update.site.description} Update Site</h2>
                <table width="100%">
                  <tr class="header">
                    <td class="sub-header" width="100%"><span>Latest Build: ${update.site.version}</span></td>
                  </tr>
            
                  <tr class="light-row" style="height: 30px">
                    <td class="bodyText">
                      <p class="bodyText">
                        This is the <b>${update.site.description}</b>
                        Update Site for ${update.site.name}.
                        <blockquote style="border: 1px dashed #1778be; padding: 2px">
                          <ol>
                            <li>To install from this site, start up Eclipse ${target.eclipse.version}, then do:
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