@echo off
REM ============================================================================
REM Setup Task Scheduler Automation - Admin Elevated
REM ============================================================================

title System Health Optimization - Task Scheduler Setup
cls

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║     Task Scheduler Setup for Health Optimization              ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script requires Administrator privileges!
    echo.
    echo Please:
    echo   1. Right-click this batch file
    echo   2. Select "Run as Administrator"
    echo.
    pause
    exit /b 1
)

echo ✓ Running with Administrator privileges
echo.

cd /d "%~dp0"

echo Setting up weekly task scheduler job...
echo Schedule: Every week at 2:00 AM
echo.

powershell -ExecutionPolicy Bypass -Command ^
    "& '.\SETUP_TASK_SCHEDULER.ps1' -Schedule Weekly -Time '02:00'"

if %errorLevel% equ 0 (
    echo.
    echo ╔════════════════════════════════════════════════════════════════╗
    echo ║                    ✓ SETUP COMPLETE!                          ║
    echo ╚════════════════════════════════════════════════════════════════╝
    echo.
    echo Your system will now receive automatic weekly health checks.
    echo Scheduled for: Every week at 2:00 AM
    echo.
    echo Next step: Configure Email Alerts
    echo   Run: EMAIL_SETUP.bat
    echo.
) else (
    echo.
    echo ✗ Setup failed. Please check the error messages above.
    echo.
)

pause
