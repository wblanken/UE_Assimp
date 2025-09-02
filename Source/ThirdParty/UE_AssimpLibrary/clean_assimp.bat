@echo off
setlocal enabledelayedexpansion

echo ====================================
echo CMake Clean Script
echo ====================================

:: Change to the working directory (one level down)
cd /d "%~dp0"

:: Find the directory containing CMakeLists.txt
set "TARGET_DIR="
if exist CMakeLists.txt (
    set "TARGET_DIR=%CD%"
) else (
    echo Looking for CMakeLists.txt in subdirectories...
    for /d %%i in (*) do (
        if exist "%%i\CMakeLists.txt" (
            echo Found CMakeLists.txt in %%i
            set "TARGET_DIR=%CD%\%%i"
            goto :found_target
        )
    )
    echo Error: Could not find CMakeLists.txt in current directory or subdirectories
    pause
    exit /b 1
)

:found_target
cd /d "%TARGET_DIR%"
echo Cleaning directory: %CD%
echo.

:: Delete root level files
echo Removing root level files...
if exist "ALL_BUILD.vcxproj" del /q "ALL_BUILD.vcxproj"
if exist "ALL_BUILD.vcxproj.filters" del /q "ALL_BUILD.vcxproj.filters"
if exist "Assimp.sln" del /q "Assimp.sln"
if exist "CMakeCache.txt" del /q "CMakeCache.txt"
if exist "INSTALL.vcxproj" del /q "INSTALL.vcxproj"
if exist "INSTALL.vcxproj.filters" del /q "INSTALL.vcxproj.filters"
if exist "UpdateAssimpLibsDebugSymbolsAndDLLs.vcxproj" del /q "UpdateAssimpLibsDebugSymbolsAndDLLs.vcxproj"
if exist "UpdateAssimpLibsDebugSymbolsAndDLLs.vcxproj.filters" del /q "UpdateAssimpLibsDebugSymbolsAndDLLs.vcxproj.filters"
if exist "ZERO_CHECK.vcxproj" del /q "ZERO_CHECK.vcxproj"
if exist "ZERO_CHECK.vcxproj.filters" del /q "ZERO_CHECK.vcxproj.filters"
if exist "assimp.pc" del /q "assimp.pc"
if exist "cmake_install.cmake" del /q "cmake_install.cmake"
if exist "cmake_uninstall.cmake" del /q "cmake_uninstall.cmake"
if exist "uninstall.vcxproj" del /q "uninstall.vcxproj"
if exist "uninstall.vcxproj.filters" del /q "uninstall.vcxproj.filters"

:: Delete root level directories
echo Removing root level directories...
if exist "CMakeFiles" (
    echo Removing CMakeFiles/
    rmdir /s /q "CMakeFiles"
)
if exist "bin" (
    echo Removing bin/
    rmdir /s /q "bin"
)
if exist "generated" (
    echo Removing generated/
    rmdir /s /q "generated"
)
if exist "lib" (
    echo Removing lib/
    rmdir /s /q "lib"
)
if exist "x64" (
    echo Removing x64/
    rmdir /s /q "x64"
)

:: Clean code directory
echo Cleaning code directory...
if exist "code" (
    cd code
    if exist "INSTALL.vcxproj" del /q "INSTALL.vcxproj"
    if exist "INSTALL.vcxproj.filters" del /q "INSTALL.vcxproj.filters"
    if exist "assimp.vcxproj" del /q "assimp.vcxproj"
    if exist "assimp.vcxproj.filters" del /q "assimp.vcxproj.filters"
    if exist "cmake_install.cmake" del /q "cmake_install.cmake"
    if exist "CMakeFiles" (
        echo Removing code/CMakeFiles/
        rmdir /s /q "CMakeFiles"
    )
    if exist "assimp.dir" (
        echo Removing code/assimp.dir/
        rmdir /s /q "assimp.dir"
    )
    cd ..
)

:: Clean contrib/zlib directory
echo Cleaning contrib/zlib directory...
if exist "contrib\zlib" (
    cd "contrib\zlib"
    if exist "ALL_BUILD.vcxproj" del /q "ALL_BUILD.vcxproj"
    if exist "ALL_BUILD.vcxproj.filters" del /q "ALL_BUILD.vcxproj.filters"
    if exist "CTestTestfile.cmake" del /q "CTestTestfile.cmake"
    if exist "INSTALL.vcxproj" del /q "INSTALL.vcxproj"
    if exist "INSTALL.vcxproj.filters" del /q "INSTALL.vcxproj.filters"
    if exist "cmake_install.cmake" del /q "cmake_install.cmake"
    if exist "zconf.h" del /q "zconf.h"
    if exist "zlib.pc" del /q "zlib.pc"
    if exist "zlib.sln" del /q "zlib.sln"
    if exist "zlibstatic.vcxproj" del /q "zlibstatic.vcxproj"
    if exist "zlibstatic.vcxproj.filters" del /q "zlibstatic.vcxproj.filters"
    if exist "CMakeFiles" (
        echo Removing contrib/zlib/CMakeFiles/
        rmdir /s /q "CMakeFiles"
    )
    if exist "Release" (
        echo Removing contrib/zlib/Release/
        rmdir /s /q "Release"
    )
    if exist "zlibstatic.dir" (
        echo Removing contrib/zlib/zlibstatic.dir/
        rmdir /s /q "zlibstatic.dir"
    )
    cd ..\..
)

:: Clean test directory
echo Cleaning test directory...
if exist "test" (
    cd test
    if exist "INSTALL.vcxproj" del /q "INSTALL.vcxproj"
    if exist "INSTALL.vcxproj.filters" del /q "INSTALL.vcxproj.filters"
    if exist "cmake_install.cmake" del /q "cmake_install.cmake"
    if exist "unit.vcxproj" del /q "unit.vcxproj"
    if exist "unit.vcxproj.filters" del /q "unit.vcxproj.filters"
    if exist "CMakeFiles" (
        echo Removing test/CMakeFiles/
        rmdir /s /q "CMakeFiles"
    )
    if exist "unit.dir" (
        echo Removing test/unit.dir/
        rmdir /s /q "unit.dir"
    )

    :: Clean test/headercheck subdirectory
    if exist "headercheck" (
        cd headercheck
        if exist "INSTALL.vcxproj" del /q "INSTALL.vcxproj"
        if exist "INSTALL.vcxproj.filters" del /q "INSTALL.vcxproj.filters"
        if exist "cmake_install.cmake" del /q "cmake_install.cmake"
        if exist "CMakeFiles" (
            echo Removing test/headercheck/CMakeFiles/
            rmdir /s /q "CMakeFiles"
        )
        cd ..
    )
    cd ..
)

:: Clean generated header files
echo Cleaning generated header files...
if exist "include\assimp\config.h" del /q "include\assimp\config.h"
if exist "include\assimp\revision.h" del /q "include\assimp\revision.h"

echo.
echo ====================================
echo Clean completed successfully!
echo ====================================
echo All CMake-generated files and directories have been removed.
echo You can now run CMake to generate fresh build files.
echo.

pause