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
package de.cau.cs.kieler.spviz.spvizmodel.sPVizModel;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>SP Viz Model</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel#getPackage <em>Package</em>}</li>
 *   <li>{@link de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel#getName <em>Name</em>}</li>
 *   <li>{@link de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel#getArtifacts <em>Artifacts</em>}</li>
 * </ul>
 *
 * @see de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModelPackage#getSPVizModel()
 * @model
 * @generated
 */
public interface SPVizModel extends EObject
{
  /**
   * Returns the value of the '<em><b>Package</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Package</em>' attribute.
   * @see #setPackage(String)
   * @see de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModelPackage#getSPVizModel_Package()
   * @model
   * @generated
   */
  String getPackage();

  /**
   * Sets the value of the '{@link de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel#getPackage <em>Package</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Package</em>' attribute.
   * @see #getPackage()
   * @generated
   */
  void setPackage(String value);

  /**
   * Returns the value of the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Name</em>' attribute.
   * @see #setName(String)
   * @see de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModelPackage#getSPVizModel_Name()
   * @model
   * @generated
   */
  String getName();

  /**
   * Sets the value of the '{@link de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel#getName <em>Name</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Name</em>' attribute.
   * @see #getName()
   * @generated
   */
  void setName(String value);

  /**
   * Returns the value of the '<em><b>Artifacts</b></em>' containment reference list.
   * The list contents are of type {@link de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact}.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Artifacts</em>' containment reference list.
   * @see de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModelPackage#getSPVizModel_Artifacts()
   * @model containment="true"
   * @generated
   */
  EList<Artifact> getArtifacts();

} // SPVizModel
