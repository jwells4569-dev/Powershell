#requires -version 5
<#
.SYNOPSIS
  DSC for Installing All Windows WSUS Patches Waiting
.DESCRIPTION
  This DSC will install any Windows patches waiting via WSUS.
  The configuration can be added to any DSC and will reboot the server if needed.
  DependsOn should work with this as it may be best to leave updates until one of 
  the last DSC items


.PARAMETER <Parameter_Name>
  NodeName - Name of the "Node"/Server to which the configuration required to be applied. 

.OUTPUTS Log File

.Supported OS
  Windows Server 2012 R2, Windows Server 2008 R2 (Tested and working)
  
.NOTES
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
  <Example explanation goes here>
#>

Configuration InstallAllWSUSUpdates
{
    param
    (
        [string]$NodeName = "localhost"
    )

    # The default resource which includes the Script resource item.
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"

    Script InstallUpdates            
    {            
        # Must return a hashtable with at least one key            
        # named 'Result' of type String.
        #
        # This function returns the amount of patches remaining,
        # it is required but will never be used under normal circumstances.
                
        GetScript = {

            # Sets the criteria for the updates to be installed.
            $Criteria = "IsInstalled=0 and Type='Software'"

            # Search for relevant updates.
            $Searcher = New-Object -ComObject Microsoft.Update.Searcher

            $SearchResult = $Searcher.Search($Criteria).Updates     
                
            Write-Verbose 'Number of patches to install is $SearchResult.Count'

            # Sets the number of patches remaining to the count from the search.
            $NumberOfPatches = $SearchResult.Count

            # Return the amount of patches remaining.
            Return @{            
                'Result' = "Currently there are $NumberOfPatches patches to install."            
            }            
        }            
            
        # Must return a boolean: $true or $false  
        #
        # This checks if there are any available updates.
        # If the number is 0, it returns $true as no patches are waiting.
        # Else if the number is not 0, it returns $false as there are still patches
        # to install.          
        TestScript = {    

            # Sets the criteria for the updates to be installed.  
            $Criteria = "IsInstalled=0 and Type='Software'"
        
            # Search for relevant updates.
            $Searcher = New-Object -ComObject Microsoft.Update.Searcher
            $SearchResult = $Searcher.Search($Criteria).Updates

            If ($SearchResult.count -eq 0) {
                Write-Verbose 'No patches waiting to install'
                Return $true
            }
            else {
                Write-Verbose 'Patches are still waiting to install'
                Return $false
            }      
        }            
            
        # Returns nothing            
        SetScript = { 

            # Sets the criteria for the updates to be installed.          
            $Criteria = "IsInstalled=0 and Type='Software'"

            # Search for relevant updates.
            $Searcher = New-Object -ComObject Microsoft.Update.Searcher
            $SearchResult = $Searcher.Search($Criteria).Updates


            # Download updates.
            $Session = New-Object -ComObject Microsoft.Update.Session
            $Downloader = $Session.CreateUpdateDownloader()
            $Downloader.Updates = $SearchResult
            $Downloader.Download()


            # Install updates.
            $Installer = New-Object -ComObject Microsoft.Update.Installer
            $Installer.Updates = $SearchResult
            $Result = $Installer.Install()

            # If the machine needs a reboot, 
            # the DSC resource sets it to reboot.
            If ($Result.rebootRequired) { 
                $global:DSCMachineStatus = 1 
            }           
        }
    }
}

<#
  Compile, rename mof to InstallAllWSUSUpdates.mof, generate check sum file, publish to pull server
   
  An example of the location of the MOF files could be C:\PowerShellScripts\DSC\Configurations
#>
# Remove the comment here once you have completed the first compile as it will error if there are no
# files in the folder.
#
# Get-ChildItem -Path [Drive Letter]\[Location of MOF Files]\ | Remove-Item -Force -Verbose
InstallAllWSUSUpdates -Verbose
Get-ChildItem -Path C:\DSC\Configurations\ | Rename-Item -NewName InstallAllWSUSUpdates.mof -Verbose
New-DscChecksum -ConfigurationPath C:\DSC\Configurations\ -OutPath C:\DSC\Configurations\ -Verbose 
# If running this on the DSC Pull server change the second path to the location of the DSC Configuration Folder and it will upload.
# Usually it is the default location below.
# 
# Copy-Item [Drive Letter]\[Location of MOF Files]\InstallAllWSUSUpdates\*  "C:\Program Files\WindowsPowerShell\DscService\Configuration" -Verbose