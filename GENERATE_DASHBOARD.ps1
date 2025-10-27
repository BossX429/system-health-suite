<#
.SYNOPSIS
    Health Trends Dashboard Generator
.DESCRIPTION
    Creates interactive HTML dashboard showing health score trends from CSV logs
.PARAMETER CsvPath
    Path to the health trends CSV file
.PARAMETER OutputPath
    Where to save the dashboard HTML file
.PARAMETER DaysToShow
    Number of days of historical data to display (default: 30)
#>

param(
    [string]$CsvPath = "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\Reports\HealthTrends.csv",
    [string]$OutputPath = "c:\Operation_Token_Discount_Archive\3_SCRIPTS_AND_SETUP\Reports\HealthDashboard.html",
    [int]$DaysToShow = 30
)

Write-Host "====== HEALTH TRENDS DASHBOARD GENERATOR ======" -ForegroundColor Cyan
Write-Host ""

# Create Reports directory if needed
$reportDir = Split-Path $OutputPath
if (-not (Test-Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
    Write-Host "✓ Created Reports directory" -ForegroundColor Green
}

# Read CSV data
if (-not (Test-Path $CsvPath)) {
    Write-Host "✗ CSV file not found: $CsvPath" -ForegroundColor Red
    Write-Host "Run APPLY_HEALTH_OPTIMIZATION.ps1 first to generate trend data" -ForegroundColor Yellow
    exit 1
}

$trendData = @()
try {
    $trendData = Import-Csv -Path $CsvPath
    Write-Host "✓ Loaded $($trendData.Count) records from CSV" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to read CSV: $_" -ForegroundColor Red
    exit 1
}

# Analyze trends
$avgScore = 0
$maxScore = 0
$minScore = 100
$trendDirection = "Stable"

if ($trendData.Count -gt 0) {
    $scores = $trendData.OverallScore -as [float[]]
    $avgScore = [math]::Round(($scores | Measure-Object -Average).Average, 2)
    $maxScore = [math]::Round(($scores | Measure-Object -Maximum).Maximum, 2)
    $minScore = [math]::Round(($scores | Measure-Object -Minimum).Minimum, 2)
    
    # Determine trend
    if ($scores.Count -ge 2) {
        $first = [float]$scores[0]
        $last = [float]$scores[-1]
        $change = $last - $first
        
        if ($change -gt 2) { $trendDirection = "Improving ↑" }
        elseif ($change -lt -2) { $trendDirection = "Declining ↓" }
        else { $trendDirection = "Stable →" }
    }
}

# Build chart data (JSON format for JavaScript)
$chartData = @()
foreach ($record in $trendData) {
    $chartData += @{
        timestamp = $record.Timestamp
        score = [float]$record.OverallScore
        cpu = [float]$record.CPUHealth
        memory = [float]$record.MemoryHealth
        disk = [float]$record.DiskHealth
        services = [float]$record.ServicesHealth
    }
}

$chartJson = $chartData | ConvertTo-Json

# Generate HTML Dashboard
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Health Trends Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .header {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        
        .header h1 {
            color: #667eea;
            margin-bottom: 10px;
            font-size: 2.5em;
        }
        
        .header p {
            color: #666;
            font-size: 0.95em;
        }
        
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .metric-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-left: 4px solid #667eea;
        }
        
        .metric-card h3 {
            font-size: 0.9em;
            color: #999;
            text-transform: uppercase;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }
        
        .metric-value {
            font-size: 2.2em;
            font-weight: bold;
            color: #667eea;
        }
        
        .metric-sub {
            font-size: 0.85em;
            color: #999;
            margin-top: 5px;
        }
        
        .trend-improving {
            color: #10b981;
        }
        
        .trend-declining {
            color: #ef4444;
        }
        
        .trend-stable {
            color: #f59e0b;
        }
        
        .chart-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            position: relative;
            height: 400px;
        }
        
        .chart-container h2 {
            margin-bottom: 15px;
            color: #333;
            font-size: 1.3em;
        }
        
        .chart-wrapper {
            position: relative;
            height: 350px;
        }
        
        .component-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }
        
        .component-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .component-card h3 {
            margin-bottom: 15px;
            color: #333;
        }
        
        .component-chart {
            position: relative;
            height: 200px;
        }
        
        .footer {
            background: white;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            color: #999;
            font-size: 0.9em;
            margin-top: 20px;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 1.8em;
            }
            
            .metrics-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 System Health Trends Dashboard</h1>
            <p>Last Updated: $timestamp</p>
        </div>
        
        <div class="metrics-grid">
            <div class="metric-card">
                <h3>Average Health Score</h3>
                <div class="metric-value">$avgScore</div>
                <div class="metric-sub">out of 100</div>
            </div>
            
            <div class="metric-card">
                <h3>Peak Score</h3>
                <div class="metric-value" style="color: #10b981;">$maxScore</div>
                <div class="metric-sub">Best recorded</div>
            </div>
            
            <div class="metric-card">
                <h3>Lowest Score</h3>
                <div class="metric-value" style="color: #ef4444;">$minScore</div>
                <div class="metric-sub">Worst recorded</div>
            </div>
            
            <div class="metric-card">
                <h3>Trend</h3>
                <div class="metric-value trend-$(($trendDirection -replace ' ↑|↓|→' | ForEach-Object {if ($_ -eq 'Improving') {'improving'} elseif ($_ -eq 'Declining') {'declining'} else {'stable'}}))" style="font-size: 1.8em;">$trendDirection</div>
                <div class="metric-sub">Overall direction</div>
            </div>
        </div>
        
        <div class="chart-container">
            <h2>Health Score Over Time</h2>
            <div class="chart-wrapper">
                <canvas id="scoreChart"></canvas>
            </div>
        </div>
        
        <div class="component-grid">
            <div class="component-card">
                <h3>CPU Health</h3>
                <div class="component-chart">
                    <canvas id="cpuChart"></canvas>
                </div>
            </div>
            
            <div class="component-card">
                <h3>Memory Health</h3>
                <div class="component-chart">
                    <canvas id="memoryChart"></canvas>
                </div>
            </div>
            
            <div class="component-card">
                <h3>Disk Health</h3>
                <div class="component-chart">
                    <canvas id="diskChart"></canvas>
                </div>
            </div>
            
            <div class="component-card">
                <h3>Services Health</h3>
                <div class="component-chart">
                    <canvas id="servicesChart"></canvas>
                </div>
            </div>
        </div>
        
        <div class="footer">
            <p>System Health Optimization Suite • Generated: $timestamp</p>
        </div>
    </div>
    
    <script>
        const trendData = $chartJson;
        
        // Prepare labels
        const labels = trendData.map(d => new Date(d.timestamp).toLocaleString());
        const scores = trendData.map(d => d.score);
        const cpuData = trendData.map(d => d.cpu);
        const memoryData = trendData.map(d => d.memory);
        const diskData = trendData.map(d => d.disk);
        const servicesData = trendData.map(d => d.services);
        
        // Common chart options
        const commonOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 100,
                    ticks: {
                        color: '#999'
                    },
                    grid: {
                        color: 'rgba(0, 0, 0, 0.05)'
                    }
                },
                x: {
                    ticks: {
                        color: '#999',
                        maxTicksLimit: 6
                    },
                    grid: {
                        display: false
                    }
                }
            }
        };
        
        // Overall Score Chart
        new Chart(document.getElementById('scoreChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Overall Score',
                    data: scores,
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#667eea',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 5
                }]
            },
            options: commonOptions
        });
        
        // CPU Chart
        new Chart(document.getElementById('cpuChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'CPU Health',
                    data: cpuData,
                    borderColor: '#f59e0b',
                    backgroundColor: 'rgba(245, 158, 11, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 3
                }]
            },
            options: commonOptions
        });
        
        // Memory Chart
        new Chart(document.getElementById('memoryChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Memory Health',
                    data: memoryData,
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 3
                }]
            },
            options: commonOptions
        });
        
        // Disk Chart
        new Chart(document.getElementById('diskChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Disk Health',
                    data: diskData,
                    borderColor: '#ef4444',
                    backgroundColor: 'rgba(239, 68, 68, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 3
                }]
            },
            options: commonOptions
        });
        
        // Services Chart
        new Chart(document.getElementById('servicesChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Services Health',
                    data: servicesData,
                    borderColor: '#8b5cf6',
                    backgroundColor: 'rgba(139, 92, 246, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 3
                }]
            },
            options: commonOptions
        });
    </script>
</body>
</html>
"@

# Save dashboard
try {
    $html | Out-File -FilePath $OutputPath -Force -Encoding UTF8
    Write-Host "✓ Dashboard generated successfully" -ForegroundColor Green
    Write-Host "  Location: $OutputPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Analytics Summary:" -ForegroundColor Yellow
    Write-Host "  - Average Score: $avgScore/100" -ForegroundColor White
    Write-Host "  - Best Score: $maxScore/100" -ForegroundColor White
    Write-Host "  - Lowest Score: $minScore/100" -ForegroundColor White
    Write-Host "  - Trend: $trendDirection" -ForegroundColor White
    Write-Host "  - Records: $($trendData.Count)" -ForegroundColor White
} catch {
    Write-Host "✗ Failed to save dashboard: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "====== DASHBOARD GENERATION COMPLETE ======" -ForegroundColor Green
