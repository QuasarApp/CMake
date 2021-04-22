
# Crossplatform module

This module include crossplatform toolchains by target platform. To select target platform set the TARGET_PLATFORM_TOOLCHAIN define.

**Availabel platforms:**
* wasm32 - use the initWasmSupport function
* win32-g++
* win64-g++

**Note:**

For add full support of the wasm32 build you shold use the initWasmSupport method. 

**initWasmSupport** (name deployFile) - This method prepare static build for wasm executable and qt resources.
* name - This is name of your initialize targets. You can set it as a CMAKE_PROJECT
* deployFile - This is path to the deploy file of the cqtdepoyer tool. Use it for deploy your site.


