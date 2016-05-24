@echo off
setlocal

set target_root=f:\apps\bin
call :set_link git			"%ProgramFiles%\Git\mingw64\bin\git.exe" "%ProgramFiles%\Git\bin\git.exe" "%ProgramFiles(x86)%\Git\bin\git.exe" 
call :set_link py			"%ProgramFiles(x86)%\Python 3.5\python.exe" "%ProgramFiles(x86)%\Python35-32\python.exe" 
call :set_link npp			"%ProgramFiles(x86)%\Notepad++\notepad++.exe" "%windir%\system32\notepad.exe" "%windir%\notepad.exe"
call :set_link windbg		"%SystemDrive%\debuggers\windbg.exe"
call :set_link ewseditor	"%~d0\Apps\EWSEditor 1.13 - bin\EWSEditor.exe"
call :set_link ie			"%ProgramFiles%\Internet Explorer\iexplore.exe"
call :set_link stylecopeditor "%ProgramFiles(x86)%\StyleCop 4.7\StyleCopSettingsEditor.exe"
call :set_link snip			"%WINDIR%\system32\snippingtool.exe"
call :set_link fiddler		"%ProgramFiles(x86)%\Fiddler2\Fiddler.exe"
call :set_link ilspy		"%~d0\Apps\ILSpy\ILSpy.exe"
call :set_link xts			"%~d0\Apps\xts\xts.exe"
call :set_link chrome		"%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"

goto :eof

:set_link
	set link_name=%target_root%\%~1.cmd
	shift
	
	:loop_dest
	set link_dest=%~1
	if not defined link_dest goto :eof
	rem echo Checking: %link_dest%
	
	shift
	if not exist "%link_dest%" goto :loop_dest

	echo Creating link %link_dest% =^> %link_name%	
	echo @"%link_dest%" %%^* > "%link_name%"
	
	goto :eof

