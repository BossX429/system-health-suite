@echo off
REM ============================================================================
REM Full Integration Test - Complete System Verification
REM ============================================================================

title System Health Optimization - Full Integration Test
cls

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║     Full Integration Test                                     ║
echo ║     (2 minutes - complete system verification)               ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo Testing all components:
echo   • Core health optimization
echo   • Enhanced diagnostics (process, network, antivirus)
echo   • Dashboard generation
echo   • CSV trend export
echo.

powershell -ExecutionPolicy Bypass -Command ^
    "& '.\UNIFIED_INTEGRATION.ps1' -Mode Full -RunDashboard -EnableEnhancements"

if %errorLevel% equ 0 (
    echo.
    echo ╔════════════════════════════════════════════════════════════════╗
    echo ║     ✓ ALL TESTS PASSED!                                       ║
    echo ╚════════════════════════════════════════════════════════════════╝
    echo.
    echo All components are working correctly.
    echo.
    echo Next step: View interactive dashboard
    echo   Run: VIEW_DASHBOARD.bat
    echo.
) else (
    echo.
    echo ✗ Tests encountered errors. Please check the output above.
    echo.
)

pause
