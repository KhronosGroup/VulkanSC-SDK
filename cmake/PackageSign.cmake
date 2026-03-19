# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
if(DEFINED ENV{AZ_KEY_VAULT_CERTIFICATE})
    include("${CMAKE_CURRENT_LIST_DIR}/PackageSignCommon.cmake")

    execute_process(
        COMMAND "${AZ_SIGNTOOL_EXECUTABLE}" ${AZ_SIGNTOOL_ARGS} "${CPACK_TEMPORARY_PACKAGE_FILE_NAME}"
        COMMAND_ERROR_IS_FATAL ANY
    )
endif()
