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
package de.cau.cs.kieler.spviz.spviz.sPViz;

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Artifact Shows</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactShows#getArtifactShows <em>Artifact Shows</em>}</li>
 *   <li>{@link de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactShows#getViews <em>Views</em>}</li>
 * </ul>
 *
 * @see de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage#getArtifactShows()
 * @model
 * @generated
 */
public interface ArtifactShows extends EObject
{
  /**
   * Returns the value of the '<em><b>Artifact Shows</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Artifact Shows</em>' reference.
   * @see #setArtifactShows(Artifact)
   * @see de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage#getArtifactShows_ArtifactShows()
   * @model
   * @generated
   */
  Artifact getArtifactShows();

  /**
   * Sets the value of the '{@link de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactShows#getArtifactShows <em>Artifact Shows</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Artifact Shows</em>' reference.
   * @see #getArtifactShows()
   * @generated
   */
  void setArtifactShows(Artifact value);

  /**
   * Returns the value of the '<em><b>Views</b></em>' containment reference list.
   * The list contents are of type {@link de.cau.cs.kieler.spviz.spviz.sPViz.ArtifactView}.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Views</em>' containment reference list.
   * @see de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage#getArtifactShows_Views()
   * @model containment="true"
   * @generated
   */
  EList<ArtifactView> getViews();

} // ArtifactShows
