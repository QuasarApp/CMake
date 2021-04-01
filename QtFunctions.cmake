#
# Copyright (C) 2021-2021 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#

# This module provides The qt utilty functions of QuasarApp group.
#**********************
# Availabel functions:
# *********************
# The prepareQM function - This function prepare translations for you prijects
# The includeQt function - This function search package for the qt6 or qt5 with requir modules and check if a sought package is already included.

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
            COMMAND ${LUPDATE_EXECUTABLE} -recursive ${sourceDir} -ts ${_ts_file})
        execute_process(
            COMMAND ${LRELEASE_EXECUTABLE} ${_ts_file})

    endforeach()


endfunction()


# This function search package for the qt6 or qt5 with requir modules and check if a sought package is already included.
# Arguments :
#  ModulesList - This is mist of requir modules of the qt.
function(includeQt ModulesList)

    foreach(module ${ModulesList})

        if (NOT QT_${module}_FOUND)
            find_package(QT NAMES Qt6 Qt5 COMPONENTS module REQUIRED)
            find_package(Qt${QT_VERSION_MAJOR} COMPONENTS module REQUIRED)

            message (the ${module} package is found )
        endif()

    endforeach()


    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)


endfunction()
