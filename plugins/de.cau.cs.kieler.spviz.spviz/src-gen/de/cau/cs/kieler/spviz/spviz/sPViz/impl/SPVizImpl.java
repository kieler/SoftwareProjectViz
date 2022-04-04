/**
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 * 
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2022 by
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

import de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactShows;
import de.cau.cs.kieler.spviz.spviz.sPViz.SPViz;
import de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage;
import de.cau.cs.kieler.spviz.spviz.sPViz.View;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>SP Viz</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.impl.SPVizImpl#getPackage <em>Package</em>}</li>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.impl.SPVizImpl#getImportURI <em>Import URI</em>}</li>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.impl.SPVizImpl#getName <em>Name</em>}</li>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.impl.SPVizImpl#getViews <em>Views</em>}</li>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.impl.SPVizImpl#getArtifactShows <em>Artifact Shows</em>}</li>
 * </ul>
 *
 * @generated
 */
public class SPVizImpl extends MinimalEObjectImpl.Container implements SPViz
{
  /**
   * The default value of the '{@link #getPackage() <em>Package</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getPackage()
   * @generated
   * @ordered
   */
  protected static final String PACKAGE_EDEFAULT = null;

  /**
   * The cached value of the '{@link #getPackage() <em>Package</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getPackage()
   * @generated
   * @ordered
   */
  protected String package_ = PACKAGE_EDEFAULT;

  /**
   * The default value of the '{@link #getImportURI() <em>Import URI</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getImportURI()
   * @generated
   * @ordered
   */
  protected static final String IMPORT_URI_EDEFAULT = null;

  /**
   * The cached value of the '{@link #getImportURI() <em>Import URI</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getImportURI()
   * @generated
   * @ordered
   */
  protected String importURI = IMPORT_URI_EDEFAULT;

  /**
   * The default value of the '{@link #getName() <em>Name</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getName()
   * @generated
   * @ordered
   */
  protected static final String NAME_EDEFAULT = null;

  /**
   * The cached value of the '{@link #getName() <em>Name</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getName()
   * @generated
   * @ordered
   */
  protected String name = NAME_EDEFAULT;

  /**
   * The cached value of the '{@link #getViews() <em>Views</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getViews()
   * @generated
   * @ordered
   */
  protected EList<View> views;

  /**
   * The cached value of the '{@link #getArtifactShows() <em>Artifact Shows</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getArtifactShows()
   * @generated
   * @ordered
   */
  protected EList<ArtifactShows> artifactShows;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected SPVizImpl()
  {
    super();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  protected EClass eStaticClass()
  {
    return SPVizPackage.Literals.SP_VIZ;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public String getPackage()
  {
    return package_;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void setPackage(String newPackage)
  {
    String oldPackage = package_;
    package_ = newPackage;
    if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, SPVizPackage.SP_VIZ__PACKAGE, oldPackage, package_));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public String getImportURI()
  {
    return importURI;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void setImportURI(String newImportURI)
  {
    String oldImportURI = importURI;
    importURI = newImportURI;
    if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, SPVizPackage.SP_VIZ__IMPORT_URI, oldImportURI, importURI));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public String getName()
  {
    return name;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void setName(String newName)
  {
    String oldName = name;
    name = newName;
    if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, SPVizPackage.SP_VIZ__NAME, oldName, name));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EList<View> getViews()
  {
    if (views == null)
    {
      views = new EObjectContainmentEList<View>(View.class, this, SPVizPackage.SP_VIZ__VIEWS);
    }
    return views;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EList<ArtifactShows> getArtifactShows()
  {
    if (artifactShows == null)
    {
      artifactShows = new EObjectContainmentEList<ArtifactShows>(ArtifactShows.class, this, SPVizPackage.SP_VIZ__ARTIFACT_SHOWS);
    }
    return artifactShows;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs)
  {
    switch (featureID)
    {
      case SPVizPackage.SP_VIZ__VIEWS:
        return ((InternalEList<?>)getViews()).basicRemove(otherEnd, msgs);
      case SPVizPackage.SP_VIZ__ARTIFACT_SHOWS:
        return ((InternalEList<?>)getArtifactShows()).basicRemove(otherEnd, msgs);
    }
    return super.eInverseRemove(otherEnd, featureID, msgs);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public Object eGet(int featureID, boolean resolve, boolean coreType)
  {
    switch (featureID)
    {
      case SPVizPackage.SP_VIZ__PACKAGE:
        return getPackage();
      case SPVizPackage.SP_VIZ__IMPORT_URI:
        return getImportURI();
      case SPVizPackage.SP_VIZ__NAME:
        return getName();
      case SPVizPackage.SP_VIZ__VIEWS:
        return getViews();
      case SPVizPackage.SP_VIZ__ARTIFACT_SHOWS:
        return getArtifactShows();
    }
    return super.eGet(featureID, resolve, coreType);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @SuppressWarnings("unchecked")
  @Override
  public void eSet(int featureID, Object newValue)
  {
    switch (featureID)
    {
      case SPVizPackage.SP_VIZ__PACKAGE:
        setPackage((String)newValue);
        return;
      case SPVizPackage.SP_VIZ__IMPORT_URI:
        setImportURI((String)newValue);
        return;
      case SPVizPackage.SP_VIZ__NAME:
        setName((String)newValue);
        return;
      case SPVizPackage.SP_VIZ__VIEWS:
        getViews().clear();
        getViews().addAll((Collection<? extends View>)newValue);
        return;
      case SPVizPackage.SP_VIZ__ARTIFACT_SHOWS:
        getArtifactShows().clear();
        getArtifactShows().addAll((Collection<? extends ArtifactShows>)newValue);
        return;
    }
    super.eSet(featureID, newValue);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void eUnset(int featureID)
  {
    switch (featureID)
    {
      case SPVizPackage.SP_VIZ__PACKAGE:
        setPackage(PACKAGE_EDEFAULT);
        return;
      case SPVizPackage.SP_VIZ__IMPORT_URI:
        setImportURI(IMPORT_URI_EDEFAULT);
        return;
      case SPVizPackage.SP_VIZ__NAME:
        setName(NAME_EDEFAULT);
        return;
      case SPVizPackage.SP_VIZ__VIEWS:
        getViews().clear();
        return;
      case SPVizPackage.SP_VIZ__ARTIFACT_SHOWS:
        getArtifactShows().clear();
        return;
    }
    super.eUnset(featureID);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public boolean eIsSet(int featureID)
  {
    switch (featureID)
    {
      case SPVizPackage.SP_VIZ__PACKAGE:
        return PACKAGE_EDEFAULT == null ? package_ != null : !PACKAGE_EDEFAULT.equals(package_);
      case SPVizPackage.SP_VIZ__IMPORT_URI:
        return IMPORT_URI_EDEFAULT == null ? importURI != null : !IMPORT_URI_EDEFAULT.equals(importURI);
      case SPVizPackage.SP_VIZ__NAME:
        return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
      case SPVizPackage.SP_VIZ__VIEWS:
        return views != null && !views.isEmpty();
      case SPVizPackage.SP_VIZ__ARTIFACT_SHOWS:
        return artifactShows != null && !artifactShows.isEmpty();
    }
    return super.eIsSet(featureID);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public String toString()
  {
    if (eIsProxy()) return super.toString();

    StringBuilder result = new StringBuilder(super.toString());
    result.append(" (package: ");
    result.append(package_);
    result.append(", importURI: ");
    result.append(importURI);
    result.append(", name: ");
    result.append(name);
    result.append(')');
    return result.toString();
  }

} //SPVizImpl
