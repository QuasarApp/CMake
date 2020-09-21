#
# Copyright (C) 2020-2020 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#

if(DEFINED CROSSPLATFORM_BUILD_TOOLCHAIN_WASM_32)
  return()
else()
  set(CROSSPLATFORM_BUILD_TOOLCHAIN_WASM_32 1)
endif()

# the name of the target operating system

message("Building from Linux for Wasm_32")

add_link_options("SHELL:-s FETCH=1")
add_link_options("SHELL:-s WASM=1")
add_link_options("SHELL:-s FULL_ES2=1")
add_link_options("SHELL:-s FULL_ES3=1")
add_link_options("SHELL:-s USE_WEBGL2=1")
add_link_options("SHELL:-s EXIT_RUNTIME=1")
add_link_options("SHELL:-s ERROR_ON_UNDEFINED_SYMBOLS=1")
add_link_options("SHELL:-s EXTRA_EXPORTED_RUNTIME_METHODS=[\"UTF16ToString\",\"stringToUTF16\"]")

add_link_options("--bind")

set(CMAKE_C_COMPILER emcc)
#set_property(GLOBAL PROPERTY CMAKE_C_COMPILER emcc)
#add_definitions(-DCMAKE_C_COMPILER="emcc")

set(CMAKE_CXX_COMPILER em++)
#set_property(GLOBAL PROPERTY CMAKE_CXX_COMPILER em++)
#add_definitions(-DCMAKE_CXX_COMPILER="em++")
set(BUILD_SHARED_LIBS OFF)
#set_property(GLOBAL PROPERTY BUILD_SHARED_LIBS OFF)
#add_definitions(-DBUILD_SHARED_LIBS="OFF")
