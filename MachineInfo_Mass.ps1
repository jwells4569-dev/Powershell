## v-jawel (Jim Wells Design Labratory Inc)
## Use download locally and run as administrator
## Place Computers.txt into root of C:\
## Run MachineInfo_Mass.ps1 from anywhere as follows putting your output file where you desire.
## .\MachineInfo_Mass.ps1 | Out-File -filepath C:\MachineInfo.txt -Append

Clear-Host;
$servers = Get-Content  -path C:\computers.txt 
ForEach ($server in $servers) {
Write-Host "Checking your system information, Please wait... " -foregroundcolor DarkRed -backgroundcolor white

systeminfo /s $server | findstr /c:"Host Name" 
systeminfo /s $server | findstr /c:"Domain" 
Write-Output "Active Directory Operational Unit" 
dsquery computer -name $server
systeminfo /s $server | findstr /c:"OS Name" 
systeminfo /s $server | findstr /c:"OS Version" 

Write-Output "Build Number/UBR" 
 (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabEx -match '^[0-9]+\.[0-9]+' |  % { $matches.Values }

systeminfo /s $server | findstr /c:"System Manufacturer" 
systeminfo /s $server | findstr /c:"System Model" 
systeminfo /s $server | findstr /c:"System type"

Write-Output "VM Host Name"

(get-item "HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters").GetValue("HostName")


Write-Output "Machine Administrators Group"  

$group = get-wmiobject win32_group -ComputerName $server -Filter "LocalAccount=True AND SID='S-1-5-32-544'"
$query = "GroupComponent = `"Win32_Group.Domain='$($group.domain)'`,Name='$($group.name)'`""
$allAdmins = Get-WmiObject win32_groupuser -ComputerName $server -Filter $query | %{$_.PartComponent} | % {$_.substring($_.lastindexof("Domain=") + 7).replace("`",Name=`"","\")}

$alladmins

Write-Output "Machine IP Configuration" 

$ipV4 = ping $server -4

$ipv6 = ping $server -6

$ipV4

$ipV6


Write-Output "Hard Drive Information:"


wmic /node:$server diskdrive get InterfaceType,name,size,model,manufacturer


Write-Output "CPU Information:" 

wmic /node:$server cpu get Name,NumberOfCores,NumberOfLogicalProcessors

systeminfo /s $server | findstr /c:"Total Physical Memory"
Write-Output "Memory Information:" 
 

wmic /node:$server MEMORYCHIP get Capacity,DeviceLocator,PartNumber,Tag


Write-Output "Hot Fixes Installed" 

get-hotfix -computername $server 

} 

