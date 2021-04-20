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

# This module contains function that sets version of the build libraryes.
# AVailable function
# setVersion - sets version for target with name PROJECT_NAME
# arguments :
#  * maj - are number of majur version
#  * min - are number of minor version
#  * rev - are number of review version
#
# setVersionForTarget - sets version for target with a custom name.
# arguments :
#  * target - are target name of the executable file or library.
#  * maj - are number of majur version
#  * min - are number of minor version
#  * rev - are number of review version
#
#
# Note This module is deprecated.
#
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
