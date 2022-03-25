/*
 * SPViz - Kieler Software Project Visualization for Projects
 * 
 * A part of Kieler
 * https://github.com/kieler
 * 
 * Copyright 2022 by
 * + Christian-Albrechts-University of Kiel
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 */

package de.cau.cs.kieler.spviz.yarnInversify.generate;

/**
 * This is a utility class with static final Strings this project uses.
 *
 * @author nre
 */
@SuppressWarnings("nls")
public class StaticVariables {
    static final String TS_FILE = ".ts";
    static final String LOCK_FILE = "yarn.lock";
    static final String PACKAGE_FILE = "package.json";
    
	static final String PACKAGE_PREFIX = "Package_";
	static final String INTERFACE_PREFIX = "Interface_";
	static final String CLASS_PREFIX = "Class_";

    static final String DEPENDENCIES = "dependencies";
    static final String NAME = "name";
    static final String VERSION = "version";
    static final String TYPES = "TYPES.";
    static final String INJECTABLE = "@injectable()";
    static final String INJECT = "@inject(";
    static final String MULTIINJECT = "@multiInject(";
    static final String BIND = "bind(TYPES.";
    static final String TO = ").to(";

}
