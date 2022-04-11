#!/bin/ash
# It's insecure but it's local and a scoped token
git config credential.helper store

su -l root
apk update
apk add libstdc++

# woah there pardner, while this works, we might wanna review...
apk add docker

#region Enable passwordless su for my account

USR=$(stat -c%U $(readlink /proc/self/fd/0))
cd /etc/pam.d/
sed -i "3 i auth            sufficient      pam_succeed_if.so use_uid user = $USR" su

#endregion

#region INI tooling

# This is probably overkill but I like package management for everything
# Primary purpose here is to get nice tooling for editing INI-style files

# Install hubapp
# ** PROBLEM - hubapp install only works as root but can't actually _run_ the binary for some reason
# we just get "-ash: hubapp not found", despite it showing in _which_, _hash_, and being in path
# and _stat_ working fine, permissions look good.. **
wget -q -O - https://raw.githubusercontent.com/warrensbox/hubapp/release/install.sh | ash
# install Crudini
hubapp install pixelb/crudini

crudini --set /etc/containers/storage.conf '' driver btrfs

#endregion

#region Podman

apk add podman
# enable cgroups V2
sed -i 's/#rc_cgroup_mode="hybrid"/rc_cgroup_mode="unified"/' /etc/rc.conf
# Configure the storage driver
# NB: I need to research if this is the right move
sed -i 's/driver = "overlay"/driver = "btrfs"/' /etc/containers/storage.conf

rc-update add cgroups
rc-service cgroups start

modprobe tun
echo tun >> /etc/modules
echo "$ORIGINAL_USER:100000:65536" >/etc/subuid
echo "$ORIGINAL_USER:100000:65536" >/etc/subgid

# Test
podman run --rm hello-world

#endregion