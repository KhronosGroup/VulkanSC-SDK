; ~~~
; Copyright (c) 2025-2026 The Khronos Group Inc.
; Copyright (c) 2025-2026 RasterGrid Kft.
;
; SPDX-License-Identifier: Apache-2.0
; ~~~
#include "environment.iss"

[Tasks]
Name: "Register"; Description: "Register installed components and environment variables with the system"; Flags: checkedonce

[Registry]
; Set env var to help locating the SDK with tools
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; Tasks: Register; Flags: uninsdeletevalue; ValueType: string; ValueName: "VULKANSC_SDK"; ValueData: "{app}"

; Register Vulkan and Vulkan SC ICD, PCC, and layer manifests
; see https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html#package-registry
Root: HKLM; Subkey: "Software\Khronos"; Tasks: Register; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Khronos\VulkanSC"; Tasks: Register; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Khronos\VulkanSC\Drivers"; Tasks: Register; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Khronos\VulkanSC\Drivers"; Tasks: Register; Flags: uninsdeletevalue; ValueType: dword; ValueName: "{app}\share\vulkansc\icd.d\vksconvk.json"; ValueData: "0"
Root: HKLM; Subkey: "Software\Khronos\VulkanSC\PCC"; Tasks: Register; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Khronos\VulkanSC\PCC"; Tasks: Register; Flags: uninsdeletevalue; ValueType: dword; ValueName: "{app}\share\vulkansc\pcc.d\pcconvk.json"; ValueData: "0"
Root: HKLM; Subkey: "Software\Khronos\VulkanSC\ExplicitLayers"; Tasks: Register; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Khronos\VulkanSC\ExplicitLayers"; Tasks: Register; Flags: uninsdeletevalue; ValueType: dword; ValueName: "{app}\share\vulkansc\explicit_layer.d\VkSCLayer_khronos_device_simulation.json"; ValueData: "0"
Root: HKLM; Subkey: "Software\Khronos\VulkanSC\ExplicitLayers"; Tasks: Register; Flags: uninsdeletevalue; ValueType: dword; ValueName: "{app}\share\vulkansc\explicit_layer.d\VkSCLayer_khronos_validation.json"; ValueData: "0"

Root: HKLM; Subkey: "Software\Khronos\Vulkan"; Tasks: Register; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Khronos\Vulkan\ExplicitLayers"; Tasks: Register; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Khronos\Vulkan\ExplicitLayers"; Tasks: Register; Flags: uninsdeletevalue; ValueType: dword; ValueName: "{app}\share\vulkan\explicit_layer.d\VkLayer_khronos_json_gen.json"; ValueData: "0"

; Register with the CMake Package Registry
; see https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html#package-registry
Root: HKLM; Subkey: "Software\Kitware\CMake\Packages\VulkanSC"; Tasks: Register; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Kitware\CMake\Packages\VulkanSC"; Tasks: Register; Flags: uninsdeletevalue; ValueType: string; ValueName: "VulkanSC"; ValueData: "{app}\share\cmake\VulkanSC"

; Adding-removing env vars is simple with built-in features. Modifying requires custom Pascal scripting
; Borrowed Wojciech Mleczek's solution: https://stackoverflow.com/a/46609047/1476661
[Code]
procedure CurStepChanged(CurStep: TSetupStep);
begin
    if (CurStep = ssPostInstall) and IsTaskSelected('Register') then
    begin
        EnvAddPath(ExpandConstant('{app}') + '\bin');
    end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
    if CurUninstallStep = usPostUninstall then
        EnvRemovePath(ExpandConstant('{app}') +'\bin');
end;
