import hxp.Haxelib;

/**
	Run with a fake `neko` first on PATH (see run.sh) so that `haxelib path`
	prints a missing-dependency error to stderr, nothing to stdout, and exits
	non-zero. The error reported by Haxelib.getPath must name the dependency.
**/
class MissingDependencyTest
{
	public static function main()
	{
		Haxelib.pathOverrides.set("haxelib", "fakehaxelib");
		Haxelib.getPath(new Haxelib("lime"), true);
	}
}
