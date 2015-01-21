
# Grabs the input as a complete path and file name
$configFile = $args[0]

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