/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2024-2025 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
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
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.resource.XtextResourceSet
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
@Command(name = "spviz")
class SPVizCLI implements Runnable {
    
    static final Logger LOGGER = LoggerFactory.getLogger(SPVizCLI)
    
    /**
     * All files for which this tool should generate the projects. Only accepts .spvizmodel and .spviz files.
     */
    @Parameters(arity = "1..*", description = "Any number of .spvizmodel or .spviz input files. Other files types will be ignored.")
    protected List<File> files = new ArrayList

    /**
     * The .spvizmodel files given to this tool.
     */
    List<File> spvizModelFiles = new ArrayList
    
    /**
     * The .spviz files given to this tool.
     */
    List<File> spvizFiles = new ArrayList

    /**
     * The paths to the folders of the projects, that should be documented.
     */
    @Option(names = #["-o", "--output"], paramLabel = "OUTPUT-PATH", defaultValue = ".",
            description = "The path to the output folder where the generated projects should be stored. Defaults to the current working directory.")
    protected Path output
    
    @Option(names = #["-h", "--help"], usageHelp = true, description = "display a help message")
    protected boolean help
    
    @Option(names = #["-b", "--build"], defaultValue = "false", description = "Automatically build the generated visualization projects with Maven.")
    protected boolean build
    
    @Option(names = #["-g", "--build-generator"], defaultValue = "false", description = "Automatically build the generator projects with Maven.")
    protected boolean buildGenerator

    /**
     * Main entry point for this command line tool.
     */
    def static void main(String[] args) {
        val CommandLine cl = new CommandLine(new SPVizCLI())
        System.exit(cl.execute(args))
    }
    
    override void run() {
        // Individually list all .spvizmodel and .spviz files from the parameters.
        spvizModelFiles.addAll(files.filter[
            name.endsWith(".spvizmodel")
        ])
        spvizFiles.addAll(files.filter[
            name.endsWith(".spviz")
        ])
        
        val XtextResourceSet rs = new XtextResourceSet
        //    Comment this line in if the lazy loading causes problems later when resolving the spvizmodel artifacts referred by the spviz file.
        // This would load the referenced model immediately instead. Should not be necessary.
//        rs.addLoadOption(XtextResource.OPTION_RESOLVE_ALL, Boolean.TRUE)
      
        try {
            // Prepare loading .spvizmodel files.
            SPVizModelStandaloneSetup.doSetup
            for (spvizModelFile : spvizModelFiles) {
                // Parse the model file.
                LOGGER.info("Generating sources for {}", spvizModelFile.absolutePath.replace("\\", "/"))
                val Resource resource = rs.getResource(URI.createURI("file://" + spvizModelFile.absolutePath.replace("\\", "/")), true)
                SPVizModelGenerator.generate(resource, output)
            }
            
            // Prepare loading .spviz files.
            SPVizStandaloneSetup.doSetup
            for (spvizFile : spvizFiles) {
                // Parse the visualization file. A full absolute URI with file:// scheme is important, so that the resource
                // can correctly resolve the imported .spvizmodel file.
                LOGGER.info("Generating sources for {}", spvizFile.absolutePath.replace("\\", "/"))
                val Resource resource = rs.createResource(URI.createURI("file://" + spvizFile.absolutePath.replace("\\", "/")))
                resource.load(rs.getLoadOptions())
                SPVizGenerator.generate(resource, output)
                
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
                    }
                }
            }
            LOGGER.info("SPViz project generation finished. The newly generated projects can be found in {}", output.toAbsolutePath().toString())
            
            
        } catch (Throwable t) {
            LOGGER.error("SPViz project generation failed. See trace for details.", t)
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
