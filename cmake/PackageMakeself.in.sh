#!/bin/sh
# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~

# Script preamble heavily inspired by Robert Siemer: https://stackoverflow.com/a/29754866/1476661

# More safety, by turning some bugs into errors.
#set -o errexit -o noclobber -o nounset

# ignore errexit with `&& true`
getopt --test > /dev/null && true
if [ $? -ne 4 ]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

# option --prefix/-p and --envprofile require 1 argument
LONGOPTS=debug,force,prefix:,verbose,register,noregister,envprofile:
OPTIONS=dfp:evr

# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
# -if getopt fails, it complains itself to stderr
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@") || exit 2
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# Check root privileges
if [ $(id -u) -eq 0 ]; then
    root=true
    prefix=/opt/Khronos/VulkanSCSDK/@CPACK_PACKAGE_VERSION@
    sys_prefix=/usr/local
else
    root=false
    prefix=${HOME}/VulkanSCSDK/@CPACK_PACKAGE_VERSION@
    sys_prefix=${HOME}/.local
fi

debug=false force=false verbose=false register=false noregister=false profile=""
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -d|--debug)
            debug=true
            shift
            ;;
        -f|--force)
            force=true
            shift
            ;;
        -p|--prefix)
            prefix="$2"
            shift 2
            ;;
        -v|--verbose)
            verbose=true
            shift
            ;;
        -r|--register)
            register=true
            shift
            ;;
        -n|--noregister)
            noregister=true
            shift
            ;;
        -e|--envprofile)
            profile="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Unexpected command line argument: $1"
            exit 2
            ;;
    esac
done

if [ ${register} = true ]; then
    if [ ${noregister} = true ]; then
        echo "Options --register and --noregister are mutually exclusive"
        exit 2
    fi
fi

# We do not support installing the SDK binaries in the root FHS
if [ "$prefix" = "/" ]; then
    echo "The Vulkan SC SDK is not to be installed in the root file system directly."
    echo "Please specify a custom install location such as /opt/VulkanSC-SDK."
    exit 1
fi

if [ ${root} = true ]; then
    if [ $SUDO_USER ]; then
        if [ $verbose = true ]; then echo "Running installer as superuser $SUDO_USER."; fi
    else
        if [ $verbose = true ]; then echo "Running installer as root."; fi
    fi
    # Set umask to 022 to allow read access to everybody and write access only to the root
    umask 022
else
    if [ $verbose = true ]; then echo "Running installer as user $USER."; fi
    # Set umask to 002 to allow read access to everybody and write access to the group
    umask 002
fi

if [ ${register} = false ]; then
    if [ ${noregister} = false ]; then
        while true; do
            read -p "Register installed components and environment variables (y or n)? " doregister
            case "$doregister" in
                y|Y|yes|Yes|YES)
                    register=true
                    break
                    ;;
                n|N|no|No|NO)
                    noregister=true
                    break
                    ;;
                *)
                    echo "Unrecognized answer: $doregister"
                    ;;
            esac
        done
    fi
fi

if [ ${register} = false ]; then
    if [ "${profile}" = "" ]; then
        : # noop
    else
        echo "Unexpected --envprofile argument when --register was not specified and component and environment registration was not selected"
        exit 2
    fi
fi

if [ -d ${prefix} ]; then
    if [ ${force} = false ]; then
        while true; do
            read -p "Target already exists, do you want to uninstall previous installation and continue (y or n)?" doreinstall
            case "$doreinstall" in
                y|Y|yes|Yes|YES)
                    doreinstall=true
                    break
                    ;;
                n|N|no|No|NO)
                    doreinstall=false
                    break
                    ;;
                *)
                    echo "Unrecognized answer: $doreinstall"
                    ;;
            esac
        done
    else
        doreinstall=true
    fi
    if [ ${doreinstall} = true ]; then
        test -e ${prefix}/uninstall.sh; ret=$?
        if [ ${ret} -ne 0 ]; then
            echo "Uninstaller not present in target directory, please use a different target directory"
            exit 1
        fi
        ${prefix}/uninstall.sh; ret=$?
        if [ ${ret} -ne 0 ]; then
            echo "Failed to uninstall: ${prefix}"
            exit 1
        fi
    else
        exit 1
    fi
fi

if [ $verbose = true ]; then echo "Installing to directory: ${prefix}"; fi
mkdir -p ${prefix} > /dev/null
ret=$?
if [ ${ret} -ne 0 ]; then
    echo "Failed to create: ${prefix}"
    exit 1
fi

# Copy entire install tree
cp -r ./ ${prefix}

# Create uninstall script
uninst="${prefix}/uninstall.sh"
echo "# Auto-generated uninstall script" > ${uninst}
echo "curr_dir=\"\$(dirname \"\$(readlink -f \"\$0\" )\" )\"" >> ${uninst}
echo "prefix=$prefix" >> ${uninst}
echo "sys_prefix=$sys_prefix" >> ${uninst}
echo "if [ \"\$curr_dir\" = \"\$prefix\" ]; then" >> ${uninst}
echo "    : # noop" >> ${uninst}
echo "else" >> ${uninst}
echo "    echo \"Installation has been moved from its original location (\$prefix), cannot proceed\"" >> ${uninst}
echo "    exit 3" >> ${uninst}
echo "fi" >> ${uninst}
chmod +x ${uninst}

if [ ${register} = true ]; then
    if [ "$profile" = "" ]; then
        # Check distribution
        dist=$(cat /etc/os-release | grep '^NAME=' | sed -e 's/NAME="\([^"]*\)"/\1/g')
        if [ $verbose = true ]; then echo "Detected distribution: ${dist}"; fi
        if [ "$dist" = "Ubuntu" ]; then
            if [ ${root} = true ]; then
                profile=/etc/profile.d/vulkansc-sdk.sh
            else
                profile=${HOME}/.profile
            fi
        else
            if [ $verbose = true ]; then echo "Please specify the location of the profile to add environment setup to."; fi
            if [ ${root} = true ]; then
                if [ ${register} = true ]; then
                    read -p "System profile script to add/amend/update (/etc/profile.d/vulkansc-sdk.sh): " profile
                    if [ ! $profile ]; then profile=/etc/profile.d/vulkansc-sdk.sh; fi
                fi
            else
                if [ ${register} = true ]; then
                    read -p "User profile script to add/amend/update (${HOME}/.profile): " profile
                    if [ ! $profile ]; then profile=${HOME}/.profile; fi
                fi
            fi
        fi
    fi

    # Create Vulkan and Vulkan SC manifest directory tree
    if [ $verbose = true ]; then echo "Registering ICD, PCC and layers at: ${sys_prefix}/share"; fi
    for directory in vulkansc/icd.d vulkansc/pcc.d vulkansc/explicit_layer.d vulkan/explicit_layer.d; do
        mkdir -p ${sys_prefix}/share/${directory} > /dev/null
        ret=$?
        if [ ${ret} -ne 0 ]; then
            echo "Failed to find or create: ${sys_prefix}/share/${directory}"
            $uninst; rm -rf $prefix
            exit 1
        fi
    done

    # Install Vulkan and Vulkan SC ICD, PCC, and layer manifests
    registrees="vulkansc/icd.d/vksconvk.json vulkansc/pcc.d/pcconvk.json vulkansc/explicit_layer.d/VkSCLayer_khronos_device_simulation.json vulkansc/explicit_layer.d/VkSCLayer_khronos_validation.json vulkan/explicit_layer.d/VkLayer_khronos_json_gen.json"
    for file in ${registrees}; do
        if [ $verbose = true ]; then echo "Creating symlink: ${sys_prefix}/share/${file}"; fi
        ln -f -s ${prefix}/share/${file} ${sys_prefix}/share/${file}
        echo "if [ \"\$(readlink -f \${sys_prefix}/share/${file})\" = \"\${prefix}/share/${file}\" ]; then rm \${sys_prefix}/share/${file}; fi" >> ${uninst}
    done
    if [ $verbose = true ]; then echo "Registering programs at: ${sys_prefix}/bin"; fi
    mkdir -p ${sys_prefix}/bin > /dev/null
    ret=$?
    if [ ${ret} -ne 0 ]; then
        echo "Failed to find or create: ${sys_prefix}/bin"
        $uninst; rm -rf $prefix
        exit 1
    fi
    registrees="vulkanscinfo vksccube pcconvk vkscpcctool"
    for file in ${registrees}; do
        if [ $verbose = true ]; then echo "Creating symlink: ${sys_prefix}/bin/${file}"; fi
        ln -f -s ${prefix}/bin/${file} ${sys_prefix}/bin/${file}
        echo "if [ \"\$(readlink -f \${sys_prefix}/bin/${file})\" = \"\${prefix}/bin/${file}\" ]; then rm \${sys_prefix}/bin/${file}; fi" >> ${uninst}
    done

    # Install CMake Vulkan SC meta-package
    if [ ${root} = true ]; then
        if [ $verbose = true ]; then echo "Registering CMake package registry at: ${sys_prefix}/share/cmake"; fi

        mkdir -p ${sys_prefix}/share/cmake/VulkanSC > /dev/null
        ret=$?
        if [ ${ret} -ne 0 ]; then
            echo "Failed to find or create: ${sys_prefix}/share/cmake/VulkanSC"
            $uninst; rm -rf $prefix
            exit 1
        fi
        ln -f -s ${prefix}/share/cmake/VulkanSC/VulkanSCConfig.cmake ${sys_prefix}/share/cmake/VulkanSC/VulkanSCConfig.cmake
        echo "if [ \"\$(readlink -f \${sys_prefix}/share/cmake/VulkanSC/VulkanSCConfig.cmake)\" = \"\${prefix}/share/cmake/VulkanSC/VulkanSCConfig.cmake\" ]; then rm \${sys_prefix}/share/cmake/VulkanSC/VulkanSCConfig.cmake; fi" >> ${uninst}
    else
        if [ $verbose = true ]; then echo "Registering with CMake user package registry at: ${HOME}/.cmake/packages"; fi

        mkdir -p ${HOME}/.cmake/packages/VulkanSC > /dev/null
        ret=$?
        if [ ${ret} -ne 0 ]; then
            echo "Failed to create: ${HOME}/.cmake/packages/VulkanSC"
            $uninst; rm -rf $prefix
            exit 1
        fi
        echo "${prefix}/share/cmake/VulkanSC" > "${HOME}/.cmake/packages/VulkanSC/VulkanSC"
        ret=$?
        if [ ${ret} -ne 0 ]; then
            echo "Failed to create: ${HOME}/.cmake/packages/VulkanSC/VulkanSC"
            $uninst; rm -rf $prefix
            exit 1
        fi
        echo "grep -q \"\${prefix}/share/cmake/VulkanSC\" ${HOME}/.cmake/packages/VulkanSC/VulkanSC; ret=\$?" >> ${uninst}
        echo "if [ \${ret} -eq 0 ]; then rm ${HOME}/.cmake/packages/VulkanSC/VulkanSC; fi" >> ${uninst}
    fi

    # Set up environment variables
    if [ $verbose = true ]; then echo "Registering environment modification in: ${profile}"; fi
    comment='# Vulkan SC SDK environment setup'
    content=". ${prefix}/internal/autosetup-env.sh ${comment}"
    # Touch up content and regex to escape / characters in them to no conflict with / in "s/<regex>/<string>/g"
    sanitized_content=$(echo "${content}" | sed "s/\//\\\\\//g")
    test -e ${profile}; ret=$?
    if [ ${ret} -eq 0 ]; then
        grep -q "${comment}" ${profile}; ret=$?
        if [ ${ret} -eq 0 ]; then
            if [ $verbose = true ]; then echo "Updating environment in profile file: ${profile}"; fi
            sed -i "s/^\. .* ${comment}$/${sanitized_content}/g" ${profile}; ret=$?
            if [ ${ret} -ne 0 ]; then
                echo "Failed to update profile: ${profile}"
                $uninst; rm -rf $prefix
                exit 1
            fi
        else
            if [ $verbose = true ]; then echo "Amending profile file: ${profile}"; fi
            echo "${content}" >> ${profile}; ret=$?
            if [ ${ret} -ne 0 ]; then
                echo "Failed to amend profile: ${profile}"
                $uninst; rm -rf $prefix
                exit 1
            fi
        fi
    else
        if [ $verbose = true ]; then echo "Creating profile file: ${profile}"; fi
        echo "${content}" > ${profile}
        test -e ${profile}; ret=$?
        if [ ${ret} -ne 0 ]; then
            echo "Failed to create profile: ${profile}"
            $uninst; rm -rf $prefix
            exit 1
        fi
    fi

    # Add code to the uninstaller to detect registration and remove environment variables
    echo "profile=$profile" >> ${uninst}
    echo "test -e \${profile}; ret=\$?" >> ${uninst}
    echo "if [ \${ret} -eq 0 ]; then" >> ${uninst}
    echo "    grep -q \". ${prefix}/internal/autosetup-env.sh ${comment}\" \${profile}; ret=$?" >> ${uninst}
    echo "    if [ \${ret} -eq 0 ]; then" >> ${uninst}
    echo "        sed -i '/$sanitized_content/d' \${profile}" >> ${uninst}
    echo "    fi" >> ${uninst}
    echo "else" >> ${uninst}
    echo "    echo \"Profile file \$profile no longer exists\"" >> ${uninst}
    echo "fi" >> ${uninst}
fi

# Finally remove installation folder
echo "rm -rf \$prefix" >> ${uninst}

if [ $verbose = true ]; then echo "Installation successful!"; fi
