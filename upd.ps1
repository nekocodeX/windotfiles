#Requires -RunAsAdministrator

# �G���[�������Ƀ��b�Z�[�W��\�����A���s���邩�ǂ������m�F
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
Set-Location $PSScriptRoot

Write-Host "[Update] windotfiles"
git pull origin main --rebase

if ($LastExitCode -eq 0) {
    Write-Host "[Install] windotfiles"
    . "$PSScriptRoot\func-and-var.ps1"
    installDotfiles
} else {
    Write-Host "[ERROR] ���[�L���O�c���[�̕ύX���j������邱�Ƃ��m�F������ňȉ������s���Ă���Ď��s���Ă�������"
    Write-Host "`tSet-Location $Env:UserProfile\WorkSpaces\Git\windotfiles"
    Write-Host "`tgit reset --hard"
}

Set-Location $bkupPwd