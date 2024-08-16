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
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Containment
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import java.io.File
import org.slf4j.Logger
import org.slf4j.LoggerFactory

/**
 * Helper methods to generate Maven build artifacts for plugins.
 */
class GenerateGeneratorScaffold {
    
    static final Logger LOGGER = LoggerFactory.getLogger(GenerateGeneratorScaffold)
    
    def static generate(File rootDirectory, SPVizModel model, String version) {
        val projectName = model.package + ".generate"
        
        val existingDirectory = new File(rootDirectory, projectName)
        if (existingDirectory.isDirectory) {
            LOGGER.info("Skipped generating generator scaffold project, folder already exists. {}", existingDirectory.absolutePath)
            return
        } else {
            LOGGER.info("Generating project {}", existingDirectory.absolutePath)
        }
        
        val projectPath = rootDirectory.absolutePath + "/" + projectName
        val File projectDirectory = FileGenerator.createDirectory(rootDirectory, projectName)
        
        // Generate a new Java project 
        new JavaMavenProjectGenerator(model.package, projectName, projectPath)
            .configureDependencies(requiredBundles(model))
            .configureSourceFolderName("src")
            .configureGenerateShadedJar(true)
            .configureMainClass("ConfigAndExecuteCli")
            .generate()
        
        val packageFolder = FileGenerator.createDirectory(projectDirectory, "src/" + projectName.replace('.', '/'))
        
        // Generate the scaffold Java files
        FileGenerator.generateFile(packageFolder, "ConfigAndExecuteCli.java", configAndExecute(model))
        FileGenerator.generateFile(packageFolder, model.name + "ModelDataGenerator.java", modelDataGenerator(model))
        FileGenerator.generateFile(packageFolder, model.name + "ModelSaveAndLoadUtility.java", modelSaveAndLoadUtility(model))
        FileGenerator.generateFile(packageFolder, "ReadProjectFiles.java", readProjectFilesScaffold(model))
    }
    
    def static configAndExecute(SPVizModel model) {
        return '''
            package «model.package».generate;
            
            import java.io.File;
            import java.lang.System.Logger;
            import java.util.HashMap;
            import java.util.Map;
            import java.util.Map.Entry;
            import java.util.Optional;
            
            import «model.package».model.«model.name.toFirstUpper»Project;
            import picocli.CommandLine;
            import picocli.CommandLine.Command;
            import picocli.CommandLine.Option;
            
            /**
             * This class is a command line tool that executes the generation of the «model.name» model files.
             * The project parameters for this generation are configured via command line parameters.
             */
            @Command(name = "«model.name.toFirstLower»modelgen")
            public class ConfigAndExecuteCli implements Runnable {
                
                static final Logger LOGGER = System.getLogger(ConfigAndExecuteCli.class.getName());
            
                /**
                 * The names of all projects, that should be documented.
                 */
                @Option(names = {"-N", "--names"}, paramLabel = "PROJECT-NAMES",
                        description = "The names of all projects that should be documented.")
                private Map<String, String> projectNames = new HashMap<>();
            
                /**
                 * The paths to the folders of the projects, that should be documented.
                 */
                @Option(names = {"-P", "--paths"}, paramLabel = "PROJECT-PATHS",
                        description = "The paths to the folders of the projects that should be documented.")
                private Map<String, File> projectPaths = new HashMap<>();
            
                /**
                 * The output path where the model is saved.
                 */
                @Option(names = {"-S", "-O", "--output"}, required = true, paramLabel = "OUTPUT",
                        description = "The output path where the model is saved.")
                private String modelSaveFilePath;
                
                @Option(names = {"-h", "--help"}, usageHelp = true, description = "displays this help message.")
                protected boolean help;
            
                /**
                 * Executes the reading of project files and the creation of the documentation.
                 */
                public static void main(String[] args) {
                    CommandLine cl = new CommandLine(new ConfigAndExecuteCli());
                    System.exit(cl.execute(args));
                }
                
                @Override
                public void run() {
                    if (projectPaths != null) {
                        for (final Entry<String, File> projectPathEntry : projectPaths.entrySet()) {
                            final String projectKey = projectPathEntry.getKey();
            
                            if (!projectNames.containsKey(projectKey) || projectNames.get(projectKey) == null) {
                                projectNames.put(projectKey, projectKey);
                            }
                            
                            LOGGER.log(System.Logger.Level.DEBUG, "ProjectPath: " + projectPathEntry.getValue());
                            LOGGER.log(System.Logger.Level.DEBUG, "ProjectName: " + projectNames.get(projectKey));
                        }
            
                        // Modelfile path
                        Optional<String> optionalModelSaveFilePath = Optional.empty();
                        if (!modelSaveFilePath.equals("")) {
                            optionalModelSaveFilePath = Optional.of(modelSaveFilePath);
                            LOGGER.log(System.Logger.Level.DEBUG, "Model Save Directory: " + modelSaveFilePath);
                        }
            
                        // Read the project Data
                        final Map<String, «model.name.toFirstUpper»Project> projectMap = new HashMap<String, «model.name.toFirstUpper»Project>();
                        for (final Entry<String, File> projectPathEntry : projectPaths.entrySet()) {
                            LOGGER.log(System.Logger.Level.INFO, "Reading Project Data for " + projectNames.get(projectPathEntry.getKey()));
                            final String projectKey = projectPathEntry.getKey();
                            projectMap.put(projectKey, «model.name.toFirstUpper»ModelDataGenerator.generateData(projectPathEntry.getValue().toString(),
                                    projectNames.get(projectKey), optionalModelSaveFilePath));
                        }
            
                        LOGGER.log(System.Logger.Level.INFO, "«model.name.toFirstUpper» model generation has finished. The files can be found in " + modelSaveFilePath);
                    }
                }
                
            }
            
        '''
    }
    
    def static modelDataGenerator(SPVizModel model) {
        return '''
            package «model.package».generate;
            
            import java.io.File;
            import java.io.IOException;
            import java.lang.System.Logger;
            import java.util.Optional;
            
            import «model.package».model.«model.name.toFirstUpper»Project;
            
            /**
             * The model generator for «model.name.toFirstUpper» projects.
             */
            public final class «model.name.toFirstUpper»ModelDataGenerator {
            
                static final Logger LOGGER = System.getLogger(«model.name.toFirstUpper»ModelDataGenerator.class.getName());
            
                
                /**
                 * Generates «model.name.toFirstUpper» project data from a given project path. The generated Model
                 * will be returned and also saved in a file.
                 * 
                 * @param projectFilePath The path to the project root folder
                 * @param projectName     Descriptive name of the project
                 * @param save    if true, model file will be saved under target/projectName.«model.name.toLowerCase»
                 * @return The generated «model.name.toFirstUpper» project data.
                 */
                public static «model.name.toFirstUpper»Project generateData(final String projectFilePath, final String projectName, Optional<String> modelSaveFilePath) {
            
                    final ReadProjectFiles reader = new ReadProjectFiles();
                    LOGGER.log(System.Logger.Level.INFO, "Generating data for " + projectName);
                    final «model.name.toFirstUpper»Project project = reader.generateData(new File(projectFilePath), projectName);
                    
                    if (modelSaveFilePath.isPresent()) {
            
                        LOGGER.log(System.Logger.Level.INFO, "Saving data for " + projectName);
                        final String fileName = projectName + ".«model.name.toLowerCase»";
                        try {
                            «model.name.toFirstUpper»ModelSaveAndLoadUtility.saveData(fileName, project, modelSaveFilePath.get());
                        } catch (final IOException e) {
                            LOGGER.log(System.Logger.Level.ERROR, "There was a Problem while saving.", e);
                            e.printStackTrace();
                        }
                    }
                    LOGGER.log(System.Logger.Level.INFO, "Finished");
            
                    return project;
                }
            
            }
            
        '''
    }
    
    def static modelSaveAndLoadUtility(SPVizModel model) {
        return '''
            package «model.package».generate;
            
            import java.io.IOException;
            import java.util.Collections;
            import java.util.Map;
            
            import org.eclipse.emf.common.util.URI;
            import org.eclipse.emf.ecore.resource.Resource;
            import org.eclipse.emf.ecore.resource.ResourceSet;
            import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
            import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
            
            import «model.package».model.«model.name.toFirstUpper»Project;
            
            public class «model.name.toFirstUpper»ModelSaveAndLoadUtility {
            
                /**
                 * Takes a «model.name.toFirstUpper» project and saves the data under modelSaveFilePath/fileName.
                 * 
                 * @param fileName the name for the file
                 * @param data «model.name.toFirstUpper»Project to save
                 * @throws IOException
                 */
                public static void saveData(final String fileName, final «model.name.toFirstUpper»Project data, String modelSaveFilePath) throws IOException {
                    final Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
                    final Map<String, Object> m = reg.getExtensionToFactoryMap();
                    m.put("«model.name.toLowerCase»", new XMIResourceFactoryImpl());
            
                    final ResourceSet resSet = new ResourceSetImpl();
                    modelSaveFilePath= modelSaveFilePath.replace("\\", "/");
                    if (!modelSaveFilePath.endsWith("/")) {
                        modelSaveFilePath+="/";
                    }
                    final Resource resource = resSet.createResource(URI.createURI("file:///"+modelSaveFilePath+fileName));
                    resource.getContents().add(data);
                    resource.save(Collections.EMPTY_MAP);
                }
            
            }
            
        '''
    }
    
    def static readProjectFilesScaffold(SPVizModel model) {
        return '''
            package «model.package».generate;
            
            import java.io.File;
            import java.nio.file.Path;
            import java.nio.file.Paths;
            import java.util.HashMap;
            import java.util.List;
            import java.util.Map;
            
            import «model.package».model.«model.name.toFirstUpper»Factory;
            import «model.package».model.«model.name.toFirstUpper»Project;
            «FOR artifact : model.artifacts»
                import «model.package».model.«artifact.name.toFirstUpper»;
            «ENDFOR»
            
            //=========================== INFORMATION FOR MODIFYING THIS GENERATOR ===========================\\
            // This is a mockup class that should read all necessary project files/configurations to define   ||
            // all artifacts, their containments and connections as defined in the .spvizmodel file. From the ||
            // generated files, this is the one not complete yet that you need to program to convert the      ||
            // project files into the model as listed below.                                                  ||
            // You may just modify this class, it is generated from your .spvizmodel file but will never be   ||
            // overwritten. So if the todo-list below is not complete for your model, just delete this plugin ||
            // and let SPViz re-generate it.                                                                  ||
            //================================================================================================//
            
            // TODO: To complete the model generator, the following checklist needs to be completed:
            // [x] Have a functioning .spvizmodel file to generate the model files and this generator scaffold
            «FOR artifact : model.artifacts»
                // [ ] extract the information for every «artifact.name.toFirstLower» from your project
                «FOR reference : artifact.references»
                    «IF reference instanceof Containment»
                        // [ ] connect all «(reference as Containment).contains.name.toFirstLower» artifacts to a parent «artifact.name.toFirstLower»
                    «ELSEIF reference instanceof Connection»
                        // [ ] connect all «artifact.name.toFirstLower» artifacts to all their «(reference as Connection).connects.name.toFirstLower» artifacts as defined by the «(reference as Connection).name.toFirstLower» connection.
                    «ENDIF»
                «ENDFOR»
            «ENDFOR»
            
             
            /**
             * TODO: document me!
             */
            public class ReadProjectFiles {
            
                static final java.lang.System.Logger LOGGER = System.getLogger(«model.name.toFirstUpper»ModelDataGenerator.class.getName());
            
                final «model.name.toFirstUpper»Project project = «model.name.toFirstUpper»Factory.eINSTANCE.create«model.name.toFirstUpper»Project();
            
                «FOR artifact : model.artifacts»
                    private final Map<String, «artifact.name.toFirstUpper»> «artifact.name.toFirstLower»s = new HashMap<>();
                «ENDFOR»
            
                /**
                 * Fills the HashMaps with Data for all artifacts.
                 *
                 * @param projectPath to extract project data from
                 * @return «model.name.toFirstUpper»Project with all correctly connected project artifacts
                 */
                public «model.name.toFirstUpper»Project generateData(final File projectPath, final String projectName) {
                    project.setProjectName(projectName);
                    
                    // TODO: fill this!
                    // You can start with searching for all files of a specific type that contains your project data like this:
                    // final List<Path> filePaths = new ArrayList<Path>();
                    // findFiles(".someextension", projectPath, filePaths);
                    // for (final Path filePath : filePaths) {
                    //     parseSomeExtensionFile(filePath);
                    // }
                    
                    return project;
            
                }
                
                «FOR artifact : model.artifacts»
                    /**
                     * Return the «artifact.name.toFirstLower» with the given name. If it was generated before, return that, or else return a new one.
                     * The {@code name} and {@code ecoreId} of the module are pre-set.
                     * 
                     * @param name The identifying name of the «artifact.name.toFirstLower».
                     * @return The (possibly newly created) «artifact.name.toFirstLower».
                     */
                    private «artifact.name.toFirstUpper» createOrFind«artifact.name.toFirstUpper»(String name) {
                        if («artifact.name.toFirstLower»s.containsKey(name)) {
                            return «artifact.name.toFirstLower»s.get(name);
                        } else {
                            // Create a new «artifact.name.toFirstLower» and set it up
                            final «artifact.name.toFirstUpper» the«artifact.name.toFirstUpper»= «model.name.toFirstUpper»Factory.eINSTANCE.create«artifact.name.toFirstUpper»();
                            the«artifact.name.toFirstUpper».setName(name);
                            the«artifact.name.toFirstUpper».setEcoreId("«artifact.name.toUpperCase»_" + toAscii(name));
                            the«artifact.name.toFirstUpper».setExternal(true);
                            «artifact.name.toFirstLower»s.put(name, the«artifact.name.toFirstUpper»);
                            project.get«artifact.name.toFirstUpper»s().add(the«artifact.name.toFirstUpper»);
                            return the«artifact.name.toFirstUpper»;
                        }
                    }
                    
                «ENDFOR»
            
                /**
                 * Finds all files in a directory and all its sub-directories. Adds the path to
                 * the files to the <em>accumulator</em>
                 *
                 * @param name Filename extension/ending to search for
                 * @param file Path to search in
                 * @param accumulator The list to accumulate the found paths in.
                 */
                private void findFiles(final String name, final File file, final List<Path> accumulator) {
                    final File[] list = file.listFiles();
            
                    if (list != null) {
                        for (final File fil : list) {
                            if (fil.isDirectory()) {
                                findFiles(name, fil, accumulator);
                            } else if (fil.getName().endsWith(name)) {
                                Path filePath = Paths.get(fil.getPath());
                                accumulator.add(filePath);
                            }
                        }
                    }
                }
            
                /**
                 * Converts the given name to an ACII string save for using in an Ecore ID.
                 * German umlauts are converted to their long form counterparts (e.g., ä->ae)
                 * and special characters not in the alphabet are replaced by underscores (_).
                 * 
                 * @param name The name to convert to an ASCII string
                 * @return An ASCII-only version of the string.
                 */
                private String toAscii(String name) {
                    Map<Character, String> mappings = new HashMap<>();
                    mappings.put('Ä', "Ae");
                    mappings.put('ä', "ae");
                    mappings.put('Ö', "Oe");
                    mappings.put('ö', "oe");
                    mappings.put('Ü', "Ue");
                    mappings.put('ü', "ue");
                    mappings.put('ẞ', "Ss");
                    mappings.put('ß', "ss");
                    
                    StringBuilder sb = new StringBuilder();
                    name.chars().forEachOrdered((int character) -> {
                        // Replace all known mappings to readable allowable ID substrings
                        if (mappings.containsKey((char) character)) {
                            sb.append(mappings.get((char) character));
                        // Keep all A-Z,a-z,0-9 and .- the same.
                        } else if (character >= 'A' && character <= 'Z' || 
                                   character >= 'a' && character <= 'z' ||
                                   character == '.' ||
                                   character == '-' ||
                                   character == '0' ||
                                   character >= '1' && character <= '9') {
                            sb.append((char) character);
                        // Replace all other characters by _
                        } else {
                            sb.append('_');
                        }
                    });
                    
                    return sb.toString();
                }
            
            }
            
        '''
    }
    
    def static requiredBundles(SPVizModel model) {
        return #[
            new Dependency("info.picocli", "picocli" , "4.7.5"),
            new Dependency("org.eclipse.emf", "org.eclipse.emf.ecore.xmi", "2.36.0"),
            new Dependency(model.package, model.package + ".model", "0.1.0-SNAPSHOT")
        ]
    }
    
}