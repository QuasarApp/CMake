#
# Copyright (C) 2018-2021 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#

# This module is wraper of the QTFunctions.cmake.
# The tr module contains only prepareQM function.

if(DEFINED PROJECT_TR_SUPPORT)
  return()
else()
  set(PROJECT_TR_SUPPORT 1)
endif()


include(QtUtils.cmake)
