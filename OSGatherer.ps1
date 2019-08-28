Clear-Host;
$servers = Get-Content  -path C:\computers.txt 

ForEach ($server in $servers) 
{

systeminfo /s $server | findstr /c:"Host Name" 
systeminfo /s $server | findstr /c:"OS Name" 
systeminfo /s $server | findstr /c:"OS Version"

Write-Output "Hard Drive Information:"


wmic /node:$server diskdrive get InterfaceType,name,size,model,manufacturer


Write-Output "CPU Information:" 

wmic /node:$server cpu get Name,NumberOfCores,NumberOfLogicalProcessors

systeminfo /s $server | findstr /c:"Total Physical Memory"
Write-Output "Memory Information:" 
 

wmic /node:$server MEMORYCHIP get Capacity,DeviceLocator,PartNumber,Tag 

#Write-Output ""

#Write-Output "Machine Administrators Group"  

#$group = get-wmiobject win32_group -ComputerName $server -Filter "LocalAccount=True AND SID='S-1-5-32-544'"
#$query = "GroupComponent = `"Win32_Group.Domain='$($group.domain)'`,Name='$($group.name)'`""
#$allAdmins = Get-WmiObject win32_groupuser -ComputerName $server -Filter $query | %{$_.PartComponent} | % {$_.substring($_.lastindexof("Domain=") + 7).replace("`",Name=`"","\")}

#$alladmins

Write-Output ""


#$i++
#Write-Progress -Activity "System Search" -status "Scanned: $i of $($server.Count)" -percentComplete (($i / $server.Count)  * 100)
}