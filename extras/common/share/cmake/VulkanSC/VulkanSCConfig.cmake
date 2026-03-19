# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~

#[=======================================================================[.rst:
FindVulkanSC
----------

Find ecosystem components of Vulkan SC, a low-overhead, cross-platform,
safe-critical-ready 3D graphics and computing API.

IMPORTED Targets
^^^^^^^^^^^^^^^^

This module defines :prop_tgt:`IMPORTED` targets if Vulkan has been found:

``VulkanSC::Headers``
  Provides just Vulkan SC headers include paths, if found.  No library is
  included in this target.  This can be useful for applications that
  load the Vulkan SC library dynamically.

``VulkanSC::Loader``
  The main Vulkan SC library, the ICD loader.

``VulkanSC::VulkanSC``
  Imported target encompassing the headers and the ICD loader. Also sets
  up the ICD-specific environment for downstreams.

``VulkanSC::PCC``
  The pipeline cache compiler of the found platform.

``VulkanSC::PCUtil``
  Provides the header-only PCReader/PCWriter libraries.

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

``VulkanSC_FOUND``
  set to true if Vulkan SC was found
``VulkanSC_INCLUDE_DIRS``
  include directories for Vulkan SC
``VulkanSC_LIBRARIES``
  link against this library to use Vulkan SC
``VulkanSC_VERSION``
  value from ``vulkan/vulkan_sc_core.h``
``VulkanSC_PCC_EXECUTABLE``
  path to the pipeline cache compiler


The module will also defines these cache variables:

``VulkanSC_INCLUDE_DIR``
  the Vulkan SC include directory
``VulkanSC_LIBRARY``
  the path to the Vulkan SC library

Hints
^^^^^

The ``VULKANSC_SDK`` environment variable optionally specifies the
location of the Vulkan SC SDK root directory for the given
architecture.

#]=======================================================================]

cmake_minimum_required(VERSION 3.22...4.0)

if(WIN32)
    set(_VulkanSC_library_name vulkansc-1)
else()
    set(_VulkanSC_library_name vulkansc)
endif()

find_path(VulkanSC_INCLUDE_DIR
    REQUIRED
    NAMES vulkan/vulkan_sc.h
    HINTS
        "$ENV{VULKANSC_SDK}/include"
)
mark_as_advanced(VulkanSC_INCLUDE_DIR)

find_library(VulkanSC_LIBRARY
    REQUIRED
    NAMES ${_VulkanSC_library_name}
    HINTS
        "$ENV{VULKANSC_SDK}/lib"
)
mark_as_advanced(VulkanSC_LIBRARY)

if(WIN32)
    find_file(VulkanSC_LIBRARY_RUNTIME_DEPENDENCY
        REQUIRED
        NAMES NAMES ${_VulkanSC_library_name}.dll
        HINTS
            "$ENV{VULKANSC_SDK}/bin"
    )
    mark_as_advanced(VulkanSC_LIBRARY)
endif()

set(VulkanSC_LIBRARIES ${VulkanSC_LIBRARY})
set(VulkanSC_INCLUDE_DIRS "${VulkanSC_INCLUDE_DIR}")

# detect version e.g 1.0.17
set(VulkanSC_VERSION "")
if(VulkanSC_INCLUDE_DIR)
  set(VULKAN_SC_CORE_H "${VulkanSC_INCLUDE_DIR}/vulkan/vulkan_sc_core.h")
  if(EXISTS ${VULKAN_SC_CORE_H})
    set_directory_properties(PROPERTIES CMAKE_CONFIGURE_DEPENDS "${VULKAN_SC_CORE_H}")
    file(STRINGS  ${VULKAN_SC_CORE_H} VulkanSCHeaderVersionLine REGEX "^#define VK_HEADER_VERSION ")
    string(REGEX MATCHALL "[0-9]+" VulkanSCHeaderVersion "${VulkanSCHeaderVersionLine}")
    file(STRINGS  ${VULKAN_SC_CORE_H} VulkanSCHeaderVersionLine2 REGEX "^#define VK_HEADER_VERSION_COMPLETE ")
    string(REGEX MATCHALL "[0-9]+" VulkanSCHeaderVersion2 "${VulkanSCHeaderVersionLine2}")
    list(LENGTH VulkanSCHeaderVersion2 _len)
    #  versions >= 1.2.175 have an additional numbers in front of e.g. '0, 1, 2' instead of '1, 2'
    if(_len EQUAL 3)
        list(REMOVE_AT VulkanSCHeaderVersion2 0)
    endif()
    list(APPEND VulkanSCHeaderVersion2 ${VulkanSCHeaderVersion})
    list(JOIN VulkanSCHeaderVersion2 "." VulkanSC_VERSION)
  endif(EXISTS ${VULKAN_SC_CORE_H})
endif(VulkanSC_INCLUDE_DIR)

add_library(VulkanSCHeaders INTERFACE IMPORTED)
add_library(VulkanSC::Headers ALIAS VulkanSCHeaders)
add_library(VulkanSCLoader SHARED IMPORTED)
add_library(VulkanSC::Loader ALIAS VulkanSCLoader)
add_library(VulkanSCVulkanSC INTERFACE IMPORTED)
add_library(VulkanSC::VulkanSC ALIAS VulkanSCVulkanSC)
add_library(VulkanSCPCUtil INTERFACE IMPORTED)
add_library(VulkanSC::PCUtil ALIAS VulkanSCPCUtil)

target_include_directories(VulkanSCHeaders INTERFACE "${VulkanSC_INCLUDE_DIRS}")
if(WIN32)
    set_target_properties(VulkanSCLoader PROPERTIES
        IMPORTED_IMPLIB "${VulkanSC_LIBRARY}"
        IMPORTED_LOCATION "${VulkanSC_LIBRARY_RUNTIME_DEPENDENCY}"
    )
else()
    cmake_path(GET VulkanSC_LIBRARY PARENT_PATH VulkanSC_LIBRARY_DIR)
    set_target_properties(VulkanSCLoader PROPERTIES
        IMPORTED_LOCATION "${VulkanSC_LIBRARY}"
    )
endif()

target_link_libraries(VulkanSCVulkanSC INTERFACE VulkanSC::Headers VulkanSC::Loader)

target_include_directories(VulkanSCPCUtil INTERFACE "${VulkanSC_INCLUDE_DIRS}") # shared /include folder

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../Modules")
include("${CMAKE_CURRENT_LIST_DIR}/../Modules/VulkanSCPccDiscovery.cmake")
