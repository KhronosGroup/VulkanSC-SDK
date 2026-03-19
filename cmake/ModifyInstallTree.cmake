# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~

if(WIN32)
    # On Windows, components will install the JSON manifests under the bin directory.
    # However, that results in a soup of Vulkan, Vulkan SC components, including ICD, layer, and PCC manifests
    # mixed in a single directory which is not appropriate for an SDK environment.
    # Instead, we create the directory structure as on Linux for the purposes of the SDK.
    # This also requires removing the ".\" from the JSON manifests as the paths are not expected to relative.
    message(STATUS "Moving and patching JSON manifests to: ${CMAKE_INSTALL_PREFIX}/share")

    function(MOVE_AND_PATCH SRC_JSON_PATH BIN_NAME DST_DIR)
        file(MAKE_DIRECTORY "${DST_DIR}")
        cmake_path(GET SRC_JSON_PATH FILENAME JSON_NAME)
        file(RENAME "${SRC_JSON_PATH}" "${DST_DIR}/${JSON_NAME}")
        file(READ "${DST_DIR}/${JSON_NAME}" JSON_CONTENTS)
        string(REPLACE ".\\\\${BIN_NAME}" "${BIN_NAME}" PATCHED_JSON_CONTENTS "${JSON_CONTENTS}")
        file(WRITE "${DST_DIR}/${JSON_NAME}" "${PATCHED_JSON_CONTENTS}")
    endfunction()

    # Vulkan SC ICDs
    move_and_patch("${CMAKE_INSTALL_PREFIX}/bin/vksconvk.json" "vksconvk.dll" "${CMAKE_INSTALL_PREFIX}/share/vulkansc/icd.d")

    # Vulkan SC PCCs
    move_and_patch("${CMAKE_INSTALL_PREFIX}/bin/pcconvk.json" "pcconvk.exe" "${CMAKE_INSTALL_PREFIX}/share/vulkansc/pcc.d")

    # Vulkan SC layers
    move_and_patch("${CMAKE_INSTALL_PREFIX}/bin/VkSCLayer_khronos_device_simulation.json" "VkSCLayer_khronos_device_simulation.dll" "${CMAKE_INSTALL_PREFIX}/share/vulkansc/explicit_layer.d")
    move_and_patch("${CMAKE_INSTALL_PREFIX}/bin/VkSCLayer_khronos_validation.json" "VkSCLayer_khronos_validation.dll" "${CMAKE_INSTALL_PREFIX}/share/vulkansc/explicit_layer.d")

    # Vulkan layers
    move_and_patch("${CMAKE_INSTALL_PREFIX}/bin/VkLayer_khronos_json_gen.json" "VkLayer_khronos_json_gen.dll" "${CMAKE_INSTALL_PREFIX}/share/vulkan/explicit_layer.d")
endif()

# lib/cmake is used by Vulkan ecosystem components
message(STATUS "Pruning: ${CMAKE_INSTALL_PREFIX}/lib/cmake")
file(REMOVE_RECURSE "${CMAKE_INSTALL_PREFIX}/lib/cmake")

# lib/pkconfig holds defunct Vulkan SC loader .pc file
message(STATUS "Pruning: ${CMAKE_INSTALL_PREFIX}/lib/pkgconfig")
file(REMOVE_RECURSE "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig")

# share/cmake/VulkanHeaders exports under Vulkan:: namespace
message(STATUS "Pruning: ${CMAKE_INSTALL_PREFIX}/share/cmake/VulkanHeaders")
file(REMOVE_RECURSE "${CMAKE_INSTALL_PREFIX}/share/cmake/VulkanHeaders")

# share/cmake/VulkanSCPCUtil exports link against Vulkan::Headers as usual in ecosystem builds
# VulkanSCConfig.cmake re-exports the target with adequate properties
message(STATUS "Pruning: ${CMAKE_INSTALL_PREFIX}/share/cmake/VulkanSCPCUtil")
file(REMOVE_RECURSE "${CMAKE_INSTALL_PREFIX}/share/cmake/VulkanSCPCUtil")
