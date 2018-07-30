package hxp.helpers;


import haxe.io.Path;
import sys.FileSystem;


class InterpHelper {
	
	
	public static function run (buildArgs:Array<String>, runArgs:Array<String> = null, workingDirectory = ""):Int {
		
		// TODO: Make this dependent on runtime Haxe version?
		
		#if (haxe_ver >= "4.0.0")
		
		buildArgs = buildArgs.concat ([ "--interp" ]);
		if (runArgs != null) {
			buildArgs.push ("--");
			buildArgs = buildArgs.concat (runArgs);
		}
		return ProcessHelper.runCommand (workingDirectory, "haxe", buildArgs);
		
		#else
		
		var tempDirectory = PathHelper.getTemporaryDirectory ();
		var nekoOutput = PathHelper.combine (tempDirectory, "script.n");
		
		buildArgs = buildArgs.concat ([ "-neko", nekoOutput ]);
		var result = ProcessHelper.runCommand (workingDirectory, "haxe", buildArgs);
		
		if (result != 0) return result;
		
		if (FileSystem.exists (nekoOutput)) {
			
			result = ProcessHelper.runCommand (workingDirectory, "neko", [ nekoOutput ].concat (runArgs != null ? runArgs : []));
			
		}
		
		return result;
		
		#end
		
	}
	
	
}