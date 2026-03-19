# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~

export VULKANSC_SDK="$(dirname "$(readlink -f "${BASH_SOURCE:-$0}" )" )"
export PATH="${VULKANSC_SDK}/bin:${PATH}"
export LD_LIBRARY_PATH="${VULKANSC_SDK}/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export VK_ADD_LAYER_PATH="$VULKANSC_SDK/share/vulkansc/explicit_layer.d"
export VK_ADD_DRIVER_FILES="$VULKANSC_SDK/share/vulkansc/icd.d/vksconvk.json"
export VulkanSC_ROOT="$VULKANSC_SDK"
