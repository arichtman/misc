
import-module posh-git 
import-module poshfuck
 
New-Alias ss -Value select-string
 
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isadmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Remove-Variable identity
Remove-Variable principal
function su {
    &$HOME\scoop\shims\sudo.cmd powershell -NoLogo
}