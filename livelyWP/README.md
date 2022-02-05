# Add-SteamExceptions

Powershell script to add rules to [Lively Wallpaper](https://github.com/rocksdanister/lively) to pause when games are running.

## Usage

1. Correct the Steam directories at the top of the script to your locations. You may add and remove as you like but there must be at least one and they should all be valid paths.
1. Check your [current file]("$env:UserProfile\AppData\Local\Lively Wallpaper\AppRules.json") for any rules that you wish to persist and add them post looping.
