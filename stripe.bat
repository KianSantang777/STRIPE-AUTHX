@echo off
title STRIPE-AUTHX Auto Installer + GUI Menu (curl)
color 0A

:: =========================================================
:: CHECK CURL
:: =========================================================
curl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] curl is not available.
    echo HINT: curl is built-in on Windows 10/11. If disabled:
    echo - Update Windows
    echo - Or enable curl in system PATH
    pause
    exit /b
)

:: =========================================================
:: MENU
:: =========================================================
:menu
cls
echo ================================================
echo         STRIPE-AUTHX WINDOWS INSTALLER
echo ================================================
echo  1) Download STRIPE-AUTHX (via curl)
echo  2) Install Requirements
echo  3) Run oki.py
echo  4) Full Auto Install (1+2+3)
echo  0) Exit
echo ================================================
set /p choice=Choose option: 

if "%choice%"=="1" goto download
if "%choice%"=="2" goto install_req
if "%choice%"=="3" goto run_script
if "%choice%"=="4" goto full_auto
if "%choice%"=="0" exit
goto menu

:: =========================================================
:: 1) DOWNLOAD ZIP USING CURL
:: =========================================================
:download
cls
echo [*] Downloading STRIPE-AUTHX ZIP via curl...
echo.

set zipfile=stripeauthx.zip

:: Remove old folder + ZIP
if exist STRIPE-AUTHX (
    echo Removing old STRIPE-AUTHX folder...
    rmdir /s /q STRIPE-AUTHX
)

if exist %zipfile% del /f /q %zipfile%

:: Download ZIP
curl -L -o %zipfile% "https://github.com/KianSantang777/STRIPE-AUTHX/archive/refs/heads/main.zip"
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to download ZIP.
    echo HINT:
    echo - Check internet connection
    echo - Disable VPN/Proxy
    echo.
    pause
    goto menu
)

echo.
echo [OK] ZIP downloaded: %zipfile%
echo.

:: Extract ZIP
echo [*] Extracting ZIP...
powershell -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '.' -Force"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to extract ZIP.
    echo HINT: Update PowerShell or extract manually.
    pause
    goto menu
)

:: Rename extracted folder
ren "STRIPE-AUTHX-main" "STRIPE-AUTHX" 2>nul

echo.
echo [OK] Extracted to STRIPE-AUTHX folder.
pause
goto menu

:: =========================================================
:: 2) INSTALL REQUIREMENTS
:: =========================================================
:install_req
cls

if not exist STRIPE-AUTHX (
    echo [ERROR] STRIPE-AUTHX folder not found.
    echo Run option (1) first.
    pause
    goto menu
)

cd STRIPE-AUTHX

echo [*] Checking Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed.
    echo Get Python from: https://python.org
    cd ..
    pause
    goto menu
)
echo [OK] Python detected.
echo.

echo [*] Upgrading pip silently...
python -m pip install --upgrade pip --quiet

echo.
echo [*] Installing dependencies...
python -m pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to install dependencies.
    echo -------------------------------------------------
    echo FIX HINT:
    echo 1) Run this installer as Administrator.
    echo 2) Install Visual C++ Redistributable:
    echo    https://aka.ms/vs/17/release/vc_redist.x64.exe
    echo 3) Check internet connection.
    echo -------------------------------------------------
    cd ..
    pause
    goto menu
)

echo.
echo [OK] Requirements installed.
cd ..
pause
goto menu

:: =========================================================
:: 3) RUN SCRIPT
:: =========================================================
:run_script
cls
if not exist STRIPE-AUTHX (
    echo [ERROR] STRIPE-AUTHX folder not found.
    pause
    goto menu
)

cd STRIPE-AUTHX

echo ================================================
echo [*] Starting STRIPE-AUTHX (oki.py)
echo ================================================
echo.

python oki.py
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Script crashed.
    echo FULL ERROR SHOWN ABOVE.
    echo HINT:
    echo - Make sure Python version is 3.10+ (prefer 3.12)
    echo - Disable VPN/Proxy
    echo - Reinstall requirements (Menu 2)
    cd ..
    pause
    goto menu
)

cd ..
pause
goto menu

:: =========================================================
:: 4) FULL AUTO INSTALL
:: =========================================================
:full_auto
cls
echo [*] Running Full Automated Install...
call :download
call :install_req
call :run_script
goto menu
