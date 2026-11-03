#!/bin/sh
# Verifies Haxelib.getPath reports the missing dependency, not just the parent library.
cd "$(dirname "$0")"
haxe -main FakeHaxelib -neko fakehaxelib/run.n || exit 1
err=$(haxe -cp ../src -main MissingDependencyTest --interp 2>&1 >/dev/null)
echo "$err"
echo "$err" | grep -q 'native-desktop' && echo PASS || { echo FAIL; exit 1; }
