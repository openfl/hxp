/** Stands in for haxelib's run.n: fails like `haxelib path lime` with a missing dependency. */
class FakeHaxelib
{
	public static function main()
	{
		Sys.stderr().writeString("Error: Library native-desktop is not installed : run 'haxelib install native-desktop'\n");
		Sys.exit(1);
	}
}
