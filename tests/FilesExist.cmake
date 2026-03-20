# ~~~
# Copyright (c) 2025 The Khronos Group Inc.
# Copyright (c) 2025 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~
cmake_minimum_required(VERSION 3.21.5...4.0)

include("${CMAKE_CURRENT_LIST_DIR}/ExpectedInstallTree.cmake")

# Start search
foreach(Header IN LISTS vkscHeaders)
    if(NOT EXISTS "${PREFIX}/include/vulkan/${Header}")
        message(FATAL_ERROR "Missing Vulkan SC header: /include/vulkan/${Header}")
    endif()
    list(APPEND processedFiles "${PREFIX}/include/vulkan/${Header}")
endforeach()

foreach(vkscLibrary IN LISTS vkscLibraries)
    find_library(${vkscLibrary}
        NAMES ${vkscLibrary}
        PATHS "${PREFIX}/lib"
        NO_DEFAULT_PATH
        REQUIRED
    )
    list(APPEND processedFiles "${${vkscLibrary}}")
    if(WIN32)
        find_file(${vkscLibrary}DLL
            NAMES ${vkscLibrary}.dll
            PATHS "${PREFIX}/bin"
            NO_DEFAULT_PATH
            REQUIRED
        )
        list(APPEND processedFiles "${${vkscLibrary}DLL}")
    else()
        set(${vkscLibrary}SYM "${${vkscLibrary}}")
        message(STATUS "${vkscLibrary}SYM: ${${vkscLibrary}SYM}")
        while(IS_SYMLINK "${${vkscLibrary}SYM}")
            file(READ_SYMLINK "${${vkscLibrary}SYM}" "${vkscLibrary}SYM")
            if(NOT IS_ABSOLUTE "${${vkscLibrary}SYM}")
              cmake_path(ABSOLUTE_PATH ${vkscLibrary}SYM BASE_DIRECTORY "${PREFIX}/lib" NORMALIZE)
            endif()
            list(APPEND processedFiles "${${vkscLibrary}SYM}")
        endwhile()
    endif()
endforeach()

foreach(vkscLayer IN LISTS vkscLayers)
    if(WIN32)
        find_file(${vkscLayer}DLL
            NAMES ${vkscLayer}.dll
            PATHS "${PREFIX}/bin"
            NO_DEFAULT_PATH
            REQUIRED
        )
        list(APPEND processedFiles "${${vkscLayer}DLL}")
    else()
        find_library(${vkscLayer}SO
            NAMES ${vkscLayer}
            PATHS "${PREFIX}/lib"
            NO_DEFAULT_PATH
            REQUIRED
        )
        list(APPEND processedFiles "${${vkscLayer}SO}")
    endif()
    find_file(${vkscLayer}JSON
        NAMES ${vkscLayer}.json
        PATHS "${PREFIX}/share/vulkansc/explicit_layer.d"
        NO_DEFAULT_PATH
        REQUIRED
    )
    list(APPEND processedFiles "${${vkscLayer}JSON}")
endforeach()

foreach(vkLayer IN LISTS vkLayers)
    if(WIN32)
        find_file(${vkLayer}DLL
            NAMES ${vkLayer}.dll
            PATHS "${PREFIX}/bin"
            NO_DEFAULT_PATH
            REQUIRED
        )
        list(APPEND processedFiles "${${vkLayer}DLL}")
    else()
        find_library(${vkLayer}SO
            NAMES ${vkLayer}
            PATHS "${PREFIX}/lib"
            NO_DEFAULT_PATH
            REQUIRED
        )
        list(APPEND processedFiles "${${vkLayer}SO}")
    endif()
    find_file(${vkLayer}JSON
        NAMES ${vkLayer}.json
        PATHS "${PREFIX}/share/vulkan/explicit_layer.d"
        NO_DEFAULT_PATH
        REQUIRED
    )
    list(APPEND processedFiles "${${vkLayer}JSON}")
endforeach()

foreach(vkscICD IN LISTS vkscICDs)
    if(WIN32)
        find_file(${vkscICD}DLL
            NAMES ${vkscICD}.dll
            PATHS "${PREFIX}/bin"
            NO_DEFAULT_PATH
            REQUIRED
        )
        list(APPEND processedFiles "${${vkscICD}DLL}")
    else()
        find_library(${vkscICD}SO
            NAMES ${vkscICD}
            PATHS "${PREFIX}/lib"
            NO_DEFAULT_PATH
            REQUIRED
        )
        list(APPEND processedFiles "${${vkscICD}SO}")
    endif()
    find_file(${vkscICD}JSON
        NAMES ${vkscICD}.json
        PATHS "${PREFIX}/share/vulkansc/icd.d"
        NO_DEFAULT_PATH
        REQUIRED
    )
    list(APPEND processedFiles "${${vkscICD}JSON}")
endforeach()

foreach(vkscPCC IN LISTS vkscPCCs)
    find_program(${vkscPCC}
        NAMES ${vkscPCC}
        PATHS "${PREFIX}/bin"
        NO_DEFAULT_PATH
        REQUIRED
    )
    list(APPEND processedFiles "${${vkscPCC}}")
    find_file(${vkscPCC}JSON
        NAMES ${vkscPCC}.json
        PATHS "${PREFIX}/share/vulkansc/pcc.d"
        NO_DEFAULT_PATH
        REQUIRED
    )
    list(APPEND processedFiles "${${vkscPCC}JSON}")
endforeach()

foreach(vkscExecutable IN LISTS vkscExecutables)
    find_program(${vkscExecutable}
        NAMES ${vkscExecutable}
        PATHS "${PREFIX}/bin"
        NO_DEFAULT_PATH
        REQUIRED
    )
    list(APPEND processedFiles "${${vkscExecutable}}")
endforeach()

if(WIN32)
    foreach(vkscProgramDatabase IN LISTS vkscProgramDatabases)
        find_program(${vkscProgramDatabase}PDB
            NAMES ${vkscProgramDatabase}.pdb
            PATHS "${PREFIX}/bin"
            NO_DEFAULT_PATH
            REQUIRED
        )
        list(APPEND processedFiles "${${vkscProgramDatabase}PDB}")
    endforeach()
endif()

foreach(vkscCMakeModule IN LISTS vkscCMakeModules)
    find_file(${vkscCMakeModule}CMAKE
        NAMES ${vkscCMakeModule}.cmake
        PATHS "${PREFIX}/share/cmake/Modules"
        NO_DEFAULT_PATH
        REQUIRED
    )
    list(APPEND processedFiles "${${vkscCMakeModule}CMAKE}")
endforeach()

foreach(vkscCMakeExportInterfaceFile IN LISTS vkscCMakeExportInterfaceFiles)
    if(NOT EXISTS "${PREFIX}/share/cmake/${vkscCMakeExportInterfaceFile}.cmake")
        message(FATAL_ERROR "Missing Vulkan SC CMake export file: /share/cmake/${vkscCMakeExportInterfaceFile}.cmake")
    endif()
    list(APPEND processedFiles "${PREFIX}/share/cmake/${vkscCMakeExportInterfaceFile}.cmake")
endforeach()

foreach(vkscFile IN LISTS vkscLicense vkscDocs vkscEnvSetupScripts)
    if(NOT EXISTS "${PREFIX}/${vkscFile}")
        message(FATAL_ERROR "Missing miscellaneous install tree entry: ${vkscFile}")
    endif()
    list(APPEND processedFiles "${PREFIX}/${vkscFile}")
endforeach()

file(GLOB_RECURSE vkscRegistryFile "${PREFIX}/share/vulkan/registry/*")
if(NOT vkscRegistryFile)
    message(FATAL_ERROR "Missing or empty Vulkan SC registry: /share/vulkan/registry")
endif()
list(APPEND processedFiles "${vkscRegistryFile}")

# Prodcue output for FileAbsent.cmake to pick up
list(JOIN processedFiles "\n    " processedFiles)
file(WRITE "${OUTPUT}" "set(processedFiles ${processedFiles})")
