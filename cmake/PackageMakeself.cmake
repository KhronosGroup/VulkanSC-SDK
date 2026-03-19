# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
configure_file(
    "${CMAKE_CURRENT_LIST_DIR}/PackageMakeself.in.sh"
    "${CPACK_TEMPORARY_DIRECTORY}/internal/install-script.sh"
    @ONLY
)
file(CHMOD "${CPACK_TEMPORARY_DIRECTORY}/internal/install-script.sh"
    FILE_PERMISSIONS
    OWNER_READ OWNER_WRITE OWNER_EXECUTE
    GROUP_READ GROUP_WRITE GROUP_EXECUTE
    WORLD_READ             WORLD_EXECUTE
)

# CPack is just weird and these sort of shenanigans are necessary to get external packaging tools working
cmake_path(GET CPACK_TEMPORARY_DIRECTORY PARENT_PATH PACKAGE_DIR)
cmake_path(GET PACKAGE_DIR PARENT_PATH PACKAGE_DIR)
cmake_path(GET PACKAGE_DIR PARENT_PATH PACKAGE_DIR)

execute_process(
    COMMAND "${CPACK_VKSCSDK_Makeself_EXECUTABLE}"
        "--license" "${CPACK_VKSCSDK_SOURCE_DIR}/extras/common/LICENSE.txt"
        "${CPACK_TEMPORARY_DIRECTORY}"
        "${CPACK_PACKAGE_FILE_NAME}.run"
        "Khronos Vulkan SC SDK ${CPACK_PACKAGE_VERSION}"
        "./internal/install-script.sh"
    COMMAND_ERROR_IS_FATAL ANY
    COMMAND_ECHO STDOUT
    WORKING_DIRECTORY "${PACKAGE_DIR}"
)
set(CPACK_EXTERNAL_BUILT_PACKAGES "${PACKAGE_DIR}/${CPACK_PACKAGE_FILE_NAME}.run")
