@echo off
REM ============================================================================
REM Generate Baseline Health Metrics - Multiple Samples
REM ============================================================================

title System Health Optimization - Generate Baselines
cls

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║     Generating Baseline Metrics                               ║
echo ║     (3 minutes - 5 samples for trend analysis)                ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo Collecting health snapshots...
echo.

for /L %%i in (1,1,5) do (
    echo [%%i/5] Taking health snapshot...
    powershell -ExecutionPolicy Bypass -Command ^
        "& '.\APPLY_HEALTH_OPTIMIZATION.ps1' -DryRun -Quiet"
    
    if %%i lss 5 (
        echo   Waiting 60 seconds before next sample...
        timeout /t 60 /nobreak
    )
)

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║     ✓ BASELINE GENERATION COMPLETE!                          ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
echo Generated 5 health snapshots (9+ total data points).
echo.
echo Next step: Run full integration test
echo   Run: FULL_TEST.bat
echo.

pause
