<#
.SYNOPSIS
    Task Scheduler Automation Setup
.DESCRIPTION
    Creates and configures Windows Task Scheduler for automated health optimization
.PARAMETER Schedule
    Schedule frequency: 'Daily', 'Weekly', or 'Monthly' (default: 'Weekly')
.PARAMETER Time
    Time in HH:mm format (default: '02:00')
.PARAMETER ListTasks
    List all scheduled health tasks
.PARAMETER Remove
    Remove the scheduled task
#>

param(
    [ValidateSet('Daily', 'Weekly', 'Monthly')]
    [string]$Schedule = 'Weekly',
    [string]$Time = '02:00',
    [switch]$ListTasks = $false,
    [switch]$Remove = $false
)

$TaskName = 'System Health Optimization'
$ScriptPath = 'c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\APPLY_HEALTH_OPTIMIZATION.ps1'

# Check admin privileges
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $currentUser
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: Administrator privileges required!" -ForegroundColor Red
    exit 1
}

# ============================================================================
# LIST TASKS
# ============================================================================

if ($ListTasks) {
    Write-Host ""
    Write-Host "====== SCHEDULED HEALTH OPTIMIZATION TASKS ======" -ForegroundColor Cyan
    Write-Host ""
    
    $tasks = Get-ScheduledTask | Where-Object {$_.TaskName -like '*Health*' -or $_.TaskName -like '*Optimization*'}
    
    if ($tasks.Count -eq 0) {
        Write-Host "No health optimization tasks scheduled." -ForegroundColor Yellow
    } else {
        foreach ($task in $tasks) {
            Write-Host "Task: $($task.TaskName)" -ForegroundColor Green
            Write-Host "  State: $($task.State)"
            
            $info = Get-ScheduledTaskInfo -TaskName $task.TaskName -ErrorAction SilentlyContinue
            if ($info) {
                Write-Host "  Last Run: $($info.LastRunTime)"
                Write-Host "  Next Run: $($info.NextRunTime)"
                Write-Host "  Last Result: $($info.LastTaskResult)"
            }
            Write-Host ""
        }
    }
    exit 0
}

# ============================================================================
# REMOVE TASK
# ============================================================================

if ($Remove) {
    Write-Host "Removing scheduled task: $TaskName" -ForegroundColor Yellow
    
    try {
        $task = Get-ScheduledTask -TaskName $TaskName -ErrorAction Stop
        Unregister-ScheduledTask -InputObject $task -Confirm:$false
        Write-Host "Task removed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Task not found or failed to remove" -ForegroundColor Red
    }
    exit 0
}

# ============================================================================
# CREATE TASK
# ============================================================================

Write-Host ""
Write-Host "====== CREATE SCHEDULED TASK ======" -ForegroundColor Cyan
Write-Host ""

# Validate script exists
if (-not (Test-Path $ScriptPath)) {
    Write-Host "ERROR: Script not found: $ScriptPath" -ForegroundColor Red
    exit 1
}

# Check if task exists
try {
    $existing = Get-ScheduledTask -TaskName $TaskName -ErrorAction Stop
    Write-Host "Task already exists. Removing old version..." -ForegroundColor Yellow
    Unregister-ScheduledTask -InputObject $existing -Confirm:$false
    Start-Sleep -Seconds 2
} catch {
    # Task doesn't exist, continue
}

# Create trigger
$trigger = switch ($Schedule) {
    'Daily' {
        New-ScheduledTaskTrigger -Daily -At $Time
    }
    'Weekly' {
        New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At $Time
    }
    'Monthly' {
        New-ScheduledTaskTrigger -Monthly -DaysOfMonth 1 -At $Time
    }
}

# Create action
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-ExecutionPolicy Bypass -NoProfile -File `"$ScriptPath`""

# Create settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -RunWithHighestPrivileges -ExecutionTimeLimit (New-TimeSpan -Hours 2)

# Create principal
$principal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest

# Register task
try {
    $task = Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force
    
    Write-Host "Successfully created scheduled task!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Task Details:" -ForegroundColor Cyan
    Write-Host "  Name: $TaskName"
    Write-Host "  Schedule: $Schedule at $Time"
    Write-Host "  Script: $ScriptPath"
    Write-Host "  Status: $($task.State)"
    Write-Host ""
    Write-Host "The optimization will run automatically according to the schedule." -ForegroundColor Green
    Write-Host ""
    
} catch {
    Write-Host "ERROR: Failed to create task: $_" -ForegroundColor Red
    exit 1
}

# Generate supporting files
Write-Host "Generating supporting files..." -ForegroundColor Cyan
Write-Host ""

# Create config file
$configPath = 'c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\HealthOptimization.config.json'
@{
    ScriptPath = $ScriptPath
    ReportDirectory = 'c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\Reports'
    Schedule = $Schedule
    Time = $Time
    TaskName = $TaskName
    CreatedDate = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
} | ConvertTo-Json | Out-File -FilePath $configPath -Encoding UTF8 -Force

Write-Host "Config file: $configPath" -ForegroundColor Green

# Create batch runner
$batchPath = 'c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\RUN_HEALTH_CHECK.bat'
$batchContent = @'
@echo off
REM System Health Optimization
powershell -ExecutionPolicy Bypass -NoProfile -File "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\APPLY_HEALTH_OPTIMIZATION.ps1"
pause
'@
$batchContent | Out-File -FilePath $batchPath -Encoding ASCII -Force
Write-Host "Batch runner: $batchPath" -ForegroundColor Green

Write-Host ""
Write-Host "====== SETUP COMPLETE ======" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Task is now scheduled to run $Schedule at $Time"
Write-Host "2. You can run manually: RUN_HEALTH_CHECK.bat"
Write-Host "3. Check Task Scheduler (taskschd.msc) to verify"
Write-Host "4. Reports will be saved to the Reports directory"
Write-Host ""
