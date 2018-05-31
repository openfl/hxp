[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md) [![Haxelib Version](https://img.shields.io/github/tag/openfl/hxp.svg?style=flat&label=haxelib)](http://lib.haxe.org/p/hxp) [![Build Status](https://img.shields.io/circleci/project/github/openfl/hxp/develop.svg)](https://circleci.com/gh/openfl/hxp)

HXP
===



License
=======

HXP is free, open-source software under the [MIT license](LICENSE.md).


Installation
============

First install the latest version of [Haxe](http://www.haxe.org/download).

The current version of Lime has not been released on haxelib, yet, so please install the latest [development build](http://www.openfl.org/builds/lime).


Development Builds
==================

When there are changes, Lime is built nightly. Builds are available for download [here](http://www.openfl.org/builds/lime).

To install a development build, use the "haxelib local" command:

    haxelib local filename.zip


Building from Source
====================

Clone the HXP repository, as well as the submodules:

    git clone --recursive https://github.com/openfl/hxp

Tell haxelib where your development copy of HXP is installed:

    haxelib dev hxp hxp

The first time you run the "hxp" command, it will attempt to build the HXP tools. To build these manually, use the following command:

    haxelib install format
    hxp rebuild tools

To switch away from a source build, use:

    haxelib dev hxp

