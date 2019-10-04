#PA Ticketing Alias
$Alias = "tcktpascom@microsoft.com"

#Get Date
$Date = get-date -format 'yyyy-MM-dd'

#SMTP Server Info
$ExchangeServer = "CoreSMTP.corp.microsoft.com"
$FromAddress = "DLIPAAll@microsoft.com"


## New logic for gathering Alerts without using SQL query
Get-SCOMAlert -Criteria "ResolutionState!='255' AND Severity='2' AND Priority>='0' AND TimeRaised> '$((get-date).addMinutes(-90))'" | Sort TimeRaised -Descending| Select TimeRaised, MonitoringObjectPath, MonitoringObjectDisplayName, name, severity, priority, ResolutionState, RepeatCount |
export-csv C:\All-Alerts.txt -notype

#Import from CSV
$Alerts = Import-CSV -Path C:\All-Alerts.txt
#Write-Host $Alerts

#SendMail to each alias
Foreach ($Alert in $Alerts){
    $Time = $Alert.TimeRaised
    $MachineName = $Alert.MonitoringObjectPath
    $DisplayName = $Alert.MonitoringObjectDisplayName
    $Title = $Alert.Name
    $Sev = $Alert.Severity
    $Priority = $Alert.Priority
    $Open = $Alert.ResolutionState
    $Repeat = $Alert.RepeatCount

    $EmailBody = @"
    
    
    @$Alias<br>
    <br>
  
    The following machine <font color="red"><b>[$DisplayName]</b></font> has generated a critical <font color="red"><b>[$Title]</b></font> Alert at the following time <font color="red"><b>[$Time]</b></font>.<br>
    Please take immediate action to view the SCOM alert on the <a href="http://pascomconsole.redmond.corp.microsoft.com/OperationsManager/default.aspx?ViewType=AlertView&ViewID=8db1f5a7-f3f3-2646-6c6b-e34672f7ed98">Web Console</a> and take steps to remediate.<br>  
    This machine has generated this alert <font color="red"><b>[$Repeat]</b></font> times<br>
    <br>
    Thank you for your attention,<br>
    <br>
    SCOM Alerts System<br>

    <p><small>For issues with this mail contact v-jawel@microsoft.com</small></p>
    <p><small>Version 1.0</small></p>


"@

    Write-Host "Sending Ticket to $Alias for $DisplayName" -ForegroundColor Green
    Send-MailMessage -to $Alias -bcc v-jawel@microsoft.com, v-cadams@microsoft.com -subject "SCOM Alert for $DisplayName, $Title, $Date" -BodyAsHtml -Body $EmailBody -Priority High -SmtpServer $ExchangeServer -Port 25 -From $FromAddress

}