package org.spicefactory.lib.expr {

import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.nullValue;
import org.spicefactory.lib.expr.impl.DefaultExpressionContext;
import org.spicefactory.lib.expr.impl.DefaultVariableResolver;
import org.spicefactory.lib.expr.impl.ValueExpression;
import org.spicefactory.lib.expr.model.SimpleModel;

public class ExpressionTest {
	
	
	private var context:ExpressionContext;
	
	
	[Before]
	public function setUp () : void {
		context = new DefaultExpressionContext();
	}
	
	
	[Test]
	public function literalExpression () : void {
		var ex:Expression = context.createExpression("literal");
		assertThat("literal", equalTo(ex.value));
	}
	
	[Test]
	public function escapedExpression () : void {
		var ex:Expression = context.createExpression("$\\{escaped}");
		assertThat(ex.value, equalTo("${escaped}"));
	}
	
	[Test]
	public function simpleValueExpression () : void {
		context.setVariable("foo", 42);
		var ex:Expression = context.createExpression("${foo}");
		assertThat(ex.value, equalTo(42));
	}
	
	[Test]
	public function simpleProperty () : void {
		var model:SimpleModel = new SimpleModel();
		model.property = "xyz";
		context.setVariable("model", model);
		var ex:Expression = context.createExpression("${model.property}");
		assertThat(ex.value, equalTo("xyz"));
	}
	
	[Test(expects="org.spicefactory.lib.expr.impl.IllegalExpressionError")]
	public function unresolvableExpression () : void {
		context.createExpression("${foo}").value;
	}
	
	[Test]
	public function chainedVariableResolver () : void {
		var vr:DefaultVariableResolver = new DefaultVariableResolver();
		vr.setVariable("foo", 1);
		context.setVariable("bar", 2);
		context.addVariableResolver(vr);
		var ex1:Expression = context.createExpression("${foo}");
		var ex2:Expression = context.createExpression("${bar}");
		assertThat(ex1.value, equalTo(1));
		assertThat(ex2.value, equalTo(2));
	}
	
	[Test]
	public function compositeExpression () : void {
		context.setVariable("foo", 42);
		var ex:Expression = context.createExpression("The Meaning of Life is ${foo}");
		assertThat(ex.value, equalTo("The Meaning of Life is 42"));
	}
	
	[Test(expects="org.spicefactory.lib.expr.impl.IllegalExpressionError")]
	public function illegalInt () : void {
		context.createExpression("Illegal ${expression");
	}
	
	[Test]
	public function defaultValue () : void {
		var ve:Expression = ValueExpression(context.createExpression("${foo|'bar'}"));
		assertThat(ve.value, equalTo("bar"));
	}
	
	[Test]
	public function nullDefaultValue () : void {
		var ve:ValueExpression = ValueExpression(context.createExpression("${foo|null}"));
		assertThat(ve.defaultValue, nullValue());
	}
	
	[Test]
	public function stringDefaultValue () : void {
		var ve:ValueExpression = ValueExpression(context.createExpression("${foo|'bar'}"));
		assertThat(ve.defaultValue, equalTo("bar"));
	}
	
	[Test]
	public function numberDefaultValue () : void {
		var ve:ValueExpression = ValueExpression(context.createExpression("${foo|23}"));
		assertThat(ve.defaultValue, equalTo(23));
	}
	
	[Test]
	public function expressionDefaultValue () : void {
		context.setVariable("bar", true);
		var ve:ValueExpression = ValueExpression(context.createExpression("${foo|bar}"));
		assertThat(ValueExpression(ve.defaultValue).value, equalTo(true));
	}
	
	
}

}