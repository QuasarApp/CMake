
# QuasarApp module

This is main cmake module of the QuasarApp group.
All project of the QuasarApp group ust be use this module in own cmake rro directory.
Example
include(CMake/QuasarApp.cmake)
 
**This module do:**

* Print debug information.
* Prepare build type, By default it is Release mode
include ccache for project.
* Add default QussarApp  definition into code.
* Initialise all default targets. See the QuasarAppCITargets module.
* Initialise all qtUtils. See the QtUtils module.
* Initialise all crossplatform toolchains. See the crossplatform module.
