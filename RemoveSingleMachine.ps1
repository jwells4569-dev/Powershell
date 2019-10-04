$Name = Read-Host "Input Machine FQDN
$Agent = Get-SCOMAgent -DNSHostName "$Name"
Uninstall-SCOMAgent -Agent $Agent -ActionAccount (Get-Credential)