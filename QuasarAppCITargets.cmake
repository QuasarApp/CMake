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


function(initTestsArg testExec arg)

    set(EXEC_TEST ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${testExec})
    set(RUN_CMD BuildetTests/${testExec}.sh)

    if (WIN32)
        set(EXEC_TEST ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${testExec}.exe)
        set(RUN_CMD BuildetTests/${testExec}.exe)

    endif (WIN32)

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        deployTest
        COMMAND cqtdeployer clear -bin ${EXEC_TEST} -qmake ${Q_MAKE_EXE} -targetDir ${PROJECT_SOURCE_DIR}/BuildetTests -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5
        COMMENT "Deploy Test: cqtdeployer clear -bin ${EXEC_TEST} -targetDir BuildetTests -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5"
    )

    ADD_CUSTOM_TARGET(
        test
        COMMAND ${RUN_CMD} ${arg}
        COMMENT "=================== Run Test ==================="
        WORKING_DIRECTORY BuildetTests
        DEPENDS deployTest
    )

    message("prepare tests for ${RUN_CMD} with arg : ${arg}")

endfunction()

function(initTests testExec)

    set(EXEC_TEST ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${testExec})
    set(RUN_CMD ${PROJECT_SOURCE_DIR}/BuildetTests/${testExec}.sh)

    if (WIN32)
        set(EXEC_TEST ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${testExec}.exe)
        set(RUN_CMD ${PROJECT_SOURCE_DIR}/BuildetTests/${testExec}.exe)

    endif (WIN32)

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        deployTest
        COMMAND cqtdeployer clear -bin ${EXEC_TEST} -qmake ${Q_MAKE_EXE} -targetDir ${PROJECT_SOURCE_DIR}/BuildetTests -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5
        COMMENT "Deploy Test: cqtdeployer clear -bin ${EXEC_TEST} -targetDir BuildetTests -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5"
    )

    ADD_CUSTOM_TARGET(
        test
        COMMAND ${RUN_CMD}
        COMMENT "=================== Run Test ==================="
        WORKING_DIRECTORY BuildetTests
        DEPENDS deployTest
    )

    message("prepare tests for ${RUN_CMD}")

endfunction()

function(initDeploy targets)

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        deploy
        COMMAND cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${PROJECT_SOURCE_DIR}/Distro -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5
        COMMENT "Deploy: cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${PROJECT_SOURCE_DIR}/Distro -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5"
    )

endfunction()

function(initDeployQML targets qml)

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        deploy
        COMMAND cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${PROJECT_SOURCE_DIR}/Distro -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5 -qmlDir ${qml}
        COMMENT "Deploy: cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${PROJECT_SOURCE_DIR}/Distro -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5 -qmlDir ${qml}"
    )

endfunction()

function(initTestsDefault)
    message("init empty tests")

    ADD_CUSTOM_TARGET(
        test
        COMMENT "=================== Run Test ==================="
    )

endfunction()

function(initRelease)

    ADD_CUSTOM_TARGET(
        release
        COMMENT "=================== Run release ==================="
    )

endfunction()

function(initDeployDefault)

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
    initTestsDefault()
    initDeployDefault()
    initRelease()

endfunction()

