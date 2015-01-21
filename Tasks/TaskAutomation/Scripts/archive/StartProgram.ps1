# Grabs parameters passed to script
Param([string]$computername=$env:computername,[string]$cmd)

$ErrorActionPreference="SilentlyContinue"

Trap {
Write-Warning "There was an error connecting to the remote computer or creating the process"
Continue
}    

Write-Host "Connecting to $computername" -ForegroundColor CYAN
Write-Host "Process to create is $cmd" -ForegroundColor CYAN

# Attempts to create an object for the other computer
[wmiclass]$wmi="\\$computername\root\cimv2:win32_process"

# Bails out if the object failed to be created
if (!$wmi) {return}

# Sends the command to the other program
$remote=$wmi.Create($cmd)

if ($remote.returnvalue -eq 0) {
    Write-Host "Successfully launched $cmd on $computername with a processid of" $remote.processid -ForegroundColor GREEN
}
else {
    Write-Host "Failed to launch $cmd on $computername. ReturnValue is" $remote.ReturnValue -ForegroundColor RED
}