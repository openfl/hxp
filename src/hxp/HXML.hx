package hxp;

import hxp.System;
import sys.io.File;
import sys.FileSystem;

@:structInit
abstract HXML(Array<String>)
{
	/**
		Generates ActionScript 3 source code in specified directory.
	**/
	public var as3(get, set):String;

	/**
		Connect on the given port and run commands there.
	**/
	public var connect(get, set):String;

	/**
		Generates C++ source code in specified directory and compiles it using native C++ compiler.
	**/
	public var cpp(get, set):String;

	/**
		Generates the specified script as cppia file.
	**/
	public var cppia(get, set):String;

	/**
		Generates C# source code in specified directory.
	**/
	public var cs(get, set):String;

	/**
		Set the Dead Code Elimination mode (default std).
	**/
	public var dce(get, set):DCE;

	/**
		Add debug information to the compiled code.
	**/
	public var debug(get, set):Bool;

	/**
		Display code tips to provide completion information for IDEs and editors.
	**/
	public var display(get, set):Bool;

	/**
		More type strict flash API.
	**/
	public var flashStrict(get, set):Bool;

	/**
		Generate hx headers for all input classes.
	**/
	public var genHXClasses(get, set):Bool;

	/**
		Generates HashLink byte code in specified file.
	**/
	public var hl(get, set):String;

	/**
		Generates Java source code in specified directory and compiles it using the Java Compiler.
	**/
	public var java(get, set):String;

	/**
		Generates JavaScript source code in specified file.
	**/
	public var js(get, set):String;

	/**
		Generates Lua source code in the specified file.
	**/
	public var lua(get, set):String;

	/**
		Sets the main class.
	**/
	public var main(get, set):String;

	/**
		Generates Neko binary as specified file.
	**/
	public var neko(get, set):String;

	/**
		Disable Inline.
	**/
	public var noInline(get, set):Bool;

	/**
		Disable code optimizations.
	**/
	public var noOpt(get, set):Bool;

	/**
		Compiles but does not generate any file.
	**/
	public var noOutput(get, set):Bool;

	/**
		Don't compile trace calls in the program.
	**/
	public var noTraces(get, set):Bool;

	/**
		Generates PHP source code in specified directory. Use -D php7 for PHP7 source code.
	**/
	public var php(get, set):String;

	/**
		Select the name for the php front file.
	**/
	public var phpFront(get, set):String;

	/**
		Select the name for the php lib folder.
	**/
	public var phpLib(get, set):String;

	/**
		Prefix all classes with given name.
	**/
	public var phpPrefix(get, set):String;

	/**
		Prompt on error.
	**/
	public var prompt(get, set):Bool;

	/**
		Generates Python source code in the specified file.
	**/
	public var python(get, set):String;

	/**
		Generates the specified file as Flash .swf.
	**/
	public var swf(get, set):String;

	/**
		Define SWF header (width:height:fps:color).
	**/
	public var swfHeader(get, set):String;

	/**
		Change the SWF version.
	**/
	public var swfVersion(get, set):String;

	/**
		Measure compilation times.
	**/
	public var times(get, set):Bool;

	/**
		Turn on verbose mode.
	**/
	public var verbose(get, set):Bool;

	/**
		Wait on the given port for commands to run.
	**/
	public var wait(get, set):String;

	/**
		Generate XML types description. Useful for API documentation generation tools like Dox.
	**/
	public var xml(get, set):String;

	public function new(hxml:HXMLConfig = null)
	{
		this = new Array();

		if (hxml != null)
		{
			if (Reflect.hasField(hxml, "as3")) as3 = hxml.as3;
			if (Reflect.hasField(hxml, "connect")) connect = hxml.connect;
			if (Reflect.hasField(hxml, "cpp")) cpp = hxml.cpp;
			if (Reflect.hasField(hxml, "cppia")) cppia = hxml.cppia;
			if (Reflect.hasField(hxml, "cs")) cs = hxml.cs;
			if (Reflect.hasField(hxml, "dce")) dce = hxml.dce;
			if (Reflect.hasField(hxml, "debug")) debug = hxml.debug;
			if (Reflect.hasField(hxml, "display")) display = hxml.display;
			if (Reflect.hasField(hxml, "flashStrict")) flashStrict = hxml.flashStrict;
			if (Reflect.hasField(hxml, "genHXClasses")) genHXClasses = hxml.genHXClasses;
			if (Reflect.hasField(hxml, "hl")) hl = hxml.hl;
			if (Reflect.hasField(hxml, "java")) java = hxml.java;
			if (Reflect.hasField(hxml, "js")) js = hxml.js;
			if (Reflect.hasField(hxml, "lua")) lua = hxml.lua;
			if (Reflect.hasField(hxml, "main")) main = hxml.main;
			if (Reflect.hasField(hxml, "neko")) neko = hxml.neko;
			if (Reflect.hasField(hxml, "noInline")) noInline = hxml.noInline;
			if (Reflect.hasField(hxml, "noOpt")) noOpt = hxml.noOpt;
			if (Reflect.hasField(hxml, "noOutput")) noOutput = hxml.noOutput;
			if (Reflect.hasField(hxml, "noTraces")) noTraces = hxml.noTraces;
			if (Reflect.hasField(hxml, "php")) php = hxml.php;
			if (Reflect.hasField(hxml, "phpFront")) phpFront = hxml.phpFront;
			if (Reflect.hasField(hxml, "phpLib")) phpLib = hxml.phpLib;
			if (Reflect.hasField(hxml, "phpPrefix")) phpPrefix = hxml.phpPrefix;
			if (Reflect.hasField(hxml, "prompt")) prompt = hxml.prompt;
			if (Reflect.hasField(hxml, "python")) python = hxml.python;
			if (Reflect.hasField(hxml, "swf")) swf = hxml.swf;
			if (Reflect.hasField(hxml, "swfHeader")) swfHeader = hxml.swfHeader;
			if (Reflect.hasField(hxml, "swfVersion")) swfVersion = hxml.swfVersion;
			if (Reflect.hasField(hxml, "times")) times = hxml.times;
			if (Reflect.hasField(hxml, "verbose")) verbose = hxml.verbose;
			if (Reflect.hasField(hxml, "wait")) wait = hxml.wait;
			if (Reflect.hasField(hxml, "xml")) xml = hxml.xml;

			if (Reflect.hasField(hxml, "classNames"))
			{
				for (className in hxml.classNames)
				{
					addClassName(className);
				}
			}
			if (Reflect.hasField(hxml, "cArgs"))
			{
				for (_cArg in hxml.cArgs)
				{
					cArg(_cArg);
				}
			}
			if (Reflect.hasField(hxml, "cmds"))
			{
				for (_cmd in hxml.cmds)
				{
					cmd(_cmd);
				}
			}
			if (Reflect.hasField(hxml, "cp"))
			{
				for (_cp in hxml.cp)
				{
					cp(_cp);
				}
			}
			if (Reflect.hasField(hxml, "defines"))
			{
				for (_define in hxml.defines)
				{
					this.push("-D \"" + _define + "\"");
				}
			}
			if (Reflect.hasField(hxml, "javaLibs"))
			{
				for (_javaLib in hxml.javaLibs)
				{
					javaLib(_javaLib);
				}
			}
			if (Reflect.hasField(hxml, "libs"))
			{
				for (_lib in hxml.libs)
				{
					this.push("-lib " + _lib);
				}
			}
			if (Reflect.hasField(hxml, "netLibs"))
			{
				for (_netLib in hxml.netLibs)
				{
					netLib(_netLib);
				}
			}
			if (Reflect.hasField(hxml, "netStd"))
			{
				for (std in hxml.netStd)
				{
					netStd(std);
				}
			}
			if (Reflect.hasField(hxml, "remap"))
			{
				for (_remap in hxml.remap)
				{
					this.push("--remap \"" + _remap + "\"");
				}
			}
			if (Reflect.hasField(hxml, "resources"))
			{
				for (resource in hxml.resources)
				{
					this.push("-resource \"" + resource + "\"");
				}
			}
			if (Reflect.hasField(hxml, "macros"))
			{
				for (_macro in hxml.macros)
				{
					addMacro(_macro);
				}
			}
			if (Reflect.hasField(hxml, "swfLibs"))
			{
				for (_swfLib in hxml.swfLibs)
				{
					swfLib(_swfLib);
				}
			}
			if (Reflect.hasField(hxml, "swfLibExterns"))
			{
				for (_swfLibExtern in hxml.swfLibExterns)
				{
					swfLibExtern(_swfLibExtern);
				}
			}
		}
	}

	/**
		Include a specific class name in compilation.
	**/
	public function addClassName(classname:String):Void
	{
		this.push(classname);
	}

	/**
		Call the given initialization macro before typing anything else.
	**/
	public function addMacro(value:String):Void
	{
		this.push("--macro " + value);
	}

	/**
		Builds the current HXML using Haxe.
	**/
	public function build():Int
	{
		return System.runCommand("", "haxe " + this.join(" "), null);
	}

	/**
		Pass option arg to the native Java/C# compiler.
	**/
	public function cArg(arg:String):Void
	{
		this.push("-c-arg " + arg);
	}

	public function clone():HXML
	{
		var copy = this.copy();
		return cast copy;
	}

	/**
		Run the specified command after a successful compilation.
	**/
	public function cmd(command:String):Void
	{
		this.push("-cmd \"" + command + "\"");
	}

	/**
		Adds a class path where `.hx` source files or packages (sub-directories) can be found.
	**/
	public function cp(path:String):Void
	{
		if (path.indexOf(" ") != -1)
		{
			this.push("-cp \"" + path + "\"");
		}
		else
		{
			this.push("-cp " + path);
		}
	}

	/**
		Set current working directory.
	**/
	public function cwd(path:String):Void
	{
		this.push("-cwd \"" + path + "\"");
	}

	/**
		Define a conditional compilation flag.
	**/
	public function define(name:String, value:Dynamic = null):Void
	{
		this.push("-D " + name + (value == null ? "" : "=" + Std.string(value)));
	}

	public static function fromFile(path:String):HXML
	{
		if (FileSystem.exists(path))
		{
			return HXML.fromString(File.getContent(path));
		}

		return null;
	}

	@:from public static function fromString(hxml:String):HXML
	{
		var value = new Array<String>();

		if (hxml != null)
		{
			var lines = hxml.split("\n");

			for (line in lines)
			{
				value.push(StringTools.trim(line));
			}
		}

		return cast value;
	}

	/**
		Get the value of a conditional compilation flag, if present.
	**/
	public function getDefine(name:String):String
	{
		var prefix = "-D " + name;
		var value = null;

		for (line in this)
		{
			if (StringTools.startsWith(line, prefix))
			{
				if (line.length == prefix.length)
				{
					value = null;
				}
				else if (line.indexOf("=") == prefix.length)
				{
					value = line.substr(prefix.length + 1);
				}
			}
		}

		return value;
	}

	/**
		Return whether a conditional compilation flag has been defined.
	**/
	public function hasDefine(name:String):Bool
	{
		var prefix = "-D " + name;

		for (line in this)
		{
			if (StringTools.startsWith(line, prefix))
			{
				if (line.length == prefix.length || line.indexOf("=") == prefix.length)
				{
					return true;
				}
			}
		}

		return false;
	}

	/**
		Add an external JAR or class directory library.
	**/
	public function javaLib(path:String):Void
	{
		this.push("-java-lib \"" + path + "\"");
	}

	/**
		Adds a Haxelib library. By default the most recent version in the local Haxelib repository is used.
	**/
	public function lib(name:String, version:String = null):Void
	{
		this.push("-lib " + name + (version == null ? "" : ":" + version));
	}

	/**
		Add an external .NET DLL file.
	**/
	public function netLib(path:String, std:String = null):Void
	{
		this.push("-net-lib \"" + path + (std == null ? "" : "@" + std) + "\"");
	}

	/**
		Add a root std .NET DLL search path.
	**/
	public function netStd(path:String):Void
	{
		this.push("-net-std \"" + path + "\"");
	}

	/**
		Remap a package to another one.
	**/
	public function remap(packageName:String, target:String):Void
	{
		this.push("--remap " + packageName + ":" + target);
	}

	/**
		Add a named resource file.
	**/
	public function resource(path:String, name:String = null):Void
	{
		this.push("-resource \"" + path + (name == null ? "" : "@" + name) + "\"");
	}

	/**
		Add the SWF library to the compiled SWF.
	**/
	public function swfLib(path:String):Void
	{
		this.push("-swf-lib \"" + path + "\"");
	}

	/**
		Use the SWF library for type checking.
	**/
	public function swfLibExtern(path:String):Void
	{
		this.push("-swf-lib-extern \"" + path + "\"");
	}

	@:to public function toString():String
	{
		return this.join("\n");
	}

	@:noCompletion private function __getLine(prefix:String):String
	{
		for (line in this)
		{
			if (StringTools.startsWith(line, prefix))
			{
				return line.substr(prefix.length);
			}
		}

		return null;
	}

	@:noCompletion private function __trimLines(prefixes:Array<String>):Void
	{
		var i = this.length - 1;
		while (i >= 0)
		{
			for (prefix in prefixes)
			{
				if (StringTools.startsWith(this[i], prefix))
				{
					this.splice(i, 1);
				}
			}

			i--;
		}
	}

	@:noCompletion private function __trimTargets():Void
	{
		__trimLines([
			"-js ", "-as3 ", "-swf ", "-neko ", "-php ", "-cpp ", "-cs ", "-java ", "-python ", "-lua ", "-hl ", "-cppia ", "-x "
		]);
	}

	// Get & Set Methods

	@:noCompletion private function get_as3():String
	{
		return __getLine("-as3 ");
	}

	@:noCompletion private function set_as3(value:String):String
	{
		__trimTargets();
		this.push("-as3 " + value);
		return value;
	}

	@:noCompletion private function get_connect():String
	{
		return __getLine("--connect ");
	}

	@:noCompletion private function set_connect(value:String):String
	{
		__trimLines(["--connect "]);
		this.push("--connect " + value);
		return value;
	}

	@:noCompletion private function get_cpp():String
	{
		return __getLine("-cpp ");
	}

	@:noCompletion private function set_cpp(value:String):String
	{
		__trimTargets();
		this.push("-cpp " + value);
		return value;
	}

	@:noCompletion private function get_cppia():String
	{
		return __getLine("-cppia ");
	}

	@:noCompletion private function set_cppia(value:String):String
	{
		__trimTargets();
		this.push("-cppia " + value);
		return value;
	}

	@:noCompletion private function get_cs():String
	{
		return __getLine("-cs ");
	}

	@:noCompletion private function set_cs(value:String):String
	{
		__trimTargets();
		this.push("-cs " + value);
		return value;
	}

	@:noCompletion private function get_dce():DCE
	{
		var line = __getLine("-dce ");
		if (line != null)
		{
			var type = line.substr(5);
			if (type == "std") return STD;
			else if (type == "full") return FULL;
			else if (type == "no") return NO;
		}
		return null;
	}

	@:noCompletion private function set_dce(value:DCE):DCE
	{
		var str = switch (value)
		{
			case FULL: "full";
			case NO: "no";
			default: "std";
		}

		__trimLines(["-dce "]);
		this.push("-dce " + str);
		return value;
	}

	@:noCompletion private function get_debug():Bool
	{
		return __getLine("-debug") != null;
	}

	@:noCompletion private function set_debug(value:Bool):Bool
	{
		__trimLines(["-debug"]);
		this.push("-debug");
		return value;
	}

	@:noCompletion private function get_display():Bool
	{
		return __getLine("--display") != null;
	}

	@:noCompletion private function set_display(value:Bool):Bool
	{
		__trimLines(["--display"]);
		this.push("--display");
		return value;
	}

	@:noCompletion private function get_flashStrict():Bool
	{
		return __getLine("--flash-strict") != null;
	}

	@:noCompletion private function set_flashStrict(value:Bool):Bool
	{
		__trimLines(["--flash-strict"]);
		this.push("--flash-strict");
		return value;
	}

	@:noCompletion private function get_genHXClasses():Bool
	{
		return __getLine("--gen-hx-classes") != null;
	}

	@:noCompletion private function set_genHXClasses(value:Bool):Bool
	{
		__trimLines(["--gen-hx-classes"]);
		this.push("--gen-hx-classes");
		return value;
	}

	@:noCompletion private function get_hl():String
	{
		return __getLine("-hl ");
	}

	@:noCompletion private function set_hl(value:String):String
	{
		__trimTargets();
		this.push("-hl " + value);
		return value;
	}

	@:noCompletion private function get_java():String
	{
		return __getLine("-java ");
	}

	@:noCompletion private function set_java(value:String):String
	{
		__trimTargets();
		this.push("-java " + value);
		return value;
	}

	@:noCompletion private function get_js():String
	{
		return __getLine("-js ");
	}

	@:noCompletion private function set_js(value:String):String
	{
		__trimTargets();
		this.push("-js " + value);
		return value;
	}

	@:noCompletion private function get_lua():String
	{
		return __getLine("-lua ");
	}

	@:noCompletion private function set_lua(value:String):String
	{
		__trimTargets();
		this.push("-lua " + value);
		return value;
	}

	@:noCompletion private function get_main():String
	{
		return __getLine("-main ");
	}

	@:noCompletion private function set_main(value:String):String
	{
		__trimLines(["-main "]);
		this.push("-main " + value);
		return value;
	}

	@:noCompletion private function get_neko():String
	{
		return __getLine("-neko ");
	}

	@:noCompletion private function set_neko(value:String):String
	{
		__trimTargets();
		this.push("-neko " + value);
		return value;
	}

	@:noCompletion private function get_noInline():Bool
	{
		return __getLine("--no-inline") != null;
	}

	@:noCompletion private function set_noInline(value:Bool):Bool
	{
		__trimLines(["--no-inline"]);
		if (value)
		{
			this.push("--no-inline");
		}
		return value;
	}

	@:noCompletion private function get_noOpt():Bool
	{
		return __getLine("--no-opt") != null;
	}

	@:noCompletion private function set_noOpt(value:Bool):Bool
	{
		__trimLines(["--no-opt"]);
		if (value)
		{
			this.push("--no-opt");
		}
		return value;
	}

	@:noCompletion private function get_noOutput():Bool
	{
		return __getLine("--no-output") != null;
	}

	@:noCompletion private function set_noOutput(value:Bool):Bool
	{
		__trimLines(["--no-output"]);
		if (value)
		{
			this.push("--no-output");
		}
		return value;
	}

	@:noCompletion private function get_noTraces():Bool
	{
		return __getLine("--no-traces") != null;
	}

	@:noCompletion private function set_noTraces(value:Bool):Bool
	{
		__trimLines(["--no-traces"]);
		if (value)
		{
			this.push("--no-traces");
		}
		return value;
	}

	@:noCompletion private function get_php():String
	{
		return __getLine("-php ");
	}

	@:noCompletion private function set_php(value:String):String
	{
		__trimTargets();
		this.push("-php " + value);
		return value;
	}

	@:noCompletion private function get_phpFront():String
	{
		return __getLine("--php-front ");
	}

	@:noCompletion private function set_phpFront(value:String):String
	{
		__trimLines(["--php-front "]);
		this.push("--php-front " + value);
		return value;
	}

	@:noCompletion private function get_phpLib():String
	{
		return __getLine("--php-lib ");
	}

	@:noCompletion private function set_phpLib(value:String):String
	{
		__trimLines(["--php-lib "]);
		this.push("--php-lib " + value);
		return value;
	}

	@:noCompletion private function get_phpPrefix():String
	{
		return __getLine("--php-prefix ");
	}

	@:noCompletion private function set_phpPrefix(value:String):String
	{
		__trimLines(["--php-prefix "]);
		this.push("--php-prefix " + value);
		return value;
	}

	@:noCompletion private function get_prompt():Bool
	{
		return __getLine("-prompt") != null;
	}

	@:noCompletion private function set_prompt(value:Bool):Bool
	{
		__trimLines(["-prompt"]);
		if (value)
		{
			this.push("-prompt");
		}
		return value;
	}

	@:noCompletion private function get_python():String
	{
		return __getLine("-python ");
	}

	@:noCompletion private function set_python(value:String):String
	{
		__trimTargets();
		this.push("-python " + value);
		return value;
	}

	@:noCompletion private function get_swf():String
	{
		return __getLine("-swf ");
	}

	@:noCompletion private function set_swf(value:String):String
	{
		__trimTargets();
		this.push("-swf " + value);
		return value;
	}

	@:noCompletion private function get_swfHeader():String
	{
		return __getLine("-swf-header ");
	}

	@:noCompletion private function set_swfHeader(value:String):String
	{
		__trimLines(["-swf-header "]);
		this.push("-swf-header " + value);
		return value;
	}

	@:noCompletion private function get_swfVersion():String
	{
		return __getLine("-swf-version ");
	}

	@:noCompletion private function set_swfVersion(value:String):String
	{
		__trimLines(["-swf-version "]);
		this.push("-swf-version " + value);
		return value;
	}

	@:noCompletion private function get_times():Bool
	{
		return __getLine("--times") != null;
	}

	@:noCompletion private function set_times(value:Bool):Bool
	{
		__trimLines(["--times"]);
		if (value)
		{
			this.push("--times");
		}
		return value;
	}

	@:noCompletion private function get_verbose():Bool
	{
		return __getLine("-v") != null;
	}

	@:noCompletion private function set_verbose(value:Bool):Bool
	{
		__trimLines(["-v"]);
		if (value)
		{
			this.push("-v");
		}
		return value;
	}

	@:noCompletion private function get_wait():String
	{
		return __getLine("--wait ");
	}

	@:noCompletion private function set_wait(value:String):String
	{
		__trimLines(["--wait "]);
		this.push("--wait " + value);
		return value;
	}

	@:noCompletion private function get_xml():String
	{
		return __getLine("-xml ");
	}

	@:noCompletion private function set_xml(value:String):String
	{
		__trimLines(["-xml "]);
		this.push("-xml " + value);
		return value;
	}
}

enum DCE
{
	STD;
	FULL;
	NO;
}

typedef HXMLConfig =
{
	/**
		Generates ActionScript 3 source code in specified directory.
	**/
	@:optional var as3:String;

	/**
		Connect on the given port and run commands there.
	**/
	@:optional var connect:String;

	/**
		Generates C++ source code in specified directory and compiles it using native C++ compiler.
	**/
	@:optional var cpp:String;

	/**
		Generates the specified script as cppia file.
	**/
	@:optional var cppia:String;

	/**
		Generates C# source code in specified directory.
	**/
	@:optional var cs:String;

	/**
		Set the Dead Code Elimination mode (default std).
	**/
	@:optional var dce:DCE;

	/**
		Add debug information to the compiled code.
	**/
	@:optional var debug:Bool;

	/**
		Display code tips to provide completion information for IDEs and editors.
	**/
	@:optional var display:Bool;

	/**
		More type strict flash API.
	**/
	@:optional var flashStrict:Bool;

	/**
		Generate hx headers for all input classes.
	**/
	@:optional var genHXClasses:Bool;

	/**
		Generates HashLink byte code in specified file.
	**/
	@:optional var hl:String;

	/**
		Generates Java source code in specified directory and compiles it using the Java Compiler.
	**/
	@:optional var java:String;

	/**
		Generates JavaScript source code in specified file.
	**/
	@:optional var js:String;

	/**
		Generates Lua source code in the specified file.
	**/
	@:optional var lua:String;

	/**
		Sets the main class.
	**/
	@:optional var main:String;

	/**
		Generates Neko binary as specified file.
	**/
	@:optional var neko:String;

	/**
		Disable Inline.
	**/
	@:optional var noInline:Bool;

	/**
		Disable code optimizations.
	**/
	@:optional var noOpt:Bool;

	/**
		Compiles but does not generate any file.
	**/
	@:optional var noOutput:Bool;

	/**
		Don't compile trace calls in the program.
	**/
	@:optional var noTraces:Bool;

	/**
		Generates PHP source code in specified directory. Use -D php7 for PHP7 source code.
	**/
	@:optional var php:String;

	/**
		Select the name for the php front file.
	**/
	@:optional var phpFront:String;

	/**
		Select the name for the php lib folder.
	**/
	@:optional var phpLib:String;

	/**
		Prefix all classes with given name.
	**/
	@:optional var phpPrefix:String;

	/**
		Prompt on error.
	**/
	@:optional var prompt:Bool;

	/**
		Generates Python source code in the specified file.
	**/
	@:optional var python:String;

	/**
		Generates the specified file as Flash .swf.
	**/
	@:optional var swf:String;

	/**
		Define SWF header (width:height:fps:color).
	**/
	@:optional var swfHeader:String;

	/**
		Change the SWF version.
	**/
	@:optional var swfVersion:String;

	/**
		Measure compilation times.
	**/
	@:optional var times:Bool;

	/**
		Turn on verbose mode.
	**/
	@:optional var verbose:Bool;

	/**
		Wait on the given port for commands to run.
	**/
	@:optional var wait:String;

	/**
		Generate XML types description. Useful for API documentation generation tools like Dox.
	**/
	@:optional var xml:String;

	/**
		Include a specific class name in compilation.
	**/
	@:optional var classNames:Array<String>;

	/**
		Pass option arg to the native Java/C# compiler.
	**/
	@:optional var cArgs:Array<String>;

	/**
		Run the specified command after a successful compilation.
	**/
	@:optional var cmds:Array<String>;

	/**
		Adds a class path where `.hx` source files or packages (sub-directories) can be found.
	**/
	@:optional var cp:Array<String>;

	/**
		Set current working directory.
	**/
	// @:optional var cwd:Array<String>;

	/**
		Define a conditional compilation flag.
	**/
	@:optional var defines:Array<String>;

	/**
		Add an external JAR or class directory library.
	**/
	@:optional var javaLibs:Array<String>;

	/**
		Adds a Haxelib library. By default the most recent version in the local Haxelib repository is used.
	**/
	@:optional var libs:Array<String>;

	/**
		Add an external .NET DLL file.
	**/
	@:optional var netLibs:Array<String>;

	/**
		Add a root std .NET DLL search path.
	**/
	@:optional var netStd:Array<String>;

	/**
		Remap a package to another one.
	**/
	@:optional var remap:Array<String>;

	/**
		Add a named resource file.
	**/
	@:optional var resources:Array<String>;

	/**
		Call the given initialization macro before typing anything else.
	**/
	@:optional var macros:Array<String>;

	/**
		Add the SWF library to the compiled SWF.
	**/
	@:optional var swfLibs:Array<String>;

	/**
		Use the SWF library for type checking.
	**/
	@:optional var swfLibExterns:Array<String>;
}
