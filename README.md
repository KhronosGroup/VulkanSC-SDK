# Vulkan SC SDK

This project provides the Khronos official Vulkan SC SDK binaries for all supported development platforms.

## Introduction

Vulkan is an explicit API, enabling direct control over how GPUs actually work. Vulkan SC is an API derived from Vulkan with various changes applied to fulfill the special requirements of safety critical (hence SC) applications.

Fron an SDK perspective, the fundamental difference between Vulkan and Vulkan SC is that vendor implementations of the prior consist of an appropriately packaged C library (the Installable Client Driver, ICD for short), while the latter consists of an ICD and a collection of toolchain components - minimally a pipeline cache compiler - required to compile a Vulkan SC application.

The pipeline cache compiler is a consequence of the ahead-of-time compilation requirement of safety critical applications. Shaders, unlike in Vulkan, can't be compiled online and must be built alongside the application. Only the final device binary may be uploaded at run-time.

The SDK itself is not safety critical certified (nor could it ever be), but it greatly facilitates developing certifiable safety critical applications for real SC environments. A real SC environment probably uses some real-time operating system (eg. QNX), requiring cross-compilation, also making debugging harder. The Vulkan SC Emulation ICD lowers the barrier to entry, allowing the development of real Vulkan SC code on readily available Vulkan-enabled end-user systems.

## Contents

The following components are packaged by this repository:

- [Vulkan SC Headers](https://github.com/KhronosGroup/VulkanSC-Headers): header files and API registry
- [Vulkan SC Loader](https://github.com/KhronosGroup/VulkanSC-Loader): installable client driver (ICD) loader
- [Vulkan SC Validation Layers](https://github.com/KhronosGroup/VulkanSC-ValidationLayers): application validity checker
- [Vulkan SC Tools](https://github.com/KhronosGroup/VulkanSC-Tools): various command-line utilities
- [Vulkan SC Emulation ICD](https://github.com/KhronosGroup/VulkanSC-Emulation): ICD implementing Vulkan SC on top of Vulkan

## Using

### Install

To use the SDK, download and extract the binary archives to any location on disk. (Samples assume `SDK_VER` and `SDK_ROOT` are a shell variables holding the version and the install location of the SDK.)

- Linux

  ```bash
  curl --location --remote-name "https://github.com/KhronosGroup/VulkanSC-SDK/releases/download/vksc${SDK_VER}/VulkanSC-SDK-${SDK_VER}-Linux-x86_64.tar.gz"
  mkdir --parents $SDK_ROOT
  tar xf ./VulkanSC-SDK-${SDK_VER}-Linux-x86_64.tar.gz --directory $SDK_ROOT --strip-components=1
  ```

  > **IMPORTANT**: The Vulkan SC headers conflict with the Vulkan headers (name collision). Linux users should only extract the binary archive system-wide if they are 100% sure Vulkan development headers won't be installed system-wide.

- Windows Command

  ```cmd
  curl --location --remote-name "https://github.com/KhronosGroup/VulkanSC-SDK/releases/download/vksc%SDK_VER%/VulkanSC-SDK-%SDK_VER%-Windows-AMD64.zip"
  md %SDK_ROOT%
  tar xf ".\VulkanSC-SDK-%SDK_VER%-Windows-AMD64.zip" --directory %SDK_ROOT% --strip-components=1
  ```

### Setup environment

To test your setup, set environment variables such that the ICD loader will only pick up the implementation of your choice. The following commands force using the Khronos Emulation ICD.

- Linux

  ```bash
  export LD_LIBRARY_PATH=${SDK_ROOT}/lib
  export VK_DRIVER_FILES=${SDK_ROOT}/share/vulkansc/icd.d/vksconvk.json
  ${SDK_ROOT}/bin/vulkanscinfo --summary
  ${SDK_ROOT}/bin/vksccube
  ```

- Windows Command

  ```cmd
  set PATH="%SDK_ROOT%\bin;%PATH%"
  set VK_DRIVER_FILES="%SDK_ROOT%\bin\vksconvk.json"
  %SDK_ROOT%\bin\vulkanscinfo --summary
  %SDK_ROOT%\bin\vksccube
  ```

#### Environment variables

The complete list of environment variables to which the ICD loader and the Emulation ICD reacts to the [ICD loader docs](https://github.com/KhronosGroup/Vulkan-Loader/blob/main/docs/LoaderInterfaceArchitecture.md) and the [emulation ICD docs](https://github.com/KhronosGroup/VulkanSC-Emulation/blob/main/icd/README.md).

## Building

> _It is highly advised to consume the SDK via the [pre-built binaries](https://github.com/KhronosGroup/VulkanSC-SDK/releases). Should that be insufficient for any reason, please refer to [BUILD.md](./BUILD.md) for details._