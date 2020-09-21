#
# Copyright (C) 2018-2020 QuasarApp.
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


set(CROSSPLATFORM_BUILD_TOOLCHAIN_PATH ${CMAKE_CURRENT_LIST_DIR}/${CMAKE_HOST_SYSTEM_NAME}/${TARGET_PLATFORM_TOOLCHAIN}.cmake)

message("CROSSPLATFORM_BUILD_TOOLCHAIN_PATH = ${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH}")
if(EXISTS ${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH})

    message("${TARGET_PLATFORM_TOOLCHAIN} exits in ${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH}")
    
    include(${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH})
    
else(EXISTS ${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH})
    message("${TARGET_PLATFORM_TOOLCHAIN} not exits in ${CROSSPLATFORM_BUILD_TOOLCHAIN_PATH}")
endif()

