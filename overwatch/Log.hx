package overwatch;
import haxe.PosInfos;

enum OWLogLevel {
	DEBUG;
	INFO;
	WARNING;
	ERROR;
	FATAL;
}

class OWLogEvent {
	public var sessionIndex:Int;
	public var timeStamp:Float;
	public var className:String;
	public var message:String;
	public var level:OWLogLevel;
	public var meta:Null<Array<Dynamic>>;
	public function new() {
	}
	public inline function toString():String {
		return sessionIndex + "\t" + DateTools.format(Date.fromTime(timeStamp), Log.dateFormat) + "\t" + level + "\t" + className+ " ->\t" + message;
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

class Log
{
	public static var dateFormat:String = "%H:%M:%S";
	static var sessionIndex:Int = 0;
	static inline function buildEvent(input:String, level:OWLogLevel, ?pos:PosInfos):OWLogEvent {
		var name:String = pos.className;
		var owEvent = new OWLogEvent();
		owEvent.className = name;
		owEvent.level = level;
		owEvent.timeStamp = Date.now().getTime();
		owEvent.sessionIndex = sessionIndex++;
		owEvent.message = input;
		binding.handleLogEvent(owEvent);
		return owEvent;
	}
	
	public static var binding:LogBinding = new DefaultBinding();
	public static inline function debug(input:String):OWLogEvent {
		return buildEvent(input, DEBUG);
	}
	public static inline function info(input:String):OWLogEvent {
		return buildEvent(input, INFO);
	}
	public static inline function warn(input:String):OWLogEvent {
		return buildEvent(input, WARNING);
	}
	public static inline function error(input:String):OWLogEvent {
		return buildEvent(input, ERROR);
	}
	public static inline function fatal(input:String):OWLogEvent {
		return buildEvent(input, FATAL);
	}
	
}

interface LogBinding {
	function handleLogEvent(evt:OWLogEvent):Void;
}

private class DefaultBinding implements LogBinding {
	public inline function new(){}
	public inline function handleLogEvent(evt:OWLogEvent):Void {
		#if (neko || cpp)
		Sys.stdout().writeString(evt + "\n");
		#else
		#end
	}
}