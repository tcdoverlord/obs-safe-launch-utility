# =========================================================
# OBS SAFE LAUNCH (STABLE + SAFE)
# Author: ONLYFOUNDONCE
# =========================================================

# -----------------------------
# PATHS
# -----------------------------

$pluginPath   = "C:\Program Files\obs-studio\obs-plugins\64bit"
$obsExe       = "C:\Program Files\obs-studio\bin\64bit\obs64.exe"
$obsbotExe    = "C:\Program Files\OBSBOT Center\OBSBOTCenter.exe"
$lovenseExe   = "C:\Program Files\Lovense\Lovense Connect\LovenseConnect.exe"

$baselineFile = "C:\Update Code\OBS-Plugin-Hashes.json"
$versionFile  = "C:\Update Code\OBS-Version.txt"
$logFile      = "C:\Update Code\OBS-Security.log"

# -----------------------------
# HEADER
# -----------------------------

Clear-Host
Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "OBS SAFE LAUNCH" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------
# LOGGING
# -----------------------------

function Log-Event($msg) {

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    "$timestamp - $msg" | Out-File `
        -Append `
        -Encoding utf8 `
        $logFile
}

# -----------------------------
# OBS VERSION
# -----------------------------

function Get-OBSVersion {

    return (Get-Item $obsExe).VersionInfo.FileVersion
}

# -----------------------------
# BUILD BASELINE
# -----------------------------

function Build-Baseline {

    Write-Host "Building plugin baseline..." -ForegroundColor Yellow

    Get-ChildItem $pluginPath -Filter *.dll | ForEach-Object {

        [PSCustomObject]@{
            Name = $_.Name
            Hash = (Get-FileHash $_.FullName -Algorithm SHA256).Hash
        }

    } | ConvertTo-Json | Out-File `
        -Encoding utf8 `
        $baselineFile

    Get-OBSVersion | Out-File `
        -Encoding utf8 `
        $versionFile

    Log-Event "Plugin baseline created"
}

# -----------------------------
# VALIDATION
# -----------------------------

if (!(Test-Path $obsExe)) {

    Write-Host "[ERROR] OBS executable missing" -ForegroundColor Red
    Pause
    exit
}

if (!(Test-Path $pluginPath)) {

    Write-Host "[ERROR] OBS plugin folder missing" -ForegroundColor Red
    Pause
    exit
}

# -----------------------------
# INITIALIZE BASELINE
# -----------------------------

if (!(Test-Path $baselineFile) -or !(Test-Path $versionFile)) {

    Write-Host "No baseline found." -ForegroundColor Yellow

    $choice = Read-Host "Type INIT to create baseline"

    if ($choice -eq "INIT") {

        Build-Baseline
    }
    else {

        exit
    }
}

# -----------------------------
# VERSION CHECK
# -----------------------------

$currentVersion = Get-OBSVersion
$storedVersion  = Get-Content $versionFile

if ($currentVersion -ne $storedVersion) {

    Write-Host ""
    Write-Host "[NOTICE] OBS version changed" -ForegroundColor Yellow
    Write-Host "Old Version: $storedVersion"
    Write-Host "New Version: $currentVersion"
    Write-Host ""

    $choice = Read-Host "Type UPDATE to rebuild plugin baseline"

    if ($choice -eq "UPDATE") {

        Build-Baseline
    }
}

# -----------------------------
# LOAD BASELINE
# -----------------------------

$baseline = Get-Content $baselineFile | ConvertFrom-Json

$currentPlugins = Get-ChildItem $pluginPath -Filter *.dll | ForEach-Object {

    [PSCustomObject]@{
        Name = $_.Name
        Hash = (Get-FileHash $_.FullName -Algorithm SHA256).Hash
    }
}

# -----------------------------
# PLUGIN CHECK
# -----------------------------

$issues = @()

foreach ($file in $currentPlugins) {

    $match = $baseline | Where-Object {
        $_.Name -eq $file.Name
    }

    if (!$match) {

        $issues += "NEW: $($file.Name)"
    }
    elseif ($match.Hash -ne $file.Hash) {

        $issues += "MODIFIED: $($file.Name)"
    }
}

foreach ($file in $baseline) {

    if (-not ($currentPlugins.Name -contains $file.Name)) {

        $issues += "MISSING: $($file.Name)"
    }
}

# -----------------------------
# ALERTS
# -----------------------------

if ($issues.Count -gt 0) {

    Write-Host ""
    Write-Host "[ALERT] Plugin differences detected" -ForegroundColor Red
    Write-Host ""

    $issues | ForEach-Object {

        Write-Host $_ -ForegroundColor Yellow
        Log-Event $_
    }

    Write-Host ""

    $choice = Read-Host "Type RUN to continue anyway"

    if ($choice -ne "RUN") {

        exit
    }
}

# -----------------------------
# CLEAN OLD RULES
# -----------------------------

$ruleNames = @(
    "OBS_ALLOW_TEMP",
    "LOVENSE_ALLOW_TEMP",
    "OBSBOT_BLOCK_IN"
)

foreach ($rule in $ruleNames) {

    Get-NetFirewallRule `
        -DisplayName $rule `
        -ErrorAction SilentlyContinue | Remove-NetFirewallRule
}

# -----------------------------
# FIREWALL SETUP
# -----------------------------

Write-Host ""
Write-Host "Applying temporary firewall rules..." -ForegroundColor Cyan

# OBS outbound allow

New-NetFirewallRule `
    -DisplayName "OBS_ALLOW_TEMP" `
    -Direction Outbound `
    -Program $obsExe `
    -Action Allow `
    -Profile Any | Out-Null

# Lovense outbound allow

if (Test-Path $lovenseExe) {

    New-NetFirewallRule `
        -DisplayName "LOVENSE_ALLOW_TEMP" `
        -Direction Outbound `
        -Program $lovenseExe `
        -Action Allow `
        -Profile Any | Out-Null

    Write-Host "Lovense rule applied." -ForegroundColor Green
}

# OBSBOT inbound block

if (Test-Path $obsbotExe) {

    New-NetFirewallRule `
        -DisplayName "OBSBOT_BLOCK_IN" `
        -Direction Inbound `
        -Program $obsbotExe `
        -Action Block `
        -Profile Any | Out-Null

    Write-Host "OBSBOT inbound blocked." -ForegroundColor Green
}

# -----------------------------
# LAUNCH OBS
# -----------------------------

Write-Host ""
Write-Host "Launching OBS..." -ForegroundColor Green

try {

    $process = Start-Process `
        -FilePath $obsExe `
        -WorkingDirectory (Split-Path $obsExe) `
        -Verb RunAs `
        -PassThru

    Log-Event "OBS launched"
}
catch {

    Write-Host ""
    Write-Host "[ERROR] Failed to launch OBS" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor DarkGray

    Log-Event "OBS failed to launch"

    Pause
    exit
}

# -----------------------------
# WAIT FOR OBS
# -----------------------------

Write-Host ""
Write-Host "OBS running..." -ForegroundColor Cyan

while (!$process.HasExited) {

    Start-Sleep -Seconds 3
}

# -----------------------------
# CLEANUP
# -----------------------------

Write-Host ""
Write-Host "Cleaning temporary firewall rules..." -ForegroundColor Yellow

Get-NetFirewallRule `
    -DisplayName "OBS_ALLOW_TEMP" `
    -ErrorAction SilentlyContinue | Remove-NetFirewallRule

Get-NetFirewallRule `
    -DisplayName "LOVENSE_ALLOW_TEMP" `
    -ErrorAction SilentlyContinue | Remove-NetFirewallRule

Get-NetFirewallRule `
    -DisplayName "OBSBOT_BLOCK_IN" `
    -ErrorAction SilentlyContinue | Remove-NetFirewallRule

# -----------------------------
# COMPLETE
# -----------------------------

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "[SECURED] OBS session completed safely." -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

Log-Event "OBS session closed safely"

Pause
