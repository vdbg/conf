@echo off
if defined profile_loaded goto :eof
set profile_loaded=true

call :add_path f:\apps\bin
call :add_path f:\git\prog\batch

prompt $M$P$G

set gitexe="%ProgramFiles(x86)%\Git\bin\git.exe"

rem Red background if admin 
cacls "%systemroot%\system32\config\system" > nul 2> nul && color 4F

if exist "%~dp0\aliases.doskey" doskey /EXENAME=cmd.exe /MACROFILE="%~dp0\aliases.doskey"

if not exist "%ProgramFiles%\R\R-3.1.3" goto :noR

set RHOME=%ProgramFiles%\R\R-3.1.3
set RPATH=%ProgramFiles%\R\R-3.1.3
call :add_path "%RHOME%\bin\x64"

if not exist "%RPATH%\lib\x64" mkdir "%RPATH%\lib\x64"
if not exist "%RPATH%\lib\x64\R.lib" copy "%~dp0\R.lib" "%RPATH%\lib\x64\R.lib"

if exist "f:\svn\bigAnalytics\trunk" set RXSVNROOT=f:\svn\bigAnalytics\trunk
if exist "f:\git\RRE-Pull\bigAnalytics" set bigAnalytics_git=f:\git\RRE-Pull\bigAnalytics
if defined RXSVNROOT set ENABLE_RXSQL_TEST=true

:noR
goto :eof

:add_path
	if not exist "%~1" goto :eof
	set PATH=%~1;%PATH%
	goto :eof
