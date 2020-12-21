package hxp;

import haxe.io.Path in HaxePath;
import sys.FileSystem;

class Path extends HaxePath
{
	public function new(path:String)
	{
		super(path);
	}

	public static function addTrailingSlash(path:String):String
	{
		return HaxePath.addTrailingSlash(path);
	}

	public static function combine(firstPath:String, secondPath:String):String
	{
		if (firstPath == null || firstPath == "")
		{
			return secondPath;
		}
		else if (secondPath != null && secondPath != "")
		{
			if (System.hostPlatform == WINDOWS)
			{
				if (secondPath.indexOf(":") == 1)
				{
					return secondPath;
				}
			}
			else
			{
				if (secondPath.substr(0, 1) == "/")
				{
					return secondPath;
				}
			}

			var firstSlash = (firstPath.substr(-1) == "/" || firstPath.substr(-1) == "\\");
			var secondSlash = (secondPath.substr(0, 1) == "/" || secondPath.substr(0, 1) == "\\");

			if (firstSlash && secondSlash)
			{
				return firstPath + secondPath.substr(1);
			}
			else if (!firstSlash && !secondSlash)
			{
				return firstPath + "/" + secondPath;
			}
			else
			{
				return firstPath + secondPath;
			}
		}
		else
		{
			return firstPath;
		}
	}

	public static function directory(path:String):String
	{
		return HaxePath.directory(path);
	}

	public static function escape(path:String):String
	{
		if (System.hostPlatform != WINDOWS)
		{
			path = StringTools.replace(path, "\\ ", " ");
			path = StringTools.replace(path, " ", "\\ ");
			path = StringTools.replace(path, "\\'", "'");
			path = StringTools.replace(path, "'", "\\'");
		}
		else
		{
			path = StringTools.replace(path, "^,", ",");
			path = StringTools.replace(path, ",", "^,");
			path = StringTools.replace(path, "^ ", " ");
			path = StringTools.replace(path, " ", "^ ");
		}

		return expand(path);
	}

	public static function expand(path:String):String
	{
		if (path == null)
		{
			path = "";
		}

		if (System.hostPlatform != WINDOWS)
		{
			if (StringTools.startsWith(path, "~/"))
			{
				path = Sys.getEnv("HOME") + "/" + path.substr(2);
			}
		}

		return path;
	}

	public static function extension(path:String):String
	{
		return HaxePath.extension(path);
	}

	public static function isAbsolute(path:String):Bool
	{
		if (StringTools.startsWith(path, "/") || StringTools.startsWith(path, "\\"))
		{
			return true;
		}

		return false;
	}

	public static function isRelative(path:String):Bool
	{
		return !isAbsolute(path);
	}

	public static function join(paths:Array<String>):String
	{
		var result = "";
		for (path in paths)
		{
			result = combine(result, path);
		}
		return result;
	}

	public static function normalize(path:String):String
	{
		return HaxePath.normalize(path);
	}

	public static function relocatePath(path:String, targetDirectory:String):String
	{
		// this should be improved for target directories that are outside the current working path

		if (isAbsolute(path) || targetDirectory == "")
		{
			return path;
		}
		else if (isAbsolute(targetDirectory))
		{
			return combine(Sys.getCwd(), path);
		}
		else
		{
			targetDirectory = StringTools.replace(targetDirectory, "\\", "/");

			var splitTarget = targetDirectory.split("/");
			var directories = 0;

			while (splitTarget.length > 0)
			{
				switch (splitTarget.shift())
				{
					case ".", "":

					// ignore

					case "..":
						directories--;

					default:
						directories++;
				}
			}

			var adjust = "";

			for (i in 0...directories)
			{
				adjust += "../";
			}

			return adjust + path;
		}
	}

	public static function relocatePaths(paths:Array<String>, targetDirectory:String):Array<String>
	{
		var relocatedPaths = paths.copy();

		for (i in 0...paths.length)
		{
			relocatedPaths[i] = relocatePath(paths[i], targetDirectory);
		}

		return relocatedPaths;
	}

	public static function removeTrailingSlashes(path:String):String
	{
		return HaxePath.removeTrailingSlashes(path);
	}

	public static function safeFileName(name:String):String
	{
		// TODO: Improve this method

		var safeName = StringTools.replace(name, " ", "");
		return safeName;
	}

	public static function standardize(path:String, trailingSlash:Bool = false):String
	{
		if (path == null) return null;

		path = StringTools.replace(path, "\\", "/");
		path = StringTools.replace(path, "//", "/");
		path = StringTools.replace(path, "//", "/");

		if (!trailingSlash && StringTools.endsWith(path, "/"))
		{
			path = path.substr(0, path.length - 1);
		}
		else if (trailingSlash && !StringTools.endsWith(path, "/"))
		{
			path += "/";
		}

		if (System.hostPlatform == WINDOWS && path.charAt(1) == ":")
		{
			path = path.charAt(0).toUpperCase() + ":" + path.substr(2);
		}

		return path;
	}

	public static function startsWith(path:String, prefix:String):Bool
	{
		return StringTools.startsWith(normalize(path), normalize(prefix));
	}

	public static function tryFullPath(path:String):String
	{
		try
		{
			return FileSystem.fullPath(path);
		}
		catch (e:Dynamic)
		{
			return expand(path);
		}
	}

	public static function withExtension(path:String, ext:String):String
	{
		return HaxePath.withExtension(path, ext);
	}

	public static function withoutDirectory(path:String):String
	{
		return HaxePath.withoutDirectory(path);
	}

	public static function withoutExtension(path:String):String
	{
		return HaxePath.withoutExtension(path);
	}
}
