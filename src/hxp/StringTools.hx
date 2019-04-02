package hxp;

import haxe.crypto.BaseCode;
import haxe.io.Bytes;
import StringTools in HaxeStringTools;

class StringTools extends HaxeStringTools
{
	#if (haxe_ver >= "3.3")
	public static var winMetaCharacters(get, set):Array<Int>;
	#else
	// https://github.com/HaxeFoundation/haxe/blob/development/std/StringTools.hx
	public static var winMetaCharacters = [
		" ".code, "(".code, ")".code, "%".code, "!".code, "^".code, "\"".code, "<".code, ">".code, "&".code, "|".code, "\n".code, "\r".code, ",".code, ";".code
	];
	#end
	private static var seedNumber = 0;
	private static var base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	private static var base64Encoder:BaseCode;
	private static var usedFlatNames = new Map<String, String>();
	private static var uuidChars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

	public static function base64Decode(base64:String):Bytes
	{
		base64 = StringTools.trim(base64);
		base64 = StringTools.replace(base64, "=", "");

		if (base64Encoder == null)
		{
			base64Encoder = new BaseCode(Bytes.ofString(base64Chars));
		}

		var bytes = base64Encoder.decodeBytes(Bytes.ofString(base64));
		return bytes;
	}

	public static function base64Encode(bytes:Bytes):String
	{
		var extension = switch (bytes.length % 3)
		{
			case 1: "==";
			case 2: "=";
			default: "";
		}

		if (base64Encoder == null)
		{
			base64Encoder = new BaseCode(Bytes.ofString(base64Chars));
		}

		return base64Encoder.encodeBytes(bytes).toString() + extension;
	}

	public static function endsWith(s:String, end:String):Bool
	{
		return HaxeStringTools.endsWith(s, end);
	}

	public static function fastCodeAt(s:String, index:Int):Int
	{
		return HaxeStringTools.fastCodeAt(s, index);
	}

	public static function filter(text:String, include:Array<String> = null, exclude:Array<String> = null):Bool
	{
		if (include == null)
		{
			include = ["*"];
		}

		if (exclude == null)
		{
			exclude = [];
		}

		for (filter in exclude)
		{
			if (filter != "")
			{
				if (filter == "*") return false;
				if (filter.indexOf("*") == filter.length - 1)
				{
					if (StringTools.startsWith(text, filter.substr(0, -1))) return false;
					continue;
				}

				filter = StringTools.replace(filter, ".", "\\.");
				filter = StringTools.replace(filter, "*", ".*");

				var regexp = new EReg("^" + filter + "$", "i");

				if (regexp.match(text))
				{
					return false;
				}
			}
		}

		for (filter in include)
		{
			if (filter != "")
			{
				if (filter == "*") return true;
				if (filter.indexOf("*") == filter.length - 1)
				{
					if (StringTools.startsWith(text, filter.substr(0, -1))) return true;
					continue;
				}

				filter = StringTools.replace(filter, ".", "\\.");
				filter = StringTools.replace(filter, "*", ".*");

				var regexp = new EReg("^" + filter, "i");

				if (regexp.match(text))
				{
					return true;
				}
			}
		}

		return false;
	}

	public static function formatArray(array:Array<Dynamic>):String
	{
		var output = "[ ";

		for (i in 0...array.length)
		{
			output += array[i];

			if (i < array.length - 1)
			{
				output += ", ";
			}
			else
			{
				output += " ";
			}
		}

		output += "]";

		return output;
	}

	public static function formatEnum(value:Dynamic):String
	{
		return Type.getEnumName(Type.getEnum(value)) + "." + value;
	}

	public static function formatUppercaseVariable(name:String):String
	{
		var isAlpha = ~/[A-Z0-9]/i;
		var variableName = "";
		var lastWasUpperCase = false;
		var lastWasAlpha = true;

		for (i in 0...name.length)
		{
			var char = name.charAt(i);

			if (!isAlpha.match(char))
			{
				variableName += "_";
				lastWasUpperCase = false;
				lastWasAlpha = false;
			}
			else
			{
				if (char == char.toUpperCase() && i > 0)
				{
					if (lastWasUpperCase)
					{
						if (i == name.length - 1 || name.charAt(i + 1) == name.charAt(i + 1).toUpperCase())
						{
							variableName += char;
						}
						else
						{
							variableName += "_" + char;
						}
					}
					else if (lastWasAlpha)
					{
						variableName += "_" + char;
					}
					else
					{
						variableName += char;
					}

					lastWasUpperCase = true;
				}
				else
				{
					variableName += char.toUpperCase();
					lastWasUpperCase = i == 0 && char == char.toUpperCase();
				}

				lastWasAlpha = true;
			}
		}

		return variableName;
	}

	public static function generateHashCode(value:String):Int
	{
		var hash = 5381;
		var length = value.length;

		for (i in 0...value.length)
		{
			hash = ((hash << 5) + hash) + value.charCodeAt(i);
		}

		return hash;
	}

	public static function generateUUID(length:Int, radix:Null<Int> = null, seed:Null<Int> = null):String
	{
		var chars = uuidChars.split("");

		if (radix == null || radix > chars.length)
		{
			radix = chars.length;
		}
		else if (radix < 2)
		{
			radix = 2;
		}

		if (seed == null)
		{
			seed = Math.floor(Math.random() * 2147483647.0);
		}

		var uuid = [];
		var seedValue:Int = Math.round(Math.abs(seed));

		for (i in 0...length)
		{
			seedValue = Std.int((seedValue * 16807.0) % 2147483647.0);
			uuid[i] = chars[0 | Std.int((seedValue / 2147483647.0) * radix)];
		}

		return uuid.join("");
	}

	public static function getFlatName(name:String):String
	{
		var chars = name.toLowerCase();
		var flatName = "";

		for (i in 0...chars.length)
		{
			var code = chars.charCodeAt(i);

			if ((i > 0 && code >= "0".charCodeAt(0) && code <= "9".charCodeAt(0))
				|| (code >= "a".charCodeAt(0) && code <= "z".charCodeAt(0))
				|| (code == "_".charCodeAt(0)))
			{
				flatName += chars.charAt(i);
			}
			else
			{
				flatName += "_";
			}
		}

		if (flatName == "")
		{
			flatName = "_";
		}

		if (flatName.substr(0, 1) == "_")
		{
			flatName = "file" + flatName;
		}

		while (usedFlatNames.exists(flatName))
		{
			// Find last digit ...
			var match = ~/(.*?)(\d+)/;

			if (match.match(flatName))
			{
				flatName = match.matched(1) + (Std.parseInt(match.matched(2)) + 1);
			}
			else
			{
				flatName += "1";
			}
		}

		usedFlatNames.set(flatName, "1");

		return flatName;
	}

	public static function getUniqueID():String
	{
		return StringTools.hex(seedNumber++, 8);
	}

	public static function hex(n:Int, ?digits:Int):String
	{
		return HaxeStringTools.hex(n, digits);
	}

	public static function htmlEscape(s:String, ?quotes:Bool):String
	{
		return HaxeStringTools.htmlEscape(s, quotes);
	}

	public static function htmlUnescape(s:String):String
	{
		return HaxeStringTools.htmlUnescape(s);
	}

	@:noUsing public static function isEof(c:Int):Bool
	{
		return HaxeStringTools.isEof(c);
	}

	public static function isSpace(s:String, pos:Int):Bool
	{
		return HaxeStringTools.isSpace(s, pos);
	}

	public static function lpad(s:String, c:String, l:Int):String
	{
		return HaxeStringTools.lpad(s, c, l);
	}

	public static function ltrim(s:String):String
	{
		return HaxeStringTools.ltrim(s);
	}

	public static function quoteUnixArg(argument:String):String
	{
		#if (haxe_ver >= "3.3")
		return HaxeStringTools.quoteUnixArg(argument);
		#else
		// https://github.com/HaxeFoundation/haxe/blob/development/std/StringTools.hx
		if (argument == "") return "''";

		if (!~/[^a-zA-Z0-9_@%+=:,.\/-]/.match(argument)) return argument;

		// use single quotes, and put single quotes into double quotes
		// the string $'b is then quoted as '$'"'"'b'
		return "'" + replace(argument, "'", "'\"'\"'") + "'";
		#end
	}

	public static function quoteWinArg(argument:String, escapeMetaCharacters:Bool):String
	{
		#if (haxe_ver >= "3.3")
		return HaxeStringTools.quoteWinArg(argument, escapeMetaCharacters);
		#else
		// https://github.com/HaxeFoundation/haxe/blob/development/std/StringTools.hx
		// If there is no space, tab, back-slash, or double-quotes, and it is not an empty string.
		if (!~/^[^ \t\\"]+$/.match(argument))
		{
			// Based on cpython's subprocess.list2cmdline().
			// https://hg.python.org/cpython/file/50741316dd3a/Lib/subprocess.py#l620

			var result = new StringBuf();
			var needquote = argument.indexOf(" ") != -1 || argument.indexOf("\t") != -1 || argument == "";

			if (needquote) result.add('"');

			var bs_buf = new StringBuf();
			for (i in 0...argument.length)
			{
				switch (argument.charCodeAt(i))
				{
					case "\\".code:
						// Don't know if we need to double yet.
						bs_buf.add("\\");
					case '"'.code:
						// Double backslashes.
						var bs = bs_buf.toString();
						result.add(bs);
						result.add(bs);
						bs_buf = new StringBuf();
						result.add('\\"');
					// case var c:
					case c:
						// Normal char
						if (bs_buf.length > 0)
						{
							result.add(bs_buf.toString());
							bs_buf = new StringBuf();
						}
						result.addChar(c);
				}
			}

			// Add remaining backslashes, if any.
			result.add(bs_buf.toString());

			if (needquote)
			{
				result.add(bs_buf.toString());
				result.add('"');
			}

			argument = result.toString();
		}

		if (escapeMetaCharacters)
		{
			var result = new StringBuf();
			for (i in 0...argument.length)
			{
				var c = argument.charCodeAt(i);
				if (winMetaCharacters.indexOf(c) >= 0)
				{
					result.addChar("^".code);
				}
				result.addChar(c);
			}
			return result.toString();
		}
		else
		{
			return argument;
		}
		#end
	}

	public static function replace(s:String, sub:String, by:String):String
	{
		return HaxeStringTools.replace(s, sub, by);
	}

	public static function rpad(s:String, c:String, l:Int):String
	{
		return HaxeStringTools.rpad(s, c, l);
	}

	public static function rtrim(s:String):String
	{
		return HaxeStringTools.rtrim(s);
	}

	public static function startsWith(s:String, start:String):Bool
	{
		return HaxeStringTools.startsWith(s, start);
	}

	public static function trim(s:String):String
	{
		return HaxeStringTools.trim(s);
	}

	public static function underline(string:String, character = "="):String
	{
		return string + "\n" + StringTools.lpad("", character, string.length);
	}

	public static function urlDecode(s:String):String
	{
		return HaxeStringTools.urlDecode(s);
	}

	public static function urlEncode(s:String):String
	{
		return HaxeStringTools.urlEncode(s);
	}

	// Get & Set Methods
	#if (haxe_ver >= "3.3")
	private static function get_winMetaCharacters():Array<Int>
	{
		return HaxeStringTools.winMetaCharacters;
	}

	private static function set_winMetaCharacters(value:Array<Int>):Array<Int>
	{
		return HaxeStringTools.winMetaCharacters = value;
	}
	#end
}
