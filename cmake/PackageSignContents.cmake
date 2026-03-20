# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
if(DEFINED ENV{AZ_KEY_VAULT_CERTIFICATE})
    include("${CMAKE_CURRENT_LIST_DIR}/PackageSignCommon.cmake")

    file(GLOB BINARY_FILES RELATIVE "${CPACK_TEMPORARY_INSTALL_DIRECTORY}/bin"
        "${CPACK_TEMPORARY_INSTALL_DIRECTORY}/bin/*.exe"
        "${CPACK_TEMPORARY_INSTALL_DIRECTORY}/bin/*.dll"
    )

    execute_process(
        COMMAND "${AZ_SIGNTOOL_EXECUTABLE}" ${AZ_SIGNTOOL_ARGS} ${BINARY_FILES}
        WORKING_DIRECTORY "${CPACK_TEMPORARY_INSTALL_DIRECTORY}/bin"
        COMMAND_ERROR_IS_FATAL ANY
    )
endif()
