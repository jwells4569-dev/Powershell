## v-jawel (Jim Wells Design Labratory Inc)
## Use download locally and run as administrator
## Place Computers.txt into root of C:\

Clear-Host;


$servers = Get-Content  -path "C:\Computers.txt"

ForEach ($server in $servers) 
{
get-eventlog -ComputerName "$server" -Log System -source "User32"  | Where-Object TimeWritten -like "09/19/2018*"

get-eventlog -ComputerName "$server" -Log System -source "Microsoft-Windows-WindowsUpdateClient" | Where-Object TimeWritten -like "09/19/2018*"

get-eventlog -ComputerName "$server" -Log System -source "Microsoft-Windows-Kernel-Power" | Where-Object TimeWritten -like "09/19/2018*"
}