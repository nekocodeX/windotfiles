$gitRepositoryName = "windotfiles"
$gitRepositoryURL = "https://github.com/nekocodeX/$gitRepositoryName"

function settingSystem {
    # �Ƃ��ǂ��X�^�[�g��ʂɂ������߂�\������ OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-338388Enabled" -Value 0 -Force
    # �V�@�\�Ƃ������߂��m�F���邽�߂ɁA�X�V�̌�ƁA�T�C���C�����ɂƂ��ǂ��A[Windows�ւ悤����]�̏���\������ OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-310093Enabled" -Value 0 -Force
    # �^�C�����C���ɂ������߂�\������ OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-353698Enabled" -Value 0 -Force
    # Windows���g����ł̃q���g�₨���߂̕��@���擾���� OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-338389Enabled" -Value 0 -Force
    # �ݒ�A�v���ł������߂̃R���e���c��\������ OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-338393Enabled" -Value 0 -Force
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-353694Enabled" -Value 0 -Force
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "SubscribedContent-353696Enabled" -Value 0 -Force
    # ���b�N��� Windows�X�|�b�g���C�g OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "RotatingLockScreenEnabled" -Value 0 -Force
    # ���b�N��� Windows��Cortana�̃g���r�A��q���g�Ȃǂ̏���\������ OFF
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -name "RotatingLockScreenOverlayEnabled" -Value 0 -Force
    # �����Windows���[�h��I�����Ă������� �_�[�N
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -name "SystemUsesLightTheme" -Value 0 -Force
    # ����̃A�v�����[�h��I�����܂� �_�[�N
    New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -name "AppsUseLightTheme" -Value 0 -Force
}

function settingExplorer {
    # �G�N�X�v���[���[�ŊJ�� PC
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "LaunchTo" -Value 1 -Force
    # �o�^����Ă���g���q�͕\�����Ȃ� OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "HideFileExt" -Value 0 -Force
    # �ʂ̃v���Z�X�Ńt�H���_�[�E�B���h�E���J�� ON
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "SeparateProcess" -Value 1 -Force
    # �`�F�b�N�{�b�N�X���g�p���č��ڂ�I������ OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "AutoCheckSelect" -Value 0 -Force
    # ��̃h���C�u�͕\�����Ȃ� OFF
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "HideDrivesWithNoMedia" -Value 0 -Force
    # �J���Ă���t�H���_�[�܂œW�J ON
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "NavPaneExpandToCurrentFolder" -Value 1 -Force
    # �������^�X�N�o�[�{�^�����g�� ON
    New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name "TaskbarSmallIcons" -Value 1 -Force
}

function removeUnnecessaryApps {
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

function settingUserPath {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $userPath = "$Env:UserProfile\#Path;" + $userPath
    [Environment]::SetEnvironmentVariable("Path", $userPath, "User")
}

function installScoop {
    if (Test-Path "$Env:UserProfile\Scoop") {
        Write-Host "[Skip]"
    } else {
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString("https://get.scoop.sh")
    }
}

function installScoopApps {
    scoop install git
    scoop bucket add extras
    @(
        "sudo",
        "grep",
        "less",
        "gitignore",
        "googlechrome",
        "vscode",
        "eartrumpet",
        "crystaldiskinfo",
        "crystaldiskmark",
        "deepl",
        "gimp",
        "simplenote",
        "winscp",
        "wireshark",
        "windows-terminal",
        "starship",
        "neofetch"
    ) | ForEach-Object { scoop install $_ }

    "$Env:SCOOP\apps\vscode\current\vscode-install-context.reg"
}

function installDotfiles {
    Get-ChildItem "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot" -File | ForEach-Object { New-Item -Path "$Env:UserProfile\$_" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\$_" -ItemType SymbolicLink -Force }
    New-Item -Path "$Env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\windows-powershell\Microsoft.PowerShell_profile.ps1" -ItemType SymbolicLink -Force
    New-Item -Path "$Env:LocalAppData\Microsoft\Windows Terminal\settings.json" -Target "$Env:UserProfile\WorkSpaces\Git\$gitRepositoryName\dot\windows-terminal\settings.json" -ItemType SymbolicLink -Force
}

function manualSettingSystem {
    $inputPcName = Read-Host "PC������͂��Ă�������"
    Rename-Computer -NewName $inputPcName -Force
}

function manualSettingGUI {
    Start-Process ms-settings:windowsupdate-options
    Read-Host "ToDo: Windows�̍X�V���ɑ���Microsoft���i�̍X�V�v���O�������󂯎�� �ݒ�"
    Write-Host "[Update] Windows"
    UsoClient StartInteractiveScan
    Start-Process ms-windows-store://downloadsandupdates
    Read-Host "ToDo: Microsoft Store �A�v�� �X�V"
    Start-Process shell:recyclebinfolder
    Read-Host "ToDo: ���ݔ� �ݒ�"
    Start-Process ms-settings:taskbar
    Read-Host "ToDo: �^�X�N�o�[�̈ʒu �ݒ�"
    Start-Process shell:startup
    Read-Host "ToDo: �X�^�[�g�A�b�v �ݒ�"
    Read-Host "ToDo: �X�^�[�g���j���[�^�C�� �폜"
    Read-Host "ToDo: ���̑�UI �J�X�^�}�C�Y"
}