$ErrorActionPreference = 'Stop'

$releaseTag = if ($env:MYLES_WINTOOL_RELEASE_TAG) { $env:MYLES_WINTOOL_RELEASE_TAG } else { 'prod-latest' }
$packageUri = "https://github.com/Myles-Mattlock/MylesMattlockWinTool/releases/download/$releaseTag/WinTool.zip"
$launchDirectory = Join-Path $env:TEMP "MylesMattlockWinTool-$([guid]::NewGuid())"
$packagePath = Join-Path $launchDirectory 'WinTool.zip'
$entryPoint = Join-Path $launchDirectory 'MylesMattlockWinTool.ps1'

try {
    New-Item -ItemType Directory -Path $launchDirectory -Force | Out-Null
    Invoke-WebRequest -Uri $packageUri -OutFile $packagePath
    Expand-Archive -LiteralPath $packagePath -DestinationPath $launchDirectory -Force

    if (-not (Test-Path -LiteralPath $entryPoint)) {
        throw 'The downloaded package does not contain MylesMattlockWinTool.ps1.'
    }

    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $entryPoint
    if ($LASTEXITCODE -ne 0) {
        throw "MylesMattlockWinTool.ps1 exited with code $LASTEXITCODE."
    }
} finally {
    if (Test-Path -LiteralPath $launchDirectory) {
        Remove-Item -LiteralPath $launchDirectory -Recurse -Force
    }
}
