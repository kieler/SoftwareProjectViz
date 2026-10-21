/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2022-2026 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * + and Scheidt & Bachmann System Technik GmbH, 24109 Melsdorf
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
            import java.nio.file.Files;
            import java.nio.file.InvalidPathException;
            import java.nio.file.Path;
            import java.util.ArrayList;
            import java.util.HashMap;
            import java.util.HashSet;
            import java.util.List;
            import java.util.Locale;
            import java.util.Map;
            import java.util.Map.Entry;
            import java.util.Optional;
            import java.util.Set;
            import java.util.concurrent.Callable;
            import java.util.regex.Pattern;
            
            import «model.package».generate.«model.name.toFirstUpper»ModelDataGenerator.ModelGenerationException;
            import «model.package».model.«model.name.toFirstUpper»Project;
            import picocli.CommandLine;
            import picocli.CommandLine.Command;
            import picocli.CommandLine.Option;
            
            /**
             * This class is a command line tool that executes the generation of the «model.name» model files.
             * The project parameters for this generation are configured via command line parameters.
             */
            @Command(name = "«model.name.toFirstLower»modelgen",
                    exitCodeListHeading = "Exit codes:%n",
                    exitCodeList = {
                        "0:All requested models were generated and saved.",
                        "1:Extraction or saving failed. The output model may be erroneous.",
                        "2:Invalid input. Nothing was extracted."})
            public class ConfigAndExecuteCli implements Callable<Integer> {
                
                static final Logger LOGGER = System.getLogger(ConfigAndExecuteCli.class.getName());
                
                /**
                    Characters that cannot be part of a model file name on at least one supported operating system.
                    Contains the literal characters <>:"/\|?* and any control character.
                */
                private static final Pattern INVALID_FILE_NAME_CHARACTERS = Pattern.compile("[<>:\"/\\\\|?*\\p{Cntrl}]");
                
            
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
                public Integer call() {
                    final List<String> errors = new ArrayList<>();
                    final Path outputDirectory = validateOutput(errors);
                    final Map<String, Path> projects = validateProjectPaths(errors);
                    final Map<String, String> displayNames = validateNames(projects.keySet(), errors);
                    if (!errors.isEmpty()) {
                        for (final String error : errors) {
                            LOGGER.log(System.Logger.Level.ERROR, error);
                        }
                        LOGGER.log(System.Logger.Level.ERROR, "Invalid input, nothing was extracted. Use --help for the usage.");
                        return CommandLine.ExitCode.USAGE;
                    }
                    LOGGER.log(System.Logger.Level.DEBUG, "Model Save Directory: " + outputDirectory);
                    
                    // Read the project Data
                    final Map<String, «model.name.toFirstUpper»Project> projectMap = new HashMap<>();
                    for (final Entry<String, Path> projectEntry : projects.entrySet()) {
                        final String projectKey = projectEntry.getKey();
                        final String projectName = displayNames.get(projectKey);
                        LOGGER.log(System.Logger.Level.INFO, "Reading Project Data for " + projectName);
                        try {
                            OSGiProject projectData = «model.name.toFirstUpper»ModelDataGenerator.generateData(
                                projectEntry.getValue().toString(), projectName, Optional.of(outputDirectory.toString()));
                            projectMap.put(projectKey, projectData);
                        } catch (final ModelGenerationException | RuntimeException e) {
                            LOGGER.log(System.Logger.Level.ERROR, "Generating the model for project " + projectName + " failed.", e);
                            return CommandLine.ExitCode.SOFTWARE;
                        }
                    }
                    
                    LOGGER.log(System.Logger.Level.INFO, "«model.name.toFirstUpper» model generation has finished. The files can be found in " + modelSaveFilePath);
                    return CommandLine.ExitCode.OK;
                }
                
                /**
                 * Resolves the output parameter to an absolute path.
                 * 
                 * @param errors collects the reasons why the input is invalid
                 * @return the output directory, or {@code null} if it is invalid
                 */
                private Path validateOutput(final List<String> errors) {
                    if (modelSaveFilePath == null || modelSaveFilePath.isBlank()) {
                        errors.add("The output path must not be empty.");
                        return null;
                    }
                    try {
                        final Path outputDirectory = Path.of(modelSaveFilePath).toAbsolutePath().normalize();
                        if (Files.exists(outputDirectory) && !Files.isDirectory(outputDirectory)) {
                            errors.add("The output path " + outputDirectory + " exists but is not a directory.");
                            return null;
                        }
                        return outputDirectory;
                    } catch (final InvalidPathException e) {
                        errors.add("The output path '" + modelSaveFilePath + "' is invalid: " + e.getMessage());
                        return null;
                    }
                }
                
                /**
                 * Checks that at least one project path was given as a parameter and that all project paths are readable folders.
                 * 
                 * @param errors collects the reasons why the input is invalid
                 * @return the absolute project folders by project key
                 */
                private Map<String, Path> validateProjectPaths(final List<String> errors) {
                    final Map<String, Path> projects = new HashMap<>();
                    if (projectPaths == null || projectPaths.isEmpty()) {
                        errors.add("No project was given. Specify at least one project folder.");
                        return projects;
                    }
                    for (final Entry<String, File> projectPathEntry : projectPaths.entrySet()) {
                        final String projectKey = projectPathEntry.getKey();
                        final File projectFile = projectPathEntry.getValue();
                        if (projectKey == null || projectKey.isBlank()) {
                            errors.add("A project key must not be empty.");
                            continue;
                        }
                        if (projectFile == null || projectFile.getPath().isBlank()) {
                            errors.add("The path of project " + projectKey + " must not be empty.");
                            continue;
                        }
                        try {
                            final Path projectPath = projectFile.toPath().toAbsolutePath().normalize();
                            if (!Files.exists(projectPath)) {
                                errors.add("The path of project " + projectKey + " does not exist: " + projectPath);
                            } else if (!Files.isDirectory(projectPath)) {
                                errors.add("The path of project " + projectKey + " is not a folder: " + projectPath);
                            } else if (!Files.isReadable(projectPath)) {
                                errors.add("The path of project " + projectKey + " is not readable: " + projectPath);
                            } else {
                                projects.put(projectKey, projectPath);
                            }
                        } catch (final InvalidPathException e) {
                            errors.add("The path of project " + projectKey + " is invalid: " + e.getMessage());
                        }
                    }
                    return projects;
                }
                
                /**
                 * Determines the display names of the projects and checks that they can be used as unique file names.
                 * Projects without an explicit name parameter use their key as name.
                 * 
                 * @param projectKeys the keys of the valid projects
                 * @param errors collects the reasons why the input is invalid
                 * @return the display name by project key
                 */
                private Map<String, String> validateNames(final Set<String> projectKeys, final List<String> errors) {
                    final Map<String, String> displayNames = new HashMap<>();
                    final Set<String> usedFileNames = new HashSet<>();
                    for (final String projectKey : projectKeys) {
                        final String name = projectNames.getOrDefault(projectKey, projectKey);
                        if (name == null || name.isBlank() || name.equals(".") || name.equals("..")
                                || name.endsWith(".") || name.endsWith(" ")
                                || INVALID_FILE_NAME_CHARACTERS.matcher(name).find()) {
                            errors.add("The name '" + name + "' of project " + projectKey + " cannot be used as a file name.");
                        } else if (!usedFileNames.add(name.toLowerCase(Locale.ROOT))) {
                            errors.add("The name '" + name + "' is used for more than one project. The model files would overwrite each other.");
                        } else {
                            displayNames.put(projectKey, name);
                        }
                    }
                    for (final String nameKey : projectNames.keySet()) {
                        if (!projectPaths.containsKey(nameKey)) {
                            LOGGER.log(System.Logger.Level.WARNING, "A name was given for project " + nameKey + ", but no path was given for it. The name is ignored.");
                        }
                    }
                    return displayNames;
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
                 * Signals that the model of a project could not be extracted or saved. A model file that was written
                 * for the failing project may be erroneous.
                 */
                public static final class ModelGenerationException extends Exception {
                    private static final long serialVersionUID = 1L;
                    
                    public ModelGenerationException(final String message, final Throwable cause) {
                        super(message, cause);
                    }
                    
                    public ModelGenerationException(final String message) {
                        super(message);
                    }
                }
                
                /**
                 * Generates «model.name.toFirstUpper» project data from a given project path. The generated Model
                 * will be returned and also saved in a file.
                 * 
                 * @param projectFilePath The path to the project root folder
                 * @param projectName     Descriptive name of the project
                 * @param modelSaveFilePath if present, the model file is saved as projectName.«model.name.toLowerCase» in this directory
                 * @return The generated «model.name.toFirstUpper» project data.
                 * @throws ModelGenerationException if the extraction or the saving fails.
                 */
                public static «model.name.toFirstUpper»Project generateData(final String projectFilePath, final String projectName, Optional<String> modelSaveFilePath) throws ModelGenerationException {
            
                    final ReadProjectFiles reader = new ReadProjectFiles();
                    LOGGER.log(System.Logger.Level.INFO, "Generating data for " + projectName);
                    final «model.name.toFirstUpper»Project project;
                    try {
                        project = reader.generateData(new File(projectFilePath), projectName);
                    } catch (final Exception e) {
                        throw new ModelGenerationException("Extracting the data of project " + projectName + " failed: " + e.getMessage(), e);
                    }
                    if (project == null) {
                        throw new ModelGenerationException("The extractor returned no model for project " + projectName + ".");
                    }
                    
                    «FOR artifact : model.artifacts»
                        if (project.get«artifact.name.toFirstUpper»s().isEmpty()) {
                            LOGGER.log(System.Logger.Level.WARNING, "The extractor did not find any «artifact.name.toFirstLower»s in the project named " + projectName + "!");
                        }
                    «ENDFOR»
                    
                    if (modelSaveFilePath.isPresent()) {
            
                        LOGGER.log(System.Logger.Level.INFO, "Saving data for " + projectName);
                        final String fileName = projectName + ".«model.name.toLowerCase»";
                        try {
                            «model.name.toFirstUpper»ModelSaveAndLoadUtility.saveData(fileName, project, modelSaveFilePath.get());
                        } catch (final IOException | RuntimeException e) {
                            throw new ModelGenerationException("Saving the model of project " + projectName + " failed: " + e.getMessage(), e);
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
            import java.nio.file.Files;
            import java.nio.file.Path;
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
                 * Relative paths are resolved against the working directory.
                 * 
                 * @param fileName the name for the file
                 * @param data «model.name.toFirstUpper»Project to save
                 * @param modelSaveFilePath the directory to save the file in
                 * @throws IOException if the model cannot be written.
                 */
                public static void saveData(final String fileName, final «model.name.toFirstUpper»Project data, String modelSaveFilePath) throws IOException {
                    final Path directory = Path.of(modelSaveFilePath).toAbsolutePath().normalize();
                    final Path file = directory.resolve(fileName).normalize();
                    if (!directory.equals(file.getParent())) {
                        throw new IOException("The file name '" + fileName + "' must not contain a path.");
                    }
                    if (!Files.isDirectory(directory)) {
                        Files.createDirectories(directory);
                    }
            
                    final Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
                    final Map<String, Object> m = reg.getExtensionToFactoryMap();
                    m.put("«model.name.toLowerCase»", new XMIResourceFactoryImpl());
            
                    final ResourceSet resSet = new ResourceSetImpl();
                    final Resource resource = resSet.createResource(URI.createFileURI(file.toString()));
                    if (resource == null) {
                        throw new IOException("No resource could be created for " + file);
                    }
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
            import java.io.IOException;
            import java.nio.file.Path;
            import java.nio.file.Paths;
            import java.time.LocalDate;
            import java.util.HashMap;
            import java.util.List;
            import java.util.Map;
            
            import «model.package».model.«model.name.toFirstUpper»Factory;
            import «model.package».model.«model.name.toFirstUpper»Project;
            import «model.package».model.util.ModelUtil;
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
                // [ ] (optional) extract further textual information for every «artifact.name.toFirstLower» from your project
                «FOR reference : artifact.references»
                    «IF reference instanceof Containment»
                        // [ ] connect all «(reference as Containment).contains.name.toFirstLower» artifacts to a parent «artifact.name.toFirstLower»
                    «ELSEIF reference instanceof Connection»
                        // [ ] connect all «artifact.name.toFirstLower» artifacts to all their «(reference as Connection).connects.name.toFirstLower» artifacts as defined by the «(reference as Connection).name.toFirstLower» connection.
                    «ENDIF»
                «ENDFOR»
            «ENDFOR»
            // [ ] delete the "not implemented" guard in generateData once the extraction is implemented
            
             
            /**
             * TODO: document me!
             */
            public class ReadProjectFiles {
                
                /** Remove this constant and the guard in {@link #generateData} when the extraction is implemented. */
                private static final boolean EXTRACTION_NOT_IMPLEMENTED = true;
            
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
                 * @throws IOException if a project file cannot be read. Any other exception also fails the generation.
                 */
                public «model.name.toFirstUpper»Project generateData(final File projectPath, final String projectName) throws IOException {
                    // TODO: delete this guard when the extraction below is implemented. Until then, the generator fails on
                    // purpose, so an unimplemented extractor cannot produce a successful but empty model.
                    if (EXTRACTION_NOT_IMPLEMENTED) {
                        throw new UnsupportedOperationException("You executed the generator template. Your next task is to modify the "
                            + "`ReadProjectFiles.java` file in your generator and program how to extract the artifacts of your project.");
                    }
                    
                    project.setProjectName(projectName);
                    // Example call to add generic information to the model or individual artifacts
                    // addGenerationDateInformation();
                    
                    // TODO: fill this!
                    // You can start with searching for all files of a specific type that contains your project data like this:
                    // final List<Path> filePaths = new ArrayList<Path>();
                    // findFiles(".someextension", projectPath, filePaths);
                    // for (final Path filePath : filePaths) {
                    //     parseSomeExtensionFile(filePath);
                    // }
                    
                    return project;
            
                }
                
                /**
                 * Adds the model generation date as information to the project.
                 */
                private void addGenerationDateInformation() {
                    ModelUtil.addInformation(project, "generated on " + LocalDate.now());
                }
                
                «FOR artifact : model.artifacts»
                    /**
                     * Returns the «artifact.name.toFirstLower» with the given identifying name, if it already exists.
                     * Returns {@code null} if it does not exist yet.
                     *
                     * @param name The identifying name of the «artifact.name.toFirstLower».
                     * @return The «artifact.name.toFirstLower» for the given name or {@code null}.
                     */
                    private «artifact.name.toFirstUpper» find«artifact.name.toFirstUpper»(final String name) {
                    	return «artifact.name.toFirstLower»s.get(name);
                    }
                    
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
                 * @param searchRoot Path to search in
                 * @param accumulator The list to accumulate the found paths in.
                 * @throws IOException if a directory cannot be listed
                 */
                private void findFiles(final String fileNameSuffix, final File searchRoot, final List<Path> accumulator) throws IOException {
                    final File[] list = searchRoot.listFiles();
            
                    if (list == null) {
                        throw new IOException("Cannot list the contents of " + searchRoot);
                    }
                    for (final File fil : list) {
                        if (fil.isDirectory()) {
                            findFiles(fileNameSuffix, fil, accumulator);
                        } else if (fil.getName().endsWith(fileNameSuffix)) {
                            Path filePath = Paths.get(fil.getPath());
                            accumulator.add(filePath);
                        }
                    }
                }
            
                /**
                 * Converts the given name to an ASCII string save for using in an Ecore ID.
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
            new Dependency("info.picocli", "picocli" , "4.7.7"),
            new Dependency("org.eclipse.emf", "org.eclipse.emf.ecore.xmi", "2.39.0"),
            new Dependency(model.package, model.package + ".model", "0.1.0-SNAPSHOT")
        ]
    }
    
}