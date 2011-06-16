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
 * A VariableResolver is responsible for resolving the first (or sole) part of
 * a value expression. Example: For the expression <code>"${user.age}"</code> a 
 * VariableResolver will be requested to resolve the variable <code>"user"</code>.
 * The <code>age</code> property will then be resolved by a PropertyResolver.
 * 
 * @author Jens Halm
 */
public interface VariableResolver {

	/**
	 * Resolves the variable with the specified name. If the variable cannot be resolved
	 * this method should return undefined.
	 * 
	 * @param variableName the name of the variable to resolve
	 * @return the value associated with the specified variable name or undefined if
	 * the variable cannot be resolved
	 */
	function resolveVariable (variableName:String) : * ;
		
}

}