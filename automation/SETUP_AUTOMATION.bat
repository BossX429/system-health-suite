@echo off
REM Task Scheduler Setup - Requires Admin

echo.
echo ====================================
echo   HEALTH OPTIMIZATION AUTOMATION
echo ====================================
echo.

REM Check if running as admin
net session >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: This script requires Administrator privileges!
    echo.
    echo Please right-click this file and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo Setting up automated weekly health optimization...
echo Scheduling for Sunday at 2:00 AM
echo.

REM Run PowerShell script with admin privileges
powershell -ExecutionPolicy Bypass -NoProfile -File "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\SETUP_TASK_SCHEDULER.ps1" -Schedule Weekly -Time 02:00

echo.
echo Setup complete!
echo.
pause
