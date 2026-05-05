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

# Detect if bonjour is installed
    $SearchPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall,HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

    $TestForBonjour = Get-ChildItem $($SearchPath -split ",") -Recurse  | Get-ItemProperty | Where-Object {$_.DisplayName -Like "Bonjour" } | Select-Object -ExpandProperty Displayname
    $result = $TestForBonjour -match "Bonjour"

    if ($result)
     {
        Write-EventLog -LogName $logName -Source $sourceName -EventID 200 -EntryType Warning -Message "Bonjour installed, remediation needed"
        Write-Output "Bonjour installed, remediation needed"
        exit 1
     }
     else
     {
        Write-EventLog -LogName $logName -Source $sourceName -EventID 100 -EntryType Information -Message "Bonjour not installed, no change needed"
        Write-Output "Bonjour not installed, no change needed"
        exit 0
     }