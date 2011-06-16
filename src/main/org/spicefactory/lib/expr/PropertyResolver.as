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
 * A PropertyResolver is responsible for resolving properties of resolved variables.
 * Example: For the expression <code>"${user.age}"</code> a 
 * VariableResolver will be requested to resolve the variable <code>"user"</code>.
 * The <code>age</code> property will then be resolved by a PropertyResolver.
 * The term <code>property</code> may be interpreted in any way. You could, for example,
 * implement a PropertyResolver for <code>DisplayObjectContainers</code> and use the 
 * "property" name as a parameter for <code>getChildByName</code>.
 * 
 * @author Jens Halm
 */
public interface PropertyResolver {
		
	/**
	 * Resolves the property with the specified name in the given base object.
	 * The term "property" may be loosely interpreted and does not necessarily
	 * have to refer to a real property in the base object. If the property cannot be resolved
	 * this method should return undefined.
	 * 
	 * @param baseObject the object to extract the property from
	 * @param propertyName the name of the property to resolve
	 * @return the resolved property value or undefined if
	 * the variable cannot be resolved
	 */
	function resolveProperty (baseObject:Object, propertyName:String) : * ;
		
}

}