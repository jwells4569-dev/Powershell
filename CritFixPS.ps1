<# 

.SYNOPSIS
    Critfix CMD converted to Powershell for CE Usage

.DESCRIPTION
    Usage:  Use for machines that are non domain joined &/or machines that otherwise do not work correctly with CEWSUS deadlines.
    Runs from Elevated Powershell
    Uses JIT Elevated credentials to affect Auto Logon functionality.
    Can be configured by user choices to change settings.

.Example
    C:\PS>.\CritfixPS.PS1 
    Standard Use
    Credentials domain\User
    Update Source WSUS FQDN:Port or MU
    Content All or CriticalOnly
    Reboot Auto or None
    Retry attemps 0-100
    Log Location I.E. C:\Logs\WSUS

.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: February 19, 2019

    Ver 1.0 - Basic functionality Patching without interaction and no Auto Logon
    Ver 1.1 - Added Auto Logon function
    Ver 1.2 - Added further configurable switches with defaults
    Ver 1.3 - Added functionality to use WSUS or external Windows Update to search for Updates
    Ver 1.3.1 - Spell checking -_-
#>


#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)

#Variables Below

#Get Date
$Date = get-date -format 'yyyy-MM-dd'

#Get Time
$Time = (get-date).AddMinutes(15).ToString("HH:mm")

# AutoLogon Creds
$Credentials = Get-Credential

# Update Source (WU | MU) Default is CEWSUS
$WUMU = ( ($defaultValue='http://cewsus.redmond.corp.microsoft.com:8530'), (Read-Host "Input Content desired [$defaultValue]")) -match '\S' | select -last 1

#Content Type (Critical Patches only | All available Patches) criticalonly|all
$Content = ( ($defaultValue='All'), (Read-Host "Input Content desired [$defaultValue]")) -match '\S' | select -last 1

# Reboot Type (Auto | None)
$Reboot = ( ($defaultValue='Auto'), (Read-Host "Input Reboot Type [$defaultValue]")) -match '\S' | select -last 1

# Search and Download Retry Attempts 
$Retry = ( ($defaultValue='5'), (Read-Host "Input Number of Search/Download Retries [$defaultValue]")) -match '\S' | select -last 1

# Where to copy Log File after complete
$LogLocation = Read-Host -Prompt 'Input Log Location'

# Source for Copying new CritFix Bits from:
$Source = "\\tkfiltoolbox\tools\23649\latest.release"

# Destination where to copy CritFix
$Destination = Join-Path $env:SystemDrive '\tools\Critfix'

# CritFix Command
$Command = { C:\tools\critfix\critfix.exe /Source $WUMU /Log C:\tools\critfix\$env:Computername.txt /contenttype $Content /checkduplicate /nodriverupdate /restart $Reboot /wudebug /continue /retry $Retry /autologon $Credentials }


#Invoking workflow

    Write-Host "Running CritFix..." -ForegroundColor Yellow   

    Write-Host "Copying and Downloading CritFix to" $destination -ForegroundColor Yellow 

            robocopy.exe /E /IT  $Source $Destination #Copy new Bits to $Destination

            Write-Host "Start CritFix" -ForegroundColor Yellow

            Invoke-Command $Command #Starts CritFix with WSUS, Auto Logon, All Patches, No Drivers, Continue, Retry 5, and Auto Restart by default

            Start-Sleep -s 120

            Copy-Item C:\tools\critfix\$env:Computername.txt -Destination $LogLocation -verbose  #Copies log file to User choice of location
                                                 
            Write-Host "CritFix Finished"
                          
            Start-Sleep -s 20 




#ignore for now

#function RemoteCritfix {

#SCHTASKS /create /tn "once only" /tr "$command" arguments" /sc ONCE /sd $date /st $Time+15

#}
