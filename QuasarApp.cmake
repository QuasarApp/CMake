#
# Copyright (C) 2021-2025 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#

#
# This is main cmake module of the QuasarApp group.
# All project of the QuasarApp group ust be use this module in own cmake rro directory.
# Example
# include(CMake/QuasarApp.cmake)
#
# This module do:
# * Print debug information
# * Prepare build type, By default it is Release mode
# * include ccache for project
# * Add default QussarApp  definition into code
# * Initialise all default targets. See the QuasarAppCITargets module
# * Initialise all qtUtils. See the QtUtils module
# * Initialise all crossplatform toolchains. See the crossplatform module

#
# Supports Defines:
#  * RELEASE_BUILD - will sets to true if the build type is release.

if(DEFINED QUASARAPP_CMAKE_MODULE)
  return()
else()
  set(QUASARAPP_CMAKE_MODULE 1)
endif()

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Release)
ENDIF(NOT CMAKE_BUILD_TYPE)

if (NOT QT_QT_ROOT)
    if (QT_VERSION_MAJOR)
        get_filename_component(QT_QT_ROOT "${Qt${QT_VERSION_MAJOR}Core_DIR}/../../.." ABSOLUTE)
    endif()
endif()

if (NOT EXISTS ${QT_QMAKE_EXECUTABLE})
    message("The QT_QMAKE_EXECUTABLE variable is not set or path is wrong QT_QMAKE_EXECUTABLE=${QT_QMAKE_EXECUTABLE}")
    message("Try to Initialize from qtdir")

    find_program(QMAKE_EXECUTABLE qmake)
    set(QT_QMAKE_EXECUTABLE ${QMAKE_EXECUTABLE})
endif()

## Default Defines
## End DEfault defines
include(${CMAKE_CURRENT_LIST_DIR}/ccache.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/QuasarAppCITargets.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/QtUtils.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/crossplatform/crossplatform.cmake)

message(STATUS "buid type    " ${CMAKE_BUILD_TYPE})
message(STATUS "Project      " ${PROJECT_NAME})
message(STATUS "c compiler   " ${CMAKE_C_COMPILER})
message(STATUS "cxx compiler " ${CMAKE_CXX_COMPILER})
message(STATUS "build shared " ${BUILD_SHARED_LIBS})
message(STATUS "qmake exec   " ${QT_QMAKE_EXECUTABLE})
message(STATUS "tool chain   " ${CMAKE_TOOLCHAIN_FILE})
