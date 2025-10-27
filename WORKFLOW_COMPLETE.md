# COMPLETE WORKFLOW GUIDE

## Overview

You now have a **complete System Health Optimization Suite** with 6 deployment steps. This guide explains how to execute the workflow.

## Quick Start (Choose One)

### Option A: Automated (Simplest - 36 minutes)

```powershell
Run: WORKFLOW_LAUNCHER.bat
Select: [A] Auto-Run All 6 Steps
```

This runs all 6 steps in sequence automatically.

### Option B: Manual (More Control - 36 minutes total)

```powershell
Run: WORKFLOW_LAUNCHER.bat
Select steps individually as needed (1-6)
```

### Option C: Individual Scripts (Advanced - as needed)

See "Step Details" section below.

---

## 6-Step Workflow Explained

### ✅ Step 1: Setup Automation (5 minutes)

**File**: `SETUP_TASK_SCHEDULER_ADMIN.bat`

**What it does**: Creates Windows Task Scheduler job for automatic weekly health checks

**When**: Run first - this enables automation

**Result**: Health checks run automatically every Monday at 2:00 AM

**How to run**:

```batch
Right-click: SETUP_TASK_SCHEDULER_ADMIN.bat
Select: Run as Administrator
```

**What you''ll see**:

- Admin elevation request
- Task scheduler configuration
- Success message with next step

---

### ✅ Step 2: Configure Email (10 minutes)

**File**: `EMAIL_SETUP.bat`

**What it does**: Sets up SMTP email alerts for critical issues + weekly summaries

**Requirements**:

- SMTP server (Gmail, Office365, etc.)
- Email credentials
- Recipient addresses

**How to run**:

```batch
Double-click: EMAIL_SETUP.bat
```

**SMTP Server Examples**:

- **Gmail**: `smtp.gmail.com:587` (use App Password)
- **Office365**: `smtp.office365.com:587`
- **Outlook**: `smtp-mail.outlook.com:587`

**What happens**:

- Prompts for SMTP configuration
- Tests email connection
- Saves configuration to `email.config.json`
- Email alerts enabled

---

### ✅ Step 3: Generate Baselines (3 minutes)

**File**: `GENERATE_BASELINES.bat`

**What it does**: Collects 5 health snapshots for trend analysis

**Why important**: Dashboard needs multiple data points to show trends

**Time between samples**: 60 seconds each

**How to run**:

```batch
Double-click: GENERATE_BASELINES.bat
```

**Result**:

- 5 new CSV records added to `Reports\HealthTrends.csv`
- Dashboard will show trends (not just flat line)
- Better accuracy for detecting improvements/degradation

---

### ✅ Step 4: Full Integration Test (2 minutes)

**File**: `FULL_TEST.bat`

**What it does**: Runs complete system verification with all components active

**Includes**:

- Core health optimization
- Enhanced diagnostics (process, network, antivirus)
- CSV export to trends file
- Dashboard generation

**How to run**:

```batch
Double-click: FULL_TEST.bat
```

**Success indicators**:

- All components complete without errors
- New HTML report generated
- Dashboard updated with latest data
- CSV trends file updated

---

### ✅ Step 5: View Dashboard (1 minute)

**File**: `VIEW_DASHBOARD.bat`

**What it does**: Opens interactive health visualization

**Features**:

- CPU, Memory, Disk, Services trend charts
- Health score progression
- Critical issues timeline
- Recommendations

**How to run**:

```batch
Double-click: VIEW_DASHBOARD.bat
```

**What you''ll see**:

- Interactive charts with your data
- Trend analysis (Improving/Stable/Declining)
- Historical comparisons

---

### ✅ Step 6: Review Documentation (15 minutes)

**File**: `OPEN_DOCS.bat`

**What it does**: Opens complete documentation suite

**Documents included**:

- `QUICK_REFERENCE.txt` - One-page quick start
- `README.md` - Comprehensive usage guide
- `MASTER_COMMAND_REFERENCE.md` - Complete command reference

**How to run**:

```batch
Double-click: OPEN_DOCS.bat
```

**What you''ll learn**:

- All available commands
- Advanced configuration options
- Troubleshooting guide
- Best practices

---

## Master Workflow Launcher

**File**: `WORKFLOW_LAUNCHER.bat`

This is your main control center. It provides:

```
[A] Auto-Run All 6 Steps (runs all automatically)
[1-6] Run individual steps
[S] Show System Status (instant health check)
[T] Check Task Scheduler (verify automation)
[L] View Latest Report (see most recent analysis)
[Q] Quit
```

**Usage**:

```batch
Run: WORKFLOW_LAUNCHER.bat
Choose option and follow prompts
```

---

## What Happens After Workflow Complete

### ✅ Automated Weekly Schedule

Every Monday at 2:00 AM:

1. Health check runs automatically
2. Results saved to CSV
3. Email alert sent (if critical issues)
4. Dashboard automatically updated

### ✅ Manual On-Demand

Anytime you can:

1. Run `WORKFLOW_LAUNCHER.bat`
2. Select `[S] Show System Status`
3. Get instant health metrics

### ✅ Continuous Monitoring

- **CSV Trends**: 30-day history maintained
- **Email Alerts**: Critical issues sent immediately
- **Dashboard**: Updated every run with visualizations
- **Reports**: New HTML report generated on each check

---

## Troubleshooting

### Issue: "Admin privileges required"

**Solution**: Right-click batch file and select "Run as Administrator"

### Issue: Email won''t configure

**Solutions**:

1. Check SMTP server address is correct
2. For Gmail: use App-specific password (not regular password)
3. For Office365: verify email address format
4. Check firewall not blocking port 587

### Issue: Dashboard shows no data

**Solution**:

1. Run `GENERATE_BASELINES.bat` first (needs 5+ samples)
2. Then run `FULL_TEST.bat` to update dashboard
3. Then open dashboard again

### Issue: Task Scheduler automation not running

**Solution**:

1. Run `WORKFLOW_LAUNCHER.bat`
2. Select `[T] Check Task Scheduler`
3. Verify task shows as "Ready"
4. Check Windows Event Log for errors

---

## Success Criteria

✅ **After completing all 6 steps, you should have**:

- Weekly automation scheduled in Task Scheduler
- Email alerts configured and tested
- 5+ health snapshots for trend analysis
- All systems verified working
- Interactive dashboard with visualizations
- Understanding of complete system
- Automated reports and alerts running

✅ **Your system is now**:

- Continuously monitored
- Automatically optimized weekly
- Alert-enabled for critical issues
- Tracking trends with visualization
- Fully documented and supported

---

**Last Updated**: October 27, 2025
**Version**: Complete 6-step system
**Status**: Ready for deployment

