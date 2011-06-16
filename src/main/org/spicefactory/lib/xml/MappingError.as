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
import org.spicefactory.lib.errors.CompoundError;

/**
 * Error thrown when an XML-to-Object mapping operation failed.
 * 
 * @author Jens Halm
 */
public class MappingError extends CompoundError {

	/**
	 * Creates a new instance.
	 * 
	 * @param message the error message
	 * @param causes one or more Error instances that caused this Error
	 */
	function MappingError (message:String, causes:Array) {
		super(message, causes);
	}
	
}
}
