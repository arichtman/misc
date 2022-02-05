$steamDirs = @(
	"C:\Program Files (x86)\Steam\steamapps\common",
	"D:\SteamLibrary\steamapps\common"
	)
$steamExes = @()

# Depth 1 may be a little short but it captures most games without adding too many erroneous sub-binaries
foreach($dir in $steamDirs){
	Push-Location $dir
	$steamExes += Get-ChildItem -Depth 1 | Where-Object{$_.Name -like '*.exe'}
	Pop-Location
}

$outputObject = @()
foreach ($exe in $steamExes){
	$outputObject += @(@{ AppName = $exe.BaseName; Rule = 0 })
}

# Here I add any custom rules that I wish to add
$outputObject += @(@{ AppName = "firefox"; Rule = 1})
$outputObject += @(@{ AppName = "brave"; Rule = 1})

# Have to close down and re-open otherwise cached/in-use values will be written
Stop-Process -Force -Name livelywpf
ConvertTo-Json -InputObject $outputObject | Out-File -FilePath "$env:UserProfile\AppData\Local\Lively Wallpaper\AppRules.json"

Start "C:\Program Files (x86)\Lively Wallpaper\livelywpf.exe"