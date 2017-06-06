@echo off
setlocal

rem location and packages to install
if not defined chocoRoot set chocoRoot=%~d0\Choco
set chocoPackagesWork=fiddler4 ilspy NugetPackageExplorer redis-desktop-manager slack microsoftazurestorageexplorer armclient
set chocoPackagesUtil=7zip.install conemu git.install googlechrome keepass.install "mobaxterm --allowEmptyChecksums" notepadplusplus.install nuget.commandline "paint.net --allow-empty-checksums" sourcetree visualstudiocode rufus
set chocoPackagesHome="calibre --allow-empty-checksums" python sumatrapdf.commandline vlc
if not defined chocoPackages set chocoPackages=%chocoPackagesUtil% %chocoPackagesWork%
rem  
rem sysinternals atom nodejs powershell windirstat spybot ccleaner
if not defined chocoExe set chocoExe=choco.exe

where "%chocoExe%" > NUL 2>&1

if %errorlevel% equ 0 (
	echo ERROR: choco already installed
	exit /b 1
)

:createFolder
	if exist %chocoRoot% goto :createEnvVar
	mkdir %chocoRoot%
	if exist %chocoRoot% goto :createEnvVar
	echo ERROR: Unable to create %chocoRoot%
	exit /b 1

:createEnvVar
	setx ChocolateyInstall %chocoRoot% /m > NUL 2>&1
	if ERRORLEVEL 1 (
		echo ERROR: Unable to create create system environment variable. Run script as admin.
		exit /b 1
	)

:installChoco
	set ChocolateyInstall=%chocoRoot%
	pushd "%~dp0"
	set ps=%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe
	set setup=choco_install.ps1

	if exist %setup% del /f %setup%
	
	"%ps%" -NoProfile -ExecutionPolicy Bypass -Command "((new-object net.webclient).DownloadFile('https://chocolatey.org/install.ps1','%setup%'))"
	if not exist %setup% (
		echo ERROR: Unable to download setup script
		exit /b 1
	)
	
	"%ps%" -NoProfile -ExecutionPolicy Bypass -Command "& '%cd%\%setup%' %*"
	del /f %setup%
	popd

	set path=%chocoRoot%\bin;%path%

:installPackages
	echo Enabling chocolatey source
	rem Azure install disables choco's default source
	"%chocoExe%" source enable --name=chocolatey

	for %%X in ( %chocoPackages% ) do call :installPackage %%X
	
	echo Start a new command prompt to be able to use choco.
	
	goto :eof

:installPackage
	echo Installing %~1
	"%chocoExe%" install %~1 -y
	goto :eof
