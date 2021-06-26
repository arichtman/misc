# Setup useful variables
$USERID = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$USER = $env:UserName
$DOMAIN = $env:UserDomain
$UBUNTU="focal"

# Setup WSL
Invoke-WebRequest -Uri "https://partner-images.canonical.com/core/$UBUNTU/current/ubuntu-$UBUNTU-core-cloudimg-amd64-root.tar.gz" -OutFile $HOME\Downloads\ubuntu-core-cloudimg-amd64-root.tar.gz
lxrunoffline i -n "Ubuntu" -d $HOME\Ubuntu -f $HOME\Downloads\ubuntu-core-cloudimg-amd64-root.tar.gz
lxrunoffline r -n "Ubuntu" -c "echo '[automount]' > /etc/wsl.conf"
lxrunoffline r -n "Ubuntu" -c "echo 'options = `"metadata`"' >> /etc/wsl.conf"
lxrunoffline r -n "Ubuntu" -c "apt update"
lxrunoffline r -n "Ubuntu" -c "apt upgrade"
lxrunoffline r -n "Ubuntu" -c "apt install -y sudo git-core"
Get-Service LxssManager | Restart-Service
lxrunoffline r -n "Ubuntu" -c "useradd -m -G sudo -d /mnt/c/Users/$USER $USER"
lxrunoffline r -n "Ubuntu" -c "cp /etc/skel/.* /mnt/c/Users/$USER/"
lxrunoffline r -n "Ubuntu" -c "chown $USER:$USER /mnt/c/Users/$USER/.profile"
lxrunoffline r -n "Ubuntu" -c "chown $USER:$USER /mnt/c/Users/$USER/.bashrc"
lxrunoffline r -n "Ubuntu" -c "chown $USER:$USER /mnt/c/Users/$USER/.bash_logout"
# This is temporary - passwordless sudo is bad, m'kay?
lxrunoffline r -n "Ubuntu" -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
# Make our new non-privileged user the default
lxrunoffline su -n "Ubuntu" -v 1000

# Windows defender tweaks
Add-MpPreference -ExclusionPath $HOME\Ubuntu\rootfs
$dirs = @("\bin", "\sbin", "\usr\bin", "\usr\sbin", "\usr\local\bin", "\home\linuxbrew\.linuxbrew\bin", "\home\$USER\.cargo\bin", "\home\$USER\go\bin", "\snap\bin")
$dirs | ForEach-Object {
  $exclusion = "$HOME\Ubuntu\rootfs" + $_ + "\*"
  Add-MpPreference -ExclusionProcess $exclusion
}

Set-MpPreference -EnableControlledFolderAccess Enabled
Add-MpPreference -ControlledFolderAccessAllowedApplications "C:\windows\system32\windowspowershell\v1.0\powershell.exe"

# Configure WSL environment
lxrunoffline r -n "Ubuntu" -c "bash -c 'cd && git clone https://github.com/darkliquid/dotfiles.git && bash ./dotfiles/setup.sh'"

# Remove nopasswd sudo support for our user
lxrunoffline r -n "Ubuntu" -c "bash -c `"sudo sed -i '/$USER/d' /etc/sudoers`""