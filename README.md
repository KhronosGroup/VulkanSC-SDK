# Vulkan SC SDK

This repository is the prototype of a Vulkan SC SDK.

## Building

To build the SDK packages on Windows and Linux, execute the following CMake workflows respectively.

* Linux
  * `cmake --preset ninja-ci-linux`
  * `cmake --build --preset ninja-ci-linux-release-install`
  * `ctest --preset ninja-ci-linux-release`
  * `cpack -G TGZ -C Release --config ./build/CPackConfig.cmake -B ./package`

* Windows
  * `cmake --preset msbuild-ci-windows`
  * `cmake --build --preset msbuild-ci-windows-release-install`
  * `ctest --preset msbuild-ci-windows-release`
  * `cpack -G ZIP -C Release --config ./build/CPackConfig.cmake -B ./package`