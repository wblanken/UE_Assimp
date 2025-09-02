@echo off
setlocal enabledelayedexpansion

echo ================================================
echo CMake Library Build Script
echo ================================================

:: Change to the working directory (one level down)
cd /d "%~dp0"
if exist library (
    cd library
) else (
    echo Looking for CMakeLists.txt in subdirectories...
    for /d %%i in (*) do (
        if exist "%%i\CMakeLists.txt" (
            echo Found CMakeLists.txt in %%i
            cd "%%i"
            goto :found_cmake
        )
    )
    echo Error: Could not find CMakeLists.txt in any subdirectory
        exit /b 1
)

:found_cmake
echo Current directory: %CD%

:: Search for Visual Studio installations and load the tools
echo ================================================
echo Setting up Visual Studio environment...
echo ================================================

:: Try different Visual Studio versions and locations
set "VS_FOUND=false"

:: Check for VS 2022
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat" (
    echo Found Visual Studio 2022 Enterprise
    call "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
    set "VS_FOUND=true"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" (
    echo Found Visual Studio 2022 Professional
    call "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat"
    set "VS_FOUND=true"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" (
    echo Found Visual Studio 2022 Community
    call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
    set "VS_FOUND=true"
) else if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat" (
    echo Found Visual Studio 2019 Enterprise
    call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
    set "VS_FOUND=true"
) else if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvars64.bat" (
    echo Found Visual Studio 2019 Professional
    call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvars64.bat"
    set "VS_FOUND=true"
) else if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat" (
    echo Found Visual Studio 2019 Community
    call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"
    set "VS_FOUND=true"
) else (
    :: Try to find any VS installation using vswhere
    for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
        set "VS_PATH=%%i"
    )

    if defined VS_PATH (
        echo Found Visual Studio at: !VS_PATH!
        call "!VS_PATH!\VC\Auxiliary\Build\vcvars64.bat"
        set "VS_FOUND=true"
    )
)

if "!VS_FOUND!"=="false" (
    echo Error: Could not find Visual Studio installation
    echo Please ensure Visual Studio with C++ tools is installed
        exit /b 1
)

echo Visual Studio environment loaded successfully
echo.

:: Run CMake configuration
echo ================================================
echo Running CMake configuration...
echo ================================================

cmake CMakeLists.txt -DLIBRARY_SUFFIX:STRING=
if errorlevel 1 (
    echo Error: CMake configuration failed
        exit /b 1
)

echo CMake configuration completed successfully
echo.

:: Build the solution
echo ================================================
echo Building Assimp.sln in Release mode for x64...
echo ================================================

if not exist "Assimp.sln" (
    echo Error: Assimp.sln not found in current directory
    echo Available files:
    dir *.sln
        exit /b 1
)

msbuild Assimp.sln /p:Configuration=Release /p:Platform=x64 /m
if errorlevel 1 (
    echo Error: Build failed
        exit /b 1
)

echo.
echo ================================================
echo Build completed successfully!
echo ================================================