param(
    [Parameter(Mandatory = $true)][ValidateSet('install', 'uninstall')][string]$Action,
    [Parameter(Mandatory = $true)][string]$PackageId,
    [Parameter(Mandatory = $true)][string]$OutputPath,
    [Parameter(Mandatory = $true)][string]$ResultPath
)

try {
    Set-Content -LiteralPath $OutputPath -Value '' -Encoding UTF8
    $wingetPath = (Get-Command 'winget.exe' -ErrorAction SilentlyContinue).Source
    if (-not $wingetPath) {
        $wingetPath = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\winget.exe'
    }
    if (-not (Test-Path -LiteralPath $wingetPath)) {
        throw 'Could not locate winget.exe for the current user.'
    }
    if ($Action -eq 'install') {
        & $wingetPath install --id $PackageId --exact --accept-source-agreements --accept-package-agreements 2>&1 | ForEach-Object {
            Add-Content -LiteralPath $OutputPath -Value ([string]$_) -Encoding UTF8
        }
    } else {
        & $wingetPath uninstall --id $PackageId --exact --accept-source-agreements 2>&1 | ForEach-Object {
            Add-Content -LiteralPath $OutputPath -Value ([string]$_) -Encoding UTF8
        }
    }
    Set-Content -LiteralPath $ResultPath -Value ([string]$LASTEXITCODE) -Encoding ASCII
} catch {
    Add-Content -LiteralPath $OutputPath -Value $_.Exception.Message -Encoding UTF8
    Set-Content -LiteralPath $ResultPath -Value '1' -Encoding ASCII
}
