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
import org.spicefactory.lib.xml.NamingStrategy;

/**
 * Default implementation of the NamingStrategy interface, transforming camel-case property names
 * to XML names with dashes. The property name <code>objectCount</code> for example would be transformed
 * to <code>object-count</code>.
 * 
 * @author Jens Halm
 */
public class DefaultNamingStrategy implements NamingStrategy {

	/**
	 * @inheritDoc
	 */
	public function toXmlName (actionScriptName:String) : String {
		var xmlName:String = "";
		for (var i:int = 0; i < actionScriptName.length; i++) {
			var c:String = actionScriptName.charAt(i);
			if (c >= "A" && c <= "Z") {
				if (i > 0) xmlName += "-";
				xmlName += c.toLowerCase();
			}
			else {
				xmlName += c;
			}
		}
		return xmlName;
	}
	
}
}
