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

[Metadata(name="ChoiceId", types="property")]
/**
 * Represents a Metadata tag that can be used on properties that should map to a choice of child elements 
 * with a specific string identifier.
 * The tag can be used on Array properties, too. In this case multiple child elements are allowed in the mapped XML.
 * The choice is specified through an id in this case, and the elements which represent valid options for that choice
 * have to be specified with <code>XmlObjectMappings.choicId</code>. 
 *
 * @author Jens Halm
 */
public class ChoiceIdDecorator implements MetadataMapperDecorator {

	
	[Target]
	/**
	 * The name of the property.
	 */
	public var property:String;
	
	[DefaultProperty]
	/**
	 * The id of the choice as specified in the corresponding XmlObjectMappings instance.
	 */
	public var id:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:MetadataMapperBuilder) : void {
		builder.mapToChoiceId(property, id);
	}
	
	
}
}
