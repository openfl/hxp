package hxp;


class HXML {
	
	
	/**
		Generates ActionScript 3 source code in specified directory.
	**/
	public var as3 (get, set):String;
	
	/**
		Connect on the given port and run commands there.
	**/
	public var connect (get, set):String;
	
	/**
		Generates C++ source code in specified directory and compiles it using native C++ compiler.
	**/
	public var cpp (get, set):String;
	
	/**
		Generates the specified script as cppia file.
	**/
	public var cppia (get, set):String;
	
	/**
		Generates C# source code in specified directory.
	**/
	public var cs (get, set):String;
	
	/**
		Set the Dead Code Elimination mode (default std).
	**/
	public var dce (get, set):DCE;
	
	/**
		Add debug information to the compiled code.
	**/
	public var debug (get, set):Bool;
	
	/**
		Display code tips to provide completion information for IDEs and editors.
	**/
	public var display (get, set):Bool;
	
	/**
		More type strict flash API.
	**/
	public var flashStrict (get, set):Bool;
	
	/**
		Generate hx headers for all input classes.
	**/
	public var genHXClasses (get, set):Bool;
	
	/**
		Generates HashLink byte code in specified file.
	**/
	public var hl (get, set):String;
	
	/**
		Generates Java source code in specified directory and compiles it using the Java Compiler.
	**/
	public var java (get, set):String;
	
	/**
		Generates JavaScript source code in specified file.
	**/
	public var js (get, set):String;
	
	/**
		Generates Lua source code in the specified file.
	**/
	public var lua (get, set):String;
	
	/**
		Sets the main class.
	**/
	public var main (get, set):String;
	
	/**
		Generates Neko binary as specified file.
	**/
	public var neko (get, set):String;
	
	/**
		Disable Inline.
	**/
	public var noInline (get, set):Bool;
	
	/**
		Disable code optimizations.
	**/
	public var noOpt (get, set):Bool;
	
	/**
		Compiles but does not generate any file.
	**/
	public var noOutput (get, set):Bool;
	
	/**
		Don't compile trace calls in the program.
	**/
	public var noTraces (get, set):Bool;
	
	/**
		Generates PHP source code in specified directory. Use -D php7 for PHP7 source code.
	**/
	public var php (get, set):String;
	
	/**
		Select the name for the php front file.
	**/
	public var phpFront (get, set):String;
	
	/**
		Select the name for the php lib folder.
	**/
	public var phpLib (get, set):String;
	
	/**
		Prefix all classes with given name.
	**/
	public var phpPrefix (get, set):String;
	
	/**
		Prompt on error.
	**/
	public var prompt (get, set):Bool;
	
	/**
		Generates Python source code in the specified file.
	**/
	public var python (get, set):String;
	
	/**
		Generates the specified file as Flash .swf.
	**/
	public var swf (get, set):String;
	
	/**
		Define SWF header (width:height:fps:color).
	**/
	public var swfHeader (get, set):String;
	
	/**
		Change the SWF version.
	**/
	public var swfVersion (get, set):String;
	
	/**
		Measure compilation times.
	**/
	public var times (get, set):Bool;
	
	/**
		Turn on verbose mode.
	**/
	public var verbose (get, set):Bool;
	
	/**
		Wait on the given port for commands to run.
	**/
	public var wait (get, set):String;
	
	/**
		Generate XML types description. Useful for API documentation generation tools like Dox.
	**/
	public var xml (get, set):String;
	
	
	@:noCompletion private var __data:Array<String>;
	
	
	public function new (hxml:String = null) {
		
		data = new Array ();
		
		if (hxml != null) {
			
			var lines = hxml.split ("\n");
			
			for (line in lines) {
				
				__data.push (StringTools.trim (line));
				
			}
			
		}
		
	}
	
	
	/**
		Pass option arg to the native Java/C# compiler.
	**/
	public function cArg (arg:String):Void {
		
		__data.push ("-c-arg " + arg);
		
	}
	
	
	/**
		Run the specified command after a successful compilation.
	**/
	public function cmd (command:String):Void {
		
		__data.push ("-cmd \"" + command + "\"");
		
	}
	
	
	/**
		Adds a class path where `.hx` source files or packages (sub-directories) can be found.
	**/
	public function cp (path:String):Void {
		
		__data.push ("-cp \"" + path + "\"");
		
	}
	
	
	/**
		Set current working directory.
	**/
	public function cwd (path:String):Void {
		
		__data.push ("-cwd \"" + path + "\"");
		
	}
	
	
	/**
		Define a conditional compilation flag.
	**/
	public function define (name:String, value:Dynamic = null):Void {
		
		__data.push ("-D " + name + (value == null ? "" : "=" + Std.string (value)));
		
	}
	
	
	/**
		Get the value of a conditional compilation flag, if present.
	**/
	public function getDefine (name:String):String {
		
		var line = __getLine ("-lib " + name);
		if (line != null) {
			var equals = line.indexOf ("=");
			if (equals > -1) {
				return line.substr (equals + 1);
			}
		}
		return null;
		
	}
	
	
	/**
		Return whether a conditional compilation flag has been defined.
	**/
	public function hasDefine (name:String):Bool {
		
		return __getLine ("-lib " + name) != null;
		
	}
	
	
	/**
		Add an external JAR or class directory library.
	**/
	public function javaLib (path:String):Void {
		
		__data.push ("-java-lib \"" + path + "\"");
		
	}
	
	
	/**
		Adds a Haxelib library. By default the most recent version in the local Haxelib repository is used.
	**/
	public function lib (name:String, version:String = null):Void {
		
		__data.push ("-lib " + name + (version == null ? "" : ":" + version));
		
	}
	
	
	/**
		Call the given initialization macro before typing anything else.
	**/
	public function macro (value:String):Void {
		
		__data.push ("-macro " + value);
		
	}
	
	
	/**
		Add an external .NET DLL file.
	**/
	public function netLib (path:String, std:String = null):Void {
		
		__data.push ("-net-lib \"" + path + (std == null ? "" : "@" + std) + "\"");
		
	}
	
	
	/**
		Add a root std .NET DLL search path.
	**/
	public function netStd (path:String):Void {
		
		__data.push ("-net-std \"" + path + "\"");
		
	}
	
	
	/**
		Remap a package to another one.
	**/
	public function remap (package:String, target:String):Void {
		
		__data.push ("--remap " + package + ":" + target);
		
	}
	
	
	/**
		Add a named resource file.
	**/
	public function resource (path:String, name:String = null):Void {
		
		__data.push ("-resource \"" + path + (name == null ? "" : "@" + name) + "\"");
		
	}
	
	
	/**
		Add the SWF library to the compiled SWF.
	**/
	public function swfLib (path:String):Void {
		
		__data.push ("-swf-lib \"" + path + "\"");
		
	}
	
	
	/**
		Use the SWF library for type checking.
	**/
	public function swfLibExtern (path:String):Void {
		
		__data.push ("-swf-lib-extern \"" + path + "\"");
		
	}
	
	
	public function toString ():String {
		
		return __data.join ("\n");
		
	}
	
	
	@:noCompletion private function __getLine (prefix:String):Void {
		
		for (line in __data) {
			
			if (StringTools.startsWith (line, prefix)) {
				
				return line.substr (6);
				
			}
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function __trimLines (prefixes:Array<String>):Void {
		
		var i = __data.length;
		while (i >= 0) {
			
			for (prefix in prefixes) {
				
				if (StringTools.startsWith (__data[i], prefix)) {
					
					__data.splice (i, 1);
					
				}
				
			}
			
			i--;
		}
		
	}
	
	
	@:noCompletion private function __trimTargets ():Void {
		
		__trimLines ([ "-js ", "-as3 ", "-swf ", "-neko ", "-php ", "-cpp ", "-cs ", "-java ", "-python ", "-lua ", "-hl ", "-cppia ", "-x " ]);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_as3 ():String {
		
		return __getLine ("-as3 ");
		
	}
	
	
	@:noCompletion private function set_as3 (value:String):String {
		
		__trimTargets ();
		__data.push ("-as3 " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_connect ():String {
		
		return __getLine ("--connect ");
		
	}
	
	
	@:noCompletion private function set_connect (value:String):String {
		
		__trimLines ([ "--connect "]);
		__data.push ("--connect " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_cpp ():String {
		
		return __getLine ("-cpp ");
		
	}
	
	
	@:noCompletion private function set_cpp (value:String):String {
		
		__trimTargets ();
		__data.push ("-cpp " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_cppia ():String {
		
		return __getLine ("-cppia ");
		
	}
	
	
	@:noCompletion private function set_cppia (value:String):String {
		
		__trimTargets ();
		__data.push ("-cppia " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_cs ():String {
		
		return __getLine ("-cs ");
		
	}
	
	
	@:noCompletion private function set_cs (value:String):String {
		
		__trimTargets ();
		__data.push ("-cs " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_dce ():DCE {
		
		var line = __getLine ("-dce ");
		if (line != null) {
			var type = line.substr (5);
			if (type == "std") return STD;
			elseif (type == "full") return FULL;
			elseif (type = "no") return NO;
		}
		return null;
		
	}
	
	
	@:noCompletion private function set_dce (value:DCE):DCE {
		
		var str = switch (value) {
			case FULL: "full";
			case NO: "no";
			default: "std";
		}
		
		__trimLines ([ "-dce " ]);
		__data.push ("-dce " + str);
		return value;
		
	}
	
	
	@:noCompletion private function get_debug ():Bool {
		
		return __getLine ("-debug") != null;
		
	}
	
	
	@:noCompletion private function set_debug (value:Bool):Bool {
		
		__trimLines ([ "-debug" ]);
		__data.push ("-debug");
		return value;
		
	}
	
	
	@:noCompletion private function get_display ():Bool {
		
		return __getLine ("--display") != null;
		
	}
	
	
	@:noCompletion private function set_display (value:Bool):Bool {
		
		__trimLines ([ "--display" ]);
		__data.push ("--display");
		return value;
		
	}
	
	
	@:noCompletion private function get_flashStrict ():Bool {
		
		return __getLine ("--flash-strict") != null;
		
	}
	
	
	@:noCompletion private function set_flashStrict (value:Bool):Bool {
		
		__trimLines ([ "--flash-strict" ]);
		__data.push ("--flash-strict");
		return value;
		
	}
	
	
	@:noCompletion private function get_genHXClasses ():Bool {
		
		return __getLine ("--gen-hx-classes") != null;
		
	}
	
	
	@:noCompletion private function set_genHXClasses (value:Bool):Bool {
		
		__trimLines ([ "--gen-hx-classes" ]);
		__data.push ("--gen-hx-classes");
		return value;
		
	}
	
	
	@:noCompletion private function get_hl ():String {
		
		return __getLine ("-hl ");
		
	}
	
	
	@:noCompletion private function set_hl (value:String):String {
		
		__trimTargets ();
		__data.push ("-hl " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_java ():String {
		
		return __getLine ("-java ");
		
	}
	
	
	@:noCompletion private function set_java (value:String):String {
		
		__trimTargets ();
		__data.push ("-java " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_js ():String {
		
		return __getLine ("-js ");
		
	}
	
	
	@:noCompletion private function set_js (value:String):String {
		
		__trimTargets ();
		__data.push ("-js " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_lua ():String {
		
		return __getLine ("-lua ");
		
	}
	
	
	@:noCompletion private function set_lua (value:String):String {
		
		__trimTargets ();
		__data.push ("-lua " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_main ():String {
		
		return __getLine ("-main ");
		
	}
	
	
	@:noCompletion private function set_main (value:String):String {
		
		__trimLines ([ "-main "]);
		__data.push ("-main " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_neko ():String {
		
		return __getLine ("-neko ");
		
	}
	
	
	@:noCompletion private function set_neko (value:String):String {
		
		__trimTargets ();
		__data.push ("-neko " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_noInline ():Bool {
		
		return __getLine ("--no-inline") != null;
		
	}
	
	
	@:noCompletion private function set_noInline (value:Bool):Bool {
		
		__trimLines ([ "--no-inline" ]);
		__data.push ("--no-inline");
		return value;
		
	}
	
	
	@:noCompletion private function get_noOpt ():Bool {
		
		return __getLine ("--no-opt") != null;
		
	}
	
	
	@:noCompletion private function set_noOpt (value:Bool):Bool {
		
		__trimLines ([ "--no-opt" ]);
		__data.push ("--no-opt");
		return value;
		
	}
	
	
	@:noCompletion private function get_noOutput ():Bool {
		
		return __getLine ("--no-output") != null;
		
	}
	
	
	@:noCompletion private function set_noOutput (value:Bool):Bool {
		
		__trimLines ([ "--no-output" ]);
		__data.push ("--no-output");
		return value;
		
	}
	
	
	@:noCompletion private function get_noTraces ():Bool {
		
		return __getLine ("--no-traces") != null;
		
	}
	
	
	@:noCompletion private function set_noTraces (value:Bool):Bool {
		
		__trimLines ([ "--no-traces" ]);
		__data.push ("--no-traces");
		return value;
		
	}
	
	
	@:noCompletion private function get_php ():String {
		
		return __getLine ("-php ");
		
	}
	
	
	@:noCompletion private function set_php (value:String):String {
		
		__trimTargets ();
		__data.push ("-php " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_phpFront ():String {
		
		return __getLine ("--php-front ");
		
	}
	
	
	@:noCompletion private function set_phpFront (value:String):String {
		
		__trimLines ([ "--php-front "]);
		__data.push ("--php-front " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_phpLib ():String {
		
		return __getLine ("--php-lib ");
		
	}
	
	
	@:noCompletion private function set_phpLib (value:String):String {
		
		__trimLines ([ "--php-lib "]);
		__data.push ("--php-lib " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_phpPrefix ():String {
		
		return __getLine ("--php-prefix ");
		
	}
	
	
	@:noCompletion private function set_phpPrefix (value:String):String {
		
		__trimLines ([ "--php-prefix "]);
		__data.push ("--php-prefix " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_prompt ():Bool {
		
		return __getLine ("-prompt") != null;
		
	}
	
	
	@:noCompletion private function set_prompt (value:Bool):Bool {
		
		__trimLines ([ "-prompt" ]);
		__data.push ("-prompt");
		return value;
		
	}
	
	
	@:noCompletion private function get_python ():String {
		
		return __getLine ("-python ");
		
	}
	
	
	@:noCompletion private function set_python (value:String):String {
		
		__trimTargets ();
		__data.push ("-python " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_swf ():String {
		
		return __getLine ("-swf ");
		
	}
	
	
	@:noCompletion private function set_swf (value:String):String {
		
		__trimTargets ();
		__data.push ("-swf " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_swfHeader ():String {
		
		return __getLine ("-swf-header ");
		
	}
	
	
	@:noCompletion private function set_swfHeader (value:String):String {
		
		__trimLines ([ "-swf-header "]);
		__data.push ("-swf-header " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_swfVersion ():String {
		
		return __getLine ("-swf-version ");
		
	}
	
	
	@:noCompletion private function set_swfVersion (value:String):String {
		
		__trimLines ([ "-swf-version "]);
		__data.push ("-swf-version " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_times ():Bool {
		
		return __getLine ("--times") != null;
		
	}
	
	
	@:noCompletion private function set_times (value:Bool):Bool {
		
		__trimLines ([ "--times" ]);
		__data.push ("--times");
		return value;
		
	}
	
	
	@:noCompletion private function get_verbose ():Bool {
		
		return __getLine ("-v") != null;
		
	}
	
	
	@:noCompletion private function set_verbose (value:Bool):Bool {
		
		__trimLines ([ "-v" ]);
		__data.push ("-v");
		return value;
		
	}
	
	
	@:noCompletion private function get_wait ():String {
		
		return __getLine ("--wait ");
		
	}
	
	
	@:noCompletion private function set_wait (value:String):String {
		
		__trimLines ([ "--wait "]);
		__data.push ("--wait " + value);
		return value;
		
	}
	
	
	@:noCompletion private function get_xml ():String {
		
		return __getLine ("-xml ");
		
	}
	
	
	@:noCompletion private function set_xml (value:String):String {
		
		__trimLines ([ "-xml "]);
		__data.push ("-xml " + value);
		return value;
		
	}
	
	
}


enum DCE {
	
	STD;
	FULL;
	NO;
	
}