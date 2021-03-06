/**
 * <copyright>
 * </copyright>
 *
 * $Id$
 */
package kdm.code;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Template Unit</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link kdm.code.TemplateUnit#getCodeElement <em>Code Element</em>}</li>
 * </ul>
 * </p>
 *
 * @see kdm.code.CodePackage#getTemplateUnit()
 * @model
 * @generated
 */
public interface TemplateUnit extends Datatype {
	/**
	 * Returns the value of the '<em><b>Code Element</b></em>' containment reference list.
	 * The list contents are of type {@link kdm.code.CodeItem}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Code Element</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Code Element</em>' containment reference list.
	 * @see kdm.code.CodePackage#getTemplateUnit_CodeElement()
	 * @model containment="true"
	 * @generated
	 */
	EList<CodeItem> getCodeElement();

} // TemplateUnit
