@echo off
setlocal

set target_root=f:\apps\bin
call :ensure_target || exit /b 1
set cmd_args=

call :set_link false git		"%ProgramFiles%\Git\cmd\git.exe" "%ProgramFiles%\Git\mingw64\bin\git.exe" "%ProgramFiles%\Git\bin\git.exe" "%ProgramFiles(x86)%\Git\bin\git.exe"
call :set_link false start-ssh-agent	"%ProgramFiles%\Git\cmd\start-ssh-agent.cmd"
call :set_link false py			"%ProgramFiles(x86)%\Python 3.5\python.exe" "%ProgramFiles(x86)%\Python35-32\python.exe"
call :set_link false pip		"%ProgramFiles(x86)%\Python 3.5\Scripts\pip.exe" "%ProgramFiles(x86)%\Python35-32\Scripts\pip.exe"
call :set_link true npp			"%ProgramFiles%\Notepad++\notepad++.exe" "%ProgramFiles(x86)%\Notepad++\notepad++.exe" "%windir%\system32\notepad.exe" "%windir%\notepad.exe"
call :set_link true windbg		"%SystemDrive%\debuggers\windbg.exe"
call :set_link true ewseditor	"%~d0\Apps\EWSEditor 1.17 - bin\EWSEditor.exe" "%~d0\Apps\EWSEditor 1.13 - bin\EWSEditor.exe"
call :set_link true ie			"%ProgramFiles%\Internet Explorer\iexplore.exe"
call :set_link true stylecopeditor "%ProgramFiles(x86)%\StyleCop 4.7\StyleCopSettingsEditor.exe"
call :set_link true snip			"%WINDIR%\system32\snippingtool.exe"
call :set_link true fiddler		"%ProgramFiles(x86)%\Fiddler2\Fiddler.exe"
call :set_link true ilspy		"%~d0\Apps\ILSpy\ILSpy.exe"
call :set_link true xts			"%~d0\Apps\xts\xts.exe"
call :set_link true chrome		"%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
call :set_link true paint		"%ProgramFiles%\Paint.NET\PaintDotNet.exe" "%windir%\system32\mspaint.exe"
call :set_link true rdm			"%ProgramFiles(x86)%\RedisDesktopManager\rdm.exe"
call :set_link true sourcetree		"%ProgramFiles(x86)%\Atlassian\SourceTree\SourceTree.exe"
call :set_link true azexplore		"%ProgramFiles(x86)%\Microsoft Azure Storage Explorer\StorageExplorer.exe"
call :set_link true moba		"%ProgramFiles(x86)%\Mobatek\MobaXterm Personal Edition\MobaXterm.exe"
call :set_link true pdf			"%~d0\Choco\bin\SumatraPDF.exe"
call :set_link true code		"%ProgramFiles%\Microsoft VS Code\Code.exe" "%ProgramFiles(x86)%\Microsoft VS Code\bin\code.cmd"
call :set_link false node		"%ProgramFiles%\nodejs\node.exe"
call :set_link false npm		"%ProgramFiles%\nodejs\npm.cmd"


set cmd_args=--processStart "slack.exe"
call :set_link true slack "%LOCALAPPDATA%\slack\Update.exe"
set cmd_args=

goto :eof

:ensure_target
	if exist "%target_root%" exit /b 0
	mkdir "%target_root%"
	if not exist "%target_root%" exit /b 1
	exit /b 0

:set_link
	set is_ui=%~1
	shift
	set link_name=%target_root%\%~1.cmd
	shift
	
	:loop_dest
	set link_dest=%~1
	if not defined link_dest goto :eof
	rem echo Checking: %link_dest%
	
	shift
	if not exist "%link_dest%" goto :loop_dest

	echo Creating link %link_dest% =^> %link_name%	
	if /i "%is_ui%" equ "true" echo @start "" "%link_dest%" %cmd_args% %%^* > "%link_name%"
	if /i "%is_ui%" neq "true" echo @"%link_dest%" %cmd_args% %%^* > "%link_name%"
	
	goto :eof

