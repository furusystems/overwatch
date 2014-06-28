package overwatch;
import haxe.PosInfos;

@:enum
abstract OWLogLevel(Int) {
	var DEBUG = 0;
	var INFO = 1;
	var WARNING = 2;
	var ERROR = 3;
	var FATAL = 4;
}

private class OWLogEvent {
	public var sessionIndex:Int;
	public var timeStamp:Float;
	public var loggerName:String;
	public var message:String;
	public var level:OWLogLevel;
	public var meta:Null<Array<Dynamic>>;
	public function new() {
	}
	public inline function toString():String {
		return DateTools.format(Date.fromTime(timeStamp), Log.dateFormat) + " " + levelToString(level) + "\t" + loggerName+ " :\t" + message;
	}
	function levelToString(level:OWLogLevel):String {
		switch(level) {
			case DEBUG:
				return "DEBUG  ";
			case INFO:
				return "INFO   ";
			case WARNING:
				return "WARNING";
			case ERROR:
				return "ERROR  ";
			case FATAL:
				return "FATAL  ";
		}
	}
	public inline function addMeta(data:Dynamic):OWLogEvent {
		if (meta == null) meta = [data];
		else meta.push(data);
		return this;
	}
	public inline function disposeMeta():OWLogEvent {
		meta = null;
		return this;
	}
}

class Logger {
	var name:String;
	public var enabled:Bool;
	public function new(owner:Dynamic) { 
		enabled = true;
		if (Std.is(owner, String)) {
			this.name = owner; 
		}else {
			this.name = Type.getClassName(owner);
		}
	}
	
	inline function buildEvent(input:String, level:OWLogLevel):OWLogEvent {
		var owEvent = new OWLogEvent();
		owEvent.loggerName = name;
		owEvent.level = level;
		owEvent.timeStamp = Date.now().getTime();
		owEvent.sessionIndex = Log.sessionIndex++;
		owEvent.message = input;
		if (enabled) Log.binding.handleLogEvent(owEvent);
		return owEvent;
	}
	
	public inline function debug(input:String):OWLogEvent {
		return buildEvent(input, OWLogLevel.DEBUG);
	}
	public inline function info(input:String):OWLogEvent {
		return buildEvent(input, OWLogLevel.INFO);
	}
	public inline function warn(input:String):OWLogEvent {
		return buildEvent(input, OWLogLevel.WARNING);
	}
	public inline function error(input:String):OWLogEvent {
		return buildEvent(input, OWLogLevel.ERROR);
	}
	public inline function fatal(input:String):OWLogEvent {
		return buildEvent(input, OWLogLevel.FATAL);
	}
}


@:allow(overwatch)
class Log
{
	static var sessionIndex:Int = 0;
	public static var dateFormat:String = "%H:%M:%S";
	public static var binding:LogBinding = new DefaultBinding();
	public static inline function println(str:String):Void {
		#if flash
			#if (fdb || native_trace)
				untyped #if flash9 __global__["trace"] #else __trace__ #end(str);
			#else
				untyped flash.Boot.__trace(str);
			#end
		#elseif (neko || cpp)
			untyped {
				Sys.stdout().writeString(str+"\n");
			}
		#elseif js
			untyped console.log(str);
		#elseif php
			php.Lib.println(str);
		#elseif (cs || java)
			#if cs
			cs.system.Console.WriteLine(str);
			#elseif java
			untyped __java__("java.lang.System.out.println(str)");
			#end
		#end
	}
}

interface LogBinding {
	function handleLogEvent(evt:OWLogEvent):Void;
}

private class DefaultBinding implements LogBinding {
	public inline function new() {
	}
	public function handleLogEvent(evt:OWLogEvent):Void {
		Log.println(evt.toString());
	}
}