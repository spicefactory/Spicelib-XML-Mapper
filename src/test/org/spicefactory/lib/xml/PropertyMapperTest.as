package org.spicefactory.lib.xml {

import org.hamcrest.object.notNullValue;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.object.nullValue;
import org.flexunit.asserts.fail;
import org.hamcrest.core.isA;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.xml.mapper.Choice;
import org.spicefactory.lib.xml.mapper.PropertyMapperBuilder;
import org.spicefactory.lib.xml.mapper.SimpleValueMapper;
import org.spicefactory.lib.xml.model.ChildA;
import org.spicefactory.lib.xml.model.ChildB;
import org.spicefactory.lib.xml.model.ClassWithChild;
import org.spicefactory.lib.xml.model.ClassWithChildren;
import org.spicefactory.lib.xml.model.SimpleClass;
import org.hamcrest.object.equalTo;
import org.flexunit.assertThat;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class PropertyMapperTest {
	
	
	[Test]
	public function attributeMapper () : void {
		var xml:XML = <tag boolean-prop="true" string-prop="foo" int-prop="7" class-prop="flash.events.Event"/>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
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
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
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
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
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
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToChildTextNodes();
		var mapper:XmlObjectMapper = builder.build();
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
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToChildTextNodes();
		var mapper:XmlObjectMapper = builder.build();
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
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToChildTextNodes();
		var mapper:XmlObjectMapper = builder.build();
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
	public function mapSingleAttribute () : void {
		var xml:XML = <tag string-prop="foo"/>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapToAttribute("stringProp");
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(SimpleClass));
		var sc:SimpleClass = SimpleClass(obj);
		assertThat(sc.stringProp, equalTo("foo"));
		assertThat(sc.intProp, equalTo(0));
		assertThat(sc.booleanProp, equalTo(false));
		assertThat(sc.classProp, nullValue());
	}
	
	[Test]
	public function mapSingleChildTextNode () : void {
		var xml:XML = <tag>
			<string-prop>foo</string-prop>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapToChildTextNode("stringProp");
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(SimpleClass));
		var sc:SimpleClass = SimpleClass(obj);
		assertThat(sc.stringProp, equalTo("foo"));
		assertThat(sc.intProp, equalTo(0));
		assertThat(sc.booleanProp, equalTo(false));
		assertThat(sc.classProp, nullValue());
	}
	
	[Test]
	public function mapSingleTextNode () : void {
		var xml:XML = <tag>foo</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapToTextNode("stringProp");
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(SimpleClass));
		var sc:SimpleClass = SimpleClass(obj);
		assertThat(sc.stringProp, equalTo("foo"));
		assertThat(sc.intProp, equalTo(0));
		assertThat(sc.booleanProp, equalTo(false));
		assertThat(sc.classProp, nullValue());
	}
	
	[Test]
	public function mapTextNodeAndAttribute () : void {
		var xml:XML = <tag int-prop="7">foo</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapToTextNode("stringProp");
		builder.mapToAttribute("intProp");
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(SimpleClass));
		var sc:SimpleClass = SimpleClass(obj);
		assertThat(sc.stringProp, equalTo("foo"));
		assertThat(sc.intProp, equalTo(7));
		assertThat(sc.booleanProp, equalTo(false));
		assertThat(sc.classProp, nullValue());
	}
	
	[Test]
	public function mapSingleChildElement () : void {
		var xml:XML = <tag int-prop="7">
			<child name="foo"/>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChild, new QName("tag"));
		builder.createChildElementMapperBuilder("child").mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(ClassWithChild));
		var cwc:ClassWithChild = ClassWithChild(obj);
		assertThat(cwc.intProp, equalTo(7));
		assertThat(cwc.child, notNullValue());
		assertThat(cwc.child.name, equalTo("foo"));
	}
	
	[Test]
	public function mapSingleChildElementExplicit () : void {
		var xml:XML = <tag int-prop="7">
			<child name="foo"/>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChild, new QName("tag"));
		var childBuilder:PropertyMapperBuilder = new PropertyMapperBuilder(ChildA, new QName("child"));
		childBuilder.mapAllToAttributes();
		builder.mapToChildElement("child", childBuilder.build());
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(ClassWithChild));
		var cwc:ClassWithChild = ClassWithChild(obj);
		assertThat(cwc.intProp, equalTo(7));
		assertThat(cwc.child, notNullValue());
		assertThat(cwc.child.name, equalTo("foo"));
	}
	
	[Test]
	public function mapChildElementArray () : void {
		var xml:XML = <tag int-prop="7">
			<child name="A"/>
			<child name="B"/>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChildren, new QName("tag"));
		builder.createChildElementMapperBuilder("children", ChildA, new QName("child")).mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(ClassWithChildren));
		var cwc:ClassWithChildren = ClassWithChildren(obj);
		assertThat(cwc.intProp, equalTo(7));
		assertThat(cwc.children, notNullValue());
		assertThat(cwc.children, arrayWithSize(2));
		assertThat(cwc.children[0].name, equalTo("A"));
		assertThat(cwc.children[1].name, equalTo("B"));
	}
	
	[Test]
	public function mapChildElementChoice () : void {
		var xml:XML = <tag int-prop="7">
			<child-a name="A"/>
			<child-b name="B"/>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChildren, new QName( "tag"));
		var choice:Choice = new Choice();
		var childABuilder:PropertyMapperBuilder = new PropertyMapperBuilder(ChildA, new QName("child-a"));
		childABuilder.mapAllToAttributes();
		var childBBuilder:PropertyMapperBuilder = new PropertyMapperBuilder(ChildB, new QName("child-b"));
		childBBuilder.mapAllToAttributes();
		choice.addMapper(childABuilder.build());
		choice.addMapper(childBBuilder.build());
		builder.mapToChildElementChoice("children", choice);
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(ClassWithChildren));
		var cwc:ClassWithChildren = ClassWithChildren(obj);
		assertThat(cwc.intProp, equalTo(7));
		assertThat(cwc.children, notNullValue());
		assertThat(cwc.children, arrayWithSize(2));
		assertThat(cwc.children[0], isA(ChildA));
		assertThat(cwc.children[1], isA(ChildB));
		assertThat(cwc.children[0].name, equalTo("A"));
		assertThat(cwc.children[1].name, equalTo("B"));
	}
	
	[Test]
	public function missingRequiredChildren () : void {
		var xml:XML = <tag int-prop="7"/>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChildren, new QName("tag"));
		builder.createChildElementMapperBuilder("children", ChildA, new QName("child")).mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
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
	public function missingRequiredChild () : void {
		var xml:XML = <tag int-prop="7"/>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChild, new QName("tag"));
		builder.createChildElementMapperBuilder("child").mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
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
	public function twoErrors () : void {
		var xml:XML = <tag><child/></tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChild, new QName("tag"));
		builder.createChildElementMapperBuilder("child").mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var context:XmlProcessorContext = new XmlProcessorContext();
		try {
			mapper.mapToObject(xml, context);
		} catch (e:MappingError) {
			assertThat(context.hasErrors(), equalTo(true));
			assertThat(e.causes, arrayWithSize(2));
			assertThat(context.errors, arrayWithSize(2));
			return;
		}
		fail("Expected mapping error");
	}
	
	[Test]
	public function xmlNamespace () : void {
		var xml:XML = <tag int-prop="7" xmlns:ns="testuri">
			<ns:child name="foo"/>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChild, new QName("tag"));
		builder.createChildElementMapperBuilder("child", null, new QName("testuri", "child")).mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(ClassWithChild));
		var cwc:ClassWithChild = ClassWithChild(obj);
		assertThat(cwc.intProp, equalTo(7));
		assertThat(cwc.child, notNullValue());
		assertThat(cwc.child.name, equalTo("foo"));
	}
	
	[Test]
	public function simpleMapper () : void {
		var xml:XML = <tag>
			<child>foo</child>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapToChildElement("stringProp", new SimpleValueMapper(ClassInfo.forClass(String), new QName("child")));
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml);
		assertThat(obj, isA(SimpleClass));
		var sc:SimpleClass = SimpleClass(obj);
		assertThat(sc.stringProp, equalTo("foo"));
	}
	
}
}
