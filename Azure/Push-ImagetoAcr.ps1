
# .\Push-ImagetoAcr.ps1 -subscriptionId 20410346-1177-4425-9c5a-86b20c84189a 
# -acrName csswebapps -principalName vpacrprincipal -principalPassword '.-07Q~6n9EYP1SN2JCl1gHsG4CocoVcLQhPg7'  
# -resourceGroup webappstrainning -namespace ticketsrazorpages 
# -localimagename azuresignalrrazorpages:latest -acrimagename azuresignalrrazorpages:v1

param([Parameter(Mandatory=$true)][string]$subscriptionId,
[Parameter(Mandatory=$true)][string]$resourceGroup, 
[Parameter(Mandatory=$true)][string]$acrName,
[Parameter(Mandatory=$true)][string]$principalName,
[Parameter(Mandatory=$true)][string]$principalPassword,
[Parameter(Mandatory=$true)][string]$namespace,
[Parameter(Mandatory=$true)][string]$localimagename,
[Parameter(Mandatory=$true)][string]$acrimagename
)
 
Connect-AzAccount -Subscription $subscriptionId

# existing resource groups https://azuretracks.com/2021/04/current-azure-region-names-reference/
Set-AzContext -SubscriptionId $subscriptionId

$registry = Get-AzContainerRegistry -Name $acrName -ResourceGroupName $resourceGroup

$principal = Get-AzADServicePrincipal -DisplayName $principalName

Write-Output "local image name is $localimagename"

$loginServer = $registry.LoginServer

$acrImageName = "$loginServer/$namespace/$acrimagename"

Write-Output "ACR image name is $acrImageName"

docker tag "$localimagename" $acrImageName

docker images $acrImageName

docker login $loginServer  -u $principal[1].AppId -p $principalPassword

docker push $acrImageName

docker rmi $acrImageName
