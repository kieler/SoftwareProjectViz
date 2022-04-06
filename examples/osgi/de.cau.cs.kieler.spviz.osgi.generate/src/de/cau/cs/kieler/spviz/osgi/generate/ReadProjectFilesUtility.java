// ******************************************************************************
//
// Copyright (c) 2018-2022 by
// Scheidt & Bachmann System Technik GmbH, 24145 Kiel
// and
// + Christian-Albrechts-University of Kiel
//   + Department of Computer Science
//     + Real-Time and Embedded Systems Group
//
// This program and the accompanying materials are made available under the
// terms of the Eclipse Public License 2.0 which is available at
// http://www.eclipse.org/legal/epl-2.0.
// 
// SPDX-License-Identifier: EPL-2.0
//
// ******************************************************************************

package de.cau.cs.kieler.spviz.osgi.generate;

import java.lang.System.Logger;
import java.util.Comparator;

import de.cau.cs.kieler.spviz.osgi.model.Bundle;
import de.cau.cs.kieler.spviz.osgi.model.OSGiProject;

/**
 * This is a utility class for {@linkplain ReadProjectFiles} with methods for
 * reading and parsing files.
 *
 * @author dams
 *
 */

public class ReadProjectFilesUtility {
	static final Logger LOGGER = System.getLogger(ReadProjectFilesUtility.class.getName());

	/**
	 * This method takes an interface name, and returns the belonging bundle.
	 *
	 */
	static Bundle getBundleFromInterface(String interfaceName, OSGiProject project) {
		return project.getBundles().stream()//
				.filter(bundle -> interfaceName.startsWith(bundle.getName()))//
				.max(Comparator.comparingInt(x -> x.getEcoreId().length()))
				.orElse(null);
	}
}
