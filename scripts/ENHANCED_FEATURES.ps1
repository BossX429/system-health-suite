<#
.SYNOPSIS
    Enhanced Features Module for Health Optimization
.DESCRIPTION
    Adds advanced monitoring: process analysis, network diagnostics, event logging
.PARAMETER EnableProcessAnalysis
    Analyze top CPU/Memory consuming processes
.PARAMETER EnableNetworkDiagnostics
    Check network connectivity and DNS
.PARAMETER EnableEventLogging
    Log to Windows Event Viewer
.PARAMETER EnableAntivirus
    Check antivirus status
#>

param(
    [switch]$EnableProcessAnalysis,
    [switch]$EnableNetworkDiagnostics,
    [switch]$EnableEventLogging,
    [switch]$EnableAntivirusCheck
)

# ============================================================================
# SECTION 1: PROCESS ANALYSIS
# ============================================================================

function Get-ProcessHealth {
    Write-Host "Analyzing process health..." -ForegroundColor Cyan
    
    $processMetrics = @{
        TopCPUProcesses = @()
        TopMemoryProcesses = @()
        RogueProcesses = @()
        Analysis = ""
    }
    
    # Get top CPU consuming processes
    $topCPU = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
    foreach ($proc in $topCPU) {
        $processMetrics.TopCPUProcesses += @{
            Name = $proc.Name
            CPU = [math]::Round($proc.CPU, 2)
            Memory = [math]::Round($proc.WorkingSet / 1MB, 2)
            Handles = $proc.Handles
        }
    }
    
    # Get top memory consuming processes
    $topMemory = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5
    foreach ($proc in $topMemory) {
        $processMetrics.TopMemoryProcesses += @{
            Name = $proc.Name
            Memory = [math]::Round($proc.WorkingSet / 1MB, 2)
            CPU = [math]::Round($proc.CPU, 2)
            Threads = $proc.Threads.Count
        }
    }
    
    # Detect potentially problematic processes
    $allProcesses = Get-Process
    foreach ($proc in $allProcesses) {
        $memoryMB = [math]::Round($proc.WorkingSet / 1MB, 2)
        $cpuTime = [math]::Round($proc.CPU, 2)
        
        # Flag processes using excessive resources
        if ($memoryMB -gt 500 -or $cpuTime -gt 1000) {
            $processMetrics.RogueProcesses += @{
                Name = $proc.Name
                Memory = $memoryMB
                CPU = $cpuTime
                Status = "EXCESSIVE RESOURCES"
            }
        }
    }
    
    # Generate analysis
    if ($processMetrics.RogueProcesses.Count -gt 0) {
        $processMetrics.Analysis = "WARNING: $($processMetrics.RogueProcesses.Count) processes using excessive resources detected"
    } else {
        $processMetrics.Analysis = "Process health is normal"
    }
    
    return $processMetrics
}

# ============================================================================
# SECTION 2: NETWORK DIAGNOSTICS
# ============================================================================

function Test-NetworkDiagnostics {
    Write-Host "Running network diagnostics..." -ForegroundColor Cyan
    
    $networkMetrics = @{
        InternetConnectivity = $false
        DNSResolution = @()
        NetworkAdapters = @()
        Latency = 0
        Analysis = ""
    }
    
    # Test internet connectivity
    try {
        $ping = Test-Connection -ComputerName 8.8.8.8 -Count 1 -ErrorAction Stop
        $networkMetrics.InternetConnectivity = $true
        $networkMetrics.Latency = [math]::Round($ping.ResponseTime, 2)
    } catch {
        $networkMetrics.InternetConnectivity = $false
    }
    
    # Test DNS resolution
    try {
        $dns1 = Resolve-DnsName -Name "google.com" -ErrorAction Stop
        $networkMetrics.DNSResolution += @{ Domain = "google.com"; Status = "Resolved"; IP = $dns1.IPAddress }
    } catch {
        $networkMetrics.DNSResolution += @{ Domain = "google.com"; Status = "Failed"; IP = "N/A" }
    }
    
    # Get network adapter status
    $adapters = Get-NetAdapter | Where-Object Status -eq "Up"
    foreach ($adapter in $adapters) {
        $networkMetrics.NetworkAdapters += @{
            Name = $adapter.Name
            Status = $adapter.Status
            Speed = $adapter.LinkSpeed
        }
    }
    
    # Analysis
    $issues = @()
    if (-not $networkMetrics.InternetConnectivity) {
        $issues += "Internet connectivity issue detected"
    }
    if ($networkMetrics.NetworkAdapters.Count -eq 0) {
        $issues += "No active network adapters"
    }
    
    if ($issues.Count -gt 0) {
        $networkMetrics.Analysis = "ALERT: " + ($issues -join "; ")
    } else {
        $networkMetrics.Analysis = "Network health is normal"
    }
    
    return $networkMetrics
}

# ============================================================================
# SECTION 3: ANTIVIRUS CHECK
# ============================================================================

function Get-AntivirusStatus {
    Write-Host "Checking antivirus status..." -ForegroundColor Cyan
    
    $antivirusMetrics = @{
        ProductName = "Unknown"
        Status = "Unknown"
        LastUpdate = $null
        RealTimeProtection = $false
        Analysis = ""
    }
    
    try {
        $av = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct -ErrorAction Stop
        
        if ($av) {
            $antivirusMetrics.ProductName = $av.DisplayName
            
            # Check state: 0=off, 262144=on, 266240=on with updates
            $antivirusMetrics.Status = switch ($av.productState) {
                0 { "Off" }
                262144 { "On" }
                266240 { "On (Updated)" }
                default { "Unknown" }
            }
            
            $antivirusMetrics.RealTimeProtection = $av.productState -in 262144, 266240
        }
    } catch {
        $antivirusMetrics.Analysis = "Could not retrieve antivirus status"
    }
    
    # Generate analysis
    if ($antivirusMetrics.Status -eq "Off") {
        $antivirusMetrics.Analysis = "CRITICAL: Antivirus protection is disabled!"
    } elseif ($antivirusMetrics.RealTimeProtection) {
        $antivirusMetrics.Analysis = "Antivirus protection is active"
    } else {
        $antivirusMetrics.Analysis = "Antivirus status requires attention"
    }
    
    return $antivirusMetrics
}

# ============================================================================
# SECTION 4: EVENT LOGGING
# ============================================================================

function Add-HealthEvent {
    param(
        [string]$EventType,
        [string]$Message,
        [int]$EventID = 1000
    )
    
    Write-Host "Logging event to Windows Event Log..." -ForegroundColor Cyan
    
    $logName = "Application"
    $source = "SystemHealthOptimization"
    
    try {
        # Create event source if it doesn't exist
        if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
            [System.Diagnostics.EventLog]::CreateEventSource($source, $logName)
        }
        
        $eventLog = New-Object System.Diagnostics.EventLog
        $eventLog.Source = $source
        
        $eventType = switch ($EventType) {
            "Information" { [System.Diagnostics.EventLogEntryType]::Information }
            "Warning" { [System.Diagnostics.EventLogEntryType]::Warning }
            "Error" { [System.Diagnostics.EventLogEntryType]::Error }
            default { [System.Diagnostics.EventLogEntryType]::Information }
        }
        
        $eventLog.WriteEntry($Message, $eventType, $EventID)
        Write-Host "✓ Event logged successfully" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "✗ Failed to log event: $_" -ForegroundColor Red
        return $false
    }
}

# ============================================================================
# SECTION 5: CSV LOGGING FOR TRENDING
# ============================================================================

function Export-HealthMetricsToCSV {
    param(
        [hashtable]$HealthScore,
        [int]$CriticalIssues,
        [int]$Warnings,
        [string]$CsvPath = "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\Reports\HealthTrends.csv"
    )
    
    Write-Host "Exporting metrics to CSV..." -ForegroundColor Cyan
    
    # Create Reports directory if it doesn't exist
    $reportDir = Split-Path $CsvPath
    if (-not (Test-Path $reportDir)) {
        New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
    }
    
    $csvEntry = @{
        Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        ComputerName = $env:COMPUTERNAME
        OverallScore = $HealthScore.OverallScore
        Status = $HealthScore.Status
        CPUHealth = $HealthScore.ComponentScores.CPU
        MemoryHealth = $HealthScore.ComponentScores.Memory
        DiskHealth = $HealthScore.ComponentScores.Disk
        ServicesHealth = $HealthScore.ComponentScores.Services
        CriticalIssues = $CriticalIssues
        Warnings = $Warnings
    }
    
    try {
        $csvEntry | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $CsvPath -Force
        Write-Host "✓ Metrics exported to: $CsvPath" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "✗ Failed to export metrics: $_" -ForegroundColor Red
        return $false
    }
}

# ============================================================================
# GENERATE ENHANCED REPORT SECTION
# ============================================================================

function New-EnhancedReportHTML {
    param(
        [hashtable]$ProcessMetrics,
        [hashtable]$NetworkMetrics,
        [hashtable]$AntivirusMetrics
    )
    
    $html = @"
<h2>Advanced Diagnostics</h2>

<h3>Process Analysis</h3>
<div class="section">
    <p><strong>Analysis:</strong> $($ProcessMetrics.Analysis)</p>
    
    <h4>Top CPU Consuming Processes:</h4>
    <table>
        <tr><th>Process</th><th>CPU</th><th>Memory (MB)</th><th>Handles</th></tr>
"@
    
    foreach ($proc in $ProcessMetrics.TopCPUProcesses) {
        $html += "<tr><td>$($proc.Name)</td><td>$($proc.CPU)</td><td>$($proc.Memory)</td><td>$($proc.Handles)</td></tr>"
    }
    
    $html += @"
    </table>
    
    <h4>Top Memory Consuming Processes:</h4>
    <table>
        <tr><th>Process</th><th>Memory (MB)</th><th>CPU</th><th>Threads</th></tr>
"@
    
    foreach ($proc in $ProcessMetrics.TopMemoryProcesses) {
        $html += "<tr><td>$($proc.Name)</td><td>$($proc.Memory)</td><td>$($proc.CPU)</td><td>$($proc.Threads)</td></tr>"
    }
    
    $html += @"
    </table>
</div>

<h3>Network Diagnostics</h3>
<div class="section">
    <p><strong>Analysis:</strong> $($NetworkMetrics.Analysis)</p>
    <p>Internet Connectivity: $(if($NetworkMetrics.InternetConnectivity) {'✓ Connected'} else {'✗ Offline'})</p>
    <p>Latency: $($NetworkMetrics.Latency) ms</p>
    
    <h4>Network Adapters:</h4>
    <table>
        <tr><th>Adapter</th><th>Status</th><th>Speed</th></tr>
"@
    
    foreach ($adapter in $NetworkMetrics.NetworkAdapters) {
        $html += "<tr><td>$($adapter.Name)</td><td>$($adapter.Status)</td><td>$($adapter.Speed)</td></tr>"
    }
    
    $html += @"
    </table>
</div>

<h3>Antivirus Status</h3>
<div class="section">
    <p><strong>Product:</strong> $($AntivirusMetrics.ProductName)</p>
    <p><strong>Status:</strong> $($AntivirusMetrics.Status)</p>
    <p><strong>Real-time Protection:</strong> $(if($AntivirusMetrics.RealTimeProtection) {'✓ Enabled'} else {'✗ Disabled'})</p>
    <p><strong>Analysis:</strong> $($AntivirusMetrics.Analysis)</p>
</div>
"@
    
    return $html
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Write-Host ""
Write-Host "====== ENHANCED FEATURES MODULE ======" -ForegroundColor Cyan
Write-Host ""

$enhancements = @{
    ProcessAnalysis = $null
    NetworkDiagnostics = $null
    AntivirusStatus = $null
}

if ($EnableProcessAnalysis) {
    $enhancements.ProcessAnalysis = Get-ProcessHealth
}

if ($EnableNetworkDiagnostics) {
    $enhancements.NetworkDiagnostics = Test-NetworkDiagnostics
}

if ($EnableAntivirusCheck) {
    $enhancements.AntivirusStatus = Get-AntivirusStatus
}

Write-Host ""
Write-Host "====== ENHANCED FEATURES COMPLETE ======" -ForegroundColor Green
Write-Host ""

$enhancements
