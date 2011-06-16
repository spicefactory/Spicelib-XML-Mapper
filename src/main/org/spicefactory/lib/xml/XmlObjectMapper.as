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

package org.spicefactory.lib.xml {
import org.spicefactory.lib.reflect.ClassInfo;

/**
 * The core interface of the XML-to-Object mapping framework.
 * 
 * <p>In most cases applications should be able to use the XmlObjectMapper implementation produced by the
 * <code>PropertyMapperBuilder</code> class. But for unusual use cases new implementations of this interface
 * can be created from scratch to be combined with the existing ones. In a complex XML hierarchy it is 
 * usually recommended to create a corresponding hierarchy of mappers where each mapper is only responsible
 * for mapping a single element, delegating work to child mapper for child elements.</p>
 * 
 * @author Jens Halm
 */
public interface XmlObjectMapper {
	
	
	/**
	 * The type of the objects the mapToObject method produces.
	 */
	function get objectType () : ClassInfo;

	/**
	 * The name of the elements the mapToXml method produces.
	 */
	function get elementName () : QName;
	
	
	/**
	 * Maps from XML to object. Should always return objects of the type the <code>objectType</code> property was set to.
	 * 
	 * @param element the XML element to be transformed to an object
	 * @param context the processing context
	 * @return a new object that maps to the specified XML element
	 */
	function mapToObject (element:XML, context:XmlProcessorContext = null) : Object;

	/**
	 * Maps from object to XML. Should always return XML elements with the name the <code>elementName</code> property was set to.
	 * 
	 * @param object the object to be transformed to an XML element
	 * @param context the processing context
	 * @return a new XML element that maps to the specified object
	 */
	function mapToXml (object:Object, context:XmlProcessorContext = null) : XML;
	
	
}

}
