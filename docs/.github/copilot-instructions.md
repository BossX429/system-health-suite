# System Health Optimization Suite - AI Coding Agent Instructions

## Big Picture Architecture

This is a **Windows system health monitoring and automation platform** deployed as a 6-step workflow. The system continuously monitors system performance (CPU, Memory, Disk, Services) and generates actionable reports with optional weekly automation via Task Scheduler.

### Core Components & Data Flow

```
User Input (WORKFLOW_LAUNCHER.bat)
    ↓
[Batch Orchestrators] - 8 .bat files that handle step sequencing
    ↓
[PowerShell Engines] - 6 .ps1 scripts doing actual work:
    ├─ APPLY_HEALTH_OPTIMIZATION.ps1 (core health analysis)
    ├─ EMAIL_ALERT_SYSTEM.ps1 (SMTP notifications)
    ├─ ENHANCED_FEATURES.ps1 (process/network diagnostics)
    ├─ GENERATE_DASHBOARD.ps1 (Chart.js visualization)
    ├─ SETUP_TASK_SCHEDULER.ps1 (Windows automation)
    └─ UNIFIED_INTEGRATION.ps1 (master orchestrator)
    ↓
[Data & Outputs]
    ├─ Reports/HealthReport_*.html (7-section analysis)
    ├─ Reports/HealthDashboard.html (interactive charts)
    ├─ Reports/HealthTrends.csv (CSV trending data)
    └─ Config JSON files (SMTP, optimization settings)
```

**Why this architecture:**
- Batch files provide accessible GUI for non-technical users (double-click to run)
- PowerShell handles OS-level operations (Task Scheduler, WMI queries, file I/O)
- Modular scripts allow independent execution and testing
- Unified mode combines all features for end-to-end automation

## Critical Developer Workflows

### Adding a New Health Metric

**Pattern in `APPLY_HEALTH_OPTIMIZATION.ps1`:**
1. Create `function Get-[MetricName]Health` returning 0-25 score
2. Add to health score calculation (must sum to 100 total)
3. Add HTML generation section in report builder (line ~45)
4. Export to CSV in trend data section

Example structure:
```powershell
function Get-GPUHealth {
    # Query WMI or Performance Monitor
    # Calculate score 0-25 based on utilization/temperature
    # Return score and status
    return @{ Score = $score; Status = $status }
}
```

### Creating New Batch Workflow Step

**Pattern:** Copy existing batch file, modify:
1. Step number in title
2. Call to correct PowerShell script
3. Success/error messages
4. Progress indicators

**Key convention:** All batch files MUST call PowerShell with explicit path:
```batch
powershell -ExecutionPolicy Bypass -Command "& 'c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\SCRIPT_NAME.ps1'"
```

### Updating Dashboard Without Rebuild

**Key files:**
- `Reports/HealthTrends.csv` - Append new row with timestamp, all metrics
- `GENERATE_DASHBOARD.ps1` - Reads CSV, generates interactive HTML
- Chart.js library sourced from CDN (no offline dependency)

**Convention:** CSV schema is strict - adding columns requires updating both CSV export AND Chart.js data mapping section.

## Project-Specific Patterns & Conventions

### Health Score Calculation (NOT averages)
- **CPU Health:** `25 - (CurrentCPU% * 0.25)` if <80%, else 0
- **Memory Health:** Similar threshold-based, not averaging
- **Components weighted equally:** Each maxes at 25 points
- **NEVER use simple average** - this breaks the 0-100 scale

**Why:** Thresholds matter more than averages for system health assessment

### HTML Report Format
- **ALWAYS use character codes** for HTML tags: `$lt = [char]60` for `<`
  - PowerShell tokenizer interprets literal `<` as operator at parse-time
  - This is NOT escapable - must use character codes
- **7 mandatory sections** in exact order (line ~47 in APPLY_HEALTH_OPTIMIZATION.ps1):
  1. Overall Health Score
  2. Critical Issues  
  3. Warnings
  4. Optimizations Applied
  5. Safe Parameters
  6. Bottlenecks
  7. Action Items

### File Output Conventions
- Reports: `Reports/HealthReport_[YYYYMMDD_HHMMSS].html`
- Dashboard: `Reports/HealthDashboard.html` (overwrites, not timestamped)
- CSV: `Reports/HealthTrends.csv` (appends, never overwrites)
- Use `-FilePath` parameter (NOT `-Path`) for `Out-File` - this was a discovered bug

### Configuration Storage
- Primary config: `HealthOptimization.config.json` (health thresholds)
- Secondary config: `email.config.json` (SMTP settings, created on first run)
- **Convention:** All numeric thresholds are percentages (80 = 80%, not 0.8)

## Integration Points & External Dependencies

### Windows Task Scheduler Integration
- **Script:** `SETUP_TASK_SCHEDULER.ps1` 
- **Task Name:** `BuildAgent.HealthCheck-Continuous`
- **Requires:** Administrator privileges (`-RunAs` flag)
- **Default:** Weekly Monday 2:00 AM, configurable via parameters
- **Trigger behavior:** If system off at scheduled time, runs on next login

### Email System Integration
- **Script:** `EMAIL_ALERT_SYSTEM.ps1`
- **Dependencies:** .NET SmtpClient (built-in, no external package needed)
- **Configuration:** First-run wizard creates `email.config.json`
- **Supported SMTP:** Gmail (needs App Password, not regular password), Office365, custom servers
- **Alert types:** Critical immediate + Weekly Monday digests

### Dashboard Visualization
- **Script:** `GENERATE_DASHBOARD.ps1`
- **External dependency:** Chart.js library (loaded from CDN - requires internet)
- **Data source:** Always reads from `Reports/HealthTrends.csv` - must have ≥2 rows for charts to render
- **If offline:** Dashboard HTML still generates but charts won't display

### CSV Trend Export
- **Format:** Standard Windows CSV (comma-delimited, quoted fields)
- **Columns (locked):** Timestamp, ComputerName, OverallScore, Status, CPUHealth, MemoryHealth, DiskHealth, ServicesHealth, CriticalIssues, Warnings
- **Appends only:** Never deletes historical data
- **Reading pattern:** `Import-Csv` expects headers in row 1

## Cross-Component Communication

### Unified Integration Mode (`UNIFIED_INTEGRATION.ps1`)
- **Orchestration pattern:** Dot-source all other scripts, call functions in sequence
- **Error handling:** If one component fails, continues with others (non-blocking)
- **Output:** HTML report + CSV append + optional email

### Workflow Sequencing (WORKFLOW_LAUNCHER.bat)
- **Six step execution order is LOCKED** - changing order breaks dashboard trending
- **Step 3 (baselines)** is critical - must collect ≥2 samples for CSV trending to work
- **Step 5 (dashboard)** depends on Step 3 having data

## Testing & Debugging

### Running Individual Scripts Safely
```powershell
# ALWAYS use -DryRun first - no system changes
& ".\APPLY_HEALTH_OPTIMIZATION.ps1" -DryRun

# For email testing (doesn't send until confirmed)
& ".\EMAIL_ALERT_SYSTEM.ps1" -TestOnly

# For task scheduler (validates before creating)
& ".\SETUP_TASK_SCHEDULER.ps1" -Schedule Weekly -Time "02:00" -WhatIf
```

### Common Bug Patterns to Avoid

1. **PowerShell Parse Error** 
   - **Cause:** Literal `<` or `>` in source code at parse-time
   - **Solution:** Use `[char]60` and `[char]62` to build HTML
   - **NOT fixable with:** Escaping, quoting, backticks

2. **Out-File Parameter Error**
   - **Wrong:** `-Path` parameter (doesn't exist in some versions)
   - **Right:** `-FilePath` parameter (universal)

3. **CSV Not Appending**
   - **Cause:** Not using `-Append` flag, or overwriting entire file
   - **Solution:** Always use `Add-Content` or `Out-File -Append`

4. **Dashboard Charts Blank**
   - **Cause:** CSV has <2 data rows, or Chart.js fails to load
   - **Solution:** Check CSV has headers + ≥2 data rows, test offline mode

## Code Examples from Codebase

### Health Score Calculation Pattern
```powershell
# From APPLY_HEALTH_OPTIMIZATION.ps1
$cpuScore = if ($avgCPU -le 80) { 
    [math]::Max(0, 25 - ($avgCPU / 4)) 
} else { 
    0 
}
$memoryScore = if ($memPercent -le 85) { 
    [math]::Max(0, 25 - ($memPercent / 3.4)) 
} else { 
    0 
}
$overallScore = $cpuScore + $memoryScore + $diskScore + $servicesScore
```

### HTML Character Code Generation Pattern
```powershell
# Don't write HTML directly - use character codes
$lt = [char]60  # <
$gt = [char]62  # >
$html = @()
$html += ($lt + "html" + $gt)
$html += ($lt + "head" + $gt)
# ... build array ...
$html -join "`n" | Out-File -FilePath $reportPath -Encoding UTF8
```

### CSV Appending Pattern
```powershell
# From APPLY_HEALTH_OPTIMIZATION.ps1 export section
$csvData = "$timestamp,$computerName,$overallScore,$status,$cpuScore,$memScore,$diskScore,$servicesScore,$criticalCount,$warningCount"
Add-Content -Path $trendsCsvPath -Value $csvData -Encoding UTF8
```

## Quick Lookup: What to Modify for Common Changes

| Change | File | Section | Notes |
|--------|------|---------|-------|
| Health thresholds (CPU%, Memory%) | HealthOptimization.config.json | Thresholds section | Numeric percentages only |
| Report template | APPLY_HEALTH_OPTIMIZATION.ps1 | Line ~47-70 (report builder) | Use character codes for HTML |
| Schedule time/frequency | SETUP_TASK_SCHEDULER.ps1 | Line ~25-35 | Task creation logic |
| Dashboard chart types | GENERATE_DASHBOARD.ps1 | Line ~100-150 | Chart.js configuration section |
| CSV columns | Multiple (see Integration) | Column definitions | Must update export + chart mapper |
| Email template | EMAIL_ALERT_SYSTEM.ps1 | Line ~80-120 | HTML email body generation |
| Batch workflow steps | WORKFLOW_LAUNCHER.bat | Menu section | Exact order matters for trending |

## Known Limitations & Documented Workarounds

1. **Offline Mode:** Dashboard won't show charts without internet (Chart.js CDN dependency)
   - **Workaround:** Deploy local Chart.js or generate static PNG instead

2. **CSV Growth:** 30-day history grows unbounded
   - **Workaround:** Implement CSV rotation/archival in maintenance script

3. **Task Scheduler:** Can't run if system offline at scheduled time on non-domain systems
   - **Workaround:** Set task to run on login as backup

4. **Email:** SMTP timeout if network unreachable
   - **Workaround:** Wrap in try-catch, queue alerts for retry

## Documentation References

- **User guide:** README.md (complete feature overview)
- **Complete commands:** MASTER_COMMAND_REFERENCE.md (all parameters, 800+ lines)
- **Quick reference:** QUICK_REFERENCE.txt (1-page cheat sheet)
- **Workflow steps:** WORKFLOW_COMPLETE.md (6-step deployment guide)

---

**Last Updated:** October 27, 2025  
**Codebase Version:** 1.0 - Production  
**Status:** All components tested and operational
