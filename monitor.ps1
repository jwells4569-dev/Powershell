## v-jawel (Jim Wells Design Labratory Inc)



#############Variables######################
#To Alias 
$Alias = ""

#Get Date
$Date = get-date 

#SMTP Server Info
$ExchangeServer = "CoreSMTP.corp.microsoft.com"
$FromAddress = ""

#Import from CSV
$Alerts = Import-CSV -Path "C:\Events.csv"
#Write-Host $Alerts Debugging line to read CSV

#Get Date
$Begin = (get-date).AddMinutes(-15) 
$End = (get-date).AddMinutes(15)

#ComputerName
$Computer = $env:computername
#################Varibles End###############



#############Find-Error#################################################
## Loops through error array to find Instances of each error on startup
## Writes a CSV containing each Error found storing it on 
## C:\ to send as attachment and to be read by the Mail Sender
########################################################################

#Error Array
[array]$ErrorArray = @("12","41","1001","1074","1076","6005","6006","6008","6009","7036")

foreach ($element in $ErrorArray) 
{
#Write-Host "Analysing Event Log" Debug line to show each loop through each Array Entry
$Event = get-eventlog -ComputerName "$Computer" -Log System -After $Begin -Before $End | Where-Object {$_.EventID -eq $element}
$Event | Select-Object -Property Source, EventID, InstanceId, Message | Export-CSV -Path "C:\Events.csv" -NoTypeInformation
}

############End Find-Error################################



##################Send-Mail##########################################
## Loops through each Error found and sends a mail to customer
#####################################################################


#SendMail Customer for each Alert
Foreach ($Alert in $Alerts){
    $Source = $Alert.Source
    $EventID = $Alert.EventID
    $InstanceID = $Alert.InstanceID
    $Message = $Alert.Message
    
 $EmailBody = @"
    
    
    @$Alias<br>
    <br>
  
    The following machine <font color="red"><b>[$Computer]</b></font> has generated Event <font color="red"><b>[$EventID]</b></font> Reboot Alert at the following time <font color="red"><b>[$Date]</b></font>.<br>
    <br>
    Thank you for your attention,<br>
    <br>
    Reboot Alerts System<br>

    <p><small>For issues with this mail contact v-jawel@microsoft.com</small></p>
    <p><small>Version 1.0</small></p>


"@

    #Write-Host "Sending Ticket to $Alias for $Computer" -ForegroundColor Green  Debugging to show tickets going out.
    Send-MailMessage -to $Alias -cc "", "" -subject "Reboot Alert for $Computer, $EventID, $Date" -BodyAsHtml -Body $EmailBody -Priority High  -SmtpServer $ExchangeServer -Port 25 -From $FromAddress

}

######################End Send-Mail Customer########################################
Start-Sleep [60]
######################Send-Mail OPS################################################
$EmailBody2 = @"
    
    
    @$Alias<br>
    <br>
  
    The following machine <font color="red"><b>[$Computer]</b></font> has generated Event <font color="red"><b>[$EventID]</b></font> Reboot Alert at the following time <font color="red"><b>[$Date]</b></font>.<br>
    <br>
    Thank you for your attention,<br>
    <br>
    Reboot Alerts System<br>

    <p><small>For issues with this mail contact v-jawel@microsoft.com</small></p>
    <p><small>Version 1.0</small></p>


"@

Send-MailMessage -to tktcefun@microsoft.com  -subject "Reboot Alert for $Computer, $Date" -BodyAsHtml -Body $EmailBody2 -Priority High -Attachement "C:\Events.csv" -SmtpServer $ExchangeServer -Port 25 -From $FromAddress

Start-Sleep [30]

remove-item -path C:\Events.csv -force -ErrorAction SilentlyContinue

######################End Send-Mail OPS########################################