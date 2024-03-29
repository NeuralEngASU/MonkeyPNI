# Get parameters to pass to script
# $program can be a full path including name with extension, the program name with extension, or the processid
Param([string]$computername=$env:computername,[string]$program)

# Determine if $program is a processid or name
[reflection.assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
$programtype = [Microsoft.VisualBasic.Information]::isnumeric($program)

# Get process
if ($programtype) {
	# $program is a numeric processid
	$process = get-wmiobject -class win32_process -computername $computername -filter "processid='$program'"
}
else {
	# $program is a name
	# Need to make sure we only use the name and not the full path
	$progObj = [regex]::match($program,"[^\\/]+$")
	$program = $progObj.value
	$process = get-wmiobject -class win32_process -computername $computername -filter "name='$program'"
}

if ($process) {
    $resultObj = $process.terminate()
	$result = $resultObj.returnvalue
	if ($result -eq 0) {
		# Process stopped successfully
		Write-Host "processid: $processid`nresult: 0"
	}
	else {
		# Process could not be stopped
		Write-Host "processid: $processid`nresult: -1"
	}
}
else {
    # Process does not exist
    Write-Host "processid: $processid`nresult: -2"
}