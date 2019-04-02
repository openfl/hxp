package hxp;

import haxe.Constraints.IMap;

class MapTools
{
	@:generic public static function copy<K, V>(source:IMap<K, V>)
	{
		var target = new Map<K, V>();

		for (key in source.keys())
		{
			target.set(key, source.get(key));
		}

		return target;
	}

	@:generic public static function copyDynamic<K>(source:IMap<K, Dynamic>)
	{
		var target = new Map<K, Dynamic>();

		for (key in source.keys())
		{
			target.set(key, source.get(key));
		}

		return target;
	}

	@:generic public static function copyKeys<K, V>(source:IMap<K, V>, target:IMap<K, V>):Void
	{
		for (key in source.keys())
		{
			target.set(key, source.get(key));
		}
	}

	public static function copyKeysDynamic<K>(source:IMap<K, Dynamic>, target:IMap<K, Dynamic>):Void
	{
		for (key in source.keys())
		{
			target.set(key, source.get(key));
		}
	}

	@:generic public static function copyUniqueKeys<K, V>(source:IMap<K, V>, target:IMap<K, V>):Void
	{
		for (key in source.keys())
		{
			if (!target.exists(key))
			{
				target.set(key, source.get(key));
			}
		}
	}

	public static function copyUniqueKeysDynamic<K>(source:IMap<K, Dynamic>, target:IMap<K, Dynamic>):Void
	{
		for (key in source.keys())
		{
			if (!target.exists(key))
			{
				target.set(key, source.get(key));
			}
		}
	}
}
