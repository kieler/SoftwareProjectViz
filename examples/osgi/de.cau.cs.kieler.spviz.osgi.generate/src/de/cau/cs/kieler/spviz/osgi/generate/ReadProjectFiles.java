// ******************************************************************************
//
// Copyright (c) 2018-2021 by
// Scheidt & Bachmann System Technik GmbH, 24145 Kiel
//
// This program and the accompanying materials are made available under the
// terms of the Eclipse Public License 2.0 which is available at
// http://www.eclipse.org/legal/epl-2.0.
// 
// SPDX-License-Identifier: EPL-2.0
//
// ******************************************************************************

package de.cau.cs.kieler.spviz.osgi.generate;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.jar.Attributes;
import java.util.jar.Manifest;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import de.cau.cs.kieler.spviz.osgi.model.Bundle;
import de.cau.cs.kieler.spviz.osgi.model.Feature;
import de.cau.cs.kieler.spviz.osgi.model.ModelFactory;
import de.cau.cs.kieler.spviz.osgi.model.OSGiProject;
import de.cau.cs.kieler.spviz.osgi.model.Package;
import de.cau.cs.kieler.spviz.osgi.model.Product;
import de.cau.cs.kieler.spviz.osgi.model.ServiceComponent;
import de.cau.cs.kieler.spviz.osgi.model.ServiceInterface;

/**
 * This class reads all the data for osgi artifacts from the artifact files. It
 * searches the project folder for all osgi specific files. For the
 * documentation javadoc comments are parsed and about.html/about.txt files are
 * extracted.
 *
 * For bundles it reads the belonging MANIFEST.MF file and searches for an about
 * file. For features it reads the feature.xml file and searches for an about
 * file. For services it reads all the service 00 files and parses the javadoc
 * comment from the implementing class. For service interfaces it reads all
 * service interface references of the service components and parses the javadoc
 * from the service interface class. For products it searches for product files
 * and an about file.
 *
 * @author dams
 *
 */
public class ReadProjectFiles {

	static final java.lang.System.Logger LOGGER = System.getLogger(OsgiModelDataGenerator.class.getName());

	final OSGiProject project = ModelFactory.eINSTANCE.createOSGiProject();
//	private final List<Package> packageDependencies = new ArrayList<Package>();
	private final List<Path> filePaths = new ArrayList<Path>();


	/**
	 * Generates the HashMaps with Data for bundles, features, services and
	 * products.
	 *
	 * @param projectPath to extract osgi data from
	 * @return OsgiProject with all OSGI objects (bundles, features, services,
	 *         products, service interfaces)
	 */
	public OSGiProject generateData(final File projectPath, final String projectName) {
		
		// Parsing of manifest data
		filePaths.clear();
		findFiles(StaticVariables.MANIFEST_FILE, projectPath);
		for (final Path manifestPath : filePaths) {
			extractBundleData(manifestPath);
		}
		
		// parsing of feature data
		filePaths.clear();
		findFiles(StaticVariables.FEATURE_FILE, projectPath);
		for (final Path featurePath : filePaths) {
			extractFeatureData(featurePath);
		}
		
		// parsing of product data
		filePaths.clear();
		findFiles(StaticVariables.PRODUCT_FILE, projectPath);
		for (final Path productPath : filePaths) {
			extractProductData(productPath);
		}
		
		
		return project;

	}

	/**
	 * Extracts all relevant properties of a bundle into a HashMap of bundles.
	 *
	 * @param manifestPath is the path to the prepared manifest file
	 */
	// CHECKSTYLE IGNORE check FOR NEXT 1 LINES
	private void extractBundleData(final Path manifestPath) {
		String symbolicName = StaticVariables.EMPTY_STRING;
		final Path manifestFolder = manifestPath.getParent();
		Path bundleRoot = null;
		if (manifestFolder != null) {
			bundleRoot = manifestFolder.getParent();
		}
		
		try (final InputStream is = new FileInputStream(manifestPath.toString())){
			final Manifest manifest = new Manifest(is);
			final Attributes attributes = manifest.getMainAttributes();
			
			symbolicName = getAndRemove(attributes, StaticVariables.BUNDLE_SYMBOLIC_NAME);
			
			// check, if bundle is already existing
			final Bundle bundle = getOrCreateBundle(symbolicName);
			
			extractPackages(bundle, attributes);
			
			// check all required bundles and create them, if not existing
			for (final String requiredBundleName : getList(attributes, StaticVariables.REQUIRE_BUNDLE)) {
				final Bundle requiredBundle = getOrCreateBundle(requiredBundleName);
				requiredBundle.getRequiringDependencyBundles().add(bundle);
				bundle.getRequiredDependencyBundles().add(requiredBundle);
			}
			
			extractServiceComponents(bundle, bundleRoot, attributes);
			
		} catch (final IOException e) {
			LOGGER.log(System.Logger.Level.ERROR, "There was an error with reading the manifest file " + e); //$NON-NLS-1$
		}
	}
	
	/**
	 * Generates a list of {@link PackageObject} for a bundle. Packages can be
	 * exported or imported packages of a bundle
	 *
	 * @param bundle     is the bundle which exports/imports the packages
	 * @param attributes is the String of packages
	 * @param key        describes whether the packages are imported or exported
	 * @return
	 */
	private void extractPackages(final Bundle bundle, final Attributes attributes) {
		for (final String importOrExport : new String[] { StaticVariables.EXPORT_PACKAGE,
				StaticVariables.IMPORT_PACKAGE }) {

			final String packageIds = attributes.getValue(importOrExport);
			attributes.remove(new Attributes.Name(importOrExport));
			
			if (null == packageIds) {
				continue;
			}
			
			for (final String b : packageIds.replaceAll("\\s", "").replaceAll("\"(.*?)\"", "").split(",")) { //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
				final String packageName = b.split(";")[0]; //$NON-NLS-1$			
				
				if (importOrExport.equals(StaticVariables.EXPORT_PACKAGE)) {
					final Package newExportedPackage = ModelFactory.eINSTANCE.createPackage();
					newExportedPackage.setName(packageName);
					newExportedPackage.setEcoreId(StaticVariables.PACKAGE_PREFIX + packageName);
					newExportedPackage.getBundles().add(bundle);
					bundle.getPackages().add(newExportedPackage);
					project.getPackages().add(newExportedPackage);
				} else {
//					final Optional<Package> knownImportedPackage = packageDependencies//
//							.stream()//
//							.filter(elem -> elem.getName().equals(packageName))//
//							.findFirst();
					final Optional<Package> ownProjectPackage = project.getPackages()//
							.stream()//
							.filter(elem -> elem.getName().equals(packageName))//
							.findFirst();
					if (ownProjectPackage.isPresent()) {
						ownProjectPackage.get().getRequiringPackageDependencyBundles().add(bundle);
						bundle.getRequiredPackageDependencyPackages().add(ownProjectPackage.get());
//					} else if (knownImportedPackage.isPresent()) {
//						bundle.getPackageDependency().add(knownImportedPackage.get());
					} else {
						final Package newImportedPackage = ModelFactory.eINSTANCE.createPackage();
						newImportedPackage.setName(packageName);
						newImportedPackage.setEcoreId(StaticVariables.PACKAGE_PREFIX + packageName);
						newImportedPackage.getRequiringPackageDependencyBundles().add(bundle);
						bundle.getRequiredPackageDependencyPackages().add(newImportedPackage);
//						packageDependencies.add(newImportedPackage);
						project.getPackages().add(newImportedPackage);
					}
				}
			}
		}
	}
	
	
	private void extractServiceComponents (final Bundle bundle, final Path bundleRoot, final Attributes attributes) {
		final List<String> serviceComponents = getList(attributes, StaticVariables.SERVICE_COMPONENT);
		if (serviceComponents.contains("OSGI-INF/*.xml")) {
			if (!new File(bundleRoot + "/OSGI-INF").exists()) { //$NON-NLS-1$
				LOGGER.log(System.Logger.Level.INFO, "The MANIFEST-INF folder and the OSGI-INF folder are not in the same path."); //$NON-NLS-1$
			}
			final File serviceComponentsFolder = new File(bundleRoot + "/OSGI-INF/");
			final File[] serviceComponentFiles = serviceComponentsFolder
					.listFiles((dir, name) -> name.toLowerCase().endsWith(".xml"));

			if (serviceComponentFiles != null) {
				for (final File serviceComponentFile : serviceComponentFiles) {

					final ServiceComponent serviceComponent = ModelFactory.eINSTANCE.createServiceComponent();
					String componentName = serviceComponentFile.getName()
							.replace(".xml", StaticVariables.EMPTY_STRING);
					serviceComponent.setName(componentName);
					serviceComponent.setEcoreId(StaticVariables.SERVICE_COMPONENT_PREFIX + componentName);
					serviceComponent.getBundles().add(bundle);
					bundle.getServiceComponents().add(serviceComponent);
					project.getServiceComponents().add(serviceComponent);
					
					extractServiceInterfaces(bundle, serviceComponent, serviceComponentFile);
				}
			}
		} else {
			for (final String service : serviceComponents) {
				final String serviceName = service.replace(".xml", StaticVariables.EMPTY_STRING).replace( //$NON-NLS-1$
						"OSGI-INF/", StaticVariables.EMPTY_STRING);
				final ServiceComponent serviceComponent = ModelFactory.eINSTANCE.createServiceComponent();
				serviceComponent.setName(serviceName);
				serviceComponent.setEcoreId(StaticVariables.SERVICE_COMPONENT_PREFIX + serviceName);
				serviceComponent.getBundles().add(bundle);
				bundle.getServiceComponents().add(serviceComponent);
				project.getServiceComponents().add(serviceComponent);
				
				final File serviceComponentFile = new File(bundleRoot + "\\" + service);
				extractServiceInterfaces(bundle, serviceComponent, serviceComponentFile);
			}
		}
		
	}
	
	private void extractServiceInterfaces(final Bundle bundle, final ServiceComponent serviceComponent, final File xmlFile) {
		try {
			final DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder;
			dBuilder = dbFactory.newDocumentBuilder();
			final Document doc = dBuilder.parse(xmlFile);
			final NodeList providedInterfaceList = doc.getElementsByTagName(StaticVariables.PROVIDE);
			// read interface
			if (providedInterfaceList.getLength() != 0) {
				for (int x = 0, size = providedInterfaceList.getLength(); x < size; x++) {
					final String interfaceName = providedInterfaceList.item(x).getAttributes()
							.getNamedItem(StaticVariables.INTERFACE).getNodeValue();
					
					final Optional<ServiceInterface> serviceInterfaceOptional = project.getServiceInterfaces()//
							.stream()//
							.filter(elem -> elem.getName().equals(interfaceName))//
							.findFirst();
					if (serviceInterfaceOptional.isPresent()) {
						serviceInterfaceOptional.get().getRequiringRequiredServiceComponents().add(serviceComponent);
						serviceComponent.getRequiredRequiredServiceInterfaces().add(serviceInterfaceOptional.get());
					} else {
						final ServiceInterface serviceInterface = ModelFactory.eINSTANCE.createServiceInterface();
						serviceInterface.setName(interfaceName);
						serviceInterface.setEcoreId(StaticVariables.SERVICE_INTERFACE_PREFIX + interfaceName);
						serviceInterface.getRequiringRequiredServiceComponents().add(serviceComponent);
						serviceComponent.getRequiredRequiredServiceInterfaces().add(serviceInterface);
						bundle.getServiceInterfaces().add(serviceInterface);
						project.getServiceInterfaces().add(serviceInterface);
					}
				}
			}
			
			//
			// REQUIRED
			//
			
		} catch (ParserConfigurationException | SAXException | IOException e) {
			LOGGER.log(System.Logger.Level.ERROR, "There was an error with reading the service xml file " + e); //$NON-NLS-1$
		}
	}


	/**
	 * extracts information out of the feature xml file in featurepath, and adds it
	 * to the feature HashMap
	 *
	 * @param featurePath is the path to the feature.xml file
	 */
	private void extractFeatureData(final Path featurePath) {
		final File xmlFile = featurePath.toFile();
		final DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder;
		
		try {
			dBuilder = dbFactory.newDocumentBuilder();
			final Document doc = dBuilder.parse(xmlFile);
			final NodeList pluginNodeList = doc.getElementsByTagName(StaticVariables.PLUGIN);
			
			final Feature feature = ModelFactory.eINSTANCE.createFeature();
			project.getFeatures().add(feature);
			
			for (int x = 0, size = pluginNodeList.getLength(); x < size; x++) {
				final String plugin = pluginNodeList.item(x).getAttributes().getNamedItem(StaticVariables.ID)
						.getNodeValue();
				Bundle bundle = getOrCreateBundle(plugin);
				bundle.getFeatures().add(feature);
				feature.getBundles().add(bundle);
			}
			String featureName = doc.getDocumentElement().getAttribute(StaticVariables.ID);
			feature.setName(featureName);
			feature.setEcoreId(StaticVariables.FEATURE_PREFIX + featureName);
			
		} catch (ParserConfigurationException | SAXException | IOException e) {
			LOGGER.log(System.Logger.Level.ERROR, "There was an error with reading the feature.xml file " + e); //$NON-NLS-1$
		}
	}

	// CHECKSTYLEON NPathComplexity
	/**
	 * extracts information out of the product file, and adds it to productData.
	 *
	 * @param productPath is the path to the product file
	 */
	private void extractProductData(final Path productPath) {
		final DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder;
		try {
			dBuilder = dbFactory.newDocumentBuilder();
			final Document doc = dBuilder.parse(productPath.toString());
//			final String productName = doc.getDocumentElement().getAttribute(StaticVariables.NAME);
			final String productName = doc.getDocumentElement().getAttribute(StaticVariables.UNIQUE_ID);
			
			final Product product = ModelFactory.eINSTANCE.createProduct();
			product.setName(productName);
			product.setEcoreId(StaticVariables.PRODUCT_PREFIX + productName);
			
			project.getProducts().add(product);
			
			final NodeList featureNodeList = doc.getElementsByTagName(StaticVariables.FEATURE);
			for (int x = 0, size = featureNodeList.getLength(); x < size; x++) {
				final String featureName = featureNodeList.item(x).getAttributes().getNamedItem(StaticVariables.ID)
						.getNodeValue();
				final Optional<Feature> featureOptional = project.getFeatures()//
						.stream()//
						.filter(elem -> elem.getName().equals(featureName))//
						.findFirst();

				if (featureOptional.isPresent()) {
					Feature feature = featureOptional.get();
					feature.getProducts().add(product);
					product.getFeatures().add(feature);
				} else {
					final Feature feature = ModelFactory.eINSTANCE.createFeature();
					feature.setName(featureName);
					feature.setEcoreId(StaticVariables.FEATURE_PREFIX + featureName);
					feature.getProducts().add(product);
					product.getFeatures().add(feature);
					project.getFeatures().add(feature);
				}
			}
			
			final NodeList bundleNodeList = doc.getElementsByTagName(StaticVariables.PLUGIN);
			for (int x = 0, size = bundleNodeList.getLength(); x < size; x++) {
				final String bundleName = bundleNodeList.item(x).getAttributes().getNamedItem(StaticVariables.ID)
						.getNodeValue();
				final Optional<Bundle> bundleOptional = project.getBundles()//
						.stream()//
						.filter(elem -> elem.getName().equals(bundleName))//
						.findFirst();
				if (bundleOptional.isPresent()) {
					Bundle bundle = bundleOptional.get();
					bundle.getProducts().add(product);
					product.getBundles().add(bundle);
				} else {
					final Bundle bundle = ModelFactory.eINSTANCE.createBundle();
					bundle.setName(bundleName);
					bundle.setEcoreId(StaticVariables.BUNDLE_PREFIX + bundleName);
					bundle.getProducts().add(product);
					product.getBundles().add(bundle);
					project.getBundles().add(bundle);
				}
			}
		} catch (ParserConfigurationException | SAXException | IOException e) {
			LOGGER.log(System.Logger.Level.ERROR, "There was an error with reading the product xml file " + e); //$NON-NLS-1$
		}
	}

	
	/**
	 * returns a bundle if it already exists, else bundle is created
	 *
	 * @param uniqueId is the unique id of the bundle
	 * @return bundle Object
	 */
	private Bundle getOrCreateBundle(final String name) {
		final Optional<Bundle> bundleAlreadyPresent = project.getBundles()//
				.stream()//
				.filter(elem -> elem.getEcoreId().equals(StaticVariables.BUNDLE_PREFIX + name))//
				.findFirst();
		if (bundleAlreadyPresent.isPresent()) {
			return bundleAlreadyPresent.get();
		} else {
			final Bundle bundle = ModelFactory.eINSTANCE.createBundle();
			bundle.setName(name);
			bundle.setEcoreId(StaticVariables.BUNDLE_PREFIX + name);
			project.getBundles().add(bundle);
			return bundle;
		}
	}
	
	/**
	 * Finds all files in a directory and all its subdirectories. Adds the path to
	 * the files to List <em>filePaths</em>
	 *
	 * @param name Filename you search for
	 * @param file Path you search in
	 *
	 */
	private void findFiles(final String name, final File file) {
		final File[] list = file.listFiles();

		if (list != null) {
			for (final File fil : list) {
				if (fil.isDirectory()) {
					// Ignore /target directories.
					if (!fil.getPath().endsWith(File.separator + "target")) {
						findFiles(name, fil);
					}
				} else if (fil.getName().endsWith(name)) {
					Path filePath = Paths.get(fil.getPath());
					filePaths.add(filePath);
				}
			}
		}
	}


	/**
	 * Returns the value of the attribute "key" out of an attribute list and removes
	 * it from the list.
	 *
	 * @param attributes the list of attributes
	 * @param key        the attribute asked for
	 * @return the value of the attribute, if the attribute does not exist, return
	 *         is null.
	 */
	private static String getAndRemove(final Attributes attributes, final String key) {
		final String value = attributes.getValue(key);
		attributes.remove(new Attributes.Name(key));
		if (null == value) {
			return StaticVariables.NOT_SET;
		}

		return value.split(";")[0]; //$NON-NLS-1$
	}

	/**
	 * Returns the value (comma separated list) of the attribute "key" out of an
	 * attribute list and removes it from the list. Splits the comma separated
	 * String of Strings into a list of Strings.
	 *
	 * @param attributes
	 * @param key
	 * @return
	 */
	private static List<String> getList(final Attributes attributes, final String key) {
		final String list = attributes.getValue(key);
		attributes.remove(new Attributes.Name(key));
		final List<String> result = new ArrayList<String>();
		if (null == list) {
			return result;
		}
		for (final String b : list.replaceAll("\"(.*?)\"", "")// remove all characters between '"'
				.replaceAll("\\s", "")// remove all whitespaces
				.split(",")) { //$NON-NLS-1$
			result.add(b.split(";")[0]); //$NON-NLS-1$
		}
		return result;
	}

}
