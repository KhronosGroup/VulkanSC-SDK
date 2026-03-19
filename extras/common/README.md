# Vulkan SC SDK

This document describes the content, the requirements and procedure for getting started with the _Vulkan SC SDK_.

- [Vulkan SC SDK](#vulkan-sc-sdk)
  - [Introduction](#introduction)
  - [Terminology](#terminology)
  - [System requirements](#system-requirements)
  - [Installation](#installation)
    - [Windows installation instructions](#windows-installation-instructions)
      - [Unattended Windows installation](#unattended-windows-installation)
    - [Linux installation instructions](#linux-installation-instructions)
      - [Unattended Linux installation](#unattended-linux-installation)
  - [Using the Vulkan SC SDK](#using-the-vulkan-sc-sdk)
    - [Manual environment setup](#manual-environment-setup)
    - [Components](#components)
      - [Vulkan SC Headers](#vulkan-sc-headers)
      - [Vulkan SC Emulation Driver Stack](#vulkan-sc-emulation-driver-stack)
      - [Vulkan SC Info](#vulkan-sc-info)
      - [Vulkan SC Cube Demo](#vulkan-sc-cube-demo)
      - [Vulkan SC Validation Layers](#vulkan-sc-validation-layers)
      - [Vulkan SC Device Simulation Layer](#vulkan-sc-device-simulation-layer)
      - [Vulkan JSON Gen Layer](#vulkan-json-gen-layer)
    - [CMake integration](#cmake-integration)
      - [PCC discovery and integration](#pcc-discovery-and-integration)


## Introduction

The [Khronos Vulkan SC API](https://www.khronos.org/vulkansc/) is an explicit, low-overhead, deterministic and robust API based on the [Khronos Vulkan API](https://www.khronos.org/vulkan/) that enables state-of-the-art GPU-accelerated graphics and computation to be deployed in safety-critical systems that are certified to meet industry functional safety standards.

The _Vulkan SC SDK_ enables developers to build _Vulkan SC_ applications on consumer development platforms. Targeting native Vulkan SC platforms with the _Vulkan SC SDK_ is enabled through cross-compilation. For such cross-compilation toolchains and instructions, please refer to your Vulkan SC platform vendor provider.

The _Vulkan SC SDK_ source code is [available on Github](https://github.com/KhronosGroup/VulkanSC-SDK) and includes components packaged from the following source repositories:

 * [Vulkan SC Headers](https://github.com/KhronosGroup/VulkanSC-Headers)
 * [Vulkan SC Loader](https://github.com/KhronosGroup/VulkanSC-Loader)
 * [Vulkan SC Tools](https://github.com/KhronosGroup/VulkanSC-Tools)
 * [Vulkan SC Validation Layers](https://github.com/KhronosGroup/VulkanSC-ValidationLayers)
 * [Vulkan SC Emulation driver stack](https://github.com/KhronosGroup/VulkanSC-Emulation)
 * [Vulkan SC Pipeline Cache Utilities](https://github.com/KhronosGroup/VulkanSC-pcutil)

**Important:** This SDK only installs a single Vulkan SC driver: the _Vulkan SC Emulation_ driver. This driver emulates the Vulkan SC API on top of the Vulkan API, therefore using it requires the user to install compatible Vulkan drivers (minimum Vulkan 1.2 with Vulkan Memory Model support). In order to install Vulkan drivers and/or native Vulkan SC drivers, please refer to your system GPU vendor's website.


## Terminology

| Term | Description |
|------|-------------|
| ICD  | Installable Client Driver (i.e. a Vulkan SC or Vulkan display driver) |
| PCC  | Pipeline Cache Compiler (offline compiler to create Vulkan SC pipeline cache binaries) |
| Loader | The library that exposes the API entry points and manages the layers and drivers available on the system |
| Layer | A library designed to work as a plug-in for the loader/API |


## System requirements

Using the SDK requires the following minimum development system hardware and software requirements:

  * 64-bit Intel/AMD CPU
  * Windows 10 64-bit OS (for the Windows version of the SDK)
  * Ubuntu 22.04 or 24.04 64-bit (for the Linux version of the SDK - other distributions may work but are not verified on a regular basis)
  * Vulkan drivers (for running Vulkan SC applications on development systems using the _Vulkan SC Emulation_ driver)
  * Sufficient free disk space to install the _Vulkan SC SDK_
  * Optional: additional vendor-specific Vulkan SC SDKs, drivers, and/or toolchains (for developing Vulkan SC applications for native Vulkan SC platforms)


## Installation

The _Vulkan SC SDK_ releases are [available on Github](https://github.com/KhronosGroup/VulkanSC-SDK/releases/) in the following packaging options:

  * Windows x64 zip package
  * Windows x64 installer package
  * Linux x64 tarball package
  * Linux x64 installer package

The zip/tarball packages contain all the contents of the SDK and utilities to set up Vulkan SC development environments (as discussed in the [Manual environment setup](#manual-environment-setup) section). The installer packages provide the additional option to register the installed components to the user/system environment enabling a more out-of-the-box, readily available development environment.


### Windows installation instructions

The Windows version of the _Vulkan SC SDK_ is available as an [Inno Setup](https://jrsoftware.org/isinfo.php) installer package. When using the Windows installer package, the installer provides the option (enabled by default) to register the installed components with the system. If not selected, the development environment requires manual setup, as discussed in the [Manual environment setup](#manual-environment-setup) section. If selected, the installer will register the installed components as follows:

  * The installed ICDs, PCCs, and layers are registered in the Windows registry under `HKLM\Software\Khronos\*`
  * Environment variables (`VULKANSC_SDK`, `PATH` modifications, etc.) and build tools (e.g. CMake packages and utilities) are registered with the system

The latest SDK installed with registration therefore will be readily available to the user without additional environment configuration.

**Note:** The environment variable settings after installation with registration may only be available after restarting the system.

Alternatively, the Windows version of the _Vulkan SC SDK_ is also available as a zip package. Manual installation from the Windows zip package is as simple as unzipping the package to any folder. In this case no Vulkan SC development components are registered with the system and the development environment requires manual setup.


#### Unattended Windows installation

The relevant command line options of the Windows installer are as presented below:

```bat
VulkanSC-SDK-<version>-Windows-<architecture>.exe [/VERYSILENT] [/DIR="<path>"] [/TASKS="!Register"]
```

`/VERYSILENT`
  * Invokes the installer silently, suppressing any window output

`/DIR="<path>"`
  * Specifies the destination installation path (defaults to `%SystemDrive%\VulkanSCSDK\<version>\`)

`/TASKS="!Register"`
  * Asks the installer to **NOT** register the installed components with the system (by default, component registration is enabled)


### Linux installation instructions

The Linux version of the _Vulkan SC SDK_ is available as a [Makeself](https://makeself.io/) self-extractable installer package. This installer package can be executed either as a regular Linux user or with root privileges (e.g. with `sudo`).

The default installation path for the SDK is as follows:

  * `$HOME/VulkanSCSDK/<version>/` for user installs
  * `/opt/Khronos/VulkanSCSDK/<version>/` for root installs

When using the Linux installer package, the installer provides the option to register the installed components with the system. If not selected, the development environment requires manual setup, as discussed in the [Manual environment setup](#manual-environment-setup) section. If selected, the installer will register the installed components as follows:

  * The installed ICDs, PCCs, and layers are registered in the file system using symlinks (under `$HOME/.local/share` for user installs or under `/usr/local/share` for root installs)
  * Environment variables (`VULKANSC_SDK`, `PATH` and `LD_LIBRARY_PATH` modifications, etc.) are registered through updating the user-specified profile file (defaults to `$HOME/.profile` for user installs or `/etc/profile.d/vulkansc-sdk.sh` for root installs)
  * Build tools (e.g. CMake packages and utilities) are registered (under `$HOME/.cmake/packages/VulkanSC` for user installs or under `/usr/local/share/cmake/VulkanSC` for root installs)

The installer will also generate a script called `uninstall.sh` in the installation path that can be invoked to uninstall the SDK. This will also unregister the environment variable changes applied in the profile file modified during installation and remove the symlinks from the file system.

**Note:** The environment variable settings after installation with registration may only be available after restarting the system and/or opening a new shell/session.

Alternatively, the Linux version of the Vulkan SC SDK is also available as a tarball package. Manual installation from the Linux tarball package is as simple as extracting the package to any folder, e.g.:

```bash
tar xzf VulkanSC-SDK-<version>-Linux-<architecture>.tar.gz
```

In this case no Vulkan SC development components are registered with the system and the development environment requires manual setup.


#### Unattended Linux installation

The relevant command line options of the Linux installer are as presented below:

```bash
./VulkanSC-SDK-<version>-Linux-<architecture>.run [--accept] [-- <installer-options>]
```

The `--accept` flag can be specified to automatically accept the SDK license, while additional installer options can be provided after the `--` indicated above (note that there is an additional space between `--` and the installer options). Available installer options are as follows:

`--prefix <path>`
  * Specifies the destination installation path (defaults to `$HOME/VulkanSCSDK/<version>/` for user installs and `/opt/Khronos/VulkanSCSDK/<version>/` for root installs)

`--register`
  * Registers the components with the system (without asking the user)

`--noregister`
  * Does not register the components (without asking the user)

`--envprofile <profilefile>`
  * Specifies the file name of the profile to include the environment variable configuration in (defaults to `$HOME/.profile` for user installs or `/etc/profile.d/vulkansc-sdk.sh` for root installs)

`--verbose`
  * Outputs details during the installation

`--force`
  * Forces installation even if a previous installation already exists in the destination installation path

The following example installs under `$HOME/dev/VulkanSC-SDK` with component registration and including the environment configuration in the profile `$HOME/.bashrc`, automatically accepting the SDK license:

```bash
# Example
./VulkanSC-SDK-<version>-Linux-<architecture>.run --accept -- --prefix $HOME/dev/VulkanSC-SDK --register --envprofile $HOME/.bashrc
```


## Using the Vulkan SC SDK

If the _Vulkan SC SDK_ was installed using one of the installers with component registration enabled, then the installed components are readily available for use. This can be verified, for example, by running the `vksccube` sample:

```
vksccube
```

**Note:** `vksccube` runs using the _Vulkan SC Emulation_ driver, by default, therefore it requires a compatible GPU and Vulkan driver installed supporting Vulkan 1.2 and the Vulkan Memory Model. For details on how to run `vksccube` with other native Vulkan SC drivers, please refer to your Vulkan SC platform vendor provider.

Information about the available Vulkan SC devices can also be listed using the `vulkanscinfo` command, e.g.:

```
vulkanscinfo --summary
```

The installation path of the currently active _Vulkan SC SDK_ is available through the environment variable `VULKANSC_SDK` and can be listed as follows:

**Windows:**
```
echo %VULKANSC_SDK%
```

**Linux:**
```
echo $VULKANSC_SDK
```


### Manual environment setup

If the _Vulkan SC SDK_ was not installed with the installer and component registration enabled, then the development environment needs manual setup. The SDK package provides helper scripts to make this process trivial.

On Windows, the `setup-env.bat` located in the root directory of the SDK installation path needs to be executed to set the appropriate environment variables, e.g.:

```
cd <installation-path>
setup-env.bat
```

On Linux, the `setup-env.sh` located in the root directory of the SDK installation path needs to be sourced to set the appropriate environment variables, e.g.:

```
cd <installation-path>
. ./setup-env.sh
```

These scripts set up the following environment variables to configure the development environment to use the specific _Vulkan SC SDK_ installation:

  * `VULKANSC_SDK` - set to the installation directory of the active _Vulkan SC SDK_
  * `PATH` - prepended to include the `bin` directory of the active _Vulkan SC SDK_ to make the SDK commands (and also libraries on Windows) available in the environment
  * `LD_LIBRARY_PATH` (Linux only) - prepended to include the `lib` directory of the active _Vulkan SC SDK_ to make the SDK libraries available in the environment
  * `VK_ADD_LAYER_PATH` - set to the `share/vulkansc/explicit_layer.d` directory of the active _Vulkan SC SDK_ to make the Vulkan SC layers included in the SDK available in the environment
  * `VK_ADD_DRIVER_FILES` - set to make the _Vulkan SC Emulation_ included in the SDK available in the environment
  * `VulkanSC_ROOT` - set to make the CMake VulkanSC package available in the environment

These scripts also enable side-by-side installation and use of multiple _Vulkan SC SDK_ installations. While there can always be at most one SDK installation registered with the system (the one that was installed with registration most recently), the `setup-env.bat` and `setup-env.sh` scripts, respectively, in other SDK installations can be invoked as described above, to make the corresponding _Vulkan SC SDK_ installation active in the current shell environment.


### Components

#### Vulkan SC Headers

The official Vulkan SC headers are available after installation under the include directory `%VULKANSC_SDK%\include` (Windows) / `$VULKANSC_SDK/include` (Linux).


#### Vulkan SC Emulation Driver Stack

The Vulkan SC Emulation driver stack enables running Vulkan SC applications on top of Vulkan implementations and has two components:

 * The [Vulkan SC Emulation ICD](https://github.com/KhronosGroup/VulkanSC-Emulation/blob/main/icd/README.md)
 * The [Vulkan SC Emulation Pipeline Cache Compiler](https://github.com/KhronosGroup/VulkanSC-Emulation/blob/main/pcc/README.md)

The Vulkan SC Emulation PCC can be invoked with the `pcconvk` command.

**Important:** This driver emulates the Vulkan SC API on top of the Vulkan API, therefore using it requires the user to install compatible Vulkan drivers (minimum Vulkan 1.2 with Vulkan Memory Model support). In order to install Vulkan drivers and/or native Vulkan SC drivers, please refer to your system GPU vendor's website.


#### Vulkan SC Info

Vulkan SC Info is a program provided in the SDK that can output various types of information about the available Vulkan SC implementations and devices on the system, similar to the [Vulkan Info](https://vulkan.lunarg.com/doc/sdk/1.4.309.0/windows/vulkaninfo.html) program. For example, the command below prints a summary of available Vulkan SC devices:

```
vulkanscinfo --summary
```


#### Vulkan SC Cube Demo

The [Vulkan SC Cube Demo](https://github.com/KhronosGroup/VulkanSC-Tools/tree/sc_main/cube-vksc) is a graphical sample application that can be used to test Vulkan SC rendering.

The build of `vkscube` packaged into the SDK contains embedded pipeline cache binaries built for the
[Vulkan SC Emulation driver stack](https://github.com/KhronosGroup/VulkanSC-Emulation/). If you intend to run it with another Vulkan SC implementation, please refer to the [documentation](https://github.com/KhronosGroup/VulkanSC-Tools/blob/sc_main/cube-vksc/README.md).

Custom pipeline cache binaries can be provided to the `vksccube` program as follows:

```
vkscube --pipeline-cache <custom-binary-file>
```

**Note:** The `vksccube` uses the `VK_KHR_display` extension for window-system interaction. The Vulkan SC Emulation ICD supports this through display emulation on top of Win32/X11 windows, hence the sample should work with the Vulkan SC Emulation ICD on top of any Vulkan implementation supporting these window-systems on Windows and on Linux running X11 or Wayland (through XWayland).


#### Vulkan SC Validation Layers

The [Vulkan SC Validation Layers](https://github.com/KhronosGroup/VulkanSC-ValidationLayers) provide the ability to test Vulkan SC applications for incorrect API usage, similar to its Vulkan counterpart.

One key difference is that some validation errors can only be detected in Vulkan SC when information about the SPIR-V modules used by pipelines is available at run-time. This requires building the Vulkan SC pipeline cache binaries with debug information included, as described in the [PCC discovery and integration](#pcc-discovery-and-integration) section.

While the application can explicitly enable the validation layers (`VK_LAYER_KHRONOS_validation`), it is also possible to enable validation externally through environment variables, e.g.:

  * Windows: `set VK_LOADER_LAYERS_ENABLE=VK_LAYER_KHRONOS_validation`
  * Linux: `export VK_LOADER_LAYERS_ENABLE=VK_LAYER_KHRONOS_validation`


#### Vulkan SC Device Simulation Layer

The [Vulkan SC Device Simulation Layer](https://github.com/KhronosGroup/VulkanSC-Tools/tree/sc_main/devsim) is a layer that works similarly to the [Vulkan Profiles layer](https://vulkan.lunarg.com/doc/sdk/1.4.335.0/windows/profiles_layer.html) and can be used to override the physical device capabilities returned by the underlying Vulkan SC driver in order to "simulate" devices with different capabilities. This helps test across a wide range of hardware and driver capabilities without requiring access to such devices/drivers.

Similar to other layers, the Vulkan SC Device Simulation Layer can be enabled through environment variables, e.g.:

  * Windows: `set VK_LOADER_LAYERS_ENABLE=VK_LAYER_KHRONOS_device_simulation`
  * Linux: `export VK_LOADER_LAYERS_ENABLE=VK_LAYER_KHRONOS_device_simulation`

In addition, the `VKSC_DEVSIM_PROFILE_FILE` environment variable needs to be set to the location of the Vulkan SC device profile JSON file to use for the device capability simulation (see examples under the `tests/vulkansc/device_profiles` directory of the [VulkanSC-ValidationLayers](https://github.com/KhronosGroup/VulkanSC-ValidationLayers/tree/sc_main/tests/vulkansc/device_profiles) repository).



#### Vulkan JSON Gen Layer

This layer is the only Vulkan (_not_ Vulkan SC) layer that ships with the _Vulkan SC SDK_. The purpose of this layer is to help extract pipeline information from an existing Vulkan application to produce Vulkan SC pipeline JSON and SPIR-V files that can then be fed to a Vulkan SC PCC to produce Vulkan SC pipeline binaries.

In order to run a Vulkan application with the JSON Gen Layer, similar to other layers, it can be enabled through environment variables, e.g.:

  * Windows: `set VK_LOADER_LAYERS_ENABLE=VK_LAYER_KHRONOS_json_gen`
  * Linux: `export VK_LOADER_LAYERS_ENABLE=VK_LAYER_KHRONOS_json_gen`

In addition, the `VK_JSON_FILE_PATH` environment variable needs to be set to the location of the destination directory where the pipeline JSON and SPIR-V files will be output.

Note that unlike the Vulkan SC layers shipped with the SDK, the Vulkan JSON Gen Layer is only readily available if the SDK was installed with component registration (see the [Installation](#installation) section for more details) and is not configured by [Manual environment setup](#manual-environment-setup). This is a limitation stemming from the fact that the environment variable names used to configure layer paths (such as `VK_ADD_LAYER_PATH`) are used by both the Vulkan and Vulkan SC loader. Therefore, if not registered with the system during installation, the Vulkan JSON Gen Layer needs to be manually added to the Vulkan layer search path, e.g.:

  * Windows: `set VK_ADD_LAYER_PATH=<sdk-location>/share/vulkan/explicit_layer.d`
  * Linux: `export VK_ADD_LAYER_PATH=<sdk-location>/share/vulkan/explicit_layer.d`


### CMake integration

The _Vulkan SC SDK_ provides a CMake package called `VulkanSC` that makes all installed components available as imported targets available to use in any application using the CMake meta build system. This package can be included and used e.g. as follows:

```cmake
find_package(VulkanSC REQUIRED)
...
target_link_libraries(myApp PRIVATE VulkanSC::VulkanSC)
```

The minimum CMake requirements are as follows:

  * CMake 3.24 (Windows)
  * CMake 3.22 (Linux)

On Windows, Microsoft Visual Studio 2022 or newer is required.

The following imported targets are available under the `VulkanSC` namespace:

  * `VulkanSC::Headers` - Vulkan SC headers
  * `VulkanSC::Loader` - Vulkan SC loader
  * `VulkanSC::VulkanSC` - target containing both the Vulkan SC headers and loader
  * `VulkanSC::PCUtil` - pipeline cache reader/writer utilities

The preferred method is to link applications with the `VulkanSC::VulkanSC` CMake target in order to be compatible with all features of PCC integration.


#### PCC discovery and integration

The CMake integration for the _Vulkan SC SDK_ also provides automatic discovery of available Vulkan SC Pipeline Cache Compilers on the system and a CMake module for easy integration of pipeline cache binary targets in CMake projects.

When the `VulkanSC` CMake package is included in a project, the `VulkanSC_PCC` CMake variable can be used to select the architecture and/or device to target when building pipeline cache binaries. When using the CMake GUI, the available options are listed in a drop-down menu when setting the `VulkanSC_PCC` CMake variable. On the command line, this can be specified with the `-D VulkanSC_PCC=<target-architecture-or-device>` argument. As an example, the following will select the (default) "Emulation - Portable" architecture that is used to build pipeline cache binaries for the _Vulkan SC Emulation_ driver stack:

```
cmake -D VulkanSC_PCC="Emulation - Portable" ...
```

To list the available Vulkan SC PCC target architecture/device options, the CMake package comes with a built-in target called `VulkanSC_PCC_ListOptions` that can be invoked as shown below:

```
cmake --build <build-dir> --target VulkanSC_PCC_ListOptions
```

This built-in target should provide an output such as the following one:

```
List of available Vulkan SC PCC target architectures/devices (possible values of VulkanSC_PCC):
        * Emulation - Portable
        * NVIDIA - Jetson Orin
        * NVIDIA - Jetson Xavier
        * NVIDIA - NVIDIA GeForce RTX 4060
        * ...
```

The `VulkanSCPccUtilities` CMake module enables adding Vulkan SC pipeline cache binary targets to a CMake project as follows:

```
include(VulkanSCPccUtilities)
...
add_vksc_pipeline_cache(<target-name>
    [DEBUG]
    PATH <pipeline-json-dir>
    [FLAGS <flags>]
    OUT <out-binary>
    [DEPENDS <dependencies>]
)
```

Where:

  * `<target-name>` is the name of the pipeline cache binary target
  * `DEBUG` is an optional flag that can be specified to request the PCC to include debug information in the built pipeline cache binary
  * `PATH <pipeline-json-dir>` specifies the path of the directory containing the source pipeline JSON files to build the pipeline cache binary with
  * `FLAGS <flags>` is an optional argument that allows specifying additional flags to pass to the invoked PCC
  * `OUT <out-file>` specifies the path of the output pipeline cache binary file to write to
  * `DEPENDS <dependencies>` specifies any dependencies for building the pipeline cache binary (e.g. source SPIR-V files or pipeline JSONs that should trigger a pipeline cache binary rebuild when modified)

This enables writing portable Vulkan SC CMake projects that are agnostic to the underlying Vulkan SC PCC toolchain.

**Important:** Include the `VulkanSCPccUtilities` modules after your CMake `project()` declaration to circumvent limitations imposed by [CMP0165](https://cmake.org/cmake/help/latest/policy/CMP0165.html).

The most common form that applications are expected to invoke the `add_vksc_pipeline_cache` is as follows:

```
add_vksc_pipeline_cache(<target-name>
    $<$<CONFIG:Debug,RelWithDebInfo>:DEBUG>
    PATH <pipeline-json-dir>
    OUT <out-binary>
)
```

Where the generator expression will automatically add the `DEBUG` option when building debug builds of the project.

When the `VulkanSCPccUtilities` module is included, linking an application with the `VulkanSC::VulkanSC` CMake target amends a special stub to the application binary on development machines that will automatically apply the vendor/driver/device filters of the selected PCC toolchain to avoid accidentally running the application against the incorrect Vulkan SC driver or device. More details are provided in the documentation of [Pipeline Cache Compiler discovery](https://github.com/KhronosGroup/VulkanSC-pcutil/blob/main/docs/PccDiscovery.md).

The inclusion of this stub can be disabled even on development machines by configuring the project with the `-D VulkanSC_NO_EMBEDDED_ENVIRONMENT_STUB` command line option.

**Important:** The stub will only be linked to the application if `VulkanSCPccUtilities` is included, cross-compilation is not used, and the `VulkanSC_NO_EMBEDDED_ENVIRONMENT_STUB` variable is not defined.
