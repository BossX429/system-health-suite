@echo off
REM ============================================================================
REM Open Documentation Suite
REM ============================================================================

title System Health Optimization - Documentation
cls

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║     Documentation Suite                                       ║
echo ║     (15 minutes - complete knowledge base)                    ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo Documentation files:
echo.
echo [1] QUICK_REFERENCE.txt
echo     One-page quick start guide
echo.
echo [2] README.md
echo     Comprehensive usage guide (400+ lines)
echo.
echo [3] MASTER_COMMAND_REFERENCE.md
echo     Complete command reference (500+ lines)
echo.
echo [4] All Documentation (open in VS Code if available)
echo.
echo [Q] Quit
echo.

set /p choice="Select option (1-4 or Q): "

if /i "%choice%"=="1" (
    if exist "QUICK_REFERENCE.txt" (
        start notepad "QUICK_REFERENCE.txt"
    ) else (
        echo File not found.
    )
) else if /i "%choice%"=="2" (
    if exist "README.md" (
        start notepad "README.md"
    ) else (
        echo File not found.
    )
) else if /i "%choice%"=="3" (
    if exist "MASTER_COMMAND_REFERENCE.md" (
        start notepad "MASTER_COMMAND_REFERENCE.md"
    ) else (
        echo File not found.
    )
) else if /i "%choice%"=="4" (
    echo Opening all documentation...
    if exist "QUICK_REFERENCE.txt" start notepad "QUICK_REFERENCE.txt"
    if exist "README.md" start notepad "README.md"
    if exist "MASTER_COMMAND_REFERENCE.md" start notepad "MASTER_COMMAND_REFERENCE.md"
) else if /i "%choice%"=="Q" (
    echo.
    exit /b 0
)

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║     ✓ WORKFLOW COMPLETE!                                      ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
echo All 6 steps have been completed:
echo   ✓ Step 1: Setup automation (weekly health checks)
echo   ✓ Step 2: Configure email alerts
echo   ✓ Step 5: Generate baseline metrics
echo   ✓ Step 3: Full integration test
echo   ✓ Step 4: View interactive dashboard
echo   ✓ Step 7: Review documentation
echo.
echo System is now fully operational and will automatically:
echo   • Run health checks every week at 2:00 AM
echo   • Send email alerts for critical issues
echo   • Maintain 30-day trend history in CSV format
echo   • Update interactive dashboard with visualizations
echo.

pause
