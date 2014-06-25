package overwatch.macro;
import haxe.macro.Context;
import haxe.macro.Type;

/**
 * ...
 * @author Andreas Rønning
 */
class Builder
{
	#if macro
	public static function build():Type {
		trace("Genericbuild");
		var t = Context.getLocalType();
		var typeName:String = "";
		var classType:ClassType;
		switch(t) {
			case TInst(t, p):
				classType = t.get();
				switch(p[0]) {
					case TInst(t2, p2):
						typeName = ""+t2;
					default:
				}
			default:
		}
		
		for (i in classType.fields.get()) {
			switch(i) {
				case _ => f:
					if (f.name == "name") {
					}
			}
		}
		
		return t;
	}
	#end
	
}