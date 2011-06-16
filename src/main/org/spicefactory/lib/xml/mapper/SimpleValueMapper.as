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
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Converter;
import org.spicefactory.lib.reflect.Converters;
import org.spicefactory.lib.xml.XmlProcessorContext;

/**
 * A mapper implementation that maps elements with a text node to simple types like String or int.
 * This is a different type of mapper compared to the standard mappers created by the <code>XmlObjectMappings</code>
 * class that always map to the properties of a particular class. 
 * 
 * @author Jens Halm
 */
public class SimpleValueMapper extends AbstractXmlObjectMapper {
	
	private var converter:Converter;
	
	/**
	 * Creates a new instance.
	 * 
	 * @param type the class to the XML element to
	 * @param name the name of the XML element that holds the text node
	 * @param converter the (optional) converter to use for converting the String values to the specified target type
	 */
	function SimpleValueMapper (type:ClassInfo, name:QName, converter:Converter = null) {
		super(type, name);
		this.converter = (converter) ? converter : Converters.getConverter(type.getClass());
	}
	
	/**
	 * @inheritDoc
	 */
	public override function mapToObject (element:XML, context:XmlProcessorContext = null) : Object {
		if (context == null) context = new XmlProcessorContext();
		var xmlText:String = element.text()[0];
		var value:* = context.expressionContext.createExpression(xmlText).value;
		return (converter) ? converter.convert(value, context.applicationDomain) : value;
	}

	/**
	 * @inheritDoc
	 */
	public override function mapToXml (object:Object, context:XmlProcessorContext = null) : XML {
		if (context == null) context = new XmlProcessorContext();
		var element:XML = <{elementName.localName}/>;
		if (elementName.uri != null && elementName.uri.length != 0) {
			context.setNamespace(element, elementName.uri);
		}
		if (object != null) {
			element.text()[0] = object.toString();
		}
		return element;
	}
	
}
}
