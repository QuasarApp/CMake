#
# Copyright (C) 2020-2021 QuasarApp.
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
add_link_options("SHELL:-s ALLOW_MEMORY_GROWTH=1")

add_link_options("--bind")

find_program(EM_CC emcc)
set(CMAKE_C_COMPILER ${EM_CC} CACHE FILEPATH "CC Compiller of Wasm" FORCE)

find_program(EM_CXX em++)
set(CMAKE_CXX_COMPILER ${EM_CXX} CACHE FILEPATH "CXX Compiller of Wasm" FORCE)

set(BUILD_SHARED_LIBS OFF CACHE BOOL "CXX Compiller of Wasm" FORCE)

add_definitions( -DWASM32_BUILD )
