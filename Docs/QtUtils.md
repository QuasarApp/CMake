# QtUtils module 

Module provides qt utils functions 
The module provides qt utils functions. This module contains some useful functions. Including provides translations functionality.

---

## Translation
 
--- 

**addQML** - function - This function add QML module into target and prepare qmldir file.

* This function add QML module into target and prepare qmldir file and qrc files.
* this function designed to prepare a static or shared library with qml components,
* that can be imported into other projects only after linked parent library.

#### Arguments :
- nicecery arguments:
  - target - it is name of the target for that will be added QML module.
  - QML_DIR - it is directory with QML files.
  
- optional arguments:
    -  VERSION - it is version of the QML module. Default value is 1.0.
    -  MODULE_NAME - it is name of the QML module. Default value is TARGET_NAME. For example if the target name is QEQuick3d then the module name will be QEQuick3dQML.
    -  PUBLIC - it is flag that indicate that the QML module will be public and afailable to using in all child libs. Default value is OFF.

- Example:

```cmake
     addQML(QEQuick3d QML_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
     addQML(QEQuick3d QML_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src VERSION 1.0 MODULE_NAME QEQuick3d)
    
     # To get make qml module for your shared or static library:
     addQML(${CURRENT_PROJECT} QML_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/QEQuick3d" PUBLIC)
     addQML(${CURRENT_PROJECT} QML_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/QEQuick3d" VERSION 1.0 MODULE_NAME QEQuick3d PUBLIC)
```

**prepareQM** (name sourceDir ts_files) - This function prepare translations for you projects.
 - name - This is a name of the translations target.
 - sourceDir - This is root source directory. Update will be scan this dir for prepare translations.
 - ts_files - This is list of the supported languages.

**updateGitVars** This macros update all GIT variable releative current cmakelist.txt. 
Use This macros before read **GIT_COMMIT_HASH** and **GIT_COMMIT_COUNT** variables.

## CMake Variables

- The **GIT_COMMIT_COUNT** - This variable contains commits count
- The **GIT_COMMIT_HASH** - This variable contains short version of the buildet commit hash.

### Note 

For update actualy value of git variables use the updateGitVars macros.
