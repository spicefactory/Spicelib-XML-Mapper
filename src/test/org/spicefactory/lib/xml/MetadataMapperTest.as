package org.spicefactory.lib.xml {

import org.hamcrest.object.notNullValue;
import org.hamcrest.collection.arrayWithSize;
import org.flexunit.asserts.fail;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.equalTo;
import org.hamcrest.core.isA;
import org.flexunit.assertThat;
import org.spicefactory.lib.xml.mapper.PropertyMapperBuilder;
import org.spicefactory.lib.xml.mapper.SimpleMappingType;
import org.spicefactory.lib.xml.mapper.XmlObjectMappings;
import org.spicefactory.lib.xml.model.ChildA;
import org.spicefactory.lib.xml.model.ChildB;
import org.spicefactory.lib.xml.model.ChildC;
import org.spicefactory.lib.xml.model.ClassWithChild;
import org.spicefactory.lib.xml.model.SimpleClass;
import org.spicefactory.lib.xml.model.metadata.ChildTextNodes;
import org.spicefactory.lib.xml.model.metadata.CustomName;
import org.spicefactory.lib.xml.model.metadata.MappedAttribute;
import org.spicefactory.lib.xml.model.metadata.MappedIdChoice;
import org.spicefactory.lib.xml.model.metadata.MappedTextNode;
import org.spicefactory.lib.xml.model.metadata.MappedTypeChoice;
import org.spicefactory.lib.xml.model.metadata.UnmappedXml;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class MetadataMapperTest {
	
	
	[Test]
	public function attributeMapper () : void {
		var xml:XML = <tag boolean-prop="true" string-prop="foo" int-prop="7" class-prop="flash.events.Event"/>;
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(SimpleClass)
							.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(SimpleClass));
		var sc:SimpleClass = SimpleClass(obj);
		assertThat(sc.stringProp, equalTo("foo"));
		assertThat(sc.intProp, equalTo(7));
		assertThat(sc.booleanProp, equalTo(true));
		assertThat(sc.classProp, equalTo(Event));
	}
	
	[Test]
	public function attributeMapperWithMissingOptionalAttr () : void {
		var xml:XML = <tag boolean-prop="true" string-prop="foo" int-prop="7"/>;
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(SimpleClass)
							.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(SimpleClass));
		var sc:SimpleClass = SimpleClass(obj);
		assertThat(sc.stringProp, equalTo("foo"));
		assertThat(sc.intProp, equalTo(7));
		assertThat(sc.booleanProp, equalTo(true));
		assertThat(sc.classProp, nullValue());
	}
	
	[Test]
	public function attributeMapperWithMissingRequiredAttr () : void {
		var xml:XML = <tag boolean-prop="true" int-prop="7"/>;
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(SimpleClass)
							.build();
		var context:XmlProcessorContext = new XmlProcessorContext();
		try {
			mapper.mapToObject(xml, context);
		} catch (e:MappingError) {
			assertThat(context.hasErrors(), equalTo(true));
			assertThat(context.errors, arrayWithSize(1));
			return;
		}
		fail("Expected mapping error");
	}
	
	[Test]
	public function textNodeMapper () : void {
		var xml:XML = <tag>
			<string-prop>foo</string-prop>
			<int-prop>7</int-prop>
			<boolean-prop>true</boolean-prop>
			<class-prop>flash.events.Event</class-prop>
		</tag>;
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(SimpleClass)
							.defaultSimpleMappingType(SimpleMappingType.CHILD_TEXT_NODE)
							.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(SimpleClass));
		var sc:SimpleClass = SimpleClass(obj);
		assertThat(sc.stringProp, equalTo("foo"));
		assertThat(sc.intProp, equalTo(7));
		assertThat(sc.booleanProp, equalTo(true));
		assertThat(sc.classProp, equalTo(Event));
	}
	
	[Test]
	public function textNodeMapperWithMissingOptionalNode () : void {
		var xml:XML = <tag>
			<string-prop>foo</string-prop>
			<int-prop>7</int-prop>
			<boolean-prop>true</boolean-prop>
		</tag>;
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(SimpleClass)
							.defaultSimpleMappingType(SimpleMappingType.CHILD_TEXT_NODE)
							.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(SimpleClass));
		var sc:SimpleClass = SimpleClass(obj);
		assertThat(sc.stringProp, equalTo("foo"));
		assertThat(sc.intProp, equalTo(7));
		assertThat(sc.booleanProp, equalTo(true));
		assertThat(sc.classProp, nullValue());
	}
	
	[Test]
	public function textNodeMapperWithMissingRequiredNode () : void {
		var xml:XML = <tag>
			<int-prop>7</int-prop>
			<boolean-prop>true</boolean-prop>
		</tag>;
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(SimpleClass)
							.defaultSimpleMappingType(SimpleMappingType.CHILD_TEXT_NODE)
							.build();
		var context:XmlProcessorContext = new XmlProcessorContext();
		try {
			mapper.mapToObject(xml, context);
		} catch (e:MappingError) {
			assertThat(context.hasErrors(), equalTo(true));
			assertThat(context.errors, arrayWithSize(1));
			return;
		}
		fail("Expected mapping error");
	}
	
	[Test]
	public function textNodeMapperWithMetadata () : void {
		var xml:XML = <tag>
			<string-prop>foo</string-prop>
			<int-prop>7</int-prop>
			<boolean-prop>true</boolean-prop>
			<class-prop>flash.events.Event</class-prop>
		</tag>;
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(ChildTextNodes)
							.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(ChildTextNodes));
		var sc:ChildTextNodes = ChildTextNodes(obj);
		assertThat(sc.stringProp, equalTo("foo"));
		assertThat(sc.intProp, equalTo(7));
		assertThat(sc.booleanProp, equalTo(true));
		assertThat(sc.classProp, equalTo(Event));
	}
	
	[Test]
	public function mapTextNodeAndAttribute () : void {
		var xml:XML = <tag int-prop="7">foo</tag>;
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(MappedTextNode)
							.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(MappedTextNode));
		var mapped:MappedTextNode = MappedTextNode(obj);
		assertThat(mapped.stringProp, equalTo("foo"));
		assertThat(mapped.intProp, equalTo(7));
	}
	
	[Test]
	public function mapAttributeAndIgnoredProperty () : void {
		var xml:XML = <tag string-prop="foo"><boolean-prop>true</boolean-prop></tag>;
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(MappedAttribute)
							.defaultSimpleMappingType(SimpleMappingType.CHILD_TEXT_NODE)
							.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(MappedAttribute));
		var mapped:MappedAttribute = MappedAttribute(obj);
		assertThat(mapped.stringProp, equalTo("foo"));
		assertThat(mapped.booleanProp, equalTo(true));
		assertThat(mapped.intProp, equalTo(0));
	}
	
	[Test]
	public function mapSingleChildElement () : void {
		var xml:XML = <tag int-prop="7">
			<child-a name="foo"/>
		</tag>;
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(ClassWithChild)
							.mappedClasses(ChildA)
							.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(ClassWithChild));
		var cwc:ClassWithChild = ClassWithChild(obj);
		assertThat(cwc.intProp, equalTo(7));
		assertThat(cwc.child, notNullValue());
		assertThat(cwc.child.name, equalTo("foo"));
	}
	
	[Test]
	public function idChoice () : void {
		var xml:XML = <tag int-prop="7">
			<child-a name="A"/>
			<child-b name="B"/>
		</tag>;
		
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(MappedIdChoice)
							.choiceId("foo", ChildA, ChildB)
							.build();
		
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(MappedIdChoice));
		var mapped:MappedIdChoice = MappedIdChoice(obj);
		assertThat(mapped.intProp, equalTo(7));
		assertThat(mapped.children, notNullValue());
		assertThat(mapped.children, arrayWithSize(2));
		assertThat(mapped.children[0], isA(ChildA));
		assertThat(mapped.children[1], isA(ChildB));
		assertThat(mapped.children[0].name, equalTo("A"));
		assertThat(mapped.children[1].name, equalTo("B"));
	}
	
	[Test]
	public function idChoiceWithIllegalChild () : void {
		var xml:XML = <tag int-prop="7">
			<child-a name="A"/>
			<child-b name="B"/>
			<child-c name="C"/>
		</tag>;
		
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(MappedIdChoice)
						    .mappedClasses(ChildC)
							.choiceId("foo", ChildA, ChildB)
							.build();
		var context:XmlProcessorContext = new XmlProcessorContext();
		try {
			mapper.mapToObject(xml, context);
		} catch (e:MappingError) {
			assertThat(context.hasErrors(), equalTo(true));
			assertThat(context.errors, arrayWithSize(1));
			return;
		}
		fail("Expected mapping error");
	}
	
	[Test]
	public function typeChoice () : void {
		var xml:XML = <tag int-prop="7">
			<child-a name="A"/>
			<child-b name="B"/>
		</tag>;
		
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(MappedTypeChoice)
							.mappedClasses(ChildA, ChildB, ChildC)
							.build();
		
		var obj:Object = mapper.mapToObject(xml);
		validateMappedTypeChoice(obj);
	}
	
	[Test]
	public function typeChoiceWithIllegalChild () : void {
		var xml:XML = <tag int-prop="7">
			<child-a name="A"/>
			<child-b name="B"/>
			<child-c name="C"/>
		</tag>;
		
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(MappedTypeChoice)
							.mappedClasses(ChildA, ChildB, ChildC)
							.build();
		var context:XmlProcessorContext = new XmlProcessorContext();
		try {
			mapper.mapToObject(xml, context);
		} catch (e:MappingError) {
			assertThat(context.hasErrors(), equalTo(true));
			assertThat(context.errors, arrayWithSize(1));
			return;
		}
		fail("Expected mapping error");
	}
	
	[Test]
	public function customBuilder () : void {
		var xml:XML = <tag int-prop="7">
			<custom name="A"/>
			<child-b name="B"/>
		</tag>;
		
		var mappings:XmlObjectMappings 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(MappedTypeChoice);
		mappings.newMapperBuilder(ChildA, new QName("custom"));
		var mapper:XmlObjectMapper = mappings.mappedClasses(ChildB, ChildC).build();
		
		var obj:Object = mapper.mapToObject(xml);
		validateMappedTypeChoice(obj);
	}
	
	[Test]
	public function customMapper () : void {
		var xml:XML = <tag int-prop="7">
			<custom name="A"/>
			<child-b name="B"/>
		</tag>;
		
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ChildA, new QName("custom"));
		builder.mapAllToAttributes();
		var customMapper:XmlObjectMapper = builder.build();
		
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(MappedTypeChoice)
						.customMapper(customMapper)
						.mappedClasses(ChildB, ChildC)
						.build();
		
		var obj:Object = mapper.mapToObject(xml);
		validateMappedTypeChoice(obj);
	}
	
	[Test]
	public function mergedMappings () : void {
		var xml:XML = <tag int-prop="7">
			<child-a name="A"/>
			<child-b name="B"/>
		</tag>;
		
		var mappings:XmlObjectMappings = XmlObjectMappings
			.forUnqualifiedElements()
				.withoutRootElement()
					.mappedClasses(ChildA, ChildB, ChildC);
		
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(MappedTypeChoice)
						.mergedMappings(mappings)
						.build();
		
		var obj:Object = mapper.mapToObject(xml);
		validateMappedTypeChoice(obj);
	}
	
	[Test]
	public function xmlNamespace () : void {
		var xml:XML = <tag int-prop="7" xmlns:ns="testuri">
			<ns:child-a name="A"/>
			<ns:child-b name="B"/>
		</tag>;
		
		var mappings:XmlObjectMappings = XmlObjectMappings
			.forNamespace("testuri")
				.withoutRootElement()
					.mappedClasses(ChildA, ChildB, ChildC);
		
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(MappedTypeChoice)
						.mergedMappings(mappings)
						.build();
		
		var obj:Object = mapper.mapToObject(xml);
		validateMappedTypeChoice(obj);
	}
	
	private function validateMappedTypeChoice (obj:Object) : void {
		assertThat(obj, isA(MappedTypeChoice));
		var mapped:MappedTypeChoice = MappedTypeChoice(obj);
		assertThat(mapped.intProp, equalTo(7));
		assertThat(mapped.children, notNullValue());
		assertThat(mapped.children, arrayWithSize(2));
		assertThat(mapped.children[0], isA(ChildA));
		assertThat(mapped.children[1], isA(ChildB));
		assertThat(ChildA(mapped.children[0]).name, equalTo("A"));
		assertThat(ChildB(mapped.children[1]).name, equalTo("B"));
	}
	
	[Test]
	public function customName () : void {
		var xml:XML = <custom string-prop="foo"/>;
		
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(CustomName)
						.build();
		
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(CustomName));
		var sc:CustomName = CustomName(obj);
		assertThat(sc.stringProp, equalTo("foo"));
	}
	
	[Test]
	public function ignoreUnmappedXml () : void {
		var xml:XML = <ignore-unmapped-xml unmapped="foo"><unmapped/></ignore-unmapped-xml>;
		
		var mapper:XmlObjectMapper 
				= XmlObjectMappings
					.forUnqualifiedElements()
						.withRootElement(UnmappedXml)
						.build();
		
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(UnmappedXml));
	}
	
	 
}
}
