# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~

# NOTE: The variables available here can be queried using the "old but gold": https://stackoverflow.com/a/9328525/1476661

# We reuse the folder originally packaged by renaming it and overwriting the package with the misnamed root folder inside
file(RENAME "${CPACK_TEMPORARY_INSTALL_DIRECTORY}" "${CPACK_TOPLEVEL_DIRECTORY}/${CPACK_PACKAGE_VERSION}")
if(CPACK_GENERATOR MATCHES "ZIP")
    set(MODE "c")
    set(FORMAT --format=zip)
elseif(CPACK_GENERATOR MATCHES "TGZ")
    set(MODE "cz")
    set(FORMAT --format=gnutar)
endif()
execute_process(
    COMMAND "${CMAKE_COMMAND}" "-E" "tar" ${MODE} "${CPACK_OUTPUT_FILE_NAME}" ${FORMAT} "--" "${CPACK_PACKAGE_VERSION}"
    COMMAND_ERROR_IS_FATAL ANY
    WORKING_DIRECTORY "${CPACK_TOPLEVEL_DIRECTORY}"
    COMMAND_ECHO STDOUT
)