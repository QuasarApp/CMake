#
# Copyright (C) 2021-2024 QuasarApp.
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

