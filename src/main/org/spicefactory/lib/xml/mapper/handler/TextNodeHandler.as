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
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.lib.xml.XmlProcessorContext;

/**
 * Responsible for mapping properties to text nodes.
 * 
 * @author Jens Halm
 */
public class TextNodeHandler extends AbstractPropertyHandler {
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param property the property the text node should be applied to
	 */
	public function TextNodeHandler (property:Property) {
		super(property, "text");
	}
	
	
	/**
	 * @private
	 */
	public override function toObject (nodes:Array, parentInstance:Object, context:XmlProcessorContext) : void {
		validateValueCount(nodes.length);
		if (nodes.length > 0) {
			property.setValue(parentInstance, context.expressionContext.createExpression(nodes[0]).value);
		}
	}
	
	/**
	 * @private
	 */
	public override function toXML (instance:Object, parentElement:XML, context:XmlProcessorContext) : void {
		var value:String = getValueAsString(instance);
		if (value.length > 0) {
			parentElement.text()[0] = getValue(instance);
		}
	}


}
}
