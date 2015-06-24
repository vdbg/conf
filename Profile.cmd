@echo off
if defined profile_loaded goto :eof
set profile_loaded=true

if exist f:\apps\bin set PATH=f:\apps\bin:%PATH%
if exist f:\git\prog\batch set PATH=f:\git\prog\batch:%PATH%

prompt $M$P$G

set gitexe="C:\Program Files (x86)\Git\bin\git.exe"

rem Red background if admin 
cacls "%systemroot%\system32\config\system" > nul 2> nul && color 4F

if exist "%~dp0\aliases.doskey" doskey /EXENAME=cmd.exe /MACROFILE="%~dp0\aliases.doskey"

if not exist "C:\Program Files\R\R-3.1.3" goto :noR

set RHOME=C:\Program Files\R\R-3.1.3
set RPATH=C:\Program Files\R\R-3.1.3
set PATH=%RHOME%\bin\x64;%PATH%

if not exist "%RPATH%\lib\x64" mkdir "%RPATH%\lib\x64"
if not exist "%RPATH%\lib\x64\R.lib" copy "%~dp0\R.lib" "%RPATH%\lib\x64\R.lib"

if exist "f:\svn\bigAnalytics\trunk" set RXSVNROOT=f:\svn\bigAnalytics\trunk
if exist "f:\git\RRE-Pull\bigAnalytics" set bigAnalytics_git=f:\git\RRE-Pull\bigAnalytics
if defined RXSVNROOT set ENABLE_RXSQL_TEST=true

:noR

