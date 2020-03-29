#
# Copyright (C) 2018-2020 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#

if(DEFINED QUASARAPP_DEFAULT_TARGETS)
  return()
else()
  set(QUASARAPP_DEFAULT_TARGETS 1)
endif()

function(initQmake)

    set(Q_MAKE ${Qt5_DIR}/bin/qmake)
    if (WIN32)
        set(Q_MAKE ${Qt5_DIR}/bin/qmake.exe)
    endif (WIN32)

endfunction()

function(initTests testExec arg)

    ADD_CUSTOM_TARGET(
        deployTest
        COMMAND ${testExec} ${arg}
        COMMENT "=================== Deploy Test ==================="
    )

    initQmake()

    ADD_CUSTOM_TARGET(
        test
        COMMAND cqtdeployer -bin ${testExec} -qmake ${Q_MAKE}
        COMMENT "=================== Run Test ==================="
        DEPENDS deployTest
    )

endfunction()

function(initTests testExec)

    ADD_CUSTOM_TARGET(
        deployTest
        COMMAND ${testExec}
        COMMENT "=================== Deploy Test ==================="
    )

    initQmake()

    ADD_CUSTOM_TARGET(
        test
        COMMAND cqtdeployer -bin ${testExec} -qmake ${Q_MAKE}
        COMMENT "=================== Run Test ==================="
        DEPENDS deployTest
    )

endfunction()

function(initTests )

    ADD_CUSTOM_TARGET(
        test
        COMMENT "=================== Run Test ==================="
    )

endfunction()

function(initDeploy targets)

    if(DEFINED targets)
        initQmake()

        ADD_CUSTOM_TARGET(
            deploy
            COMMAND cqtdeployer -bin ${targets} -qmake ${Q_MAKE}
            COMMENT "=================== Run deploy ==================="
            DEPENDS deployTest
        )
    else(DEFINED testExec)
        ADD_CUSTOM_TARGET(
            deploy
            COMMENT "=================== Run deploy ==================="
        )
    endif(DEFINED testExec)

endfunction()

function(initRelease)

    ADD_CUSTOM_TARGET(
        release
        COMMENT "=================== Run release ==================="
    )

endfunction()

function(initDeploy)

    ADD_CUSTOM_TARGET(
        deploy
        COMMENT "=================== Run deploy ==================="
    )

endfunction()

function(initRelease)

    ADD_CUSTOM_TARGET(
        release
        COMMENT "=================== Run release ==================="
    )

endfunction()

function(initAll)
    initTests()
    initDeploy()
    initRelease()

endfunction()

