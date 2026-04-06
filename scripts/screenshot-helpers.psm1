<#
.SYNOPSIS
    Shared screenshot capture helpers for workshop screenshot automation.

.DESCRIPTION
    Provides reusable functions for capturing CLI output (via Charm freeze)
    and web UI screenshots (via Playwright). Used by the domain-specific
    capture-screenshots.ps1 orchestrator.
#>

function Invoke-CharmFreeze {
    <#
    .SYNOPSIS
        Execute a CLI command and capture terminal output as a PNG using Charm freeze.

    .PARAMETER Command
        The PowerShell command to execute and capture.

    .PARAMETER OutputFile
        Path for the output PNG file.

    .PARAMETER WorkingDirectory
        Optional working directory for command execution.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Command,

        [Parameter(Mandatory)]
        [string]$OutputFile,

        [string]$WorkingDirectory
    )

    # Check if freeze is available
    $freezeCmd = Get-Command freeze -ErrorAction SilentlyContinue
    if (-not $freezeCmd) {
        Write-Warning "Charm 'freeze' not found. Install from https://github.com/charmbracelet/freeze"
        Write-Warning "Generating placeholder for $OutputFile"
        New-PlaceholderImage -OutputFile $OutputFile -Text $Command
        return
    }

    # Wrap commands in pwsh on Windows so PowerShell cmdlets work with freeze
    $execCmd = if ($WorkingDirectory) {
        "cd '$WorkingDirectory'; $Command"
    } else {
        $Command
    }

    if ($IsWindows) {
        $escapedCmd = $execCmd -replace '"', '\"'
        $execCmd = "pwsh -NoProfile -Command `"$escapedCmd`""
    }

    $cmdArgs = @("--execute", $execCmd)
    $cmdArgs += "--output"
    $cmdArgs += $OutputFile
    $cmdArgs += "--window"
    $cmdArgs += "--padding"
    $cmdArgs += "20"

    & freeze @cmdArgs
}

function Invoke-PlaywrightCapture {
    <#
    .SYNOPSIS
        Navigate to a URL and capture a screenshot using Playwright.

    .PARAMETER Url
        The URL to navigate to.

    .PARAMETER OutputFile
        Path for the output PNG file.

    .PARAMETER StorageState
        Optional Playwright storage state file for authenticated sessions.

    .PARAMETER Width
        Browser viewport width (default: 1280).

    .PARAMETER Height
        Browser viewport height (default: 720).
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Url,

        [Parameter(Mandatory)]
        [string]$OutputFile,

        [string]$StorageState,

        [int]$Width = 1280,

        [int]$Height = 720
    )

    $helperScript = Join-Path $PSScriptRoot "playwright-helpers.js"
    if (-not (Test-Path $helperScript)) {
        Write-Warning "playwright-helpers.js not found. Generating placeholder."
        New-PlaceholderImage -OutputFile $OutputFile -Text "Web: $Url"
        return
    }

    $nodeArgs = @($helperScript, "--url", $Url, "--output", $OutputFile, "--width", $Width, "--height", $Height)
    if ($StorageState) {
        $nodeArgs += "--storage-state"
        $nodeArgs += $StorageState
    }

    node @nodeArgs
}

function Test-ShouldCapture {
    <#
    .SYNOPSIS
        Determine if a screenshot entry should be captured based on filter criteria.

    .PARAMETER Entry
        The screenshot manifest entry object.

    .PARAMETER Lab
        Optional lab filter (e.g., "02", "06-ado").

    .PARAMETER Phase
        Optional phase filter (1-4).
    #>
    param(
        [Parameter(Mandatory)]
        [PSObject]$Entry,

        [string]$Lab,

        [int]$Phase
    )

    if ($Lab -and $Entry.lab -ne $Lab) {
        return $false
    }
    if ($Phase -gt 0 -and $Entry.phase -ne $Phase) {
        return $false
    }
    return $true
}

function New-LabDirectory {
    <#
    .SYNOPSIS
        Create a lab image directory with a README inventory file.

    .PARAMETER Path
        Path to the lab image directory.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "  Created directory: $Path" -ForegroundColor DarkGray
    }
}

function New-PlaceholderImage {
    <#
    .SYNOPSIS
        Create a placeholder text file when capture tools are not available.

    .PARAMETER OutputFile
        Path for the placeholder file.

    .PARAMETER Text
        Description text to include in the placeholder.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$OutputFile,

        [string]$Text = "Placeholder"
    )

    $placeholderPath = $OutputFile -replace '\.png$', '.placeholder.txt'
    "PLACEHOLDER: Screenshot not captured. Tool not available.`nCommand/URL: $Text" | Set-Content -Path $placeholderPath -Encoding UTF8
}

Export-ModuleMember -Function Invoke-CharmFreeze, Invoke-PlaywrightCapture, Test-ShouldCapture, New-LabDirectory, New-PlaceholderImage
