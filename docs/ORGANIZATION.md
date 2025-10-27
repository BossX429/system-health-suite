# System Health Optimization Suite

> **Organized for Comfort** - Professional PowerShell-based system monitoring and optimization with automated task scheduling, email alerts, and interactive dashboards.

## 📁 Project Structure

```bash
system-health-suite/
├── automation/          # Batch orchestrators and task scheduling
│   ├── WORKFLOW_LAUNCHER.bat
│   ├── SETUP_TASK_SCHEDULER_ADMIN.bat
│   ├── EMAIL_SETUP.bat
│   ├── GENERATE_BASELINES.bat
│   ├── FULL_TEST.bat
│   ├── VIEW_DASHBOARD.bat
│   └── OPEN_DOCS.bat
│
├── scripts/             # PowerShell core engines
│   ├── APPLY_HEALTH_OPTIMIZATION.ps1
│   ├── EMAIL_ALERT_SYSTEM.ps1
│   ├── GENERATE_DASHBOARD.ps1
│   ├── UNIFIED_INTEGRATION.ps1
│   ├── SETUP_TASK_SCHEDULER.ps1
│   └── ENHANCED_FEATURES.ps1
│
├── docs/                # Complete documentation
│   ├── README.md
│   ├── WORKFLOW_COMPLETE.md
│   ├── MASTER_COMMAND_REFERENCE.md
│   ├── QUICK_REFERENCE.txt
│   └── .github/
│       └── copilot-instructions.md
│
├── config/              # Configuration files
│   └── (JSON configs as needed)
│
├── Reports/             # Generated health reports and dashboards
│   ├── HealthDashboard.html
│   ├── HealthTrends.csv
│   └── HealthReport_*.html
│
└── START.bat            # Quick access launcher (double-click to start)
```

## 🚀 Quick Start

### Easiest Way

1. **Double-click `START.bat`** in the root directory
2. Select your desired option from the menu
3. Follow on-screen prompts

### From Command Line

```powershell
cd <repository-root>
.\automation\WORKFLOW_LAUNCHER.bat
```

## 📋 What's Where

| Folder | Purpose | When to Use |
|--------|---------|------------|
| `automation/` | Menu-driven batch orchestrators | Running the system, scheduling, testing |
| `scripts/` | PowerShell engines & core logic | Development, debugging, or direct execution |
| `docs/` | Complete documentation | Learning, troubleshooting, reference |
| `config/` | System configuration | Customizing behavior and settings |
| `Reports/` | Generated outputs | Viewing health reports and trends |

## ⚙️ Core Features

- **System Health Monitoring** - Real-time CPU, memory, disk, and service analysis
- **Automated Scheduling** - Weekly checks via Windows Task Scheduler
- **Email Alerts** - SMTP-based notifications for critical issues
- **Interactive Dashboard** - Chart.js-based trend visualization
- **Baseline Trending** - CSV-based historical data tracking
- **HTML Reports** - Detailed health analysis with recommendations

## 📊 Dashboard

After running a health check, view the interactive dashboard:

```html
Reports/HealthDashboard.html
```

## 🔧 Configuration

Edit settings in:

- `scripts/APPLY_HEALTH_OPTIMIZATION.ps1` - Health parameters
- `scripts/EMAIL_ALERT_SYSTEM.ps1` - SMTP configuration
- `scripts/SETUP_TASK_SCHEDULER.ps1` - Automation schedule

## 📖 Documentation

- **`docs/README.md`** - Complete feature guide
- **`docs/MASTER_COMMAND_REFERENCE.md`** - All commands and parameters
- **`docs/QUICK_REFERENCE.txt`** - One-page cheat sheet
- **`docs/WORKFLOW_COMPLETE.md`** - 6-step deployment walkthrough

## 🛠️ Development

### PowerShell Scripts (in `scripts/`)

- Modular, independently callable
- Use `UNIFIED_INTEGRATION.ps1` to orchestrate
- All use character-code HTML (`[char]60` for `<`)

### Batch Files (in `automation/`)

- User-friendly menu interface
- Call scripts with proper paths
- Handle directory navigation

## 📝 Recent Updates

✅ Reorganized into logical subdirectories for comfort  
✅ All PowerShell Unicode characters fixed  
✅ Markdown documentation cleaned and validated  
✅ Git repository ready for deployment

## 🤝 Contributing

See `.github/copilot-instructions.md` for AI agent development guidelines.

## 📜 License

Deployment package for system optimization and monitoring.

---

**Status**: Production Ready | **Version**: 1.0 | **Last Updated**: October 27, 2025
