
local function GetSDKPath(directory)
	directory = directory or _OPTIONS["sourcesdk"] or os.getenv("SOURCE_SDK") or SOURCESDK_DIRECTORY or --[[deprecated]] DEFAULT_SOURCESDK_DIRECTORY

	assert(type(directory) == "string", "Source SDK path is not a string!")

	local dir = path.getabsolute(directory)
	assert(os.isdir(dir), "'" .. dir .. "' doesn't exist (Source SDK)")

	return path.getrelative(_SCRIPT_DIR, directory)
end

newoption({
	trigger = "gmcommon",
	description = "Sets the path to the garrysmod_common (https://github.com/danielga/garrysmod_common) directory",
	value = "path to garrysmod_common directory"
})

local gmcommon = assert(_OPTIONS.gmcommon or os.getenv("GARRYSMOD_COMMON"),
	"you didn't provide a path to your garrysmod_common (https://github.com/danielga/garrysmod_common) directory")
include(path.join(gmcommon, "generator.v2.lua"))

CreateWorkspace({name = "bspzip",serverside = false})

	group("garrysmod_common")
		sysincludedirs(path.join("source", "utils", "lzma", "C"))
		links("LZMA")
		
		--Using include lzma because of source 2018 changes
		project("LZMA")
			kind("StaticLib")
			warnings("Default")
			defines("_7ZIP_ST")
			sysincludedirs(path.join("source", "utils", "lzma", "C"))
			files({
				path.join("source", "utils", "lzma", "C", "*.h"),
				path.join("source", "utils", "lzma", "C", "*.c")
			})
			-- Removing threaded code
			removefiles ({
				path.join("source", "utils", "lzma", "C", "*Mt*.*"),
				path.join("source", "utils", "lzma", "C", "Threads.*")
			})
			vpaths({
				["Header files/*"] = path.join("source", "utils", "lzma", "C", "*.h"),
				["Source files/*"] = path.join("source", "utils", "lzma", "C", "*.c"),
			})

		project("bspzip")
			kind("ConsoleApp")
			warnings("Default")
			IncludeSDKCommon()
			IncludeSDKTier0()
			IncludeSDKTier1()
			IncludeSDKTier2()
			IncludeSDKMathlib()


			directory = GetSDKPath(directory)

			sysincludedirs({
				path.join(directory, "public")
			})

			files({
					path.join(directory, "public", "filesystem_init.cpp"),
					path.join(directory, "public", "filesystem_helpers.cpp"),
					path.join(directory, "public", "lumpfiles.cpp"),
					path.join(directory, "public", "zip_utils.cpp"),					
			})

			vpaths({["Source files/*"] = path.join(directory, "public", "*.cpp")})
	
			sysincludedirs({
				path.join(directory, "utils", "common")
			})
			files({
					path.join(directory, "utils", "common", "bsplib.cpp"),
					path.join(directory, "utils", "common", "cmdlib.cpp"),
					path.join(directory, "utils", "common", "filesystem_tools.cpp"),
					path.join(directory, "utils", "common", "scriplib.cpp"),
			})


			sysincludedirs({
				"source",
				path.join("source","utils","lzma")
			})
			files({
				path.join("source","utils","lzma","lzma.cpp"),
				path.join("source","linux_support.cpp"),
				path.join("source","bspzip.cpp"),
			})
			vpaths({["Source files/*"] = path.join("source" , "*.cpp")})

			filter("system:linux")
				links { "dl","pthread" }
	group("")
