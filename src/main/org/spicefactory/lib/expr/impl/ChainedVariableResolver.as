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
	
import org.spicefactory.lib.expr.VariableResolver;
	

/**
 * VariableResolver implementation that chains multiple VariableResolvers.
 * For resolving variables this implementation will delegate the task to each 
 * of the chained VariableResolver instances until one of them is able to resolve
 * the variable. The order of execution corresponds to the order in which VariableResolver
 * instances were added.
 * 
 * @author Jens Halm
 */
public class ChainedVariableResolver implements VariableResolver {
	
	
	private var resolvers:Array;
	
	
	/**
	 * Creates a new instance.
	 */
	public function ChainedVariableResolver () {
		resolvers = new Array();
	}
	
	
	/**
	 * Adds the specified VariableResolver instance to the internal chain.
	 * 
	 * @param resolver the resolver to add to the internal chain.
	 */
	public function addResolver (resolver:VariableResolver) : void {
		resolvers.unshift(resolver);
	}
	
	/**
	 * @inheritDoc
	 */
	public function resolveVariable (variableName : String) : * {
		for each (var resolver:VariableResolver in resolvers) {
			var value:* = resolver.resolveVariable(variableName);
			if (value != undefined) {
				return value;
			}
		}
		return undefined;
	}	
	
	
}

}