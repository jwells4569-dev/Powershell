Use OperationsManager

Select Distinct MonitoringObjectPath AS Machine,
				Severity,
				TimeRaised, 
				AlertStringName,
				AlertStringDescription,
				RepeatCount
								
From dbo.AlertView

where 
dbo.AlertView.TimeRaised <= SysDateTime()
and dbo.AlertView.AlertStringName Like '%Predictive%'
or dbo.AlertView.AlertStringName Like '%degraded%'
or dbo.AlertView.AlertStringName Like '%block%'
or dbo.AlertView.AlertStringName Like '%mismatch%'
or dbo.AlertView.AlertStringName Like '%processor%'
or dbo.AlertView.AlertStringName Like '%block%'
or dbo.AlertView.AlertStringName Like '%battery%'
or dbo.AlertView.AlertStringName Like '%heartbeat%'
