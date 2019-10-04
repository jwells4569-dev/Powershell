
##Get Alerts from last X days

$TimeFrame = Read-Host -Prompt 'Input your time frame'

Get-SCOMAlert -Criteria "ResolutionState!='255' AND Severity='2' AND Priority>='0' AND TimeRaised> '$((get-date).adddays(-$TimeFrame))'" | Sort TimeRaised -Descending| Select TimeRaised, MonitoringObjectPath, MonitoringObjectDisplayName, name, severity, priority, ResolutionState, RepeatCount


##Clear the Alert
Write-Host "Alert Clearing Script"

$AlertName = Read-Host -Prompt 'Input your Complete Alert Name'

$ResolutionState = Read-Host -Prompt 'Input your Resolution State'

Get-SCOMAlert -Name "$AlertName" | Set-SCOMAlert -ResolutionState $ResolutionState



