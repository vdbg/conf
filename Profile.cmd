@echo off
if defined profile_loaded goto :eof
set profile_loaded=true

if exist f:\apps\bin set PATH=f:\apps\bin:%PATH%
prompt $M$P$G

set gitexe="C:\Program Files (x86)\Git\bin\git.exe"

rem Red background if admin 
cacls "%systemroot%\system32\config\system" > nul 2> nul && color 4F

if exist "%~dp0\aliases.doskey" doskey /EXENAME=cmd.exe /MACROFILE="%~dp0\aliases.doskey"