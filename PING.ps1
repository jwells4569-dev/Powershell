$servers = Get-Content "hosts.txt"
ForEach ($server in $servers) {
 Try {
  $IP = ((Test-Connection -ea stop -Count 1 -comp $server).IPV4Address).IPAddresstoString
  "$server - UP - $($IP)" >> "log.txt"
  } 
 Catch {
  Write-Warning "$_"
  "$server - Down - $($_)" >> "log.txt"
  }
 }