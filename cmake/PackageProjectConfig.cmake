# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
if(DEFINED CPACK_SOURCE_TOPLEVEL_TAG)
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_VKSCSDK_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-Source")
elseif(CPACK_GENERATOR MATCHES "ZIP|TGZ")
    if(CMAKE_VERSION VERSION_GREATER_EQUAL 4.0)
        set(CPACK_ARCHIVE_FILE_NAME "${CPACK_VKSCSDK_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_VKSCSDK_SYSTEM_NAME}-${CPACK_VKSCSDK_PROCESSOR}")
        set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_VERSION}") # The name of the root folder inside the archive
    else()
        # Pre-4.0 CPack versions can't control the outermost folder name. We touch up the package root folder package post-build time
        set(CPACK_PACKAGE_FILE_NAME "${CPACK_VKSCSDK_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_VKSCSDK_SYSTEM_NAME}-${CPACK_VKSCSDK_PROCESSOR}")
        set(CPACK_POST_BUILD_SCRIPTS "${CMAKE_CURRENT_LIST_DIR}/PackageArchiveRenameRoot.cmake")
    endif()
    set(CPACK_PRE_BUILD_SCRIPTS "${CMAKE_CURRENT_LIST_DIR}/PackageSignContents.cmake")
else()
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_VKSCSDK_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_VKSCSDK_SYSTEM_NAME}-${CPACK_VKSCSDK_PROCESSOR}")
endif()

if(CPACK_GENERATOR STREQUAL "INNOSETUP")
    set(CPACK_INNOSETUP_USE_MODERN_WIZARD ON)

    set(CPACK_INNOSETUP_PROGRAM_MENU_FOLDER "${CPACK_PACKAGE_NAME}")

    set(CPACK_INNOSETUP_ICON_FILE                  "${CPACK_VKSCSDK_SOURCE_DIR}/installer/resources/VulkanSC.ico")
    set(CPACK_INNOSETUP_SETUP_UninstallDisplayIcon "${CPACK_VKSCSDK_SOURCE_DIR}/installer/resources/VulkanSC.ico")
    set(CPACK_INNOSETUP_SETUP_WizardStyle "modern dynamic") # Modern look, light-dark theme dynamically follow system settings
    set(CPACK_INNOSETUP_SETUP_DisableWelcomePage OFF)
    set(CPACK_INNOSETUP_SETUP_WizardImageFile            "${CPACK_VKSCSDK_SOURCE_DIR}/installer/resources/VulkanSC-SDK-WizardImage.png")
    set(CPACK_INNOSETUP_SETUP_WizardImageFileDynamicDark "${CPACK_VKSCSDK_SOURCE_DIR}/installer/resources/VulkanSC-SDK-WizardImage.png")
    set(CPACK_INNOSETUP_SETUP_WizardSmallImageFile            "${CPACK_VKSCSDK_SOURCE_DIR}/installer/resources/VulkanSC.png")
    set(CPACK_INNOSETUP_SETUP_WizardSmallImageFileDynamicDark "${CPACK_VKSCSDK_SOURCE_DIR}/installer/resources/VulkanSC.png")
    set(CPACK_INNOSETUP_SETUP_WizardImageStretch ON)
    set(CPACK_INNOSETUP_SETUP_ChangesEnvironment ON)

    set(CPACK_INNOSETUP_SETUP_DefaultDirName "{sd}/VulkanSCSDK/${CPACK_PACKAGE_VERSION}")

    set(CPACK_INNOSETUP_SETUP_AppVerName "${CPACK_PACKAGE_NAME}") # By default it's "{AppName} version {AppVersion}", but we set AppName via CPACK_PACKAGE_NAME to already have the version number in it.

    set(CPACK_INNOSETUP_DEFINE_PROJECT_VERSION "${CPACK_PACKAGE_VERSION}")

    set(CPACK_INNOSETUP_EXTRA_SCRIPTS "${CPACK_VKSCSDK_SOURCE_DIR}/cmake/PackageINNOSETUP.iss")
    set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY OFF) # Avoid CPack Warning: Inno Setup Generator cannot work with CPACK_INCLUDE_TOPLEVEL_DIRECTORY set. This option will be reset to 0 (for this generator only).

    include("${CMAKE_CURRENT_LIST_DIR}/PackageSign.cmake")
    set(CPACK_PRE_BUILD_SCRIPTS "${CMAKE_CURRENT_LIST_DIR}/PackageSignContents.cmake")
endif()

if(CPACK_GENERATOR STREQUAL "External")
    set(CPACK_EXTERNAL_PACKAGE_SCRIPT "${CPACK_VKSCSDK_SOURCE_DIR}/cmake/PackageMakeself.cmake")
    set(CPACK_EXTERNAL_ENABLE_STAGING ON)
endif()
