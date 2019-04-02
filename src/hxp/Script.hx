package hxp;

import haxe.io.Path;
import hxp.Log;
import sys.FileSystem;

class Script
{
	@:noCompletion private static var __args:Array<String>;
	@:noCompletion private static var __workingDirectory:String;

	public var args:Array<String>;
	public var command:String;
	public var commandArgs:Array<String>;
	public var defines:Map<String, String>;
	public var flags:Map<String, Bool>;
	public var options:Map<String, Array<String>>;
	public var workingDirectory:String;

	public function new()
	{
		if (__args != null)
		{
			args = __args;
			__args = null;
		}
		else
		{
			args = new Array();
		}

		if (__workingDirectory != null)
		{
			workingDirectory = __workingDirectory;
			__workingDirectory = null;
		}
		else
		{
			workingDirectory = Sys.getCwd();
		}

		command = "";
		commandArgs = new Array();
		defines = new Map();
		flags = new Map();
		options = new Map();

		processArguments();
	}

	public static function main()
	{
		var args = Sys.args();
		__workingDirectory = args.pop();

		// Patch Haxe 4 preview 5 behavior
		if (args.indexOf("--") > -1)
		{
			args = args.slice(args.indexOf("--") + 1);
			// Worse than I thought
			var firstArg = args[0];
			if (args.indexOf(firstArg, 1) != -1)
			{
				// Arguments are doubled
				args = args.slice(Math.floor(args.length / 2) + 1);
			}
		}

		var className = args.pop();
		__args = args;

		for (arg in args)
		{
			switch (arg)
			{
				case "-v", "-verbose":
					Log.verbose = true;
				case "-nocolor":
					Log.enableColor = false;
				default:
			}
		}

		if (className != null)
		{
			try
			{
				var classRef = Type.resolveClass(className);
				if (classRef == null) throw "Cannot find class name \"" + className + "\"";

				Type.createInstance(classRef, []);
			}
			catch (e:Dynamic)
			{
				Log.error(e);
			}
		}
	}

	@:noCompletion private function processArguments():Void
	{
		var catchDefine = false, catchOption = null;
		var words = [];

		for (arg in args)
		{
			var equals = arg.indexOf("=");

			if (catchOption != null)
			{
				if (!options.exists(catchOption)) options[catchOption] = [arg];
				else
					options[catchOption].push(arg);
				catchOption = null;
			}
			else if (arg == "-D")
			{
				catchDefine = true;
			}
			else if (equals > 0)
			{
				var argValue = arg.substr(equals + 1);
				// if quotes remain on the argValue we need to strip them off
				// otherwise the compiler really dislikes the result!
				var r = ~/^['"](.*)['"]$/;
				if (r.match(arg))
				{
					argValue = r.matched(1);
				}

				if (catchDefine)
				{
					defines.set(arg, argValue);
					catchDefine = false;
				}
				else if (arg.substr(0, 2) == "-D")
				{
					defines.set(arg.substr(2, equals - 2), argValue);
				}
				else if (arg.substr(0, 2) == "--")
				{
					// this won't work because it assumes there is only ever one of these.
					// projectDefines.set (argument.substr (2, equals - 2), argValue);

					var field = arg.substr(2, equals - 2);
					if (!options.exists(field)) options[field] = [argValue];
					else
						options[field].push(argValue);
				}
				else if (arg.substr(0, 1) == "-")
				{
					flags.set(arg, true);
				}
				else
				{
					words.push(arg);
				}
			}
			else if (catchDefine)
			{
				defines.set(arg, "");
				catchDefine = false;
			}
			else if (arg.substr(0, 2) == "-D")
			{
				defines.set(arg.substr(2), "");
			}
			else if (arg.substr(0, 1) == "-")
			{
				if (arg == "-dce" || arg.substr(1, 1) == "-")
				{
					if (arg == "--remap" || arg == "--connect" || arg == "-dce")
					{
						catchOption = arg;
					}
					else
					{
						if (!options.exists(arg)) options[arg] = [""];
						else
							options[arg].push("");
					}
				}
				else
				{
					flags.set(arg.substr(1), true);
				}
			}
			else
			{
				words.push(arg);
			}
		}

		command = words.shift();
		commandArgs = words;
	}
}
