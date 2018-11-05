@ECHO off
REM Save the current directory on a stack and change to %~dp0 which is the drive-and-path of the "0'th" command-line parameter, ie location of this file
PUSHD %~dp0

ECHO *************************************************************************************
REM Copy and overwrite ArioANE.dll from native project to platform folder
SET DLL_FILE_NAME=ArioANE.dll
ECHO COPYING %~dp0..\ArioANE-native\ArioANE\Release\%DLL_FILE_NAME% TO %~dp0.\platform\%DLL_FILE_NAME%
COPY /Y %~dp0..\ArioANE-native\ArioANE\Release\%DLL_FILE_NAME%  %~dp0.\platform\%DLL_FILE_NAME%

ECHO *************************************************************************************
REM Extract library.swf form ArioANE.swc to platform folder
ECHO EXTRACTING library.swf FROM ArioANE.swc
7z e %~dp0.\bin\ArioANE.swc -aoa -o%~dp0.\platform\ library.swf -r

ECHO *************************************************************************************
REM deleting old ANE library
SET EXTENSION_FILE_NAME=arioAirextension.ane
ECHO DELETING LAST %EXTENSION_FILE_NAME%
DEL %~dp0.\%EXTENSION_FILE_NAME%

REM building ANE library
ECHO BUILDING %EXTENSION_FILE_NAME%
adt -package -target ane %EXTENSION_FILE_NAME% .\descriptor.xml -swc .\bin\ArioANE.swc -platform default -C platform library.swf -platform Windows-x86 -C platform library.swf ArioANE.dll ArioSdk.dll api-ms-win-crt-convert-l1-1-0.dll api-ms-win-crt-heap-l1-1-0.dll api-ms-win-crt-math-l1-1-0.dll api-ms-win-crt-runtime-l1-1-0.dll api-ms-win-crt-stdio-l1-1-0.dll api-ms-win-crt-string-l1-1-0.dll msvcp140.dll StoreSdk.dll vcruntime140.dll "Adobe AIR.dll" 
POPD

