#v-jawel Powershell Module for SCOM Administration
# 10/3/2019
#Because I can.

#####
#####

<# 

.SYNOPSIS
    SCOM Admin Tool for CE/PA Usage

.DESCRIPTION
    Usage:  Use for managing any SCOM instance you have access to as runas.
    Runs from Elevated Powershell
    Uses JIT Elevated credentials for functionality.
    Can be configured by user choices to change settings.

.Notes
    Author: J.Wells (Design Laboratory Inc)
    Date: October 03, 2019

    Ver 1.0 - Basic functionality
#>

Clear-Host;

function Get-AlertsBulk {


Clear-Host;
   
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

Clear-Host;


    ## Takes Machine FQDN to pass to Get-SCOMAlert to get All Alerts for a machine
        
  $CompName = ( ($defaultValue='Test.redmond.corp.microsoft.com'), (Read-Host "Input Machine Name [$defaultValue]")) -match '\S' | select -last 1 


    ##Gets All alerts for Single Machine using FQDN

     
              Get-SCOMAlert -criteria "MonitoringObjectDisplayName = '$CompName'" | Sort TimeRaised -Descending| Select TimeRaised, MonitoringObjectPath, MonitoringObjectDisplayName, MonitoringObjectID, name, severity, priority, ResolutionState, RepeatCount, Owner
}


#####
#####


function Clear-AlertBulk {

Clear-Host;

#User inputs to clear bulk alerts.  Defaults to Clearing "Failed to Connect to Computer" and "255" for Closed

    Write-Host "Alert Clearing Script"

    $AlertName = ( ($defaultValue='Failed to Connect to Computer'), (Read-Host "Input Alert Name as Displayed [$defaultValue]")) -match '\S' | select -last 1 

    $ResolutionState = ( ($defaultValue='255'), (Read-Host "Input Resolution State [$defaultValue]")) -match '\S' | select -last 1 

    $Owner = ( ($defaultValue='Powershell User'), (Read-Host "Input Alias for Ownership [$defaultValue]")) -match '\S' | select -last 1 


    ##Clear the Alert

    Get-SCOMAlert -Name "$AlertName" | Set-SCOMAlert -ResolutionState $ResolutionState -Owner "$Owner"
}


#####
#####

function Clear-AlertSingle {

Clear-Host;

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

#Remove Machines from SCOM Instance.  Uses TXT file to pass machines (FQDN) to loop. Requires runas credentials

Clear-Host;

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

#Remove Machine from SCOM Instance.  Uses FQDN to remove machine.  Requires runas credentials.
Clear-Host;

    $Name = ( ($defaultValue='Test.redmond.corp.microsoft.com'), (Read-Host "Input Machine Name [$defaultValue]")) -match '\S' | select -last 1


     $Agent = Get-SCOMAgent -DNSHostName "$Name"


        Uninstall-SCOMAgent -Agent $Agent -ActionAccount (Get-Credential)

}


#####
#####


function MaintenanceMode_Bulk {

#Set Machines into Maintenance Mode in bulk Uses TXT file to pass machines (FQDN) to loop.

Clear-Host;
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


function MaintenanceMode_Single {

Clear-Host;

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
function Get-MaintenanceMode {

Clear-Host;

##Gets machines in MM

Get-SCOMMonitoringObject | where-object {$_.InMaintenanceMode -eq $true}

}
