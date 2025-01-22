#
# Copyright (C) 2021-2025 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#

# This module provides The qt utilty functions of QuasarApp group.
#**********************
# Availabel functions:
# *********************
# The prepareQM function - This function prepare translations for you prijects
# The updateGitVars macross - This macross update all GIT variables releative current cmake file.
# The addQML function - This function add QML module into target and prepare qmldir file.
#**********************
# Availabel VARIABLE:
# *********************
# The GIT_COMMIT_COUNT variable - This variable contains commits count
# The GIT_COMMIT_HASH variable - This variable contains short version of the buildet commit hash.
# Note:
# For update actualy value of git variables use the updateGitVars macros


if(DEFINED PROJECT_QT_UTILS_SUPPORT)
  return()
else()
  set(PROJECT_QT_UTILS_SUPPORT 1)
endif()

# This function add QML module into target and prepare qmldir file and qrc files.
# this function designed to prepare a static or shared library with qml components,
# that can be imported into other projects only after linked parent library.
# Arguments :
# nicecery arguments:
#  target - it is name of the target for that will be added QML module.
#  QML_DIR - it is directory with QML files.

# optional arguments:
#  VERSION - it is version of the QML module. Default value is 1.0.
#  MODULE_NAME - it is name of the QML module. Default value is TARGET_NAME.
#   For example if the target name is QEQuick3d then the module name will be QEQuick3dQML.
# Example:
# addQML(QEQuick3d QML_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
# addQML(QEQuick3d QML_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src VERSION 1.0 MODULE_NAME QEQuick3d)

function(addQML target)

    set(options VERSION MODULE_NAME PUBLIC)
    set(oneValueArgs QML_DIR)

    cmake_parse_arguments(arg_addQML
        "${options}" "${oneValueArgs}" ""
        ${ARGN}
    )


    # QML module configuration.
    file(GLOB QML_FILES
        RELATIVE "${arg_addQML_QML_DIR}"
        "${arg_addQML_QML_DIR}/*.qml")

    if(NOT EXISTS "${arg_addQML_QML_DIR}")
        message(FATAL_ERROR "QML_DIR is not a readable directory")
    endif()

    file(GLOB_RECURSE ALL_QML_FILES
        RELATIVE "${arg_addQML_QML_DIR}"
        "${arg_addQML_QML_DIR}/*.qml")


    if (NOT arg_addQML_VERSION)
        set(arg_addQML_VERSION "1.0")
    endif()

    if (NOT arg_addQML_MODULE_NAME)
        set(arg_addQML_MODULE_NAME "${target}")
    endif()


    if(${arg_addQML_PUBLIC})

        set(QML_MODULE_CONTENT "")

        foreach(QML_FILE ${QML_FILES})
            get_filename_component(QML_NAME ${QML_FILE} NAME_WE)
            set(QML_MODULE_CONTENT "${QML_MODULE_CONTENT}${QML_NAME} ${arg_addQML_VERSION} ${QML_NAME}.qml\n")
        endforeach()

        write_file("${arg_addQML_QML_DIR}/qmldir" "module ${arg_addQML_MODULE_NAME}\n" )
        write_file("${arg_addQML_QML_DIR}/qmldir" "${QML_MODULE_CONTENT}" APPEND)
        file(RELATIVE_PATH QMLDIR_RELEATIVE_PATH ${arg_addQML_QML_DIR} "${arg_addQML_QML_DIR}/qmldir")

        if (NOT QML_IMPORT_PATH MATCHES "${arg_addQML_QML_DIR}/..")
            set(QML_IMPORT_PATH ${QML_IMPORT_PATH} "${arg_addQML_QML_DIR}/.." CACHE STRING "update global variable to access to qml from qt creator." FORCE)
        endif()

    endif()

    # here is creating a qrc file and adding them into target
    set(QML_QRC_FILE "${arg_addQML_QML_DIR}/${arg_addQML_MODULE_NAME}.qrc")
    write_file(${QML_QRC_FILE} "<RCC>\n")
    write_file(${QML_QRC_FILE} "    <qresource prefix=\"/${arg_addQML_MODULE_NAME}\">\n" APPEND)

    if(${arg_addQML_PUBLIC})
        write_file(${QML_QRC_FILE} "        <file>${QMLDIR_RELEATIVE_PATH}</file>\n" APPEND)
    endif()

    foreach(QML_FILE ${ALL_QML_FILES})
        write_file(${QML_QRC_FILE} "        <file>${QML_FILE}</file>\n" APPEND)
    endforeach()
    write_file(${QML_QRC_FILE} "    </qresource>\n" APPEND)
    write_file(${QML_QRC_FILE} "</RCC>\n" APPEND)

    # add to taget new qrc file as source
    target_sources(${target} PRIVATE ${QML_QRC_FILE})



endfunction()

# This function prepare translations for you prijects
# Arguments :
#  name - it is name of the translations target.
#  sourceDir - it is root source directory. lupdate will be scan this dir for prepare translations.
#  ts_files - it is list of the supported languages.
function(prepareQM name sourceDir ts_files)

    find_program(LUPDATE_EXECUTABLE lupdate)
    find_program(LRELEASE_EXECUTABLE lrelease)
    message(supported translations = ${ts_files})

    add_custom_target(${name}Translations ALL
        SOURCES ${ts_files}
    )

    foreach(_ts_file ${ts_files})

        execute_process(
            COMMAND ${LUPDATE_EXECUTABLE} -no-obsolete -locations none -recursive ${sourceDir} -ts ${_ts_file})
        execute_process(
            COMMAND ${LRELEASE_EXECUTABLE} ${_ts_file})

    endforeach()


endfunction()

# This macros create or update next variables:
# GIT_COMMIT_COUNT - This variable contains count of the commits.
# GIT_COMMIT_HASH - This variable contains short hash of the current cummit.
macro(updateGitVars)

    execute_process(
        COMMAND git rev-list --count HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_COUNT
        )
    string(STRIP "${GIT_COMMIT_COUNT}" GIT_COMMIT_COUNT)

    execute_process(
        COMMAND git rev-parse --short HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_HASH
        )
    string(STRIP "${GIT_COMMIT_HASH}" GIT_COMMIT_HASH)

endmacro()

# This macros create or update next variables:
# GIT_COMMIT_COUNT - This variable contains count of the commits.
# GIT_COMMIT_COUNT_FROM - This variable contains count of the commits from the hash.
# GIT_COMMIT_HASH - This variable contains short hash of the current cummit.
macro(updateGitVarsWithHash hash)

    execute_process(
        COMMAND git rev-list --count HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_COUNT
        )
    string(STRIP "${GIT_COMMIT_COUNT}" GIT_COMMIT_COUNT)

    execute_process(
        COMMAND git rev-list ${hash}..HEAD --count
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_COUNT_FROM
        )
    string(STRIP "${GIT_COMMIT_COUNT_FROM}" GIT_COMMIT_COUNT_FROM)

    execute_process(
        COMMAND git rev-parse --short HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_HASH
        )
    string(STRIP "${GIT_COMMIT_HASH}" GIT_COMMIT_HASH)

endmacro()


# This function do some as cmake function configure_file but add files into target for convenient access from editor
# Arguments :
#  name - it is name of the target for that will be configuret selected file.
#  file - it is file that will be configured
function(configure_file_in name file)

    if (TARGET ${name}Templates)
        target_sources(${name}Templates PRIVATE "${file}.in")
    else()
        add_custom_target(${name}Templates ALL
            SOURCES "${file}.in"
        )
    endif()

    configure_file("${file}.in" ${file} @ONLY)

endfunction()

