$USERID = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$USER = $env:UserName
$DOMAIN = $env:UserDomain

# backup and overwrite the user's psprofile
if ($(Test-Path -Path $PROFILE )) { Move-Item -Path $PROFILE -Destination "$PROFILE.bak" -Force }
Copy-item '.\Microsoft.PowerShell_profile.ps1' $PROFILE -Force

# Install powershell modules

Install-module posh-git 
install-module poshfuck

# Install scoop, new buckets, and packages

Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install 7zip git aria2

scoop config SCOOP_REPO 'https://github.com/Ash258/Scoop-Core'
scoop update
scoop status
scoop checkup

shovel bucket add tlz https://github.com/TheLastZombie/scoop-bucket
shovel bucket add Ash258 'https://github.com/Ash258/scoop-Ash258.git'
shovel bucket add darkliquid 'https://github.com/darkliquid/bucket.git'
shovel bucket add dorado 'https://github.com/chawyehsu/dorado'
shovel bucket add lemon https://github.com/hoilc/scoop-lemon
shovel bucket add arichtman https://github.com/arichtman/shovel-bucket

$packages = @(
    'concfg',
    'git',
    'gpg',
    'vscode',
    'vcredist2017',
    'DirectX',
    'docker',
    'volta',
    'yarn',
    'sudo',
    'which',
    'envsubst',
    'bulk-crap-uninstaller',
    'copyq',
    'coreutils',
    'imageglass'
)
$packages | ForEach-Object{ shovel install $_ }

# enable tab-completion for Volta
(& volta completions powershell) | Out-String | Invoke-Expression
volta install node

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
