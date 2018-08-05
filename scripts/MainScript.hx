package;


import hxp.Log;
import hxp.Haxelib;
import hxp.Path;
import hxp.System;
import sys.FileSystem;


class MainScript {
	
	
	public static function main () {
		
		var arguments = Sys.args ();
		
		var words = [];
		var otherArguments = [];
		var command = "build";
		var scriptFile = null;
		
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
			
			switch (command) {
				
				case "help":
				
					if (words.length > 1) {
						
						Log.error ("Incorrect number of arguments for command 'help'");
						
					}
					
					displayHelp (words.length > 0 ? words[0] : "");
					return;
				
				default:
				
			}
			
			Log.error ("No valid script file found");
			
		}
		
		executeScript (scriptFile, command, words.concat (otherArguments));
		
	}
	
	
	private static function displayHelp (command:String = null):Void {
		
		var commandName = "hxp";
		var defaultLibraryName = "HXP";
		
		var commands = [
			
			"config" => "Display or set command-line configuration values",
			"create" => "Create a new project or extension using templates",
			"clean" => "Clean the specified project and target",
			"update" => "Copy assets for the specified project and target",
			"build" => "Compile and package for the specified project and target",
			"run" => "Install and run for the specified project and target",
			"test" => "Update, build and run in one command",
			"help" => "Show this information",
			"trace" => "Trace output for the specifed project and target",
			"deploy" => "Archive and upload builds",
			"display" => "Display information for the specified project and target",
			"rebuild" => "Recompile native binaries for libraries",
			"install" => "Install a library from haxelib, plus dependencies",
			"remove" => "Remove a library from haxelib",
			"upgrade" => "Upgrade a library from haxelib",
			"setup" => "Setup " + defaultLibraryName + " or a specific platform"
			
		];
		
		var basicCommands = [ "config", "create", "clean", "update", "build", "run", "test", "help" ];
		var additionalCommands = [ "trace", "deploy", "display", "rebuild", "install", "remove", "upgrade", "setup" ];
		
		var isProjectCommand = false, isBuildCommand = false;
		
		if (commands.exists (command)) {
			
			Log.println ("\x1b[1m" + commands.get (command) + "\x1b[0m");
			Log.println ("");
			
		}
		
		switch (command) {
			
			case "setup":
				
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " setup\x1b[0m \x1b[3;37m(target)\x1b[0m \x1b[3;37m[options]\x1b[0m");
			
			case "clean", "update", "build", "run", "test", "display", "deploy", "trace":
				
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " " + command + "\x1b[0m \x1b[3;37m(project)\x1b[0m \x1b[1m<target>\x1b[0m \x1b[3;37m[options]\x1b[0m");
				isProjectCommand = true;
				isBuildCommand = true;
			
			case "create":
				
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " create\x1b[0m \x1b[3;37m(library)\x1b[0m \x1b[1mproject\x1b[0m \x1b[3;37m(directory)\x1b[0m \x1b[3;37m[options]\x1b[0m");
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " create\x1b[0m \x1b[3;37m(library)\x1b[0m \x1b[1mextension\x1b[0m \x1b[3;37m(directory)\x1b[0m \x1b[3;37m[options]\x1b[0m");
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " create\x1b[0m \x1b[3;37m(library)\x1b[0m \x1b[1m<sample>\x1b[0m \x1b[3;37m(directory)\x1b[0m \x1b[3;37m[options]\x1b[0m");
			
			case "rebuild":
				
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " rebuild\x1b[0m \x1b[3;37m(library)\x1b[0m \x1b[3;37m(target)\x1b[0m \x1b[3;37m[options]\x1b[0m");
				isBuildCommand = true;
			
			case "config":
				
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " config\x1b[0m \x1b[3;37m(name)\x1b[0m \x1b[3;37m(value)\x1b[0m \x1b[3;37m[options]\x1b[0m");
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " config remove <name>\x1b[0m \x1b[3;37m[options]\x1b[0m");
			
			case "install", "remove", "upgrade":
				
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " " + command + "\x1b[0m \x1b[3;37m(library)\x1b[0m \x1b[3;37m[options]\x1b[0m");
			
			case "process":
				
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " process <file>\x1b[0m \x1b[3;37m(directory)\x1b[0m \x1b[3;37m[options]\x1b[0m");
			
			default:
				
				displayInfo ();
				
				Log.println ("");
				Log.println (" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + commandName + " <command>\x1b[0m \x1b[3;37m[arguments]\x1b[0m");
				Log.println ("");
				Log.println (" " + Log.accentColor + "Basic Commands:" + Log.resetColor);
				Log.println ("");
				
				for (command in basicCommands) {
					
					Log.println ("  \x1b[1m" + command + "\x1b[0m -- " + commands.get (command));
					
				}
				
				Log.println ("");
				Log.println (" " + Log.accentColor + "Additional Commands:" + Log.resetColor);
				Log.println ("");
				
				for (command in additionalCommands) {
					
					Log.println ("  \x1b[1m" + command + "\x1b[0m -- " + commands.get (command));
					
				}
				
				Log.println ("");
				Log.println ("For additional help, run \x1b[1m" + commandName + " help <command>\x1b[0m");
				
				return;
			
		}
		
		if (isBuildCommand || command == "setup") {
			
			Log.println ("");
			Log.println (" " + Log.accentColor + "Targets:" + Log.resetColor);
			Log.println ("");
			Log.println ("  \x1b[1mair\x1b[0m -- Create an AIR application");
			Log.println ("  \x1b[1mandroid\x1b[0m -- Create an Android application");
			//Log.println ("  \x1b[1mblackberry\x1b[0m -- Create a BlackBerry application");
			Log.println ("  \x1b[1memscripten\x1b[0m -- Create an Emscripten application");
			Log.println ("  \x1b[1mflash\x1b[0m -- Create a Flash SWF application");
			Log.println ("  \x1b[1mhtml5\x1b[0m -- Create an HTML5 application");
			Log.println ("  \x1b[1mios\x1b[0m -- Create an iOS application");
			Log.println ("  \x1b[1mlinux\x1b[0m -- Create a Linux application");
			Log.println ("  \x1b[1mmac\x1b[0m -- Create a macOS application");
			//Log.println ("  \x1b[1mtizen\x1b[0m -- Create a Tizen application");
			Log.println ("  \x1b[1mtvos\x1b[0m -- Create a tvOS application");
			//Log.println ("  \x1b[1mwebos\x1b[0m -- Create a webOS application");
			Log.println ("  \x1b[1mwindows\x1b[0m -- Create a Windows application");
			
			Log.println ("");
			Log.println (" " + Log.accentColor + "Target Aliases:" + Log.resetColor);
			Log.println ("");
			Log.println ("  \x1b[1mcpp\x1b[0m -- Alias for host platform (using \x1b[1m-cpp\x1b[0m)");
			Log.println ("  \x1b[1mneko\x1b[0m -- Alias for host platform (using \x1b[1m-neko\x1b[0m)");
			Log.println ("  \x1b[1mmacos\x1b[0m -- Alias for \x1b[1mmac\x1b[0m");
			Log.println ("  \x1b[1mnodejs\x1b[0m -- Alias for host platform (using \x1b[1m-nodejs\x1b[0m)");
			Log.println ("  \x1b[1mjava\x1b[0m -- Alias for host platform (using \x1b[1m-java\x1b[0m)");
			Log.println ("  \x1b[1mcs\x1b[0m -- Alias for host platform (using \x1b[1m-cs\x1b[0m)");
			Log.println ("  \x1b[1muwp\x1b[0;3m/\x1b[0m\x1b[1mwinjs\x1b[0m -- Alias for \x1b[1mwindows -uwp\x1b[0m");
			// Log.println ("  \x1b[1miphone\x1b[0;3m/\x1b[0m\x1b[1miphoneos\x1b[0m -- \x1b[1mios\x1b[0m");
			// Log.println ("  \x1b[1miphonesim\x1b[0m -- Alias for \x1b[1mios -simulator\x1b[0m");
			// Log.println ("  \x1b[1mappletv\x1b[0;3m/\x1b[0m\x1b[1mappletvos\x1b[0m -- Alias for \x1b[1mtvos\x1b[0m");
			// Log.println ("  \x1b[1mappletvsim\x1b[0m -- Alias for \x1b[1mtvos -simulator\x1b[0m");
			Log.println ("  \x1b[1mrpi\x1b[0;3m/\x1b[0m\x1b[1mraspberrypi\x1b[0m -- Alias for \x1b[1mlinux -rpi\x1b[0m");
			Log.println ("  \x1b[1mwebassembly\x1b[0;3m/\x1b[0m\x1b[1mwasm\x1b[0m -- Alias for \x1b[1memscripten -webassembly\x1b[0m");
			
		}
		
		Log.println ("");
		Log.println (" " + Log.accentColor + "Options:" + Log.resetColor);
		Log.println ("");
		
		if (isBuildCommand) {
			
			Log.println ("  \x1b[1m-D\x1b[0;3mvalue\x1b[0m -- Specify a define to use when processing other commands");
			Log.println ("  \x1b[1m-debug\x1b[0m -- Use debug configuration instead of release");
			Log.println ("  \x1b[1m-final\x1b[0m -- Use final configuration instead of release");
			
		}
		
		Log.println ("  \x1b[1m-v\x1b[0;3m/\x1b[0m\x1b[1m-verbose\x1b[0m -- Print additional information (when available)");
		
		if (isBuildCommand && command != "run" && command != "trace") {
			
			Log.println ("  \x1b[1m-clean\x1b[0m -- Add a \"clean\" action before running the current command");
			
		}
		
		Log.println ("  \x1b[1m-nocolor\x1b[0m -- Disable ANSI format codes in output");
		
		if (command == "run" || command == "test") {
			
			Log.println ("  \x1b[1m-notrace\x1b[0m -- Disable trace output during run or test command");
			
		}
		
		Log.println ("  \x1b[1m-dryrun\x1b[0m -- Execute the requested command without making changes");		
		
		if (isProjectCommand && command != "run" && command != "trace") {
			
			Log.println ("  \x1b[1m-xml\x1b[0m -- Generate XML type information, useful for documentation");
			
		}
		
		if (command == "run" || command == "test") {
			
			Log.println ("  \x1b[1m--\x1b[0;3m/\x1b[0m\x1b[1m-args\x1b[0m ... -- Pass additional arguments at launch");
			
		}
		
		if (isProjectCommand) {
			
			Log.println ("  \x1b[3m(windows|mac|linux)\x1b[0m \x1b[1m-cpp\x1b[0m -- Build with C++ (default behavior)");
			Log.println ("  \x1b[3m(windows|mac|linux)\x1b[0m \x1b[1m-neko\x1b[0m -- Build with Neko instead of C++");
			Log.println ("  \x1b[3m(windows|mac|ios|android)\x1b[0m \x1b[1m-air\x1b[0m -- Build with AIR instead of C++");
			
		}
		
		if (isBuildCommand) {
			
			Log.println ("  \x1b[3m(windows|mac|linux|android)\x1b[0m \x1b[1m-static\x1b[0m -- Compile as a static C++ executable");
			Log.println ("  \x1b[3m(windows|mac|linux)\x1b[0m \x1b[1m-32\x1b[0m -- Compile for 32-bit instead of the OS default");
			Log.println ("  \x1b[3m(windows|mac|linux)\x1b[0m \x1b[1m-64\x1b[0m -- Compile for 64-bit instead of the OS default");
			Log.println ("  \x1b[3m(ios|android)\x1b[0m \x1b[1m-armv6\x1b[0m -- Compile for ARMv6 instead of the OS defaults");
			Log.println ("  \x1b[3m(ios|android)\x1b[0m \x1b[1m-armv7\x1b[0m -- Compile for ARMv7 instead of the OS defaults");
			Log.println ("  \x1b[3m(ios|android)\x1b[0m \x1b[1m-armv7s\x1b[0m -- Compile for ARMv7s instead of the OS defaults");
			Log.println ("  \x1b[3m(ios)\x1b[0m \x1b[1m-arm64\x1b[0m -- Compile for ARM64 instead of the OS defaults");
			
		}
		
		if (isProjectCommand) {
			
			Log.println ("  \x1b[3m(ios)\x1b[0m \x1b[1m-archive\x1b[0m -- Generate iOS archive during build");
			
		}
		
		if (isProjectCommand) {
			
			if (command != "run" && command != "trace") {
				
				Log.println ("  \x1b[3m(ios)\x1b[0m \x1b[1m-xcode\x1b[0m -- Launch the generated Xcode project");
				
			}
			
			//Log.println ("  \x1b[3m(ios|blackberry|tizen|tvos|webos)\x1b[0m \x1b[1m-simulator\x1b[0m -- Target the device simulator");
			Log.println ("  \x1b[3m(ios|tvos)\x1b[0m \x1b[1m-simulator\x1b[0m -- Target the device simulator");
			Log.println ("  \x1b[3m(ios)\x1b[0m \x1b[1m-simulator -ipad\x1b[0m -- Build/test for the iPad Simulator");
			Log.println ("  \x1b[3m(android)\x1b[0m \x1b[1m-emulator\x1b[0m -- Target the device emulator");
			Log.println ("  \x1b[3m(flash)\x1b[0m \x1b[1m-web\x1b[0m -- Test Flash target using a web template");
			Log.println ("  \x1b[3m(air)\x1b[0m \x1b[1m-ios\x1b[0m -- Target iOS instead of AIR desktop");
			Log.println ("  \x1b[3m(air)\x1b[0m \x1b[1m-android\x1b[0m -- Target Android instead of AIR desktop");
			
			if (command == "run" || command == "test") {
				
				Log.println ("  \x1b[3m(emscripten|html5|flash)\x1b[0m \x1b[1m-nolaunch\x1b[0m -- Begin test server without launching");
				//Log.println ("  \x1b[3m(html5)\x1b[0m \x1b[1m-minify\x1b[0m -- Minify output using the Google Closure compiler");
				Log.println ("  \x1b[3m(emscripten|html5)\x1b[0m \x1b[1m-minify\x1b[0m -- Minify application file");
				//Log.println ("  \x1b[3m(html5)\x1b[0m \x1b[1m-minify -yui\x1b[0m -- Minify output using the YUI compressor");
				Log.println ("  \x1b[3m(emscripten|html5|flash)\x1b[0m \x1b[1m--port=\x1b[0;3mvalue\x1b[0m -- Set port for test server");
				
			}
			
			if (command != "run" && command != "trace") {
				
				Log.println ("  \x1b[3m(emscripten)\x1b[0m \x1b[1m-webassembly\x1b[0m -- Compile for WebAssembly instead of asm.js");
				
			}
			
			Log.println ("");
			Log.println (" " + Log.accentColor + "Experimental Options:" + Log.resetColor);
			Log.println ("");
			Log.println ("  \x1b[1m-watch\x1b[0m -- Execute the current command when the source changes");
			Log.println ("  \x1b[3m(linux)\x1b[0m \x1b[1m-rpi\x1b[0m -- Build for Raspberry Pi");
			Log.println ("  \x1b[3m(windows|mac|linux)\x1b[0m \x1b[1m-java\x1b[0m -- Build for Java instead of C++");
			Log.println ("  \x1b[3m(windows|mac|linux)\x1b[0m \x1b[1m-nodejs\x1b[0m -- Build for Node.js instead of C++");
			Log.println ("  \x1b[3m(windows|mac|linux)\x1b[0m \x1b[1m-cs\x1b[0m -- Build for C# instead of C++");
			Log.println ("  \x1b[3m(windows)\x1b[0m \x1b[1m-winjs\x1b[0m -- Build for WinJS instead of C++ (implies UWP)");
			Log.println ("  \x1b[3m(windows)\x1b[0m \x1b[1m-uwp\x1b[0m -- Build for Universal Windows Platform");
			
			
			if (command != "run" && command != "trace") {
				
				Log.println ("");
				Log.println (" " + Log.accentColor + "Project Overrides:" + Log.resetColor);
				Log.println ("");
				Log.println ("  \x1b[1m--app-\x1b[0;3moption=value\x1b[0m -- Override a project <app/> setting");
				Log.println ("  \x1b[1m--meta-\x1b[0;3moption=value\x1b[0m -- Override a project <meta/> setting");
				Log.println ("  \x1b[1m--window-\x1b[0;3moption=value\x1b[0m -- Override a project <window/> setting");
				Log.println ("  \x1b[1m--dependency\x1b[0;3m=value\x1b[0m -- Add an additional <dependency/> value");
				Log.println ("  \x1b[1m--haxedef\x1b[0;3m=value\x1b[0m -- Add an additional <haxedef/> value");
				Log.println ("  \x1b[1m--haxeflag\x1b[0;3m=value\x1b[0m -- Add an additional <haxeflag/> value");
				Log.println ("  \x1b[1m--haxelib\x1b[0;3m=value\x1b[0m -- Add an additional <haxelib/> value");
				Log.println ("  \x1b[1m--haxelib-\x1b[0;3mname=value\x1b[0m -- Override the path to a haxelib");
				Log.println ("  \x1b[1m--source\x1b[0;3m=value\x1b[0m -- Add an additional <source/> value");
				Log.println ("  \x1b[1m--certificate-\x1b[0;3moption=value\x1b[0m -- Override a project <certificate/> setting");
				
			}
			
		}
		
	}
	
	
	private static function displayInfo (showHint:Bool = false):Void {
		
		if (System.hostPlatform == WINDOWS) {
			
			Log.println ("");
			
		}
		
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
		
		if (showHint) {
			
			var commandName = "hxp";
			Log.println ("Use \x1b[3m" + commandName + " setup\x1b[0m to configure platforms or \x1b[3m" + commandName + " help\x1b[0m for more commands");
			
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
		var runArgs = [ className, command == "" ? "build" : command ];
		runArgs = runArgs.concat (arguments);
		
		if (Log.verbose) runArgs.push ("-verbose");
		if (!Log.enableColor) runArgs.push ("-nocolor");
		// if (!traceEnabled) runArgs.push ("-notrace");
		
		// if (additionalArguments.length > 0) {
			
		// 	runArgs.push ("-args");
		// 	runArgs = runArgs.concat (additionalArguments);
			
		// }
		
		System.runScript (path, buildArgs, runArgs, dir);
		
	}
	
	
	private static function getToolsVersion (version:String = null):String {
		
		// if (version == null) version = this.version;
		// return version;
		return "0.0.0";
		
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