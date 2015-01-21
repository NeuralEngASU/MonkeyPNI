IPAddress = WScript.Arguments.Item(0) 'IP Address to the remote computer (i.e. 155.101.184.62 or localhost)
ProgramPath = WScript.Arguments.Item(1) 'Full path of program to start (i.e. C:\FingerPressRT.exe)

Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & IPAddress & "\root\cimv2")
Set objProcess = objWMIService.Get("Win32_Process")
errReturn = objProcess.Create(ProgramPath, null, null, intProcessID)

If errReturn = 0 Then
    Wscript.Echo ProgramPath & " was started with a process ID: " & intProcessID
Else
    Wscript.Echo ProgramPath & " could not be started due to an error"
End If