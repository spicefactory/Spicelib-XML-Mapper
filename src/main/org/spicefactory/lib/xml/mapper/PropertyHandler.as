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
import org.spicefactory.lib.xml.XmlProcessorContext;
import org.spicefactory.lib.reflect.Property;

/**
 * Responsible for mapping a single property of a mapped class to an XML element, attribute or text node.
 * 
 * @author Jens Halm
 */
public interface PropertyHandler {
	
	
	/**
	 * The Property the XML element, attribute or text node should map to.
	 */
	function get property () : Property;
	
	/**
	 * The names of the mapped XML elements, attributes or text nodes.
	 * For Array properties the Array may contain more than one XML name.
	 */
	function get xmlNames () : Array;
	
	/**
	 * The kind of the mapped node. Either <code>element</code>, <code>attribute</code> or <code>text</code>.
	 */
	function get nodeKind () : String;
	
	
	/**
	 * Maps the specified XML elements, attributes or text nodes to the mapped property of the specified instance.
	 * 
	 * @param nodes the XML elements, attributes or text nodes to apply as a property value
	 * @param parentInstance the instance the property should be set for
	 * @param context the processing context
	 */
	function toObject (nodes:Array, parentInstance:Object, context:XmlProcessorContext) : void;

	/**
	 * Maps the property value this handler is responsible for to the specified XML elements.
	 * 
	 * @param instance the instance the to read the property value from
	 * @param parentElement the XML element to apply the property value to, either as an attribute, text node or child element
	 * @param context the processing context
	 */
	function toXML (instance:Object, parentElement:XML, context:XmlProcessorContext) : void;
	
	
}
}
