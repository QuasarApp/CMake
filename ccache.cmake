#
# Copyright (C) 2018-2021 QuasarApp.
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
endif()

