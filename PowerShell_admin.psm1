#J.M. Wells Powershell Module for SCOM Administration
# 10/3/2019

    Write-Host @"
    Use "Help" infront of command for Help/Examples.

    Commands:
    
    Get-Info
    Get-AlertBulk
    Get-AlertSingle
    Clear-AlertBulk
    Clear-AlertSingle
    Remove-MachineBulk
    Remove-MachineSingle
    Set-MaintenanceModeBulk
    Set-MaintenanceModeSingle
    Show-MaintenanceMode
"@ -ForegroundColor Black -BackgroundColor White



function Get-Info {

<# 

.SYNOPSIS
    SCOM Admin Tool Info/Help File
.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Gives a list of all functions in module
    Runs from Elevated Operations Manager Shell
    Can be configured by user choices to change settings.

.Example
    Help Get-Info
    Get-Info  Self contained function
.Notes
    Author: J.M. Wells 
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

    Write-Host @"
    Use "Help" infront of command for Help/Examples.

    Commands:

    Get-Info
    Get-AlertBulk
    Get-AlertSingle
    Clear-AlertBulk
    Clear-AlertSingle
    Remove-MachineBulk
    Remove-MachineSingle
    Set-MaintenanceModeBulk
    Set-MaintenanceModeSingle
    Show-MaintenanceMode
"@ -ForegroundColor Black -BackgroundColor White

}



function Get-AlertsBulk {


<# 

.SYNOPSIS
    SCOM Alert Bulk Gatherer

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Gets All updates from User Specified time Period.
    Runs from Elevated Operations Manager Shell
    Can be configured by user choices to change settings.

.Example
    Help Get-AlertBulk
    Get-AlertBulk  Self contained function
.Notes
    Author: J.M. Wells 
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

  Get-SCOMAlert -Criteria "ResolutionState$ResOp'$Resolution' AND Severity$SevOp'$Severity' AND Priority$PriOp'$Priority' AND TimeRaised> '$((get-date).adddays(-$TimeFrame))'" | Sort TimeRaised -Descending| Select TimeRaised, MonitoringObjectPath, MonitoringObjectDisplayName, MonitoringObjectID, name, severity, priority, ResolutionState, RepeatCount, Owner

}


#####
#####


function Get-AlertSingle {

<# 

.SYNOPSIS
    SCOM Admin Tool Get-AlertSingle 

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Gathers All Alerts for a Single SCOM monitored Machine.
    Runs from Elevated Operations Manager Shell
    Can be configured by user choices to change settings.

.Example
    Help Get-AlertSingle
    Get-AlertSingle  Self contained function
.Notes
    Author: J.M. Wells 
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

     
              Get-SCOMAlert -criteria "MonitoringObjectDisplayName = '$CompName'" | Sort TimeRaised -Descending| Select TimeRaised, MonitoringObjectPath, MonitoringObjectDisplayName, MonitoringObjectID, name, severity, priority, ResolutionState, RepeatCount, Owner
}


#####
#####


function Clear-AlertBulk {

<# 

.SYNOPSIS
    SCOM Admin Tool Clear-AlertBulk

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Clears All Alerts of a specific type 
    Runs from Elevated Operations Manager Shell
    Can be configured by user choices to change settings.

.Example
    Help Clear-AlertBulk
    Clear-AlertBulk self contained function
.Notes
    Author: J.M. Wells 
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

    Get-SCOMAlert -Name "$AlertName" | Set-SCOMAlert -ResolutionState $ResolutionState -Owner "$Owner"
}


#####
#####

function Clear-AlertSingle {

<# 

.SYNOPSIS
    SCOM Admin Tool Clear-AlertSingle

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Clears a specific alert for a specific machine
    Runs from Elevated Operations Manager Shell
    Can be configured by user choices to change settings.

.Example
    Help Clear-AlertSingle
    Clear-AlertSingle self contained function
.Notes
    Author: J.M. Wells 
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
    Get-SCOMAlert -criteria "MonitoringObjectDisplayName = '$CompName' and Name = '$AlertName'" | Set-SCOMAlert -ResolutionState $ResolutionState -Owner "$Owner"

}


#####
#####


function Remove-MachineBulk {

<# 

.SYNOPSIS
    SCOM Admin Tool RemoveMachineBulk

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Removes machines in bulk from Instance using TXT files
    Runs from Elevated Operations Manager Shell
    Can be configured by user choices to change settings.

.Example
    Help RemoveMachineBulk
    RemoveMachineBulk self contained function
.Notes
    Author: J.M. Wells 
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)





#Remove Machines from SCOM Instance.  Uses TXT file to pass machines (FQDN) to loop. Requires runas credentials



    $Path = ( ($defaultValue='C:\Computers.txt'), (Read-Host "Input Path and File Name [$defaultValue]")) -match '\S' | select -last 1


    $servers = Get-Content  -path "$Path"

    ForEach ($server in $servers) 
    {

    $Agent = Get-SCOMAgent -DNSHostName "$server"
    Uninstall-SCOMAgent -Agent $Agent -ActionAccount (Get-Credential)
    }

}


#####
#####


function Remove-MachineSingle {


<# 

.SYNOPSIS
    SCOM Admin Tool RemoveMachineSingle

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Removes a single machine from Instance
    Runs from Elevated Operations Manager Shell
    Can be configured by user choices to change settings.

.Example
    Help RemoveMachineSingle
    RemoveMachineSingle self contained function
.Notes
    Author: J.M. Wells 
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)


#Remove Machine from SCOM Instance.  Uses FQDN to remove machine.  Requires runas credentials.


    $Name = ( ($defaultValue='Test.redmond.corp.microsoft.com'), (Read-Host "Input Machine Name [$defaultValue]")) -match '\S' | select -last 1


     $Agent = Get-SCOMAgent -DNSHostName "$Name"


        Uninstall-SCOMAgent -Agent $Agent -ActionAccount (Get-Credential)

}


#####
#####


function Set-MaintenanceModeBulk {

<# 

.SYNOPSIS
    SCOM Admin Tool Set-MaintenanceModeBulk

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Puts machines into Maintenance Mode in bulk batches using TXT file.
    Runs from Elevated Operations Manager Shell
    Can be configured by user choices to change settings.

.Example
    Help Set-MaintenanceModeBulk
    Set-MaintenanceModeBulk self contained function
.Notes
    Author: J.M. Wells 
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)

#Set Machines into Maintenance Mode in bulk Uses TXT file to pass machines (FQDN) to loop.


$Path = ( ($defaultValue='C:\Computers.txt'), (Read-Host "Input Path and File Name [$defaultValue]")) -match '\S' | select -last 1
$servers = Get-Content  -path "$Path"
$minutes = ( ($defaultValue=15), (Read-Host "Input Length of maintenance window desired [$defaultValue]")) -match '\S' | select -last 1
$Reason = ( ($defaultValue='SecurityIssue'), (Read-Host "Input Reason for Maintenance Window [$defaultValue]")) -match '\S' | select -last 1
$Comment = ( ($defaultValue='Applying Software Updates.'), (Read-Host "Input Comment for Maintenance Window [$defaultValue]")) -match '\S' | select -last 1


ForEach ($server in $servers) {

$Instance = Get-SCOMClassInstance -Name $servers
$Time = ((Get-Date).AddMinutes($minutes))
Start-SCOMMaintenanceMode -Instance $Instance -EndTime $Time -Reason "$Reason" -Comment "$Comment"

}


}


#####
#####


function Set-MaintenanceModeSingle {

<# 

.SYNOPSIS
    SCOM Admin Tool Set-MaintenanceModeSingle

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Puts a single machine into Maintenance Mode
    Runs from Elevated Operations Manager Shell
    Can be configured by user choices to change settings.

.Example
    Help Set-MaintenanceModeSingle
    Set-MaintenanceModeSingle self contained function
    
 .Notes   
    Author: J.M. Wells 
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)




#Set one machine to maintenance mode
$minutes = ( ($defaultValue=15), (Read-Host "Input Length of maintenance window desired [$defaultValue]")) -match '\S' | select -last 1
$Reason = ( ($defaultValue='SecurityIssue'), (Read-Host "Input Reason for Maintenance Window [$defaultValue]")) -match '\S' | select -last 1
$Comment = ( ($defaultValue='Applying Software Updates.'), (Read-Host "Input Comment for Maintenance Window [$defaultValue]")) -match '\S' | select -last 1
$ServerName = ( ($defaultValue='Test.redmond.corp.microsoft.com'), (Read-Host "Input Machine Name [$defaultValue]")) -match '\S' | select -last 1

Start-SCOMMaintenanceMode -Instance $ServerName -EndTime $Time -Reason "$Reason" -Comment "$Comment"

}


#####
#####



##Get machines in maintenance mode
function Show-MaintenanceMode {

<# 

.SYNOPSIS
    SCOM Admin Tool Show-MaintenanceMode

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Lists All machines in Maintenance Mode
    Runs from Elevated Operations Manager Shell
    Can be configured by user choices to change settings.

.Example
    Help Show-MaintenanceMode
    Show-MaintenanceMode self contained function
.Notes
    Author: J.M. Wells
    Date: October 03, 2019

    Ver 1.0 - Basic functionality

#>

#Invoke Help file
Param(
    [String]$Targets = "Help"  #The targets to run.
)



##Gets machines in MM

Get-SCOMMonitoringObject | where-object {$_.InMaintenanceMode -eq $true}

}
