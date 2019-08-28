#PA Ticketing Alias
$Alias = "DLIPAAll@microsoft.com"

#Get Date
$Date = get-date -format 'yyyy-MM-dd'

#SMTP Server Info
$ExchangeServer = "CoreSMTP.corp.microsoft.com"
$FromAddress = "DLIPAAll@microsoft.com"

#Import from CSV
$Alerts = Import-CSV -Path HighPriScom.csv
Write-Host $Alerts

#SendMail to each alias
Foreach ($Alert in $Alerts){
    $Machine = $Alert.Machine
    #$Open = $Alert.ResolutionState       #Remarked out until needed
    #$Sev = $Alert.Severity               #Remarked out until needed
    $Time = $Alert.TimeRaised
    $Title = $Alert.AlertStringName
    #$Description = $Alert.AlertStringDescription      #Remarked out until needed

    $EmailBody = @"

    $Alias,

    The following machine $Machine has generated a critical $Title Alert at the following time $Time.  Please take immediate action to view the SCOM alert on the web console and take steps to remediate. 

    Thank you for your attention,

    SCOM Alerts System

"@

    Write-Host "Sending Ticket to $Alias for $Machine" -ForegroundColor Green
    Send-MailMessage -to $Alias -bcc v-brians@microsoft.com -subject "SCOM Alert $Date" -Body $EmailBody -Priority High -SmtpServer $ExchangeServer -Port 25 -From $FromAddress

}