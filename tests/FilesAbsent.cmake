# ~~~
# Copyright (c) 2025 The Khronos Group Inc.
# Copyright (c) 2025 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
cmake_minimum_required(VERSION 3.21.5...4.0)

include("${CMAKE_CURRENT_LIST_DIR}/ExpectedInstallTree.cmake")
include("${INPUT}")

file(GLOB_RECURSE installTreeEntries LIST_DIRECTORIES ON "${PREFIX}/*")
foreach(installTreeEntry IN LISTS installTreeEntries)
    if(IS_DIRECTORY "${installTreeEntry}")
        file(GLOB dirGlob "${installTreeEntry}/*")
        list(LENGTH dirGlob dirGlobLen)
        if(dirGlobLen EQUAL 0)
            file(RELATIVE_PATH installTreeEntry "${PREFIX}" "${installTreeEntry}")
            message(FATAL_ERROR "Empty directory found: <prefix>/${installTreeEntry}")
        endif()
    else()
        if(NOT installTreeEntry IN_LIST processedFiles)
            message(FATAL_ERROR "Extraneous install tree entry found: <prefix>/${installTreeEntry}")
        endif()
    endif()
endforeach()
