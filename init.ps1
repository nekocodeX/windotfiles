#Requires -RunAsAdministrator

# エラー発生時にメッセージを表示し、続行するかどうかを確認
$ErrorActionPreference = "Inquire"

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Clear-Host
Write-Host "           _             _         _     __  _  _"
Write-Host "          (_)           | |       | |   / _|(_)| |"
Write-Host "__      __ _  _ __    __| |  ___  | |_ | |_  _ | |  ___  ___"
Write-Host "\ \ /\ / /| || '_ \  / _' | / _ \ | __||  _|| || | / _ \/ __|"
Write-Host " \ V  V / | || | | || (_| || (_) || |_ | |  | || ||  __/\__ \"
Write-Host "  \_/\_/  |_||_| |_| \__,_| \___/  \__||_|  |_||_| \___||___/"
Write-Host "Initialization by nekocodeX"

$bkupPwd = Get-Location
Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)
. ((Split-Path -Parent $MyInvocation.MyCommand.Path) + "\func-and-var.ps1")

Write-Host "[Setting] System"
settingSystem

Write-Host "[Setting] Explorer"
settingExplorer

Write-Host "[Remove] Unnecessary apps"
removeUnnecessaryApps

Write-Host "[Remove] OneDrive"
removeOneDrive

Write-Host "[Create] Directories"
createDirectories

Write-Host "[Install] Scoop"
installScoop

Write-Host "[Install] Scoop apps"
installScoopApps

Write-Host "[Setting] User path"
settingUserPath

Write-Host "[Install] dotfiles"
New-Item "$Env:UserProfile\WorkSpaces\Git" -ItemType Directory -Force
Set-Location "$Env:UserProfile\WorkSpaces\Git"
git clone $gitRepositoryURL
Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)
installDotfiles

Write-Host "[Manual] [Setting] System"
manualSettingSystem

Write-Host "[Manual] [Setting] GUI"
manualSettingGUI

Read-Host "設定を完了するために再起動するには、Enter キーを押してください"
Set-Location $bkupPwd
Restart-Computer