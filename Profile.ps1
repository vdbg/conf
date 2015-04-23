if(Test-Path $PSScriptRoot\Modules\PsGet\PsGet.psm1) {
                Import-Module $PSScriptRoot\Modules\PsGet\PsGet.psm1
} else {
                (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
}
Install-Module PSReadline

Set-PSReadlineKeyHandler -Key 'Ctrl+d' -Function DeleteCharOrExit
Set-PSReadlineKeyHandler -Key 'Ctrl+k' -Function KillLine
Set-PSReadlineKeyHandler -Key 'Ctrl+u' -Function BackwardKillLine
