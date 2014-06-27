package overwatch;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

enum OWLogLevel {
	DEBUG;
	INFO;
	WARNING;
	ERROR;
	FATAL;
}

enum OWLogEvent {
	Message(className:String, level:OWLogLevel, value:String, time:Float, ?meta:Array<Dynamic>);
}

abstract EventUtil(OWLogEvent) from OWLogEvent {
	public inline function new(evt:OWLogEvent) {
		this = evt;
	}
	public inline function addMeta(data:Dynamic):EventUtil {
		{
			var array:Array<Dynamic> = this.getParameters()[5];
			if (array == null) {
				this.getParameters()[5] = array = [];
			}
			array.push(data);
		}
		return this;
	}
}
class Log
{
	public static var binding:LogBinding = new DefaultBinding();
	macro public static function debug(input:Expr):Expr {
		
		return buildEvent(input, DEBUG);
	}
	macro public static function info(input:String):Expr {
		return buildEvent(input, INFO);
	}
	macro public static function warn(input:String):Expr {
		return buildEvent(input, WARNING);
	}
	macro public static function error(input:String):Expr {
		return buildEvent(input, ERROR);
	}
	macro public static function fatal(input:String):Expr {
		return buildEvent(input, FATAL);
	}
	#if macro
	static function buildEvent(input:Expr, level:OWLogLevel):Expr {
		
		var name = Context.getLocalClass().get().name;
		var str = ExprTools.toString(input);
			return macro {
				var owLogTime = Date.now().getTime();
				var event = overwatch.OWLogEvent.Message($v { name }, $v { level }, $input, owLogTime );
				overwatch.Log.binding.handleLogEvent(event);
				var util = new overwatch.EventUtil(event);
				util;
			}
	}
	#end
	
}

interface LogBinding {
	function handleLogEvent(evt:OWLogEvent):Void;
}

private class DefaultBinding implements LogBinding {
	public inline function new(){}
	public inline function handleLogEvent(evt:OWLogEvent):Void {
		#if (neko || cpp)
		switch(evt) {
			case Message(className, level, value, time, meta):
				Sys.stdout().writeString(time+"\t" + level + "\t" + className+ " ->\t" + value + "\n");
		}
		#else
		switch(evt) {
			case Message(className, level, value, time, meta):
				trace(value);
		}
		#end
	}
}