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
import org.spicefactory.lib.xml.mapper.metadata.XmlMapping;
import org.spicefactory.lib.reflect.metadata.TargetPropertyUtil;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.lib.xml.MappingError;
import org.spicefactory.lib.xml.NamingStrategy;

import flash.system.ApplicationDomain;

/**
 * Extension of the base PropertyMapperBuilder that supports mapping configuration with metadata.
 * 
 * @author Jens Halm
 */
public class MetadataMapperBuilder extends PropertyMapperBuilder {
	
	
	private var choices:ChoiceRegistry;
	
	private var simpleTypes:Array = [
		Boolean,
		String,
		Number,
		int,
		uint,
		Class,
		ClassInfo,
		Date
	];
	
	
	/**
	 * Creates a new instance for building a mapper that maps the specified objectType to the XML element
	 * with the specified name.
	 * 
	 * @param objectType the type of the object to map to the XML element
	 * @param elementName the name of the XML element to map
	 * @param choices the registry for choices
	 * @param namingStrategy the naming strategy to use for transforming property names to XML attribute and element names
	 * @param domain the ApplicationDomain to use for reflecting on the mapped type
	 */
	function MetadataMapperBuilder (objectType:Class, elementName:QName, choices:ChoiceRegistry,
			namingStrategy:NamingStrategy = null, domain:ApplicationDomain = null) {
		super(objectType, elementName, namingStrategy, domain);
		this.choices = choices;		
		processClassMetadataForName();
	}
	
	/**
	 * Maps the property with the specified name to the objects of a choice of child elements that map to a particular 
 	 * interface or class and its subtypes and implementors.
 	 * 
 	 * @param propertyName the name of the property to map to the specified choice of child elements
	 * @param type the type that all permitted elements of the choice map to (including subtypes)
	 */
	public function mapToChoiceType (propertyName:String, type:Class) : void {
		var c:Choice = choices.getChoiceByType(type);
		mapToChildElementChoice(propertyName, c);
	}
	
	/**
	 * Maps the property with the specified name to the objects of a choice of child elements 
	 * with a particular string identifier.
	 * The choice is specified through an id and the elements which represent valid options for that choice
 	 * have to be specified with <code>XmlObjectMappings.choicId</code>. 
 	 * 
 	 * @param propertyName the name of the property to map to the specified choice of child elements
	 * @param id the id of the choice as specified in the corresponding XmlObjectMappings instance
	 */
	public function mapToChoiceId (propertyName:String, id:String) : void {
		var c:Choice = choices.getChoiceById(id);
		mapToChildElementChoice(propertyName, c);
	}
	
	
	/**
	 * @private
	 */
	internal function processMetadata (simpleMappingType:SimpleMappingType) : void {
		processClassMetadataForOptions();
		
		for each (var property:Property in objectType.getProperties()) {
			
			if (!isMappableProperty(property)) continue;
			
			if (!processPropertyMetadata(property)) {
				processDefaultMapping(property, simpleMappingType);
			}
		}
	}
	
	private function processClassMetadataForName () : void {
		var metadata:Array = objectType.getMetadata(XmlMapping);
		if (metadata.length > 0) {
			var mapping:XmlMapping = metadata[0];
			if (mapping.elementName || mapping.elementUri) {
				var name:String = (mapping.elementName) ? mapping.elementName : elementName.localName;
				var uri:String = (mapping.elementUri) ? mapping.elementUri : elementName.uri;
				updateElementName(new QName(uri, name));
			}
		}
	}
	
	private function processClassMetadataForOptions () : void {
		var metadata:Array = objectType.getMetadata(XmlMapping);
		if (metadata.length > 0) {
			var mapping:XmlMapping = metadata[0];
			if (mapping.ignoreUnmappedAttributes) {
				ignoreUnmappedAttributes();
			}
			if (mapping.ignoreUnmappedChildren) {
				ignoreUnmappedChildren();
			}
		}
	}
	
	private function processPropertyMetadata (property:Property) : Boolean {
		var processed:Boolean = false;
		for each (var metadata:Object in property.getAllMetadata()) {
			if (metadata is MetadataMapperDecorator) {
				if (processed) {
					throw new MappingError("" + property + " contains more than one mapping metadata tag", []);
				}
				TargetPropertyUtil.setPropertyName(property, metadata, objectType.applicationDomain);
				MetadataMapperDecorator(metadata).decorate(this);
				processed = true;
			}
		}
		return processed;
	}
	
	private function processDefaultMapping (property:Property, simpleMappingType:SimpleMappingType) : void {
		if (!isSimpleType(property)) {
			var type:Class = (property.type.isType(Array)) ? Object : property.type.getClass();
			var choice:Choice = choices.getChoiceByType(type);
			mapToChildElementChoice(property.name, choice);
		}
		else if (simpleMappingType == SimpleMappingType.CHILD_TEXT_NODE) {
			mapToChildTextNode(property.name);
		}
		else {
			mapToAttribute(property.name);
		}
	}
	
	private function isSimpleType (property:Property) : Boolean {
		var type:ClassInfo = property.type;
		for each (var simple:Class in simpleTypes) {
			if (type.isType(simple)) return true;
		}
		return false;
	}
	
	
}
}
