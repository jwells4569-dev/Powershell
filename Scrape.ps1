## Registry Scraper CE
## Jim Wells v-jawel@microsoft.com 
## 9/23/19
## | Export-CSV C:\CE_ESINV.csv -Append

#Date/Time Stamp
$DateStamp = Get-Date

#$Path = HKLM:\SYSTEM\ESINV

$servers = Get-Content -path C:\computers.txt 

#}
foreach ($server in $servers){

   # [System.Net.Dns]::GetHostByName("$server")| export-csv -path C:\DNS.csv -Append -notypeinformation
    Invoke-Command -ComputerName $Server -Command {Get-ItemProperty -Path 'HKLM:\System\ESInv'}
  
 } 

 #Start-Sleep(90)

 #$Names = Import-Csv -path "C:\DNS.csv"

 #Foreach($Name in $Names){
 #   $Name1 = $Name.HostName
 #   $Alias = $Name.Aliases
  #  $Address = $Name.AddressList

       # Invoke-Command -ComputerName $Name1 -Command {Get-ItemProperty -Path 'HKLM:\System\ESInv' | Export-CSV C:\CE_ESINV.csv -Append -NoTypeInformation}
#}




