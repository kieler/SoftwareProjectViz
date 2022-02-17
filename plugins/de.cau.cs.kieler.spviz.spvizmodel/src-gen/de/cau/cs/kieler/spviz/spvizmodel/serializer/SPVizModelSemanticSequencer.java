/*
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
package de.cau.cs.kieler.spviz.spvizmodel.serializer;

import com.google.inject.Inject;
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact;
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Connection;
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Containment;
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModel;
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.SPVizModelPackage;
import de.cau.cs.kieler.spviz.spvizmodel.services.SPVizModelGrammarAccess;
import java.util.Set;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.xtext.Action;
import org.eclipse.xtext.Parameter;
import org.eclipse.xtext.ParserRule;
import org.eclipse.xtext.serializer.ISerializationContext;
import org.eclipse.xtext.serializer.acceptor.SequenceFeeder;
import org.eclipse.xtext.serializer.sequencer.AbstractDelegatingSemanticSequencer;
import org.eclipse.xtext.serializer.sequencer.ITransientValueService.ValueTransient;

@SuppressWarnings("all")
public class SPVizModelSemanticSequencer extends AbstractDelegatingSemanticSequencer {

	@Inject
	private SPVizModelGrammarAccess grammarAccess;
	
	@Override
	public void sequence(ISerializationContext context, EObject semanticObject) {
		EPackage epackage = semanticObject.eClass().getEPackage();
		ParserRule rule = context.getParserRule();
		Action action = context.getAssignedAction();
		Set<Parameter> parameters = context.getEnabledBooleanParameters();
		if (epackage == SPVizModelPackage.eINSTANCE)
			switch (semanticObject.eClass().getClassifierID()) {
			case SPVizModelPackage.ARTIFACT:
				sequence_Artifact(context, (Artifact) semanticObject); 
				return; 
			case SPVizModelPackage.CONNECTION:
				sequence_Connection(context, (Connection) semanticObject); 
				return; 
			case SPVizModelPackage.CONTAINMENT:
				sequence_Containment(context, (Containment) semanticObject); 
				return; 
			case SPVizModelPackage.SP_VIZ_MODEL:
				sequence_SPVizModel(context, (SPVizModel) semanticObject); 
				return; 
			}
		if (errorAcceptor != null)
			errorAcceptor.accept(diagnosticProvider.createInvalidContextOrTypeDiagnostic(semanticObject, context));
	}
	
	/**
	 * Contexts:
	 *     Artifact returns Artifact
	 *
	 * Constraint:
	 *     (name=ID references+=Reference*)
	 */
	protected void sequence_Artifact(ISerializationContext context, Artifact semanticObject) {
		genericSequencer.createSequence(context, semanticObject);
	}
	
	
	/**
	 * Contexts:
	 *     Reference returns Connection
	 *     Connection returns Connection
	 *
	 * Constraint:
	 *     (name=ID connects=[Artifact|ID])
	 */
	protected void sequence_Connection(ISerializationContext context, Connection semanticObject) {
		if (errorAcceptor != null) {
			if (transientValues.isValueTransient(semanticObject, SPVizModelPackage.Literals.CONNECTION__NAME) == ValueTransient.YES)
				errorAcceptor.accept(diagnosticProvider.createFeatureValueMissing(semanticObject, SPVizModelPackage.Literals.CONNECTION__NAME));
			if (transientValues.isValueTransient(semanticObject, SPVizModelPackage.Literals.CONNECTION__CONNECTS) == ValueTransient.YES)
				errorAcceptor.accept(diagnosticProvider.createFeatureValueMissing(semanticObject, SPVizModelPackage.Literals.CONNECTION__CONNECTS));
		}
		SequenceFeeder feeder = createSequencerFeeder(context, semanticObject);
		feeder.accept(grammarAccess.getConnectionAccess().getNameIDTerminalRuleCall_0_0(), semanticObject.getName());
		feeder.accept(grammarAccess.getConnectionAccess().getConnectsArtifactIDTerminalRuleCall_2_0_1(), semanticObject.eGet(SPVizModelPackage.Literals.CONNECTION__CONNECTS, false));
		feeder.finish();
	}
	
	
	/**
	 * Contexts:
	 *     Reference returns Containment
	 *     Containment returns Containment
	 *
	 * Constraint:
	 *     contains=[Artifact|ID]
	 */
	protected void sequence_Containment(ISerializationContext context, Containment semanticObject) {
		if (errorAcceptor != null) {
			if (transientValues.isValueTransient(semanticObject, SPVizModelPackage.Literals.CONTAINMENT__CONTAINS) == ValueTransient.YES)
				errorAcceptor.accept(diagnosticProvider.createFeatureValueMissing(semanticObject, SPVizModelPackage.Literals.CONTAINMENT__CONTAINS));
		}
		SequenceFeeder feeder = createSequencerFeeder(context, semanticObject);
		feeder.accept(grammarAccess.getContainmentAccess().getContainsArtifactIDTerminalRuleCall_1_0_1(), semanticObject.eGet(SPVizModelPackage.Literals.CONTAINMENT__CONTAINS, false));
		feeder.finish();
	}
	
	
	/**
	 * Contexts:
	 *     SPVizModel returns SPVizModel
	 *
	 * Constraint:
	 *     (package=QualifiedName name=ID artifacts+=Artifact*)
	 */
	protected void sequence_SPVizModel(ISerializationContext context, SPVizModel semanticObject) {
		genericSequencer.createSequence(context, semanticObject);
	}
	
	
}
