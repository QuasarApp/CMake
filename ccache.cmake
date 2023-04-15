#
# Copyright (C) 2018-2023 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#


# This module adds support of the ccache.
# If you include this cmake file in the main cmakList file then your project will be use the ccace on to the compilator
if(DEFINED CCACHE_SUPPORT)
  return()
else()
  set(CCACHE_SUPPORT 1)
endif()

find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    message("using ccache in ${CCACHE_PROGRAM}")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK "${CCACHE_PROGRAM}") # Less useful to do it for linking, see edit2

    if(CMAKE_GENERATOR STREQUAL "Xcode")

        set(CC_LAUNCHER ${CMAKE_CURRENT_LIST_DIR}/ccahe_cc_launcher.sh)
        set(CXX_LAUNCHER ${CMAKE_CURRENT_LIST_DIR}/ccahe_cxx_launcher.sh)

        configure_file("${CC_LAUNCHER}.in" "${CC_LAUNCHER}")
        configure_file("${CXX_LAUNCHER}.in" "${CXX_LAUNCHER}")

        # Set Xcode project attributes to route compilation and linking
        # through our scripts
        set(CMAKE_XCODE_ATTRIBUTE_CC         ${CC_LAUNCHER} CACHE INTERNAL "override CMAKE_XCODE_ATTRIBUTE_CC" )
        set(CMAKE_XCODE_ATTRIBUTE_CXX        ${CXX_LAUNCHER} CACHE INTERNAL "override CMAKE_XCODE_ATTRIBUTE_CC")

        message("CMAKE_XCODE_ATTRIBUTE_CC = ${CMAKE_XCODE_ATTRIBUTE_CC}")
        message("CMAKE_XCODE_ATTRIBUTE_CXX = ${CMAKE_XCODE_ATTRIBUTE_CXX}")

    endif()
endif()

