/**
 * generated by Xtext 2.22.0
 */
package de.cau.cs.kieler.spviz.spvizmodel.sPVizModel;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Containment</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Containment#getContains <em>Contains</em>}</li>
 * </ul>
 *
 * @see de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModelPackage#getContainment()
 * @model
 * @generated
 */
public interface Containment extends Reference
{
  /**
   * Returns the value of the '<em><b>Contains</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the value of the '<em>Contains</em>' reference.
   * @see #setContains(Artifact)
   * @see de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModelPackage#getContainment_Contains()
   * @model
   * @generated
   */
  Artifact getContains();

  /**
   * Sets the value of the '{@link de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Containment#getContains <em>Contains</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Contains</em>' reference.
   * @see #getContains()
   * @generated
   */
  void setContains(Artifact value);

} // Containment
