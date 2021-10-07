$gitRepositoryName = "windotfiles"
$gitRepositoryURL = "https://github.com/nekocodeX/$gitRepositoryName"

function settingSystem {
    # ロングパス制限 OFF
    New-ItemProperty -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -Force
    # Windowsの使用時にヒントと提案を表示する OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0 -Force
    # 設定アプリでおすすめのコンテンツを表示する OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Value 0 -Force
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353694Enabled" -Value 0 -Force
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Value 0 -Force
    # ロック画面 Windowsスポットライト OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenEnabled" -Value 0 -Force
    # ロック画面にトリビアやヒントなどの情報を表示する OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenOverlayEnabled" -Value 0 -Force
    # ダークモード
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Force
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Force
}

function settingExplorer {
    # エクスプローラーで開く PC
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1 -Force
    # 登録されている拡張子は表示しない OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Force
    # 別のプロセスでフォルダーウィンドウを開く ON
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "SeparateProcess" -Value 1 -Force
    # チェックボックスを使用して項目を選択する OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AutoCheckSelect" -Value 0 -Force
    # 空のドライブは表示しない OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideDrivesWithNoMedia" -Value 0 -Force
    # 開いているフォルダーまで展開 ON
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "NavPaneExpandToCurrentFolder" -Value 1 -Force
    # 項目間のスペースを減らす(コンパクトビュー) ON
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "UseCompactMode" -Value 1 -Force
    # デスクトップ ごみ箱 アイコン OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 1 -Force
}

function removeUnnecessaryApps {
    Start-Process ms-windows-store://downloadsandupdates
    Read-Host "ToDo: Microsoft Store アプリ 更新"
    @(
        "Microsoft.549981C3F5F10", # Cortana
        "Microsoft.BingNews",
        "Microsoft.BingWeather",
        "Microsoft.GamingApp",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.OneDriveSync",
        "Microsoft.People",
        "Microsoft.PowerAutomateDesktop",
        "Microsoft.Office.OneNote",
        "Microsoft.People",
        "Microsoft.Todos",
        "microsoft.windowscommunicationsapps",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps",
        "Microsoft.ZuneVideo",
        "MicrosoftTeams",
        "SpotifyAB.SpotifyMusic"
    ) | ForEach-Object {
        Get-AppxPackage *$_* | Remove-AppxPackage
    }
}

function removeOneDrive {
    taskkill /f /im OneDrive.exe
    if (Test-Path "$Env:SystemRoot\System32\OneDriveSetup.exe") {
        # x86
        & "$Env:SystemRoot\System32\OneDriveSetup.exe" /uninstall
    }
    if (Test-Path "$Env:SystemRoot\SysWOW64\OneDriveSetup.exe") {
        # x64
        & "$Env:SystemRoot\SysWOW64\OneDriveSetup.exe" /uninstall
    }
}

function createDirectories {
    New-Item "$Env:UserProfile\Apps" -ItemType Directory -Force
    New-Item "$Env:UserProfile\#Path" -ItemType Directory -Force
    New-Item "$Env:UserProfile\WorkSpaces" -ItemType Directory -Force
}

function installScoop {
    if (Test-Path "$Env:UserProfile\scoop") {
        Write-Host "[Skip]"
    } else {
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString("https://get.scoop.sh")
    }
}

function settingScoop {
    scoop install aria2 git
    scoop bucket add extras
    scoop bucket add scoop-viewer-bucket https://github.com/prezesp/scoop-viewer-bucket
}

function installScoopApps {
    @(
        "adb",
        "crystaldiskinfo",
        "crystaldiskmark",
        "deepl",
        "eartrumpet",
        "gimp",
        "gitignore",
        "googlechrome",
        "grep",
        "less",
        "neofetch",
        "quicklook",
        "scoop-viewer",
        "simplenote",
        "starship",
        "sudo",
        "vcredist2019",
        "vscode",
        "winscp",
        "wireshark"
    ) | ForEach-Object {
        scoop install $_
    }

    reg import "$Env:UserProfile\scoop\apps\vscode\current\vscode-install-context.reg"
    smarttaskbar-add-startup
}

function settingUserPath {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $userPath = $userPath.Replace("$Env:UserProfile\#Path;", "")
    $userPath = "$Env:UserProfile\#Path;" + $userPath
    [Environment]::SetEnvironmentVariable("Path", $userPath, "User")
}

function installDotfiles {
    Get-ChildItem "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot" -File | ForEach-Object {
        New-Item -Path "$Env:UserProfile\$_" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\$_" -ItemType SymbolicLink -Force
    }
    New-Item "$Env:UserProfile\.config" -ItemType Directory -Force
    Get-ChildItem "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\.config" -File | ForEach-Object {
        New-Item -Path "$Env:UserProfile\.config\$_" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\.config\$_" -ItemType SymbolicLink -Force
    }
    New-Item -Path "$Env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\windows-powershell\Microsoft.PowerShell_profile.ps1" -ItemType SymbolicLink -Force
    New-Item -Path "$Env:LocalAppData\Microsoft\Windows Terminal\settings.json" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\windows-terminal\settings.json" -ItemType SymbolicLink -Force
    New-Item -Path "$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\windows-terminal\settings.json" -ItemType SymbolicLink -Force
}

function manualSettingGUI {
    Start-Process ms-settings:windowsupdate-options
    Read-Host "ToDo: その他のMicrosoft製品の更新プログラムを受け取る 設定"
    Write-Host "[Update] Windows"
    UsoClient StartInteractiveScan
    Start-Process ms-settings:taskbar
    Read-Host "ToDo: タスクバー 設定"
    Start-Process ms-settings:defaultapps
    Read-Host "ToDo: 既定のアプリ 設定"
    Start-Process ms-settings:clipboard
    Read-Host "ToDo: クリップボード 設定"
    Start-Process ms-settings:regionlanguage-jpnime
    Read-Host "ToDo: IME 設定"
    Start-Process ms-settings:optionalfeatures
    Read-Host "ToDo: オプション機能 設定"
    Start-Process optionalfeatures
    Read-Host "ToDo: Windowsの機能 設定"
    Start-Process shell:recyclebinfolder
    Read-Host "ToDo: ごみ箱 設定"
    Start-Process explorer "$Env:UserProfile\scoop\apps"
    Start-Process shell:startup
    Read-Host "ToDo: スタートアップ 設定"
    Read-Host "ToDo: スタートメニューピン留め 削除"
    Read-Host "ToDo: その他UI カスタマイズ"
}