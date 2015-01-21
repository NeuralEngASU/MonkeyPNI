# Get parameters to pass to script
Param([string]$computername=$env:computername,[string]$program)

# Get name of program from full path
$progObj = [regex]::match($program,"[^\\/]+$")
$programname = $progObj.value

# Get remote process
$process = get-wmiobject -class win32_process -computername $computername -filter "name='$programname'"

if ($process) {
	# Process already exists
	$processid = $process.processid
	Write-Host "processid: $processid`nresult: 1"
}
else {
	# Create remote process
	$process = invoke-wmimethod -class win32_process -name create -computername $computername -argumentlist $program
	if ($process) {
		# Process created successfully
		$processid = $process.processid
		Write-Host "processid: $processid`nresult: 0"
	}
	else {
		# Process not created
		Write-Host "processid: `nresult: 2"
	}
}

