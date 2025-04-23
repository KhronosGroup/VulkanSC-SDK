# Vulkan SC SDK

This package contains the components of the Vulkan SC SDK.


## Source

The source repositories of the components packaged in this SDK are the following:

 * [Vulkan SC Headers](https://github.com/KhronosGroup/VulkanSC-Headers)
 * [Vulkan SC Loader](https://github.com/KhronosGroup/VulkanSC-Loader)
 * [Vulkan SC Tools](https://github.com/KhronosGroup/VulkanSC-Tools)
 * [Vulkan SC Validation Layers](https://github.com/KhronosGroup/VulkanSC-ValidationLayers)
 * [Vulkan SC Emulation driver stack](https://github.com/KhronosGroup/VulkanSC-Emulation)


## Usage

Note: the usage instructions below use `SDK_PATH` to refer to the directory extracted from the package (e.g. `/myExtractionPath/1.0.18`).


### Vulkan SC headers

Vulkan SC applications can be built against the Vulkan SC headers provided by this package by using the include directory `<SDK_PATH>/include`.


### Runtime libraries

The package comes with a set of runtime libraries, including the [Vulkan SC Loader](https://github.com/KhronosGroup/VulkanSC-Loader), various [Vulkan SC layers](#layers), and the [Vulkan SC Emulation ICD](https://github.com/KhronosGroup/VulkanSC-Emulation/blob/main/icd/README.md). In order to make these available in the runtime environment, the library location has to be included in the shared library search path:

 * Linux
   ```bash
   export LD_LIBRARY_PATH=<SDK_PATH>/lib
   ```

 * Windows
   ```cmd
   set PATH="<SDK_PATH>\bin;%PATH"
   ```


### Layers

The SDK includes Vulkan SC layers such as the [Validation Layers](https://github.com/KhronosGroup/VulkanSC-ValidationLayers) and the [Device Simulation Layer](https://github.com/KhronosGroup/VulkanSC-Tools/blob/sc_main/devsim/README.md). In order to enable the Vulkan SC Loader to find these layers, they have to be configured through one of the layer path environment variables (`VK_LAYER_PATH` or `VK_ADD_LAYER_PATH`), e.g.:

 * Linux
   ```bash
   export VK_LAYER_PATH=<SDK_PATH>/share/vulkansc/explicit_layers.d
   ```
 * Windows
   ```cmd
   set VK_LAYER_PATH=<SDK_PATH>\bin
   ```


### Vulkan SC Emulation Driver Stack

The Vulkan SC Emulation driver stack enables running Vulkan SC applications on top of Vulkan implementations and has two components:

 * The [Vulkan SC Emulation ICD](#vulkan-sc-emulation-icd)
 * The [Vulkan SC Emulation Pipeline Cache Compiler](#vulkan-sc-emulation-pipeline-cache-compiler)


#### Vulkan SC Emulation ICD

In order to enable the Vulkan SC Loader to use the Vulkan SC Emulation ICD, it has to be configured through one of the driver file environment variables (`VK_DRIVER_FILES` or `VK_ADD_DRIVER_FILES`), e.g.:

 * Linux
   ```bash
   export VK_DRIVER_FILES=<SDK_PATH>/share/vulkansc/icd.d/vksconvk.json
   ```
 * Windows
   ```cmd
   set VK_DRIVER_FILES=<SDK_PATH>\bin\vksconvk.json
   ```

For additional configuration options, please refer to the [documentation](https://github.com/KhronosGroup/VulkanSC-Emulation/blob/main/icd/README.md).


#### Vulkan SC Emulation Pipeline Cache Compiler

In order to build pipeline caches compatible with the Vulkan SC Emulation ICD, use the `pcconvk` command, for example:

  * Linux
    ```bash
    <SDK_PATH>/bin/pcconvk --path <pipeline-json-dir> --out <pipeline-cache-binary-file>
    ```
  * Windows
    ```bash
    <SDK_PATH>\bin\pcconvk --path <pipeline-json-dir> --out <pipeline-cache-binary-file>
    ```

For additional details, see the output of the `pcconvk --help` command or refer to the [documentation](https://github.com/KhronosGroup/VulkanSC-Emulation/blob/main/pcc/README.md).


### Vulkan SC Information

Vulkan SC Info is a program provided in the SDK which outputs various types of information about the Vulkan SC implementations on the system, similar to the [Vulkan Info](https://vulkan.lunarg.com/doc/sdk/1.4.309.0/windows/vulkaninfo.html) program. For example, the command below prints a summary of available Vulkan SC devices:

  * Linux
    ```bash
    <SDK_PATH>/bin/vulkanscinfo --summary
    ```
  * Windows
    ```bash
    <SDK_PATH>\bin\vulkanscinfo --summary
    ```


### Vulkan SC Cube Demo

The [Vulkan SC Cube Demo](https://github.com/KhronosGroup/VulkanSC-Tools/tree/sc_main/cube-vksc) is a graphical sample application that can be used to test Vulkan SC rendering.

The build of `vkscube` packaged into the SDK contains embedded pipeline cache binaries built for the
[Vulkan SC Emulation driver stack](https://github.com/KhronosGroup/VulkanSC-Emulation/). If you intend to run it with another Vulkan SC implementation, please refer to the [documentation](https://github.com/KhronosGroup/VulkanSC-Tools/blob/sc_main/cube-vksc/README.md).

Custom pipeline cache binaries can be provided to the `vksccube` program as follows:

  * Linux
    ```bash
    <SDK_PATH>/bin/vksccube --pipeline-cache <custom-binary-file>
    ```
  * Windows
    ```cmd
    <SDK_PATH>\bin\vksccube --pipeline-cache <custom-binary-file>
    ```

The `vksccube` uses the `VK_KHR_display` extension for window-system interaction. The Vulkan SC
Emulation ICD supports this through display emulation on top of Win32/X11 windows, hence the sample should work with the
Vulkan SC Emulation ICD on top of any Vulkan implementation supporting these window-systems on Windows and on Linux
running X11 or Wayland (through XWayland).
