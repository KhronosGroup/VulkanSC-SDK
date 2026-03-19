# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
# Copyright (c) 2020 Andreas Atteneder
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
if(DEFINED $ENV{AZ_KEY_VAULT_CERTIFICATE})
    find_program(AZ_SIGNTOOL_EXECUTABLE azuresigntool REQUIRED)
    message(STATUS "Found azuresigntool: ${AZ_SIGNTOOL_EXECUTABLE}")
    set(AZ_SIGNTOOL_ARGS
        sign
        -kvu $ENV{AZ_KEY_VAULT_URL}
        -kvc $ENV{AZ_KEY_VAULT_CERTIFICATE}
        -kva $ENV{AZ_TOKEN}
        -fd sha256
        -td sha256
        -d VulkanSC-SDK
        -du https://www.github.com/KhronosGroup/VulkanSC-SDK
        -tr $ENV{AZ_TIMESTAMP_URL}
        -s
    )
else()
    message(FATAL_ERROR "Code signing environment not available")
endif()
