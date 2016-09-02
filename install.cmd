@echo off
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /d "%~dp0Profile.cmd" /f
call "%~dp0CreateShortcuts.cmd"
call "%~dp0ConsoleSetup.cmd"

