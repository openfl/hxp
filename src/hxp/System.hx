package hxp;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.io.Eof;
import haxe.zip.Entry;
import haxe.zip.Writer;
import haxe.Json;
import haxe.Template;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;

class System
{
	public static var dryRun:Bool = false;
	public static var hostArchitecture(get, never):HostArchitecture;
	public static var hostPlatform(get, never):HostPlatform;
	public static var processorCores(get, never):Int;
	private static var _haxeVersion:String;
	private static var _hostArchitecture:HostArchitecture;
	private static var _hostPlatform:HostPlatform;
	private static var _isText:Map<String, Bool>;
	private static var _processorCores:Int = 0;

	private static function __init__():Void
	{
		// @formatter:off
		_isText = [
			"jpg" => false,
			"jpeg" => false,
			"png" => false,
			"gif" => false,
			"webp" => false,
			"bmp" => false,
			"tiff" => false,
			"jfif" => false,
			"otf" => false,
			"ttf" => false,
			"wav" => false,
			"wave" => false,
			"mp3" => false,
			"mp2" => false,
			"exe" => false,
			"bin" => false,
			"so" => false,
			"pch" => false,
			"dll" => false,
			"zip" => false,
			"tar" => false,
			"gz" => false,
			"fla" => false,
			"swf" => false,
			"atf" => false,
			"psd" => false,
			"awd" => false,

			"txt" => true,
			"text" => true,
			"xml" => true,
			"java" => true,
			"hx" => true,
			"cpp" => true,
			"c" => true,
			"h" => true,
			"cs" => true,
			"js" => true,
			"mm" => true,
			"hxml" => true,
			"html" => true,
			"json" => true,
			"css" => true,
			"gpe" => true,
			"pbxproj" => true,
			"plist" => true,
			"properties" => true,
			"ini" => true,
			"hxproj" => true,
			"nmml" => true,
			"lime" => true,
			"svg" => true,
		];
		// @formatter:on
	}

	public static function compress(path:String, targetPath:String = ""):Void
	{
		#if nodejs
		throw "Unimplemented File.write";
		#else
		if (targetPath == "")
		{
			targetPath = path;
		}

		System.mkdir(Path.directory(targetPath));

		if (hostPlatform == WINDOWS || !FileSystem.isDirectory(path))
		{
			var files = new List<Entry>();

			if (FileSystem.isDirectory(path))
			{
				_readDirectory(path, "", files);
			}
			else
			{
				_readFile(path, "", files);
			}

			var output = File.write(targetPath, true);

			/*if (Path.extension (path) == "crx") {

				var input = File.read (defines.get ("KEY_STORE"), true);
				var publicKey:Bytes = input.readAll ();
				input.close ();

				var signature = SHA1.encode ("this isn't working");

				output.writeString ("Cr24"); // magic number
				output.writeInt32 (Int32.ofInt (2)); // CRX file format version
				output.writeInt32 (Int32.ofInt (publicKey.length)); // public key length
				output.writeInt32 (Int32.ofInt (signature.length)); // signature length
				output.writeBytes (publicKey, 0, publicKey.length);
				output.writeString (signature);

				//output.writeBytes (); // public key contents "The contents of the author's RSA public key, formatted as an X509 SubjectPublicKeyInfo block. "
				//output.writeBytes (); // "The signature of the ZIP content using the author's private key. The signature is created using the RSA algorithm with the SHA-1 hash function."

			}*/

			Log.info("", " - \x1b[1mWriting file:\x1b[0m " + targetPath);

			var writer = new Writer(output);
			writer.write(cast files);
			output.close();
		}
		else
		{
			runCommand(path, "zip", ["-r", Path.relocatePath(targetPath, path), "./"]);
		}
		#end
	}

	private static function _readDirectory(basePath:String, path:String, files:List<Entry>):Void
	{
		var directory = Path.combine(basePath, path);

		for (file in FileSystem.readDirectory(directory))
		{
			var fullPath = Path.combine(directory, file);
			var childPath = Path.combine(path, file);

			if (FileSystem.isDirectory(fullPath))
			{
				_readDirectory(basePath, childPath, files);
			}
			else
			{
				_readFile(basePath, childPath, files);
			}
		}
	}

	private static function _readFile(basePath:String, path:String, files:List<Entry>):Void
	{
		if (Path.extension(path) != "zip" && Path.extension(path) != "crx" && Path.extension(path) != "wgt")
		{
			var fullPath = Path.combine(basePath, path);

			var name = path;
			// var date = FileSystem.stat (directory + "/" + file).ctime;
			var date = Date.now();

			Log.info("", " - \x1b[1mCompressing file:\x1b[0m " + fullPath);

			var input = File.read(fullPath, true);
			var data = input.readAll();
			input.close();

			var entry:Entry =
				{
					fileName: name,
					fileSize: data.length,
					fileTime: date,
					compressed: false,
					dataSize: data.length,
					data: data,
					crc32: null
				};

			files.push(entry);
		}
	}

	// TODO: Always copy
	public static function copyFile(source:String, destination:String, context:Dynamic = null, process:Bool = true)
	{
		var extension = Path.extension(source);

		if (process && context != null)
		{
			if (_isText.exists(extension) && !_isText.get(extension))
			{
				copyIfNewer(source, destination);
				return;
			}

			var textFile = false;

			if (_isText.exists(extension) && _isText.get(extension))
			{
				textFile = true;
			}
			else
			{
				textFile = isText(source);
			}

			if (textFile)
			{
				// Log.info ("", " - \x1b[1mProcessing template file:\x1b[0m " + source + " \x1b[3;37m->\x1b[0m " + destination);

				var fileContents:String = File.getContent(source);
				var template:Template = new Template(fileContents);
				var result:String = template.execute(context,
					{
						toJSON: function(_, s) return Json.stringify(s),
						upper: function(_, s) return s.toUpperCase(),
						replace: function(_, s, sub, by) return StringTools.replace(s, sub, by)
					});

				try
				{
					if (FileSystem.exists(destination))
					{
						var existingContent = File.getContent(destination);
						if (result == existingContent) return;
					}
				}
				catch (e:Dynamic) {}

				System.mkdir(Path.directory(destination));

				Log.info("", " - \x1b[1mCopying template file:\x1b[0m " + source + " \x1b[3;37m->\x1b[0m " + destination);

				try
				{
					File.saveContent(destination, result);
				}
				catch (e:Dynamic)
				{
					Log.error("Cannot write to file \"" + destination + "\"");
				}

				return;
			}
		}

		copyIfNewer(source, destination);
	}

	public static function copyFileTemplate(templatePaths:Array<String>, source:String, destination:String, context:Dynamic = null, process:Bool = true,
			warnIfNotFound:Bool = true)
	{
		var path = System.findTemplate(templatePaths, source, warnIfNotFound);

		if (path != null)
		{
			copyFile(path, destination, context, process);
		}
	}

	public static function copyIfNewer(source:String, destination:String)
	{
		// allFiles.push (destination);

		if (!isNewer(source, destination))
		{
			return;
		}

		System.mkdir(Path.directory(destination));

		Log.info("", " - \x1b[1mCopying file:\x1b[0m " + source + " \x1b[3;37m->\x1b[0m " + destination);

		try
		{
			File.copy(source, destination);
		}
		catch (e:Dynamic)
		{
			try
			{
				if (FileSystem.exists(destination))
				{
					Log.error("Cannot copy to \"" + destination + "\", is the file in use?");
					return;
				}
				else {}
			}
			catch (e:Dynamic) {}

			Log.error("Cannot open \"" + destination + "\" for writing, do you have correct access permissions?");
		}
	}

	public static function findTemplate(templatePaths:Array<String>, path:String, warnIfNotFound:Bool = true):String
	{
		var matches = findTemplates(templatePaths, path, warnIfNotFound);

		if (matches.length > 0)
		{
			return matches[matches.length - 1];
		}

		return null;
	}

	public static function findTemplateRecursive(templatePaths:Array<String>, path:String, warnIfNotFound:Bool = true,
			destinationPaths:Array<String> = null):Array<String>
	{
		var paths = findTemplates(templatePaths, path, warnIfNotFound);
		if (paths.length == 0) return null;

		try
		{
			if (FileSystem.isDirectory(paths[0]))
			{
				var templateFiles = new Array<String>();
				var templateMatched = new Map<String, Bool>();

				paths.reverse();

				findTemplateRecursive_(paths, "", templateFiles, templateMatched, destinationPaths);
				return templateFiles;
			}
		}
		catch (e:Dynamic) {}

		paths.splice(0, paths.length - 1);

		if (destinationPaths != null)
		{
			destinationPaths.push(paths[0]);
		}

		return paths;
	}

	public static function deleteFile(path:String)
	{
		try
		{
			if (FileSystem.exists(path) && !FileSystem.isDirectory(path))
			{
				Log.info("", " - \x1b[1mDeleting file:\x1b[0m " + path);
				FileSystem.deleteFile(path);
			}
		}
		catch (e:Dynamic) {}
	}

	private static function findTemplateRecursive_(templatePaths:Array<String>, source:String, templateFiles:Array<String>, templateMatched:Map<String, Bool>,
			destinationPaths:Array<String>):Void
	{
		var files:Array<String>;

		for (templatePath in templatePaths)
		{
			try
			{
				files = FileSystem.readDirectory(Path.combine(templatePath, source));

				for (file in files)
				{
					// if (file.substr (0, 1) != ".") {

					var itemSource = Path.combine(source, file);

					if (!templateMatched.exists(itemSource))
					{
						templateMatched.set(itemSource, true);
						var path = Path.combine(templatePath, itemSource);

						if (FileSystem.isDirectory(path))
						{
							findTemplateRecursive_(templatePaths, itemSource, templateFiles, templateMatched, destinationPaths);
						}
						else
						{
							templateFiles.push(path);

							if (destinationPaths != null)
							{
								destinationPaths.push(itemSource);
							}
						}
					}

					// }
				}
			}
			catch (e:Dynamic) {}
		}
	}

	public static function findTemplates(templatePaths:Array<String>, path:String, warnIfNotFound:Bool = true):Array<String>
	{
		var matches = [];

		for (templatePath in templatePaths)
		{
			var targetPath = Path.combine(templatePath, path);

			if (FileSystem.exists(targetPath))
			{
				matches.push(targetPath);
			}
		}

		if (matches.length == 0 && warnIfNotFound)
		{
			Log.warn("Could not find template file: " + path);
		}

		return matches;
	}

	public static function getLastModified(source:String):Float
	{
		if (FileSystem.exists(source))
		{
			return FileSystem.stat(source).mtime.getTime();
		}

		return -1;
	}

	public static function getTemporaryDirectory():String
	{
		var path = getTemporaryFile();
		mkdir(path);
		return path;
	}

	public static function getTemporaryFile(extension:String = ""):String
	{
		var path = "";

		if (System.hostPlatform == WINDOWS)
		{
			path = Sys.getEnv("TEMP");
		}
		else
		{
			path = Sys.getEnv("TMPDIR");

			if (path == null)
			{
				path = "/tmp";
			}
		}

		path = Path.combine(path, "temp_" + Math.round(0xFFFFFF * Math.random()) + extension);

		if (FileSystem.exists(path))
		{
			return getTemporaryFile(extension);
		}

		return path;
	}

	public static function isNewer(source:String, destination:String):Bool
	{
		if (source == null || !FileSystem.exists(source))
		{
			Log.error("Source path \"" + source + "\" does not exist");
			return false;
		}

		if (FileSystem.exists(destination))
		{
			if (FileSystem.stat(source).mtime.getTime() < FileSystem.stat(destination).mtime.getTime())
			{
				return false;
			}
		}

		return true;
	}

	public static function isText(source:String):Bool
	{
		if (!FileSystem.exists(source))
		{
			return false;
		}

		var input = File.read(source, true);

		var numChars = 0;
		var numBytes = 0;
		var byteHeader = [];
		var zeroBytes = 0;

		try
		{
			while (numBytes < 512)
			{
				var byte = input.readByte();

				if (numBytes < 3)
				{
					byteHeader.push(byte);
				}
				else if (byteHeader != null)
				{
					if (byteHeader[0] == 0xFF && byteHeader[1] == 0xFE) return true; // UCS-2LE or UTF-16LE
					if (byteHeader[0] == 0xFE && byteHeader[1] == 0xFF) return true; // UCS-2BE or UTF-16BE
					if (byteHeader[0] == 0xEF && byteHeader[1] == 0xBB && byteHeader[2] == 0xBF) return true; // UTF-8
					byteHeader = null;
				}

				numBytes++;

				if (byte == 0)
				{
					zeroBytes++;
				}

				if ((byte > 8 && byte < 16) || (byte > 32 && byte < 256) || byte > 287)
				{
					numChars++;
				}
			}
		}
		catch (e:Dynamic) {}

		input.close();

		if (numBytes == 0 || (numChars / numBytes) > 0.9 || ((zeroBytes / numBytes) < 0.015 && (numChars / numBytes) > 0.5))
		{
			return true;
		}

		return false;
	}

	public static function linkFile(source:String, destination:String, symbolic:Bool = true, overwrite:Bool = false)
	{
		if (!isNewer(source, destination))
		{
			return;
		}

		if (FileSystem.exists(destination))
		{
			FileSystem.deleteFile(destination);
		}

		if (!FileSystem.exists(destination))
		{
			try
			{
				var command = "/bin/ln";
				var args = [];

				if (symbolic)
				{
					args.push("-s");
				}

				if (overwrite)
				{
					args.push("-f");
				}

				args.push(source);
				args.push(destination);

				System.runCommand(".", command, args);
			}
			catch (e:Dynamic) {}
		}
	}

	public static function makeDirectory(directory:String):Void
	{
		mkdir(directory);
	}

	public static function mkdir(directory:String):Void
	{
		try
		{
			if (FileSystem.exists(directory) && FileSystem.isDirectory(directory))
			{
				return;
			}
		}
		catch (e:Dynamic) {}

		directory = StringTools.replace(directory, "\\", "/");
		var total = "";

		if (directory.substr(0, 1) == "/")
		{
			total = "/";
		}

		var parts = directory.split("/");
		var oldPath = "";

		if (parts.length > 0 && parts[0].indexOf(":") > -1)
		{
			try
			{
				oldPath = Sys.getCwd();
				Sys.setCwd(parts[0] + "\\");
				parts.shift();
			}
			catch (e:Dynamic)
			{
				Log.error("Cannot create directory \"" + directory + "\"");
			}
		}

		for (part in parts)
		{
			if (part != "." && part != "")
			{
				if (total != "" && total != "/")
				{
					total += "/";
				}

				total += part;

				if (FileSystem.exists(total) && !FileSystem.isDirectory(total))
				{
					Log.info("", " - \x1b[1mRemoving file:\x1b[0m " + total);

					FileSystem.deleteFile(total);
				}

				if (!FileSystem.exists(total))
				{
					Log.info("", " - \x1b[1mCreating directory:\x1b[0m " + total);

					FileSystem.createDirectory(total);
				}
			}
		}

		if (oldPath != "")
		{
			Sys.setCwd(oldPath);
		}
	}

	public static function openFile(workingDirectory:String, targetPath:String, executable:String = ""):Void
	{
		if (executable == null)
		{
			executable = "";
		}

		if (hostPlatform == WINDOWS)
		{
			var args = [];

			if (executable == "")
			{
				executable = "cmd";
				args = ["/c"];
			}

			if (targetPath.indexOf(":\\") == -1)
			{
				runCommand(workingDirectory, executable, args.concat([targetPath]));
			}
			else
			{
				runCommand(workingDirectory, executable, args.concat([".\\" + targetPath]));
			}
		}
		else if (hostPlatform == MAC)
		{
			if (executable == "")
			{
				executable = "/usr/bin/open";
			}

			if (targetPath.substr(0, 1) == "/")
			{
				runCommand(workingDirectory, executable, ["-W", targetPath]);
			}
			else
			{
				runCommand(workingDirectory, executable, ["-W", "./" + targetPath]);
			}
		}
		else
		{
			if (executable == "")
			{
				executable = "/usr/bin/xdg-open";
			}

			if (targetPath.substr(0, 1) == "/")
			{
				runCommand(workingDirectory, executable, [targetPath]);
			}
			else
			{
				runCommand(workingDirectory, executable, ["./" + targetPath]);
			}
		}
	}

	public static function openURL(url:String):Void
	{
		if (hostPlatform == WINDOWS)
		{
			runCommand("", "start", [url]);
		}
		else if (hostPlatform == MAC)
		{
			runCommand("", "/usr/bin/open", [url]);
		}
		else
		{
			runCommand("", "/usr/bin/xdg-open", [url, "&"]);
		}
	}

	public static function readBytes(source:String):Bytes
	{
		return File.getBytes(source);
	}

	public static function readDirectory(directory:String, ignore:Array<String> = null, paths:Array<String> = null):Array<String>
	{
		if (FileSystem.exists(directory))
		{
			if (paths == null)
			{
				paths = [];
			}

			var files;

			try
			{
				files = FileSystem.readDirectory(directory);
			}
			catch (e:Dynamic)
			{
				return paths;
			}

			for (file in FileSystem.readDirectory(directory))
			{
				if (ignore != null)
				{
					var filtered = false;

					for (filter in ignore)
					{
						if (filter == file)
						{
							filtered = true;
						}
					}

					if (filtered) continue;
				}

				var path = directory + "/" + file;

				try
				{
					if (FileSystem.isDirectory(path))
					{
						readDirectory(path, ignore, paths);
					}
					else
					{
						paths.push(path);
					}
				}
				catch (e:Dynamic)
				{
					return paths;
				}
			}

			return paths;
		}

		return null;
	}

	public static function readText(source:String):String
	{
		return File.getContent(source);
	}

	public static function recursiveCopy(source:String, destination:String, context:Dynamic = null, process:Bool = true)
	{
		System.mkdir(destination);

		var files:Array<String> = null;

		try
		{
			files = FileSystem.readDirectory(source);
		}
		catch (e:Dynamic)
		{
			Log.error("Could not find source directory \"" + source + "\"");
		}

		for (file in files)
		{
			if (file.substr(0, 1) != ".")
			{
				var itemDestination:String = destination + "/" + file;
				var itemSource:String = source + "/" + file;

				if (FileSystem.isDirectory(itemSource))
				{
					recursiveCopy(itemSource, itemDestination, context, process);
				}
				else
				{
					copyFile(itemSource, itemDestination, context, process);
				}
			}
		}
	}

	public static function recursiveCopyTemplate(templatePaths:Array<String> = null, source:String, destination:String, context:Dynamic = null,
			process:Bool = true, warnIfNotFound:Bool = true)
	{
		var destinations = [];
		var paths = System.findTemplateRecursive(templatePaths, source, warnIfNotFound, destinations);

		if (paths != null)
		{
			System.mkdir(destination);
			var itemDestination;

			for (i in 0...paths.length)
			{
				itemDestination = Path.combine(destination, destinations[i]);
				copyFile(paths[i], itemDestination, context, process);
			}
		}
	}

	public static function removeDirectory(directory:String):Void
	{
		if (FileSystem.exists(directory))
		{
			var files;

			try
			{
				files = FileSystem.readDirectory(directory);
			}
			catch (e:Dynamic)
			{
				return;
			}

			for (file in FileSystem.readDirectory(directory))
			{
				var path = directory + "/" + file;

				try
				{
					if (FileSystem.isDirectory(path))
					{
						removeDirectory(path);
					}
					else
					{
						FileSystem.deleteFile(path);
					}
				}
				catch (e:Dynamic) {}
			}

			Log.info("", " - \x1b[1mRemoving directory:\x1b[0m " + directory);

			try
			{
				FileSystem.deleteDirectory(directory);
			}
			catch (e:Dynamic) {}
		}
	}

	public static function renameFile(source:String, destination:String)
	{
		System.mkdir(Path.directory(destination));
		Log.info("", " - \x1b[1mRenaming file:\x1b[0m " + source + " \x1b[3;37m->\x1b[0m " + destination);

		try
		{
			File.copy(source, destination);
		}
		catch (e:Dynamic)
		{
			try
			{
				if (FileSystem.exists(destination))
				{
					Log.error("Cannot copy to \"" + destination + "\", is the file in use?");
					return;
				}
			}
			catch (e:Dynamic) {}
		}

		try
		{
			FileSystem.deleteFile(source);
		}
		catch (e:Dynamic) {}
	}

	public static function replaceText(sourcePath:String, replaceString:String, replacement:String)
	{
		if (FileSystem.exists(sourcePath))
		{
			var output = File.getContent(sourcePath);

			var index = output.indexOf(replaceString);

			if (index > -1)
			{
				output = output.substr(0, index) + replacement + output.substr(index + replaceString.length);
				File.saveContent(sourcePath, output);
			}
		}
	}

	public static function runCommand(path:String, command:String, args:Array<String> = null, safeExecute:Bool = true, ignoreErrors:Bool = false,
			print:Bool = false):Int
	{
		if (print)
		{
			var message = command;

			if (args != null)
			{
				for (arg in args)
				{
					if (arg.indexOf(" ") > -1)
					{
						message += " \"" + arg + "\"";
					}
					else
					{
						message += " " + arg;
					}
				}
			}

			Sys.println(message);
		}

		#if (haxe_ver < "3.3.0")
		if (args != null && hostPlatform == WINDOWS)
		{
			command = Path.escape(command);
		}
		#end

		if (safeExecute)
		{
			try
			{
				if (path != null
					&& path != ""
					&& !FileSystem.exists(FileSystem.fullPath(path))
					&& !FileSystem.exists(FileSystem.fullPath(new Path(path).dir)))
				{
					Log.error("The specified target path \"" + path + "\" does not exist");
					return 1;
				}

				return _runCommand(path, command, args);
			}
			catch (e:Dynamic)
			{
				if (!ignoreErrors)
				{
					Log.error("", e);
					return 1;
				}

				return 0;
			}
		}
		else
		{
			return _runCommand(path, command, args);
		}
	}

	private static function _runCommand(path:String, command:String, args:Null<Array<String>>):Int
	{
		var oldPath:String = "";

		if (path != null && path != "")
		{
			Log.info("", " - \x1b[1mChanging directory:\x1b[0m " + path + "");

			if (!dryRun)
			{
				oldPath = Sys.getCwd();
				Sys.setCwd(path);
			}
		}

		var argString = "";

		if (args != null)
		{
			for (arg in args)
			{
				if (arg.indexOf(" ") > -1)
				{
					argString += " \"" + arg + "\"";
				}
				else
				{
					argString += " " + arg;
				}
			}
		}

		Log.info("", " - \x1b[1mRunning command:\x1b[0m " + command + argString);

		var result = 0;

		if (!dryRun)
		{
			if (args != null && args.length > 0)
			{
				result = Sys.command(command, args);
			}
			else
			{
				result = Sys.command(command);
			}

			if (oldPath != "")
			{
				Sys.setCwd(oldPath);
			}
		}

		if (result != 0)
		{
			throw("Error running: " + command + (args != null ? " " + args.join(" ") : "") + " [" + path + "]");
		}

		return result;
	}

	public static function runProcess(path:String, command:String, args:Array<String> = null, waitForOutput:Bool = true, safeExecute:Bool = true,
			ignoreErrors:Bool = false, print:Bool = false, returnErrorValue:Bool = false):String
	{
		if (print)
		{
			var message = command;

			if (args != null)
			{
				for (arg in args)
				{
					if (arg.indexOf(" ") > -1)
					{
						message += " \"" + arg + "\"";
					}
					else
					{
						message += " " + arg;
					}
				}
			}

			Sys.println(message);
		}

		#if (haxe_ver < "3.3.0")
		command = Path.escape(command);
		#end

		if (safeExecute)
		{
			try
			{
				if (path != null
					&& path != ""
					&& !FileSystem.exists(FileSystem.fullPath(path))
					&& !FileSystem.exists(FileSystem.fullPath(new Path(path).dir)))
				{
					Log.error("The specified target path \"" + path + "\" does not exist");
				}

				return _runProcess(path, command, args, waitForOutput, safeExecute, ignoreErrors, returnErrorValue);
			}
			catch (e:Dynamic)
			{
				if (!ignoreErrors)
				{
					Log.error("", e);
				}

				return null;
			}
		}
		else
		{
			return _runProcess(path, command, args, waitForOutput, safeExecute, ignoreErrors, returnErrorValue);
		}
	}

	private static function _runProcess(path:String, command:String, args:Null<Array<String>>, waitForOutput:Bool, safeExecute:Bool, ignoreErrors:Bool,
			returnErrorValue:Bool):String
	{
		var oldPath:String = "";

		if (path != null && path != "")
		{
			Log.info("", " - \x1b[1mChanging directory:\x1b[0m " + path + "");

			if (!dryRun)
			{
				oldPath = Sys.getCwd();
				Sys.setCwd(path);
			}
		}

		var argString = "";

		if (args != null)
		{
			for (arg in args)
			{
				if (arg.indexOf(" ") > -1)
				{
					argString += " \"" + arg + "\"";
				}
				else
				{
					argString += " " + arg;
				}
			}
		}

		Log.info("", " - \x1b[1mRunning process:\x1b[0m " + command + argString);

		var output = "";
		var result = 0;

		if (!dryRun)
		{
			var process:Process;

			if (args != null && args.length > 0)
			{
				process = new Process(command, args);
			}
			else
			{
				process = new Process(command);
			}

			if (waitForOutput)
			{
				var buffer = new BytesOutput();
				var waiting = true;

				while (waiting)
				{
					try
					{
						var current = process.stdout.readAll(1024);
						buffer.write(current);

						if (current.length == 0)
						{
							waiting = false;
						}
					}
					catch (e:Eof)
					{
						waiting = false;
					}
				}

				result = process.exitCode();

				output = buffer.getBytes().toString();

				if (output == "")
				{
					var error = process.stderr.readAll().toString();
					process.close();

					if (result != 0 || error != "")
					{
						if (ignoreErrors)
						{
							output = error;
						}
						else if (!safeExecute)
						{
							throw error;
						}
						else
						{
							Log.error(error);
						}

						if (returnErrorValue)
						{
							return output;
						}
						else
						{
							return null;
						}
					}

					/*if (error != "") {

						Log.error (error);

					}*/
				}
				else
				{
					process.close();
				}
			}

			if (oldPath != "")
			{
				Sys.setCwd(oldPath);
			}
		}

		return output;
	}

	public static function runScript(path:String, buildArgs:Array<String>, runArgs:Array<String> = null, workingDirectory = null):Int
	{
		var tempDirectory = System.getTemporaryDirectory();
		System.mkdir(tempDirectory);

		var script = Path.withoutExtension(Path.withoutDirectory(path));
		script = script.substr(0, 1).toUpperCase() + script.substr(1);
		var scriptFile = Path.combine(tempDirectory, script + ".hx");

		var sourcePath = Path.directory(path);
		var args = ["-cp", tempDirectory, "-cp", Path.tryFullPath(sourcePath)].concat(buildArgs);
		var input = File.read(path, false);
		var tag = "@:compiler(";

		try
		{
			while (true)
			{
				var line = input.readLine();

				if (StringTools.startsWith(line, tag))
				{
					args.push(line.substring(tag.length + 1, line.length - 2));
				}
			}
		}
		catch (ex:Eof) {}

		input.close();

		System.copyFile(path, scriptFile);

		// if (_haxeVersion == null) {

		// 	try {

		// 		var process = new Process ("haxe", [ "-version" ]);
		// 		_haxeVersion = StringTools.trim (process.stderr.readAll ().toString ());

		// 		if (_haxeVersion == "") {

		// 			_haxeVersion = StringTools.trim (process.stdout.readAll ().toString ());

		// 		}

		// 		process.close ();

		// 	} catch (e:Dynamic) {

		// 		_haxeVersion = "";

		// 	}

		// }

		// if (Std.parseFloat (_haxeVersion) >= 4) {

		args = args.concat(["-D", "hxp-interp", "--run"]);
		if (runArgs != null)
		{
			args = args.concat(runArgs);
		}
		else
		{
			args.push(script);
		}

		// return runCommand(workingDirectory, "haxe", args, true, false, true);
		return runCommand(workingDirectory, "haxe", args);

		// } else {

		// 	var nekoOutput = Path.combine (tempDirectory, "script.n");

		// 	args = args.concat ([ "-D", "hxp-interp", "-neko", nekoOutput ]);
		// 	var result = runCommand (workingDirectory, "haxe", args);

		// 	if (result != 0) return result;

		// 	if (FileSystem.exists (nekoOutput)) {
		// 		result = runCommand (workingDirectory, "neko", [ nekoOutput ].concat (runArgs != null ? runArgs : []));
		// 	}

		// 	return result;

		// }
	}

	public static function watch(command:String, directories:Array<String>):Void
	{
		var suffix = switch (hostPlatform)
		{
			case WINDOWS: "-windows.exe";
			case MAC: "-mac";
			case LINUX: "-linux";
			default: return;
		}

		if (suffix == "-linux")
		{
			if (hostArchitecture == X86)
			{
				suffix += "32";
			}
			else
			{
				suffix += "64";
			}
		}

		#if lime
		var templatePaths = [Path.combine(Haxelib.getPath(new Haxelib("lime")), "templates")];
		var node = System.findTemplate(templatePaths, "bin/node/node" + suffix);
		var bin = System.findTemplate(templatePaths, "bin/node/watch/cli-custom.js");
		#else
		// TODO: Move to separate lib?
		var nodeTemplatePath = [Path.combine(Haxelib.getPath(new Haxelib("http-server")), "bin")];
		var watchTemplatePath = [Path.combine(Haxelib.getPath(new Haxelib("hxp")), "bin")];
		var node = System.findTemplate(nodeTemplatePath, "node" + suffix);
		var bin = System.findTemplate(watchTemplatePath, "node/watch/cli-custom.js");
		#end

		if (System.hostPlatform != WINDOWS)
		{
			Sys.command("chmod", ["+x", node]);
		}

		var args = [bin, command];
		args = args.concat(directories);

		args.push("--exit");
		args.push("--ignoreDotFiles");
		args.push("--ignoreUnreadable");

		System.runCommand("", node, args);
	}

	public static function writeBytes(bytes:Bytes, path:String):Void
	{
		File.saveBytes(path, bytes);
	}

	public static function writeText(text:String, path:String):Void
	{
		File.saveContent(path, text);
	}

	// Get & Set Methods

	private static function get_hostArchitecture():HostArchitecture
	{
		if (_hostArchitecture == null)
		{
			switch (hostPlatform)
			{
				case WINDOWS:
					var architecture = Sys.getEnv("PROCESSOR_ARCHITECTURE");
					var wow64Architecture = Sys.getEnv("PROCESSOR_ARCHITEW6432");

					if (architecture.indexOf("64") > -1 || wow64Architecture != null && wow64Architecture.indexOf("64") > -1)
					{
						_hostArchitecture = X64;
					}
					else
					{
						_hostArchitecture = X86;
					}

				case LINUX, MAC:
					#if nodejs
					switch (js.Node.process.arch)
					{
						case "arm":
							_hostArchitecture = ARMV7;

						case "x64":
							_hostArchitecture = X64;

						default:
							_hostArchitecture = X86;
					}
					#else
					var process = new Process("uname", ["-m"]);
					var output = process.stdout.readAll().toString();
					var error = process.stderr.readAll().toString();
					process.exitCode();
					process.close();

					if (output.indexOf("armv6") > -1)
					{
						_hostArchitecture = ARMV6;
					}
					else if (output.indexOf("armv7") > -1)
					{
						_hostArchitecture = ARMV7;
					}
					else if (output.indexOf("64") > -1)
					{
						_hostArchitecture = X64;
					}
					else
					{
						_hostArchitecture = X86;
					}
					#end

				default:
					_hostArchitecture = ARMV6;
			}

			Log.info("", " - \x1b[1mDetected host architecture:\x1b[0m " + Std.string(_hostArchitecture).toUpperCase());
		}

		return _hostArchitecture;
	}

	private static function get_hostPlatform():HostPlatform
	{
		if (_hostPlatform == null)
		{
			if (new EReg("window", "i").match(Sys.systemName()))
			{
				_hostPlatform = WINDOWS;
			}
			else if (new EReg("linux", "i").match(Sys.systemName()))
			{
				_hostPlatform = LINUX;
			}
			else if (new EReg("mac", "i").match(Sys.systemName()))
			{
				_hostPlatform = MAC;
			}

			Log.info("", " - \x1b[1mDetected host platform:\x1b[0m " + Std.string(_hostPlatform).toUpperCase());
		}

		return _hostPlatform;
	}

	private static function get_processorCores():Int
	{
		var cacheDryRun = dryRun;
		dryRun = false;

		if (_processorCores < 1)
		{
			var result = null;

			if (hostPlatform == WINDOWS)
			{
				var env = Sys.getEnv("NUMBER_OF_PROCESSORS");

				if (env != null)
				{
					result = env;
				}
			}
			else if (hostPlatform == LINUX)
			{
				result = runProcess("", "nproc", null, true, true, true);

				if (result == null)
				{
					var cpuinfo = runProcess("", "cat", ["/proc/cpuinfo"], true, true, true);

					if (cpuinfo != null)
					{
						var split = cpuinfo.split("processor");
						result = Std.string(split.length - 1);
					}
				}
			}
			else if (hostPlatform == MAC)
			{
				var cores = ~/Total Number of Cores: (\d+)/;
				var output = runProcess("", "/usr/sbin/system_profiler", ["-detailLevel", "full", "SPHardwareDataType"]);

				if (cores.match(output))
				{
					result = cores.matched(1);
				}
			}

			if (result == null || Std.parseInt(result) < 1)
			{
				_processorCores = 1;
			}
			else
			{
				_processorCores = Std.parseInt(result);
			}
		}

		dryRun = cacheDryRun;

		return _processorCores;
	}
}
