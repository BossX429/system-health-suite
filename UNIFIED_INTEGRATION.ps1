<#
.SYNOPSIS
    Complete System Health Optimization Suite - Unified Integration
.DESCRIPTION
    Master script that orchestrates all components: optimization, email alerts, trend tracking, advanced diagnostics
.PARAMETER Mode
    Execution mode: 'Full' (all features), 'Health' (only health check), 'Email' (email alerts), 'Trends' (dashboard only)
.PARAMETER RunDashboard
    Generate trends dashboard after execution
.PARAMETER SendEmail
    Send email alert if critical issues found
.PARAMETER EnableEnhancements
    Include advanced diagnostics (process analysis, network diagnostics, antivirus check)
#>

param(
    [ValidateSet('Full', 'Health', 'Email', 'Trends')]
    [string]$Mode = 'Full',
    [switch]$RunDashboard,
    [switch]$SendEmail,
    [switch]$EnableEnhancements
)

# ============================================================================
# CONFIGURATION
# ============================================================================

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$mainScript = Join-Path $scriptPath "APPLY_HEALTH_OPTIMIZATION.ps1"
$emailScript = Join-Path $scriptPath "EMAIL_ALERT_SYSTEM.ps1"
$enhancedScript = Join-Path $scriptPath "ENHANCED_FEATURES.ps1"
$dashboardScript = Join-Path $scriptPath "GENERATE_DASHBOARD.ps1"
$configPath = Join-Path $scriptPath "HealthOptimization.config.json"
$emailConfigPath = Join-Path $scriptPath "email.config.json"

# ============================================================================
# VALIDATION
# ============================================================================

function Test-AllScripts {
    Write-Host "Validating script dependencies..." -ForegroundColor Cyan
    
    $scripts = @(
        @{Path = $mainScript; Name = "Main Optimization Script"}
        @{Path = $emailScript; Name = "Email Alert System"}
        @{Path = $enhancedScript; Name = "Enhanced Features"}
        @{Path = $dashboardScript; Name = "Dashboard Generator"}
    )
    
    $allValid = $true
    foreach ($script in $scripts) {
        if (Test-Path $script.Path) {
            Write-Host "  ✓ $($script.Name)" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $($script.Name) - NOT FOUND" -ForegroundColor Red
            $allValid = $false
        }
    }
    
    return $allValid
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   SYSTEM HEALTH OPTIMIZATION SUITE - UNIFIED       ║" -ForegroundColor Cyan
Write-Host "║   Integration Bridge v1.0                          ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Validate scripts
if (-not (Test-AllScripts)) {
    Write-Host ""
    Write-Host "✗ Missing required scripts. Please ensure all scripts are in:" -ForegroundColor Red
    Write-Host "  $scriptPath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Execution Mode: $Mode" -ForegroundColor Yellow
Write-Host "Dashboard: $(if($RunDashboard) {'Enabled'} else {'Disabled'})" -ForegroundColor Yellow
Write-Host "Email Alerts: $(if($SendEmail) {'Enabled'} else {'Disabled'})" -ForegroundColor Yellow
Write-Host "Enhanced Diagnostics: $(if($EnableEnhancements) {'Enabled'} else {'Disabled'})" -ForegroundColor Yellow
Write-Host ""

# ============================================================================
# SECTION 1: RUN HEALTH OPTIMIZATION
# ============================================================================

if ($Mode -in 'Full', 'Health') {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Phase 1: Running Health Optimization" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        & $mainScript
        $healthCheckComplete = $true
        Write-Host ""
        Write-Host "✓ Health optimization completed successfully" -ForegroundColor Green
    } catch {
        Write-Host ""
        Write-Host "✗ Health optimization failed: $_" -ForegroundColor Red
        $healthCheckComplete = $false
    }
} else {
    $healthCheckComplete = $true
}

# ============================================================================
# SECTION 2: RUN ENHANCED DIAGNOSTICS
# ============================================================================

if ($EnableEnhancements -and $Mode -in 'Full', 'Health') {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Phase 2: Running Enhanced Diagnostics" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        & $enhancedScript -EnableProcessAnalysis -EnableNetworkDiagnostics -EnableAntivirusCheck
        Write-Host ""
        Write-Host "✓ Enhanced diagnostics completed" -ForegroundColor Green
    } catch {
        Write-Host ""
        Write-Host "✗ Enhanced diagnostics failed: $_" -ForegroundColor Red
    }
}

# ============================================================================
# SECTION 3: SEND EMAIL ALERTS
# ============================================================================

if ($SendEmail -and $Mode -in 'Full', 'Email') {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Phase 3: Processing Email Alerts" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    
    if (Test-Path $emailConfigPath) {
        try {
            & $emailScript -SendAlert
            Write-Host ""
            Write-Host "✓ Email alerts processed" -ForegroundColor Green
        } catch {
            Write-Host ""
            Write-Host "✗ Email alert failed: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "⚠ Email configuration not found" -ForegroundColor Yellow
        Write-Host "  Run EMAIL_ALERT_SYSTEM.ps1 to configure SMTP settings first" -ForegroundColor Yellow
    }
}

# ============================================================================
# SECTION 4: GENERATE TRENDS DASHBOARD
# ============================================================================

if ($RunDashboard -or $Mode -eq 'Trends') {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Phase 4: Generating Trends Dashboard" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        & $dashboardScript
        Write-Host ""
        Write-Host "✓ Trends dashboard generated" -ForegroundColor Green
    } catch {
        Write-Host ""
        Write-Host "✗ Dashboard generation failed: $_" -ForegroundColor Red
    }
}

# ============================================================================
# COMPLETION SUMMARY
# ============================================================================

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   EXECUTION COMPLETE                               ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

$reportDir = Join-Path $scriptPath "Reports"
if (Test-Path $reportDir) {
    $reports = Get-ChildItem -Path $reportDir -Filter "*.html" | Sort-Object LastWriteTime -Descending | Select-Object -First 5
    if ($reports) {
        Write-Host "Recent Reports:" -ForegroundColor Yellow
        foreach ($report in $reports) {
            $time = $report.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
            Write-Host "  • $($report.Name) ($time)" -ForegroundColor White
        }
    }
}

Write-Host ""
Write-Host "Quick Links:" -ForegroundColor Cyan
Write-Host "  📊 Dashboard: $reportDir\HealthDashboard.html" -ForegroundColor Cyan
Write-Host "  📧 Configure Email: & .\EMAIL_ALERT_SYSTEM.ps1" -ForegroundColor Cyan
Write-Host "  📈 View Trends: Open latest HTML report in browser" -ForegroundColor Cyan
Write-Host "  ⚙️ Settings: Edit HealthOptimization.config.json" -ForegroundColor Cyan
Write-Host ""
