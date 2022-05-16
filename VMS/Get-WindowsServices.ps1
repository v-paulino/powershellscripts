


function Get-WellknownWindowsServices(){
    param([PSObject[]]$servicesNames)    
    
    $iisServices = @()
    
    $servicesNames | ForEach-Object{
        $service = New-Object PSObject
    
        try{
            $service | Add-Member -MemberType NoteProperty -Name Status -Value 'Not Found'
            $service | Add-Member -MemberType NoteProperty -Name Name -Value $_
            $service | Add-Member -MemberType NoteProperty -Name DisplayName -Value $_
            $service | Add-Member -MemberType NoteProperty -Name Logon -Value 'LocalSystem'
            $service | Add-Member -MemberType NoteProperty -Name EventsWarnings -Value 0
            $service | Add-Member -MemberType NoteProperty -Name EventsErrors -Value 0
            $iisServices += $service;
        }catch{
        }
    }

    $iisServices | ForEach-Object{
        
        $serviceFoundInConsole = New-Object PSObject
        try{
            $name = $_.Name
            $serviceFoundInConsole = Get-Service | Where-Object {$_.Name -eq $name } -ErrorAction SilentlyContinue
            $_.Logon = (Get-WmiObject Win32_Service -Filter "Name='$name'").StartName
            if(!$serviceFoundInConsole)
            {
                $_.Status = 'Not Found'    
                
            }else{
                $_.Status = $serviceFoundInConsole.Status

                $errorEventLogEntries =  Get-EventLog -LogName System -Source $name -EntryType Error -ErrorAction SilentlyContinue
                $warningEventLogEntries = Get-EventLog -LogName System -Source $name -EntryType Warning -ErrorAction SilentlyContinue
                
                $_.EventsWarnings = $warningEventLogEntries.Count
                $_.EventsErrors = $errorEventLogEntries.Count
            }
            
            $_.DisplayName = $serviceFoundInConsole.DisplayName

        }catch
        {
            
        }
    }
    return $iisServices  

}

function Export-Services() {
    param([string]$filePath , [PSObject[]]$services)

    $iisServices | Export-Csv -Path $filePath -NoTypeInformation

}


echo '======================================================== IIS Services ==========================================='

$iisServicesNames = @('AppHostSVC', 'FTPSVC', 'IISADMIN', 'MSFTPSVC', 'W3SVC', 'WAS', 'WMSVC', 'MsDepSvc', 'w3logsvc');
$iisServicesFound = Get-WellknownWindowsServices -servicesNames $iisServicesNames
Export-Services -filePath $PWD -services $iisServicesFound 

echo '======================================================== WCF Services ==========================================='
$wcfServicesNames = @('NetMsmqActivator', 'NetPipeActivator', 'NetTcpActivator', 'NetTcpPortSharing');
$wcfServicesFound = Get-WellknownWindowsServices -servicesNames $wcfServicesNames
Export-Services -filePath $PWD -services $wcfServicesFound 

