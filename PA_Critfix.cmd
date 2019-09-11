REM Written by Jim Wells (Design Labratory Inc)

Echo Running Crit Fix
	Echo Downloading Crit Fix to %systemdrive%\tools\Critfix
		robocopy.exe /E /IT "\\tkfiltoolbox\tools\23649\latest.release" "%systemdrive%\tools\critfix"
		Echo Starting Critfix	
			%systemdrive%\tools\critfix\critfix.exe /Source http://PA-WSUS.redmond.corp.microsoft.com:8530 /Log %systemdrive%\tools\critfix\Log.txt /contenttype all /checkduplicate /nodriverupdate /restart auto /ignoreuserinput /wudebug /report C:\CritFixReport\%computername%#CritFixReport.xml
				Echo Done
					timeout /t 5 