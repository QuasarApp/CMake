#
# Copyright (C) 2021-2021 QuasarApp.
# Distributed under the lgplv3 software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#

if(DEFINED CMAKE_LIBRARY)
  return()
else()
  set(CMAKE_LIBRARY 1)
  add_definitions(-DCMAKE_LIBRARY)
endif()

project(CMAKE)

if(TARGET ${PROJECT_NAME})
  message("The ${PROJECT_NAME} arledy included in main Project")
  return()
endif()

cmake_minimum_required(VERSION 3.12)
include(QuasarApp.cmake)
include(Version.cmake)


initAll()

addDoc(${PROJECT_NAME}Docs ${CMAKE_CURRENT_SOURCE_DIR}/doxygen.conf)
