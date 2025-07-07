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


# Detect if FastStartup is enabled
    $SearchPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
    $TestForFastStartup = Get-ItemPropertyValue $searchpath -Name "HiberBootEnabled"
        
    if (($TestForFastStartup -eq "1") -or $TestForFastStartup -eq $null )
     {
        Write-EventLog -LogName $logName -Source $sourceName -EventID 200 -EntryType Warning -Message "Intune Remediation detected a change as needed for FastStartup Configuration on the device, remediation script will be run."
        exit 1
     }
     else
     {        
        Write-EventLog -LogName $logName -Source $sourceName -EventID 100 -EntryType Information -Message "Intune Remediation checked config for FastStartup, no change was needed."     
        exit 0
     }