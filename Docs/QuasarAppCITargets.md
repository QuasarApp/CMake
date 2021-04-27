# QuasarAppCITargets module
 
The library contains 2 methods type it is added methods and init methods.
All inits method must be invoked before adds methods. If you change order then some add method will be ignored.

This module implementation next cmake functions:

---

## Testing
  
---
**addTestsArg** (name testExec arg) - Name target for test utility of your application.
- name - Prefix for target (any word).
- testExec - Name of tests utility (without extensions).
- arg - Arguments for testExec.

 **addTests** (name testExec) - Name target for test utility of your application (without arguments).
 - name - Prefix for target (any word).
 - testExec - Name of tests utility (without extensions).

 **initTests** - Init main test target for testing all added tests, this method need to call before all invoiced addTests methods.

---

## Deployment

---
 **addDeploy** (name targets targetDir) - Add deploy target for deployed your application via CqtDeployer tool.
 - name - This is prefix of added subtarget (any word).
 - targets - This is list of cqtdeployer targets [see CQtDeployer help](https://github.com/QuasarApp/CQtDeployer/wiki/).
 - targetDir - This is target of directory [see option targetDir](https://github.com/QuasarApp/CQtDeployer/wiki/Options) of CqtDeployer help.

 **addDeployFromFile** (name) - Some as initDeploy but use CQtDeployer.json for configuration.
 - name - This is prefix of added subtarget (any word)

 **addDeployFromCustomFile** (name file) - Some as initDeploy but use custom path for deployment file for configuration.
 - name - This is prefix of added subtarget (any word).
 - file - This is path to config file of CQtDeployer.

 **addDeploySnap** (name targetDir) - Add to deploy step substeps for create a snap package.
 - name - This is prefix of added subtarget (any word).
 - targetDir - Destanation directroy for snap files.

 **addDeployQIF** (name sourceDir targetDir config) - add to deploy step substeps for create Qt Install FrameWork Installer.
 - name - This is prefix of added subtarget (any word) location for created installer.
 - sourceDir - Path to folder with qif template.
 - config - Path to config file of qif template.

 **addDeployAPK** (name input aliase keystore keystorePass targetDir extraLibs) - Add subtargets of deploy setep for create signed android apk file.
 - name - This is prefix of added subtarget (any word).
 - android_src -  Path to folder with the android_manifest file.
 - aliase - Alise for key store.
 - keystore - Path of key store.
 - keystorePass - Pass of keystore file.
 - targetDir - Target directory for output apk file.
 - extraLibs - list f the extra libraryes (like the openssl) 

**add_qt_android_apk** (my_app_apk my_app) - This target add targets for the build apk file.
For get more information about this function see oficial [documentation](https://github.com/LaurentGomila/qt-android-cmake#options-of-the-add_qt_android_apk-macro
) of the **qt-android-cmake** toolchain.

 **initDeploy** - Create a main deploy target for all addDeploy subtargets. This method need to call before invoiced of all addDeploy methods.

---

## Release

---
 **initRelease** - Сreate the general release target for all subtargets addRelease. This method need to call before invoice all addRelease methods.

 **addReleaseSnap** (name) - Сreate subtargets for publish snap deployed snap package.
 - name - This is prefix of added subtarget (any word).

 **addReleaseQif** (name sourceDir targetDir) - Create subtargets for publish the qif package on qif repository.
 - name - This is prefix of added subtarget (any word).
 - sourceDir - Path to folder with qif template.
 - targetDir - Path to target directory.

---

## Dcumentation
 
---
 **initDoc** - Create the general doc target for all subtargets addDoc. This method need to call before invoice all addDoc methods.

 **addDoc** (name doxygenFile) - Create subtargets for generate documentation of cpp code.
 - name - This is prefix of added subtarget (any word).
 - doxygenFile - This is path to doxygen configuration file.
