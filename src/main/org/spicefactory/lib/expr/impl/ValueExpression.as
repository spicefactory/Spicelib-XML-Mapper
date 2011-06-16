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
 */
 
package org.spicefactory.lib.expr.impl {
import org.spicefactory.lib.expr.Expression;
import org.spicefactory.lib.expr.PropertyResolver;
import org.spicefactory.lib.expr.VariableResolver;

/**	
 * Represents a value expression without literal parts. That means the expression starts
 * with <code>${</code> and ends with <code>}</code>.
 * Example: <code>"${user.address.city}"</code>
 * 
 * @author Jens Halm
 */
public class ValueExpression implements Expression {
	
	private var _expressionString:String;
	
	private var expressionParts:Array;
	private var variableResolver:VariableResolver;
	private var propertyResolver:PropertyResolver;
	private var _defaultValue:*;
	
	
	/**
	 * Creates a new expression instance.
	 * 
	 * @param expressionString the expression string
	 * @param variableResolver the VariableResolver to use for this expression
	 * @param propertyResolver the PropertyResolver to use for this expression
	 */
	public function ValueExpression (
			expressionString:String, 
			variableResolver:VariableResolver,
			propertyResolver:PropertyResolver
			) {
		if (expressionString == null || expressionString.length == 0) {
			throw new IllegalExpressionError("An empty or null String is not a legal expression");
		}
		this._expressionString = expressionString;
		this.variableResolver = variableResolver;
		this.propertyResolver = propertyResolver;
		var index:int = expressionString.indexOf("|");
		if (index == -1) {
			this.expressionParts = expressionString.split(".");
		}
		else {
			this.expressionParts = expressionString.substring(0, index).split(".");
			this._defaultValue = resolveDefaultValue(expressionString.substring(index + 1));
		}
	}
	
	private function resolveDefaultValue (expression:String) : * {
		if (expression == "null") {
			return null;
		}
		else if (expression == "true") {
			return true;
		}
		else if (expression == "false") {
			return false;
		}
		else if (expression.search(/^'.*'$/) >= 0) {
			return expression.substring(1, expression.length - 1);
		}
		else if (expression.search(/^[0-9].*$/) >= 0) {
			var num:Number = Number(expression);
			if (isNaN(num)) {
				throw new IllegalExpressionError("Unable to convert value to Number: " + expression);
			}
			return num;
		}
		else {
			return new ValueExpression(expression, variableResolver, propertyResolver);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function get value () : * {
		var val:* = variableResolver.resolveVariable(expressionParts[0]);
		for (var i:Number = 1; i < expressionParts.length; i++) {
			if (val == undefined) break;
			val = propertyResolver.resolveProperty(val, expressionParts[i]);
		}
		if (val === undefined) {
			if (_defaultValue === undefined) {
				throw new IllegalExpressionError("Expression " + expressionString 
						+ " cannot be resolved and no default value specified");
			}
			return (_defaultValue is ValueExpression) 
					? ValueExpression(_defaultValue).value : _defaultValue;
		}
		return val;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get expressionString () : String {
		return "${" + _expressionString + "}";
	}	
	
	/**
	 * The default value to use when this expression evaluates to undefined.
	 * Might be an instance of <code>ValueExpression</code> itself.
	 */
	public function get defaultValue () : * {
		return _defaultValue;
	}
	
}

}