package {

import org.spicefactory.lib.expr.ExpressionTest;
import org.spicefactory.lib.xml.MetadataMapperTest;
import org.spicefactory.lib.xml.PropertyMapperTest;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class XmlMapperSuite {

	public var metadata:MetadataMapperTest;
	public var property:PropertyMapperTest;
	public var expressions:ExpressionTest;
	
}
}
