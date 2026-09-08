/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2024-2026 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * + and Scheidt & Bachmann System Technik GmbH, 24109 Melsdorf
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */

package de.cau.cs.kieler.spviz.cli

import de.cau.cs.kieler.spviz.spviz.SPVizStandaloneSetup
import de.cau.cs.kieler.spviz.spviz.generator.SPVizGenerator
import de.cau.cs.kieler.spviz.spviz.sPViz.SPViz
import de.cau.cs.kieler.spviz.spvizmodel.SPVizModelStandaloneSetup
import de.cau.cs.kieler.spviz.spvizmodel.generator.SPVizModelGenerator
import java.io.BufferedReader
import java.io.File
import java.io.IOException
import java.io.InputStreamReader
import java.nio.file.Path
import java.util.ArrayList
import java.util.List
import java.util.concurrent.Callable
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.resource.IResourceServiceProvider
import org.eclipse.xtext.resource.XtextResourceSet
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.validation.CheckMode
import org.eclipse.xtext.validation.Issue
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import picocli.CommandLine
import picocli.CommandLine.Command
import picocli.CommandLine.Option
import picocli.CommandLine.Parameters

/**
 * A command line tool to generate projects from SPViz DSL files.
 * This can be configured via command line parameters.
 *
 * @author nre
 */
@Command(name = "spviz", versionProvider = SPVizVersionProvider,
    footer = "\nFor guided SPViz workflows, use the 'spviz-orientation' AI skill and related other SPViz skills released alongside this CLI.")
class SPVizCLI implements Callable<Integer> {
    
    static final Logger LOGGER = LoggerFactory.getLogger(SPVizCLI)
    
    /**
     * All files for which this tool should generate the projects. Only accepts .spvizmodel and .spviz files.
     */
    @Parameters(arity = "1..*", description = "Any number of .spvizmodel or .spviz input files. Other file types are rejected.")
    protected List<File> files = new ArrayList

    /**
     * The validated .spvizmodel resources given to this tool.
     */
    List<Resource> spvizModelResources = new ArrayList
    
    /**
     * The validated .spviz resources given to this tool.
     */
    List<Resource> spvizResources = new ArrayList

    /**
     * The paths to the folders of the projects, that should be documented.
     */
    @Option(names = #["-o", "--output"], paramLabel = "OUTPUT-PATH", defaultValue = ".",
            description = "The path to the output folder where the generated projects should be stored. Defaults to the current working directory.")
    protected Path output
    
    @Option(names = #["-h", "--help"], usageHelp = true, description = "display a help message")
    protected boolean help

    @Option(names = #["-V", "--version"], versionHelp = true, description = "display version info")
    protected boolean version
    
    @Option(names = #["-b", "--build"], defaultValue = "false", description = "Automatically build the generated visualization projects with Maven.")
    protected boolean build
    
    @Option(names = #["-g", "--build-generator"], defaultValue = "false", description = "Automatically build the generator projects with Maven.")
    protected boolean buildGenerator
    
    @Option(names = #["--no-model-dsl"], defaultValue = "false", description = "Skip generating the model DSL for your architecture model and skip incorporating them into the build process.")
    protected boolean noModelDsl
    
    @Option(names = #["--no-diff"], defaultValue = "false", description = "Skip generating the difference visualization and its DSL and skip incorporating them into the build process.")
    protected boolean noDiff
    
    @Option(names = #["--validate"], defaultValue = "false",
            description = "Only validate the input files for their syntax and referenced artifacts and do not generate anything.")
    protected boolean validate

    /**
     * Main entry point for this command line tool.
     */
    def static void main(String[] args) {
        val CommandLine cl = new CommandLine(new SPVizCLI())
        System.exit(cl.execute(args))
    }
    
    override Integer call() {
        val validationResult = validate()
        if (validationResult !== CommandLine.ExitCode.OK || validate) {
            return validationResult
        }

        return generate()
    }

    /**
     * Validates the input files and their referenced resources.
     *
     * @return The corresponding {@link CommandLine.ExitCode}
     */
    def int validate() {
        spvizModelResources.clear
        spvizResources.clear
        if (files.empty) {
            LOGGER.error("No .spvizmodel or .spviz files were provided.")
            return CommandLine.ExitCode.SOFTWARE
        }

        // Prepare loading the files.
        SPVizModelStandaloneSetup.doSetup
        SPVizStandaloneSetup.doSetup

        val XtextResourceSet resourceSet = new XtextResourceSet
        val List<Resource> modelResources = new ArrayList
        val List<Resource> visualizationResources = new ArrayList
        var boolean errors = false
        for (file : files) {
            if (!file.name.endsWith(".spvizmodel") && !file.name.endsWith(".spviz")) {
                LOGGER.error("Unsupported input file (expected .spvizmodel or .spviz): {}", file.absolutePath)
                errors = true
            } else if (!file.isFile) {
                LOGGER.error("File does not exist: {}", file.absolutePath)
                errors = true
            } else {
                try {
                    val resource = resourceSet.getResource(URI.createFileURI(file.absoluteFile.absolutePath), true)
                    if (file.name.endsWith(".spvizmodel")) {
                        modelResources.add(resource)
                    } else {
                        visualizationResources.add(resource)
                    }
                } catch (Exception exception) {
                    LOGGER.error("Could not load " + file.absolutePath + ".", exception)
                    errors = true
                }
            }
        }

        // Validate after all resources are loaded.
        // Loading .spviz files may load more models into the resource set, so run through with a counter and re-check size every iteration.       
        var resourceIndex = 0
        while (resourceIndex < resourceSet.resources.size) {
            val resource = resourceSet.resources.get(resourceIndex)
            val serviceProvider = IResourceServiceProvider.Registry.INSTANCE.getResourceServiceProvider(resource.URI)
            if (serviceProvider === null || serviceProvider.resourceValidator === null) {
                LOGGER.error("No validator is registered for {}.", resource.URI)
                errors = true
            } else {
                try {
                    val issues = serviceProvider.resourceValidator.validate(resource, CheckMode.ALL, CancelIndicator.NullImpl)
                    for (issue : issues) {
                        reportIssue(resource, issue)
                        if (issue.severity === Severity.ERROR) {
                            errors = true
                        }
                    }
                } catch (Exception exception) {
                    LOGGER.error("Could not validate " + resource.URI + ".", exception)
                    errors = true
                }
            }
            resourceIndex++
        }

        if (errors) {
            LOGGER.error("SPViz validation failed.")
            return CommandLine.ExitCode.SOFTWARE
        }

        spvizModelResources.addAll(modelResources)
        spvizResources.addAll(visualizationResources)
        LOGGER.info("SPViz validation succeeded.")
        return CommandLine.ExitCode.OK
    }

    /**
     * Reports one Xtext validation issue with its source location.
     */
    def void reportIssue(Resource resource, Issue issue) {
        val uri = issue.uriToProblem ?: resource.URI
        val line = issue.lineNumber ?: 0
        val column = issue.column ?: 0
        switch issue.severity {
            case Severity.ERROR:
                LOGGER.error("{}:{}:{}: {}", uri, line, column, issue.message)
            case Severity.WARNING:
                LOGGER.warn("{}:{}:{}: {}", uri, line, column, issue.message)
            case Severity.INFO:
                LOGGER.info("{}:{}:{}: {}", uri, line, column, issue.message)
            case Severity.IGNORE:
                LOGGER.debug("Ignoring validation issue at {}:{}:{}: {}", uri, line, column, issue.message)
        }
    }

    /**
     * Executes SPViz code generation.
     *
     * @return The corresponding {@link CommandLine.ExitCode}
     */
    def int generate() {
        try {
            var boolean errors = false
            for (resource : spvizModelResources) {
                LOGGER.info("Generating sources for {}", resource.URI)
                SPVizModelGenerator.generate(resource, output, noModelDsl, noDiff)
            }
            
            for (resource : spvizResources) {
                LOGGER.info("Generating sources for {}", resource.URI)
                SPVizGenerator.generate(resource, output, noModelDsl, noDiff)
                // Build the project.
                val buildProject = output.toAbsolutePath.toString.replace("\\", "/") + "/" + (resource.contents.head as SPViz).package + ".build"
                if (build) {
                    LOGGER.info("Building the project {}.", buildProject)
                    try {
                        // First, try with "mvn" as the command
                        #["mvn", "clean", "package"].invoke(new File(buildProject))
                    } catch (IOException e) try {
                        // If that does not work, try "mvn.cmd"
                        LOGGER.warn("Cannot invoke \"mvn\" command, trying \"mvn.cmd\" instead.")
                        #["mvn.cmd", "clean", "package"].invoke(new File(buildProject))
                    } catch (IOException e2) {
                        LOGGER.error("Building generated project failed, because the \"mvn\" command cannot be executed. Is Maven installed and available via command line?. See trace for details.", e)
                        errors = true
                    }
                }
                // Build the generator.
                if (buildGenerator) {
                    LOGGER.info("Building the project {}.", buildProject)
                    try {
                        // First, try with "mvn" as the command
                        #["mvn", "clean", "package", "-P", "generator"].invoke(new File(buildProject))
                    } catch (IOException e) try {
                        // If that does not work, try "mvn.cmd"
                        LOGGER.warn("Cannot invoke \"mvn\" command, trying \"mvn.cmd\" instead.")
                        #["mvn.cmd", "clean", "package", "-P", "generator"].invoke(new File(buildProject))
                    } catch (IOException e2) {
                        LOGGER.error("Building generated project failed, because the \"mvn\" command cannot be executed. Is Maven installed and available via command line?. See trace for details.", e)
                        errors = true
                    }
                }
            }
            if (errors) {
                LOGGER.warn("SPViz project generation finished with errors. See the logs for details. The newly generated projects can be found in {}", output.toAbsolutePath().toString())
                return CommandLine.ExitCode.SOFTWARE
            } else {
                LOGGER.info("SPViz project generation finished. The newly generated projects can be found in {}", output.toAbsolutePath().toString())
                return CommandLine.ExitCode.OK
            }
            
            
        } catch (Throwable t) {
            LOGGER.error("SPViz project generation failed. See trace for details.", t)
            return CommandLine.ExitCode.SOFTWARE
        }
    }
    
    /**
     * Invokes a new process with the given {@code command}.
     * @param command The command to invoke, parameters in individual Strings in the list.
     * @param directory The root directory to execute the command.
     */
    def invoke(List<String> command, File directory) throws IOException {
        LOGGER.info("Invoking command: {}", command.join(" "))
        val pb = new ProcessBuilder(command)
        pb.directory(directory)
        pb.redirectErrorStream(true)
        
        try {
            val p = pb.start
            val pReader = new BufferedReader(new InputStreamReader(p.inputStream))
            var String line = null
            while ((line = pReader.readLine()) !== null) {
                LOGGER.info(line)
            }
            
            p.waitFor
            
            LOGGER.info("Exit value: " + p.exitValue)
            return p.exitValue
        } catch (IOException io) {
        	// re-throw IO exception
        	throw io
    	} catch (Exception e) {
            LOGGER.error("ERROR: Exception while invoking command", e)
        }
    }
    
}
