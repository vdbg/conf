If (! (Test-Path $Profile)) {
	Write-Host "Creating $Profile"
	New-Item -path $Profile -type file -force
}
Write-Output ". `"$(Join-Path $PSScriptRoot "Profile.ps1")`" " > $Profile
