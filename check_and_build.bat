@echo off
set "DLL_PATH=%~dp0Source\ThirdParty\UE_AssimpLibrary\assimp\bin\Release\assimp.dll"
set "BUILD_SCRIPT=%~dp0Source\ThirdParty\UE_AssimpLibrary\build_assimp.bat"

@REM if not exist "%DLL_PATH%" (
@REM     echo Assimp DLL not found, running build script...
@REM     call "%BUILD_SCRIPT%"
@REM ) else (
@REM     echo Assimp DLL already exists at %DLL_PATH%, skipping build
@REM )

echo Building Assimp...
call "%BUILD_SCRIPT%"