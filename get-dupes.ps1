Set-Location D:\nextcloud\InstantUpload
$files = Get-ChildItem -Recurse | Where-Object{ !$_.PSIsContainer }

$dupeGroups = $files | group-object -Property Name,CreationTime,Length | Where-Object -Property Count -GT 1

function Select-GroupSubjectToDelete {
    param (
        $group
    )
    Return $(  $group[0].group |  Sort-Object -Property {$_.FullName.Length} | Select-Object -Last 1)
}

$deletionList = @()
foreach($group in $dupeGroups){
    $deletionList += Select-GroupSubjectToDelete $group
}

foreach($finding in $deletionList){
    Remove-Item $finding.FullName
}

$files = Get-ChildItem -Recurse -Filter "*(1)*"  | Where-Object{ !$_.PSIsContainer }
foreach($file in $files){
    if (test-path $file.fullname.Replace(' (1)','') ){
        remove-item $file.fullname
    }
}