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
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.lib.xml.DefaultNamingStrategy;
import org.spicefactory.lib.xml.NamingStrategy;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.mapper.PropertyHandler;
import org.spicefactory.lib.xml.mapper.handler.AttributeHandler;
import org.spicefactory.lib.xml.mapper.handler.ChildElementHandler;
import org.spicefactory.lib.xml.mapper.handler.ChildTextNodeHandler;
import org.spicefactory.lib.xml.mapper.handler.ChoiceHandler;
import org.spicefactory.lib.xml.mapper.handler.TextNodeHandler;

import flash.system.ApplicationDomain;
import flash.utils.Dictionary;

/**
 * Builder that creates PropertyMapper instances.
 * 
 * <p>The main entry point for most basic use cases covered by the builtin PropertyMapper implementation.
 * Use the various <code>map</code> methods to create a mapper that maps properties of a class
 * to XML attributes, child elements or text nodes.</p>
 * 
 * <p>This class is primarily intended for internal use. In most cases the most convenient way to create
 * mappings is the use of the <code>XmlObjectMappings</code> class and its DSL to quickly set up mappings
 * that support metadata configuration.</p>
 * 
 * @author Jens Halm
 */
public class PropertyMapperBuilder {
	
	
	/**
	 * The default naming strategy to use for transforming property names to
	 * XML attribute or element names.
	 */
	public static var defaultNamingStrategy:NamingStrategy = new DefaultNamingStrategy();


	private var _namingStrategy:NamingStrategy;
	
	private var _objectType:ClassInfo;
	private var _elementName:QName;

	
	private var _ignoreUnmappedAttributes:Boolean = false;
	private var _ignoreUnmappedChildren:Boolean = false;
	private var _ignoredProperties:Dictionary = new Dictionary();
	
	
	private var propertyHandlerMap:Dictionary = new Dictionary();
	private var propertyHandlerList:Array = new Array();
	
	
	/**
	 * Creates a new instance for building a mapper that maps the specified objectType to the XML element
	 * with the specified name.
	 * 
	 * @param objectType the type of the object to map to the XML element
	 * @param elementName the name of the XML element to map
	 * @param namingStrategy the naming strategy to use for transforming property names to XML attribute and element names
	 * @param domain the ApplicationDomain to use for reflecting on the mapped type
	 */
	function PropertyMapperBuilder (objectType:Class, elementName:QName, namingStrategy:NamingStrategy = null,
			domain:ApplicationDomain = null) {
		_objectType = ClassInfo.forClass(objectType, domain);
		_elementName = elementName;
		_namingStrategy = (namingStrategy != null) ? namingStrategy : defaultNamingStrategy;
	}

	
	/**
	 * The mapped object type.
	 */
	public function get objectType () : ClassInfo {
		return _objectType;
	}
	
	/**
	 * The name of the mapped XML element.
	 */
	public function get elementName () : QName {
		return _elementName;
	}	
	
	/**
	 * The naming strategy to use for transforming property names to XML attribute and element names.
	 */
	public function get namingStrategy () : NamingStrategy {
		return _namingStrategy;
	}	

	
	/**
	 * Instructs this builder to ignore attributes in XML that are not mapped to properties.
	 */
	public function ignoreUnmappedAttributes () : void {
		_ignoreUnmappedAttributes = true;
	}
	
	/**
	 * Instructs this builder to ignore child elements in XML that are not mapped to properties.
	 */
	public function ignoreUnmappedChildren () : void {
		_ignoreUnmappedChildren = true;
	}

	/**
	 * Instructs this builder not to map the property with the specified name.
	 * 
	 * @param propertyName the name of the property to exclude from the mapping
	 */
	public function ignoreProperty (propertyName:String) : void {
		_ignoredProperties[propertyName] = true;
	}
	
	/**
	 * Checks whether the specified property can still be mapped.
	 * Returns false if the specified property has already been mapped or if 
	 * it has been added to the list of properties that should be ignored.
	 * 
	 * @param property the property to check
	 * @return true if the specified property can still be mapped
	 */
	protected function isMappableProperty (property:Property) : Boolean {
		return (property.writable 
				&& propertyHandlerMap[property.name] == undefined 
				&& _ignoredProperties[property.name] == undefined);
	}
	
	/**
	 * Updates the XML element name to apply to this mapping.
	 * 
	 * @param newName the new name to apply to this mapping
	 */
	protected function updateElementName (newName:QName) : void {
		_elementName = newName;
	}

	/**
	 * Maps all properties of the mapped class to attribute of the mapped XML element.
	 * Has the same effect as calling <code>mapToAttribute</code> for all properties of the class.
	 */
	public function mapAllToAttributes () : void {
		for each (var property:Property in _objectType.getProperties()) {
			if (isMappableProperty(property)) {
				var attributeName:QName = new QName("", namingStrategy.toXmlName(property.name));
				addPropertyHandler(new AttributeHandler(property, attributeName));
			}
		}
	}

	/**
	 * Maps the property with the specified name to the XML attribute with the specified name.
	 * 
	 * <p>Example:</p>
	 * 
	 * <pre><code>public class Song {
	 *     public var year:int;
	 *     public var title:String;
	 *     public var artist:String;
	 * }
	 * 
	 * &lt;song
	 *     year="1989" 
	 *     title="Monkey Gone To Heaven"
	 *     artist="Pixies"
	 * /&gt;</code></pre>
	 * 
	 * <p>Calling <code>mapToAttribute("year")</code> for the Song class shown above would map the year property to the
	 * attribute in the song tag with the same name.</p>
	 * 
	 * @param propertyName the name of the mapped property
	 * @param attributeName the name of the mapped XML attribute
	 */	
	public function mapToAttribute (propertyName:String, attributeName:QName = null) : void {
		if (attributeName == null) attributeName = new QName("", namingStrategy.toXmlName(propertyName));
		addPropertyHandler(new AttributeHandler(getProperty(propertyName), attributeName));
	}

	/**
	 * Maps all properties of the mapped class to text nodes of child elements of the mapped XML element.
	 * Has the same effect as calling <code>mapToChildTextNode</code> for all properties of the class.
	 */
	public function mapAllToChildTextNodes () : void {
		for each (var property:Property in _objectType.getProperties()) {
			if (isMappableProperty(property)) {
				var childName:QName = new QName(_elementName.uri, namingStrategy.toXmlName(property.name));
				addPropertyHandler(new ChildTextNodeHandler(property, childName));
			}
		}
	}

	/**
	 * Maps the property with the specified name to the XML text node of the child element with the specified name.
	 * 
	 * <p>Example:</p>
	 * 
	 * <pre><code>public class Song {
	 *     public var year:int;
	 *     public var title:String;
	 *     public var artist:String;
	 * }
	 * 
	 * &lt;song&gt;
	 *    &lt;year&gt;1989&lt;/year&gt; 
	 *    &lt;title&gt;Monkey Gone To Heaven&lt;/title&gt;
	 *    &lt;artist&gt;Pixies&lt;/artist&gt;
	 * &lt;/song&gt;</code></pre>
	 * 
	 * <p>Calling <code>mapToChildTextNode("year")</code> for the Song class shown above would map the year property to the
	 * text node of the child element with the same name.</p>
	 * 
	 * @param propertyName the name of the mapped property
	 * @param childName the name of the XML element that contains the mapped text node
	 */		
	public function mapToChildTextNode (propertyName:String, childName:QName = null) : void {
		if (childName == null) childName = new QName(_elementName.uri, namingStrategy.toXmlName(propertyName));
		addPropertyHandler(new ChildTextNodeHandler(getProperty(propertyName), childName));
	}
	
	/**
	 * Maps the property with the specified name to the XML text node inside the mapped XML element.
	 * 
	 * <p>This is different from mapping to child text nodes. It maps a property to the text node that belongs to the
	 * same element. Since this can only apply for a single property it is often combined with attribute mapping.</p>
	 * 
	 * <p>Example:</p>
	 * 
	 * <pre><code>public class Song {
	 * 
	 *     public var year:int;
	 *     public var title:String;
	 *     public var artist:String;
	 *     
	 * }
	 * 
	 * &lt;song year="2000" artist="Goldfrapp"&gt;Felt Mountain&lt;/song&gt;</code></pre>
	 * 
	 * <p>Calling <code>mapToTextNode("title")</code> for the Song class shown above would map the title property to the
	 * text node of the song element ("Felt Mountain").</p>
	 * 
	 * @param propertyName the name of the property to map to the text node
	 */
	public function mapToTextNode (propertyName:String) : void {
		addPropertyHandler(new TextNodeHandler(getProperty(propertyName)));
	}
	
	/**
	 * Maps the property with the specified name to the object mapped to the specified XML element.
	 * 
	 * <p>Mapping to child elements allows you to build a hierarchy of nested mappers since it is the responsibility
	 * of the specified mapper to handle the mapping of the child element itself.</p>
	 * 
	 * <p>Example:</p>
	 * 
	 * <pre><code>public class Album {
	 *
	 *    public var year:int;
	 *    public var title:String;
	 *    public var artist:String;
	 *    public var songs:Array;
	 *    
	 * }
	 *
	 * public class Song {
	 *
	 *    public var duration:String;
	 *    public var title:String;
	 *    
	 * }
	 *
	 * &lt;album year="2000" artist="Goldfrapp" title="Felt Mountain"&gt;
	 *    &lt;song title="Lovely Head" duration="3:50"/&gt;
	 *    &lt;song title="Pilots" duration="4:30"/&gt;
	 *    &lt;song title="Deer Stop" duration="4:07"/&gt;
	 *    &lt;song title="Utopia" duration="4:18"/&gt;
	 * &lt;/album&gt;</code></pre>
	 * 
	 * <p>In this example the song child elements will be mapped into the songs property of
	 * the Album class. This is how you would set up such a mapper:</p>
	 *
	 * <pre><code>var songBuilder:PropertyMapperBuilder = new PropertyMapperBuilder(Song, new QName("song"));
	 * songBuilder.mapAllToAttributes();
	 *
	 * var albumBuilder:PropertyMapperBuilder = new PropertyMapperBuilder(Album, new QName("album"));
	 * albumBuilder.mapToChildElement("songs", songBuilder.build());
	 * albumBuilder.mapAllToAttributes();</code></pre>
	 *
	 * <p>For the song element we simply map all properties to attributes. For the album element
	 * we map the songs Array property to the song child element, passing the mapper that we have
	 * built for the child element. We then map all remaining properties to attributes.</p>
	 * 
	 * @param propertyName the name of the property to map to the child element
	 * @param mapper the mapper responsible for mapping the child elements to objects
	 */
	public function mapToChildElement (propertyName:String, mapper:XmlObjectMapper) : void {
		addPropertyHandler(new ChildElementHandler(getProperty(propertyName), mapper));
	}
	
	/**
	 * Maps the property with the specified name to the objects of a choice of mapped child elements.
	 * 
	 * <p>This is a variant for the child element mapping mechanism that allows for even greater flexibility.
	 * With choices you can map several different child elements into a single Array property (or single valued property).</p>
	 * 
	 * <p>Example:</p>
	 * 
	 * <pre><code>public class Order {
	 * 
	 *     public var products:Array;
	 *     
	 * }
	 * 
	 * public class Album {
	 * 
	 *     public var artist:String;
	 *     public var title:String;
	 *     public var duration:String;
	 *     
	 * }
	 * 
	 * public class Book {
	 * 
	 *     public var author:String;
	 *     public var title:String;
	 *     public var pageCount:String;  
	 * 
	 * }
	 * 
	 * &lt;order&gt;
	 *     &lt;album artist="Goldfrapp" title="Felt Mountain"  duration="38:50"/&gt;
	 *     &lt;album artist="Unkle" title="Never, Never, Land"  duration="49:27"/&gt;
	 *     &lt;book author="Karen Duve" title"Rain" pageCount="256"/&gt;
	 *     &lt;book author="Judith Hermann" title"Summerhouse, Later" pageCount="224"/&gt;
	 * &lt;/order&gt;</code></pre>
	 * 
	 * <p> This time we map the products Array property of the Order class to multiple different
	 * child elements. This is how you set up the mapper: </p>
	 * 
	 * <pre><code>var albumBuilder:PropertyMapperBuilder = new PropertyMapperBuilder(Album, new QName("album"));
	 * albumBuilder.mapAllToAttributes();
	 * 
	 * var bookBuilder:PropertyMapperBuilder = new PropertyMapperBuilder(Book, new QName("book"));
	 * bookBuilder.mapAllToAttributes();
	 * 
	 * var orderBuilder:PropertyMapperBuilder = new PropertyMapperBuilder(Order, new QName("order"));
	 * var choice:Choice = new Choice();
	 * choice.addMapper(albumBuilder.build());
	 * choice.addMapper(bookBuilder.build());
	 * orderBuilder.mapAllToChildElementChoice("products", choice);</code></pre>

	 * <p>The mappers for the Book and Album classes are simple: Both simply map all
	 * properties to attributes. For the Order class we create a Choice instance,
	 * add all child element mappers to it and finally map the products property of the Order
	 * class to the choice.</p>
	 * 
	 * @param propertyName the name of the property to map to the specified choice of child elements
	 * @param choice the choice instance containing all mappers for the child elements
	 */
	public function mapToChildElementChoice (propertyName:String, choice:Choice) : void {
		addPropertyHandler(new ChoiceHandler(getProperty(propertyName), choice));
	}

	/**
	 * Convenient short cut to produce a mapper for a child element that will then be mapped
	 * to a property of the class mapped by this builder.
	 * 
	 * <p>This is equivalent to creating the <code>PropertyMapperBuilder</code> yourself,
	 * and then passing the mapper produced by that builder to <code>mapToChildElement</code></p>.
	 * 
	 * <p>Note that you must not pass the mapper created by the returned builder to this builder.
	 * This will be done automatically for you.</p>
	 * 
	 * @param propertyName the name of the property to create a child element mapper for
	 * @param type the type the child element will be mapped to (the type of the specified property if omitted)
	 * @param elementName the name of the mapped child element (if omitted the same name as the property in the same
	 * namespace as the XML element mapped by this builder)
	 * @return a new PropertyMapperBuilder
	 */
	public function createChildElementMapperBuilder (propertyName:String, 
			type:Class = null, elementName:QName = null) : PropertyMapperBuilder {
		if (elementName == null) elementName = new QName(this._elementName.uri, namingStrategy.toXmlName(propertyName));
		var property:Property = getProperty(propertyName);
		if (type == null) type = property.type.getClass();
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(type, elementName, namingStrategy, _objectType.applicationDomain);
		addPropertyHandler(new ChildElementHandler(property, builder.build()));
		return builder;
	}
	
	/**
	 * Adds a custom property handler to this builder.
	 * May be used in rare cases where the property mapping mechanisms offered by this builder are not sufficient.
	 * 
	 * @param handler the handler to add to this builder
	 */
	public function addPropertyHandler (handler:PropertyHandler) : void {
		if (propertyHandlerMap[handler.property.name] != undefined) {
			propertyHandlerList.splice(propertyHandlerList.indexOf(propertyHandlerMap[handler.property.name]), 1);
		}
		propertyHandlerMap[handler.property.name] = handler;
		propertyHandlerList.push(handler);
	}

	
	private function getProperty (propertyName:String) : Property {
		var property:Property = _objectType.getProperty(propertyName);
		if (property == null || !property.writable) {
			throw new IllegalArgumentError("Property with name " + propertyName + " does not exist or is not writable"); 
		}		
		return property;
	}
	
	
	/**
	 * Builds the final mapper based on the instructions that were given through the various
	 * map* methods of this class. The returned mapper instance is lazy-initializing, so the real
	 * mapper does not get created until it is used for the first time through a call to <code>mapToObject</code>
	 * or <code>mapToXml</code>. So calling some of the map* methods of this builder will still modify the 
	 * behaviour of the returned mapper. This mechanism makes it easier to build a nested structure of mappers
	 * with circular references.
	 * 
	 * @return the mapper produced based on instructions given to this class
	 */
	public function build () : XmlObjectMapper {
		return new PropertyMapperDelegate(this, objectType.applicationDomain);
	}
	
	/**
	 * @private
	 */
	internal function get mapper () : PropertyMapper {
		return new PropertyMapper(_objectType, _elementName, propertyHandlerList, _ignoreUnmappedAttributes, _ignoreUnmappedChildren);
	}
	
	
}
}
