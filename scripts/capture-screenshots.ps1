<#
.SYNOPSIS
    Captures screenshots for the Code Quality Scan Workshop.

.DESCRIPTION
    Domain-specific orchestrator that reads the screenshot manifest,
    filters by lab/phase, and invokes the appropriate capture method
    (Charm freeze for CLI, Playwright for web UI).

.PARAMETER Lab
    Filter to capture screenshots for a specific lab (e.g., "02", "06-ado").
    If not specified, captures all screenshots.

.PARAMETER Phase
    Filter by capture phase (1-4). Phase 1 = offline, Phase 2 = app-dependent,
    Phase 3 = GitHub UI, Phase 4 = ADO UI.

.PARAMETER DemoAppDir
    Path to the sibling code-quality-scan-demo-app directory.
    Defaults to "../code-quality-scan-demo-app".

.PARAMETER Force
    Overwrite existing screenshots.

.EXAMPLE
    .\capture-screenshots.ps1 -Lab "02" -Phase 1
    .\capture-screenshots.ps1 -Phase 3 -Force
    .\capture-screenshots.ps1
#>

param(
    [string]$Lab,
    [int]$Phase,
    [string]$DemoAppDir = "../code-quality-scan-demo-app",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Import shared helpers
Import-Module "$PSScriptRoot/screenshot-helpers.psm1" -Force

# Ensure PATH includes Python Scripts for pip-installed tools
if ($IsWindows) {
    # Try standard installer location first, then Microsoft Store location
    $pythonScripts = @(
        (Join-Path $env:USERPROFILE "AppData\Local\Programs\Python\Python*\Scripts"),
        (Join-Path $env:USERPROFILE "AppData\Local\Packages\PythonSoftwareFoundation.Python.*\LocalCache\local-packages\Python*\Scripts")
    ) | ForEach-Object { Resolve-Path $_ -ErrorAction SilentlyContinue } | Select-Object -First 1
    if ($pythonScripts) {
        $env:PATH = "$($pythonScripts.Path);$env:PATH"
    }
}

# Load manifest
$manifestPath = Join-Path $PSScriptRoot "screenshot-manifest.json"
if (-not (Test-Path $manifestPath)) {
    Write-Error "Screenshot manifest not found at $manifestPath"
    return
}

$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
$screenshots = $manifest.screenshots

# Resolve demo app directory
$resolvedDemoApp = Resolve-Path $DemoAppDir -ErrorAction SilentlyContinue
if (-not $resolvedDemoApp) {
    Write-Warning "Demo app directory not found at $DemoAppDir. Screenshots requiring workingDir='demo-app' will be skipped."
}

# Filter screenshots
$filtered = $screenshots | Where-Object {
    Test-ShouldCapture -Entry $_ -Lab $Lab -Phase $Phase
}

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Code Quality Scan Workshop — Screenshot Capture" -ForegroundColor Cyan
Write-Host " Manifest: $manifestPath" -ForegroundColor Cyan
Write-Host " Total screenshots: $($screenshots.Count)" -ForegroundColor Cyan
Write-Host " Filtered to capture: $($filtered.Count)" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

$captured = 0
$skipped = 0
$failed = 0

foreach ($entry in $filtered) {
    $labDir = "lab-$($entry.lab)"
    $outputDir = Join-Path $PSScriptRoot "..\images\$labDir"
    $outputFile = Join-Path $outputDir "$($entry.name).png"

    # Create directory if needed
    New-LabDirectory -Path $outputDir

    # Skip if file exists and not forcing
    if ((Test-Path $outputFile) -and (-not $Force)) {
        Write-Host "  SKIP $($entry.name) (exists, use -Force to overwrite)" -ForegroundColor Yellow
        $skipped++
        continue
    }

    # Resolve working directory
    $workDir = $null
    if ($entry.workingDir -eq "demo-app" -and $resolvedDemoApp) {
        $workDir = $resolvedDemoApp.Path
    } elseif ($entry.workingDir -like "demo-app/*" -and $resolvedDemoApp) {
        $subDir = $entry.workingDir.Substring(9)  # Remove "demo-app/" prefix
        $workDir = Join-Path $resolvedDemoApp.Path $subDir
    }

    try {
        switch ($entry.method) {
            "freeze-execute" {
                Write-Host "  CAPTURE $($entry.name) [freeze-execute]" -ForegroundColor Green
                Invoke-CharmFreeze -Command $entry.command -OutputFile $outputFile -WorkingDirectory $workDir
            }
            "playwright-navigate" {
                Write-Host "  CAPTURE $($entry.name) [playwright-navigate]" -ForegroundColor Green
                Invoke-PlaywrightCapture -Url $entry.url -OutputFile $outputFile
            }
            "playwright-auth" {
                Write-Host "  CAPTURE $($entry.name) [playwright-auth]" -ForegroundColor Green
                Invoke-PlaywrightCapture -Url $entry.url -OutputFile $outputFile -StorageState $entry.storageState
            }
            "script" {
                Write-Host "  CAPTURE $($entry.name) [script]" -ForegroundColor Green
                & $entry.script -OutputFile $outputFile
            }
            default {
                Write-Warning "  Unknown method '$($entry.method)' for $($entry.name)"
                $failed++
                continue
            }
        }
        $captured++
    }
    catch {
        Write-Warning "  FAILED $($entry.name): $_"
        $failed++
    }
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Results: $captured captured, $skipped skipped, $failed failed" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
