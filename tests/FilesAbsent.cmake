# ~~~
# Copyright (c) 2025 The Khronos Group Inc.
# Copyright (c) 2025 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
cmake_minimum_required(VERSION 3.21.5...4.0)

set(vkHeaders
    vulkan.h
    vulkan_core.h
    vulkan_core.hpp
)

# Start search for absent files
foreach(vkHeader IN LISTS vkHeaders)
    if(EXISTS "${PREFIX}/include/vulkan/${vkHeader}")
        message(FATAL_ERROR "Vulkan header found: /include/vulkan/${Header}")
    endif()
endforeach()

foreach(Folder IN ITEMS
    "share/vulkan/registry"
    "share/vulkan/registry/spec_tools"
)
    if(EXISTS "${PREFIX}/${Folder}/__pycache__")
        message(FATAL_ERROR "Python cache found in: ${PREFIX}/${Folder}")
    endif()
endforeach()
