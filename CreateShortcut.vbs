
If WScript.Arguments.Count <> 5 And WScript.Arguments.Count <> 4 Then
  WScript.Echo "usage: CreateShortcut.vbs shortcutdir workingdir shortcutfile target [arguments]"
  WScript.Echo "Argument count: " & WScript.Arguments.Count & ";" & WScript.Arguments.Item(WScript.Arguments.Count -1)
  WScript.Quit
End If
 
set ws = WScript.CreateObject("WScript.Shell")
linkFile = WScript.Arguments.Item(0) & "\" & WScript.Arguments.Item(2) & ".lnk"

WScript.Echo("Creating "+linkFile)
set link = ws.CreateShortcut(linkFile)

target = WScript.Arguments.Item(3)
WScript.Echo("	Target: " + target)
link.TargetPath = target

wdir = WScript.Arguments.Item(1)
WScript.Echo("	Working dir: " + wdir)
link.WorkingDirectory = wdir

If WScript.Arguments.Count = 5 Then
  arguments = WScript.Arguments.Item(4)
  arguments = Replace(arguments, "'", """")
  link.Arguments = arguments
  WScript.Echo("	Arguments: " + arguments)
End If
'	link.IconLocation = "NYI"
link.Save
WScript.Echo("	DONE")

