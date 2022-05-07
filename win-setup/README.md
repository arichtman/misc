# Scripts for setting up a Windows environment

Mostly for development but plenty of QoL stuff and leisure optionals. Some stuff ripped straight from https://gist.github.com/darkliquid/47b9c4bc835d1f7109ebc678c4379d61

## Ubuntu

Note that some of the NordVPN endpoints in Australia have been blacklisted by Canonical for some of the repositories. Disable the VPN when interacting with these to ensure all listings and updates are successful.

## Podman init.d service

Non root users don't have access to /var/run (linked to /run) so we get errors if we try to use that directory like SystemD does. It seems to be a tempfs directory so it's not like we can `sudo` set up a directory once and have it persist. I've used /tmp instead for now, though I'd love to get to the bottom of what's correct practice.

There may also be some kind of bug that leaves podman processes running after the service is stopped.

## Devcontainers

I tried running a sample container and need to solve for this

```
[125093 ms] Start: Run in Host: podman inspect --type container f8ca0418f60cb956f975c95a4fc6b877a56610de94c8be4f5406b25051b747e1
[125476 ms] Start: Run in Host: podman exec -i -u vscode -e VSCODE_REMOTE_CONTAINERS_SESSION=65ffef42-034c-4c64-b567-e25cdc55fd931651936724048 f8ca0418f60cb956f975c95a4fc6b877a56610de94c8be4f5406b25051b747e1 /bin/sh
[125478 ms] Start: Run in container: uname -m
[125809 ms] Start: Run in container: cat /etc/passwd
[125810 ms] Start: Run in Host: podman rm -f 410bc551de3f042360f4d346ff6963a4c3d0563a66013ae295ab60e515c27949
[125813 ms] Shell server terminated (code: 127, signal: null)

Error: error opening file `/home/arichtman/crun/f8ca0418f60cb956f975c95a4fc6b877a56610de94c8be4f5406b25051b747e1/status`: No such file or directory: OCI runtime attempted to invoke a command that was not found

[136538 ms] Container server: Error: container has already been removed
[136540 ms] Container server terminated (code: 255, signal: null)
```
