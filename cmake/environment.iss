; ~~~
; Copyright (c) 2025-2026 The Khronos Group Inc.
; Copyright (c) 2025-2026 RasterGrid Kft.
;
; SPDX-License-Identifier: Apache-2.0
; ~~~

[Code]
const EnvironmentKey = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';

procedure EnvAddPath(Path: string);
var
    Paths: string;
begin
    { Add path to the beginning of the path variable }
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
        Paths := Path + ';'+ Paths
    else
        Paths := Path;

    { Overwrite (or create if missing) path environment variable }
    if RegWriteStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
        Log(Format('The [%s] added to PATH: [%s]', [Path, Paths]))
    else
        Log(Format('Error while adding the [%s] to PATH: [%s]', [Path, Paths]));
end;

procedure EnvRemovePath(Path: string);
var
    I: Integer;
    PathStr, PathElem, ResultStr: string;
    PathArr, ResultArr: TArrayOfString;
begin
    { Skip if registry entry not exists }
    if not RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', PathStr) then
        exit;

    PathArr := StringSplit(PathStr, [';'], stExcludeEmpty);
    ResultArr := [];

    for I := 0 to GetArrayLength(PathArr) - 1 do
    begin
        PathElem := PathArr[I];
        if not (PathElem = Path) then
        begin
            SetArrayLength(ResultArr, GetArrayLength(ResultArr) + 1);
            ResultArr[GetArrayLength(ResultArr) - 1] := PathElem;
        end;
    end;

    ResultStr := StringJoin(';', ResultArr);

    { Overwrite path environment variable }
    if RegWriteStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', ResultStr)
    then Log(Format('The [%s] removed from PATH: [%s]', [Path, PathStr]))
    else Log(Format('Error while removing the [%s] from PATH: [%s]', [Path, PathStr]));
end;
