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

# Add config if missing or wrong   
    if (($TestForFastStartup -eq "1") -or $TestForFastStartup -eq $null )
     {        
        Write-EventLog -LogName $logName -Source $sourceName -EventID 200 -EntryType Warning -Message "Fast Startup Enabled, or registry item for FastStartup, 'HiberBootEnabled' is missing. Intune Remediation will attempt to create entry with value of 0 (Disabled) in registry key: '$Searchpath'"
        Set-ItemProperty -Path $SearchPath -Name "HiberBootEnabled" -Value "0" -Type DWORD -force
        if ($? -eq $True) {
            Write-EventLog -LogName $logName -Source $sourceName -EventID 100 -EntryType Information -Message "Intune Remediation succesfully added configuration for FastStartup, 'HiberBootEnabled', with value of '0' in registry key '$searchpath'"
        } else {
            Write-EventLog -LogName $logName -Source $sourceName -EventID 400 -EntryType Error -Message "Intune Remediation failed to add configuration for FastStartup, 'HiberBootEnabled', with value of '0' in registry key '$searchpath'!"
        }
     }
     else
     {
        Write-EventLog -LogName $logName -Source $sourceName -EventID 100 -EntryType Information -Message "Intune Remediation was run to disable FastStartup, but no change was needed"
     }

