If (! (Test-Path $Profile)) {
	Write-Host "Creating $Profile"
	New-Item -path $Profile -type file -force
}
$customProfile = Join-Path $PSScriptRoot "Profile.ps1"
Copy-Item $customProfile $Profile 


