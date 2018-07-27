[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md) [![Haxelib Version](https://img.shields.io/github/tag/openfl/hxp.svg?style=flat&label=haxelib)](http://lib.haxe.org/p/hxp) [![Build Status](https://img.shields.io/circleci/project/github/openfl/hxp/develop.svg)](https://circleci.com/gh/openfl/hxp)

HXP
===

Write scripts in Haxe, and execute them on Windows, macOS or Linux.

## build.hx

```haxe
class Build {
    
    public function new () {
        
        trace ("Hello World");
        
    }
    
}
```

```
hxp build.hx // Hello World
```

_Currently requires the Haxe 4 preview._

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
    
    haxelib run hxp setup


Development Builds
==================

Clone the HXP repository:

    git clone https://github.com/openfl/hxp


Tell haxelib where your development copy of HXP is installed:

    haxelib dev hxp hxp


To return to release builds:

    haxelib dev hxp
