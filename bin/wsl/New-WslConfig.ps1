#Requires -Version 5.1
<#
.SYNOPSIS
  Creates or updates the .wslconfig file for WSL2 in the current user's profile.
.DESCRIPTION
  This script interactively prompts for memory and processor allocation for WSL2
  and writes these settings to the .wslconfig file located at %USERPROFILE%\.wslconfig.
  It provides suggestions for default values and warns the user to restart WSL
  for changes to take effect.
.EXAMPLE
  .\New-WslConfig.ps1
  Follow the prompts to configure memory and processors.
#>

$wslConfigPath = Join-Path $env:USERPROFILE ".wslconfig"

# --- Determine Default Configuration Values ---
$defaultMemory = "8GB"
$totalLogicalProcessors = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
# Suggest half of the system's logical processors, with a minimum of 1
$suggestedProcessors = [Math]::Max(1, [Math]::Floor($totalLogicalProcessors / 2))
$defaultProcessors = $suggestedProcessors.ToString()
$windowsUserName = $env:USERNAME

Write-Host "--- WSL2 Configuration Script ---" -ForegroundColor Magenta
Write-Host "This script will configure .wslconfig for the current Windows user: '$($windowsUserName)'." -ForegroundColor Green
Write-Host "The configuration file will be created/updated at: $wslConfigPath" -ForegroundColor Cyan
Write-Host "--------------------------------------------------"

# --- Get Memory Allocation ---
$memoryInput = Read-Host "Enter memory to allocate to WSL2 (e.g., 4GB, 8GB, 16GB). Press Enter for default ($($defaultMemory))"
if ([string]::IsNullOrWhiteSpace($memoryInput)) {
    $memoryInput = $defaultMemory
}
if (-not ($memoryInput -match "^\d+(GB|MB)$")) {
    Write-Warning "Invalid memory format. Using default: $defaultMemory"
    $memoryInput = $defaultMemory
}

# --- Get Processor Allocation ---
$processorsInput = Read-Host "Enter number of processors to allocate to WSL2 (e.g., 2, 4, $($defaultProcessors)). Press Enter for default ($($defaultProcessors))"
if ([string]::IsNullOrWhiteSpace($processorsInput)) {
    $processorsInput = $defaultProcessors
}
if (-not ($processorsInput -match "^\d+$") -or ([int]$processorsInput -lt 1) -or ([int]$processorsInput -gt $totalLogicalProcessors)) {
    Write-Warning "Invalid processor count (must be a number between 1 and $totalLogicalProcessors). Using default: $defaultProcessors"
    $processorsInput = $defaultProcessors
}

# --- Construct .wslconfig Content ---
$wslConfigContent = @"
[wsl2]
memory=$memoryInput
processors=$processorsInput
# For more advanced options, you can uncomment and modify the lines below:
# swap=0                 # How much swap space to add to WSL2 (0 for no swap file). Default is 25% of memory size in Windows.
# swapFile=C:\\temp\\wsl-swap.vhdx # Optional: Specify the path to the swap vhd
# localhostForwarding=true # Boolean to enable/disable localhost forwarding
# pageReporting=true     # Boolean to enable/disable page reporting
# guiApplications=true   # Enable or disable GUI applications (WSLg)
# debugConsole=false     # Enable a debug console window for WSLg
# nestedVirtualization=true # Enable nested virtualization
# vmIdleTimeout=60000    # Milliseconds to wait before an idle VM is shut down
"@

# --- Write File ---
$fileExists = Test-Path $wslConfigPath
$shouldWrite = $true

if ($fileExists) {
    Write-Warning "File '$wslConfigPath' already exists."
    $overwrite = Read-Host "Do you want to overwrite it with the new settings? (y/N)"
    if ($overwrite.ToLower() -ne 'y') {
        $shouldWrite = $false
        Write-Host "Operation cancelled. No changes made to .wslconfig."
    }
}

if ($shouldWrite) {
    try {
        Set-Content -Path $wslConfigPath -Value $wslConfigContent -Encoding UTF8 -ErrorAction Stop
        Write-Host "`nSuccessfully wrote .wslconfig file:" -ForegroundColor Green
        Write-Host $wslConfigContent
        Write-Host "`nIMPORTANT: For these changes to take effect, you MUST shut down WSL." -ForegroundColor Yellow
        Write-Host "Run 'wsl --shutdown' in PowerShell or Command Prompt, then restart your WSL distribution." -ForegroundColor Yellow
    } catch {
        Write-Error "Failed to write .wslconfig file: $($_.Exception.Message)"
    }
}
