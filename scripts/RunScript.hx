package;

import hxp.InterpHelper;
import hxp.Log;

class RunScript
{
	public static function runCommand(path:String, command:String, args:Array<String>, throwErrors:Bool = true):Int
	{
		var oldPath:String = "";

		if (path != null && path != "")
		{
			oldPath = Sys.getCwd();

			try
			{
				Sys.setCwd(path);
			}
			catch (e:Dynamic)
			{
				Log.error("Cannot set current working directory to \"" + path + "\"");
			}
		}

		var result:Dynamic = Sys.command(command, args);

		if (oldPath != "")
		{
			Sys.setCwd(oldPath);
		}

		if (throwErrors && result != 0)
		{
			Sys.exit(1);
		}

		return result;
	}

	public static function main()
	{
		Sys.exit(InterpHelper.run(["-main", "MainScript", "-cp", "src", "-cp", "scripts",], Sys.args()));

	}
}
