@echo off
setlocal
if not defined CacheDrive set CacheDrive=%~d0

reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /d "%~dp0Profile.cmd" /f

rem Search index: location is stored here
rem HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Search\Databases\Windows
rem However, changing it directly & restarting service does not work

call :set_env_path NugetMachineInstallRoot %CacheDrive%\CoreXTCache
call :set_env_path ChocolateyInstall %CacheDrive%\Choco
call :set_env_path ChocoRoot %CacheDrive%\Choco
call :set_env_path TMP %CacheDrive%\OS_FILES\OS_TMP /M
call :set_env_path TEMP %CacheDrive%\OS_FILES\OS_TMP /M

call :set_env_path TMP %CacheDrive%\OS_FILES\%USERNAME%_TMP
call :set_env_path TEMP %CacheDrive%\OS_FILES\%USERNAME%_TMP

call :ensure_exists %CacheDrive%\symbols
setx _NT_SYMBOL_PATH cache*%CacheDrive%\symbols;SRV*http://msdl.microsoft.com/download/symbols;SRV*http://symweb


call "%~dp0CreateShortcuts.cmd"
call "%~dp0ConsoleSetup.cmd"

goto :eof

:ensure_exists
	if not exist %1 mkdir %1
	goto :eof

:set_env_path
	call :ensure_exists %2 || exit /b 1
	echo Creating env var %1=%2
	setx %1 %2 %3
	goto :eof
