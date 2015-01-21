IPAddress = WScript.Arguments.Item(0) 'IP Address to the remote computer (i.e. 155.101.184.62 or localhost)
Process = WScript.Arguments.Item(1) 'PID or name of process to stop (i.e. 8159 or FingerPressRT.exe)

Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & IPAddress & "\root\cimv2")

If IsNumeric(Process) Then
    Set colProcessList = objWMIService.ExecQuery ("Select * from Win32_Process Where processid = '" & Process & "'")
Else
    Set colProcessList = objWMIService.ExecQuery ("Select * from Win32_Process Where name = '" & Process & "'")
End If

If colProcessList.Count = 0 Then
    Wscript.Echo "missing"
Else
    Wscript.Echo "exists"
End If