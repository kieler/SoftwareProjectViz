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
package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spvizmodel.generator.FileGenerator
import java.io.File

/**
 * Generates language server classes for the visualization.
 * 
 * @author nre
 */
class GenerateLanguageServer {
    
    def static void generate(File sourceFolder, File launchFolder, DataAccess data, boolean noModelDsl, boolean noDiff) {
        
        val String bundleNamePrefix = data.getBundleNamePrefix
        val File folder = FileGenerator.createDirectory(sourceFolder, bundleNamePrefix.replace('.','/') + "/language/server")
        
        var String content = generateLanguageRegistration(data, noModelDsl, noDiff)
        FileGenerator.updateFile(folder, data.visualizationName + "LanguageRegistration.xtend", content)
        content = generateLanguageServer(data)
        FileGenerator.updateFile(folder, data.visualizationName + "LanguageServer.xtend", content)
        content = generateLsCreator(data)
        FileGenerator.updateFile(folder, data.visualizationName + "LsCreator.xtend", content)
        content = generateRegistrationLsExt(data, noModelDsl, noDiff)
        FileGenerator.updateFile(folder, data.visualizationName + "RegistrationLsExt.xtend", content)
        content = generateLaunchConfig(data, noModelDsl, noDiff)
        FileGenerator.generateFile(launchFolder, data.visualizationName + " Launguage Server.launch", content)
    }
    
    /**
     * Generates the content for the [vizname]LanguageRegistration class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return
     *         the generated file content as a string
     */
    def static String generateLanguageRegistration(DataAccess data, boolean noModelDsl, boolean noDiff) {
        return '''
            package «data.getBundleNamePrefix».language.server
            
            import de.cau.cs.kieler.kgraph.text.ide.KGraphLSSetup
            import de.cau.cs.kieler.klighd.lsp.launch.ILanguageRegistration
            import «data.getBundleNamePrefix».model.«data.visualizationName.toFirstUpper»Package
            import «data.modelBundleNamePrefix».model.«data.spvizModel.name.toFirstUpper»Package
            «IF !noModelDsl»
                import «data.modelBundleNamePrefix».model.dsl.«data.spvizModel.name.toFirstUpper»DslStandaloneSetup
            «ENDIF»
            «IF !noDiff»
                import «data.modelBundleNamePrefix».diff.dsl.«data.spvizModel.name.toFirstUpper»DiffDslStandaloneSetup
            «ENDIF»
            import org.eclipse.emf.ecore.resource.Resource
            import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
            
            /**
             * Binds and registers the KGraph language and sets up usage for the «data.spvizModel.name»(-viz) models.
             * 
             * @author nre
             */
            class «data.visualizationName.toFirstUpper»LanguageRegistration implements ILanguageRegistration {
                
                override bindAndRegisterLanguages() {
                    // There needs to be at least one XText language supported, as the KGraphLSExtension fails otherwise bc of that.
                    // "No Xtext languages have been registered. Please make sure you have added the languages\'s setup class in \'/META-INF/services/org.eclipse.xtext.ISetup\'
                    // in LanguageServerImpl.
                    KGraphLSSetup.doLSSetup
                    // Initialize the model packages by making sure they have been called.
                    var modelPackageInstance = «data.spvizModel.name.toFirstUpper»Package.eINSTANCE
                    var vizmodelPackageInstance = «data.visualizationName.toFirstUpper»Package.eINSTANCE
                    
                    // use the variables to remove unused warning
                    modelPackageInstance = modelPackageInstance
                    vizmodelPackageInstance = vizmodelPackageInstance
                    
                    Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap.put("«data.spvizModel.name.toLowerCase»", new XMIResourceFactoryImpl)
                    Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap.put("«data.visualizationName.toLowerCase»", new XMIResourceFactoryImpl)
                    «IF !noModelDsl»
                        
                        // Register model DSL language.
                        «data.spvizModel.name.toFirstUpper»DslStandaloneSetup.doSetup
                    «ENDIF»
                    «IF !noDiff»
                        
                        // Register diff DSL language.
                        «data.spvizModel.name.toFirstUpper»DiffDslStandaloneSetup.doSetup
                    «ENDIF»
                }
            }
            
        '''
    }
    
    /**
     * Generates the content for the [vizname]LanguageServer class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return
     *         the generated file content as a string
     */
    def static String generateLanguageServer(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».language.server
            
            import de.cau.cs.kieler.klighd.lsp.launch.AbstractLanguageServer
            
            /**
             * Entry point for the language server application for «data.visualizationName.toFirstUpper».
             * 
             * @see AbstractLanguageServer
             * @author nre
             */
            class «data.visualizationName.toFirstUpper»LanguageServer extends AbstractLanguageServer {
                
                def static main(String[] args) {
                    val server = new «data.visualizationName.toFirstUpper»LanguageServer
                    server.configureAndRun(new «data.visualizationName.toFirstUpper»LanguageRegistration, new «data.visualizationName.toFirstUpper»LsCreator)
                }
                
            }
            
        '''
    }
    
    /**
     * Generates the content for the [vizname]LsCreator class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return
     *         the generated file content as a string
     */
    def static String generateLsCreator(DataAccess data) {
        return '''
            package «data.getBundleNamePrefix».language.server
            
            import de.cau.cs.kieler.klighd.lsp.KGraphLanguageClient
            import de.cau.cs.kieler.klighd.lsp.launch.AbstractLsCreator
            import java.util.List
            import org.eclipse.xtext.ide.server.ILanguageServerExtension
            
            /** 
             * Provides methods to create a LS.
             * This involves binding of modules and creating, starting, and configure logging for an LS.
             * 
             * @author nre
             */
            class «data.visualizationName.toFirstUpper»LsCreator extends AbstractLsCreator {
                
                override getLanguageServerExtensions() {
                    val List<ILanguageServerExtension> iLanguageServerExtensions = #[
                        injector.getInstance(«data.visualizationName.toFirstUpper»RegistrationLsExt)
                    ]
                    return iLanguageServerExtensions
                }
                
                override getRemoteInterface() {
                    KGraphLanguageClient
                }
                
            }
            
        '''
    }
    
    /**
     * Generates the content for the [vizname]RegistrationLsExt class.
     * 
     * @param data
     *         a DataAccess to easily get the information from
     * @return
     *         the generated file content as a string
     */
    def static String generateRegistrationLsExt(DataAccess data, boolean noModelDsl, boolean noDiff) {
        return '''
            package «data.getBundleNamePrefix».language.server
            
            import com.google.inject.Singleton
            import de.cau.cs.kieler.klighd.lsp.launch.AbstractRegistrationLanguageServerExtension
            import de.cau.cs.kieler.klighd.lsp.launch.Language
            
            /**
             * Extends the language server with support for the «data.spvizModel.name» model and visualization languages.
             * 
             * @author nre
             */
             @Singleton
            class «data.visualizationName.toFirstUpper»RegistrationLsExt extends AbstractRegistrationLanguageServerExtension {
                
                override getLanguageExtensions() {
                    return newArrayList(
                        «IF !noModelDsl»
                            new Language("«data.spvizModel.name.toLowerCase»dsl", "«data.spvizModel.name» Model DSL", #[
                            "projectName", "external",
                                «FOR artifact : data.artifacts SEPARATOR ", "»
                                    "«artifact.name.toFirstLower»", "«artifact.name.toFirstLower»s"
                                «ENDFOR»
                                «FOR connection : data.connections BEFORE ", " SEPARATOR ", "»
                                    "«connection.name.toFirstLower»"
                                «ENDFOR»
                            ]),
                        «ENDIF»
                        «IF !noDiff»
                            new Language("«data.visualizationName.toLowerCase»diffdsl", "«data.visualizationName» Diff DSL", #[
                                "compare",
                                "to"
                            ]),
                        «ENDIF»
                        new Language("«data.spvizModel.name.toLowerCase»", "«data.spvizModel.name» Model", #[]),
                        new Language("«data.visualizationName.toLowerCase»", "«data.visualizationName» Model", #[])
                    )
                }
                
            }
            
        '''
    }
    
    def static String generateLaunchConfig(DataAccess data, boolean noModelDsl, boolean noDiff) {
        return '''
            <?xml version="1.0" encoding="UTF-8" standalone="no"?>
            <launchConfiguration type="org.eclipse.jdt.launching.localJavaApplication">
                <listAttribute key="org.eclipse.debug.core.MAPPED_RESOURCE_PATHS">
                    <listEntry value="/«data.bundleNamePrefix».language.server/xtend-gen/«data.bundleNamePrefix.replace('.', '/')»/language/server/«data.visualizationName.toFirstUpper»LanguageServer.java"/>
                </listAttribute>
                <listAttribute key="org.eclipse.debug.core.MAPPED_RESOURCE_TYPES">
                    <listEntry value="1"/>
                </listAttribute>
                <booleanAttribute key="org.eclipse.jdt.launching.ATTR_ATTR_USE_ARGFILE" value="false"/>
                <booleanAttribute key="org.eclipse.jdt.launching.ATTR_SHOW_CODEDETAILS_IN_EXCEPTION_MESSAGES" value="true"/>
                <booleanAttribute key="org.eclipse.jdt.launching.ATTR_USE_CLASSPATH_ONLY_JAR" value="false"/>
                <booleanAttribute key="org.eclipse.jdt.launching.ATTR_USE_START_ON_FIRST_THREAD" value="true"/>
                <listAttribute key="org.eclipse.jdt.launching.CLASSPATH">
                    <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry containerPath=&quot;org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-21&quot; path=&quot;5&quot; type=&quot;4&quot;/&gt;&#10;"/>
                    <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry path=&quot;5&quot; projectName=&quot;«data.bundleNamePrefix».language.server&quot; type=&quot;1&quot;/&gt;&#10;"/>
                    <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry internalArchive=&quot;/«data.bundleNamePrefix».language.server&quot; path=&quot;5&quot; type=&quot;2&quot;/&gt;&#10;"/>
                    <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry path=&quot;5&quot; projectName=&quot;«data.bundleNamePrefix».model&quot; type=&quot;1&quot;/&gt;&#10;"/>
                    <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry internalArchive=&quot;/«data.bundleNamePrefix».model&quot; path=&quot;5&quot; type=&quot;2&quot;/&gt;&#10;"/>
                    <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry path=&quot;5&quot; projectName=&quot;«data.bundleNamePrefix».viz&quot; type=&quot;1&quot;/&gt;&#10;"/>
                    <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry internalArchive=&quot;/«data.bundleNamePrefix».viz&quot; path=&quot;5&quot; type=&quot;2&quot;/&gt;&#10;"/>
                    <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry path=&quot;5&quot; projectName=&quot;«data.modelBundleNamePrefix».model&quot; type=&quot;1&quot;/&gt;&#10;"/>
                    <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry internalArchive=&quot;/«data.modelBundleNamePrefix».model&quot; path=&quot;5&quot; type=&quot;2&quot;/&gt;&#10;"/>
                    «IF !noModelDsl»
                        <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry path=&quot;5&quot; projectName=&quot;«data.modelBundleNamePrefix».model.dsl&quot; type=&quot;1&quot;/&gt;&#10;"/>
                        <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry internalArchive=&quot;/«data.modelBundleNamePrefix».model.dsl&quot; path=&quot;5&quot; type=&quot;2&quot;/&gt;&#10;"/>
                        <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry path=&quot;5&quot; projectName=&quot;«data.modelBundleNamePrefix».model.dsl.ide&quot; type=&quot;1&quot;/&gt;&#10;"/>
                        <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry internalArchive=&quot;/«data.modelBundleNamePrefix».model.dsl.ide&quot; path=&quot;5&quot; type=&quot;2&quot;/&gt;&#10;"/>
                    «ENDIF»
                    «IF !noDiff»
                        <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry path=&quot;5&quot; projectName=&quot;«data.bundleNamePrefix».diffviz&quot; type=&quot;1&quot;/&gt;&#10;"/>
                        <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry internalArchive=&quot;/«data.bundleNamePrefix».diffviz&quot; path=&quot;5&quot; type=&quot;2&quot;/&gt;&#10;"/>
                        <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry path=&quot;5&quot; projectName=&quot;«data.modelBundleNamePrefix».diff.dsl&quot; type=&quot;1&quot;/&gt;&#10;"/>
                        <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry internalArchive=&quot;/«data.modelBundleNamePrefix».diff.dsl&quot; path=&quot;5&quot; type=&quot;2&quot;/&gt;&#10;"/>
                        <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry path=&quot;5&quot; projectName=&quot;«data.modelBundleNamePrefix».diff.dsl.ide&quot; type=&quot;1&quot;/&gt;&#10;"/>
                        <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry internalArchive=&quot;/«data.modelBundleNamePrefix».diff.dsl.ide&quot; path=&quot;5&quot; type=&quot;2&quot;/&gt;&#10;"/>
                    «ENDIF»
                    <listEntry value="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;&#10;&lt;runtimeClasspathEntry containerPath=&quot;org.eclipse.m2e.MAVEN2_CLASSPATH_CONTAINER&quot; path=&quot;5&quot; type=&quot;4&quot;/&gt;&#10;"/>
                </listAttribute>
                <stringAttribute key="org.eclipse.jdt.launching.CLASSPATH_PROVIDER" value="org.eclipse.m2e.launchconfig.classpathProvider"/>
                <booleanAttribute key="org.eclipse.jdt.launching.DEFAULT_CLASSPATH" value="false"/>
                <stringAttribute key="org.eclipse.jdt.launching.MAIN_TYPE" value="«data.bundleNamePrefix».language.server.«data.visualizationName»LanguageServer"/>
                <listAttribute key="org.eclipse.jdt.launching.MODULEPATH"/>
                <stringAttribute key="org.eclipse.jdt.launching.MODULE_NAME" value="«data.bundleNamePrefix».language.server"/>
                <stringAttribute key="org.eclipse.jdt.launching.PROJECT_ATTR" value="«data.bundleNamePrefix».language.server"/>
                <stringAttribute key="org.eclipse.jdt.launching.SOURCE_PATH_PROVIDER" value="org.eclipse.m2e.launchconfig.sourcepathProvider"/>
                <stringAttribute key="org.eclipse.jdt.launching.VM_ARGUMENTS" value="-Dport=5007"/>
            </launchConfiguration>
            
        '''
    }
    
}
