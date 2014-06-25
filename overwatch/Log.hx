package overwatch;

/**
 * ...
 * @author Andreas Rønning
 */
@:genericBuild(overwatch.macro.Builder.build()) class Logger<T> {
	var name:String;
	public function new() {
		
	}
	public inline function debug(data:Dynamic):Void {
		Log.debug(name+": "+data);
	}
}
@:allow(overwatch)
class Log
{
	public static var binding:LogBinding = new DefaultBinding();
	static inline function debug(input:String):Void {
		binding.print(input);
	}
	
}
interface LogBinding {
	function print(str:String):Void;
}
private class DefaultBinding implements LogBinding {
	public inline function new(){}
	public inline function print(str:String):Void {
		Sys.stdout().writeString(str + "\n");
	}
}