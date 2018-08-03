package hxp;


import hxp.Haxelib;
import sys.FileSystem;


class WatchHelper {
	
	
	public static function processHXML (hxml:String, outputPath:String = null):Array<String> {
		
		var directories = [];
		var outputPath = PathHelper.tryFullPath (outputPath);
		var dir, fullPath = null;
		
		for (line in hxml.split ("\n")) {
			
			if (StringTools.startsWith (line, "-cp ")) {
				
				dir = StringTools.trim (line.substr (4));
				
				if (FileSystem.exists (dir)) {
					
					fullPath = PathHelper.tryFullPath (dir);
					
					if (outputPath == null || !StringTools.startsWith (fullPath, outputPath)) {
						
						// directories.push (fullPath);
						directories.push (dir);
						
					}
					
				}
				
			}
			
		}
		
		return directories;
		
	}
	
	
	public static function watch (command:String, directories:Array<String>):Void {
		
		var suffix = switch (PlatformHelper.hostPlatform) {
			
			case WINDOWS: "-windows.exe";
			case MAC: "-mac";
			case LINUX: "-linux";
			default: return;
			
		}
		
		if (suffix == "-linux") {
			
			if (PlatformHelper.hostArchitecture == X86) {
				
				suffix += "32";
				
			} else {
				
				suffix += "64";
				
			}
			
		}
		
		var templatePaths = [ PathHelper.combine (PathHelper.getHaxelib (new Haxelib (#if lime "lime" #else "hxp" #end)), #if lime "templates" #else "" #end) ];
		var node = PathHelper.findTemplate (templatePaths, "bin/node/node" + suffix);
		var bin = PathHelper.findTemplate (templatePaths, "bin/node/watch/cli-custom.js");
		
		if (PlatformHelper.hostPlatform != WINDOWS) {
			
			Sys.command ("chmod", [ "+x", node ]);
			
		}
		
		var args = [ bin, command ];
		args = args.concat (directories);
		
		args.push ("--exit");
		args.push ("--ignoreDotFiles");
		args.push ("--ignoreUnreadable");
		
		ProcessHelper.runCommand ("", node, args);
		
	}
	
	
}