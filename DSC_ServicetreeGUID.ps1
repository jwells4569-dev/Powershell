Configuration RegistryUpdate



{
    param($NodeName)

    Node $NodeName

    {
        Registry Add_Change

            {
                Ensure = "Present";
                Key = "HKEY_LOCAL_MACHINES\System\EsInv"
                ValueName = 'ServiceTreeGuid'
                ValueData = 'GUID'
                ValueType = "String"
            }
    }
}
    RegistryUpdate
