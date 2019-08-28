#Get Date
$Date = get-date -format 'yyyy-MM-dd'

#SMTP Server Info
$ExchangeServer = "CoreSMTP.corp.microsoft.com"
$FromAddress = "v-jawel@microsoft.com"

#Import from CSV
$Users = Import-CSV -Path MailList.csv

#SendMail to each alias
Foreach ($User in $Users){
    $ToAddress = $User.Email
    $Alias = $User.Alias
    $EmailBody = @"

    $Alias,

    Setting up WSUS Deadlines for $Alias for the monthly Cosine Patch outage.

"@

    Write-Host "Sending Ticket to $Alias($ToAddress)" -ForegroundColor Green
    Send-MailMessage -to $User.Email -subject "Compliance Work $Date" -Body $EmailBody -SmtpServer $ExchangeServer -Port 25 -From $FromAddress

}