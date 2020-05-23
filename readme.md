# bspzip\_source

Project for building sourcesdk's bspzip tool for linux.

## General information

This project is made to build a tool called `bspzip` from `Source SDK`.
This modified version of `bspzip` have an extra function called 
`-deletelist <bspfile> <deletelist> <newbspfile>`
used to remove content from bsp files.

## Compiling

On Linux, everything should work after merging fix for [IncludeSDKMathlib](https://github.com/danielga/garrysmod_common/pull/48).  
For other platforms i didn't tested.

## Requirements

This project requires [garrysmod\_common][1], a framework to facilitate the creation of compilations files (Visual Studio, make, XCode, etc). Simply set the environment variable '**GARRYSMOD\_COMMON**' or the premake option '**gmcommon**' to the path of your local copy of [garrysmod\_common][1].  

  [1]: https://github.com/danielga/garrysmod_common
  
