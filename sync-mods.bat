@echo off
echo ====================================
echo Minecraft Mods and Resource Packs Sync Script
echo ====================================
echo.

REM Get the script directory (Client folder)
set SCRIPT_DIR=%~dp0
set CLIENT_MODS=%SCRIPT_DIR%mods
set MINECRAFT_MODS=%APPDATA%\.minecraft\mods
set CLIENT_RESOURCEPACKS=%SCRIPT_DIR%resourcepacks
set MINECRAFT_RESOURCEPACKS=%APPDATA%\.minecraft\resourcepacks

echo Mods Source: %CLIENT_MODS%
echo Mods Target: %MINECRAFT_MODS%
echo Resource Packs Source: %CLIENT_RESOURCEPACKS%
echo Resource Packs Target: %MINECRAFT_RESOURCEPACKS%
echo.

REM Check if mods folder exists in Client directory
if not exist "%CLIENT_MODS%" (
    echo ERROR: mods folder not found in Client directory!
    echo Please make sure the mods folder exists next to this script.
    pause
    exit /b 1
)

REM Remove old mods folder if it exists
if exist "%MINECRAFT_MODS%" (
    echo Removing old mods folder...
    rmdir /s /q "%MINECRAFT_MODS%"
    if errorlevel 1 (
        echo ERROR: Failed to remove old mods folder.
        echo Make sure Minecraft is closed and try again.
        pause
        exit /b 1
    )
    echo Old mods folder removed successfully.
    echo.
)

REM Create .minecraft directory if it doesn't exist
if not exist "%APPDATA%\.minecraft" (
    echo Creating .minecraft directory...
    mkdir "%APPDATA%\.minecraft"
)

REM Copy new mods folder
echo Copying new mods folder...
xcopy "%CLIENT_MODS%" "%MINECRAFT_MODS%" /E /I /H /Y
if errorlevel 1 (
    echo ERROR: Failed to copy mods folder.
    pause
    exit /b 1
)

REM ====================================
REM Sync Resource Packs
REM ====================================
echo.
echo Syncing resource packs...
echo.

REM Check if resourcepacks folder exists in Client directory
if not exist "%CLIENT_RESOURCEPACKS%" (
    echo WARNING: resourcepacks folder not found in Client directory!
    echo Skipping resource packs sync...
    echo.
) else (
    REM Remove old resourcepacks folder if it exists
    if exist "%MINECRAFT_RESOURCEPACKS%" (
        echo Removing old resourcepacks folder...
        rmdir /s /q "%MINECRAFT_RESOURCEPACKS%"
        if errorlevel 1 (
            echo ERROR: Failed to remove old resourcepacks folder.
            echo Make sure Minecraft is closed and try again.
            pause
            exit /b 1
        )
        echo Old resourcepacks folder removed successfully.
        echo.
    )

    REM Copy new resourcepacks folder
    echo Copying new resourcepacks folder...
    xcopy "%CLIENT_RESOURCEPACKS%" "%MINECRAFT_RESOURCEPACKS%" /E /I /H /Y
    if errorlevel 1 (
        echo ERROR: Failed to copy resourcepacks folder.
        pause
        exit /b 1
    )
    echo Resource packs synced successfully!
    echo.
)

echo.
echo ====================================
echo Sync completed successfully!
echo ====================================
echo.
echo You can now launch Minecraft.
echo.
pause
