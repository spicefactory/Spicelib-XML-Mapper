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
import flash.utils.Dictionary;

import org.spicefactory.lib.expr.VariableResolver;

/**
 * The default VariableResolver implementation mapping variable names to values
 * with an internal Dictionary. Values for all variables must be explicitly set 
 * with this VariableResolver.
 * 
 * @author Jens Halm
 */
public class DefaultVariableResolver implements VariableResolver {
	
	
	private var variables:Dictionary;
	
	
	/**
	 * Creates a new instance.
	 */
	public function DefaultVariableResolver () {
		variables = new Dictionary();
	}
	
	
	/**
	 * Sets the variable with the specified name to a new value.
	 * 
	 * @param name the name of the variable
	 * @param value the new value of the variable
	 */
	public function setVariable (name:String, value:*) : void {
		variables[name] = value;
	}
	
	/**
	 * Removes the variable with the specified name from this resolver.
	 * 
	 * @param name the name of the variable to remove
	 */
	public function removeVariable (name:String) : void {
		delete variables[name];
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function resolveVariable (variableName : String) : * {
		return variables[variableName];
	}
	
	
	
}

}