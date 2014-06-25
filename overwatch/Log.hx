package overwatch;
import haxe.macro.Expr;

/**
 * ...
 * @author Andreas Rønning
 */

@:remove @:genericBuild(overwatch.macro.Builder.build()) abstract Logger<T>(Void) {
	//var name:String;
	public inline function new() {
		
	}
	macro public inline function debug(input:String):Expr {
		Log.debug(name, input);
	}
	macro public inline function info(input:String):Expr {
		Log.info(name, input);
	}
	macro public inline function warn(input:String):Expr {
		Log.warn(name, input);
	}
	macro public inline function error(input:String):Expr {
		Log.error(name, input);
	}
	macro public inline function fatal(input:String):Expr {
		Log.fatal(name, input);
	}
}

enum LogLevel {
	DEBUG;
	INFO;
	WARNING;
	ERROR;
	FATAL;
}

@:allow(overwatch)
class Log
{
	static var binding:LogBinding = new DefaultBinding();
	public static function bind(b:LogBinding) {
		if (b == null) throw "Null binding not permitted";
		binding = b;
	}
	static inline function debug(src:String, input:String):Void {
		binding.print(src, DEBUG, input);
	}
	static inline function info(src:String, input:String):Void {
		binding.print(src, INFO, input);
	}
	static inline function warn(src:String, input:String):Void {
		binding.print(src, WARNING, input);
	}
	static inline function error(src:String, input:String):Void {
		binding.print(src, ERROR, input);
	}
	static inline function fatal(src:String, input:String):Void {
		binding.print(src, FATAL, input);
	}
	
}

interface LogBinding {
	function print(source:String, level:LogLevel, str:String):Void;
}

private class DefaultBinding implements LogBinding {
	public inline function new(){}
	public inline function print(source:String, level:LogLevel, str:String):Void {
		#if (neko || cpp)
		Sys.stdout().writeString(level + "\t" + source+ " ->\t" + str + "\n");
		#else
		trace(str);
		#end
	}
}