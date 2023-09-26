/**
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 * 
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2023 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * Generated by Xtext 2.27.0
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 */
package de.cau.cs.kieler.spviz.spviz.sPViz;

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Shown Category Connection</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.ShownCategoryConnection#getConnection <em>Connection</em>}</li>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.ShownCategoryConnection#getSourceChain <em>Source Chain</em>}</li>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.ShownCategoryConnection#getInnerView <em>Inner View</em>}</li>
 * </ul>
 *
 * @see de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage#getShownCategoryConnection()
 * @model
 * @generated
 */
public interface ShownCategoryConnection extends EObject
{
  /**
   * Returns the value of the '<em><b>Connection</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Connection</em>' reference.
   * @see #setConnection(Connection)
   * @see de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage#getShownCategoryConnection_Connection()
   * @model
   * @generated
   */
  Connection getConnection();

  /**
   * Sets the value of the '{@link de.cau.cs.kieler.spviz.spviz.sPViz.ShownCategoryConnection#getConnection <em>Connection</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Connection</em>' reference.
   * @see #getConnection()
   * @generated
   */
  void setConnection(Connection value);

  /**
   * Returns the value of the '<em><b>Source Chain</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Source Chain</em>' containment reference.
   * @see #setSourceChain(ArtifactChain)
   * @see de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage#getShownCategoryConnection_SourceChain()
   * @model containment="true"
   * @generated
   */
  ArtifactChain getSourceChain();

  /**
   * Sets the value of the '{@link de.cau.cs.kieler.spviz.spviz.sPViz.ShownCategoryConnection#getSourceChain <em>Source Chain</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Source Chain</em>' containment reference.
   * @see #getSourceChain()
   * @generated
   */
  void setSourceChain(ArtifactChain value);

  /**
   * Returns the value of the '<em><b>Inner View</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Inner View</em>' reference.
   * @see #setInnerView(View)
   * @see de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage#getShownCategoryConnection_InnerView()
   * @model
   * @generated
   */
  View getInnerView();

  /**
   * Sets the value of the '{@link de.cau.cs.kieler.spviz.spviz.sPViz.ShownCategoryConnection#getInnerView <em>Inner View</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Inner View</em>' reference.
   * @see #getInnerView()
   * @generated
   */
  void setInnerView(View value);

} // ShownCategoryConnection
