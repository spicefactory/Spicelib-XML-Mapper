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

package org.spicefactory.lib.xml.mapper.handler {
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.lib.reflect.metadata.Required;
import org.spicefactory.lib.xml.XmlProcessorContext;
import org.spicefactory.lib.xml.XmlValidationError;
import org.spicefactory.lib.xml.mapper.PropertyHandler;

import flash.utils.getQualifiedClassName;

/**
 * Abstract base impelementation of the PropertyHandler interface.
 * 
 * @author Jens Halm
 */
public class AbstractPropertyHandler implements PropertyHandler {
	
	
	private var _property:Property;
	private var _xmlNames:Array;
	private var _nodeKind:String;
	private var _required:Boolean;
	private var _singleValue:Boolean;
	
	/**
	 * Creates a new instance.
	 * 
	 * @param property the property the XML value should be applied to
	 * @param nodeKind the node kind (attribute, text or element)
	 * @param xmlNames the names of the mapped XML attributes or elements
	 * @param allowArrayProperty whether this handler is able to handle multi-value mappings
	 */
	public function AbstractPropertyHandler (property:Property, nodeKind:String, 
			xmlNames:Array = null, allowArrayProperty:Boolean = false) {
		_property = property;
		_required = property.getMetadata(Required).length > 0;
		_singleValue = !property.type.isType(Array);
		_nodeKind = nodeKind;
		_xmlNames = (xmlNames == null) ? [null] : xmlNames;
		if (_property.type.isType(Array) && !allowArrayProperty) {
			throw new XmlValidationError("Array Properties cannot be handled by " + getQualifiedClassName(this)
					+ ": " + _property);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function get property () : Property {
		return _property;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get xmlNames () : Array {
		return _xmlNames;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get nodeKind () : String {
		return _nodeKind;
	}
	
	/**
	 * Indicates whether this attribute is required.
	 */
	protected function get required () : Boolean {
		return _required;
	}
	
	/**
	 * Indicates whether this handler maps a single-valued or multi-valued (Array) property.
	 */
	protected function get singleValue () : Boolean {
		return _singleValue;
	}
	
	/**
	 * Validates the specified number of mapped XML elements, attributes or text nodes.
	 * For any invalid number this method throws an Error.
	 */
	protected function validateValueCount (count:int) : void {
		if (count == 0 && _required) {
			throw new XmlValidationError("Missing required " + nodeKind + " mapping to " + property);
		}
		if (count > 1 && _singleValue) {
			throw new XmlValidationError("At most one element allowed to map to " + property);
		}
	}
	
	/**
	 * Extracts the value from the specified node, resolving any variables that nodes with simple content
	 * possibly contain.
	 * 
	 * @param node the node to extract the value from
	 * @param context the processing context
	 * @return the value extracted fron the node to be applied to the property
	 */
	protected function getValueFromNode (node:XML, context:XmlProcessorContext) : * {
		return context.expressionContext.createExpression(node.toString()).value;
	}
	
	/**
	 * Gets the value of the mapped property from the specified instance.
	 * 
	 * @param instance the instance to get the property value from
	 * @return the value of the mapped property from the specified instance
	 */
	protected function getValue (instance:Object) : * {
		var value:* = property.getValue(instance);
		if (_required && (value == null || value === "" || (value is Array && value.length == 0))) {
			throw new XmlValidationError("Null, empty string or empty array values not allowed for required " + property);
		}
		return value;
	}
	
	/**
	 * Gets the value of the mapped property from the specified instance as a String.
	 * 
	 * @param instance the instance to get the property value from
	 * @return the value of the mapped property from the specified instance as a String
	 */
	protected function getValueAsString (instance:Object) : String {
		var value:* = getValue(instance);
		return (value == null) ? "" : value.toString();
	}
	
	/**
	 * @inheritDoc
	 */
	public function toObject (nodes:Array, parentInstance:Object, context:XmlProcessorContext) : void {
		throw new AbstractMethodError();
	}
	
	/**
	 * @inheritDoc
	 */
	public function toXML (instance:Object, parentElement:XML, context:XmlProcessorContext) : void {
		throw new AbstractMethodError();
	}
	

}
}
