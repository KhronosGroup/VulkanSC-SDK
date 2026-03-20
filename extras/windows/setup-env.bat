:: ~~~
:: Copyright (c) 2025-2026 The Khronos Group Inc.
:: Copyright (c) 2025-2026 RasterGrid Kft.
::
:: SPDX-License-Identifier: Apache-2.0
:: ~~~
@ECHO OFF

SET VULKANSC_SDK=%~dp0
SET PATH=%VULKANSC_SDK%\bin;%PATH%
SET VK_ADD_LAYER_PATH=%VULKANSC_SDK%\share\vulkansc\explicit_layer.d
SET VK_ADD_DRIVER_FILES=%VULKANSC_SDK%\share\vulkansc\icd.d\vksconvk.json
SET VulkanSC_ROOT=%VULKANSC_SDK%
