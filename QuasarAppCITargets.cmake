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

function(initDeploy targets targetDir)

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        cqtdeployer
        COMMAND cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${targetDir} -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5
        COMMENT "Deploy: cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${targetDir} -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5"
    )

    ADD_CUSTOM_TARGET(
        deploy
        COMMENT "=================== Run deploy ==================="
        DEPENDS cqtdeployer snapClear snapcraft snapcraftCopy
    )

endfunction()

function(initDeployQML targets targetDir qml)

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        cqtdeployer
        COMMAND cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${targetDir} -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5 -qmlDir ${qml}
        COMMENT "Deploy: cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${targetDir} -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5 -qmlDir ${qml}"
    )

    ADD_CUSTOM_TARGET(
        deploy
        COMMENT "=================== Run deploy ==================="
        DEPENDS cqtdeployer snapClear snapcraft snapcraftCopy
    )

endfunction()

function(initDeploySnap sourceDir)

    ADD_CUSTOM_TARGET(
        snapClear
        COMMAND snapcraft clear
        COMMENT "clear snap: snapcraft clear"
    )

    ADD_CUSTOM_TARGET(
        snapcraft
        COMMAND snapcraft
        COMMENT "create snap: snapcraft"
    )

    ADD_CUSTOM_TARGET(
        snapcraftCopy
        COMMAND ${CMAKE_COMMAND} -E copy *.snap ${sourceDir}
        COMMENT "copt snap: ${CMAKE_COMMAND} -E copy *.snap ${sourceDir}"
    )

endfunction()

function(initDeployQIF sourceDir targetDir config)

    find_program(BINARYCREATOR_EXE binarycreator)

    set(OUT_EXE ${sourceDir}/${PROJECT_NAME}OfllineInstaller.run)
    if (WIN32)
        set(OUT_EXE ${sourceDir}/${PROJECT_NAME}OfllineInstaller.exe)
    endif (WIN32)

    ADD_CUSTOM_TARGET(
        qifDeploy
        COMMAND ${BINARYCREATOR_EXE} --offline-only -c ${config} -p ${sourceDir}/packages ${OUT_EXE}
        COMMENT "deploy qif: ${BINARYCREATOR_EXE} --offline-only -c ${config} -p ${sourceDir}/packages ${OUT_EXE}"
    )

endfunction()

function(initReleaseSnap)

    ADD_CUSTOM_TARGET(
        snapRelease
        COMMAND snapcraft push
        COMMENT "snapcraft release"
    )

endfunction()

function(initReleaseQif sourceDir)

    ADD_CUSTOM_TARGET(
        qifRelease
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${sourceDir}
        ${CMAKE_BINARY_DIR}/Repo
        COMMENT "qifRelease release ${CMAKE_COMMAND} -E copy_directory ${sourceDir} ${CMAKE_BINARY_DIR}/Repo"
       )
endfunction()

function(initTestsDefault)
    message("init empty tests")

    ADD_CUSTOM_TARGET(
        test
        COMMENT "=================== Run Test ==================="
    )

endfunction()

function(initDeployDefault)

    ADD_CUSTOM_TARGET(
        deploy
        COMMENT "=================== Run deploy ==================="
    )

endfunction()

function(initReleaseDefault)

    ADD_CUSTOM_TARGET(
        release
        COMMENT "=================== Run release ==================="
    )

endfunction()

function(initAll)
    initTestsDefault()
    initDeployDefault()
    initReleaseDefault()

endfunction()

