@echo off
REM ============================================================================
REM View Interactive Health Dashboard
REM ============================================================================

title System Health Optimization - Dashboard Viewer
cls

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║     Opening Health Dashboard                                  ║
echo ║     (1 minute - interactive trends visualization)             ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

if not exist "Reports\HealthDashboard.html" (
    echo ERROR: Dashboard not found at Reports\HealthDashboard.html
    echo.
    echo Please run full integration test first:
    echo   Run: FULL_TEST.bat
    echo.
    pause
    exit /b 1
)

echo Opening dashboard in default browser...
start "" "Reports\HealthDashboard.html"

echo.
echo Dashboard features:
echo   • Interactive trend charts (CPU, Memory, Disk, Services)
echo   • Health score progression
echo   • Critical issues timeline
echo   • Optimization recommendations
echo.
echo Next step: Review documentation
echo   Run: OPEN_DOCS.bat
echo.

timeout /t 3 /nobreak
