
function Get-WindowsServerFeaturesInstalled() {

    try{

        $featuresInstalled = Get-WindowsFeature | Where-Object {$_.InstallState -eq 'Installed'}
    
        $featuresInstalled
    
    }catch [System.Management.Automation.CommandNotFoundException] {

     Write-Output 'It was not possible to retrieve windows features installed because command Not supported'
    }
}


function Export-FeaturesToCsv() {
    param([string]$filePath = 'C:\InstalledFeatures.csv', [PSObject[]]$featuresInstalled)

    $featuresInstalled | Export-Csv -Path $filePath -NoTypeInformation

}

$windowsFeaturesInstalled = Get-WindowsServerFeaturesInstalled

Export-FeaturesToCsv -featuresInstalled $windowsFeaturesInstalled