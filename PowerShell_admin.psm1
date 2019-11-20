#v-jawel Powershell Module for SCOM Administration
# 10/3/2019

#Modified by Jonathan Powell - Remove-MachineBulk; New logic for Uninstall-SCOMAgent loop limitations.

    Clear-Host

    Write-Host @"
    Use "Help" infront of command for Help/Examples.

    USE FQDN of Machine unless otherwise stated!!

    Commands:

    Get-Info
    Get-MachineList    
    Get-AlertsBulk
    Get-AlertSingle
    Clear-AlertBulk
    Clear-AlertSingle
    Remove-MachineBulk
    Remove-MachineSingle
    Set-MaintenanceModeBulk
    Set-MaintenanceModeSingle
    Show-MaintenanceMode

"@ -ForegroundColor Yellow -BackgroundColor Black



function Get-MachineList {

<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    SCOM Admin Tool Info/Help File
.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Gives a list of all functions in module
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help Get-Info
    Get-Info  Self contained function
.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: October 03, 2019

    Ver 1.0 - Basic functionality
    Ver 1.1 - Added Info and Info Function 10/4/19
    Ver 1.2 - Added Help option to each function 10/7/19
    Ver 1.3 - Spell checking and clean up of function names 
    Ver 1.4 - Finalized Help options and information 10/8/19

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)

    $Output = ( ($defaultValue='C:\AllSCOMMachines.txt'), (Read-Host "Input path and name [$defaultValue]")) -match '\S' | select -last 1

    Get-SCOMGroup -DisplayName “All Windows Computers” | Get-SCOMClassInstance -Verbose | sort DisplayName | FT DisplayName | Out-File -FilePath $Output 

}



function Get-Info {

<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    SCOM Admin Tool Info/Help File
.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Gives a list of all functions in module
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help Get-MachineList
    Get-MachineList  Self contained function
.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: November 06, 2019

    Ver 1.0 - Basic functionality
    Ver 1.1 - Added Info and Info Function 10/4/19
    Ver 1.2 - Added Help option to each function 10/7/19
    Ver 1.3 - Spell checking and clean up of function names 
    Ver 1.4 - Finalized Help options and information 10/8/19

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)

    Write-Host @"
    Use "Help" infront of command for Help/Examples.

    USE FQDN of Machine unless otherwise stated!!

    Commands:

    Get-Info
    Get-AlertsBulk
    Get-AlertSingle
    Clear-AlertBulk
    Clear-AlertSingle
    Remove-MachineBulk
    Remove-MachineSingle
    Set-MaintenanceModeBulk
    Set-MaintenanceModeSingle
    Show-MaintenanceMode

"@ -ForegroundColor Yellow -BackgroundColor Black

}





function Get-AlertsBulk {


<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    SCOM Alert Bulk Gatherer

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Gets All updates from User Specified time Period.
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help Get-AlertBulk
    Get-AlertBulk  Self contained function
.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: October 03, 2019

    Ver 1.0 - Basic functionality
    Ver 1.1 - Added Info and Info Function 10/4/19
    Ver 1.2 - Added Help option to each function 10/7/19
    Ver 1.3 - Spell checking and clean up of function names 
    Ver 1.4 - Finalized Help options and information 10/8/19
    Ver 1.5 - Changed Verbs to approved versions 10/8/19

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)



   
  #User inputs to get alert values.  Defaults to 1 day back.

  $TimeFrame = ( ($defaultValue='1'), (Read-Host "Input your time frame [$defaultValue]")) -match '\S' | select -last 1
    $ResOp = ( ($defaultValue='!='), (Read-Host "Input Resolution State operator [$defaultValue]")) -match '\S' | select -last 1
  $Resolution = ( ($defaultValue='255'), (Read-Host "Input Resolution State [$defaultValue]")) -match '\S' | select -last 1 
    $SevOp = ( ($defaultValue='='), (Read-Host "Input Resolution State operator [$defaultValue]")) -match '\S' | select -last 1
  $Severity = ( ($defaultValue='2'), (Read-Host "Input Severity Level [$defaultValue]")) -match '\S' | select -last 1
    $PriOp = ( ($defaultValue='>='), (Read-Host "Input Resolution State operator [$defaultValue]")) -match '\S' | select -last 1
  $Priority = ( ($defaultValue='0'), (Read-Host "Input Priority Level [$defaultValue]")) -match '\S' | select -last 1


  ##Get Alerts from last X days

  Get-SCOMAlert -Criteria "ResolutionState$ResOp'$Resolution' AND Severity$SevOp'$Severity' AND Priority$PriOp'$Priority' AND TimeRaised> '$((get-date).adddays(-$TimeFrame))'" | Sort TimeRaised -Descending| Select TimeRaised, MonitoringObjectPath, MonitoringObjectDisplayName, MonitoringObjectID, name, severity, priority, ResolutionState, RepeatCount, Owner -Verbose

}


#####
#####


function Get-AlertSingle {

<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    Get-AlertSingle 

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Gathers All Alerts for a Single SCOM monitored Machine.
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help Get-AlertSingle
    Get-AlertSingle  Self contained function
.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)






    ## Takes Machine FQDN to pass to Get-SCOMAlert to get All Alerts for a machine
        
  $CompName = ( ($defaultValue='Test.redmond.corp.microsoft.com'), (Read-Host "Input Machine Name [$defaultValue]")) -match '\S' | select -last 1 


    ##Gets All alerts for Single Machine using FQDN

     
              Get-SCOMAlert -criteria "MonitoringObjectDisplayName = '$CompName'" | Sort TimeRaised -Descending| Select TimeRaised, MonitoringObjectPath, MonitoringObjectDisplayName, MonitoringObjectID, name, severity, priority, ResolutionState, RepeatCount, Owner -Verbose
}


#####
#####


function Clear-AlertBulk {

<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    Clear-AlertBulk

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Clears All Alerts of a specific type 
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help Clear-AlertBulk
    Clear-AlertBulk self contained function
.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)


#User inputs to clear bulk alerts.  Defaults to Clearing "Failed to Connect to Computer" and "255" for Closed

    $AlertName = ( ($defaultValue='Failed to Connect to Computer'), (Read-Host "Input Alert Name as Displayed [$defaultValue]")) -match '\S' | select -last 1 

    $ResolutionState = ( ($defaultValue='255'), (Read-Host "Input Resolution State [$defaultValue]")) -match '\S' | select -last 1 

    $Owner = ( ($defaultValue='Powershell User'), (Read-Host "Input Alias for Ownership [$defaultValue]")) -match '\S' | select -last 1 


    ##Clear the Alert
    Write-Host "Clearing Selected Alert..." -ForegroundColor Yellow -BackgroundColor Black
    Get-SCOMAlert -Name "$AlertName" | Set-SCOMAlert -ResolutionState $ResolutionState -Owner "$Owner" -Verbose
}


#####
#####

function Clear-AlertSingle {

<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    Clear-AlertSingle

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Clears a specific alert for a specific machine
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help Clear-AlertSingle
    Clear-AlertSingle self contained function
.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)




#User input to clear alert for single machine.  Defaults to Clearing "Health Service Heartbeat Failure" and "255" for Closed and Owner as "Powershell User"

    $CompName = ( ($defaultValue='Test.redmond.corp.microsoft.com'), (Read-Host "Input Machine Name [$defaultValue]")) -match '\S' | select -last 1

    $AlertName = ( ($defaultValue='Health Service Heartbeat Failure'), (Read-Host "Input Alert Name as Displayed [$defaultValue]")) -match '\S' | select -last 1 

    $ResolutionState = ( ($defaultValue='255'), (Read-Host "Input Resolution State [$defaultValue]")) -match '\S' | select -last 1 

    $Owner = ( ($defaultValue='Powershell User'), (Read-Host "Input Alias for Ownership [$defaultValue]")) -match '\S' | select -last 1 

    ##Clear the Alert By Machine Name and Alert Name
    Write-Host "Clearing Selected Alert..." -ForegroundColor Yellow -BackgroundColor Black
    Get-SCOMAlert -criteria "MonitoringObjectDisplayName = '$CompName' and Name = '$AlertName'" | Set-SCOMAlert -ResolutionState $ResolutionState -Owner "$Owner" -Verbose

}


#####
#####


function Remove-MachineBulk {

<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    RemoveMachineBulk

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Removes machines in bulk from Instance using TXT files
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help RemoveMachineBulk
    RemoveMachineBulk self contained function
.Notes
    Author: J.Wells (Design Laboratory Inc) Original concept and code
    Modified by: Jonathan Powell (Design Laboratory Inc) New logic to work around Uninstall-SCOMAgent loop limitations
            Many Thanks Jonathan!
    Date: October 03, 2019

    Ver 1.0 - Basic functionality
    Ver 1.1 - Assistance from Jonathan Powell for Uninstall-SCOMAgent Loop issues.

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)

$Path = ( ($defaultValue='C:\Computers.txt'), (Read-Host "Input Path and File Name [$defaultValue]")) -match '\S' | select-object -last 1
$Credentials = Get-Credential -Message "Please enter credentials for SCOM interaction"
$Iteration = 0
$TargetList = Get-Content $Path

Foreach ($Target in $TargetList)
{
    Write-Host "Attempting to detect SCOM agent on $Target..." -ForegroundColor Yellow -BackgroundColor Black
    $Agent = $null
    $Agent = Get-SCOMAgent -DNSHostName "$Target" # This returns null when there is no client detected
    if ($null -ne $Agent)
    {
        Write-Host "Attemping to remove SCOM agent on $Target..." -ForegroundColor Yellow -BackgroundColor Black
        $Iteration++
        $User = $Credentials.UserName
        $Password = $Credentials.GetNetworkCredential().password
        Start-Job -ScriptBlock{
            $Target = $args[0]
            $User = $args[1]
            $Password = $args[2] | ConvertTo-SecureString -asPlainText -Force
            $Credentials = New-Object System.Management.Automation.PSCredential($User,$Password)
            $Agent = Get-SCOMAgent -DNSHostName "$Target"
            Uninstall-SCOMAgent -Agent $Agent -ActionAccount $Credentials -PassThru #This removes the client, but doesn't return cleanly, hangs without error
        } -ArgumentList $Target,$User,$Password -Name "AgentRemoval-$Iteration" | Out-Null
    }
}

$JobCount = (Get-Job -Name AgentRemoval*).Count
if ($JobCount -gt 0)
{
    Write-Host "The SCOM agent removals should be in-progress now.  Sleeping for 3 minutes to allow the uninstallations to complete." -ForegroundColor Green
    Start-Sleep -Seconds 180
    Get-Job -Name AgentRemoval* | Receive-Job
    Get-Job -Name AgentRemoval* | Remove-Job -Force
}
else {Write-Host "No SCOM agents were detected." -ForegroundColor Green}

}


#####
#####


function Remove-MachineSingle {


<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    RemoveMachineSingle

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Removes a single machine from Instance
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help RemoveMachineSingle
    RemoveMachineSingle self contained function
.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)


#Remove Machine from SCOM Instance.  Uses FQDN to remove machine.  Requires runas credentials.


$Path = ( ($defaultValue='Test.redmond.corp.microsoft.com'), (Read-Host "Input Machine Name [$defaultValue]")) -match '\S' | select -last 1
$Credentials = Get-Credential -Message "Please enter credentials for SCOM interaction"
$Count = 0
$Iteration = 0

While ($Count -eq 0)

{

Write-Host "Attempting to detect SCOM agent on $Path..." -ForegroundColor Yellow -BackgroundColor Black
    $Count++
    $Agent = $null
    $Agent = Get-SCOMAgent -DNSHostName "$Path" # This returns null when there is no client detected
}

if ($null -ne $Agent)
    {
        Write-Host "Attemping to remove SCOM agent on $Path..." -ForegroundColor Yellow -BackgroundColor Black
        $Iteration++
        $User = $Credentials.UserName
        $Password = $Credentials.GetNetworkCredential().password
        Start-Job -ScriptBlock{
            $Path = $args[0]
            $User = $args[1]
            $Password = $args[2] | ConvertTo-SecureString -asPlainText -Force
            $Credentials = New-Object System.Management.Automation.PSCredential($User,$Password)
            $Agent = Get-SCOMAgent -DNSHostName "$Path"
            Uninstall-SCOMAgent -Agent $Agent -ActionAccount $Credentials -PassThru #This removes the client, but doesn't return cleanly, hangs without error
        } -ArgumentList $Path,$User,$Password -Name "AgentRemoval-$Iteration" | Out-Null
    }

$JobCount = (Get-Job -Name AgentRemoval*).Count
if ($JobCount -gt 0)
{
    Write-Host "The SCOM agent removal should be in-progress now.  Sleeping for 3 minutes to allow the uninstallation to complete." -ForegroundColor Green
    Start-Sleep -Seconds 180
    Get-Job -Name AgentRemoval* | Receive-Job
    Get-Job -Name AgentRemoval* | Remove-Job -Force
}
else {Write-Host "No SCOM agent was detected." -ForegroundColor Green}

}

#####
#####


function Set-MaintenanceModeBulk {

<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    Set-MaintenanceModeBulk

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Puts machines into Maintenance Mode in bulk batches using TXT file.
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help Set-MaintenanceModeBulk
    Set-MaintenanceModeBulk self contained function
.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)

#Set Machines into Maintenance Mode in bulk Uses TXT file to pass machines (FQDN) to loop.


$Path = ( ($defaultValue='C:\Computers.txt'), (Read-Host "Input Path and File Name [$defaultValue]")) -match '\S' | select -last 1
$minutes = ( ($defaultValue=15), (Read-Host "Input Length of maintenance window desired [$defaultValue]")) -match '\S' | select -last 1
$Reason = ( ($defaultValue='SecurityIssue'), (Read-Host "Input Reason for Maintenance Window [$defaultValue]")) -match '\S' | select -last 1

$servers = Get-Content  -path $Path

ForEach ($server in $servers) {

$Instance = (Get-SCOMClass -DisplayName "Windows Computer" | Get-SCOMClassInstance | ?{$_.DisplayName -eq "$Server"})
$Time = ((Get-Date).AddMinutes($minutes))

Write-Host "Setting Machines in Maintenance Mode..." -ForegroundColor Yellow -BackgroundColor Black
      Start-SCOMMaintenanceMode -Instance $Instance -EndTime $Time -Reason $Reason -Verbose
                    

}


}


#####
#####


function Set-MaintenanceModeSingle {

<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    Set-MaintenanceModeSingle

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Puts a single machine into Maintenance Mode
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help Set-MaintenanceModeSingle
    Set-MaintenanceModeSingle self contained function
    Author: J.Wells (Design Laboratory Inc)
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)




#Set one machine to maintenance mode
$minutes = ( ($defaultValue="15"), (Read-Host "Input Length of maintenance window desired [$defaultValue]")) -match '\S' | select -last 1
$Reason = ( ($defaultValue='SecurityIssue'), (Read-Host "Input Reason for Maintenance Window [$defaultValue]")) -match '\S' | select -last 1
$Comment = ( ($defaultValue='Applying Software Updates.'), (Read-Host "Input Comment for Maintenance Window [$defaultValue]")) -match '\S' | select -last 1
$ServerName = ( ($defaultValue='Test.redmond.corp.microsoft.com'), (Read-Host "Input Machine Name [$defaultValue]")) -match '\S' | select -last 1

    Write-Host "Setting Machine in Maintenance Mode..." -ForegroundColor Yellow -BackgroundColor Black
    $Instance = Get-SCOMClassInstance -Name "$ServerName"
    $Time = ((Get-Date).AddMinutes($minutes))
    Start-SCOMMaintenanceMode -Instance $Instance -EndTime $Time -Reason "$Reason" -Comment "$Comment" -Verbose

}



#####
#####



##Get machines in maintenance mode
function Show-MaintenanceMode {

<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage
    Show-MaintenanceMode

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Lists All machines in Maintenance Mode
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Example
    Help Show-MaintenanceMode
    Show-MaintenanceMode self contained function
.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)



##Gets machines in MM

    Write-Host "Looking for Machines in Maintenance Mode..." -ForegroundColor Yellow -BackgroundColor Black
    Get-SCOMMonitoringObject | where-object {$_.InMaintenanceMode -eq $true} -Verbose

}


