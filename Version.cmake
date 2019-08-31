#
# Copyright (C) 2018-2019 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#


function(setVersion maj min rev)

    SET_TARGET_PROPERTIES(
      ${PROJECT_NAME}
      PROPERTIES
        VERSION "${maj}.${min}.${rev}"
        SOVERSION "${maj}.${min}.${rev}"
      )

endfunction()
