# 🎯 MASTER COMMAND REFERENCE GUIDE
**System Health Optimization Suite - Complete Command Inventory**

---

## 📋 TABLE OF CONTENTS
1. [Quick Start (30 Seconds)](#quick-start)
2. [Core Scripts Reference](#core-scripts-reference)
3. [Common Workflows](#common-workflows)
4. [Configuration Guide](#configuration-guide)
5. [Troubleshooting](#troubleshooting)
6. [Advanced Usage](#advanced-usage)

---

## ⚡ QUICK START
*Get up and running immediately*

### Option 1: Simple Health Check (Dry-Run - No Changes)
```powershell
& "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\APPLY_HEALTH_OPTIMIZATION.ps1" -DryRun
```
**Output:** HTML report showing current system health (no optimizations applied)

### Option 2: Full Health Optimization (Apply Changes)
```powershell
& "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\APPLY_HEALTH_OPTIMIZATION.ps1"
```
**Output:** System optimized + HTML report with all 7 sections

### Option 3: View Latest Report
```powershell
Invoke-Item "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\Reports\*.html" | Sort LastWriteTime | Select -Last 1
```

### Option 4: Run Everything (Everything Integrated)
```powershell
& "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\UNIFIED_INTEGRATION.ps1" -Mode Full -RunDashboard -EnableEnhancements
```

---

## 📚 CORE SCRIPTS REFERENCE

### 1. APPLY_HEALTH_OPTIMIZATION.ps1
**Purpose:** Core health analysis and optimization engine  
**Size:** 600+ lines  
**Admin Required:** Yes (for optimization)

#### Basic Usage
```powershell
# Dry-run (preview only, no changes)
& ".\APPLY_HEALTH_OPTIMIZATION.ps1" -DryRun

# Production (apply optimizations)
& ".\APPLY_HEALTH_OPTIMIZATION.ps1"

# Run as administrator (required for production)
# Right-click PowerShell → Run as Administrator
```

#### Parameters
```powershell
-DryRun           # Preview changes without applying (default: $false)
-Verbose          # Show detailed output (default: $false)
```

#### Output
- **HTML Report:** Saved to `Reports\HealthReport_[timestamp].html`
- **Components Analyzed:**
  - CPU Health (0-25 points)
  - Memory Health (0-25 points)
  - Disk Health (0-25 points)
  - Services Health (0-25 points)
  - **Overall Score:** 0-100

#### 7 Report Sections
1. **Overall Health Score** - Composite metric (0-100 scale)
2. **Critical Issues** - Problems detected and fixed
3. **Warning Signs** - Potential issues and preventive actions
4. **Optimization Recommendations** - Improvements applied
5. **Safe Parameters** - Verified system configuration
6. **Bottlenecks Identified** - Performance constraints
7. **Action Items** - Tracked required actions with priorities

---

### 2. EMAIL_ALERT_SYSTEM.ps1
**Purpose:** Send professional email notifications  
**Size:** 350+ lines  
**Admin Required:** No

#### Setup (First Time)
```powershell
# Run interactive configuration
& ".\EMAIL_ALERT_SYSTEM.ps1" -Initialize

# Follow prompts:
# - SMTP Server (Gmail: smtp.gmail.com, Office365: smtp.office365.com)
# - Port (587 or 465)
# - Email address
# - Password/App-specific password
# - Recipient email(s)
```

#### Send Test Email
```powershell
& ".\EMAIL_ALERT_SYSTEM.ps1" -SendTest
```

#### Send Alert Email
```powershell
# Send critical alert
& ".\EMAIL_ALERT_SYSTEM.ps1" -SendAlert -AlertType Critical

# Send weekly summary
& ".\EMAIL_ALERT_SYSTEM.ps1" -SendAlert -AlertType Summary

# Send with custom report file
& ".\EMAIL_ALERT_SYSTEM.ps1" -SendAlert -ReportPath "Reports\HealthReport_20251026_162950.html"
```

#### SMTP Providers
| Provider | SMTP Server | Port | Notes |
|----------|-------------|------|-------|
| Gmail | smtp.gmail.com | 587 | Use App Password (not regular password) |
| Office365 | smtp.office365.com | 587 | Use Office365 credentials |
| Outlook | smtp-mail.outlook.com | 587 | Same as Office365 |
| Custom | your-server.com | 25/587/465 | Ask your IT admin |

---

### 3. SETUP_TASK_SCHEDULER.ps1
**Purpose:** Enable automated health checks  
**Size:** 200+ lines  
**Admin Required:** Yes

#### Setup Automation (First Time)
```powershell
# Run as Administrator
# Right-click PowerShell → Run as Administrator

& ".\SETUP_TASK_SCHEDULER.ps1" -Schedule Weekly -Time "02:00"
```

#### Parameters
```powershell
-Schedule Daily    # Run every day (default)
-Schedule Weekly   # Run every 7 days (recommended)
-Schedule Monthly  # Run monthly (low frequency)

-Time "02:00"      # Time to run (24-hour format, default: 02:00 AM)
```

#### View Scheduled Tasks
```powershell
& ".\SETUP_TASK_SCHEDULER.ps1" -ListTasks
```

#### Remove Scheduled Task
```powershell
& ".\SETUP_TASK_SCHEDULER.ps1" -RemoveTask
```

#### Batch File Alternative (No PowerShell Skills Needed)
```batch
# Right-click SETUP_AUTOMATION.bat → Run as Administrator
# Follow prompts for schedule configuration
```

---

### 4. ENHANCED_FEATURES.ps1
**Purpose:** Advanced diagnostics and monitoring  
**Size:** 300+ lines  
**Admin Required:** No

#### Usage
```powershell
# Run all enhancements
& ".\ENHANCED_FEATURES.ps1"

# Individual features
& ".\ENHANCED_FEATURES.ps1" -EnableProcessAnalysis         # Top CPU/Memory processes
& ".\ENHANCED_FEATURES.ps1" -EnableNetworkDiagnostics      # Connectivity checks
& ".\ENHANCED_FEATURES.ps1" -EnableAntivirusCheck          # AV status verification
```

#### Features
| Feature | What It Does |
|---------|-------------|
| Process Analysis | Identifies top 5 CPU/Memory consuming processes |
| Network Diagnostics | Tests internet connectivity, DNS resolution, adapter status |
| Antivirus Check | Verifies Windows Defender or 3rd-party antivirus is active |
| Event Logging | Logs health events to Windows Event Viewer |
| CSV Export | Records metrics for trending |

---

### 5. GENERATE_DASHBOARD.ps1
**Purpose:** Create interactive trends visualization  
**Size:** 400+ lines  
**Admin Required:** No

#### Usage
```powershell
# Generate dashboard from CSV trend data
& ".\GENERATE_DASHBOARD.ps1"

# Custom output path
& ".\GENERATE_DASHBOARD.ps1" -OutputPath "c:\custom\path\dashboard.html"

# View last 7 days only
& ".\GENERATE_DASHBOARD.ps1" -DaysToShow 7
```

#### Output
- **File:** `Reports\HealthDashboard.html`
- **Features:** 
  - Line charts for each metric (overall score, CPU, memory, disk, services)
  - Analytics summary (avg, peak, lowest scores)
  - Trend direction (improving/declining/stable)
  - Historical data from CSV logs
  - Interactive charts with Chart.js

#### Requirements
- Requires CSV trend data (generated by APPLY_HEALTH_OPTIMIZATION.ps1)
- Requires internet for Chart.js CDN

---

### 6. UNIFIED_INTEGRATION.ps1
**Purpose:** Master orchestrator combining all components  
**Size:** 300+ lines  
**Admin Required:** Depends on mode

#### Usage
```powershell
# Full suite: health check + email + enhancements + dashboard
& ".\UNIFIED_INTEGRATION.ps1" -Mode Full -RunDashboard -EnableEnhancements

# Health check only
& ".\UNIFIED_INTEGRATION.ps1" -Mode Health

# Email alerts only
& ".\UNIFIED_INTEGRATION.ps1" -Mode Email -SendEmail

# Dashboard only (no optimization)
& ".\UNIFIED_INTEGRATION.ps1" -Mode Trends

# Just health + dashboard (no email/enhancements)
& ".\UNIFIED_INTEGRATION.ps1" -Mode Health -RunDashboard
```

#### Execution Modes
```
Full    - Health optimization + Email alerts + Enhancements + Dashboard
Health  - Health optimization only
Email   - Email alerts only
Trends  - Dashboard generation only
```

---

## 🔄 COMMON WORKFLOWS

### Workflow 1: First-Time Setup (5 minutes)
```powershell
# Step 1: Run initial health check (dry-run)
& ".\APPLY_HEALTH_OPTIMIZATION.ps1" -DryRun

# Step 2: Review report (save to desktop)
# Open: Reports\HealthReport_[latest].html in browser

# Step 3: Run optimization (production)
& ".\APPLY_HEALTH_OPTIMIZATION.ps1"

# Step 4: Check new score
# Open: Reports\HealthReport_[latest].html
```

### Workflow 2: Set Up Automation (10 minutes)
```powershell
# Step 1: Configure email (optional but recommended)
& ".\EMAIL_ALERT_SYSTEM.ps1" -Initialize
# Follow SMTP configuration prompts

# Step 2: Set up scheduler (run as admin)
& ".\SETUP_TASK_SCHEDULER.ps1" -Schedule Weekly -Time "02:00"

# Step 3: Verify setup
& ".\SETUP_TASK_SCHEDULER.ps1" -ListTasks

# Result: Health checks run automatically every week at 2 AM
```

### Workflow 3: Weekly Monitoring (1 minute)
```powershell
# View latest trend dashboard
Invoke-Item "Reports\HealthDashboard.html"

# Or regenerate fresh dashboard
& ".\GENERATE_DASHBOARD.ps1"
```

### Workflow 4: Investigate Performance Issues (15 minutes)
```powershell
# Step 1: Run full analysis with enhancements
& ".\UNIFIED_INTEGRATION.ps1" -Mode Full -EnableEnhancements

# Step 2: Review enhanced report
# Check: Process Analysis section for CPU/Memory hogs
# Check: Network Diagnostics for connectivity issues
# Check: Antivirus Status for security status

# Step 3: Export findings
# Save HTML report to share with IT team
```

### Workflow 5: Emergency System Check (2 minutes)
```powershell
# Quick health status check (dry-run)
& ".\APPLY_HEALTH_OPTIMIZATION.ps1" -DryRun

# If critical issues found:
# Step 1: Apply full optimization
& ".\APPLY_HEALTH_OPTIMIZATION.ps1"

# Step 2: Send alert email
& ".\EMAIL_ALERT_SYSTEM.ps1" -SendAlert -AlertType Critical

# Step 3: Generate dashboard for trending
& ".\GENERATE_DASHBOARD.ps1"
```

---

## ⚙️ CONFIGURATION GUIDE

### Main Configuration: HealthOptimization.config.json
```json
{
  "Scripts": {
    "ScriptPath": "c:\\Operation_Token_Discount_Archive\\3_SCRIPTS_AND_SETUP",
    "ReportPath": "c:\\Operation_Token_Discount_Archive\\3_SCRIPTS_AND_SETUP\\Reports"
  },
  "Thresholds": {
    "CPUWarning": 80,
    "MemoryWarning": 85,
    "DiskWarning": 90,
    "ServicesCritical": 3
  },
  "Optimizations": {
    "EnableDiskCleanup": true,
    "EnableDefragmentation": true,
    "EnableServiceOptimization": true,
    "EnableVirtualMemoryOptimization": true
  },
  "Notifications": {
    "EmailOnCritical": true,
    "EmailOnWarning": false,
    "LogToEventViewer": true
  }
}
```

### Edit Configuration
```powershell
# Open in default editor
notepad HealthOptimization.config.json

# Or in VS Code
code HealthOptimization.config.json
```

### Email Configuration: email.config.json
```json
{
  "SMTPServer": "smtp.gmail.com",
  "SMTPPort": 587,
  "UseTLS": true,
  "SenderEmail": "your-email@gmail.com",
  "SenderPassword": "[APP_PASSWORD_HERE]",
  "Recipients": ["recipient@example.com"],
  "AlertOnCritical": true,
  "WeeklySummaryDay": "Monday",
  "WeeklySummaryTime": "08:00"
}
```

---

## 🔧 TROUBLESHOOTING

### Issue 1: "Administrator privileges required"
**Symptom:** Scripts fail when running optimizations  
**Solution:**
```powershell
# Option A: Run PowerShell as Administrator
# Right-click PowerShell → Run as Administrator
# Then run script

# Option B: Use batch file wrapper
# Right-click SETUP_AUTOMATION.bat → Run as Administrator
```

### Issue 2: "No HTML reports generated"
**Symptom:** Reports folder empty  
**Solution:**
```powershell
# Check Reports directory exists
if (-not (Test-Path "Reports")) { New-Item -Type Directory -Path "Reports" }

# Run with verbose output
& ".\APPLY_HEALTH_OPTIMIZATION.ps1" -Verbose

# Check file permissions
Get-Item "Reports" | Format-List Attributes
```

### Issue 3: "Email configuration not found"
**Symptom:** Email script shows config missing  
**Solution:**
```powershell
# Run email setup wizard
& ".\EMAIL_ALERT_SYSTEM.ps1" -Initialize

# Or manually create email.config.json with SMTP details
# Use configuration guide above as template
```

### Issue 4: "Task Scheduler fails to create task"
**Symptom:** Scheduled task not created  
**Solution:**
```powershell
# Ensure running as Administrator
# Right-click PowerShell → Run as Administrator

# Check Task Scheduler service
Get-Service Schedule | Start-Service

# Run setup again
& ".\SETUP_TASK_SCHEDULER.ps1" -Schedule Weekly
```

### Issue 5: "Dashboard shows no data"
**Symptom:** Blank dashboard HTML  
**Solution:**
```powershell
# Run health checks first to generate CSV data
& ".\APPLY_HEALTH_OPTIMIZATION.ps1"
& ".\APPLY_HEALTH_OPTIMIZATION.ps1"  # Run twice for trend data

# Then generate dashboard
& ".\GENERATE_DASHBOARD.ps1"

# Verify CSV file
Get-ChildItem "Reports\HealthTrends.csv" -ErrorAction Stop
```

---

## 🚀 ADVANCED USAGE

### Integration with Other Tools

#### Export Data to Excel
```powershell
# Export health metrics
Get-Content Reports\HealthTrends.csv | Export-Csv "HealthMetrics.xlsx" -NoTypeInformation

# Open in Excel
Invoke-Item "HealthMetrics.xlsx"
```

#### Send Reports via Email
```powershell
# Include latest report in email
$latestReport = Get-ChildItem "Reports\HealthReport*.html" | Sort LastWriteTime | Select -Last 1
& ".\EMAIL_ALERT_SYSTEM.ps1" -SendAlert -ReportPath $latestReport.FullName
```

#### Schedule Custom Batch Jobs
```powershell
# Morning health check + email
$trigger = New-ScheduledTaskTrigger -Daily -At 7:00AM
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command `"& 'path\UNIFIED_INTEGRATION.ps1' -Mode Full -SendEmail`""
Register-ScheduledTask -TaskName "MorningHealthCheck" -Trigger $trigger -Action $action -RunLevel Highest
```

### Programmatic Usage (PowerShell Functions)

#### Get Latest Health Score
```powershell
function Get-LatestHealthScore {
    $latestReport = Get-ChildItem "Reports\HealthReport*.html" | Sort LastWriteTime | Select -Last 1
    $content = Get-Content $latestReport.FullName
    
    if ($content -match "Overall Score: (\d+\.?\d*)") {
        return [float]$matches[1]
    }
}

$score = Get-LatestHealthScore
Write-Host "Current Health Score: $score/100"
```

#### Check System Status
```powershell
function Get-SystemHealthStatus {
    param([string]$ReportPath = (Get-ChildItem "Reports\HealthReport*.html" | Sort LastWriteTime | Select -Last 1).FullName)
    
    $content = Get-Content $ReportPath
    
    if ($content -match "Critical Issues: (\d+)") {
        return @{
            CriticalCount = [int]$matches[1]
            HealthySystem = [int]$matches[1] -eq 0
        }
    }
}

$status = Get-SystemHealthStatus
if ($status.HealthySystem) {
    Write-Host "✓ System is healthy"
} else {
    Write-Host "✗ System has critical issues"
}
```

### Batch Processing Multiple Systems

```powershell
# Run on multiple computers
$computers = "Server1", "Server2", "Server3"

foreach ($computer in $computers) {
    Write-Host "Checking $computer..."
    Invoke-Command -ComputerName $computer -ScriptBlock {
        & "C:\scripts\APPLY_HEALTH_OPTIMIZATION.ps1"
    }
}
```

---

## 📊 METRICS REFERENCE

### Health Score Components
| Component | Weight | Max Points | Threshold |
|-----------|--------|-----------|-----------|
| CPU Usage | 25% | 25 | <80% = 25, 100% = 0 |
| Memory Usage | 25% | 25 | <85% = 25, 100% = 0 |
| Disk Space | 25% | 25 | <90% = 25, 100% = 0 |
| Services | 25% | 25 | 0 failed = 25, 3+ = 0 |

### Overall Score Interpretation
```
90-100: Excellent    ✓ System optimal
75-89:  Good         ✓ System performing well
60-74:  Fair         ⚠ Optimization needed
45-59:  Poor         ⚠ Significant issues
0-44:   Critical     ✗ Urgent action required
```

---

## 📞 SUPPORT & RESOURCES

### File Locations
```
Main Scripts:     c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\*.ps1
Reports:          c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\Reports\
Config Files:     c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\*.json
Dashboard:        Reports\HealthDashboard.html
CSV Trends:       Reports\HealthTrends.csv
```

### Key Files
- `APPLY_HEALTH_OPTIMIZATION.ps1` - Core script
- `EMAIL_ALERT_SYSTEM.ps1` - Email notifications
- `ENHANCED_FEATURES.ps1` - Advanced diagnostics
- `GENERATE_DASHBOARD.ps1` - Trends visualization
- `UNIFIED_INTEGRATION.ps1` - Master orchestrator
- `HealthOptimization.config.json` - Main settings
- `email.config.json` - SMTP settings

### Quick Command Reference
```powershell
# Health Check
& ".\APPLY_HEALTH_OPTIMIZATION.ps1"

# Dry Run
& ".\APPLY_HEALTH_OPTIMIZATION.ps1" -DryRun

# Setup Email
& ".\EMAIL_ALERT_SYSTEM.ps1" -Initialize

# Setup Scheduler
& ".\SETUP_TASK_SCHEDULER.ps1" -Schedule Weekly -Time "02:00"

# Enhanced Diagnostics
& ".\ENHANCED_FEATURES.ps1"

# View Dashboard
& ".\GENERATE_DASHBOARD.ps1"
Invoke-Item "Reports\HealthDashboard.html"

# Everything
& ".\UNIFIED_INTEGRATION.ps1" -Mode Full -RunDashboard -EnableEnhancements
```

---

**Last Updated:** 2025-10-26  
**Version:** 1.0  
**Status:** Production Ready  
