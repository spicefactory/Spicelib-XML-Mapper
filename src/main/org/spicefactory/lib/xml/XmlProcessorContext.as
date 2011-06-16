/*
 * Copyright 2009 the original author or authors.
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

package org.spicefactory.lib.xml {
import org.spicefactory.lib.expr.ExpressionContext;
import org.spicefactory.lib.expr.impl.DefaultExpressionContext;

import flash.system.ApplicationDomain;
import flash.utils.Dictionary;

/**
 * The context for a recursive XML processing operation. Holds the <code>ApplicationDomain</code> and
 * <code>ExpressionContext</code> that the mappers participating in the operation may use.
 * Allows to add namespace which may be used when mapping from object to XML, since the mappers
 * need to know the prefix they should use.
 * 
 * @author Jens Halm
 */
public class XmlProcessorContext {
	
	
	private var _expressionContext:ExpressionContext;
	private var _applicationDomain:ApplicationDomain;
	private var _data:Object;
	
	private var _namespaceMap:Dictionary = new Dictionary();

	private var _errors:Array = new Array();
	

	/**
	 * Creates a new instance.
	 * 
	 * @param expressionContext the expression context containing variable values the participating mappers can use for resolving values
	 * @param domain the ApplicationDomain to use for reflecting on classes
	 * @param data arbitrary data participating mapper may need
	 */
	function XmlProcessorContext (expressionContext:ExpressionContext = null, domain:ApplicationDomain = null, data:Object = null) {
		_expressionContext = (expressionContext == null) ? new DefaultExpressionContext() : expressionContext;
		_applicationDomain = (domain == null) ? ApplicationDomain.currentDomain : domain;
		_data = data;
	}
	
	
	/**
	 * Adds the specified namespace to the context. Will only be considered when mapping from
	 * object to XML not vice-versa. The participating mapper may query the preferred namespace prefix
	 * for objects mapped to XML elements in namespaces.
	 * 
	 * @param ns the namespace to add to this context
	 */
	public function addNamespace (ns:Namespace) : void {
		_namespaceMap[ns.uri] = ns;
	}
	
	/**
	 * @private
	 */
	public function setNamespace (element:XML, uri:String) : void {
		// TODO - may be obsolete
		var ns:Namespace = _namespaceMap[uri];
		if (ns == null) {
			throw new XmlValidationError("Namespace for URI " + uri + " has not been added to this context.");
		}
		element.setNamespace(ns);
	}
	
	/**
	 * Adds the namespace declarations added to this context to the specified element.
	 * May be used for root XML elements after mapping to avoid having namespace declarations
	 * cluttered throughout child elements.
	 * 
	 * @param element the element to add all namespace declarations used in this context to
	 */
	public function addNamespaceDeclarations (element:XML) : void {
		for each (var ns:Namespace in _namespaceMap) {
			element.addNamespace(ns);
		}
	}


	/**
	 * The ApplicationDomain to use when reflecting on objects.
	 */	
	public function get applicationDomain () : ApplicationDomain {
		return _applicationDomain;
	}
	
	/**
	 * The expression context containing variable values the participating mappers can use for resolving values.
	 */
	public function get expressionContext () : ExpressionContext {
		return _expressionContext;
	}
	
	/**
	 * Arbitrary data assigned to this context which may be needed by participating mappers.
	 */
	public function get data () : Object {
		return _data;
	}
	
	/**
	 * Adds an Error to this context. Individual mappers should try not to operate in fail-fast mode,
	 * allowing multiple errors to be collected before an Error is finally thrown.
	 * 
	 * @param error the error to add to this context
	 */
	public function addError (error:Error) : void {
		_errors.push(error);
	}
	
	/**
	 * Returns true when this context contains errors.
	 * 
	 * @return true when this context contains errors
	 */
	public function hasErrors () : Boolean {
		return _errors.length > 0;
	}
	
	/**
	 * All Errors that were already added to this context.
	 */
	public function get errors () : Array {
		return _errors.concat();
	}
	
	
}

}
