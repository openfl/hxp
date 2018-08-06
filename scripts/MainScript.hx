package;


import hxp.Log;
import hxp.Haxelib;
import hxp.Path;
import hxp.System;
import sys.FileSystem;


class MainScript {
	
	
	private static var version:String;
	
	
	public static function main () {
		
		var arguments = Sys.args ();
		
		var words = [];
		var otherArguments = [];
		var command = "build";
		var scriptFile = null;
		
		version = Haxelib.getPathVersion ("");
		if (version == null) version = "0.0.0";
		
		handleLastArgument (arguments);
		
		for (argument in arguments) {
			
			if (argument == "-v" || argument == "-verbose") {
				
				Log.verbose = true;
				
			} else if (argument == "-nocolor") {
				
				Log.enableColor = false;
				
			} else if (!StringTools.startsWith (argument, "-")) {
				
				words.push (argument);
				
			} else {
				
				otherArguments.push (argument);
				
			}
			
		}
		
		if (words.length > 0) {
			
			if (words[0].indexOf (".") > -1) {
				
				command = "build";
				scriptFile = words.shift ();
				
			} else {
				
				command = words.shift ();
				
			}
			
		}
		
		// TODO: Handle "config" or other non-script commands
		
		if (scriptFile == null) {
			
			if (words.length > 0 && words[0].indexOf (".") > -1) {
				
				scriptFile = words.shift ();
				
			} else {
				
				scriptFile = findScriptFile (Sys.getCwd (), command);
				
			}
			
		}
		
		if (scriptFile == null) {
			
			if (command == "help" || otherArguments.indexOf ("-h") != -1 || otherArguments.indexOf ("-help") != -1 || otherArguments.indexOf ("--help") != -1) {
				
				displayHelp ();
				return;
				
			} else {
				
				if (Log.verbose) displayInfo ();
				Log.error ("No valid script file found");
				
			}
			
		}
		
		if (Log.verbose) displayInfo ();
		executeScript (scriptFile, command, words.concat (otherArguments));
		
	}
	
	
	private static function displayHelp (command:String = null):Void {
		
		displayInfo (true);
		
		Log.println ("");
		Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1mhxp\x1b[0m \x1b[3;37m(command) (script)\x1b[0m \x1b[3;37m[arguments...]\x1b[0m");
		
		Log.println ("");
		Log.println (" " + Log.accentColor + "Flags:" + Log.resetColor);
		Log.println ("");
		
		Log.println ("  \x1b[1m-v\x1b[0;3m/\x1b[0m\x1b[1m-verbose\x1b[0m -- Print additional information (when available)");
		Log.println ("  \x1b[1m-h\x1b[0m/\x1b[0m\x1b[1m-help\x1b[0m -- Display help information (if available)");
		Log.println ("  \x1b[1m-nocolor\x1b[0m -- Disable ANSI format codes in output");
		
	}
	
	
	private static function displayInfo (showLogo:Bool = false, showHint:Bool = false):Void {
		
		if (System.hostPlatform == WINDOWS) {
			
			Log.println ("");
			
		}
		
		if (showLogo) {
			
			Log.println ("\x1b[36;1m ,dPb,                              \x1b[0m");
			Log.println ("\x1b[36;1m IP`Yb                              \x1b[0m");
			Log.println ("\x1b[36;1m I8 8I                              \x1b[0m");
			Log.println ("\x1b[36;1m I8 8'                              \x1b[0m");
			Log.println ("\x1b[36;1m I8d8Pgg,       ,gg,   ,gg gg,gggg,   \x1b[0m");
			Log.println ("\x1b[36;1m I8dP\" \"8I    d8\"\"8b,dP\"  I8P\"  \"Yb  \x1b[0m");
			Log.println ("\x1b[36;1m I8P    I8   dP   ,88\"    I8'    ,8i \x1b[0m");
			Log.println ("\x1b[36;1m,d8     I8,,dP  ,dP\"Y8,  ,I8 _  ,d8' \x1b[0m");
			Log.println ("\x1b[36;1md8P     `Y88\"  dP\"   \"Y88PI8 YY88P\x1b[0m");
			Log.println ("\x1b[36;1m                          I8         \x1b[0m");
			Log.println ("\x1b[36;1m                          I8         \x1b[0m");
			Log.println ("");
			Log.println ("\x1b[1mHXP Command-Line Tools\x1b[0;1m (" + getToolsVersion () + ")\x1b[0m");
			
		} else {
			
			Log.println ("\x1b[36;1mHXP Command-Line Tools (" + getToolsVersion () + ")\x1b[0m");
			
		}
		
		if (showHint) {
			
			var commandName = "hxp";
			Log.println ("Use \x1b[3mhxp help\x1b[0m for instructions");
			
		}
		
	}
	
	
	private static function executeScript (path:String, command:String, arguments:Array<String>):Void {
		
		Log.info ("", Log.accentColor + "Executing script: " + path + Log.resetColor);
		
		var dir = Path.directory (path);
		var file = Path.withoutDirectory (path);
		var className = Path.withoutExtension (file);
		className = className.substr (0, 1).toUpperCase () + className.substr (1);
		
		var version = "0.0.0";
		var buildArgs = [ className, "-main", "hxp.Script", "-D", "hxp="+ version, "-cp", Path.combine (Haxelib.getPath (new Haxelib ("hxp")), "src") ];
		var runArgs = [ command == "" ? "build" : command ];
		runArgs = runArgs.concat (arguments);
		
		if (Log.verbose) runArgs.push ("-verbose");
		if (!Log.enableColor) runArgs.push ("-nocolor");
		
		runArgs.push (className);
		runArgs.push (Sys.getCwd ());
		
		// if (!traceEnabled) runArgs.push ("-notrace");
		
		// if (additionalArguments.length > 0) {
			
		// 	runArgs.push ("-args");
		// 	runArgs = runArgs.concat (additionalArguments);
			
		// }
		
		System.runScript (path, buildArgs, runArgs, dir);
		
	}
	
	
	private static function getToolsVersion ():String {
		
		return version;
		
	}
	
	
	private static function handleLastArgument (arguments:Array<String>):Void {
		
		var runFromHaxelib = false;
		
		if (arguments.length > 0) {
			
			// When the command-line tools are called from haxelib, 
			// the last argument is the project directory and the
			// path to Lime is the current working directory 
			
			var lastArgument = "";
			
			for (i in 0...arguments.length) {
				
				lastArgument = arguments.pop ();
				if (lastArgument.length > 0) break;
				
			}
			
			lastArgument = new Path (lastArgument).toString ();
			var isRootDirectory = false;
			
			if (System.hostPlatform == WINDOWS) {
				
				isRootDirectory = (lastArgument.length == 3 && lastArgument.charAt (1) == ":" && (lastArgument.charAt (2) == "/" || lastArgument.charAt (2) == "\\"));
				
			} else {
				
				isRootDirectory = (lastArgument == "/");
				
			}
			
			if (FileSystem.exists (lastArgument) && FileSystem.isDirectory (lastArgument)) {
				
				// Haxelib.setOverridePath (new Haxelib ("lime-tools"), Path.combine (Sys.getCwd (), "tools"));
				
				Sys.setCwd (lastArgument);
				runFromHaxelib = true;
				
			} else if (!isRootDirectory) {
				
				arguments.push (lastArgument);
				
			}
			
			// Haxelib.workingDirectory = Sys.getCwd ();
			
		}
		
		if (!runFromHaxelib) {
			
			// TODO
			
			// 	var path = null;
				
			// 	if (FileSystem.exists ("tools.n")) {
					
			// 		path = Path.combine (Sys.getCwd (), "../");
					
			// 	} else if (FileSystem.exists ("run.n")) {
					
			// 		path = Sys.getCwd ();
					
			// 	} else {
					
			// 		Log.error ("Could not run Lime tools from this directory");
					
			// 	}
				
			// 	Haxelib.setOverridePath (new Haxelib ("lime"), path);
			// 	Haxelib.setOverridePath (new Haxelib ("lime-tools"), Path.combine (path, "tools"));
			
		}
		
	}
	
	
	private static function findScriptFile (path:String, command:String = null):String {
		
		if (command != null && FileSystem.exists (Path.combine (path, command + ".hxp"))) {
			
			return Path.combine (path, command + ".hxp");
			
		} else if (command != null && FileSystem.exists (Path.combine (path, command + ".hx"))) {
			
			return Path.combine (path, command + ".hx");
			
		} else if (FileSystem.exists (Path.combine (path, "script.hxp"))) {
			
			return Path.combine (path, "script.hxp");
			
		} else if (FileSystem.exists (Path.combine (path, "script.lime"))) {
			
			return Path.combine (path, "script.lime");
			
		} else if (FileSystem.exists (Path.combine (path, "project.hxp"))) {
			
			return Path.combine (path, "project.hxp");
			
		} else if (FileSystem.exists (Path.combine (path, "project.hx"))) {
			
			return Path.combine (path, "project.hx");
			
		} else {
			
			var files = FileSystem.readDirectory (path);
			var matches = new Map<String, Array<String>> ();
			matches.set ("hxp", []);
			matches.set ("hx", []);
			
			for (file in files) {
				
				var path = Path.combine (path, file);
				
				if (FileSystem.exists (path) && !FileSystem.isDirectory (path)) {
					
					var extension = Path.extension (file);
					
					if (matches.exists (extension)) {
						
						matches.get (extension).push (path);
						
					}
					
				}
				
			}
			
			if (matches.get ("hxp").length > 0) {
				
				return matches.get ("hxp")[0];
				
			}
			
			if (matches.get ("hx").length == 1) {
				
				return matches.get ("hx")[0];
				
			} else if (matches.get ("hx").length > 1) {
				
				Log.error ("Please use 'hxp filename.hx' to specify which script you wish to run");
				
			}
			
		}
		
		return null;
		
	}
	
	
}