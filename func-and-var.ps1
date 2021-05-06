$gitRepositoryName = "windotfiles"
$gitRepositoryURL = "https://github.com/nekocodeX/$gitRepositoryName"

function settingSystem {
    # ときどきスタート画面におすすめを表示する OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-338388Enabled" -Value 0 -Force
    # 新機能とおすすめを確認するために、更新の後と、サインイン時にときどき、[Windowsへようこそ]の情報を表示する OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-310093Enabled" -Value 0 -Force
    # タイムラインにおすすめを表示する OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-353698Enabled" -Value 0 -Force
    # Windowsを使う上でのヒントやお勧めの方法を取得する OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-338389Enabled" -Value 0 -Force
    # 設定アプリでおすすめのコンテンツを表示する OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-338393Enabled" -Value 0 -Force
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-353694Enabled" -Value 0 -Force
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-353696Enabled" -Value 0 -Force
    # ロック画面 Windowsスポットライト OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "RotatingLockScreenEnabled" -Value 0 -Force
    # ロック画面 WindowsとCortanaのトリビアやヒントなどの情報を表示する OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "RotatingLockScreenOverlayEnabled" -Value 0 -Force
    # 既定のWindowsモードを選択してください ダーク
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -name "SystemUsesLightTheme" -Value 0 -Force
    # 既定のアプリモードを選択します ダーク
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -name "AppsUseLightTheme" -Value 0 -Force
}

function settingExplorer {
    # エクスプローラーで開く PC
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "LaunchTo" -Value 1 -Force
    # 登録されている拡張子は表示しない OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "HideFileExt" -Value 0 -Force
    # 別のプロセスでフォルダーウィンドウを開く ON
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "SeparateProcess" -Value 1 -Force
    # チェックボックスを使用して項目を選択する OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "AutoCheckSelect" -Value 0 -Force
    # 空のドライブは表示しない OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "HideDrivesWithNoMedia" -Value 0 -Force
    # 開いているフォルダーまで展開 ON
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "NavPaneExpandToCurrentFolder" -Value 1 -Force
    # 小さいタスクバーボタンを使う ON
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "TaskbarSmallIcons" -Value 1 -Force
    # デスクトップ ごみ箱 アイコン OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 1 -Force
}

function removeUnnecessaryApps {
    Start-Process ms-windows-store://downloadsandupdates
    Read-Host "ToDo: Microsoft Store アプリ 更新"
    @(
        "Microsoft.3DBuilder",
        "Microsoft.Microsoft3DViewer",
        "Microsoft.Print3D",
        "Microsoft.BingWeather",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.Microsoft3DViewer",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection",
        "MixedReality",
        "Microsoft.MSPaint",
        "Microsoft.Office.OneNote",
        "Microsoft.People",
        "Microsoft.SkypeApp",
        "microsoft.windowscommunicationsapps",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxApp",
        "Microsoft.ZuneVideo",
        "Microsoft.549981C3F5F10" # Cortana
    ) | ForEach-Object { Get-AppxPackage *$_* | Remove-AppxPackage }    
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

function installScoopApps {
    scoop install aria2 git
    scoop bucket add extras
    @(
        "adb",
        "crystaldiskinfo",
        "crystaldiskmark",
        "deepl",
        "eartrumpet",
        "flux",
        "gimp",
        "gitignore",
        "googlechrome",
        "grep",
        "less",
        "neofetch",
        "quicklook",
        "simplenote",
        "smarttaskbar",
        "starship",
        "sudo",
        "vcredist2019",
        "vscode",
        "windows-terminal",
        "winscp",
        "wireshark"
    ) | ForEach-Object { scoop install $_ }

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
    Get-ChildItem "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot" -File | ForEach-Object { New-Item -Path "$Env:UserProfile\$_" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\$_" -ItemType SymbolicLink -Force }
    New-Item -Path "$Env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\windows-powershell\Microsoft.PowerShell_profile.ps1" -ItemType SymbolicLink -Force
    New-Item -Path "$Env:LocalAppData\Microsoft\Windows Terminal\settings.json" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\windows-terminal\settings.json" -ItemType SymbolicLink -Force
}

function manualSettingSystem {
    $inputPcName = Read-Host "PC名を入力してください"
    Rename-Computer -NewName $inputPcName -Force
}

function manualSettingGUI {
    Start-Process ms-settings:windowsupdate-options
    Read-Host "ToDo: Windowsの更新時に他のMicrosoft製品の更新プログラムを受け取る 設定"
    Write-Host "[Update] Windows"
    UsoClient StartInteractiveScan
    Start-Process shell:recyclebinfolder
    Read-Host "ToDo: ごみ箱 設定"
    Start-Process ms-settings:taskbar
    Read-Host "ToDo: タスクバーの位置 設定"
    Start-Process ms-settings:defaultapps
    Read-Host "ToDo: 既定のアプリ 設定"
    Start-Process ms-settings:optionalfeatures
    Read-Host "ToDo: オプション機能 設定"
    Start-Process optionalfeatures
    Read-Host "ToDo: Windowsの機能 設定"
    Start-Process explorer "$Env:UserProfile\scoop\apps"
    Start-Process shell:startup
    Read-Host "ToDo: スタートアップ 設定"
    Read-Host "ToDo: スタートメニュータイル 削除"
    Read-Host "ToDo: その他UI カスタマイズ"
}