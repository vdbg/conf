@echo off

setlocal

set force=no

if "%~2" neq "" goto :badArgs
if "%~1" equ "" goto :doneArgs

if /i "%~1" equ "--force" (
	set force=yes
	goto :doneArgs
)

goto :badArgs

:doneArgs

set Shells=%~d0\Shell
set wdir=%~d0
if not exist "%Shells%" mkdir "%Shells%"

rem VS
for /F "tokens=1,* delims==" %%I in ( 'set VS ^| findstr COMNTOOLS' ) do call :addVS "%%I" "%%J"

rem cmd
call :createShortcut cmd64 "%comspec%"
call :createShortcut cmd32 "%WINDIR%\SysWOW64\cmd.exe"

rem PS
set ps="%windir%\system32\WindowsPowerShell\v1.0\powershell.exe"
call :createShortcut PS "%ps%"

rem Git
call :createShortcut "Git Bash" "%ProgramFiles%\Git\git-bash.exe" --cd-to-home

rem Azure
call :createPSShortcut "%ProgramFiles(x86)%\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\ShortcutStartup.ps1" "Azure PS"
call :createPSShortcut "%~d0\apps\Ev2PSClient\AzureServiceDeployClient.ps1" "Azure SD"

rem Exchange
call :copyShortcut "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\programs\Microsoft Exchange Server 2016\Exchange Management Shell.lnk" Exchange

rem ConEmu
call :createShortcut "ConEmu" "%ProgramFiles%\ConEmu\ConEmu64.exe"

rem Moba
call :createShortcut "Moba" "%ProgramFiles(x86)%\Mobatek\MobaXterm Personal Edition\MobaXterm.exe"


goto :eof

:addVS
	set VS=%~1
	set VS=%VS:~2,2%
	set vsScript=%~2\vsvars32.bat
	if not exist "%vsScript%" (
		echo VS%VS% script not found
		goto :eof
	)
	
	call :createShortcut "VS%VS%" "%comspec%" "/k '%~2\vsvars32.bat' " 
	goto :eof
	
:createShortcut
	set Shell=%Shells%\%~1.lnk
	if "%force%" equ "yes" del /f /q "%Shell%" > nul 2>&1
	if exist "%Shell%" goto :eof
	if not exist "%~2" goto :eof
	
	cscript /nologo "%~dp0CreateShortcut.vbs" "%Shells%" "%wdir%" %*
	goto :eof

:createPSShortcut
	set ps1=%~1
	if exist "%ps1%" call :createShortcut "%~2" "%ps%" "-NoExit -ExecutionPolicy Bypass -File '%ps1%' "
	goto :eof

:copyShortcut
	set src=%~1
	set dst=%~2
	if not exist "%src%" goto :eof
	set Shell=%Shells%\%dst%.lnk
	if "%force%" equ "yes" del /f /q "%Shell%" > nul 2>&1
	if exist "%Shell%" goto :eof
	echo Creating %Shell%
	copy /y "%src%" "%Shell%" > nul
	echo.	DONE
	goto :eof
	
:badArgs
	echo usage: %~n0 [--force]
	exit /b 1

