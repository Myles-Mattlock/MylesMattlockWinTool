# MylesMattlockWinTool

PowerShell WPF tool for managing a Windows workstation from separate pages:

- **Install / Remove Apps**: install common applications with `winget` and remove selected Windows apps.
- **Customization**: apply Explorer, Start, theme, and Defender preferences.
- **Cleanup**: run the cleanup tasks directly inside the tool, with the same task selection and terminal-style logging as the original cleanup interface.

## Run

Open PowerShell as needed and run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\MylesMattlockWinTool.ps1
```

To launch it without leaving a PowerShell window visible, run:

```powershell
Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PWD\MylesMattlockWinTool.ps1`"" -WindowStyle Hidden
```

The tool self-elevates to administrator. `CleanUp.ps1` remains in the repository as the original standalone cleanup implementation, but the main tool does not launch it.

## Build locally

Install the `ps2exe` PowerShell module once, then run the local packaging script:

```powershell
Install-Module -Name ps2exe -Scope CurrentUser
.\BuildLocal.ps1
```

The output is written to `build\windowsinstaller`, with `WindowsInstaller.zip` created in `build`. The packaged executable includes the current `MM.ico`; `WingetUserHelper.ps1` and the resource folders are included beside it as runtime dependencies. The executable is compiled with administrator privileges enabled; if the Windows SDK is installed, the script also embeds `elevate.manifest.xml` with `mt.exe`.