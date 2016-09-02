@echo off
setlocal
set console_reg=
for /f "tokens=4,5 delims=. " %%i in ('ver') do set console_reg=%%i.%%j
set console_reg=%~dp0Console-%console_reg%.reg
if exist "%console_reg%" goto :file_exists
echo ERROR: could not find %console_reg%.
exit /b 1

:file_exists
echo Importing: %console_reg%
regedit /S "%console_reg%"


