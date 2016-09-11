@echo off
setlocal
set chocoRoot=%~d0\Choco

where choco.exe > NUL 2>&1

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
		echo ERROR: Unable to create create system environment variable.
		exit /b 1
	)

:installChoco
	set ChocolateyInstall=%chocoRoot%
	cd /d "%~dp0"
	set ps=%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe
	set setup=choco_install.ps1

	"%ps%" -NoProfile -ExecutionPolicy Bypass -Command "((new-object net.webclient).DownloadFile('https://chocolatey.org/install.ps1','%setup%'))"
	"%ps%" -NoProfile -ExecutionPolicy Bypass -Command "& '%cd%\%setup%' %*"
	del /f %setup%

	set path=%chocoRoot%\bin;%path%
	
:installPackages
	echo Enabling chocolatey source
	choco.exe source enable --name=chocolatey
	
	set choco_packages=googlechrome notepadplusplus.install 7zip.install git.install vlc keepass.install python fiddler4 conemu "mobaxterm --allowEmptyChecksums" visualstudiocode "calibre --allow-empty-checksums" sumatrapdf.commandline "paint.net --allow-empty-checksums"
	rem sysinternals atom nodejs powershell windirstat
	for %%X in ( %choco_packages% ) do call :installPackage %%X
	goto :eof
	
:installPackage
	echo Installing %~1
	choco install %~1 -y
	goto :eof
	