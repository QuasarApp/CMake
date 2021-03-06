#
# Copyright (C) 2018-2021 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#

if(DEFINED PROJECT_VERSIONS_SUPPORT)
  return()
else()
  set(PROJECT_VERSIONS_SUPPORT 1)
endif()

function(setVersion maj min rev)

    SET_TARGET_PROPERTIES(
      ${PROJECT_NAME}
      PROPERTIES
        VERSION "${maj}.${min}.${rev}"
        SOVERSION "${maj}.${min}.${rev}"
      )

endfunction()

function(setVersionForTarget TERAGET maj min rev)

    SET_TARGET_PROPERTIES(
      ${TERAGET}
      PROPERTIES
        VERSION "${maj}.${min}.${rev}"
        SOVERSION "${maj}.${min}.${rev}"
      )

endfunction()
