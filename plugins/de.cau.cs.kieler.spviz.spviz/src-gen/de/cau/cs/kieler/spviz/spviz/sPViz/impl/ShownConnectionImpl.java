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

import de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage;
import de.cau.cs.kieler.spviz.spviz.sPViz.ShownConnection;

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact;
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Shown Connection</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.impl.ShownConnectionImpl#getShownConnection <em>Shown Connection</em>}</li>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.impl.ShownConnectionImpl#getVia <em>Via</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ShownConnectionImpl extends MinimalEObjectImpl.Container implements ShownConnection
{
  /**
   * The cached value of the '{@link #getShownConnection() <em>Shown Connection</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getShownConnection()
   * @generated
   * @ordered
   */
  protected Connection shownConnection;

  /**
   * The cached value of the '{@link #getVia() <em>Via</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getVia()
   * @generated
   * @ordered
   */
  protected Artifact via;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected ShownConnectionImpl()
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
    return SPVizPackage.Literals.SHOWN_CONNECTION;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public Connection getShownConnection()
  {
    if (shownConnection != null && shownConnection.eIsProxy())
    {
      InternalEObject oldShownConnection = (InternalEObject)shownConnection;
      shownConnection = (Connection)eResolveProxy(oldShownConnection);
      if (shownConnection != oldShownConnection)
      {
        if (eNotificationRequired())
          eNotify(new ENotificationImpl(this, Notification.RESOLVE, SPVizPackage.SHOWN_CONNECTION__SHOWN_CONNECTION, oldShownConnection, shownConnection));
      }
    }
    return shownConnection;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public Connection basicGetShownConnection()
  {
    return shownConnection;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void setShownConnection(Connection newShownConnection)
  {
    Connection oldShownConnection = shownConnection;
    shownConnection = newShownConnection;
    if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, SPVizPackage.SHOWN_CONNECTION__SHOWN_CONNECTION, oldShownConnection, shownConnection));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public Artifact getVia()
  {
    if (via != null && via.eIsProxy())
    {
      InternalEObject oldVia = (InternalEObject)via;
      via = (Artifact)eResolveProxy(oldVia);
      if (via != oldVia)
      {
        if (eNotificationRequired())
          eNotify(new ENotificationImpl(this, Notification.RESOLVE, SPVizPackage.SHOWN_CONNECTION__VIA, oldVia, via));
      }
    }
    return via;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public Artifact basicGetVia()
  {
    return via;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void setVia(Artifact newVia)
  {
    Artifact oldVia = via;
    via = newVia;
    if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, SPVizPackage.SHOWN_CONNECTION__VIA, oldVia, via));
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
      case SPVizPackage.SHOWN_CONNECTION__SHOWN_CONNECTION:
        if (resolve) return getShownConnection();
        return basicGetShownConnection();
      case SPVizPackage.SHOWN_CONNECTION__VIA:
        if (resolve) return getVia();
        return basicGetVia();
    }
    return super.eGet(featureID, resolve, coreType);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void eSet(int featureID, Object newValue)
  {
    switch (featureID)
    {
      case SPVizPackage.SHOWN_CONNECTION__SHOWN_CONNECTION:
        setShownConnection((Connection)newValue);
        return;
      case SPVizPackage.SHOWN_CONNECTION__VIA:
        setVia((Artifact)newValue);
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
      case SPVizPackage.SHOWN_CONNECTION__SHOWN_CONNECTION:
        setShownConnection((Connection)null);
        return;
      case SPVizPackage.SHOWN_CONNECTION__VIA:
        setVia((Artifact)null);
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
      case SPVizPackage.SHOWN_CONNECTION__SHOWN_CONNECTION:
        return shownConnection != null;
      case SPVizPackage.SHOWN_CONNECTION__VIA:
        return via != null;
    }
    return super.eIsSet(featureID);
  }

} //ShownConnectionImpl
