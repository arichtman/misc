$USERID = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$USER = $env:UserName
$DOMAIN = $env:UserDomain

# backup and overwrite the user's psprofile
if ($(Test-Path -Path $PROFILE )) { Move-Item -Path $PROFILE -Destination "$PROFILE.bak" -Force }
Copy-item '.\Microsoft.PowerShell_profile.ps1' $PROFILE -Force

# install chocolatey and packages
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y powershell soundswitch

# Install powershell modules

Install-module posh-git 
install-module poshfuck

# Install scoop, new buckets, and packages

Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

scoop bucket add tlz https://github.com/TheLastZombie/scoop-bucket
scoop bucket add Ash258 'https://github.com/Ash258/scoop-Ash258.git'
scoop bucket add darkliquid 'https://github.com/darkliquid/bucket.git'

scoop install aria2  
scoop install 7zip concfg git gpg vscode vcredist2017 DirectX docker nodejs yarn sudo desktopinfo which envsubst bulk-crap-uninstaller copyq coreutils

Copy-Item -Path '.\desktopinfo.ini' -Destination "$HOME\scoop\apps\desktopinfo\current\desktopinfo.ini" -Force

# Export variables from process scope so `envsubst` can use them
$ExportVars = @( "USERID", "USER", "DOMAIN", "HOME")
$ExportVars | ForEach-Object{ Set-Item -Path "env:$_" -Value "$($(Get-Variable -Name $_).Value)" }

# Install scheduled tasks for the tools
Register-ScheduledTask -Xml "$(Get-Content -Raw '.\DesktopInfo.xml' | envsubst )" -TaskName "Desktop Info"

# SSH setup
Set-Service -StartupType Automatic ssh-agent
Start-Service ssh-agent

# Set up terminal theme
concfg import monokai

# Windows 10 Debloater
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10SysPrepDebloater.ps1')); Invoke-Expression 'Start-Debloat -Sysprep -Debloat -Privacy'
