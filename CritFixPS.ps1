# CritFix Powershell Update J.Wells (Design Labratory Inc)


#AutoLogon Creds
$Credentials = Get-Credential

#Where to copy Log File after complete
$LogLocation = Read-Host -Prompt 'Input Log Location'

# Source for Copying new CritFix Bits from:
$source = "\\tkfiltoolbox\tools\23649\latest.release"

# Desination where to copy CritFix
$destination = Join-Path $env:SystemDrive '\tools\Critfix'

#Crit Fix Command
$command = { C:\tools\critfix\critfix.exe /Source http://cewsus.redmond.corp.microsoft.com:8530 /Log C:\tools\critfix\$env:Computername.txt /contenttype all /checkduplicate /nodriverupdate /restart auto /wudebug /autologon $Credentials }

 
    Write-Host "Running Crit Fix..." -ForegroundColor Yellow 

    Write-Host "Copying and Downloading Crit Fix to" $destination -ForegroundColor Yellow 

            robocopy.exe /E /IT  $source $destination 

            Write-Host "Start Crit Fix" -ForegroundColor Yellow

            Invoke-Command $command

            Start-Sleep -s 120

            Copy-Item C:\tools\critfix\$env:Computername.txt -Destination $LogLocation -verbose
                                                 
            Write-Host "Crit Fix Finished" -ForegroundColor Yellow
                          
            Start-Sleep -s 20 