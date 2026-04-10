# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
if(DEFINED ENV{AZ_KEY_VAULT_CERTIFICATE})
    include("${CMAKE_CURRENT_LIST_DIR}/PackageSignCommon.cmake")

    set(CPACK_INNOSETUP_SETUP_SignedUninstaller ON)
    string(REPLACE ";" " " AZ_SIGNTOOL_ARGS_STR "${AZ_SIGNTOOL_ARGS}")
    string(REPLACE "$" "$$" AZ_SIGNTOOL_ARGS_STR "${AZ_SIGNTOOL_ARGS_STR}")
    string(REPLACE "\"" "$q" AZ_SIGNTOOL_ARGS_STR "${AZ_SIGNTOOL_ARGS_STR}")
    set(CPACK_INNOSETUP_SETUP_SignTool "azuresigntool ${AZ_SIGNTOOL_EXECUTABLE} ${AZ_SIGNTOOL_ARGS_STR} $f")
    set(CPACK_INNOSETUP_EXECUTABLE_ARGUMENTS "/Sazuresigntool=$p")
endif()
