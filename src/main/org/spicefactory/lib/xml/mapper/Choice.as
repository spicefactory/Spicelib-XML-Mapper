/*
 * Copyright 2009 the original author or authors.
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
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.XmlProcessorContext;
import org.spicefactory.lib.xml.XmlValidationError;

import flash.utils.Dictionary;

/**
 * Choices represent several XML child elements that should be mapped to the same property of the mapped class.
 * They are somewhat similar to choices in XML Schema definitions. Instances of this class can be passed to
 * <code>PropertyMapperBuilder.mapToChildElementChoice()</code>.
 * 
 * @author Jens Halm
 */
public class Choice {
	
	
	private var mappersByXmlName:Dictionary = new Dictionary();
	private var mappersByType:Dictionary = new Dictionary();
	
	
	/**
	 * Adds a mapper to this choice.
	 * 
	 * @param mapper the mapper to add
	 */
	public function addMapper (mapper:XmlObjectMapper) : void {
		mappersByXmlName[mapper.elementName.toString()] = mapper;
		mappersByType[mapper.objectType.getClass()] = mapper;
	}

	/**
	 * @private
	 */
	public function getMapperForInstance (instance:Object, context:XmlProcessorContext):XmlObjectMapper {
		var ci:ClassInfo = ClassInfo.forInstance(instance, context.applicationDomain);
		var mapper:XmlObjectMapper = mappersByType[ci.getClass()];
		if (mapper == null) {
			throw new XmlValidationError("No mapper defined for objects of type " + ci.name + " in this choice");
		}
		return mapper;
	}
	
	/**
	 * @private
	 */
	public function getMapperForElementName (name:QName) : XmlObjectMapper {
		var mapper:XmlObjectMapper = mappersByXmlName[name.toString()];
		if (mapper == null) {
			throw new XmlValidationError("No mapper defined for element name " + name + " in this choice");
		}
		return mapper;
	}
	
	/**
	 * @private
	 */
	public function getAllMappers () : Array {
		var result:Array = new Array();
		for each (var mapper:Object in mappersByXmlName) {
			result.push(mapper);
		}
		return result;
	}

	/**
	 * @private
	 */
	public function get xmlNames () : Array {
		var names:Array = new Array();
		for each (var mapper:XmlObjectMapper in mappersByXmlName) {
			names.push(mapper.elementName);
		}
		return names;
	}
	
				
}
}
