package hxp;

#if (haxe_ver < "4.0") @:enum #else enum #end abstract HostPlatform(String) from String to String
{
	public var WINDOWS = "windows";
	public var MAC = "mac";
	public var LINUX = "linux";
}
