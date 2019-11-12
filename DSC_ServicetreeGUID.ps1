Configuration RegistryUpdate



{
    param($NodeName)

    Node localhost

    {
        Registry Add_AssetName

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'AssetName'
                ValueData = ''
                ValueType = "String"
            }

        
        Registry Add_AssetNumber

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'AssetNumber'
                ValueData = ''
                ValueType = "String"
            }
        
        Registry Add_AssetType

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'AssetType'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_Building

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'Building'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_Component

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'Component'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_DasAttached

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'DasAttached'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_DataLossWithPowerOutage

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'DataLossWithPowerOutage'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_EmergencyResponsePlan

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'EmergencyResponsePlan'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_EmergencyResponsePlan

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'EmergencyResponsePlan'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_Environment

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'Environment'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_Function

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'Function'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_HWFailureWithPowerOutage

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'HWFailureWithPowerOutage'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_ImpactToSchedule

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'ImpactToSchedule'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_Lab

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'Lab'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_OpsContact

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'OpsContact'
                ValueData = ''
                ValueType = "String"
            }

            
        Registry Add_PeopleImpacted

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'PeopleImpacted'
                ValueData = ''
                ValueType = "String"
            }
            
        Registry Add_Project

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'Project'
                ValueData = ''
                ValueType = "String"
            }

            
        Registry Add_Rack

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'Rack'
                ValueData = ''
                ValueType = "String"
            }
            
        Registry Add_Racku

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'Racku'
                ValueData = ''
                ValueType = "String"
            }

            
        Registry Add_Row

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'Row'
                ValueData = ''
                ValueType = "String"
            }
            
        Registry Add_SanAttached

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'SanAttached'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_SerialNumber

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'SerialNumber'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_Service

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'Service'
                ValueData = ''
                ValueType = "String"
            }
            
        Registry Add_ServiceTreeGUID

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'ServiceTreeGuid'
                ValueData = ''
                ValueType = "String"
            }

        Registry Add_VMHost

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'VMHost'
                ValueData = ''
                ValueType = "String"
            }

    }
}
    RegistryUpdate
