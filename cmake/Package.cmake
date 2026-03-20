# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
set(CPACK_PACKAGE_NAME "Vulkan SC SDK ${PROJECT_VERSION}")
set(CPACK_PACKAGE_VENDOR "Khronos Group Inc.")
set(CPACK_PACKAGE_DESCRIPTION "Vulkan SC SDK ${PROJECT_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${CPACK_PACKAGE_NAME}") # Default is CMAKE_PROJECT_NAME, shows up in Add/Remove programs on Windows
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")                # Default is PROJECT_{MAJOR.MINOR.PATCH} without TWEAK, but we want that, should we have to amend

set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/extras/common/LICENSE.txt")
set(CPACK_PACKAGE_ICON "${PROJECT_SOURCE_DIR}/installer/resources/VulkanSC.ico")

set(CPACK_PACKAGE_EXECUTABLES
    vksccube "Vulkan SC Cube"
    vulkanscinfo "Vulkan SC Info"
)

set(CPACK_SOURCE_INSTALLED_DIRECTORIES "${PROJECT_SOURCE_DIR}" "/")
set(CPACK_SOURCE_IGNORE_FILES
    [[\\.git/]]
    [[\\.vs/]]
    [[\\.vscode/]]
    [[CMakeUserPresets\\.json]]
    [[/build/]]
    [[/install/]]
    [[/package/]]
)
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}-Source")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY ON)

set(CPACK_PROJECT_CONFIG_FILE "${CMAKE_CURRENT_LIST_DIR}/PackageProjectConfig.cmake") # Per-generator values

# Various CMake variables to pass to CPack
set(CPACK_VKSCSDK_PROJECT_NAME "${PROJECT_NAME}")
set(CPACK_VKSCSDK_PROCESSOR "${CMAKE_SYSTEM_PROCESSOR}")
set(CPACK_VKSCSDK_SYSTEM_NAME "${CMAKE_SYSTEM_NAME}")
set(CPACK_VKSCSDK_SOURCE_DIR "${PROJECT_SOURCE_DIR}")

if(VKSC_SDK_BUILD_INSTALLERS)
    if(NOT WIN32)
        ExternalProject_Add(Makeself
            GIT_REPOSITORY         https://github.com/megastep/makeself.git
            GIT_TAG                release-2.7.1
            GIT_SUBMODULES_RECURSE OFF
            GIT_SUBMODULES         ""
            GIT_SHALLOW            ON
            CONFIGURE_COMMAND      ""
            BUILD_COMMAND          ""
            INSTALL_COMMAND        ""
        )
        ExternalProject_Get_property(Makeself SOURCE_DIR)
        set(CPACK_VKSCSDK_Makeself_EXECUTABLE "${SOURCE_DIR}/makeself.sh")
    endif()
endif()

# Must be included AFTER all CPACK_... variables are set
include(CPack)