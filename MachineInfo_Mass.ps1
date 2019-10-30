## v-jawel (Jim Wells Design Labratory Inc)
## Use download locally and run as administrator
## Place Computers.txt into root of C:\
## Run MachineInfo_Mass.ps1 from anywhere as follows putting your output file where you desire.
## .\MachineInfo_Mass.ps1 | Out-File -filepath C:\MachineInfo.txt -Append

Clear-Host;
 
    $servers = Get-Content  -path C:\computers.txt 
        ForEach ($server in $servers) {

            Write-OutPut "Checking $server information, Please wait... " 
            Write-Output "`n"
            Write-Output "Host Information:" 

            Invoke-Command -ComputerName $server -ScriptBlock { Get-ComputerInfo -Property "CsName","CsDomain","OsName","OsVersion","OsArchitecture","OsLanguage","OsProductType","WindowsInstallDateFromRegistry","WindowsSystemRoot" | Format-List }

            Write-Output "Manufacturer Information:" 

            Invoke-Command -ComputerName $server -ScriptBlock { Get-ComputerInfo -Property "CSManufacturer","CSModel","BiosSeralNumber","BiosSMBIOSBIOSVersion" | Format-List }

            Write-Output "Memory and CPU Information:" 

            Invoke-Command -ComputerName $server -ScriptBlock { Get-ComputerInfo -Property "CsProcessors","CsNumberOfProcessors","CsNumberOfLogicalProcessors","CsPhyicallyInstalledMemory" | Format-List "CsProcessors","CsNumberOfProcessors","CsNumberOfLogicalProcessors",@{label="CsPhyicallyInstalledMemory (GB)";expression={$_.CsPhyicallyInstalledMemory/1MB}}}

            Write-Output "VM Host Information:" 

            Invoke-Command -ComputerName $server -ScriptBlock { Get-ComputerInfo -Property "WindowsEditionId","HyperVRequirement*" }


            Write-Output "Machine Administrators Group" 

            $group = get-wmiobject win32_group -ComputerName $server -Filter "LocalAccount=True AND SID='S-1-5-32-544'"
            $query = "GroupComponent = `"Win32_Group.Domain='$($group.domain)'`,Name='$($group.name)'`""
            $allAdmins = Get-WmiObject win32_groupuser -ComputerName $server -Filter $query | %{$_.PartComponent} | % {$_.substring($_.lastindexof("Domain=") + 7).replace("`",Name=`"","\")}

            $alladmins

            Write-Output "`n"
            Write-Output "Machine IP Configuration:" 

 
            $ipV4 = ping $server -4

 

            $ipv6 = ping $server -6
            Write-Output "`n"
            Write-Output "IP V4:"
            $ipV4
            Write-Output "`n"
            Write-Output "IP V6:"
            $ipV6

            Write-Output "`n"
            Write-Output "Hot Fixes Installed:"
            Get-HotFix -ComputerName $server | Select-Object -Property Source, Description, HotFixID, InstalledBy, InstalledOn | Sort-Object -Property InstalledOn | Format-Table

}



