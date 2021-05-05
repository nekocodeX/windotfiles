#Requires -RunAsAdministrator

# エラー発生時にメッセージを表示し、続行するかどうかを確認
$ErrorActionPreference = "Inquire"

Clear-Host
Write-Host "           _             _         _     __  _  _"
Write-Host "          (_)           | |       | |   / _|(_)| |"
Write-Host "__      __ _  _ __    __| |  ___  | |_ | |_  _ | |  ___  ___"
Write-Host "\ \ /\ / /| || '_ \  / _' | / _ \ | __||  _|| || | / _ \/ __|"
Write-Host " \ V  V / | || | | || (_| || (_) || |_ | |  | || ||  __/\__ \"
Write-Host "  \_/\_/  |_||_| |_| \__,_| \___/  \__||_|  |_||_| \___||___/"
Write-Host "Update by nekocodeX"

$bkupPwd = Get-Location
Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host "[Update] windotfiles"
git pull origin main --rebase

if ($LastExitCode -eq 0) {
    Write-Host "[Install] windotfiles"
    . ((Split-Path -Parent $MyInvocation.MyCommand.Path) + "\func-and-var.ps1")
    installDotfiles
} else {
    Write-Host "[ERROR] ワーキングツリーの変更が破棄されることを確認した上で以下を実行してから再試行してください"
    Write-Host "`tgit reset --hard"
}

Set-Location $bkupPwd