/*
 * SPViz - Kieler Software Project Visualization for Projects
 * 
 * A part of Kieler
 * https://github.com/kieler
 * 
 * Copyright 2022 by
 * + Christian-Albrechts-University of Kiel
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 */
package de.cau.cs.kieler.spviz.yarnInversify.generate;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import de.cau.cs.kieler.spviz.yarnInversify.model.Class;
import de.cau.cs.kieler.spviz.yarnInversify.model.Interface;
import de.cau.cs.kieler.spviz.yarnInversify.model.Package;
import de.cau.cs.kieler.spviz.yarnInversify.model.YarnInversifyFactory;
import de.cau.cs.kieler.spviz.yarnInversify.model.YarnInversifyProject;

/**
 * This class reads all the data for Yarn + Inversify artifacts from the artifact files. It
 * searches the project folder for all Yarn+Inversify-specific files.
 *
 * For packages it reads the belonging package.json and yarn.lock files.
 * DI classes and interfaces are read by their .ts files.
 *
 * @author nre
 *
 */
public class ReadProjectFiles {

	static final java.lang.System.Logger LOGGER = System.getLogger(YarnInversifyModelDataGenerator.class.getName());

	final YarnInversifyProject project = YarnInversifyFactory.eINSTANCE.createYarnInversifyProject();

	private final Map<String, Package> packages = new HashMap<>();
	private final Map<String, Class> classes = new HashMap<>();
	private final Map<String, Interface> interfaces = new HashMap<>();
	/** The packages in yarn.lock with @workspace:[path] resolve */
	private final Set<String> workspacePackages = new HashSet<>();
	
	// Mapping to find the resolved package for any dependency
	private final Map<String, Package> resolvedPackages = new HashMap<>();
	// 
	private final Map<Package, Map<String, Object>> packageDependencies = new HashMap<>();


	/**
	 * Generates the HashMaps with Data for packages, container, and interfaces.
	 *
	 * @param projectPath to extract project data from
	 * @return YarnInversifyProject with all project artifacts
	 */
	public YarnInversifyProject generateData(final File projectPath, final String projectName) {
		project.setProjectName(projectName);
		
		// Parse the yarn.lock file (if available) for resolved project and dependency information
		final List<Path> lockPaths = new ArrayList<Path>();
		findFiles(StaticVariables.LOCK_FILE, projectPath, lockPaths);
		for (final Path lockPath : lockPaths) {
			parseLockFile(lockPath);
		}
		
		// Parse all package.json files for the information of local packages
		final List<Path> packagePaths = new ArrayList<Path>();
		findFiles(StaticVariables.PACKAGE_FILE, projectPath, packagePaths);
		for (final Path packagePath : packagePaths) {
			parsePackageFile(packagePath);
		}
		
		return project;

	}

	@SuppressWarnings("unchecked")
	private void parseLockFile(Path lockPath) {
		try {
			Map<String, Object> yarnLock = ReadProjectFilesUtility.yamlToMap(lockPath);
			// First, run through all packages to resolve the required package versions with the
			// resolved version, remembering the dependency data for after all are resolved.
			yarnLock.forEach((packageNames, packageData) -> {
				if (packageNames.equals("__metadata")) {
					return;
				}
				
				String resolvedVersion = (String) ((Map<String, Object>) packageData).get(StaticVariables.VERSION);
				// Multiple packages dependencies may be resolved by the same version, separated by a comma
				String[] splitPackageNames = packageNames.split(",");
				String resolvedPackageName = null;
				Package thePackage = null;
				for (int i = 0; i < splitPackageNames.length; ++i) {
					String splitPackageName = splitPackageNames[i].strip();
					if (resolvedPackageName == null) {
						if (packageNames.contains("@workspace:")) {
							workspacePackages.add(splitPackageName.substring(0, splitPackageName.lastIndexOf('@')));
							resolvedPackageName = splitPackageName.substring(0, splitPackageName.lastIndexOf('@'))+ "@local";
						} else {
							// Resolved package name is everything before the last @ symbol + its resolved version
							resolvedPackageName = splitPackageName.substring(0, splitPackageName.lastIndexOf('@'))+ '@' + resolvedVersion;
						}
						thePackage = createOrFindPackage(resolvedPackageName);
					}
					if (packageNames.contains("@workspace:")) {
						resolvedPackages.put(resolvedPackageName, thePackage);
					}
					resolvedPackages.put(splitPackageName, thePackage);
				}
				
				Map<String, Object> dependencies = (Map<String, Object>) ((Map<String, Object>) packageData).get(StaticVariables.DEPENDENCIES);
				if (dependencies != null) {
					packageDependencies.put(thePackage, dependencies);
				}
			});
			
			// Resolve all dependencies with the stored data
			packageDependencies.forEach((thePackage, dependencies) -> {
				dependencies.forEach((depName, depVersion) -> {
					String resolvedDepName;
					if (workspacePackages.contains(depName)) {
						resolvedDepName = depName + "@local";
					} else {
						resolvedDepName = depName + "@npm:" + depVersion;
					}
					Package dependency = resolvedPackages.get(resolvedDepName);
					if (dependency == null) {
						System.out.println("dependency not configured in yarn.lock, skipping: " + thePackage.getName() + " requires " + resolvedDepName);
						return;
					}
					thePackage.getConnectedDependencyPackages().add(dependency);
				});
			});
			
		} catch (Exception e) {
			LOGGER.log(System.Logger.Level.ERROR, "Could not parse lock file at " + lockPath.toString());
			LOGGER.log(System.Logger.Level.ERROR, e);
			e.printStackTrace();
		}
		
	}
	
	private void parsePackageFile(Path packagePath) {
		try {
			// Configure this package.
			Map<String, Object> packageJson = ReadProjectFilesUtility.jsonToMap(packagePath);
			String name = (String) packageJson.get(StaticVariables.NAME);
			String version = (String) packageJson.get(StaticVariables.VERSION);
			if (name == null) {
				return;
			}
			Package thePackage = createOrFindPackage(name + "@local");
			thePackage.setExternal(false);
			thePackage.setName(name + '@' + version);
			
			// For each of these packages, further do a pass through its source .ts files for the
			// inversifyJs classes and interfaces.
			File packageDirectory = packagePath.toFile().getParentFile();
			final List<Path> tsPaths = new ArrayList<Path>();
			findFiles(StaticVariables.TS_FILE, packageDirectory, tsPaths);
			for (final Path tsPath : tsPaths) {
				parseTSFile(tsPath);
			}
			
		} catch (IOException e) {
			LOGGER.log(System.Logger.Level.ERROR, "Could not parse package.json file at " + packagePath.toString());
			LOGGER.log(System.Logger.Level.ERROR, e);
			e.printStackTrace();
		}
	}
	
	private void parseTSFile(Path tsPath) {
		// Find these patterns to identify the interfaces and classes:
		// 
		// (di).config.ts files define containers with concrete providing bindings:
		// bind(TYPES.[Interface]).to([Class]) adds the YarnInversify.Interface.Providing connection.
		//
		// @injectable [opt. linebreak] export class [Class] defines a class
		// In these classes (count { and } to see when it ends) we may find:
		// @inject(TYPES.[Interface]) adds the YarnInversify.Class.Required connection.
		// or @multiInject(TYPES.[Interface])
		try {
			String fileContent = ReadProjectFilesUtility.readFileToString(tsPath);
			// Search for any @injectable class
			int position = 0;
			while (true) {
				int injectableStart = fileContent.indexOf(StaticVariables.INJECTABLE, position);
				if (injectableStart == -1) {
					// This file has no more @injectable annotation
					break;
				}
				int classNameStart = classNameStartOfInjectable(fileContent, injectableStart);
				if (classNameStart == -1) {
					// Cannot find the class for this annotation, look for the next one.
					position += injectableStart + StaticVariables.INJECTABLE.length();
					continue;
				}
				position = classNameStart;
				int classNameEnd = fileContent.indexOf(' ', classNameStart);
				int classNameEnd2 = fileContent.indexOf('<', classNameStart);
				if (classNameEnd2 < classNameEnd && classNameEnd2 != -1) {
					classNameEnd = classNameEnd2;
				}
				String className = fileContent.substring(classNameStart, classNameEnd);
				Class theClass = createOrFindClass(className);
				theClass.setExternal(false);
				
				// For this class, find the begin and end brackets.
				// (simple without caring for comments with not matching brackets)
				int classDefStart = fileContent.indexOf('{', classNameEnd);
				int classDefEnd = findEndBracket(fileContent, classDefStart);
				configureInjections(theClass, fileContent.substring(classDefStart, classDefEnd));
			}
			
			// Search for any (di).config.ts file for the type concretions.
			if (tsPath.getFileName().toString().endsWith(".config.ts")) {
				// search for any bind(TYPES.[Interface]).to([Class]) patterns
				position = 0;
				while (true) {
					int bindStart = fileContent.indexOf(StaticVariables.BIND, position);
					if (bindStart == -1) {
						// This file has no more binding.
						break;
					}
					int bindingStart = bindStart + StaticVariables.BIND.length();
					int bindingEnd = fileContent.indexOf(')', bindingStart);
					String bindingInterfaceName = fileContent.substring(bindingStart, bindingEnd);
					
					// If it is not bound to something via .to(...), skip this.
					if (!fileContent.substring(bindingEnd, bindingEnd + StaticVariables.TO.length()).equals(StaticVariables.TO)) {
						position = bindingEnd;
						continue;
					}
					int boundStart = bindingEnd + StaticVariables.TO.length();
					int boundEnd = fileContent.indexOf(')', boundStart);
					String boundClassName = fileContent.substring(boundStart, boundEnd);
					
					Interface bindingInterface = createOrFindInterface(bindingInterfaceName);
					Class boundClass = createOrFindClass(boundClassName);
					bindingInterface.getConnectedProvidingClasss().add(boundClass);
					
					position = boundEnd;
				}
			}
			
		} catch (IOException e) {
			LOGGER.log(System.Logger.Level.ERROR, "Could not read .ts file at " + tsPath.toString());
			LOGGER.log(System.Logger.Level.ERROR, e);
			e.printStackTrace();
		}
		
	}

	/**
	 * Parses and configures the injections in classes. 
	 *
	 * @param theClass The class in the model to connect the injections to.
	 * @param classContent The definition of the class in the code.
	 */
	private void configureInjections(Class theClass, String classContent) {
		// Search for any @inject annotations to find injected interfaces/classes
		int position = 0;
		while (true) {
			int injectStart = classContent.indexOf(StaticVariables.INJECT, position);
			if (injectStart == -1) {
				// This file has no @inject annotation
				break;
			}
			int injectedStart = injectStart + StaticVariables.INJECT.length();
			int injectedEnd = classContent.indexOf(')', injectedStart);
			String injectedName = classContent.substring(injectedStart, injectedEnd);
			// If it starts with TYPES. it is an injected interface, otherwise it is an injected class with that name.
			if (injectedName.startsWith(StaticVariables.TYPES)) {
				String injectedInterfaceName = injectedName.substring(StaticVariables.TYPES.length());
				Interface theInjectedInterface = createOrFindInterface(injectedInterfaceName);
				theClass.getConnectedRequiredInterfaces().add(theInjectedInterface);
			} else {
				Class theInjectedClass = createOrFindClass(injectedName);
				theClass.getConnectedRequiredClasss().add(theInjectedClass);
			}
			position = injectedEnd;
		}
		
		// Search for any @multiInject annotations to find injected interfaces/classes
		position = 0;
		while (true) {
			int injectStart = classContent.indexOf(StaticVariables.MULTIINJECT, position);
			if (injectStart == -1) {
				// This file has no @multiInject annotation
				break;
			}
			int injectedStart = injectStart + StaticVariables.MULTIINJECT.length();
			int injectedEnd = classContent.indexOf(')', injectedStart);
			String injectedName = classContent.substring(injectedStart, injectedEnd);
			// If it starts with TYPES. it is an injected interface, otherwise it is an injected class with that name.
			if (injectedName.startsWith(StaticVariables.TYPES)) {
				String injectedInterfaceName = injectedName.substring(StaticVariables.TYPES.length());
				Interface theInjectedInterface = createOrFindInterface(injectedInterfaceName);
				theClass.getConnectedRequiredInterfaces().add(theInjectedInterface);
			} else {
				Class theInjectedClass = createOrFindClass(injectedName);
				theClass.getConnectedRequiredClasss().add(theInjectedClass);
			}
			position = injectedEnd;
		}
	}

	/**
	 * Find the ending bracket '}' for the bracket at the given start index.
	 * @param fileContent The file to search in.
	 * @param startingBracket The index for the starting bracket '{'.
	 * @return The ending bracket's index, or -1 if not found.
	 */
	private int findEndBracket(String fileContent, int startingBracket) {
		int currentIndex = startingBracket + 1;
		char[] fromStart = fileContent.substring(currentIndex).toCharArray();
		int fromStartIndex = 0;
		int brackets = 1;
		while (brackets >= 1) {
			if (fromStartIndex >= fromStart.length) {
				return -1;
			}
			if (fromStart[fromStartIndex] == '{') {
				++brackets;
			} else if (fromStart[fromStartIndex] == '}') {
				--brackets;
			}
			// We do not need to care about a final offset, as we start with a +1 in the starting current index.
			++fromStartIndex;
		}
		return startingBracket + fromStartIndex;
	}

	/**
	 * For given .ts file content and the start index of an @injectable annotation, return the
	 * start index of the class name of this injectable.
	 * @param fileContent The Typescript file
	 * @param injectableStart The index in the file where the @injectable annotation starts
	 * @return The start index of the injectable class, or -1 if none follows this annotation.
	 */
	private int classNameStartOfInjectable(String fileContent, int injectableStart) {
		// skip @injectable, all whitespace, strings "export ", "abstract ", "class "
		// Class name (should) follow right after that
		int classNameStart = injectableStart + "@injectable()".length();
		char c = fileContent.charAt(classNameStart);
		while (Character.isWhitespace(c)) {
			c = fileContent.charAt(++classNameStart);
		}
		if (fileContent.substring(classNameStart).startsWith("export ")) {
			classNameStart += "export ".length();
		}
		if (fileContent.substring(classNameStart).startsWith("abstract ")) {
			classNameStart += "abstract ".length();
		}
		if (fileContent.substring(classNameStart).startsWith("class ")) {
			classNameStart += "class ".length();
		}
		if (Character.isUpperCase(fileContent.charAt(classNameStart))) {
			return classNameStart;
		}
		
		LOGGER.log(System.Logger.Level.ERROR, "Could not find the class name for this @injectable" +
				" annotation. File content where we started to look from:\n" +
				fileContent.substring(injectableStart, Math.min(fileContent.length(), injectableStart + 50)));
		return -1;
	}

	/**
	 * Return the package with the given name. If it was generated before, return that, or else return a new one.
	 * The {@code name} and {@code ecoreId} of the module are pre-set.
	 * 
	 * @param name The identifying name of the package.
	 * @return The (possibly newly created) package.
	 */
	private Package createOrFindPackage(String name) {
		if (packages.containsKey(name)) {
			return packages.get(name);
		} else {
			// Create a new model and set it up
			final Package thePackage = YarnInversifyFactory.eINSTANCE.createPackage();
			thePackage.setName(name);
			thePackage.setEcoreId(StaticVariables.PACKAGE_PREFIX + toAscii(name));
			thePackage.setExternal(true);
			packages.put(name, thePackage);
			project.getPackages().add(thePackage);
			return thePackage;
		}
	}

	/**
	 * Return the interface with the given name. If it was generated before, return that, or else return a new one.
	 * The {@code name} and {@code ecoreId} of the interface are pre-set.
	 * 
	 * @param name The identifying name of the interface ([interface name])
	 * @return The (possibly newly created) interface.
	 */
	private Interface createOrFindInterface(String name) {
		if (interfaces.containsKey(name)) {
			return interfaces.get(name);
		} else {
			// Create a new model and set it up
			final Interface theInterface = YarnInversifyFactory.eINSTANCE.createInterface();
			theInterface.setName(name);
			theInterface.setEcoreId(StaticVariables.INTERFACE_PREFIX + name);
			theInterface.setExternal(false);
			interfaces.put(name, theInterface);
			project.getInterfaces().add(theInterface);
			return theInterface;
		}
	}

	/**
	 * Return the class with the given name. If it was generated before, return that, or else return a new one.
	 * The {@code name} and {@code ecoreId} of the component implementation are pre-set.
	 * 
	 * @param name The identifying name of the class
	 * @return The (possibly newly created) class.
	 */
	private Class createOrFindClass(String name) {
		if (classes.containsKey(name)) {
			return classes.get(name);
		} else {
			// Create a new model and set it up
			final Class newClass = YarnInversifyFactory.eINSTANCE.createClass();
			newClass.setName(name);
			newClass.setEcoreId(StaticVariables.CLASS_PREFIX + toAscii(name));
			newClass.setExternal(true);
			classes.put(name, newClass);
			project.getClasss().add(newClass);
			return newClass;
		}
	}

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
					// Ignore /node_modules and /lib directories.
					if (!fil.getPath().endsWith(File.separator + "node_modules")
							&& !fil.getPath().endsWith(File.separator + "lib")) {
						findFiles(name, fil, accumulator);
					}
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
			// Keep all A-Z,a-z and .- the same.
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
