param([string]$machine = "")

#clear-host

$returned = @{}
$linesep = "______________________________________________"
$erroraction = "SilentlyContinue"



while ($machine -eq "") { $machine = read-host "What machine do you want to search for?`nYou can use * to specify a wildcard as well" }
if ($machine -eq "") { exit }
elseif ($machine -eq "*") {
    write-host "`n`n`nNo, you aren't going to query all the datastores for every record.`nDo you want to storm the SQL instances? Because thats how you storm SQL instances.`n`n`n" -ForegroundColor Black -BackgroundColor Red
    exit
}
else {
    get-wttdatastore -list | foreach-object { #Query datastores
        $curdatastore = $_
        write-host "Attempting to scan $curdatastore"
        get-wttdatastore $curdatastore -SessionPersist -ErrorAction $erroraction; $con = get-wttdatastore -ErrorAction SilentlyContinue
        if ($con.DatastoreName -eq $curdatastore) { #Did we connect?
            write-host "Connected...Querying......"
            $returned.$curdatastore = Get-WttResource -Name $machine -ErrorAction $erroraction
            
            if ($returned.$curdatastore.count -gt 0) { #Did it return records?
                write-host "$($returned.$curdatastore.count) Records found on $curdatastore"
                $returned.$curdatastore | format-table Name,Status,LastHBTime,Path,LastRuntime -Wrap -AutoSize
            }
            else {
                write-host "No records found on $curdatastore"
            }
        }
        else {
            write-host "ERROR: Could not connect to $curdatastore, do you have permissions to enumerate it?"
        }
        write-host $linesep
    }        
}