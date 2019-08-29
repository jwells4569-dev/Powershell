#PA Ticketing Alias
$Alias = "tcktpascom@microsoft.com"

#Get Date
$Date = get-date -format 'yyyy-MM-dd'

#SMTP Server Info
$ExchangeServer = "CoreSMTP.corp.microsoft.com"
$FromAddress = "DLIPAAll@microsoft.com"

#Import from CSV
$Alerts = Import-CSV -Path C:\HighPriScom.csv
#Write-Host $Alerts

#SendMail to each alias
Foreach ($Alert in $Alerts){
    $Machine = $Alert.Machine
    #$Open = $Alert.ResolutionState
    $Time = $Alert.TimeRaised
    $Title = $Alert.AlertStringName
    #$Description = $Alert.AlertStringDescription
    $Repeat = $Alert.RepeatCount

    $EmailBody = @"
    
    
    @$Alias<br>
    <br>
  
    The following machine <font color="red"><b>[$Machine]</b></font> has generated a critical <font color="red"><b>[$Title]</b></font> Alert at the following time <font color="red"><b>[$Time]</b></font>.<br>
    Please take immediate action to view the SCOM alert on the <a href="http://pascomconsole.redmond.corp.microsoft.com/OperationsManager/default.aspx?ViewType=AlertView&ViewID=8db1f5a7-f3f3-2646-6c6b-e34672f7ed98">Web Console</a> and take steps to remediate.<br>  
    This machine has generated this alert <font color="red"><b>[$Repeat]</b></font> times<br>
    <br>
    Thank you for your attention,<br>
    <br>
    SCOM Alerts System<br>

    <p><small>For issues with this mail contact v-jawel@microsoft.com</small></p>
    <p><small>Version 1.0</small></p>


"@

    Write-Host "Sending Ticket to $Alias for $Machine" -ForegroundColor Green
    Send-MailMessage -to $Alias -bcc v-jawel@microsoft.com, v-cadams@microsoft.com -subject "SCOM Alert for $Machine, $Title, $Date" -BodyAsHtml -Body $EmailBody -Priority High -SmtpServer $ExchangeServer -Port 25 -From $FromAddress

}