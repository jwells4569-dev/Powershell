<#
.Synopsis
This script checks the Windows 'System' event log (SEL) and sends mail if it finds specific EventIDs within a set period of time.  This is meant to run as a scheduled task with "At Startup" as the trigger, so that it effectively sends mail after every reboot.

.Description
This script checks the Windows 'System' event log (SEL) and sends mail if it finds specific EventIDs within a set period of time.  This is meant to run as a scheduled task with "At Startup" as the trigger, so that it effectively sends mail after every reboot.

.Example
Send-CE_RebootAlert

.Link
https://microsoft.visualstudio.com/ESOps/_git/Ops.CETools

.Notes
    Written by Jim Wells (Design Labratory Inc), v-jawel@microsoft.com
    Modified by Jonathan Powell (Design Labratory Inc), v-jonpow@microsoft.com
    Last edit:  10/16/2019

    Suggested Scheduled Task config:
        -General:
            *Configure to run as a domain account w/ local admin rights
            *Run whether user is logged on or not
            *Run with highest privileges
        -Triggers:
            *At Startup
        -Actions:
            *Start a program -- powershell.exe -command "<local path to script>"
        -Conditions:
            *Start only if the follow network connection is available:  Any connection
        -Settings:
            *Allow task to be run on demand
            *Run task as soon as possible after a scheduled start is missed
            *If the task fails, restart every:  5 minutes
            *Attempt to restart up to:  3 times
            *Stop the task if it runs longer than:  1 hour
            *If the running task does not end when requested, force it to stop
            *If the task is already running, the the following rule applies:  Do not start a new instance
#>


#Setting variables for the script:
#$Alias = "tktcefun@microsoft.com"
#$Alias2 = "Andrew.Richards@microsoft.com"
$Alias = "cefundsup@microsoft.com"
$Alias2 = "v-jonpow@microsoft.com"

#Get Date
$Date = get-date 

#SMTP Server Info
$ExchangeServer = "CoreSMTP.corp.microsoft.com"
$FromAddress = "cetkt@microsoft.com"

#Get Date
$Begin = (get-date).AddMinutes(-15) 
$End = (get-date).AddMinutes(15)

#ComputerName
$Computer = $env:computername

#Error Array
[array]$ErrorArray = @("12","41","1001","1074","1076","6005","6006","6008","6009")


#Find reboot/startup events by EventID (when matching the $ErrorArray elements), then export to .CSV:
$EventLogScrape = get-eventlog -ComputerName "$Computer" -Log System -After $Begin -Before $End
Foreach ($Event in $EventLogScrape)
{
    if ($ErrorArray -contains $Event.EventID)
    {
        $Event | Select-Object -Property Source, EventID, InstanceId, Message | Export-CSV -Path "C:\Events.csv" -NoTypeInformation -Append -Force
    }
}

#Imports results from CSV
$Alerts = Import-CSV -Path "C:\Events.csv" #We export to .CSV so that it can be sent as an attachment if needed, otherwise a simple PSObject would suffice.


#Indexes the applicable Event ID #s for the reboot/startup in question from the past ~15 minutes:
Foreach ($Alert in $Alerts)
{
    [string]$EventID = $Alert.EventID + ', '
    [string]$EventIDString += $EventID
}
$EventIDString = $EventIDString.TrimEnd(', ')

#Defines the e-mail body (Customer copy):
$EmailBody = @"

    $Alias2,<br>
    <br>

    The following machine <font color="red"><b>[$Computer]</b></font> has generated Events <font color="red"><b>[$EventIDString]</b></font> Reboot Alert at the following time <font color="red"><b>[$Date]</b></font>.<br>
    <br>
    Thank you for your attention,<br>
    <br>
    Reboot Alerts System<br>

    <p><small>For issues with this mail contact cefundsup@microsoft.com</small></p>
    <p><small>Version 1.01</small></p>

"@

#Sends mail to $Alias2 (Customer):
Send-MailMessage -to $Alias2 -subject "Reboot Alert for $Computer, $Date" -BodyAsHtml -Body $EmailBody -Priority High -SmtpServer $ExchangeServer -Port 25 -From $FromAddress
Start-Sleep -Seconds 10

#Defines the e-mail body (Ops copy):
$EmailBody2 = @"

    $Alias,<br>
    <br>

    The following machine <font color="red"><b>[$Computer]</b></font> has generated Events <font color="red"><b>[$EventIDString]</b></font> Reboot Alert at the following time <font color="red"><b>[$Date]</b></font>.<br>
    <br>
    Thank you for your attention,<br>
    <br>
    Reboot Alerts System<br>

    <p><small>For issues with this mail contact cefundsup@microsoft.com</small></p>
    <p><small>Version 1.01</small></p>

"@

#Sends mail to $Alias (Ops):
Send-MailMessage -to $Alias -subject "Reboot Alert for $Computer, $Date" -BodyAsHtml -Body $EmailBody2 -Priority High -SmtpServer $ExchangeServer -Port 25 -From $FromAddress
Start-Sleep -Seconds 5

#Cleanup:
remove-item -path C:\Events.csv -force -ErrorAction SilentlyContinue