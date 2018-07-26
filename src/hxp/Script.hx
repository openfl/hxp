package hxp;


import haxe.io.Path;
// import haxe.Unserializer;
// import hxp.project.Haxelib;
// import hxp.helpers.HaxelibHelper;
import hxp.helpers.LogHelper;
// import hxp.helpers.PathHelper;
// import sys.io.File;
import sys.FileSystem;


class Script {
	
	
	@:noCompletion private static var additionalArguments = new Array<String> ();
	@:noCompletion private static var targetFlags = new Map<String, String> ();
	@:noCompletion private static var traceEnabled:Bool = true;
	
	
	public function new () {
		
		
		
	}
	
	
	public static function main () {
		
		var arguments = Sys.args ();
		var additionalArguments = [];
		var catchArguments = false;
		var className = "";
		// var command = "";
		var words = [];
		
		for (argument in arguments) {
			
			var equals = argument.indexOf ("=");
			
			if (catchArguments) {
				
				additionalArguments.push (argument);
				
			} else if (argument == "-v" || argument == "-verbose") {
				
				LogHelper.verbose = true;
				
			} else if (argument == "-args") {
				
				catchArguments = true;
				
			} else if (argument == "-notrace") {
				
				traceEnabled = false;
				
			} else if (argument == "-debug") {
				
				//debug = true;
				
			} else if (argument == "-nocolor") {
				
				LogHelper.enableColor = false;
				
			} else if (className.length == 0) {
				
				className = argument;
				
			// } else if (command.length == 0) {
				
			// 	command = argument;
				
			} else {
				
				words.push (argument);
				
			}
			
		}
		
		if (className != null) {
			
			try {
				
				var classRef = Type.resolveClass (className);
				if (classRef == null) throw "Cannot find class name \"" + className + "\"";
				
				var script = Type.createInstance (classRef, []);
				// platform.traceEnabled = traceEnabled;
				// platform.execute (additionalArguments);
				
			} catch (e:Dynamic) {
				
				LogHelper.error (e);
				
			}
			
		}
		
	}
	
	
}