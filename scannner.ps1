Clear-Host;
$servers = Get-Content  -path C:\computers.txt


ForEach ($server in $servers) {

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


}