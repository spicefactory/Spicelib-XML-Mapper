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
import org.spicefactory.lib.xml.mapper.MetadataMapperBuilder;
import org.spicefactory.lib.xml.mapper.MetadataMapperDecorator;

[Metadata(name="ChoiceType", types="property")]
/**
 * Represents a Metadata tag that can be used on properties that should map to a choice of child elements that map to a particular 
 * interface or class and its subtypes and implementors.
 * The tag can be used on Array properties, too. In this case multiple child elements are allowed in the mapped XML.
 *
 * @author Jens Halm
 */
public class ChoiceTypeDecorator implements MetadataMapperDecorator {

	
	[Target]
	/**
	 * The name of the property.
	 */
	public var property:String;
	
	[DefaultProperty]
	/**
	 * The type that valid child elements map to.
	 * This is interpreted polymorphically.
	 */
	public var type:Class;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:MetadataMapperBuilder) : void {
		builder.mapToChoiceType(property, type);
	}
	
	
}
}
