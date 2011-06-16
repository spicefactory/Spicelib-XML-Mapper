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
 * Represents a context for creating and resolving expressions.
 * 
 * @author Jens Halm
 */
public interface ExpressionContext {

	/**
	 * Creates a new Expression instance using the specified String value.
	 * 
	 * @return a new Expression instance
	 */
	function createExpression (expression:String) : Expression;
	
	/**
	 * Adds a VariableResolver to this context.
	 * 
	 * @param the VariableResolver to add to this context
	 */
	function addVariableResolver (resolver:VariableResolver) : void;

	/**
	 * Adds a PropertyResolver to this context.
	 * 
	 * @param the PropertyResolver to add to this context
	 */	
	function addPropertyResolver (resolver:PropertyResolver) : void;
	
	/**
	 * Sets a variable for this context.
	 * 
	 * @param the name of the variable
	 * @param the new value of the variable
	 */
	function setVariable (name:String, value:*) : void;

	/**
	 * Removes a variable from this context.
	 * 
	 * @param the name of the variable
	 */	
	function removeVariable (name:String) : void;
		
}

}