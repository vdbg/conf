@echo off
if defined profile_loaded goto :eof
set profile_loaded=true

call :add_path %~d0\apps\bin
call :add_path %~d0\apps\bin\sysinternals
call :add_path %~d0\git\prog\batch

prompt $+$M$P$G

call :set_if_exists gitexe "%ProgramFiles%\Git\bin\git.exe"
call :set_if_exists gitexe "%ProgramFiles(x86)%\Git\bin\git.exe"
call :set_if_not_set gitexe git

call :set_if_exists pyexe "%ProgramFiles(x86)%\Python 3.5\python.exe" python
call :set_if_exists nppexe "%ProgramFiles(x86)%\Notepad++\notepad++.exe" notepad.exe
call :set_if_exists windbgexe "%SystemDrive%\debuggers\windbg.exe" windbg.exe
call :set_if_exists ewseditorexe "%~d0\Apps\EWSEditor 1.13 - bin\EWSEditor.exe" ewseditor.exe
call :set_if_exists stylecopeditorexe "%ProgramFiles(x86)%\StyleCop 4.7\StyleCopSettingsEditor.exe" StyleCopSettingsEditor.exe
call :set_if_exists fiddlerexe "%ProgramFiles(x86)%\Fiddler2\Fiddler.exe" fiddler.exe
call :set_if_exists ilspyexe "%~d0\Apps\ILSpy\ILSpy.exe" ilspy.exe

set SVN_EDITOR=notepad

rem Red background if admin 
cacls "%systemroot%\system32\config\system" > nul 2> nul && color 4F

if exist "%~dp0\aliases.doskey" doskey /EXENAME=cmd.exe /MACROFILE="%~dp0\aliases.doskey"

call :set_if_exists RHOME "%ProgramFiles%\R\R-3.2.2"
call :set_if_exists RHOME "%ProgramFiles%\R\R-3.1.3"
if defined RHOME call :add_path "%RHOME%\bin\x64"

goto :eof

:add_path
	if not exist "%~1" goto :eof
	set PATH=%~1;%PATH%
	goto :eof
	
:set_if_exists
	if defined %1 goto :eof
	if not exist "%~2" goto :not_exists
	set %1=%~2
	goto :eof
:not_exists
	if "%~3" equ "" goto :eof
	set %1=%~3
	goto :eof
	

:set_if_not_set
	if defined %1 goto :eof
	set %1=%~2
	goto :eof
