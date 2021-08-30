/**
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 * 
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * Generated by Xtext 2.25.0
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 */
package de.cau.cs.kieler.spviz.spviz.sPViz.impl;

import de.cau.cs.kieler.spviz.spviz.sPViz.SPViz;
import de.cau.cs.kieler.spviz.spviz.sPViz.SPVizFactory;
import de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage;
import de.cau.cs.kieler.spviz.spviz.sPViz.ShownConnection;
import de.cau.cs.kieler.spviz.spviz.sPViz.ShownElement;
import de.cau.cs.kieler.spviz.spviz.sPViz.View;

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModelPackage;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;

import org.eclipse.emf.ecore.impl.EPackageImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model <b>Package</b>.
 * <!-- end-user-doc -->
 * @generated
 */
public class SPVizPackageImpl extends EPackageImpl implements SPVizPackage
{
  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass spVizEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass viewEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass shownElementEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass shownConnectionEClass = null;

  /**
   * Creates an instance of the model <b>Package</b>, registered with
   * {@link org.eclipse.emf.ecore.EPackage.Registry EPackage.Registry} by the package
   * package URI value.
   * <p>Note: the correct way to create the package is via the static
   * factory method {@link #init init()}, which also performs
   * initialization of the package, or returns the registered package,
   * if one already exists.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see org.eclipse.emf.ecore.EPackage.Registry
   * @see de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage#eNS_URI
   * @see #init()
   * @generated
   */
  private SPVizPackageImpl()
  {
    super(eNS_URI, SPVizFactory.eINSTANCE);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private static boolean isInited = false;

  /**
   * Creates, registers, and initializes the <b>Package</b> for this model, and for any others upon which it depends.
   *
   * <p>This method is used to initialize {@link SPVizPackage#eINSTANCE} when that field is accessed.
   * Clients should not invoke it directly. Instead, they should simply access that field to obtain the package.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #eNS_URI
   * @see #createPackageContents()
   * @see #initializePackageContents()
   * @generated
   */
  public static SPVizPackage init()
  {
    if (isInited) return (SPVizPackage)EPackage.Registry.INSTANCE.getEPackage(SPVizPackage.eNS_URI);

    // Obtain or create and register package
    Object registeredSPVizPackage = EPackage.Registry.INSTANCE.get(eNS_URI);
    SPVizPackageImpl theSPVizPackage = registeredSPVizPackage instanceof SPVizPackageImpl ? (SPVizPackageImpl)registeredSPVizPackage : new SPVizPackageImpl();

    isInited = true;

    // Initialize simple dependencies
    SPVizModelPackage.eINSTANCE.eClass();

    // Create package meta-data objects
    theSPVizPackage.createPackageContents();

    // Initialize created meta-data
    theSPVizPackage.initializePackageContents();

    // Mark meta-data to indicate it can't be changed
    theSPVizPackage.freeze();

    // Update the registry and return the package
    EPackage.Registry.INSTANCE.put(SPVizPackage.eNS_URI, theSPVizPackage);
    return theSPVizPackage;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EClass getSPViz()
  {
    return spVizEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EAttribute getSPViz_Package()
  {
    return (EAttribute)spVizEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EAttribute getSPViz_ImportURI()
  {
    return (EAttribute)spVizEClass.getEStructuralFeatures().get(1);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EAttribute getSPViz_Name()
  {
    return (EAttribute)spVizEClass.getEStructuralFeatures().get(2);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EReference getSPViz_Views()
  {
    return (EReference)spVizEClass.getEStructuralFeatures().get(3);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EClass getView()
  {
    return viewEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EAttribute getView_Name()
  {
    return (EAttribute)viewEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EReference getView_ShownElements()
  {
    return (EReference)viewEClass.getEStructuralFeatures().get(1);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EReference getView_ShownConnections()
  {
    return (EReference)viewEClass.getEStructuralFeatures().get(2);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EClass getShownElement()
  {
    return shownElementEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EReference getShownElement_ShownElement()
  {
    return (EReference)shownElementEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EReference getShownElement_ContainedIn()
  {
    return (EReference)shownElementEClass.getEStructuralFeatures().get(1);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EClass getShownConnection()
  {
    return shownConnectionEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EReference getShownConnection_ShownConnection()
  {
    return (EReference)shownConnectionEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EReference getShownConnection_Via()
  {
    return (EReference)shownConnectionEClass.getEStructuralFeatures().get(1);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public SPVizFactory getSPVizFactory()
  {
    return (SPVizFactory)getEFactoryInstance();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private boolean isCreated = false;

  /**
   * Creates the meta-model objects for the package.  This method is
   * guarded to have no affect on any invocation but its first.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void createPackageContents()
  {
    if (isCreated) return;
    isCreated = true;

    // Create classes and their features
    spVizEClass = createEClass(SP_VIZ);
    createEAttribute(spVizEClass, SP_VIZ__PACKAGE);
    createEAttribute(spVizEClass, SP_VIZ__IMPORT_URI);
    createEAttribute(spVizEClass, SP_VIZ__NAME);
    createEReference(spVizEClass, SP_VIZ__VIEWS);

    viewEClass = createEClass(VIEW);
    createEAttribute(viewEClass, VIEW__NAME);
    createEReference(viewEClass, VIEW__SHOWN_ELEMENTS);
    createEReference(viewEClass, VIEW__SHOWN_CONNECTIONS);

    shownElementEClass = createEClass(SHOWN_ELEMENT);
    createEReference(shownElementEClass, SHOWN_ELEMENT__SHOWN_ELEMENT);
    createEReference(shownElementEClass, SHOWN_ELEMENT__CONTAINED_IN);

    shownConnectionEClass = createEClass(SHOWN_CONNECTION);
    createEReference(shownConnectionEClass, SHOWN_CONNECTION__SHOWN_CONNECTION);
    createEReference(shownConnectionEClass, SHOWN_CONNECTION__VIA);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private boolean isInitialized = false;

  /**
   * Complete the initialization of the package and its meta-model.  This
   * method is guarded to have no affect on any invocation but its first.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void initializePackageContents()
  {
    if (isInitialized) return;
    isInitialized = true;

    // Initialize package
    setName(eNAME);
    setNsPrefix(eNS_PREFIX);
    setNsURI(eNS_URI);

    // Obtain other dependent packages
    SPVizModelPackage theSPVizModelPackage = (SPVizModelPackage)EPackage.Registry.INSTANCE.getEPackage(SPVizModelPackage.eNS_URI);

    // Create type parameters

    // Set bounds for type parameters

    // Add supertypes to classes

    // Initialize classes and features; add operations and parameters
    initEClass(spVizEClass, SPViz.class, "SPViz", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEAttribute(getSPViz_Package(), ecorePackage.getEString(), "package", null, 0, 1, SPViz.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEAttribute(getSPViz_ImportURI(), ecorePackage.getEString(), "importURI", null, 0, 1, SPViz.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEAttribute(getSPViz_Name(), ecorePackage.getEString(), "name", null, 0, 1, SPViz.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getSPViz_Views(), this.getView(), null, "views", null, 0, -1, SPViz.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(viewEClass, View.class, "View", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEAttribute(getView_Name(), ecorePackage.getEString(), "name", null, 0, 1, View.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getView_ShownElements(), this.getShownElement(), null, "shownElements", null, 0, -1, View.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getView_ShownConnections(), this.getShownConnection(), null, "shownConnections", null, 0, -1, View.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(shownElementEClass, ShownElement.class, "ShownElement", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getShownElement_ShownElement(), theSPVizModelPackage.getArtifact(), null, "shownElement", null, 0, 1, ShownElement.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getShownElement_ContainedIn(), theSPVizModelPackage.getArtifact(), null, "containedIn", null, 0, 1, ShownElement.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(shownConnectionEClass, ShownConnection.class, "ShownConnection", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getShownConnection_ShownConnection(), theSPVizModelPackage.getConnection(), null, "shownConnection", null, 0, 1, ShownConnection.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getShownConnection_Via(), theSPVizModelPackage.getArtifact(), null, "via", null, 0, 1, ShownConnection.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    // Create resource
    createResource(eNS_URI);
  }

} //SPVizPackageImpl
