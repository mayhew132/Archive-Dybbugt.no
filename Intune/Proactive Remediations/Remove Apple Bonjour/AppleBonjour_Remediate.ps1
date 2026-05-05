# Event Log Details
    $sourceName = "Intune Proactive Remediations"
    $logName = "Application"
 
    # Check if the event source exists, and create it if it doesn't
    if (-not [System.Diagnostics.EventLog]::SourceExists($sourceName)) {
        New-EventLog -LogName $logName -Source $sourceName
        Write-Host "Event source created successfully."
    } else {
        Write-Host "Event source already exists."
    }

# Remediate - uninstall bonjour if found to be installed

$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -contains "Bonjour" }

 if ($app -ne $null) {
	$Uninstall = $app.Uninstall() 
    if ($? -eq "True"){
    Write-EventLog -LogName $logName -Source $sourceName -EventID 100 -EntryType Information -Message "Apple Bonjour Uninstalled."
    Write-Output "Apple Bonjour Uninstalled."
    } else {
        Write-EventLog -LogName $logName -Source $sourceName -EventID 400 -EntryType Error -Message "Apple Bonjour Uninstall failed"
        Write-output "Apple Bonjour Uninstall failed"
        }
} else {
    Write-EventLog -LogName $logName -Source $sourceName -EventID 100 -EntryType Information -Message "Apple Bonjour not found."
	Write-Output "Apple Bonjour not found."
}
