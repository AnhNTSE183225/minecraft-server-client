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
set OPTIONS_FILE=%APPDATA%\.minecraft\options.txt

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

REM ====================================
REM Enforce Resource Pack Order (options.txt)
REM ====================================
echo.
echo Updating resource pack load order...
if exist "%OPTIONS_FILE%" (
    REM Using PowerShell to safely replace the line because it handles special characters better than Batch
    powershell -Command "(Get-Content '%OPTIONS_FILE%') -replace '^resourcePacks:.*', 'resourcePacks:[\"vanilla\",\"file/FreshAnimations_v1.10.3.zip\",\"file/Default HD 128x Demo 1.8.2.2.zip\",\"file/Recolourful Containers 3.1 (1.19.4+).zip\",\"file/Round-Trees-8.1.zip\",\"file/FA+All_Extensions-v1.7.zip\",\"file/Dramatic Skys Demo 1.5.3.36.2.zip\",\"file/EvenBetterEnchants_v3_1.21.5+.zip\",\"cullleaves:smartleaves\",\"file/Better-Leaves-9.5.zip\"]' | Set-Content '%OPTIONS_FILE%'"
    
    echo Load order updated in options.txt.
) else (
    echo WARNING: options.txt not found.
    echo Please launch the game at least once to generate it, then run this script again.
)

echo.
echo ====================================
echo Sync completed successfully!
echo ====================================
echo.
echo You can now launch Minecraft.
echo.
pause