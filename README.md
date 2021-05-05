# windotfiles

Windows 用 dotfiles のような何か

## ✅ 動作環境

Windows 10 Pro 20H2 以降

## 📦 使い方

`Windows PowerShell (管理者)` で以下を実行

### 初期セットアップ

```powershell
Set-Location $Env:Temp
Invoke-WebRequest -Uri "https://github.com/nekocodeX/windotfiles/archive/refs/heads/main.zip" -UseBasicParsing -OutFile "windotfiles.zip"
Expand-Archive -Path .\windotfiles.zip
Remove-Item .\windotfiles.zip
Set-Location .\windotfiles\windotfiles-main\
powershell -ExecutionPolicy RemoteSigned .\init.ps1
```

### リポジトリの dotfiles と同期

```powershell
sudo $Env:UserProfile\WorkSpaces\Git\windotfiles\upd.ps1
```

#### 怒られた場合

```
error: cannot pull with rebase: You have unstaged changes.
error: please commit or stash them.
```

ワーキングツリーの変更が破棄されることを確認した上で以下を実行してから再試行

```powershell
git reset --hard
```

## ©️ ライセンス

Do What The F\*ck You Want To Public License
