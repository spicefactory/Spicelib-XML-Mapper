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
 
package org.spicefactory.lib.expr {

/**
 * Represents a single expression. Expressions are String values that may contain
 * dynamic values surrounded by <code>${...}</code> which will be resolved by
 * <code>VariableResolver</code> and/or <code>PropertyResolver</code> instances.
 * Example: <code>"The person must be at least ${config.minAge} years old."</code>
 * 
 * @author Jens Halm
 */
public interface Expression	{

	/**
	 * The fully resolved value of this expression.
	 */
	function get value () : * ;
	
	/**
	 * The unresolved expression string.
	 */
	function get expressionString () : String;
		
}

}