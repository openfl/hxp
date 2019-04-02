package hxp;

import sys.io.File;
import sys.FileSystem;

class PlatformTools
{
	public static function generateWebFonts(path:String):Void
	{
		var suffix = switch (System.hostPlatform)
		{
			case WINDOWS: "-windows.exe";
			case MAC: "-mac";
			case LINUX: "-linux";
			default: return;
		}

		if (suffix == "-linux")
		{
			if (System.hostArchitecture == X86)
			{
				suffix += "32";
			}
			else
			{
				suffix += "64";
			}
		}

		var templatePaths = [
			Path.combine(Haxelib.getPath(new Haxelib(#if lime "lime" #else "hxp" #end)), #if lime "templates" #else "" #end)
		];
		var webify = System.findTemplate(templatePaths, "bin/webify" + suffix);
		if (System.hostPlatform != WINDOWS)
		{
			Sys.command("chmod", ["+x", webify]);
		}

		if (Log.verbose)
		{
			System.runCommand("", webify, [Path.tryFullPath(path)]);
		}
		else
		{
			System.runProcess("", webify, [Path.tryFullPath(path)], true, true, true);
		}
	}

	public static function launchWebServer(path:String, port:Int = 3000, openBrowser:Bool = true):Int
	{
		Log.info("", " - \x1b[1mStarting local web server:\x1b[0m http://localhost:" + port);

		var args = ["run", "http-server", path, "-p", Std.string(port), "-c-1", "--cors"];

		if (!openBrowser && !Log.verbose)
		{
			Log.info("\x1b[1mStarting local web server:\x1b[0m http://localhost:" + port);
		}
		else
		{
			args.push("-o");
		}

		if (!Log.verbose)
		{
			args.push("--silent");
		}

		return Haxelib.runCommand("", args);
	}

	public static function minifyJS(sourceFile:String, sourceMap:Bool = false):Bool
	{
		if (FileSystem.exists(sourceFile))
		{
			var tempFile = System.getTemporaryFile(".js");

			// if (project.targetFlags.exists ("yui")) {

			// 	var templatePaths = [ Path.combine (Haxelib.getPath (new Haxelib (#if lime "lime" #else "hxp" #end)), #if lime "templates" #else "" #end) ].concat (project.templatePaths);
			// 	System.runCommand ("", "java", [ "-Dapple.awt.UIElement=true", "-jar", System.findTemplate (templatePaths, "bin/yuicompressor-2.4.7.jar"), "-o", tempFile, sourceFile ]);

			// } else {

			var templatePaths = [
				Path.combine(Haxelib.getPath(new Haxelib(#if lime "lime" #else "hxp" #end)), #if lime "templates" #else "" #end)
			];
			var args = [
				"-Dapple.awt.UIElement=true",
				"-jar",
				System.findTemplate(templatePaths, "bin/compiler.jar"),
				"--strict_mode_input",
				"false",
				"--js",
				sourceFile,
				"--js_output_file",
				tempFile
			];

			// if (project.targetFlags.exists ("advanced")) {

			// 	args.push ("--compilation_level");
			// 	args.push ("ADVANCED_OPTIMIZATIONS");

			// }

			if (FileSystem.exists(sourceFile + ".map") || sourceMap)
			{
				// if an input .js.map exists closure automatically detects it (from sourceMappingURL)
				// --source_map_location_mapping adds file:// to paths (similarly to haxe's .js.map)

				args.push("--create_source_map");
				args.push(tempFile + ".map");
				args.push("--source_map_location_mapping");
				args.push("/|file:///");
			}

			if (!Log.verbose)
			{
				args.push("--jscomp_off=uselessCode");
			}

			System.runCommand("", "java", args);

			if (FileSystem.exists(tempFile + ".map"))
			{
				// closure does not include a sourceMappingURL in the created .js, we do it here
				#if !nodejs
				var f = File.append(tempFile);
				f.writeString("//# sourceMappingURL=" + StringTools.urlEncode(Path.withoutDirectory(sourceFile)) + ".map");
				f.close();
				#end

				File.copy(tempFile + ".map", sourceFile + ".map");
				FileSystem.deleteFile(tempFile + ".map");
			}

			// }

			FileSystem.deleteFile(sourceFile);
			File.copy(tempFile, sourceFile);
			FileSystem.deleteFile(tempFile);

			return true;
		}

		return false;
	}
}
