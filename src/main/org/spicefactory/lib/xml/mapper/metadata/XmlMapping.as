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

package org.spicefactory.lib.xml.mapper.metadata {

[Metadata(types="class")]
/**
 * Represents a Metadata tag that can be used on the class level to specify a custom XML element name or uri and other
 * custom behaviours.
 *
 * @author Jens Halm
 */
public class XmlMapping {

	
	/**
	 * Instructs the mapper to ignore attributes in XML that are not mapped to properties.
	 */
	public var ignoreUnmappedAttributes:Boolean;

	/**
	 * Instructs the mapper to ignore child elements in XML that are not mapped to properties.
	 */
	public var ignoreUnmappedChildren:Boolean;

	/**
	 * The name of the XML element the class should map to.
	 */
	public var elementName:String;

	/**
	 * The namespace uri of the XML element the class should map to.
	 */
	public var elementUri:String;
	
	
}
}
