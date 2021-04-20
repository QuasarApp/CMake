#
# Copyright (C) 2018-2021 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#

if(DEFINED CROSSPLATFORM_BUILD_TOOLCHAIN)
  return()
else()
  set(CROSSPLATFORM_BUILD_TOOLCHAIN 1)
endif()

# use TARGET_PLATFORM_TOOLCHAIN

# This module include crossplatform toolchains by target platform.
# To select target platform set the TARGET_PLATFORM_TOOLCHAIN define.
# Availabel platforms:
# * wasm32
# * win32-g++
# * win64-g++
#
# Note
# For add full support of the wasm32 build you shold use the initWasmSupport method. This method prepare static build for wasm executable and qt resources.
#
# initWasmSupport arguments:
#  * name - This is name of your initialize targets. You can set it as a CMAKE_PROJECT
#  * deployFile - This is path to the deploy file of the cqtdepoyer tool. Use it for deploy your site.

if (NOT DEFINED TARGET_PLATFORM_TOOLCHAIN)
    message(STATUS "The crossplatform build is disabled")
    return()

endif()

set(CROSSPLATFORM_BUILD_TOOLCHAIN_PATH ${CMAKE_CURRENT_LIST_DIR}/${CMAKE_HOST_SYSTEM_NAME}/${TARGET_PLATFORM_TOOLCHAIN}.cmake)

message("CROSSPLATFORM_BUILD_TOOLCHAIN_PATH = ${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH}")
if(EXISTS ${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH})

    message(STATUS "${TARGET_PLATFORM_TOOLCHAIN} exits in ${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH}")
    
    include("${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH}")
    
else(EXISTS ${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH})
    message(STATUS "${TARGET_PLATFORM_TOOLCHAIN} not exits in ${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH}")
endif()

function(initWasmSupport name deployFile)
    if(NOT TARGET ${name})
        message("the ${name} target is not created!")
        return()

    endif(NOT TARGET ${name})

    message("init support wasm build for target ${name}")

    if (DEFINED TARGET_PLATFORM_TOOLCHAIN)
        if (${TARGET_PLATFORM_TOOLCHAIN} STREQUAL "wasm32")
            message(added deploy step for site)

            set_target_properties(${name} PROPERTIES OUTPUT_NAME "${name}.js")

            addDeployFromFile(${deployFile})

            include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../QtStaticCMake/QtStaticCMake.cmake)

            qt_generate_plugin_import(${name} VERBOSE)

            # EXTRA_PLUGIN are the one required by plugin loaded by qt_generate_plugin_import
            # It's not automatic yet :( All this workflow might change in future version of qt
            # with better and better cmake support
            qt_generate_qml_plugin_import(${name}
              QML_SRC ${CMAKE_CURRENT_SOURCE_DIR}
              EXTRA_PLUGIN
                QtQuickVirtualKeyboardPlugin
                QtQuickVirtualKeyboardSettingsPlugin
                QtQuickVirtualKeyboardStylesPlugin
                QmlFolderListModelPlugin
                QQuickLayoutsPlugin
              VERBOSE
            )

        endif(${TARGET_PLATFORM_TOOLCHAIN} STREQUAL "wasm32")
    endif(DEFINED TARGET_PLATFORM_TOOLCHAIN)

endfunction()
