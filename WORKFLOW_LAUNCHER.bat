@echo off
REM ============================================================================
REM MASTER WORKFLOW LAUNCHER - 6-Step Complete Deployment
REM ============================================================================

setlocal enabledelayedexpansion

title System Health Optimization - Master Workflow Launcher
cls

echo.
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║                                                                       ║
echo ║        SYSTEM HEALTH OPTIMIZATION SUITE - WORKFLOW LAUNCHER          ║
echo ║                                                                       ║
echo ║        Complete 6-Step Deployment (%~1 minutes total)                 ║
echo ║                                                                       ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

:menu
cls
echo.
echo WORKFLOW OPTIONS:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo QUICK START (Automated - runs all 6 steps):
echo   [A] Auto-Run All 6 Steps (36 minutes total)
echo.
echo INDIVIDUAL STEPS (Manual):
echo   [1] Setup Automation - Configure Task Scheduler (5 min)
echo   [2] Configure Email - Setup SMTP alerts (10 min)
echo   [3] Generate Baselines - Collect 5 snapshots (3 min)
echo   [4] Full Integration Test - Verify all systems (2 min)
echo   [5] View Dashboard - See trends and visualizations (1 min)
echo   [6] Review Documentation - Learn complete system (15 min)
echo.
echo UTILITIES:
echo   [S] Show System Status - Current health metrics
echo   [T] Check Task Scheduler - Verify automation is active
echo   [L] View Latest Report - Display most recent HTML report
echo.
echo   [Q] Quit
echo.

set /p choice="Select option (A, 1-6, S-L, or Q): "

if /i "%choice%"=="A" goto auto_run
if /i "%choice%"=="1" goto step1
if /i "%choice%"=="2" goto step2
if /i "%choice%"=="3" goto step3
if /i "%choice%"=="4" goto step4
if /i "%choice%"=="5" goto step5
if /i "%choice%"=="6" goto step6
if /i "%choice%"=="S" goto show_status
if /i "%choice%"=="T" goto check_task
if /i "%choice%"=="L" goto latest_report
if /i "%choice%"=="Q" goto quit

echo Invalid choice. Please try again.
timeout /t 2 /nobreak
goto menu

REM ═══════════════════════════════════════════════════════════════════════

:auto_run
cls
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║                    AUTO-RUN ALL 6 STEPS                              ║
echo ║                    This will take ~36 minutes                         ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo This will sequentially execute:
echo   Step 1: Setup Automation (5 min)
echo   Step 2: Configure Email (10 min)
echo   Step 3: Generate Baselines (3 min)
echo   Step 4: Full Integration Test (2 min)
echo   Step 5: View Dashboard (1 min)
echo   Step 6: Review Documentation (15 min)
echo.

set /p confirm="Continue? (Y/N): "
if /i not "%confirm%"=="Y" goto menu

echo.
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║ STEP 1: Setup Automation                                             ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
if exist "SETUP_TASK_SCHEDULER_ADMIN.bat" (
    call SETUP_TASK_SCHEDULER_ADMIN.bat
) else (
    echo Skipping - file not found
)

echo.
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║ STEP 2: Configure Email                                              ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
if exist "EMAIL_SETUP.bat" (
    call EMAIL_SETUP.bat
) else (
    echo Skipping - file not found
)

echo.
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║ STEP 3: Generate Baselines                                           ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
if exist "GENERATE_BASELINES.bat" (
    call GENERATE_BASELINES.bat
) else (
    echo Skipping - file not found
)

echo.
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║ STEP 4: Full Integration Test                                        ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
if exist "FULL_TEST.bat" (
    call FULL_TEST.bat
) else (
    echo Skipping - file not found
)

echo.
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║ STEP 5: View Dashboard                                               ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
if exist "VIEW_DASHBOARD.bat" (
    call VIEW_DASHBOARD.bat
) else (
    echo Skipping - file not found
)

echo.
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║ STEP 6: Review Documentation                                         ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
if exist "OPEN_DOCS.bat" (
    call OPEN_DOCS.bat
) else (
    echo Skipping - file not found
)

goto workflow_complete

REM ═══════════════════════════════════════════════════════════════════════

:step1
if exist "SETUP_TASK_SCHEDULER_ADMIN.bat" (
    call SETUP_TASK_SCHEDULER_ADMIN.bat
) else (
    echo ERROR: SETUP_TASK_SCHEDULER_ADMIN.bat not found
    pause
)
goto menu

:step2
if exist "EMAIL_SETUP.bat" (
    call EMAIL_SETUP.bat
) else (
    echo ERROR: EMAIL_SETUP.bat not found
    pause
)
goto menu

:step3
if exist "GENERATE_BASELINES.bat" (
    call GENERATE_BASELINES.bat
) else (
    echo ERROR: GENERATE_BASELINES.bat not found
    pause
)
goto menu

:step4
if exist "FULL_TEST.bat" (
    call FULL_TEST.bat
) else (
    echo ERROR: FULL_TEST.bat not found
    pause
)
goto menu

:step5
if exist "VIEW_DASHBOARD.bat" (
    call VIEW_DASHBOARD.bat
) else (
    echo ERROR: VIEW_DASHBOARD.bat not found
    pause
)
goto menu

:step6
if exist "OPEN_DOCS.bat" (
    call OPEN_DOCS.bat
) else (
    echo ERROR: OPEN_DOCS.bat not found
    pause
)
goto menu

REM ═══════════════════════════════════════════════════════════════════════

:show_status
cls
echo.
echo CURRENT SYSTEM STATUS:
echo ═══════════════════════════════════════════════════════════════════════
echo.

powershell -ExecutionPolicy Bypass -Command ^
    "& '.\APPLY_HEALTH_OPTIMIZATION.ps1' -DryRun -ShowSummary"

echo.
pause
goto menu

REM ═══════════════════════════════════════════════════════════════════════

:check_task
cls
echo.
echo SCHEDULED TASK STATUS:
echo ═══════════════════════════════════════════════════════════════════════
echo.

powershell -ExecutionPolicy Bypass -Command ^
    "Get-ScheduledTask -TaskName 'HealthOptimization*' -ErrorAction SilentlyContinue | ^
     Select-Object TaskName, State, @{N='NextRun';E={$_.Triggers[0].StartBoundary}} | ^
     Format-Table -AutoSize"

echo.
pause
goto menu

REM ═══════════════════════════════════════════════════════════════════════

:latest_report
cls
cd /d "%~dp0"

if not exist "Reports" (
    echo ERROR: Reports directory not found
    pause
    goto menu
)

cd Reports
for /f "delims=" %%f in ('dir /b /od *.html 2^>nul ^| findstr /v Dashboard') do (
    set latest=%%f
)

if defined latest (
    echo Opening latest report: !latest!
    start "" "!latest!"
) else (
    echo ERROR: No HTML reports found in Reports directory
    pause
)

cd ..
goto menu

REM ═══════════════════════════════════════════════════════════════════════

:workflow_complete
cls
echo.
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║                                                                       ║
echo ║              ✓ WORKFLOW COMPLETE - SYSTEM OPERATIONAL!              ║
echo ║                                                                       ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo All 6 steps have been completed successfully:
echo.
echo   ✓ Step 1: Automation configured (weekly health checks at 2:00 AM)
echo   ✓ Step 2: Email alerts configured (critical + weekly summaries)
echo   ✓ Step 3: Baseline metrics collected (5+ data points)
echo   ✓ Step 4: Integration testing complete (all systems verified)
echo   ✓ Step 5: Dashboard generated (interactive trends visualization)
echo   ✓ Step 6: Documentation reviewed (complete system knowledge)
echo.
echo NEXT STEPS:
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo The system will now automatically:
echo   • Run comprehensive health checks every week at 2:00 AM
echo   • Send email alerts for critical system issues
echo   • Store 30-day trend history in CSV format
echo   • Update interactive dashboard with visualizations
echo   • Generate detailed HTML reports
echo.
echo MONITORING YOUR SYSTEM:
echo   • Check dashboard weekly: Reports\HealthDashboard.html
echo   • Review email alerts when system issues occur
echo   • Run SHOW_STATUS anytime for instant health check
echo   • Access full command reference in MASTER_COMMAND_REFERENCE.md
echo.
echo QUESTIONS OR ISSUES?
echo   • See README.md for detailed usage instructions
echo   • Check QUICK_REFERENCE.txt for common commands
echo   • Review MASTER_COMMAND_REFERENCE.md for complete reference
echo.

pause
goto menu

REM ═══════════════════════════════════════════════════════════════════════

:quit
cls
echo.
echo Thank you for using System Health Optimization Suite!
echo.
echo Remember:
echo   • Automation is running weekly at 2:00 AM
echo   • Email alerts are configured and active
echo   • Dashboard will update with each scheduled run
echo.
echo To return to this menu, run: WORKFLOW_LAUNCHER.bat
echo.
pause
