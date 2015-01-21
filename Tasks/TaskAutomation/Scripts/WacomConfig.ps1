# Grabs the control type (Load, Create)
$mode = $args[0]

# Grabs the input as a file name (includes path)
$configFile = $args[1]


if($mode -eq "Load")
{
	# Stops the Tablet Service
	Stop-Service TabletServiceWacom

	# Deletes the current configuration file
	Remove-Item C:\Users\Administrator\AppData\Roaming\WTablet\Wacom_Tablet.dat

	# Copies the desired file to the configuration location
	Copy-Item $configFile C:\Users\Administrator\AppData\Roaming\WTablet\Wacom_Tablet.dat

	# Restarts the tablet service...which reloads the configuration
	Start-Service TabletServiceWacom

	# Writes the selected file to the console.
	Write-Host $configFile
}
elseif($mode -eq "Create")
{
	# Gets the current directory location
	$currentDir = Get-Location
	
	# Changes directory to the Wacom program folder and starts the Professional_CPL.exe program
	# Professional_CPL.exe is the utility to adjust the configuration file
	cd C:\'Program Files'\Tablet\Wacom
	Invoke-Item .\Professional_CPL.exe
	
	# Changes directory back to where the program started
	cd $currentDir
	
	# Grabs a list of the currently running processes that start with 'p' or 'P'
	$currentProcesses = Get-Process [pP]* | Select-Object ProcessName
	
	# Initializes the programExists boolean as false
	$programExists = $FALSE
	
	# Scans through all of the current processes and looks for the process Professional_CPL.exe
	# If that program exists create TRUE boolean.
	foreach($process in $currentProcesses)
	{
		if($process.ProcessName -eq "Professional_CPL")
		{
			$programExists = $TRUE
		}
	}

	# This loop will run for as long as the program is running. And will pause 1 second between checks
	while($programExists)
	{
		# Grabs a list of the currently running processes that start with 'p' or 'P'
		$currentProcesses = Get-Process [pP]* | Select-Object ProcessName
	
		# Resets the programExists boolean as false
		$programExists = $FALSE
	
		foreach($process in $currentProcesses)
		{
			if($process.ProcessName -eq "Professional_CPL")
			{
				$programExists = $TRUE
			}
		}
		
		Start-Sleep -m 1000
	}
	
	# Pauses the script for 0.5 seconds to allow Professional_CPL.exe to close gracefully.
	Start-Sleep -m 500

	# Stops the Tablet Service
	Stop-Service TabletServiceWacom

	# Copies the new configuration file to the repo PatientCart as a new name
	Copy-Item C:\Users\Administrator\AppData\Roaming\WTablet\Wacom_Tablet.dat $configFile

	# Restarts the tablet service...which reloads the configuration
	Start-Service TabletServiceWacom

	# Writes the selected file to the console.
	Write-Host $configFile

}
else{ Write-Host "Error, can't parse mode: $mode" }

#Forcefully exits the script AND PowerShell
exit
