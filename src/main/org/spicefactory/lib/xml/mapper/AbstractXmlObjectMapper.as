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
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.XmlProcessorContext;

/**
 * Base class for XmlObjectMapper implementations providing default implementations for the two property getter methods.
 * The two actual mapping methods are not implemented by this base class.
 * 
 * @author Jens Halm
 */
public class AbstractXmlObjectMapper implements XmlObjectMapper {
	
	
	private var _objectType:ClassInfo;
	private var _elementName:QName;
	

	/**
	 * Creates a new instance.
	 * 
	 * @param objectType the type of the mapped object
	 * @param elementName the name of the mapped XML element
	 */
	function AbstractXmlObjectMapper (objectType:ClassInfo, elementName:QName) {
		_objectType = objectType;
		_elementName = elementName;
	}	
	
	
	/**
	 * @inheritDoc
	 */
	public function get objectType () : ClassInfo {
		return _objectType;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get elementName () : QName {
		return _elementName;
	}
	
	/**
	 * @inheritDoc
	 */
	public function mapToObject (element:XML, context:XmlProcessorContext = null) : Object {
		throw new AbstractMethodError();
	}
	
	/**
	 * @inheritDoc
	 */
	public function mapToXml (object:Object, context:XmlProcessorContext = null) : XML {
		throw new AbstractMethodError();
	}
	
	
}
}
