function Get-ComputerInstalledSoftware() {

    $computerName = $env:COMPUTERNAME
    
    $array = @()
    $getAll = Get-ChildItem -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall -Recurse
    $getAll | ForEach {
     
    $getProperties = $_ | Get-ItemProperty
    
    $getDate = $getProperties.InstallDate
    $getVersion = $getProperties.DisplayVersion
    $getDisplayName = $getProperties.DisplayName
    $getInstallLocation = $getProperties.InstallLocation
    $systemComponent = $getProperties.SystemComponent
    
    $installedProduct = New-Object PSObject

    $installedProduct | Add-Member -MemberType NoteProperty -Name DisplayName -Value $getDisplayName
    $installedProduct | Add-Member -MemberType NoteProperty -Name InstalledDate -Value $getDate
    $installedProduct | Add-Member -MemberType NoteProperty -Name Version -Value $getVersion
    $installedProduct | Add-Member -MemberType NoteProperty -Name SystemComponent -Value $systemComponent
    $installedProduct | Add-Member -MemberType NoteProperty -Name InstallLocation -Value $getInstallLocation
     
    $array += $installedProduct
     
    }
    return $array 
    
    }

    # If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    # {
    # # Relaunch as an elevated process:
    # Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    # exit
    # }


    function Export-InstalledSoftwareToCsv() {
        param([string]$filePath = 'C:\InstalledSoftware.csv', [PSObject[]]$productsInstalled)

        $productsInstalled | Export-Csv -Path $filePath -NoTypeInformation

    }

    $programsInstalled = Get-ComputerInstalledSoftware
    Export-InstalledSoftwareToCsv -productsInstalled $programsInstalled