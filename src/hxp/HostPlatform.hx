package hxp;

@:enum abstract HostPlatform(String) from String to String
{
	public var WINDOWS = "windows";
	public var MAC = "mac";
	public var LINUX = "linux";
}
