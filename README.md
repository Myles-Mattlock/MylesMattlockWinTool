# MylesMattlockWinTool

PowerShell WPF tool for managing a Windows workstation from separate pages:

- **Install / Remove Apps**: install common applications with `winget` and remove selected Windows apps.
- **Customization**: apply Explorer, Start, theme, and Defender preferences.
- **Cleanup**: run the cleanup tasks directly inside the tool, with the same task selection and terminal-style logging as the original cleanup interface.

## Run from PowerShell

Open PowerShell as needed and run:

```powershell
.\MylesMattlockWinTool.ps1
```

The tool self-elevates to administrator. Keep `WingetUserHelper.ps1`, `set-cursor.ps1`, `Text-Select-Myles.cur`, and the `SystemCleanUp` resources beside the script.

## Run from the web

Once `https://myles-mattlock.co.uk/wintool` is configured to redirect to the [production launcher release asset](https://github.com/Myles-Mattlock/MylesMattlockWinTool/releases/download/prod-latest/Invoke-MylesMattlockWinTool.ps1), launch the latest package published from `main` with:

```powershell
irm https://myles-mattlock.co.uk/wintool | iex
```

The launcher downloads the matching `WinTool.zip` from its release channel, extracts it to a temporary folder, and runs the PowerShell app. The app requests administrator access and the launcher waits for it to exit before cleaning up the temporary files. Pushes to `dev` publish the `beta-latest` channel; pushes to `main` publish the `prod-latest` channel.

To test the latest `dev` build directly, run:

```powershell
irm https://github.com/Myles-Mattlock/MylesMattlockWinTool/releases/download/beta-latest/Invoke-MylesMattlockWinTool.ps1 | iex
```