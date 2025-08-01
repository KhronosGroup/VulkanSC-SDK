# ~~~
# Copyright (c) 2025 The Khronos Group Inc.
# Copyright (c) 2025 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
cmake_minimum_required(VERSION 3.21.5...4.0)
enable_testing()

project(VulkanSC-SDK
    VERSION 1.0.19
    LANGUAGES NONE
)

option(VKSC_SDK_BUILD_TESTS "Do consistency checks as CTests" ${PROJECT_IS_TOP_LEVEL})
set(VKSC_SDK_USE_TAG "vksc${PROJECT_VERSION}" CACHE STRING "Tag hash of Khronos release to fetch to test with")
set(VKSC_SDK_EP_BASE "components" CACHE PATH "Path of external projects (relative to PROJECT_BINARY_DIR)")
# NOTE: VKSC_SDK_EP_BASE defaults to "components", even though the rest of the ecosystem uses "external" is
#       to allow conveniently excluding all transitive "external" folders from the source package.

include(ExternalProject)
set_directory_properties(PROPERTIES EP_BASE "${PROJECT_BINARY_DIR}/${VKSC_SDK_EP_BASE}")

set(Common_CACHE_ARGS
    "-DUPDATE_DEPS:BOOL=ON"
    "-DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>"
    "-DCMAKE_BUILD_TYPE:STRING=$<CONFIG>"
)
foreach(CACHE_ARG IN ITEMS CMAKE_C_COMPILER CMAKE_CXX_COMPILER)
    if(DEFINED CACHE{${CACHE_ARG}})
        list(APPEND Common_CACHE_ARGS "-D${CACHE_ARG}:FILEPATH=${${CACHE_ARG}}")
    endif()
endforeach()

# CMake regex engine lack quantifiers, so we brute-force 40 hex chars
set(C "[0-9a-f]")
set(GIT_TAG_REGEX "${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}${C}")
unset(C)

foreach(Project IN ITEMS Headers Loader Tools ValidationLayers Emulation)
    set(${Project}_TAG "${VKSC_SDK_USE_TAG}" CACHE STRING "Tag to use for VulkanSC-${Project}")
    if(${${Project}_TAG} MATCHES "^${GIT_TAG_REGEX}$") # If GIT_TAG is a commit hash, shallow clones don't work (as per docs)
        set(Project_SHALLOW_ARG OFF)
    else()
        set(Project_SHALLOW_ARG ON)
    endif()
    ExternalProject_Add(VulkanSC-${Project}
        GIT_REPOSITORY         https://github.com/KhronosGroup/VulkanSC-${Project}.git
        GIT_TAG                ${${Project}_TAG}
        GIT_SUBMODULES_RECURSE OFF
        GIT_SUBMODULES         ""
        GIT_SHALLOW            ${Project_SHALLOW_ARG}
        CMAKE_CACHE_ARGS       "${Common_CACHE_ARGS};${${Project}_CACHE_ARGS}"
    )
    install(DIRECTORY "${PROJECT_BINARY_DIR}/${VKSC_SDK_EP_BASE}/Install/VulkanSC-${Project}/" DESTINATION "${PROJECT_VERSION}" USE_SOURCE_PERMISSIONS)
endforeach()
install(DIRECTORY "${PROJECT_SOURCE_DIR}/extras/" DESTINATION "${PROJECT_VERSION}")

set(CPACK_SOURCE_INSTALLED_DIRECTORIES "${PROJECT_BINARY_DIR}/${VKSC_SDK_EP_BASE}/Source/;.")
set(CPACK_SOURCE_IGNORE_FILES [[\\.git/;/external/]])
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}-Source")
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}-${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY OFF)

# Must be included AFTER all CPACK_... variables are set
include(CPack)

if(VKSC_SDK_BUILD_TESTS)
    add_subdirectory(tests)
endif()