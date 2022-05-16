

function Export-RecordsToCsv() {
    param([string]$filePath = 'C:\InstalledDotNetFramework.csv', [PSObject[]]$records)

    $records | Export-Csv -Path $filePath -NoTypeInformation

}

function Get-DotNetFrameworksInstalled(){

    return Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name version -EA 0 | Where { $_.PSChildName -Match '^(?!S)\p{L}'} | Select PSChildName, version
}

$recordsFound = Get-DotNetFrameworksInstalled


Export-RecordsToCsv -records $recordsFound