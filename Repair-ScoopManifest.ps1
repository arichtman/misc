Import-Module powershell-yaml

Function Get-ScoopManifestPath{
    Param([Parameter(Mandatory=$True)]
    [String]
    $AppName
    )
    return "$env:SCOOP\apps\$AppName\current\scoop-manifest.json"
}

Function Repair-ScoopManifest{
    # Name of the application to fix
    Param([Parameter(Mandatory=$True)]
    [String]
    $AppName
    )
    Write-Host "Commencing $AppName"
    $InstalledManifestPath = Get-ScoopManifestPath $AppName
    Write-Debug "Attempting parse of $InstalledManifestPath"

    If (Test-Path $InstalledManifestPath){
        $ManifestContent = Get-Content -Raw $InstalledManifestPath
        Try
        {
            Write-Debug "a"
            ConvertFrom-Json $ManifestContent
        }
        Catch [system.exception]
        {
            Write-Host "Invalid JSON, attempting to parse as YAML"
            $ManifestObject = ConvertFrom-YAML -Yaml $ManifestContent
            $ManifestJSON = ConvertTo-Json -InputObject $ManifestObject
            Out-File -FilePath $InstalledManifestPath -Force -InputObject $ManifestJson
        }
        Finally
        {
            Write-Host "Completed $AppName"
        }
    }
}


function Repair-AllScoopManifests{
    $AppNames = $(Get-ChildItem -Directory "$env:SCOOP\apps").Name
    foreach ($AppName in $AppNames){
        Repair-ScoopManifest $AppName
    }
}

Function Get-AllScoopInstalledApps{
    Return $(Get-ChildItem -Directory "$env:SCOOP\apps").Name
}

Function Backup-ScoopManifest{
    Param([Parameter(Mandatory=$True)]
    [String]
    $AppName,
    [Parameter(Mandatory=$True)]
    [ValidateScript({
        if(-Not ($_ | Test-Path) ){
            throw "File or folder does not exist" 
        }
        if(($_ | Test-Path -PathType Leaf) ){
            throw "The Path argument must be a directory. File paths are not allowed."
        }
        return $true
    })]
    [System.IO.FileInfo]
    $OutPath
    )
    $SourceManifest = Get-ScoopManifestPath $AppName
    $DestinationFolder = "$OutPath\$AppName"
    if (-not (Test-Path $DestinationFolder)){
        New-Item -ItemType Directory $DestinationFolder
    }
    $DestinationFile = "$DestinationFolder\scoop-manifest.json"
    Copy-Item -Path $SourceManifest -Destination $DestinationFile
}

Function Backup-AllScoopManifests{
    Param([Parameter(Mandatory=$True)]
    [System.IO.FileInfo]
    $OutPath
    )
    $AppNames = Get-AllScoopInstalledApps
    foreach ($AppName in $AppNames){
        Backup-ScoopManifest $AppName $OutPath
    }
}