# QtUtils module 

Module provides qt utils functions 
The module provides qt utils functions. This module contains some useful functions. Including provides translations functionality.

---

## Translation
 
--- 

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
