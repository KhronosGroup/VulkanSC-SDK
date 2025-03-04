# ~~~
# Copyright (c) 2025 The Khronos Group Inc.
# Copyright (c) 2025 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
cmake_minimum_required(VERSION 3.21.5...4.0)
enable_testing()

add_test(NAME Integration.Install
    COMMAND "${CMAKE_COMMAND}" --install "${PROJECT_BINARY_DIR}" --prefix "${CMAKE_INSTALL_PREFIX}" --config $<CONFIG>
)

add_test(NAME Integration.FilesExistInInstallTree
    COMMAND "${CMAKE_COMMAND}" -D "PREFIX:PATH=${CMAKE_INSTALL_PREFIX}" -P "${CMAKE_CURRENT_LIST_DIR}/FilesExist.cmake"
)
add_test(NAME Integration.FilesAbsentFromInstallTree
    COMMAND "${CMAKE_COMMAND}" -D "PREFIX:PATH=${CMAKE_INSTALL_PREFIX}" -P "${CMAKE_CURRENT_LIST_DIR}/FilesAbsent.cmake"
)

set_tests_properties(
    Integration.FilesExistInInstallTree
    Integration.FilesAbsentFromInstallTree
    PROPERTIES
        DEPENDS Integration.Install
)
