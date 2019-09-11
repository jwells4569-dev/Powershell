$Hosts = Get-Content -Path 'C:\hosts.txt'
Invoke-Command -ComputerName $Hosts -ScriptBlock {
    Get-HotFix | Where-Object {
        $_.InstalledOn -gt ((Get-Date).AddDays(-120))
    } | Select-Object -Property PSComputerName, Description, HotFixID, InstalledOn
} #| Format-Table -AutoSize |
#Out-File -Encoding ASCII -FilePath 'C:\Users\v-jawel\desktop\Recent_OS_Updates.txt' -Append -ErrorAction SilentlyContinue
