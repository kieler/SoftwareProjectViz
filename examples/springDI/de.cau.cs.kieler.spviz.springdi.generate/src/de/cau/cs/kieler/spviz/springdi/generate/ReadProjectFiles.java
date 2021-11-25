/*
 * SPViz - Kieler Software Project Visualization for Projects
 * 
 * A part of Kieler
 * https://github.com/kieler
 * 
 * Copyright 2021 by
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
package de.cau.cs.kieler.spviz.springdi.generate;

import java.io.File;
import java.io.IOException;
import java.lang.System.Logger.Level;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.jdt.core.dom.AST;
import org.eclipse.jdt.core.dom.ASTNode;
import org.eclipse.jdt.core.dom.ASTParser;
import org.eclipse.jdt.core.dom.ASTVisitor;
import org.eclipse.jdt.core.dom.CompilationUnit;
import org.eclipse.jdt.core.dom.FieldDeclaration;
import org.eclipse.jdt.core.dom.MarkerAnnotation;
import org.eclipse.jdt.core.dom.MethodDeclaration;
import org.eclipse.jdt.core.dom.PackageDeclaration;
import org.eclipse.jdt.core.dom.SimpleType;
import org.eclipse.jdt.core.dom.SingleVariableDeclaration;
import org.eclipse.jdt.core.dom.Type;
import org.eclipse.jdt.core.dom.TypeDeclaration;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import de.cau.cs.kieler.spviz.springdi.model.Artifact;
import de.cau.cs.kieler.spviz.springdi.model.Class;
import de.cau.cs.kieler.spviz.springdi.model.ComponentImplementation;
import de.cau.cs.kieler.spviz.springdi.model.ComponentInterface;
import de.cau.cs.kieler.spviz.springdi.model.Identifiable;
import de.cau.cs.kieler.spviz.springdi.model.ModelFactory;
import de.cau.cs.kieler.spviz.springdi.model.Module;
import de.cau.cs.kieler.spviz.springdi.model.SpringDIProject;

/**
 * This class reads all the data for Spring DI artifacts from the artifact files. It
 * searches the project folder for all Spring DI-specific files.
 *
 * For artifacts it reads the belonging pom.xml file.
 * For modules it also reads their pom.xml files.
 * Service component interfaces and implementations and classes requiring such interfaces are read by their .java files
 *
 * @author nre
 *
 */
public class ReadProjectFiles {

	static final java.lang.System.Logger LOGGER = System.getLogger(SpringDIModelDataGenerator.class.getName());

	final SpringDIProject project = ModelFactory.eINSTANCE.createSpringDIProject();

	private final HashMap<String, Module> modules = new HashMap<>();
	private final HashMap<String, ComponentInterface> interfaces = new HashMap<>();
	private final HashMap<String, ComponentImplementation> implementations = new HashMap<>();
	private final HashMap<String, Class> classes = new HashMap<>();


	/**
	 * Generates the HashMaps with Data for bundles, features, services and
	 * products.
	 *
	 * @param projectPath to extract osgi data from
	 * @return SpringDIProject with all OSGI objects (bundles, features, services,
	 *         products, service interfaces)
	 */
	public SpringDIProject generateData(final File projectPath, final String projectName) {
		
		// Parsing of pom.xml files for artifacts and modules data
		final List<Path> pomFilePaths = new ArrayList<Path>();
		findFiles(StaticVariables.POM_FILE, projectPath, pomFilePaths);
		for (final Path pomPath : pomFilePaths) {
			parsePomFile(pomPath);
		}
		
		return project;

	}

	private void parsePomFile(Path pomPath) {
		try {
			final Document pom = ReadProjectFilesUtility.readFileToDocument(pomPath);
			if (isArtifact(pom)) {
				// Create an artifact for this pom.xml file
				final Artifact artifact = ModelFactory.eINSTANCE.createArtifact();
				project.getArtifacts().add(artifact);
				
				// Extract model data for this artifact
				final NodeList projectNodeChildren = findChildByTagName(pom.getChildNodes(), StaticVariables.PROJECT).getChildNodes();
				final String groupId = findChildByTagName(projectNodeChildren, StaticVariables.GROUP_ID).getTextContent().strip();
				final String name = groupId + "." + findChildByTagName(projectNodeChildren, StaticVariables.ARTIFACT_ID).getTextContent().strip();
				
				artifact.setName(name);
				artifact.setEcoreId(StaticVariables.ARTIFACT_PREFIX + toAscii(name));
				
				// Extract the modules and module paths defined in this artifact
				final NodeList pomModules = findChildByTagName(projectNodeChildren, StaticVariables.MODULES).getChildNodes();
				for (int i = 0; i < pomModules.getLength(); ++i) {
					Node pomModule = pomModules.item(i);
					if (pomModule instanceof Element) {
						final Path modulePath = pomPath.getRoot()
							.resolve(pomPath.subpath(0, pomPath.getNameCount() - 1))
							.resolve(pomModule.getTextContent().strip());
						final Module module = createOrUpdateModule(modulePath.resolve(StaticVariables.POM_FILE));
						
						// parsing of .java files for component interfaces and implementations and classes in this module
						final List<Path> javaFilePaths = new ArrayList<Path>();
						findFiles(StaticVariables.JAVA_FILE, modulePath.toFile(), javaFilePaths);
						for (final Path javaPath : javaFilePaths) {
							parseJavaFile(javaPath, module);
						}
						
						artifact.getModules().add(module);
					}
					
				}
			}
		} catch (ParserConfigurationException | SAXException | IOException e) {
			LOGGER.log(Level.ERROR, "Could not parse pom.xml: " + pomPath.toString());
		}
	}

	private boolean isArtifact(Document pom) {
		final boolean hasParent = pom.getElementsByTagName(StaticVariables.PARENT).getLength() != 0;
		final boolean hasModules = pom.getElementsByTagName(StaticVariables.MODULES).getLength() != 0;
		return !hasParent && hasModules;
	}

	/**
	 * Create the module found on the given path or use the module already created by some dependency of another module.
	 * Add the dependencies to that module and return it.
	 * 
	 * @param modulePath The path on disc where to find the pom.xml defining this module.
	 * @return The module.
	 */
	private Module createOrUpdateModule(Path modulePath) {
		try {
			final Document pom = ReadProjectFilesUtility.readFileToDocument(modulePath);
			// read the ID and check if its already in the map
			final NodeList projectNodeChildren = findChildByTagName(pom.getChildNodes(), StaticVariables.PROJECT).getChildNodes();
			Node groupIdNode = findChildByTagName(projectNodeChildren, StaticVariables.GROUP_ID);
			if (groupIdNode == null) {
				// The pom does not define an own groupId, fall back to the one in the <parent> tag instead.
				final NodeList parentConfig = findChildByTagName(projectNodeChildren, StaticVariables.PARENT).getChildNodes();
				groupIdNode = findChildByTagName(parentConfig, StaticVariables.GROUP_ID);
			}
			final String groupId = groupIdNode.getTextContent().strip();
			final Node artifactIdNode = findChildByTagName(projectNodeChildren, StaticVariables.ARTIFACT_ID);
			final String name = groupId + "." + artifactIdNode.getTextContent().strip();
			final Module module = createOrFindModule(name);
			
			module.setExternal(false);
			
			// Add all dependencies to the module
			final Node dependenciesNode = findChildByTagName(projectNodeChildren, StaticVariables.DEPENDENCIES);
			if (dependenciesNode == null) {
				return module;
			}
			final NodeList dependencies = dependenciesNode.getChildNodes();
			for (int i = 0; i < dependencies.getLength(); ++i) {
				if (dependencies.item(i) instanceof Element) {
					final NodeList depChildNodes = dependencies.item(i).getChildNodes();
					Node depGroupId = findChildByTagName(depChildNodes, StaticVariables.GROUP_ID);
					Node depArtifactId = findChildByTagName(depChildNodes, StaticVariables.ARTIFACT_ID);
					
					final String depName = depGroupId.getTextContent().strip() + "." + depArtifactId.getTextContent().strip();
					final Module depModule = createOrFindModule(depName);
					module.getRequiredDependencyModules().add(depModule);
				}
			}
			
			return module;
			
		} catch (ParserConfigurationException | SAXException | IOException e) {
			LOGGER.log(Level.ERROR, "Could not parse pom.xml: " + modulePath.toString());
		}
		final Module module = ModelFactory.eINSTANCE.createModule();
		module.setName(modulePath.toString());
		module.setEcoreId(StaticVariables.MODULE_PREFIX + toAscii(modulePath.toString()));
		module.setExternal(false);
		project.getModules().add(module);
		return module;
	}

	/**
	 * Return the module with the given name. If it was generated before, return that, or else return a new one.
	 * The {@code name} and {@code ecoreId} of the module are pre-set.
	 * 
	 * @param name The identifying name of the module ([groupId].[artifactId])
	 * @return The (possibly newly created) module.
	 */
	private Module createOrFindModule(String name) {
		if (modules.containsKey(name)) {
			return modules.get(name);
		} else {
			// Create a new model and set it up
			final Module module = ModelFactory.eINSTANCE.createModule();
			module.setName(name);
			module.setEcoreId(StaticVariables.MODULE_PREFIX + toAscii(name));
			module.setExternal(true);
			modules.put(name, module);
			project.getModules().add(module);
			return module;
		}
	}

	/**
	 * Return the component interface with the given name. If it was generated before, return that, or else return a new one.
	 * The {@code name} and {@code ecoreId} of the compnent interface are pre-set.
	 * 
	 * @param name The identifying name of the component interface ([interface name])
	 * @return The (possibly newly created) component interface.
	 */
	private ComponentInterface createOrFindComponentInterface(String name) {
		if (interfaces.containsKey(name)) {
			return interfaces.get(name);
		} else {
			// Create a new model and set it up
			final ComponentInterface componentInterface = ModelFactory.eINSTANCE.createComponentInterface();
			componentInterface.setName(name);
			componentInterface.setEcoreId(StaticVariables.COMPONENT_INTERFACE_PREFIX + name);
			componentInterface.setExternal(true);
			interfaces.put(name, componentInterface);
			project.getComponentInterfaces().add(componentInterface);
			return componentInterface;
		}
	}

	/**
	 * Return the component implementation with the given name. If it was generated before, return that, or else return a new one.
	 * The {@code name} and {@code ecoreId} of the component implementation are pre-set.
	 * 
	 * @param name The identifying name of the component ([class name])
	 * @return The (possibly newly created) component implementation.
	 */
	private ComponentImplementation createOrFindComponentImplementation(String name) {
		if (implementations.containsKey(name)) {
			return implementations.get(name);
		} else {
			// Create a new model and set it up
			final ComponentImplementation componentImplementation= ModelFactory.eINSTANCE.createComponentImplementation();
			componentImplementation.setName(name);
			componentImplementation.setEcoreId(StaticVariables.COMPONENT_IMPLEMENTATION_PREFIX + toAscii(name));
			componentImplementation.setExternal(true);
			implementations.put(name, componentImplementation);
			project.getComponentImplementations().add(componentImplementation);
			return componentImplementation;
		}
	}

	/**
	 * Return the {@code Class} with the given name. If it was generated before, return that, or else return a new one.
	 * The {@code name} and {@code ecoreId} of the class are pre-set.
	 * 
	 * @param name The identifying name of the class ([class name])
	 * @return The (possibly newly created) class.
	 */
	private Class createOrFindClass(String name) {
		if (classes.containsKey(name)) {
			return classes.get(name);
		} else {
			// Create a new model and set it up
			final Class clazz = ModelFactory.eINSTANCE.createClass();
			clazz.setName(name);
			clazz.setEcoreId(StaticVariables.CLASS_PREFIX + toAscii(name));
			clazz.setExternal(true);
			classes.put(name, clazz);
			project.getClasss().add(clazz);
			return clazz;
		}
	}

	/**
	 * Returns the child {@code Element} of the given node list with the given tag name.
	 * 
	 * @param nodes The node list to search the element in.
	 * @param tagName The tag name searched for.
	 * @return The node with the given tag name, or {@code null}.
	 */
	private Node findChildByTagName(NodeList nodes, String tagName) {
		for (int i = 0; i < nodes.getLength(); ++i) {
			final Node node = nodes.item(i);
			if (node instanceof Element && ((Element) node).getTagName() == tagName) {
				return node;
			}
		}
		return null;
	}

	private void parseJavaFile(Path javaPath, Module parentModule) {
		final String fileContent = ReadProjectFilesUtility.readFileToString(javaPath.toString());
		
		final ASTParser parser = ASTParser.newParser(AST.JLS_Latest);
		parser.setSource(fileContent.toCharArray());
		parser.setKind(ASTParser.K_COMPILATION_UNIT);

		final CompilationUnit cu = (CompilationUnit) parser.createAST(null);

		cu.accept(new ASTVisitor() {
			
			// Read all declarations and search for interfaces.
			@Override
			public boolean visit(final TypeDeclaration node) {
				if (node.isInterface()) {
					PackageDeclaration packageDecl = cu.getPackage();
					String packageName = "(default).";
					if (packageDecl != null) {
						packageName = packageDecl.getName().getFullyQualifiedName();
					}
					//TODO: use the name with the package if that can be found out by the @Inject annotations.
					String interfaceName = /*packageName + "." + */node.getName().getFullyQualifiedName();
					
					final ComponentInterface componentInterface = createOrFindComponentInterface(interfaceName);
					componentInterface.setExternal(false);
					parentModule.getComponentInterfaces().add(componentInterface);
				}
				return true;
			}

			// Read all annotations and search for @Named components and @Inject.

			@Override
			public boolean visit(final MarkerAnnotation node) {

				final String name = node.getTypeName().getFullyQualifiedName();
				
				if (name.equals("Named")) {
					ASTNode parent = node.getParent();
					if (!(parent instanceof TypeDeclaration)) {
						return true;
					}
					// Create the component implementation
					String componentName = ((TypeDeclaration) parent).getName().getFullyQualifiedName();
					
					final ComponentImplementation componentImplementation = createOrFindComponentImplementation(componentName);
					componentImplementation.setExternal(false);
					parentModule.getComponentImplementations().add(componentImplementation);
					
					// Link this implementation to its interface
					@SuppressWarnings("unchecked") // JavaDoc says it returns List<Type> whereas the Java return type is just List
					List<Type> interfaceTypes = ((TypeDeclaration) parent).superInterfaceTypes();
					for (Type interfaceType : interfaceTypes) {
						if (interfaceType instanceof SimpleType) {
							String interfaceName = ((SimpleType) interfaceType).getName().getFullyQualifiedName();
							final ComponentInterface componentInterface = createOrFindComponentInterface(interfaceName);
							componentInterface.getRequiredProvidedComponentImplementations().add(componentImplementation);
						}
					}
					
				}
				
				
				if (name.equals("Inject")) {
					// Figure out the component, class or interface this injection takes place in.
					ASTNode parent = node;
					while (!(parent == null) && !(parent instanceof TypeDeclaration)) {
						parent = parent.getParent();
					}
					if (parent == null) {
						LOGGER.log(Level.ERROR, "@Inject annotation found that does not belong to any class or interface: " + javaPath);
						return true;
					}
					final TypeDeclaration parentDeclaration = (TypeDeclaration) parent;
					final String parentName = parentDeclaration.getName().getFullyQualifiedName();
					Identifiable requiring;
					if (parentDeclaration.isInterface()) {
						// This is an interface requiring another interface via injection.
						requiring = createOrFindComponentInterface(parentName);
					} else if (isComponentImplementation(parentDeclaration)) {
						// This is an implemented component requiring a service interface via injection.
						requiring = createOrFindComponentImplementation(parentName);
					} else {
						// This is some regular class (i.e., not a component), yet requiring an interface via injection.
						requiring = createOrFindClass(parentName);
					}
					requiring.setExternal(false);

					switch (node.getParent().getNodeType()) {
					case ASTNode.METHOD_DECLARATION:
						// find the type of the Parameters, that might get injected
						final MethodDeclaration methodNode = (MethodDeclaration) node.getParent();
						for (final Object parameter : methodNode.parameters()) {
							final SingleVariableDeclaration variableDeclaration = (SingleVariableDeclaration) parameter;
							final Type injectedInterfaceType = variableDeclaration.getType();
							addInjectedInterfaceConnection(injectedInterfaceType, requiring);
						}

						break;
					case ASTNode.FIELD_DECLARATION:
						// Find the type of the Variable, that gets injected.
						final FieldDeclaration fieldDeclaration = (FieldDeclaration) node.getParent();
						final Type injectedInterfaceType = fieldDeclaration.getType();
						// FIXME: the @Injected artifact is not necessarily an interface, it may as well be a component directly.
						addInjectedInterfaceConnection(injectedInterfaceType, requiring);
						break;
					default:
						break;

					}

				}

				return true;
			}

		});
	}
	
	private void addInjectedInterfaceConnection(Type injectedInterfaceType, EObject requiring) {
		String injectedInterfaceName;
		if (injectedInterfaceType instanceof SimpleType) {
			injectedInterfaceName = ((SimpleType) injectedInterfaceType).getName().getFullyQualifiedName();
		} else {
			LOGGER.log(Level.ERROR, "Could not parse interface name of injection: " + injectedInterfaceType.toString());
			return;
		}
		
		final ComponentInterface injectedInterface = createOrFindComponentInterface(injectedInterfaceName);
		
		// Add this injected interface to the requiring (class|interface).
		
		if (requiring instanceof ComponentInterface) {
			((ComponentInterface) requiring).getRequiredRequiredComponentInterfaces().add(injectedInterface);
		} else if (requiring instanceof ComponentImplementation) {
			((ComponentImplementation) requiring).getRequiredRequiredComponentInterfaces().add(injectedInterface);
		} else if (requiring instanceof Class) {
			((Class) requiring).getRequiredRequiredComponentInterfaces().add(injectedInterface);
		}
	}
	
	private boolean isComponentImplementation(TypeDeclaration declaration) {
		// Any class with an @Named annotation is seen as a component implementation.
		for (Object modifier : declaration.modifiers()) {
			if (modifier instanceof MarkerAnnotation 
					&& ((MarkerAnnotation) modifier).getTypeName().getFullyQualifiedName().equals("Named")) {
				return true;
			}
		}
		return false;
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
					// Ignore /target directories.
					if (!fil.getPath().endsWith(File.separator + "target")) {
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
			} else if (character >= 'A' && character <= 'Z' || character >= 'a' && character <= 'z' || character == '.' || character == '-') {
				sb.append((char) character);
			// Replace all other characters by _
			} else {
				sb.append('_');
			}
		});
		
		return sb.toString();
	}

}
