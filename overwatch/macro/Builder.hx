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
		switch(t) {
			case TInst(t, p):
				switch(p[0]) {
					case TInst(t2, p2):
						typeName = ""+t2;
					default:
				}
			default:
		}
		
		var fields = Context.getBuildFields();
		trace(t);
		
		return t;
	}
	#end
	
}