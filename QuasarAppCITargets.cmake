#
# Copyright (C) 2018-2020 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#


# This module implementation next cmake cunctions :
#
#
# ***Testing***
# initTestsArg( testExec arg ) // init "test" target for test utiliry of your application
# - testExec - name of tests utility (without extensions)
# - arg - arguments fot testExec
#
# initTests // init "test" target for test utiliry of your application (without arguments)
# - testExec - name of tests utility (without extensions)
#
# initTestsDefault - init empty target tests
#
#
# *** Deployment ***
# initDeploy(targets targetDir) // init deploy target for deployed your application via cqtdeployer tool
# - targets - this is list of cqtdeployer targets see cqtdeployer help https://github.com/QuasarApp/CQtDeployer/wiki/Options (-bin)
# - targetDir - this is target directory see option targetDir of cqtdeployer help https://github.com/QuasarApp/CQtDeployer/wiki/Options (-targetDir)
#
# initDeployQML(targets targetDir qml) // some as initDeploy but with qml location option
# - targets - this is list of cqtdeployer targets see cqtdeployer help https://github.com/QuasarApp/CQtDeployer/wiki/Options (-bin)
# - targetDir - this is target directory see option targetDir of cqtdeployer help https://github.com/QuasarApp/CQtDeployer/wiki/Options (-targetDir)
# - qml - this is qml location dir see help of qmlDir option of cqtdeployer help https://github.com/QuasarApp/CQtDeployer/wiki/Options (-qmlDir)
#
# initDeploySnap(targetDir) // add to deploy step substeps for create a snap package
# - targetDir - distanation direcroty for snap files
#
# initDeployQIF(sourceDir targetDir config) // add to deploy step substeps for create Qt Install FrameWork Installer
# - location for created installer
# - sourceDir - path to folder with qif template
# - config - path to config file of qif template
#
# initDeployAPK(input aliase keystore keystorePass targetDir) // add subtargets of deploy setep for create signed android apk file
# - input - path to input android json file : *-deployment-settings.json
# - aliase - aliase for key store
# - keystore - path of key store
# - keystorePass - pass of keystore file
# - targetDir - target dir for output apk file
#
# initDeployDefault() // create a enpty step for deployment
#
#
# *** Release ***
# initRelease() // create the general release target
#
# initReleaseSnap() // create subtargets for publish snap deployed snap package
#
# initReleaseQif(sourceDir targetDir) // create subtargets for publish the qif package on qif repository
# - sourceDir - path to folder with qif template
# - targetDir - path to target derictory


if(DEFINED QUASARAPP_DEFAULT_TARGETS)
  return()
else()
  set(QUASARAPP_DEFAULT_TARGETS 1)
endif()


function(initTestsArg testExec arg)

    if(TARGET test)
        message("the test target already created!")
        return()
    endif(TARGET test)

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

    if(TARGET test)
        message("the test target already created!")
        return()

    endif(TARGET test)

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

    if(TARGET deploy)
        message("the deploy target already created!")
        return()

    endif(TARGET deploy)

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        cqtdeployer
        COMMAND cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${targetDir} -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5
        COMMENT "Deploy: cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${targetDir} -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    )

    ADD_CUSTOM_TARGET(
        deploy
        COMMENT "=================== Run deploy ==================="
        DEPENDS cqtdeployer snapClear snapcraft snapcraftCopy deployAPK
    )

endfunction()

function(initDeployQML targets targetDir qml)

    if(TARGET deploy)
        message("the deploy target already created!")
        return()

    endif(TARGET deploy)

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        cqtdeployer
        COMMAND cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${targetDir} -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5 -qmlDir ${qml}
        COMMENT "Deploy: cqtdeployer clear -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${targetDir} -libDir ${PROJECT_SOURCE_DIR} -recursiveDepth 5 -qmlDir ${qml}"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    )

    ADD_CUSTOM_TARGET(
        deploy
        COMMENT "=================== Run deploy ==================="
        DEPENDS cqtdeployer snapClear snapcraft snapcraftCopy deployAPK
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    )

endfunction()

function(initDeploySnap targetDir)

    if(TARGET snapcraft)
        message("the snapcraft target already created!")
        return()

    endif(TARGET snapcraft)

    ADD_CUSTOM_TARGET(
        snapClear
        COMMAND snapcraft clean
        COMMENT "clear snap: snapcraft clear"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}

    )

    ADD_CUSTOM_TARGET(
        snapcraft
        COMMAND snapcraft
        COMMENT "create snap: snapcraft"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}

    )

    ADD_CUSTOM_TARGET(
        snapcraftCopy
        COMMAND ${CMAKE_COMMAND} -E copy *.snap ${targetDir}
        COMMENT "copt snap: ${CMAKE_COMMAND} -E copy *.snap ${targetDir}"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}

    )

endfunction()

function(initDeployQIF sourceDir targetDir config)

    if(TARGET qifDeploy)
        message("the qifDeploy target already created!")
        return()

    endif(TARGET qifDeploy)

    find_program(BINARYCREATOR_EXE binarycreator)

    set(OUT_EXE ${targetDir}/${PROJECT_NAME}OfllineInstaller.run)
    if (WIN32)
        set(OUT_EXE ${targetDir}/${PROJECT_NAME}OfllineInstaller.exe)
    endif (WIN32)

    ADD_CUSTOM_TARGET(
        qifDeploy
        COMMAND ${BINARYCREATOR_EXE} --offline-only -c ${config} -p ${sourceDir}/packages ${OUT_EXE}
        COMMENT "deploy qif: ${BINARYCREATOR_EXE} --offline-only -c ${config} -p ${sourceDir}/packages ${OUT_EXE}"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}

    )

endfunction()

function(initDeployAPK input aliase keystore keystorePass targetDir)

    if(TARGET deployAPK)
        message("the deployAPK target already created!")
        return()

    endif(TARGET deployAPK)

    set(OUTPUT_ANDROID "--output ${PROJECT_SOURCE_DIR}/AndroidBuild")
    set(INPUT_ANDROID "--input ${input}")
    set(JDK "--jdk /usr")
    set(SIGN "--sign '${keystore}' --storepass '${keystorePass}' --keypass '${keystorePass}' --release")

    find_program(A_DEPLOYER androiddeployqt)

    ADD_CUSTOM_TARGET(
        createAPK
        COMMAND ${A_DEPLOYER} ${INPUT_ANDROID} ${OUTPUT_ANDROID} ${JDK} --gradle ${SIGN}
        COMMENT "Run deploy android apk : ${A_DEPLOYER} ${INPUT_ANDROID} ${OUTPUT_ANDROID} ${JDK} --gradle ${SIGN}"
    )

    ADD_CUSTOM_TARGET(
        deployAPK
        COMMAND ${CMAKE_COMMAND} -E copy *.apk ${targetDir}
        COMMENT "copt apk: ${CMAKE_COMMAND} -E copy *.apk ${targetDir}"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/AndroidBuild/build/outputs/apk/
        DEPENDS createAPK

    )


endfunction()

function(initRelease)

    if(TARGET release)
        message("the release target already created!")
        return()

    endif(TARGET release)

    ADD_CUSTOM_TARGET(
        release
        COMMENT "=================== Relese project ==================="
        DEPENDS snapRelease qifRelease
    )

endfunction()

function(initReleaseSnap)

    if(TARGET snapRelease)
        message("the snapRelease target already created!")
        return()

    endif(TARGET snapRelease)

    ADD_CUSTOM_TARGET(
        snapRelease
        COMMAND snapcraft push
        COMMENT "snapcraft release"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}

    )

endfunction()

function(initReleaseQif sourceDir targetDir)
    if(TARGET qifRelease)
        message("the qifRelease target already created!")
        return()

    endif(TARGET qifRelease)

    find_program(BINARYCREATOR_EXE binarycreator)

    set(OUT_EXE ${targetDir}/${PROJECT_NAME}OfllineInstaller.run)
    if (WIN32)
        set(OUT_EXE ${targetDir}/${PROJECT_NAME}OfllineInstaller.exe)
    endif (WIN32)

    ADD_CUSTOM_TARGET(
        qifDeployOnline
        COMMAND ${BINARYCREATOR_EXE} --online-only -c ${config} -p ${sourceDir}/packages ${OUT_EXE}
        COMMENT "deploy qif online: ${BINARYCREATOR_EXE} --online-only -c ${config} -p ${sourceDir}/packages ${OUT_EXE}"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}

    )

    ADD_CUSTOM_TARGET(
        qifRelease
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${sourceDir}
        ${CMAKE_BINARY_DIR}/Repo
        COMMENT "qifRelease release ${CMAKE_COMMAND} -E copy_directory ${sourceDir} ${CMAKE_BINARY_DIR}/Repo"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        DEPENDS qifDeployOnline
       )
endfunction()

function(initTestsDefault)
    if(TARGET test)
        message("the test target already created!")
        return()

    endif(TARGET test)

    message("init empty tests")

    ADD_CUSTOM_TARGET(
        test
        COMMENT "=================== Run Test ==================="
    )

endfunction()

function(initDeployDefault)
    if(TARGET deploy)
        message("the deploy target already created!")
        return()

    endif(TARGET deploy)

    ADD_CUSTOM_TARGET(
        deploy
        COMMENT "=================== Run deploy ==================="
    )

endfunction()

function(initReleaseDefault)
    if(TARGET release)
        message("the release target already created!")
        return()

    endif(TARGET release)

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

