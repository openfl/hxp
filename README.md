[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md) [![Haxelib Version](https://img.shields.io/github/tag/openfl/hxp.svg?style=flat&label=haxelib)](http://lib.haxe.org/p/hxp) [![Build Status](https://img.shields.io/github/actions/workflow/status/openfl/hxp/main.yml?branch=master)](https://github.com/openfl/hxp/actions)

HXP
===

Write scripts in Haxe, and execute them on Windows, macOS or Linux.

## Basic Example

```haxe
// script.hx
class Script {

    public function new () {
    
        trace ("Hello from my script");
        
        var hxml = new HXML ({ cp: ["src"], main: "Main", js: "bin/index.js" });
        hxml.build ();
        PlatformTools.launchWebServer ("bin");
        
    }
    
}
```

### Running a Script

`hxp` looks for a script file in the current directory, or optionally, you can pass a directory or script path

```bash
cd path/with/script && hxp
hxp script.hx
hxp path/with/script
```

If you prefer to use multiple script files, HXP will prefer files which match the command name you are executing.

For example:

```bash
hxp build  # prefers "build.hx"
hxp run    # prefers "run.hx"
```

## Example with Arguments

```haxe
class Script extends hxp.Script {

    public function new () {
    
        super ();
        
        trace (command);
        trace (commandArgs);
        trace (flags.keys ());
        trace (defines.keys ());
        trace (options.keys ());
        
    }
    
}
```

When you extend `hxp.Script`, default argument parsing is included for you. Arguments which begin with a single dash (such as `-debug`) will be treated as a "flag", starting with `-D` is a "define", and starting with two dashes (such as `--out-dir`) is an "option". All other arguments will be considered a command (first), then command arguments.

For example:

```bash
hxp command arg1 arg2 -debug -Ddefine -Ddefine2=value --option=value
```

Using HXP works on Haxe 4 (using eval internally) or Haxe 3 (using Neko).

HXP includes convenience methods for working with file paths, directories, executing child processes and creating quality CLI tools.

The [Lime](https://github.com/openfl/lime) and [OpenFL](https://github.com/openfl/openfl) use HXP to develop cross-platform tools for delivering consistent content on Windows, macOS, Linux, iOS, Android, tvOS, Flash, HTML5 and other environments.


License
=======

HXP is free, open-source software under the [MIT license](LICENSE.md).


Installation
============

You can easily install HXP with haxelib:

    haxelib install hxp


Once installed, run the following command to install the `hxp` command alias:
    
    haxelib run hxp --install-hxp-alias


Development Builds
==================

Clone the HXP repository:

    git clone https://github.com/openfl/hxp


Tell haxelib where your development copy of HXP is installed:

    haxelib dev hxp hxp


To return to release builds:

    haxelib dev hxp
