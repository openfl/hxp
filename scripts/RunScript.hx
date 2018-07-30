package;


import hxp.helpers.InterpHelper;
import hxp.helpers.LogHelper;


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
		
		Sys.exit (InterpHelper.run ([
			
			"-main",
			"CommandLineTools",
			"-cp", "src",
			"-cp", "scripts",
			
		], Sys.args ()));
		
	}
	
	
}