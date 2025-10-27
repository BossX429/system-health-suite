@echo off
REM ============================================================================
REM Email Alert System Configuration - Setup
REM ============================================================================

title System Health Optimization - Email Alert Setup
cls

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║     Email Alert System Configuration                          ║
echo ║     (10 minutes)                                              ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo This script will help you configure email notifications for:
echo   • Critical system issues (immediate alerts)
echo   • Weekly health summaries (every Monday)
echo.
echo You'll need:
echo   • SMTP Server (Gmail, Office365, or custom)
echo   • Email address
echo   • Email password (or app-specific password)
echo   • Recipient email address(es)
echo.
echo Popular SMTP Servers:
echo   • Gmail: smtp.gmail.com:587 (use App Password)
echo   • Office365: smtp.office365.com:587
echo   • Outlook: smtp-mail.outlook.com:587
echo.

powershell -ExecutionPolicy Bypass -Command ^
    "& '.\EMAIL_ALERT_SYSTEM.ps1' -Initialize"

if %errorLevel% equ 0 (
    echo.
    echo ╔════════════════════════════════════════════════════════════════╗
    echo ║                    ✓ EMAIL CONFIGURED!                        ║
    echo ╚════════════════════════════════════════════════════════════════╝
    echo.
    echo Email alerts are now active.
    echo.
    echo Next step: Generate baseline metrics
    echo   Run: GENERATE_BASELINES.bat
    echo.
) else (
    echo.
    echo ✗ Configuration failed. Please try again or check settings.
    echo.
)

pause
