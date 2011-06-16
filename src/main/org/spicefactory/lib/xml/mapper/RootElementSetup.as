/*
 * Copyright 2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.spicefactory.lib.xml.mapper {
import flash.system.ApplicationDomain;

/**
 * Part of the XML object mapping DSL to set up the root element for a group of mappings.
 * 
 * @author Jens Halm
 */
public class RootElementSetup {
	
	
	private var uri:String;
	
	
	/**
	 * @private
	 */
	function RootElementSetup (uri:String = "") {
		this.uri = uri;
	}
	
	/**
	 * Creates a new group of mappings with the specified class acting as the mapping
	 * for the root XML element.
	 * 
	 * @param mappedType the class acting as the mapping
	 * for the root XML element
	 * @param domain the ApplicationDomain to use for reflection
	 * @return a new group of mappings
	 */
	public function withRootElement (mappedType:Class, domain:ApplicationDomain = null) : XmlObjectMappings {
		return new XmlObjectMappings(uri, domain, mappedType);	
	}
	
	/**
	 * Creates a new group of mappings without any specific root element.
	 * This is usually only useful if you merge the group of mappings into another group as the
	 * top level group always needs a concrete root mapping. 
	 * 
	 * @param domain the ApplicationDomain to use for reflection
	 * @return a new group of mappings
	 */
	public function withoutRootElement (domain:ApplicationDomain = null) : XmlObjectMappings {
		return new XmlObjectMappings(uri, domain);	
	}
	
	
}
}
