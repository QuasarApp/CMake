#
# Copyright (C) 2018-2022 QuasarApp.
# Distributed under the MIT software license, see the accompanying
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#


# This module implementation next cmake functions :
#
# The library contains 2 methods type it is Added methods and init methods.
# All inits method must be invoked before adds methods. If you change order then some add method will be ignored.

#
# ***Testing***
# addTestsArg( name testExec arg ) // Name target for test utility of your application.
# - name - Prefix for target (any word).
# - testExec - Name of tests utility (without extensions).
# - arg - Arguments for testExec.
#
# addTests (name testExec )// Name target for test utility of your application (without arguments).
# - name - Prefix for target (any word).
# - testExec - Name of tests utility (without extensions).
#
# initTests - Init main test target for tessting all added tests, this method need to call before all invoiced addTests methods.
#
#
# *** Deployment ***
# addDeploy(name targets targetDir) // Add deploy target for deployed your application via CQtDeployer tool.
# - name - This is prefix of added subtarget (any word).
# - targets - This is list of CQtDeployer targets see CQtDeployer help https://github.com/QuasarApp/CQtDeployer/wiki/Options (-bin).
# - targetDir - This is target directory see option targetDir of CQtDeployer help https://github.com/QuasarApp/CQtDeployer/wiki/Options (-targetDir).
#
# addDeployFromFile(name) // Some as initDeploy, but use CQtDeployer.json for configuration.
# - name - This is prefix of added subtarget (any word).
#
# addDeployFromCustomFile(name file) // Some as initDeploy, but use custom path for deployment file for configuration.
# - name - This is prefix of added subtarget (any word).
# - file - This is path to config file of cqtdeployer.
#
# addDeploySnap(name targetDir) // Add to deploy step substeps for create a snap package.
# - name - This is prefix of added subtarget (any word).
# - targetDir - Destanation direcroty for snap files.
#  The addDeploySnap method are support the SNAPCRAFT_MODE variable. If you need to use custom snapcraft mode.
#    Example:
#       set(SNAPCRAFT_MODE "--destructive-mode")
#       addDeploySnap("Client" ${TARGET_DIR})
#
# addDeployQIF(name sourceDir targetDir config) // Add to deploy step substeps for create Qt Install FrameWork Installer.
# - name - This is prefix of added subtarget (any word).
# - location for created installer.
# - sourceDir - Path to folder with qif template.
# - config - Path to config file of qif template.
#
# addDeploySignedAPK(name input aliase keystore keystorePass targetDir) // Add subtargets of deploy setep for create signed android apk file.
# - name - This is prefix of added subtarget (any word).
# - android_src - Path to folder with the android_manifest file.
# - aliase - Aliase for key store.
# - keystore - Path of key store.
# - keystorePass - Pass of keystore file.
# - targetDir - Target dir for output apk file.
# - extraLibs - list f the extra libraryes (like the openssl)
#
# addDeployAPK(name input aliase keystore keystorePass targetDir) // Add subtargets of deploy setep for create android apk file.
# - name - This is prefix of added subtarget (any word).
# - android_src - Path to folder with the android_manifest file.
# - targetDir - Target dir for output apk file.
# - extraLibs - list f the extra libraryes (like the openssl)
#
# addDeployIPA name bundle_id targetDir version appleDir
# - name - This is prefix of added subtarget (any word).
# - bundle_id - This is bundle id of application.
# - targetDir - Target dir for output apk file.
# - version - This is ersaion string of package
# - appleDir - This is main platform dir of apple. By default it is "${CMAKE_CURRENT_SOURCE_DIR}/apple"
#
# initDeploy() // Create a main deploy target for all addDeploy subtargets. This method need to call before invoiced of all addDeploy methods.
#
#
# *** Release ***
# initRelease() // Create the general release target for all subtargets addRelease. This method need to call before invoice all addRelease methods.
#
# addReleaseCustom(name pyFile) // This function prepare to run pyFile and add dependencies for release target.
# - name - This is prefix of added subtarget (any word).
# - pyFile This is python script for release project.
#
# addReleaseSnap(name) // Create subtargets for publish snap deployed snap package.
# - name - This is prefix of added subtarget (any word).
#
# addReleaseQif(name sourceDir targetDir) // Create subtargets for publish the qif package on qif repository.
# - name - This is prefix of added subtarget (any word).
# - sourceDir - Path to folder with qif template.
# - targetDir - Path to target directory.
#
#
# *** Dcumentation ***
# initDoc() // Create the general doc target for all subtargets addDoc. This method need to call before invoice all addDoc methods.
#
# addDoc(name doxygenFile) // Create subtargets for generate documentation of cpp code.
# - name - This is prefix of added subtarget (any word).
# - doxygenFile - This is path to doxygen configuration file.
#


if(DEFINED QUASARAPP_DEFAULT_TARGETS)
  return()
else()
  set(QUASARAPP_DEFAULT_TARGETS 1)
endif()

set(DOC_TARGETS_LIST "")
set(TEST_TARGETS_LIST "")
set(DEPLOY_TARGETS_LIST "")
set(RELEASE_TARGETS_LIST "")
set(DIR_FOR_TESTING ${PROJECT_SOURCE_DIR}/Testing)
set(QUASAR_MODULE_CURRENT_DIR ${CMAKE_CURRENT_LIST_DIR})

if (ANDROID)
    include(${CMAKE_CURRENT_LIST_DIR}/qt-android-cmake/AddQtAndroidApk.cmake)
endif()

if (IOS)
    include(${CMAKE_CURRENT_LIST_DIR}/QtStaticCMake/QtStaticCMake.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/QtIosCMake/AddQtIosApp.cmake)

endif()

function(emptyTarget targetName)

    if(TARGET ${targetName})
        message("the ${targetName} target already created!")
        return()

    endif(TARGET ${targetName})

    ADD_CUSTOM_TARGET(
        ${targetName}
    )

endfunction()

function(initTests)

    if(TARGET test)
        message("the test target already created!")
        return()

    endif(TARGET test)

    message("test sub targets: ${TEST_TARGETS_LIST}")

    ADD_CUSTOM_TARGET(
        test
        COMMENT "=================== Run Test ==================="
        DEPENDS
    )

    message("prepare tests for ${TEST_TARGETS_LIST}")

endfunction()

function(addTestsArg name testExec arg)

    if(TARGET test${name})
        message("the test${name} target already created!")
        return()
    endif(TARGET test${name})

    set(EXEC_TEST "${CMAKE_CURRENT_BINARY_DIR}/${testExec}")
    set(RUN_CMD "${DIR_FOR_TESTING}/${name}/${testExec}.sh")

    if (WIN32)
        set(EXEC_TEST "${CMAKE_CURRENT_BINARY_DIR}/${testExec}.exe")
        set(RUN_CMD "${DIR_FOR_TESTING}/${name}/${testExec}.exe")

    endif (WIN32)


    find_program(Q_MAKE_EXE qmake)


    ADD_CUSTOM_TARGET(
        deployTest${name}
        COMMAND cqtdeployer clear -bin ${EXEC_TEST} -qmake ${Q_MAKE_EXE} -targetDir ${DIR_FOR_TESTING}/${name} -libDir \"${CMAKE_SOURCE_DIR},${CMAKE_BINARY_DIR}\" -recursiveDepth 5
        COMMENT "Deploy Test: cqtdeployer clear -bin ${EXEC_TEST} -qmake ${Q_MAKE_EXE} -targetDir ${DIR_FOR_TESTING}/${name} -libDir ${CMAKE_SOURCE_DIR} -recursiveDepth 5"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        )

    ADD_CUSTOM_TARGET(
        test${name}
        COMMAND ${RUN_CMD} ${arg}
        COMMENT "=================== Run Test ==================="
        WORKING_DIRECTORY ${DIR_FOR_TESTING}/${name}
        DEPENDS deployTest${name}
    )

    add_dependencies(test test${name})

endfunction()

function(addTests name testExec)

    if(TARGET test${name})
        message("the test${name} target already created!")
        return()

    endif(TARGET test${name})

    set(EXEC_TEST "${CMAKE_CURRENT_BINARY_DIR}/${testExec}")
    set(RUN_CMD "${DIR_FOR_TESTING}/${name}/${testExec}.sh")

    if (WIN32)
        set(EXEC_TEST "${CMAKE_CURRENT_BINARY_DIR}/${testExec}.exe")
        set(RUN_CMD "${DIR_FOR_TESTING}/${name}/${testExec}.exe")

    endif (WIN32)

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        deployTest${name}
        COMMAND cqtdeployer clear -bin ${EXEC_TEST} -qmake ${Q_MAKE_EXE} -targetDir ${DIR_FOR_TESTING}/${name} -libDir \"${CMAKE_SOURCE_DIR},${CMAKE_BINARY_DIR}\" -recursiveDepth 5
        COMMENT "Deploy Test: cqtdeployer clear -bin ${EXEC_TEST} -qmake ${Q_MAKE_EXE} -targetDir ${DIR_FOR_TESTING}/${name} -libDir ${CMAKE_SOURCE_DIR} -recursiveDepth 5"
    )


    ADD_CUSTOM_TARGET(
        test${name}
        COMMAND ${RUN_CMD}
        COMMENT "=================== Run Test ==================="
        WORKING_DIRECTORY ${DIR_FOR_TESTING}/${name}
        DEPENDS deployTest${name}
    )

    add_dependencies(test test${name})


    message("prepare tests for ${RUN_CMD}")

endfunction()

function(initDeploy)

    if(TARGET deploy)
        message("the deploy target already created!")
        return()

    endif(TARGET deploy)

    message("deploy subtargets: ${DEPLOY_TARGETS_LIST}")

    ADD_CUSTOM_TARGET(
        deploy
        COMMENT "=================== Run deploy ==================="
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}

    )

endfunction()

function(addDeploy name targets targetDir)

    if(TARGET deploy${name})
        message("the deploy${name} target already created!")
        return()

    endif(TARGET deploy${name})

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        deploy${name}
        COMMAND cqtdeployer clear -binPrefix \"${CMAKE_BINARY_DIR}\" -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${targetDir} -libDir \"${CMAKE_SOURCE_DIR},${CMAKE_BINARY_DIR}\" -recursiveDepth 5
        COMMENT "Deploy: cqtdeployer clear -binPrefix \"${CMAKE_BINARY_DIR}\" -bin ${targets} -qmake ${Q_MAKE_EXE} -targetDir ${targetDir} -libDir ${CMAKE_SOURCE_DIR} -recursiveDepth 5"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    add_dependencies(deploy deploy${name})

endfunction()

function(addDeployFromFile name)

    if(TARGET deploy${name})
        message("the deploy${name} target already created!")
        return()

    endif(TARGET deploy${name})

    find_program(Q_MAKE_EXE qmake)

    ADD_CUSTOM_TARGET(
        deploy${name}
        COMMAND cqtdeployer -qmake ${Q_MAKE_EXE} -binPrefix \"${CMAKE_BINARY_DIR}\" -libDir \"${CMAKE_SOURCE_DIR},${CMAKE_BINARY_DIR}\"
        COMMENT "Deploy: cqtdeployer -qmake ${Q_MAKE_EXE} -binPrefix \"${CMAKE_BINARY_DIR}\" -libDir ${CMAKE_SOURCE_DIR},${CMAKE_BINARY_DIR}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
    add_dependencies(deploy deploy${name})


endfunction()

function(addDeployFromCustomFile name file)

    if(TARGET deploy${name})
        message("the deploy${name} target already created!")
        return()

    endif(TARGET deploy${name})

    find_program(Q_MAKE_EXE qmake)

    file(GLOB ${name}files
            "${file}*"
        )

    ADD_CUSTOM_TARGET(
        deploy${name}
        SOURCES ${${name}files}
        COMMAND cqtdeployer -qmake ${Q_MAKE_EXE} -binPrefix \"${CMAKE_BINARY_DIR}\" -confFile ${file} -libDir \"${CMAKE_SOURCE_DIR},${CMAKE_BINARY_DIR}\"
        COMMENT "Deploy: cqtdeployer -qmake ${Q_MAKE_EXE} -binPrefix \"${CMAKE_BINARY_DIR}\" -confFile ${file} -libDir ${CMAKE_SOURCE_DIR},${CMAKE_BINARY_DIR}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    add_dependencies(deploy deploy${name})

endfunction()

function(addDeploySnap name targetDir)

    if(TARGET snap${name})
        message("the snap${name} target already created!")
        return()

    endif(TARGET snap${name})

    find_program(SNAPCRAFT_EXE "snapcraft")

    if(NOT EXISTS ${SNAPCRAFT_EXE})
        message("please install the snapcraft before deploy this project! Use: sudo snap install snapcraft --classic")
        return()
    endif(NOT EXISTS ${SNAPCRAFT_EXE})

    ADD_CUSTOM_TARGET(
        snapClear${name}
        COMMAND snapcraft clean ${SNAPCRAFT_MODE}
        COMMENT "clear snap: snapcraft clean ${SNAPCRAFT_MODE}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}

    )

    ADD_CUSTOM_TARGET(
        snapcraft${name}
        COMMAND snapcraft ${SNAPCRAFT_MODE}
        COMMENT "create snap: snapcraft ${SNAPCRAFT_MODE}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        DEPENDS deploy${name} snapClear${name}
    )

    ADD_CUSTOM_TARGET(
        snapcraftCopy${name}
        COMMAND ${CMAKE_COMMAND} -E copy *.snap ${targetDir}
        COMMENT "copy snap: ${CMAKE_COMMAND} -E copy *.snap ${targetDir}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        DEPENDS snapcraft${name}

    )

    ADD_CUSTOM_TARGET(
        snap${name}
        COMMENT "deploy snap${name}"
        DEPENDS snapcraftCopy${name}

    )

    add_dependencies(deploy snap${name})


endfunction()

function(addDeployQIF name sourceDir targetDir config)

    if(TARGET qifDeploy${name})
        message("the qifDeploy${name} target already created!")
        return()

    endif(TARGET qifDeploy${name})

    find_program(BINARYCREATOR_EXE binarycreator)

    IF(NOT EXISTS ${BINARYCREATOR_EXE})
        message("the Binarycreator not exits please install or adde path to QtInstaller Framework to PATH and run cmake again!")
        return()
    endif(NOT EXISTS ${BINARYCREATOR_EXE})

    set(OUT_EXE ${targetDir}/${PROJECT_NAME}OfllineInstaller.run)
    if (WIN32)
        set(OUT_EXE ${targetDir}/${PROJECT_NAME}OfllineInstaller.exe)
    endif (WIN32)

    ADD_CUSTOM_TARGET(
        qifDeploy${name}
        COMMAND ${BINARYCREATOR_EXE} --offline-only -c ${config} -p ${sourceDir}/packages ${OUT_EXE}
        COMMENT "deploy qif: ${BINARYCREATOR_EXE} --offline-only -c ${config} -p ${sourceDir}/packages ${OUT_EXE}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        DEPENDS deploy${name}

    )

    add_dependencies(deploy qifDeploy${name})

endfunction()

function(addDeployIPA name bundle_id targetDir version appleDir)

    if(TARGET deployIPA${name})
        message("the deployIPA${name} target already created!")
        return()

    endif(TARGET deployIPA${name})

    if("${appleDir}" STREQUAL "")
        set(appleDir "${CMAKE_CURRENT_SOURCE_DIR}/apple")
    endif()

    set(QUASAR_CUSTOM_PLIST "${appleDir}/Info.plist")
    if (NOT EXISTS "${QUASAR_CUSTOM_PLIST}")
        set(QUASAR_CUSTOM_PLIST "${QUASAR_MODULE_CURRENT_DIR}/QtIosCMake/Info.plist.in")
    endif()

    message("Use Apple dir: ${appleDir}")

    add_qt_ios_app(${name}
      NAME ${name}
      BUNDLE_IDENTIFIER ${bundle_id}
      LONG_VERSION ${version}
      SHORT_VERSION ${version}
      VERSION ${version}
      CUSTOM_PLIST ${QUASAR_CUSTOM_PLIST}
      COPYRIGHT "QuasarApp 2022-2022"
      ASSET_DIR "${appleDir}/Assets.xcassets"
      TEAM_ID ${CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM}
      QT_IOS_LAUNCHSCREEN_STORYBOARD
      LAUNCHSCREEN_STORYBOARD "${appleDir}/LaunchScreen.storyboard"
      CATALOG_APPICON "AppIcon"
      ORIENTATION_PORTRAIT
      ORIENTATION_PORTRAIT_UPDOWN
      ORIENTATION_LANDSCAPE_LEFT
      ORIENTATION_LANDSCAPE_RIGHT
      IPA
      UPLOAD_SYMBOL
      VERBOSE
    )


    if (${QT_VERSION_MAJOR} EQUAL 5)

        if("${qmlRoot}" STREQUAL "")
            set(qmlRoot ${CMAKE_SOURCE_DIR})
        endif()

        qt_generate_plugin_import(${name} VERBOSE)

        # EXTRA_PLUGIN are the one required by plugin loaded by qt_generate_plugin_import
        # It's not automatic yet :( All this workflow might change in future version of qt
        # with better and better cmake support
        qt_generate_qml_plugin_import(${name}
          QML_SRC ${qmlRoot}
          EXTRA_PLUGIN
            QtQuickVirtualKeyboardPlugin
            QtQuickVirtualKeyboardSettingsPlugin
            QtQuickVirtualKeyboardStylesPlugin
            QmlFolderListModelPlugin
            QQuickLayoutsPlugin
          VERBOSE
        )

        qt5_import_plugins(${name} INCLUDE Qt5::QSvgPlugin)

    endif()


    ADD_CUSTOM_TARGET(
        deployIPA${name}
        COMMAND ${CMAKE_COMMAND} -E copy *.ipa ${targetDir}
        COMMENT "copy ipa: ${CMAKE_COMMAND} -E copy *.ipa ${targetDir}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${name}Ipa"

    )

    ADD_CUSTOM_TARGET(
        deployIPAd${name}
        COMMAND ${CMAKE_COMMAND} -E copy *.plist ${targetDir}
        COMMENT "copy plist: ${CMAKE_COMMAND} -E copy *.plist ${targetDir}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${name}Ipa"

    )

    add_dependencies(deploy deployIPA${name})
    add_dependencies(deploy deployIPAd${name})

endfunction()

function(addDeployAPK name android_src targetDir extraLibs)

    if(TARGET deployAPK${name})
        message("the deployAPK${name} target already created!")
        return()

    endif(TARGET deployAPK${name})

    IF(NOT DEFINED ENV{ANDROID_SDK_ROOT})
        message("the ANDROID_SDK_ROOT is not defined. define ANDROID_SDK_ROOT variable and run cmake again!")
        return()
    endif()

    IF(DEFINED ENV{ANDROID_API_VERSION})
        set(ANDROID_PLATFORM_LEVEL $ENV{ANDROID_API_VERSION})
    else()
        set(ANDROID_PLATFORM_LEVEL 30)
    endif()
    message("The ANDROID_PLATFORM_LEVEL = ${ANDROID_PLATFORM_LEVEL}")


    add_qt_android_apk(createAPK${name} ${name}
        PACKAGE_SOURCES ${android_src}
        DEPENDS ${extraLibs}
        )

    ADD_CUSTOM_TARGET(
        deployAPK${name}
        COMMAND ${CMAKE_COMMAND} -E copy *.apk ${targetDir}
        COMMENT "copy apk: ${CMAKE_COMMAND} -E copy *.apk ${targetDir}"
        WORKING_DIRECTORY ${QT_ANDROID_APP_BINARY_DIR}/build/outputs/apk/debug
        DEPENDS createAPK${name}

    )

    ADD_CUSTOM_TARGET(
        deployAAB${name}
        COMMAND ${CMAKE_COMMAND} -E copy *.aab ${targetDir}
        COMMENT "copy aab: ${CMAKE_COMMAND} -E copy *.aab ${targetDir}"
        WORKING_DIRECTORY ${QT_ANDROID_APP_BINARY_DIR}/build/outputs/bundle/release
        DEPENDS deployAPK${name}

    )

    add_dependencies(deploy deployAPK${name})
    add_dependencies(deploy deployAAB${name})

endfunction()

function(addDeploySignedAPK name android_src aliase keystore keystorePass targetDir extraLibs)

    if(TARGET deployAPK${name})
        message("the deployAPK${name} target already created!")
        return()

    endif(TARGET deployAPK${name})

    IF(NOT DEFINED ENV{ANDROID_SDK_ROOT})
        message("the ANDROID_SDK_ROOT is not defined. define ANDROID_SDK_ROOT variable and run cmake again!")
        return()
    endif()

    IF(DEFINED ENV{ANDROID_API_VERSION})
        set(ANDROID_PLATFORM_LEVEL $ENV{ANDROID_API_VERSION})
    else()
        set(ANDROID_PLATFORM_LEVEL 30)
    endif()
    message("The ANDROID_PLATFORM_LEVEL = ${ANDROID_PLATFORM_LEVEL}")


    add_qt_android_apk(createAPK${name} ${name}
        PACKAGE_SOURCES ${android_src}
        KEYSTORE ${keystore} ${aliase}
        KEYSTORE_PASSWORD ${keystorePass}
        DEPENDS ${extraLibs}
        )

    ADD_CUSTOM_TARGET(
        deployAPK${name}
        COMMAND ${CMAKE_COMMAND} -E copy *.apk ${targetDir}
        COMMENT "copy apk: ${CMAKE_COMMAND} -E copy *.apk ${targetDir}"
        WORKING_DIRECTORY ${QT_ANDROID_APP_BINARY_DIR}/build/outputs/apk/release
        DEPENDS createAPK${name}

    )

    ADD_CUSTOM_TARGET(
        deployAAB${name}
        COMMAND ${CMAKE_COMMAND} -E copy *.aab ${targetDir}
        COMMENT "copy aab: ${CMAKE_COMMAND} -E copy *.aab ${targetDir}"
        WORKING_DIRECTORY ${QT_ANDROID_APP_BINARY_DIR}/build/outputs/bundle/release
        DEPENDS deployAPK${name}

    )

    add_dependencies(deploy deployAPK${name})
    add_dependencies(deploy deployAAB${name})

endfunction()

function(initRelease)

    if(TARGET release)
        message("the release target already created!")
        return()

    endif(TARGET release)
    message("release subtargets: ${RELEASE_TARGETS_LIST}")

    ADD_CUSTOM_TARGET(
        release
        COMMENT "=================== Relese project ==================="
    )

endfunction()

function(addReleaseCustom name pyFile)

    if(TARGET pyRelease${name})
        message("the pyRelease${name} target already created!")
        return()

    endif(TARGET pyRelease${name})

    file(GLOB ${name}files
            "${pyFile}*"
        )

    ADD_CUSTOM_TARGET(
        pyRelease${name}
        SOURCES ${${name}files}
        COMMAND python pyFile
        COMMENT "pyRelease${name} release: run python ${pyFile}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}

    )

    add_dependencies(release pyRelease${name})

endfunction()

function(addReleaseSnap name)

    if(TARGET snapRelease${name})
        message("the snapRelease${name} target already created!")
        return()

    endif(TARGET snapRelease${name})

    ADD_CUSTOM_TARGET(
        snapRelease${name}
        COMMAND snapcraft push
        COMMENT "snapRelease${name} release"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}

    )

    add_dependencies(release snapRelease${name})

endfunction()

function(addReleaseQif name sourceDir targetDir)
    if(TARGET qifRelease${name})
        message("the qifRelease${name} target already created!")
        return()

    endif(TARGET qifRelease${name})

    find_program(BINARYCREATOR_EXE binarycreator)

    IF(NOT EXISTS ${BINARYCREATOR_EXE})
        message("the Binarycreator not exits please install or adde path to QtInstaller Framework to PATH and run cmake again!")
        return()
    endif(NOT EXISTS ${BINARYCREATOR_EXE})

    set(OUT_EXE ${targetDir}/${PROJECT_NAME}OfllineInstaller.run)
    if (WIN32)
        set(OUT_EXE ${targetDir}/${PROJECT_NAME}OfllineInstaller.exe)
    endif (WIN32)

    ADD_CUSTOM_TARGET(
        qifDeployOnline${name}
        COMMAND ${BINARYCREATOR_EXE} --online-only -c ${config} -p ${sourceDir}/packages ${OUT_EXE}
        COMMENT "deploy qif online: ${BINARYCREATOR_EXE} --online-only -c ${config} -p ${sourceDir}/packages ${OUT_EXE}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}

    )

    ADD_CUSTOM_TARGET(
        qifRelease${name}
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${sourceDir}
        ${CMAKE_BINARY_DIR}/Repo
        COMMENT "qifRelease${name} release ${CMAKE_COMMAND} -E copy_directory ${sourceDir} ${CMAKE_BINARY_DIR}/Repo"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        DEPENDS qifDeployOnline${name}
       )

   set(RELEASE_TARGETS_LIST ${RELEASE_TARGETS_LIST} qifRelease${name} PARENT_SCOPE)
   add_dependencies(release qifRelease${name})


endfunction()

function(addDoc name doxygenFile)

    if(TARGET doxygen${name})
        message("the doxygen${name} target already created!")
        return()

    endif(TARGET doxygen${name})

    find_program(DOXYGEN_EXECUTABLE doxygen)

    IF(NOT EXISTS ${DOXYGEN_EXECUTABLE})
        message("the doxygen not exits please install or add a path to doxygen to a PATH envirement variable and run cmake again!")
        return()
    endif(NOT EXISTS ${DOXYGEN_EXECUTABLE})


    file(GLOB ${name}files
            "${doxygenFile}*"
        )

    ADD_CUSTOM_TARGET(
        doxygen${name}
        SOURCES ${${name}files}
        COMMAND ${DOXYGEN_EXECUTABLE} ${doxygenFile}
        COMMENT "${DOXYGEN_EXECUTABLE} ${doxygenFile}"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}

    )

    add_dependencies(doc doxygen${name})

endfunction()

function(initDoc)
    if(TARGET doc)
        message("the doc target already created!")
        return()

    endif(TARGET doc)

    message("doc subtargets: ${DOC_TARGETS_LIST}")

    ADD_CUSTOM_TARGET(
        doc
        COMMENT "=================== Run generate docs ==================="
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

endfunction()

function(initAll)
    initTests()
    initDoc()
    initDeploy()
    initRelease()

endfunction()

