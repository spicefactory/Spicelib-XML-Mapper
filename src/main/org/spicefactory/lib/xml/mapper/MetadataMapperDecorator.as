/*
 * Copyright 2010 the original author or authors.
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

package org.spicefactory.lib.xml.mapper {

/**
 * The core extension interface to create metadata tags for custom XML to Object mappings.
 * Such a metadata tag can be placed on any property of a mapped class. The implementation
 * will be invoked once for each occurence of that tag on each mapped class.
 * 
 * @author Jens Halm
 */
public interface MetadataMapperDecorator {
	
	
	/**
	 * Method to be invoked by the framework for each occurence of a metadata tag on each mapped class.
	 * 
	 * It allows to validate and process the attributes of that tag and to modifiy the specified mapper
	 * builder accordingly. All existing builtin metadata tags like <code>[Attribute]</code> or <code>[ChoiceId]</code>
	 * implement this interface, too.
	 * 
	 * @param builder the builder that can be modified for the mapping of the property the metadata tag was placed upon
	 */
	function decorate (builder:MetadataMapperBuilder) : void;
	
	
}
}
