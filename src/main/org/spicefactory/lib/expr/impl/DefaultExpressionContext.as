/*
 * Copyright 2007 the original author or authors.
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
 * 
 * @author Jens Halm
 */
 
package org.spicefactory.lib.expr.impl {
import org.spicefactory.lib.expr.Expression;
import org.spicefactory.lib.expr.ExpressionContext;
import org.spicefactory.lib.expr.PropertyResolver;
import org.spicefactory.lib.expr.VariableResolver;

/**
 * Default implementation of the ExpressionContext interface.
 */
public class DefaultExpressionContext implements ExpressionContext {
	
	
	private var variables:DefaultVariableResolver;
	private var variableResolver:ChainedVariableResolver;
	private var propertyResolver:ChainedPropertyResolver;
	
	
	/**
	 * Creates a new context instance.
	 */
	public function DefaultExpressionContext () {
		variableResolver = new ChainedVariableResolver();
		variables = new DefaultVariableResolver();
		variableResolver.addResolver(variables);
		propertyResolver = new ChainedPropertyResolver();
		propertyResolver.addResolver(new DefaultPropertyResolver());
	}
	
	/**
	 * @inheritDoc
	 */
	public function createExpression (expression : String) : Expression {
		var index:int = expression.indexOf("${");
		if (index == -1) {
			return new LiteralExpression(expression);
		} else if (index == 0 && expression.indexOf("}") == expression.length - 1) {
			return buildValueExpression(expression);
		} else {
			return buildCompositeExpression(expression);
		}
		return null;
	}
	
	private function buildValueExpression (expression:String) : Expression {
		var ex:String = expression.substring(2, expression.length - 1);
		return new ValueExpression(ex, variableResolver, propertyResolver); 		
	}
	
	private function buildCompositeExpression (expression:String) : Expression {
		var tmp:Array = expression.split("${");
		var expressionStrings:Array = [tmp[0]];
		for (var i:uint = 1; i < tmp.length; i++) {
			var part:String = tmp[i];
			var endIndex:Number = part.indexOf("}");
			if (endIndex == -1) {
				throw new IllegalExpressionError("Missing closing brace in expression: " + expression);
			}
			expressionStrings.push(part.substring(0, endIndex));
			expressionStrings.push(part.substring(endIndex + 1));
		}
		var expressions:Array = new Array();
		for (i = 0; i < expressionStrings.length; i++) {
			var literal:String = expressionStrings[i];
			if (literal.length > 0) {
				expressions.push(new LiteralExpression(literal));
			}
			if (++i < expressionStrings.length) {
				var value:String = expressionStrings[i];
				if (value.length > 0) {
					expressions.push(new ValueExpression(value, variableResolver, propertyResolver));
				}
			}
		}			
		return new CompositeExpression(expressions);
	}
	
	/**
	 * @inheritDoc
	 */
	public function addVariableResolver (resolver : VariableResolver) : void {
		variableResolver.addResolver(resolver);
	}
	
	/**
	 * @inheritDoc
	 */
	public function addPropertyResolver (resolver : PropertyResolver) : void {
		propertyResolver.addResolver(resolver);
	}
	
	/**
	 * @inheritDoc
	 */
	public function setVariable (name:String, value:*) : void {
		variables.setVariable(name, value);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeVariable (name:String) : void {
		variables.removeVariable(name);
	}
	
	
}

}