# Vulkan SC SDK

This repository contains the build tools to package the Vulkan SC SDK.

## Building

To build the SDK packages on Windows and Linux, execute the following CMake workflows respectively.

* Linux build setup:
  * `cmake --preset ninja-linux-ci`
  * `cmake --build --preset ninja-linux-ci-release-install`
  * `ctest --preset ninja-linux-ci-release`

* Linux tarball package:
  * `cpack -G TGZ -C Release --config ./build/CPackConfig.cmake -B ./package`

* Linux Makeself installer package:
  * Prerequisite: makeself
  * `cpack -G External -C Release --config ./build/CPackConfig.cmake -B ./package`

* Windows build setup:
  * `cmake --preset msbuild-windows-ci`
  * `cmake --build --preset msbuild-windows-ci-release-install`
  * `ctest --preset msbuild-windows-ci-release`

* Windows ZIP package:
  * `cpack -G ZIP -C Release --config ./build/CPackConfig.cmake -B ./package`

* Windows Inno Setup installer package:
  * Prerequisite: Inno Setup
  * `cpack -G INNOSETUP -C Release --config ./build/CPackConfig.cmake -B ./package`

## Installation and Usage

For installation and usage instructions for the Vulkan SC SDK see the [README.md](extras/common/README.md).
