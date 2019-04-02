package;

import hxp.Log;
import hxp.Haxelib;
import hxp.Path;
import hxp.System;
import sys.io.File;
import sys.FileSystem;

class MainScript
{
	private static var version:String;

	public static function main()
	{
		var arguments = Sys.args();

		var words = [];
		var otherArguments = [];
		var command = null;
		var scriptFile = null;

		version = Haxelib.getPathVersion("");
		if (version == null) version = "0.0.0";

		handleLastArgument(arguments);

		for (argument in arguments)
		{
			if (argument == "-v" || argument == "-verbose")
			{
				Log.verbose = true;
			}
			else if (argument == "-nocolor")
			{
				Log.enableColor = false;
			}
			else if (argument == "--install-hxp-alias")
			{
				installHXPAlias();
				otherArguments.push(argument);
			}
			else if (!StringTools.startsWith(argument, "-"))
			{
				words.push(argument);
			}
			else
			{
				otherArguments.push(argument);
			}
		}

		if (words.length > 0)
		{
			var firstArgument = words.shift();
			var fileExists = false;

			try
			{
				if (FileSystem.exists(firstArgument)) fileExists = true;
			}
			catch (e:Dynamic) {}

			if (fileExists)
			{
				if (FileSystem.isDirectory(firstArgument))
				{
					scriptFile = findScriptFile(firstArgument);
				}
				else
				{
					scriptFile = firstArgument;
				}

				if (scriptFile != null)
				{
					if (words.length > 0)
					{
						command = words.shift();
					}
				}
			}

			if (scriptFile == null) command = firstArgument;
		}

		if (scriptFile == null)
		{
			scriptFile = findScriptFile(Sys.getCwd(), command);
		}

		if (scriptFile == null)
		{
			if (command == "help"
				|| otherArguments.indexOf("-h") != -1
				|| otherArguments.indexOf("-help") != -1
				|| otherArguments.indexOf("--help") != -1)
			{
				displayHelp();
				return;
			}
			else if (otherArguments.indexOf("--install-hxp-alias") > -1)
			{
				return;
			}
			else
			{
				if (Log.verbose) displayInfo();
				Log.error("No valid script file found");
			}
		}

		if (Log.verbose) displayInfo();
		executeScript(scriptFile, command, words.concat(otherArguments));
	}

	private static function displayHelp(command:String = null):Void
	{
		displayInfo(true);

		Log.println("");
		Log.println(" "
			+ Log.accentColor
			+ "Usage:\x1b[0m \x1b[1mhxp\x1b[0m \x1b[3;37m(script) (command)\x1b[0m \x1b[3;37m[arguments...]\x1b[0m");

		Log.println("");
		Log.println(" " + Log.accentColor + "Flags:" + Log.resetColor);
		Log.println("");

		Log.println("  \x1b[1m-v\x1b[0;3m/\x1b[0m\x1b[1m-verbose\x1b[0m -- Print additional information (when available)");
		Log.println("  \x1b[1m-h\x1b[0m/\x1b[0m\x1b[1m-help\x1b[0m -- Display help information (if available)");
		Log.println("  \x1b[1m-nocolor\x1b[0m -- Disable ANSI format codes in output");

		Log.println("");
		Log.println(" " + Log.accentColor + "Options:" + Log.resetColor);
		Log.println("");

		Log.println("  \x1b[1m--install-hxp-alias\x1b[0m -- Installs the 'hxp' command alias");
	}

	private static function displayInfo(showLogo:Bool = false, showHint:Bool = false):Void
	{
		if (System.hostPlatform == WINDOWS)
		{
			Log.println("");
		}

		if (showLogo)
		{
			Log.println("\x1b[36;1m ,dPb,                              \x1b[0m");
			Log.println("\x1b[36;1m IP`Yb                              \x1b[0m");
			Log.println("\x1b[36;1m I8 8I                              \x1b[0m");
			Log.println("\x1b[36;1m I8 8'                              \x1b[0m");
			Log.println("\x1b[36;1m I8d8Pgg,       ,gg,   ,gg gg,gggg,   \x1b[0m");
			Log.println("\x1b[36;1m I8dP\" \"8I    d8\"\"8b,dP\"  I8P\"  \"Yb  \x1b[0m");
			Log.println("\x1b[36;1m I8P    I8   dP   ,88\"    I8'    ,8i \x1b[0m");
			Log.println("\x1b[36;1m,d8     I8,,dP  ,dP\"Y8,  ,I8 _  ,d8' \x1b[0m");
			Log.println("\x1b[36;1md8P     `Y88\"  dP\"   \"Y88PI8 YY88P\x1b[0m");
			Log.println("\x1b[36;1m                          I8         \x1b[0m");
			Log.println("\x1b[36;1m                          I8         \x1b[0m");
			Log.println("");
			Log.println("\x1b[1mHXP Command-Line Tools\x1b[0;1m (" + getToolsVersion() + ")\x1b[0m");
		}
		else
		{
			Log.println("\x1b[36;1mHXP Command-Line Tools (" + getToolsVersion() + ")\x1b[0m");
		}

		if (showHint)
		{
			var commandName = "hxp";
			Log.println("Use \x1b[3mhxp help\x1b[0m for instructions");
		}
	}

	private static function executeScript(path:String, command:String, arguments:Array<String>):Void
	{
		Log.info("", Log.accentColor + "Executing script: " + path + Log.resetColor);

		var dir = Path.directory(path);
		var file = Path.withoutDirectory(path);
		var className = Path.withoutExtension(file);
		className = className.substr(0, 1).toUpperCase() + className.substr(1);

		var version = "0.0.0";
		var buildArgs = [
			className,
			/*"-main", "hxp.Script",*/
			"-D",
			"hxp=" + version,
			"-cp",
			Path.combine(Haxelib.getPath(new Haxelib("hxp")), "src")
		];
		var runArgs = ["hxp.Script", (command == null || command == "") ? "default" : command];
		runArgs = runArgs.concat(arguments);

		if (Log.verbose) runArgs.push("-verbose");
		if (!Log.enableColor) runArgs.push("-nocolor");

		runArgs.push(className);
		runArgs.push(Sys.getCwd());

		System.runScript(path, buildArgs, runArgs, dir);
	}

	private static function findScriptFile(path:String, command:String = null):String
	{
		if (command != null && FileSystem.exists(Path.combine(path, command + ".hxp")))
		{
			return Path.combine(path, command + ".hxp");
		}
		else if (command != null && FileSystem.exists(Path.combine(path, command + ".hx")))
		{
			return Path.combine(path, command + ".hx");
		}
		else if (command == null && FileSystem.exists(Path.combine(path, "default.hxp")))
		{
			return Path.combine(path, "default.hxp");
		}
		else if (command == null && FileSystem.exists(Path.combine(path, "default.hx")))
		{
			return Path.combine(path, "default.hx");
		}
		else if (FileSystem.exists(Path.combine(path, "script.hxp")))
		{
			return Path.combine(path, "script.hxp");
		}
		else if (FileSystem.exists(Path.combine(path, "script.hx")))
		{
			return Path.combine(path, "script.hx");
		}
		else if (FileSystem.exists(Path.combine(path, "project.hxp")))
		{
			return Path.combine(path, "project.hxp");
		}
		else if (FileSystem.exists(Path.combine(path, "project.hx")))
		{
			return Path.combine(path, "project.hx");
		}
		else if (command == null && FileSystem.exists(Path.combine(path, "build.hxp")))
		{
			return Path.combine(path, "build.hxp");
		}
		else if (command == null && FileSystem.exists(Path.combine(path, "build.hx")))
		{
			return Path.combine(path, "build.hx");
		}
		else
		{
			var files = FileSystem.readDirectory(path);
			var matches = new Map<String, Array<String>>();
			matches.set("hxp", []);
			matches.set("hx", []);

			for (file in files)
			{
				var path = Path.combine(path, file);

				if (FileSystem.exists(path) && !FileSystem.isDirectory(path))
				{
					var extension = Path.extension(file);

					if (matches.exists(extension))
					{
						matches.get(extension).push(path);
					}
				}
			}

			if (matches.get("hxp").length > 0)
			{
				return matches.get("hxp")[0];
			}

			if (matches.get("hx").length == 1)
			{
				return matches.get("hx")[0];
			}
			else if (matches.get("hx").length > 1)
			{
				Log.error("Please use 'hxp filename.hx' to specify which script you wish to run");
			}
		}

		return null;
	}

	private static function getToolsVersion():String
	{
		return version;
	}

	private static function handleLastArgument(arguments:Array<String>):Void
	{
		var runFromHaxelib = false;

		if (arguments.length > 0)
		{
			// When the command-line tools are called from haxelib,
			// the last argument is the project directory and the
			// path to Lime is the current working directory

			var lastArgument = "";

			for (i in 0...arguments.length)
			{
				lastArgument = arguments.pop();
				if (lastArgument.length > 0) break;
			}

			lastArgument = new Path(lastArgument).toString();
			var isRootDirectory = false;

			if (System.hostPlatform == WINDOWS)
			{
				isRootDirectory = (lastArgument.length == 3
					&& lastArgument.charAt(1) == ":"
					&& (lastArgument.charAt(2) == "/" || lastArgument.charAt(2) == "\\"));
			}
			else
			{
				isRootDirectory = (lastArgument == "/");
			}

			if (FileSystem.exists(lastArgument) && FileSystem.isDirectory(lastArgument))
			{
				// Haxelib.setOverridePath (new Haxelib ("lime-tools"), Path.combine (Sys.getCwd (), "tools"));

				Sys.setCwd(lastArgument);
				runFromHaxelib = true;
			}
			else if (!isRootDirectory)
			{
				arguments.push(lastArgument);
			}

			// Haxelib.workingDirectory = Sys.getCwd ();
		}

		if (!runFromHaxelib)
		{
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

	private static function installHXPAlias():Void
	{
		var haxePath = Sys.getEnv("HAXEPATH");

		if (System.hostPlatform == WINDOWS)
		{
			if (haxePath == null || haxePath == "")
			{
				haxePath = "C:\\HaxeToolkit\\haxe\\";
			}

			try
			{
				File.copy(Haxelib.getPath(new Haxelib("hxp")) + "\\bin\\hxp.exe", haxePath + "\\hxp.exe");
			}
			catch (e:Dynamic) {}
			try
			{
				File.copy(Haxelib.getPath(new Haxelib("hxp")) + "\\bin\\hxp.sh", haxePath + "\\hxp");
			}
			catch (e:Dynamic) {}
		}
		else
		{
			if (haxePath == null || haxePath == "")
			{
				haxePath = "/usr/lib/haxe";
			}

			var installedCommand = false;

			try
			{
				System.runCommand("", "sudo", [
					"cp",
					"-f",
					Haxelib.getPath(new Haxelib("hxp")) + "/bin/hxp.sh",
					"/usr/local/bin/hxp"
				], false);
				System.runCommand("", "sudo", ["chmod", "755", "/usr/local/bin/hxp"], false);
				installedCommand = true;
			}
			catch (e:Dynamic) {}

			if (!installedCommand)
			{
				try
				{
					System.runCommand("", "cp", ["-f", Haxelib.getPath(new Haxelib("hxp")) + "/bin/hxp.sh", "/usr/local/bin/hxp"], false);
					System.runCommand("", "chmod", ["755", "/usr/local/bin/hxp"], false);
					installedCommand = true;
				}
				catch (e:Dynamic) {}
			}

			if (!installedCommand)
			{
				Sys.println("");
				Sys.println("To finish setup, we recommend you either...");
				Sys.println("");
				Sys.println(" a) Manually add an alias called \"hxp\" to run \"haxelib run hxp\"");
				Sys.println(" b) Run the following commands:");
				Sys.println("");
				Sys.println("sudo cp \"" + Path.combine(Haxelib.getPath(new Haxelib("hxp")), "bin/hxp.sh") + "\" /usr/local/bin/hxp");
				Sys.println("sudo chmod 755 /usr/local/bin/hxp");
				Sys.println("");
			}
		}
	}
}
