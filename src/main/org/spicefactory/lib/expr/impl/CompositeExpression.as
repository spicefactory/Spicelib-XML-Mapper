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
	
/**	
 * Represents a composite expression consisting of a sequence of literal expressions
 * and value expressions.
 * Example: <code>"The person must be at least ${config.minAge} years old."</code>
 * 
 * @author Jens Halm
 */
public class CompositeExpression implements Expression {
	
	
	private var expressions:Array;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param expressions the expression parts that constitute this composite expression
	 */
	public function CompositeExpression (expressions:Array) {
		this.expressions = expressions;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get value() : * {
		var value:String = "";
		for each (var ex:Expression in expressions) {
			value += ex.value.toString();
		}
		return value;
	}

	/**
	 * @inheritDoc
	 */
	public function get expressionString() : String {
		var expressionString:String = "";
		for each (var ex:Expression in expressions) {
			expressionString += ex.expressionString;
		}
		return expressionString;
	}
	
	
	
}

}