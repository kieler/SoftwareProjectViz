/**
 * generated by Xtext 2.22.0
 */
package de.cau.cs.kieler.spviz.spviz.sPViz;

import org.eclipse.emf.ecore.EFactory;

/**
 * <!-- begin-user-doc -->
 * The <b>Factory</b> for the model.
 * It provides a create method for each non-abstract class of the model.
 * <!-- end-user-doc -->
 * @see de.cau.cs.kieler.spviz.spviz.sPViz.SPVizPackage
 * @generated
 */
public interface SPVizFactory extends EFactory
{
  /**
   * The singleton instance of the factory.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  SPVizFactory eINSTANCE = de.cau.cs.kieler.spviz.spviz.sPViz.impl.SPVizFactoryImpl.init();

  /**
   * Returns a new object of class '<em>SP Viz</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>SP Viz</em>'.
   * @generated
   */
  SPViz createSPViz();

  /**
   * Returns a new object of class '<em>View</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>View</em>'.
   * @generated
   */
  View createView();

  /**
   * Returns a new object of class '<em>Shown Element</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>Shown Element</em>'.
   * @generated
   */
  ShownElement createShownElement();

  /**
   * Returns a new object of class '<em>Shown Connection</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>Shown Connection</em>'.
   * @generated
   */
  ShownConnection createShownConnection();

  /**
   * Returns the package supported by this factory.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the package supported by this factory.
   * @generated
   */
  SPVizPackage getSPVizPackage();

} //SPVizFactory
