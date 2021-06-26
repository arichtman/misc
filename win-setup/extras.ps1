
<#
$SourceURL = 'https://github.com/NiyaShy/XB1ControllerBatteryIndicator/releases/download/v1.3.1/XB1ControllerBatteryIndicator_1.3.1.zip'
$TargetFileName = [System.IO.Path]::GetFileName($SourceURL)
Invoke-WebRequest -Uri $SourceURL -OutFile $TargetFileName
$InstallPath = 'C:\Program Files\XB1ControllerBatteryIndicator'
mkdir $InstallPath
Expand-Archive -Path $TargetFileName -DestinationPath $InstallPath
unblock-file "C:\Program Files\XB1ControllerBatteryIndicator\XB1ControllerBatteryIndicator.exe"
#>

scoop install xb1cbi electronmail irfanview lessmsi mobaxterm notepadplusplus paint.net tightvnc treesize-free vlc discord steam
choco install -y lively