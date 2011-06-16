package org.spicefactory.lib.xml.mapper {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.XmlProcessorContext;

import flash.system.ApplicationDomain;

/**
 * @private
 * 
 * @author Jens Halm
 */
internal class PropertyMapperDelegate implements XmlObjectMapper {

	
	private var builder:PropertyMapperBuilder;
	private var mapper:XmlObjectMapper;
	
	private var domain:ApplicationDomain;
	
	
	function PropertyMapperDelegate (builder:PropertyMapperBuilder, domain:ApplicationDomain) {
		this.builder = builder;
		this.domain = domain;
	}

	
	public function get objectType () : ClassInfo {
		return builder.objectType;
	}
	
	public function get elementName () : QName {
		return builder.elementName;
	}
	
	public function mapToObject (element:XML, context:XmlProcessorContext = null) : Object {
		if (context == null) context = new XmlProcessorContext(null, domain);
		if (mapper == null) mapper = builder.mapper;
		return mapper.mapToObject(element, context);
	}
	
	public function mapToXml (object:Object, context:XmlProcessorContext = null) : XML {
		if (context == null) context = new XmlProcessorContext(null, domain);
		if (mapper == null) mapper = builder.mapper;
		return mapper.mapToXml(object, context);
	}


}
}