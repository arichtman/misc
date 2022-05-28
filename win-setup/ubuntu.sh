#!/bin/bash

# Enable passwordless sudo for user
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/98-${USER}"
# Podman relies on this being set for some things
#echo "export XDG_RUNTIME_DIR=~" > ~/.profile

# Port in our SSH config and keys
mkdir -p ~/.ssh
cp /mnt/c/Users/ariel/.ssh/* ~/.ssh
chmod 600 ~/.ssh/*

sudo su -l
apt update
apt upgrade -y

#region Podman

source /etc/os-release
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | apt-key add -
apt update
apt install -y podman

cp podman /etc/init.d/
chmod +x /etc/init.d/podman

# This can be omitted if VSCode host machine Remote-Containers setting "Docker path" is set to 'podman'
ln -s /usr/bin/podman /usr/local/bin/docker

service podman start
# Could put some logic in here around XDG_RUNTIME_DIR being set
ln -s /tmp/${USER}-runtime/podman/podman.sock /run/docker.sock

# Test socket
curl -H "Content-Type: application/json" --unix-socket /var/run/docker.sock http://localhost/_ping

# devcontainers should now work!

#endregion

add-apt-repository ppa:deadsnakes/ppa
apt-get update
apt-get install python3.11 python3.11-distutils python3.11-dev

curl -sSL https://install.python-poetry.org | python3 -

exit

poetry config virtualenvs.in-project true


git config --global init.templateDir ~/.git-template
pre-commit init-templatedir ~/.git-template

#region homebrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/arichtman/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
sudo su -l
#apt-get install build-essential -y

#endregion

# Install zq for data munging
brew install brimdata/tap/zq
# Bitwarden for Chezmoi secret values
brew install bitwarden-cli

#region Chezmoi/dotfiles

mkdir -p ~/.local
cd ~/.local
sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply arichtman
chezmoi(){ ~/.local/bin/chezmoi $@ ; }
export EDITOR=nano

#endregion
