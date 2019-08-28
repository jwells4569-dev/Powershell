$server = Get-Content -path "computers.txt"
$server | foreach {get-hotfix -computername $_ } | Export-CSV C:\Hotfix.csv -Append