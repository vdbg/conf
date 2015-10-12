@echo off

setlocal
set Shells=%~d0\Shell
set wdir=%~d0
if not exist "%Shells%" mkdir "%Shells%"

rem VS
for /F "tokens=1,* delims==" %%I in ( 'set VS ^| findstr COMNTOOLS' ) do call :addVS "%%I" "%%J"

rem cmd
call :createShortcut cmd64 "%comspec%" "%~d0"
call :createShortcut cmd32 "%WINDIR%\SysWOW64\cmd.exe" "%~d0"

rem PS
set ps="%windir%\system32\WindowsPowerShell\v1.0\powershell.exe"
call :createShortcut PS "%ps%" "%~d0" 

rem Azure
set azureps=%ProgramFiles(x86)%\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\ShortcutStartup.ps1
if exist "%azureps%" call :createShortcut AzurePS "%ps%" "%wdir%" "-NoExit -ExecutionPolicy Bypass -File '%azureps%' "

goto :eof

:addVS
	set VS=%~1
	set VS=%VS:~2,2%
	set vsScript=%~2\vsvars32.bat
	if not exist "%vsScript%" (
		echo VS%VS% script not found
		goto :eof
	)
	
	call :createShortcut "VS%VS%" "%comspec%" "%wdir%" "/k '%~2\vsvars32.bat' " 
	goto :eof
	
:createShortcut
	if exist "%Shell%\%~1.lnk" goto :eof
	if not exist "%~2" goto :eof
	
	cscript /nologo "%~dp0CreateShortcut.vbs" "%Shells%" %*
	goto :eof



	
	



