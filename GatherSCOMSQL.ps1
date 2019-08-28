Write-Host "Scraping SCOM SQL for Harddrive Issues" -ForegroundColor Gray
Invoke-Sqlcmd -InputFile "C:\HighPriSCOM.sql" | Export-Csv -Path "C:\HighPriSCOM.csv" -NoTypeInformation