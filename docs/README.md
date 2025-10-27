# System Health Optimization & Automation Setup Guide

## Overview

This directory contains a comprehensive system health optimization and automation suite:

1. **APPLY_HEALTH_OPTIMIZATION.ps1** - Main health check and optimization script
2. **SETUP_TASK_SCHEDULER.ps1** - Automates scheduling of health checks
3. **SETUP_AUTOMATION.bat** - Easy launcher for task scheduler setup
4. **RUN_HEALTH_CHECK.bat** - Quick manual health check launcher

---

## Files Included

### Primary Scripts

#### 1. APPLY_HEALTH_OPTIMIZATION.ps1
The main health optimization engine that:
- **Calculates overall health score** (0-100) based on:
  - CPU Health (25%)
  - Memory Health (25%)
  - Disk Health (25%)
  - Services Health (25%)

- **Detects critical issues**:
  - Services not running
  - Disk space critically low
  - Security vulnerabilities

- **Identifies warning signs**:
  - High CPU usage (>70%)
  - High memory usage (>80%)
  - Fragmentation issues

- **Implements optimizations**:
  - Clears temporary files
  - Optimizes startup programs
  - Ensures Windows Update running
  - Verifies safe parameters

- **Identifies bottlenecks**:
  - CPU Performance
  - Memory Constraints
  - Disk I/O

- **Creates action items**:
  - Tracks tasks with priorities
  - Schedules follow-ups
  - Assigns owners

- **Generates detailed HTML reports** with all findings

**Usage:**
```powershell
# Dry-run mode (preview changes without applying)
powershell -ExecutionPolicy Bypass -File "APPLY_HEALTH_OPTIMIZATION.ps1" -DryRun

# Production mode (applies optimizations)
powershell -ExecutionPolicy Bypass -File "APPLY_HEALTH_OPTIMIZATION.ps1"
```

---

#### 2. SETUP_TASK_SCHEDULER.ps1
Automates scheduling of health checks via Windows Task Scheduler.

**Features:**
- Creates recurring health optimization tasks
- Supports Daily, Weekly, or Monthly scheduling
- Configurable execution time
- Generates supporting files
- Can list and remove scheduled tasks

**Requires:** Administrator privileges

**Usage:**
```powershell
# Create weekly task at 2:00 AM
powershell -ExecutionPolicy Bypass -File "SETUP_TASK_SCHEDULER.ps1" -Schedule Weekly -Time 02:00

# Create daily task at 3:00 AM
powershell -ExecutionPolicy Bypass -File "SETUP_TASK_SCHEDULER.ps1" -Schedule Daily -Time 03:00

# List all scheduled health tasks
powershell -ExecutionPolicy Bypass -File "SETUP_TASK_SCHEDULER.ps1" -ListTasks

# Remove scheduled task
powershell -ExecutionPolicy Bypass -File "SETUP_TASK_SCHEDULER.ps1" -Remove
```

---

#### 3. SETUP_AUTOMATION.bat
Easy launcher that handles admin elevation for you.

**Usage:**
1. Right-click **SETUP_AUTOMATION.bat**
2. Select **"Run as administrator"**
3. Follow the prompts

This will:
- Verify admin privileges
- Create the scheduled task
- Generate supporting files
- Show setup completion

---

#### 4. RUN_HEALTH_CHECK.bat
Quick launcher to manually run health optimization.

**Usage:**
Simply double-click the file to run a health check immediately.

---

### Supporting Files

#### HealthOptimization.config.json
Configuration file containing:
- Script paths
- Schedule settings
- Report directory
- Creation timestamp
- Version information

#### Health Reports
HTML reports generated with detailed findings:
- Overall health score
- Component metrics
- Critical issues
- Warnings
- Applied optimizations
- Safe parameters
- Bottlenecks
- Action items

---

## Quick Start Guide

### Step 1: Run Manual Health Check
```bash
# Run the health check immediately
APPLY_HEALTH_OPTIMIZATION.ps1

# Or use the batch file
RUN_HEALTH_CHECK.bat
```

### Step 2: Review Report
Open the generated HTML report to review:
- System health score
- Any issues detected
- Optimizations applied
- Recommended actions

### Step 3: Set Up Automation (Optional)
```bash
# Method 1: Use the batch file (Easiest)
1. Right-click SETUP_AUTOMATION.bat
2. Select "Run as administrator"
3. Follow prompts

# Method 2: Use PowerShell (Advanced)
powershell -ExecutionPolicy Bypass -File "SETUP_TASK_SCHEDULER.ps1" -Schedule Weekly -Time 02:00
```

### Step 4: Verify Scheduled Task
```bash
# Open Task Scheduler
taskschd.msc

# Or list via PowerShell
powershell -ExecutionPolicy Bypass -File "SETUP_TASK_SCHEDULER.ps1" -ListTasks
```

---

## Health Score Explained

### Score Range
- **90-100**: Excellent - System in optimal condition
- **75-89**: Good - System healthy with minor issues
- **60-74**: Fair - System requires attention
- **45-59**: Poor - System needs significant optimization
- **0-44**: Critical - System requires immediate intervention

### Component Breakdown
Each component is scored 0-25:
- **CPU Health**: Low utilization is better (< 80% target)
- **Memory Health**: Low utilization is better (< 85% target)
- **Disk Health**: Adequate free space is better (< 90% full target)
- **Services Health**: Fewer failed services is better

---

## Reports

### Report Contents

#### 1. Overall Health Score
- Composite score (0-100)
- Status (Excellent/Good/Fair/Poor/Critical)
- Calculation method
- Component breakdown

#### 2. Critical Issues
- Issues detected
- Severity level
- Impact assessment
- How issues were mitigated/resolved

#### 3. Warnings
- Warning signs observed
- Current values
- Prevention strategies
- Status

#### 4. Optimizations Applied
- Recommendations implemented
- Implementation details
- Whether tested
- Results

#### 5. Safe Parameters
- Parameters verified
- Safe values set
- Current settings
- Verification status

#### 6. Bottlenecks
- Bottlenecks identified
- Performance indicators
- Root causes
- Solutions

#### 7. Action Items
- Unique ID (AI-001, etc.)
- Task description
- Priority (High/Medium/Low)
- Due dates
- Owner assignments
- Status tracking

---

## Scheduling Options

### Weekly (Recommended)
- Day: Sunday
- Time: 2:00 AM
- Frequency: Once per week
- Best for: Comprehensive weekly reviews

```powershell
SETUP_TASK_SCHEDULER.ps1 -Schedule Weekly -Time 02:00
```

### Daily
- Time: Configurable (default: 2:00 AM)
- Frequency: Every day
- Best for: Continuous monitoring
- Note: May impact system performance

```powershell
SETUP_TASK_SCHEDULER.ps1 -Schedule Daily -Time 03:00
```

### Monthly
- Date: 1st of each month
- Time: Configurable (default: 2:00 AM)
- Frequency: Once per month
- Best for: Baseline comparison

```powershell
SETUP_TASK_SCHEDULER.ps1 -Schedule Monthly -Time 02:00
```

---

## Troubleshooting

### Task Won't Schedule
**Issue:** "Administrator privileges required"
**Solution:** 
- Right-click SETUP_AUTOMATION.bat
- Select "Run as administrator"

### Script Won't Run
**Issue:** "ExecutionPolicy" error
**Solution:**
- Run PowerShell as Administrator
- Change execution policy: `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser`

### Reports Not Generating
**Issue:** No HTML report created
**Solution:**
- Check disk space
- Verify write permissions to script directory
- Check Windows Event Viewer for errors

### Task Keeps Failing
**Issue:** Scheduled task shows error
**Solution:**
- Open Task Scheduler (taskschd.msc)
- Right-click task → Properties
- Check "Run with highest privileges" is enabled
- Review task history for specific error codes

---

## Advanced Usage

### Monitor Task Execution
```powershell
# View all health optimization tasks
Get-ScheduledTask | Where-Object {$_.TaskName -like '*Health*'}

# View task history
Get-WinEvent -LogName 'Microsoft-Windows-TaskScheduler/Operational' | Select-Object -First 20
```

### Remove Scheduled Task
```powershell
SETUP_TASK_SCHEDULER.ps1 -Remove
```

### Customize Optimization Parameters
Edit `APPLY_HEALTH_OPTIMIZATION.ps1` to:
- Adjust thresholds for warnings/critical alerts
- Add custom health checks
- Modify optimization procedures
- Change report format

---

## Best Practices

1. **Schedule Off-Peak Hours**
   - Avoid running during business hours
   - Schedule for early morning (2-4 AM) or late evening
   - Consider international time zones for distributed teams

2. **Monitor Reports Regularly**
   - Review generated reports weekly
   - Track trends over time
   - Act on critical issues promptly

3. **Keep Records**
   - Archive old reports
   - Maintain audit trail
   - Document manual interventions

4. **Test Before Production**
   - Always run in dry-run mode first
   - Review changes before full deployment
   - Verify system stability

5. **Maintain Documentation**
   - Document custom modifications
   - Keep baseline metrics
   - Track optimization history

---

## System Requirements

- **OS**: Windows 10 / Windows Server 2016+
- **Privileges**: Administrator (for optimization and scheduling)
- **PowerShell**: 5.0 or higher
- **Disk Space**: 50+ MB for reports

---

## Support & Issues

### Common Issues

1. **High disk usage after optimization**
   - Solution: Disk cleanup completes over time
   - Monitor with APPLY_HEALTH_OPTIMIZATION.ps1

2. **Task runs but no report generated**
   - Solution: Check Reports directory exists
   - Create manually: `mkdir Reports`

3. **System slow during optimization**
   - Solution: Adjust schedule time
   - Run during off-peak hours

---

## Version History

### v1.0 (Oct 2025)
- Initial release
- Health score calculation (4 metrics)
- Critical issues detection
- Warning signs identification
- Optimization recommendations
- HTML report generation
- Task Scheduler automation
- Action items tracking

---

## License & Contact

For questions or issues, contact your System Administrator.

---

**Last Updated:** October 26, 2025
**Generated By:** System Health Optimization Suite v1.0
