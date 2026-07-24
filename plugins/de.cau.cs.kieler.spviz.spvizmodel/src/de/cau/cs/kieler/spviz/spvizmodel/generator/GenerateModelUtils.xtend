/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright 2021-2026 by
 * + Kiel University
 *   + Department of Computer Science
 *   + Real-Time and Embedded Systems Group
 * + and Scheidt & Bachmann System Technik GmbH, 24109 Melsdorf
 * 
 * This code is provided under the terms of the Eclipse Public License 2.0 (EPL-2.0).
 */
package de.cau.cs.kieler.spviz.spvizmodel.generator

import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection
import java.io.File

/**
 * Generates utility classes for the model.
 * 
 * @author nre, leo
 */
class GenerateModelUtils {
    def static void generate(File sourceFolder, SPVizModel spvizModel) {
        val folder = FileGenerator.createDirectory(sourceFolder, spvizModel.package.replace('.', '/') + "/model/util/")
        FileGenerator.updateFile(folder, "ModelUtil.java", generateModelUtil(spvizModel))
    }
    
    /**
     * Generates the content for the ModelUtil.java file contained inside the model package
     * 
     * @param projectName
     *      the model project name
     * @param importedNamespace
     *         the model package name
     * @return 
     *         the generated file content as a string
     */
    private def static String generateModelUtil(SPVizModel spvizModel){
        val importedNamespace = spvizModel.package
        return '''
            package «importedNamespace».model.util;

            import «importedNamespace».model.ConnectionLabel;
            import «importedNamespace».model.Identifiable;
            import «importedNamespace».model.«spvizModel.name»Factory;
            «FOR artifact : spvizModel.artifacts»
                import «importedNamespace».model.«artifact.name»;
            «ENDFOR»
            «FOR artifact : spvizModel.artifacts»
                «FOR connection : artifact.references.filter(Connection)»
                    import «importedNamespace».model.«directLabelClassName(artifact, connection)»;
                    import «importedNamespace».model.«contextLabelClassName(artifact, connection)»;
                «ENDFOR»
            «ENDFOR»
            import org.eclipse.emf.ecore.EObject;
            
            /**
             * Handy methods for handling with OSGi model elements.
             */
            public final class ModelUtil {
                
                «FOR artifact : spvizModel.artifacts»
                    «FOR connection : artifact.references.filter(Connection)»
                        /**
                         * Connects {@code source} to {@code target}.
                         */
                        public static void add«connection.name.toFirstUpper»(«artifact.name» source,
                                «connection.connects.name» target) {
                            requireEndpoints(source, target);
                            if (!source.getConnected«connection.name.toFirstUpper»«connection.connects.name.toFirstUpper»s().contains(target)) {
                                source.getConnected«connection.name.toFirstUpper»«connection.connects.name.toFirstUpper»s().add(target);
                            }
                        }

                        /**
                         * Connects {@code source} to {@code target} and sets the global label for this
                         * «connection.name» connection.
                         */
                        public static void add«connection.name.toFirstUpper»(«artifact.name» source,
                                «connection.connects.name» target, String label) {
                            add«connection.name.toFirstUpper»(source, target);

                            «directLabelClassName(artifact, connection)» connectionLabel = null;
                            for (ConnectionLabel candidate : source.getConnectionLabels()) {
                                if (candidate instanceof «directLabelClassName(artifact, connection)»
                                        && ((«directLabelClassName(artifact, connection)») candidate).getTarget() == target) {
                                    connectionLabel = («directLabelClassName(artifact, connection)») candidate;
                                    break;
                                }
                            }
                            if (connectionLabel == null) {
                                connectionLabel = «spvizModel.name»Factory.eINSTANCE.create«directLabelClassName(artifact, connection)»();
                                connectionLabel.setTarget(target);
                                source.getConnectionLabels().add(connectionLabel);
                            }
                            connectionLabel.setLabel(label);
                        }

                        /**
                         * Connects {@code source} to {@code target} and sets a label visible only while
                         * rendering the connection in {@code context}.
                         */
                        public static void add«connection.name.toFirstUpper»InContext(«artifact.name» source,
                                «connection.connects.name» target, Identifiable context,
                                String label) {
                            add«connection.name.toFirstUpper»(source, target);
                            requireContextContains(context, source, target);

                            «contextLabelClassName(artifact, connection)» connectionLabel = null;
                            for (ConnectionLabel candidate : context.getConnectionLabels()) {
                                if (candidate instanceof «contextLabelClassName(artifact, connection)»
                                        && ((«contextLabelClassName(artifact, connection)») candidate).getSource() == source
                                        && ((«contextLabelClassName(artifact, connection)») candidate).getTarget() == target) {
                                    connectionLabel = («contextLabelClassName(artifact, connection)») candidate;
                                    break;
                                }
                            }
                            if (connectionLabel == null) {
                                connectionLabel = «spvizModel.name»Factory.eINSTANCE.create«contextLabelClassName(artifact, connection)»();
                                connectionLabel.setSource(source);
                                connectionLabel.setTarget(target);
                                context.getConnectionLabels().add(connectionLabel);
                            }
                            connectionLabel.setLabel(label);
                        }

                        /**
                         * Resolves the label for this connection in the optional owner context.
                         */
                        public static String get«connection.name.toFirstUpper»Label(«artifact.name» source,
                                «connection.connects.name» target, Identifiable context) {
                            if (context != null) {
                                for (ConnectionLabel candidate : context.getConnectionLabels()) {
                                    if (candidate instanceof «contextLabelClassName(artifact, connection)»
                                            && ((«contextLabelClassName(artifact, connection)») candidate).getSource() == source
                                            && ((«contextLabelClassName(artifact, connection)») candidate).getTarget() == target
                                            && candidate.getLabel() != null) {
                                        return candidate.getLabel();
                                    }
                                }
                            }

                            for (ConnectionLabel candidate : source.getConnectionLabels()) {
                                if (candidate instanceof «directLabelClassName(artifact, connection)»
                                        && ((«directLabelClassName(artifact, connection)») candidate).getTarget() == target
                                        && candidate.getLabel() != null) {
                                    return candidate.getLabel();
                                }
                            }
                            return null;
                        }

                    «ENDFOR»
                «ENDFOR»
                private static void requireEndpoints(EObject source, EObject target) {
                    if (source == null || target == null) {
                        throw new IllegalArgumentException("Connection endpoints must not be null.");
                    }
                }

                private static void requireContextContains(Identifiable context, EObject source, EObject target) {
                    if (context == null) {
                        throw new IllegalArgumentException("The label context must not be null.");
                    }
                    if (!contains(context, source) || !contains(context, target)) {
                        throw new IllegalArgumentException("Both connection endpoints must be in the label context.");
                    }
                }

                private static boolean contains(Identifiable context, EObject element) {
                    if (context == element) {
                        return true;
                    }
                    for (java.util.Iterator<EObject> contents = context.eAllContents(); contents.hasNext();) {
                        if (contents.next() == element) {
                            return true;
                        }
                    }
                    return false;
                }
                
            }
            
        '''
    }

    private static def String directLabelClassName(Artifact artifact, Connection connection) {
        return artifact.name.toFirstUpper + "Connects" + connection.connects.name.toFirstUpper + "Named"
            + connection.name.toFirstUpper + "Label"
    }

    private static def String contextLabelClassName(Artifact artifact, Connection connection) {
        return artifact.name.toFirstUpper + "Connects" + connection.connects.name.toFirstUpper + "Named"
            + connection.name.toFirstUpper + "ContextLabel"
    }

}
