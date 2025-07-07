# Remediation to control Fast Startup

Remediation will check if Fast Startup is enabled.\
If it is detected as enabled/or missing from registry, remediation will configure it to Disabled status.\
Script also creates a new Event Log Source "Intune Proactive Remediations" to make loggins more accessible\
The log source uses 100,200,400 as EventIDs\
100=information, 200=warning 400=error

Set "Run script in 64-bit PowerShell" to Yes when deploying the scripts in intune. 

# FastStartup_Detect
Script for detection

# FastStartup_Remediation
Script for remediation