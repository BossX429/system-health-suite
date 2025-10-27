<#
.SYNOPSIS
    Email Alert System for Health Optimization
.DESCRIPTION
    Sends professional email notifications for critical issues and weekly summaries
.PARAMETER EmailConfig
    Path to email configuration file or hashtable with settings
.PARAMETER TestEmail
    Send a test email to verify configuration
.PARAMETER SendReport
    Email address to send the report to
#>

param(
    [hashtable]$EmailConfig = @{
        SMTPServer = "smtp.gmail.com"
        SMTPPort = 587
        FromEmail = "your-email@gmail.com"
        FromPassword = $null
        ToEmail = "admin@company.com"
        UseSSL = $true
    },
    
    [switch]$TestEmail = $false,
    [string]$SendReport = $null,
    [string]$ReportPath = $null,
    [hashtable]$HealthScore = $null,
    [array]$CriticalIssues = @(),
    [array]$Warnings = @()
)

# ============================================================================
# EMAIL CONFIGURATION
# ============================================================================

function Initialize-EmailConfig {
    param([string]$ConfigPath = "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\email.config.json")
    
    if (Test-Path $ConfigPath) {
        try {
            $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
            return @{
                SMTPServer = $config.SMTPServer
                SMTPPort = $config.SMTPPort
                FromEmail = $config.FromEmail
                ToEmail = $config.ToEmail
                UseSSL = $config.UseSSL
                EnableNotifications = $config.EnableNotifications
            }
        } catch {
            Write-Host "Error reading config: $_" -ForegroundColor Red
            return $null
        }
    }
    return $null
}

# ============================================================================
# EMAIL TEMPLATES
# ============================================================================

function Get-CriticalAlertEmail {
    param(
        [string]$ComputerName,
        [array]$Issues,
        [hashtable]$HealthScore,
        [string]$ReportUrl
    )
    
    $issueList = ""
    foreach ($issue in $Issues) {
        $issueList += @"
<tr style="background-color: #fff3cd;">
    <td style="padding: 8px; border: 1px solid #ddd;">$($issue.Issue)</td>
    <td style="padding: 8px; border: 1px solid #ddd;">$($issue.Severity)</td>
    <td style="padding: 8px; border: 1px solid #ddd;">$($issue.Impact)</td>
    <td style="padding: 8px; border: 1px solid #ddd;">$($issue.Resolution)</td>
</tr>
"@
    }
    
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>System Health Alert - $ComputerName</title>
    <style>
        body { font-family: Arial, sans-serif; color: #333; }
        .header { background: #F44336; color: white; padding: 20px; text-align: center; border-radius: 4px; }
        .content { padding: 20px; background: #f9f9f9; }
        .score { font-size: 2em; font-weight: bold; color: #F44336; margin: 10px 0; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th { background: #f0f0f0; padding: 10px; text-align: left; border: 1px solid #ddd; font-weight: bold; }
        td { padding: 10px; border: 1px solid #ddd; }
        .footer { text-align: center; padding: 20px; color: #666; font-size: 0.9em; }
        .button { background: #F44336; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; display: inline-block; }
        .warning { background-color: #fff3cd; color: #856404; padding: 10px; border-left: 4px solid #ffc107; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>⚠️ SYSTEM HEALTH ALERT</h1>
    </div>
    
    <div class="content">
        <p>System: <strong>$ComputerName</strong></p>
        <p>Timestamp: <strong>$(Get-Date -Format 'MMMM dd, yyyy HH:mm:ss')</strong></p>
        
        <h2>Health Status</h2>
        <div class="score">Score: $($HealthScore.OverallScore)/100</div>
        <p>Status: <strong>$($HealthScore.Status)</strong></p>
        
        <h2>Critical Issues Detected: $($Issues.Count)</h2>
        <table>
            <tr>
                <th>Issue</th>
                <th>Severity</th>
                <th>Impact</th>
                <th>Resolution</th>
            </tr>
            $issueList
        </table>
        
        <div class="warning">
            <strong>Action Required:</strong> Please review the detailed report and take appropriate action.
        </div>
        
        <p style="text-align: center;">
            <a href="$ReportUrl" class="button">View Full Report</a>
        </p>
    </div>
    
    <div class="footer">
        <p>System Health Optimization Suite v1.0</p>
        <p>This is an automated alert. Do not reply to this email.</p>
    </div>
</body>
</html>
"@
    return $html
}

function Get-SummaryEmail {
    param(
        [string]$ComputerName,
        [hashtable]$HealthScore,
        [int]$CriticalCount,
        [int]$WarningCount,
        [string]$ReportUrl
    )
    
    $statusColor = switch ($HealthScore.Status) {
        "Excellent" { "#4CAF50" }
        "Good" { "#8BC34A" }
        "Fair" { "#FFC107" }
        "Poor" { "#FF9800" }
        "Critical" { "#F44336" }
        default { "#757575" }
    }
    
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Weekly Health Summary - $ComputerName</title>
    <style>
        body { font-family: Arial, sans-serif; color: #333; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; text-align: center; border-radius: 4px; }
        .content { padding: 20px; background: #f9f9f9; }
        .score-card { background: $statusColor; color: white; padding: 20px; text-align: center; border-radius: 4px; margin: 15px 0; }
        .score-value { font-size: 2.5em; font-weight: bold; }
        .metrics { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin: 20px 0; }
        .metric-box { background: white; padding: 15px; border-radius: 4px; border-left: 4px solid #667eea; }
        .metric-label { font-weight: bold; color: #667eea; }
        .metric-value { font-size: 1.5em; font-weight: bold; margin-top: 5px; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f0f0f0; font-weight: bold; }
        .footer { text-align: center; padding: 20px; color: #666; font-size: 0.9em; }
        .button { background: #667eea; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; display: inline-block; margin: 10px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>📊 Weekly System Health Summary</h1>
    </div>
    
    <div class="content">
        <p>System: <strong>$ComputerName</strong></p>
        <p>Report Period: <strong>This Week</strong></p>
        <p>Generated: <strong>$(Get-Date -Format 'MMMM dd, yyyy HH:mm:ss')</strong></p>
        
        <div class="score-card">
            <div>Overall Health Status</div>
            <div class="score-value">$($HealthScore.OverallScore)</div>
            <div>$($HealthScore.Status)</div>
        </div>
        
        <h2>Key Metrics</h2>
        <div class="metrics">
            <div class="metric-box">
                <div class="metric-label">Critical Issues</div>
                <div class="metric-value">$CriticalCount</div>
            </div>
            <div class="metric-box">
                <div class="metric-label">Warnings</div>
                <div class="metric-value">$WarningCount</div>
            </div>
            <div class="metric-box">
                <div class="metric-label">CPU Health</div>
                <div class="metric-value">$([math]::Round($HealthScore.ComponentScores.CPU, 1))/25</div>
            </div>
            <div class="metric-box">
                <div class="metric-label">Memory Health</div>
                <div class="metric-value">$([math]::Round($HealthScore.ComponentScores.Memory, 1))/25</div>
            </div>
            <div class="metric-box">
                <div class="metric-label">Disk Health</div>
                <div class="metric-value">$([math]::Round($HealthScore.ComponentScores.Disk, 1))/25</div>
            </div>
            <div class="metric-box">
                <div class="metric-label">Services Health</div>
                <div class="metric-value">$([math]::Round($HealthScore.ComponentScores.Services, 1))/25</div>
            </div>
        </div>
        
        <h2>Recommendations</h2>
        <ul>
            <li>Review the detailed health report</li>
            <li>Address any critical issues immediately</li>
            <li>Monitor warning signs closely</li>
            <li>Schedule maintenance during off-peak hours</li>
        </ul>
        
        <p style="text-align: center;">
            <a href="$ReportUrl" class="button">📈 View Detailed Report</a>
            <a href="$ReportUrl" class="button">🔧 View Recommendations</a>
        </p>
    </div>
    
    <div class="footer">
        <p>System Health Optimization Suite v1.0</p>
        <p>Next report: Next week at this time</p>
        <p>This is an automated summary. Do not reply to this email.</p>
    </div>
</body>
</html>
"@
    return $html
}

# ============================================================================
# SEND EMAIL
# ============================================================================

function Send-HealthAlert {
    param(
        [string]$ToEmail,
        [string]$Subject,
        [string]$HtmlBody,
        [hashtable]$Config
    )
    
    Write-Host "Preparing to send email alert..." -ForegroundColor Cyan
    
    try {
        $credential = New-Object System.Management.Automation.PSCredential(
            $Config.FromEmail,
            (ConvertTo-SecureString $Config.FromPassword -AsPlainText -Force)
        )
        
        $mailParams = @{
            SmtpServer = $Config.SMTPServer
            Port = $Config.SMTPPort
            UseSsl = $Config.UseSSL
            Credential = $credential
            From = $Config.FromEmail
            To = $ToEmail
            Subject = $Subject
            Body = $HtmlBody
            BodyAsHtml = $true
        }
        
        Send-MailMessage @mailParams
        Write-Host "✓ Email sent successfully to: $ToEmail" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "✗ Failed to send email: $_" -ForegroundColor Red
        return $false
    }
}

# ============================================================================
# TEST EMAIL
# ============================================================================

function Send-TestEmail {
    param([hashtable]$Config)
    
    Write-Host ""
    Write-Host "====== SENDING TEST EMAIL ======" -ForegroundColor Cyan
    Write-Host ""
    
    if (-not $Config.FromPassword) {
        $Config.FromPassword = Read-Host -Prompt "Enter email password" -AsSecureString | ConvertFrom-SecureString -AsPlainText
    }
    
    $testHtml = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Email - System Health Alerts</title>
    <style>
        body { font-family: Arial, sans-serif; color: #333; }
        .header { background: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 4px; }
        .content { padding: 20px; background: #f9f9f9; }
        .footer { text-align: center; padding: 20px; color: #666; }
    </style>
</head>
<body>
    <div class="header">
        <h1>✓ Test Email Successful!</h1>
    </div>
    
    <div class="content">
        <p>This is a test email from the System Health Optimization Suite.</p>
        <p>If you received this email, your SMTP configuration is working correctly.</p>
        
        <h3>Configuration Details:</h3>
        <ul>
            <li>From: $($Config.FromEmail)</li>
            <li>SMTP Server: $($Config.SMTPServer)</li>
            <li>Port: $($Config.SMTPPort)</li>
            <li>SSL/TLS: $($Config.UseSSL)</li>
        </ul>
        
        <p><strong>Status:</strong> Email system is operational!</p>
    </div>
    
    <div class="footer">
        <p>System Health Optimization Suite v1.0</p>
    </div>
</body>
</html>
"@
    
    $result = Send-HealthAlert -ToEmail $Config.ToEmail -Subject "Test Email - System Health Alerts" -HtmlBody $testHtml -Config $Config
    
    if ($result) {
        Write-Host "Test completed successfully!" -ForegroundColor Green
        Write-Host "Check your inbox at: $($Config.ToEmail)" -ForegroundColor Cyan
    } else {
        Write-Host "Test failed. Please verify your configuration." -ForegroundColor Red
    }
}

# ============================================================================
# GENERATE EMAIL CONFIGURATION
# ============================================================================

function Initialize-EmailConfiguration {
    $configPath = "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\email.config.json"
    
    Write-Host ""
    Write-Host "====== EMAIL CONFIGURATION SETUP ======" -ForegroundColor Cyan
    Write-Host ""
    
    $config = @{
        SMTPServer = Read-Host "Enter SMTP Server (e.g., smtp.gmail.com)"
        SMTPPort = Read-Host "Enter SMTP Port (e.g., 587)"
        FromEmail = Read-Host "Enter sender email address"
        ToEmail = Read-Host "Enter recipient email address"
        UseSSL = Read-Host "Use SSL/TLS? (yes/no)"
        EnableNotifications = Read-Host "Enable notifications? (yes/no)"
    }
    
    $config.UseSSL = $config.UseSSL -eq "yes"
    $config.EnableNotifications = $config.EnableNotifications -eq "yes"
    
    try {
        $config | ConvertTo-Json | Out-File -FilePath $configPath -Encoding UTF8 -Force
        Write-Host "✓ Configuration saved to: $configPath" -ForegroundColor Green
        return $config
    } catch {
        Write-Host "✗ Failed to save configuration: $_" -ForegroundColor Red
        return $null
    }
}

# ============================================================================
# MAIN
# ============================================================================

if ($TestEmail) {
    Initialize-EmailConfiguration
    Send-TestEmail -Config $EmailConfig
    exit 0
}

# Send report via email
if ($SendReport -and $ReportPath -and $HealthScore) {
    if ($CriticalIssues.Count -gt 0) {
        Write-Host "Sending critical alert email..." -ForegroundColor Yellow
        $subject = "CRITICAL: System Health Alert - $env:COMPUTERNAME"
        $body = Get-CriticalAlertEmail -ComputerName $env:COMPUTERNAME -Issues $CriticalIssues -HealthScore $HealthScore -ReportUrl $ReportPath
        Send-HealthAlert -ToEmail $SendReport -Subject $subject -HtmlBody $body -Config $EmailConfig
    } else {
        Write-Host "Sending summary email..." -ForegroundColor Cyan
        $subject = "Weekly System Health Summary - $env:COMPUTERNAME"
        $body = Get-SummaryEmail -ComputerName $env:COMPUTERNAME -HealthScore $HealthScore -CriticalCount $CriticalIssues.Count -WarningCount $Warnings.Count -ReportUrl $ReportPath
        Send-HealthAlert -ToEmail $SendReport -Subject $subject -HtmlBody $body -Config $EmailConfig
    }
    exit 0
}

Write-Host "Email Alert System initialized successfully!" -ForegroundColor Green
