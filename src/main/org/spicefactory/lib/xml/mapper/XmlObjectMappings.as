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
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Metadata;
import org.spicefactory.lib.reflect.metadata.Target;
import org.spicefactory.lib.xml.DefaultNamingStrategy;
import org.spicefactory.lib.xml.NamingStrategy;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.mapper.metadata.AttributeDecorator;
import org.spicefactory.lib.xml.mapper.metadata.ChildTextNodeDecorator;
import org.spicefactory.lib.xml.mapper.metadata.ChoiceIdDecorator;
import org.spicefactory.lib.xml.mapper.metadata.ChoiceTypeDecorator;
import org.spicefactory.lib.xml.mapper.metadata.IgnoreDecorator;
import org.spicefactory.lib.xml.mapper.metadata.TextNodeDecorator;
import org.spicefactory.lib.xml.mapper.metadata.XmlMapping;

import flash.system.ApplicationDomain;
import flash.utils.Dictionary;

/**
 * The main entry point for the DSL to create a group of XML to Object mappings that support metadata configuration.
 * 
 * <p>Example:</p>
 * 
 * <code><pre>var mapper:XmlObjectMapper = XmlObjectMappings			
 *	.forNamespace("http://www.mynamespace.com")
 *		.withRootElement(BookStore)	
 *			.mappedClasses(Book, Author, Price, DeliveryMethod)
			.build();</pre></code>
 * 
 * @author Jens Halm
 */
public class XmlObjectMappings {
	

	private static const metadataClasses:Array = [
		Target,
		XmlMapping,
		IgnoreDecorator,
		AttributeDecorator,
		ChildTextNodeDecorator,
		TextNodeDecorator,
		ChoiceIdDecorator,
		ChoiceTypeDecorator
	];
	
	private static var metadataRegistered:Boolean;
	
	private var uri:String;
	private var domain:ApplicationDomain;
	private var rootType:Class;
	private var processed:Boolean;
	private var rootMapper:XmlObjectMapper;
	
	private var choices:ChoiceRegistry = new ChoiceRegistry();
	
	private var _defaultSimpleMappingType:SimpleMappingType = SimpleMappingType.ATTRIBUTE;
	private var _defaultNamingStrategy:NamingStrategy = new DefaultNamingStrategy();
	
	private var mappers:Array = new Array();
	private var mappersByType:Dictionary = new Dictionary();
	private var metadataBuilders:Array = new Array();
	private var _mergedMappings:Array = new Array();
	
	
	/**
	 * Entry point for creating mappings for a particular XML namespace.
	 * 
	 * @param uri the URI of the XML namespace
	 * @return an instance that allows to specify the root element mapping
	 */
	public static function forNamespace (uri:String) : RootElementSetup {
		return new RootElementSetup(uri);
	}
	
	
	/**
	 * Entry point for creating mappings for unqualified XML elements.
	 * 
	 * @return an instance that allows to specify the root element mapping
	 */
	public static function forUnqualifiedElements () : RootElementSetup {
		return new RootElementSetup();
	}
	
	
	
	/**
	 * @private
	 */
	function XmlObjectMappings (uri:String, domain:ApplicationDomain = null, rootType:Class = null) {
		this.uri = uri;
		this.domain = domain;
		this.rootType = rootType;
		registerMetadata();
	}

	private function registerMetadata () : void {
		if (!metadataRegistered) {
			for each (var metadataClass:Class in metadataClasses) {
				Metadata.registerMetadataClass(metadataClass, domain);
			}
			metadataRegistered = true;
		}
	}

	
	/**
	 * The naming strategy to use for transforming property names to XML attribute and element names.
	 * The default strategy transforms camel-case names to the dash notation most commonly used for XML names 
	 * (e.g. changing 'serviceName' to 'service-name').
	 * 
	 * @param strategy the naming strategy to use for transforming property names to XML attribute and element names
	 * @return this builder for method chaining
	 */
	public function defaultNamingStrategy (strategy:NamingStrategy) : XmlObjectMappings {
		_defaultNamingStrategy = strategy;
		return this;
	}
	
	/**
	 * The mapping type to use for all simple types that do not have a metadata tag.
	 * The default is <code>SimpleMappingType.ATTRIBUTE</code>.
	 * Simple types are Boolean, String, Number, int, uint, Class, ClassInfo and Date.
	 * If you want to map any other AS3 type to simple XML types you have to configure
	 * them explicitly with metadata tags on the property (or programmatically with a custom
	 * XmlObjectMapper).
	 * 
	 * @param type the mapping type to use for all simple types that do not have a metadata tag 
	 * @return this builder for method chaining
	 */
	public function defaultSimpleMappingType (type:SimpleMappingType) : XmlObjectMappings {
		_defaultSimpleMappingType = type;
		return this;
	}
	
	/**
	 * Adds all specified classes to the group of mappings.
	 * For all these types only metadata on the properties will be processed to determine
	 * the type of mapping to apply. For properties without metadata the defaults will be applied
	 * (mapping to attributes for simple types and to child element choices for complex types).
	 * If you need to specify a mapping with custom, programmatic mapping setup, use one of the
	 * other methods of this class like <code>customMapper</code> or <code>newMapperBuilder</code>.
	 * 
	 * @param types the classes to add the the group of mappings
	 * @return this builder for method chaining
	 */
	public function mappedClasses (...types) : XmlObjectMappings {
		for each (var type:Class in types) {
			newMapperBuilder(type);
		}
		return this;
	}
	
	/**
	 * Adds a custom mapper to the group of mappings. 
	 * If you want to combine metadata configuration with programmatic setup <code>newMapperBuilder</code>
	 * should be used instead.
	 * 
	 * @param mapper the mapper to add to the group of mappings.
	 * @return this builder for method chaining
	 */
	public function customMapper (mapper:XmlObjectMapper) : XmlObjectMappings {
		addMapper(mapper);
		return this;
	}
	
	/**
	 * Creates a new builder for a custom mapper. This builder allows to combine metadata configuration
	 * with programmatic setup. For any property where a mapping was specified programmatically through
	 * the returned <code>MetadataMapperBuilder</code> metadata tags on the property will be ignored.
	 * 
	 * @param mappedType the type to create a new builder for
	 * @param elementName the (optional) name of the mapped element (if omitted the default NamingStrategy will determine the name)
	 * @return a new builder for a custom mapper
	 */
	public function newMapperBuilder (mappedType:Class, elementName:QName = null) : MetadataMapperBuilder {
		var info:ClassInfo = ClassInfo.forClass(mappedType, domain);
		if (elementName == null) elementName = new QName(this.uri, _defaultNamingStrategy.toXmlName(info.simpleName));
		var builder:MetadataMapperBuilder 
				=  new MetadataMapperBuilder(mappedType, elementName, choices, _defaultNamingStrategy, domain);
		metadataBuilders.push(builder);
		addMapper(builder.build());
		return builder;
	}
	
	/**
	 * Merges an existing group of mappings into this group.
	 * Allows to mix multiple namespaces or simply reuse existing setups.
	 * The merge operation will add all mappings of the specified group to this group
	 * and also merges any choices with an id that also exists in this group.
	 * 
	 * @param mappings
	 * @return this builder for method chaining
	 */
	public function mergedMappings (mappings:XmlObjectMappings) : XmlObjectMappings {
		_mergedMappings.push(mappings);
		return this;
	}
	
	/**
	 * Specifies the classes that are allowed as an element in the choice with the specified id.
	 * This call is necessary to tell the mapper which elements qualify to be used for properties
	 * that have the <code>[ChoiceId]</code> metadata. The list of classes can also contain
	 * classes for which custom mappings have already been specified for this group.
	 * For any type in the list where no mapping has been created yet, the framework
	 * will create one automatically in the same way like with calling <code>mappedClasses</code>.
	 * 
	 * @param id the id of the choice
	 * @param mappedClasses the classes that represent valid elements for the choice
	 * @return this builder for method chaining
	 */
	public function choiceId (id:String, ...mappedClasses) : XmlObjectMappings {
		var c:Choice = choices.getChoiceById(id);
		for each (var type:Class in mappedClasses) {
			if (mappersByType[type] == undefined) {
				newMapperBuilder(type);
			}
			c.addMapper(mappersByType[type] as XmlObjectMapper);
		}
		return this;
	}
	
	private function addMapper (mapper:XmlObjectMapper) : void {
		if (mappersByType[mapper.objectType.getClass()] != undefined) {
			throw new IllegalStateError("Mapper for class " 
					+ mapper.objectType.name + "has already been specified");
		}
		mappersByType[mapper.objectType.getClass()] = mapper;
		mappers.push(mapper);
	}
	
	
	/**
	 * @private
	 */
	internal function mergeInto (byType:Dictionary, mappers:Array, choices:ChoiceRegistry) : void {
		if (!rootMapper) {
			processMappings();
		}
		for each (var mapper:XmlObjectMapper in mappersByType) {
			byType[mapper.objectType.getClass()] = mapper;
			mappers.push(mapper);
		}
		this.choices.mergeInto(choices);
		this.choices.validate();
	}

	
	/**
	 * Processes all specified mappings and returns the concrete mapper instance
	 * for the root element.
	 * 
	 * @return the mapper for the root element
 	 */
	public function build () : XmlObjectMapper {
		
		processMappings();
		choices.validate();
		
		return rootMapper;
		
	}
	
	private function processMappings () : void {
		
		if (!processed) {
			
			if (rootType) {
				if (mappersByType[rootType] == undefined) {
					newMapperBuilder(rootType);
				}
				rootMapper = mappersByType[rootType] as XmlObjectMapper;
			}
			
			for each (var merged:XmlObjectMappings in _mergedMappings) {
				merged.mergeInto(mappersByType, mappers, choices);
			}
			
			for each (var builder:MetadataMapperBuilder in metadataBuilders) {
				builder.processMetadata(_defaultSimpleMappingType);
			}
			
			choices.populateTypeChoices(mappersByType);

			postProcess(mappers);
			
			processed = true;
		}
		
	}
	
	/**
	 * Hook for subclasses that wish to postprocess some of the mappings.
	 * The default implementation does nothing.
	 * 
	 * @param mappers all mappers configured by this mappings group
	 */
	protected function postProcess (mappers:Array) : void {
		/* do nothing */
	}
	
	
}
}
