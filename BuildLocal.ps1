[CmdletBinding()]
param(
    [string]$OutputDirectory = (Join-Path $PSScriptRoot 'build')
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command ps2exe -ErrorAction SilentlyContinue)) {
    throw "The ps2exe command is not available. Install it with: Install-Module -Name ps2exe -Scope CurrentUser"
}

$packageDirectory = Join-Path $OutputDirectory 'windowsinstaller'
$zipPath = Join-Path $OutputDirectory 'WindowsInstaller.zip'

if (Test-Path -LiteralPath $OutputDirectory) {
    Remove-Item -LiteralPath $OutputDirectory -Recurse -Force
}

New-Item -ItemType Directory -Path $packageDirectory -Force | Out-Null

& ps2exe `
    -InputFile (Join-Path $PSScriptRoot 'MylesMattlockWinTool.ps1') `
    -OutputFile (Join-Path $packageDirectory 'MylesMattlockWinTool.exe') `
    -IconFile (Join-Path $PSScriptRoot 'MM.ico') `
    -version '1.0.0' `
    -requireAdmin

$excludedFiles = @(
    'BuildLocal.ps1',
    'Installer.ps1',
    'MylesMattlockWinTool.ps1',
    'README.md',
    'UpdatePolicy.ps1',
    'elevate.manifest.xml',
    'set-execution-policy.reg',
    'ToDo',
    'MM.ico'
)

Get-ChildItem -LiteralPath $PSScriptRoot -Force |
    Where-Object { $_.Name -notin $excludedFiles -and $_.Name -notin @('.git', '.github', 'build') } |
    Copy-Item -Destination $packageDirectory -Recurse -Force

$manifestTool = Get-ChildItem -Path "${env:ProgramFiles(x86)}\Windows Kits\*\bin\*\x64\mt.exe" -File -Recurse |
    Select-Object -First 1
if ($manifestTool) {
    & $manifestTool.FullName `
        -manifest (Join-Path $PSScriptRoot 'elevate.manifest.xml') `
        "-outputresource:$($packageDirectory)\MylesMattlockWinTool.exe;#1"
} else {
    Write-Warning 'mt.exe was not found; the executable was already built with ps2exe -requireAdmin.'
}

Compress-Archive -Path $packageDirectory -DestinationPath $zipPath -Force

Write-Host "Built executable: $(Join-Path $packageDirectory 'MylesMattlockWinTool.exe')" -ForegroundColor Green
Write-Host "Built package:    $zipPath" -ForegroundColor Green
