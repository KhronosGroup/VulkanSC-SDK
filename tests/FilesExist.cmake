# ~~~
# Copyright (c) 2025 The Khronos Group Inc.
# Copyright (c) 2025 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
cmake_minimum_required(VERSION 3.21.5...4.0)

set(vkscHeaders
    vk_icd.h
    vk_layer.h
    vk_platform.h
    vulkan_android.h
    vulkan_beta.h
    vulkan_directfb.h
    vulkan_fuchsia.h
    vulkan_ggp.h
    vulkan_ios.h
    vulkan_macos.h
    vulkan_metal.h
    vulkan_sc_core.h
    vulkan_sc_core.hpp
    vulkan_sc.h
    vulkan_sci.h
    vulkan_screen.h
    vulkan_vi.h
    vulkan_wayland.h
    vulkan_win32.h
    vulkan_xcb.h
    vulkan_xlib_xrandr.h
    vulkan_xlib.h
)
if(WIN32)
    set(vkscLibraries vulkansc-1)
else()
    set(vkscLibraries vulkansc)
endif()
set(vkscICDs vksconvk)
set(vkscLayers
    device_simulation
    validation
)
set(vkscExecutables
    vulkanscinfo
    vksccube
    pcconvk
)

# Start search
foreach(Header IN LISTS vkscHeaders)
    if(NOT EXISTS "${PREFIX}/include/vulkan/${Header}")
        message(FATAL_ERROR "Missing Vulkan SC header: /include/vulkan/${Header}")
    endif()
endforeach()

foreach(vkscLibrary IN LISTS vkscLibraries)
    find_library(${vkscLibrary}
        NAMES ${vkscLibrary}
        PATHS "${PREFIX}"
        PATH_SUFFIXES "lib"
        REQUIRED
    )
    if(WIN32)
        find_file(${vkscLibrary}DLL
            NAMES ${vkscLibrary}.dll
            PATHS "${PREFIX}"
            PATH_SUFFIXES "bin"
            REQUIRED
        )
    endif()
endforeach()

foreach(vkscLayer IN LISTS vkscLayers)
    if(WIN32)
        find_file(${vkscLayer}DLL
            NAMES VkSCLayer_khronos_${vkscLayer}.dll
            PATHS "${PREFIX}"
            PATH_SUFFIXES "bin"
            REQUIRED
        )
        find_file(${vkscLayer}JSON
            NAMES VkSCLayer_khronos_${vkscLayer}.json
            PATHS "${PREFIX}"
            PATH_SUFFIXES "bin"
            REQUIRED
        )
    else()
        find_library(${vkscLayer}SO
            NAMES VkSCLayer_khronos_${vkscLayer}
            PATHS "${PREFIX}"
            PATH_SUFFIXES "lib"
            REQUIRED
        )
        find_file(${vkscLayer}JSON
            NAMES VkSCLayer_khronos_${vkscLayer}.json
            PATHS "${PREFIX}"
            PATH_SUFFIXES "share/vulkansc/explicit_layer.d"
            REQUIRED
        )
    endif()
endforeach()

foreach(vkscICD IN LISTS vkscICDs)
    if(WIN32)
        find_file(${vkscICD}DLL
            NAMES ${vkscICD}.dll
            PATHS "${PREFIX}"
            PATH_SUFFIXES "bin"
        )
        find_file(${vkscICD}JSON
            NAMES ${vkscICD}.json
            PATHS "${PREFIX}"
            PATH_SUFFIXES "bin"
            REQUIRED
        )
    else()
        find_library(${vkscICD}SO
            NAMES ${vkscICD}
            PATHS "${PREFIX}"
            PATH_SUFFIXES "lib"
            REQUIRED
        )
        find_file(${vkscICD}JSON
            NAMES ${vkscICD}.json
            PATHS "${PREFIX}"
            PATH_SUFFIXES "share/vulkansc/icd.d"
            REQUIRED
        )
    endif()
endforeach()

foreach(vkscExecutable IN LISTS vkscExecutables)
    set(CMAKE_FIND_DEBUG_MODE ON)
    find_program(${vkscExecutable}VAR
        NAMES ${vkscExecutable}
        PATHS "${PREFIX}"
        PATH_SUFFIXES "bin"
        REQUIRED
    )
endforeach()
