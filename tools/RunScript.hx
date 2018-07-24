package;


import haxe.io.Path;
import hxp.project.Haxelib;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;
import hxp.helpers.FileHelper;
import hxp.helpers.HaxelibHelper;
import hxp.helpers.LogHelper;
import hxp.helpers.PathHelper;
import hxp.helpers.PlatformHelper;
import hxp.helpers.ProcessHelper;


class RunScript {
	
	
	public static function runCommand (path:String, command:String, args:Array<String>, throwErrors:Bool = true):Int {
		
		var oldPath:String = "";
		
		if (path != null && path != "") {
			
			oldPath = Sys.getCwd ();
			
			try {
				
				Sys.setCwd (path);
				
			} catch (e:Dynamic) {
				
				LogHelper.error ("Cannot set current working directory to \"" + path + "\"");
				
			}
			
		}
		
		var result:Dynamic = Sys.command (command, args);
		
		if (oldPath != "") {
			
			Sys.setCwd (oldPath);
			
		}
		
		if (throwErrors && result != 0) {
			
			Sys.exit (1);
			
		}
		
		return result;
		
	}
	
	
	public static function main () {
		
		var args = [
			
			"--interp",
			"-main",
			"CommandLineTools",
			"-cp", "src",
			"-cp", "tools",
			"--"
			
		];
		
		Sys.exit (runCommand ("", "haxe", args.concat (Sys.args ())));
		
	}
	
	
}