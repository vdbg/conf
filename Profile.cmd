@echo off
if defined profile_loaded goto :eof
set profile_loaded=true

call :add_path %~d0\apps\bin
call :add_path %~d0\apps\bin\sysinternals
call :add_path %~d0\git\prog\batch

prompt $+$M$P$G

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

