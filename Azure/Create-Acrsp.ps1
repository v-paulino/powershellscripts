


param([Parameter(Mandatory=$true)][string]$subscriptionId,
[Parameter(Mandatory=$true)][string]$resourceGroup, 
[Parameter(Mandatory=$true)][string]$acrName, 
[Parameter(Mandatory=$true)][string]$principalName)


Connect-AzAccount -Subscription $subscriptionId

# existing resource groups https://azuretracks.com/2021/04/current-azure-region-names-reference/
Set-AzContext -SubscriptionId $subscriptionId 

$resourceGroupFound = Get-AzResourceGroup -Name $resourceGroup -Location $location -ErrorAction SilentlyContinue

if($null -eq $resourceGroupFound){
    New-AzResourceGroup -Name $resourceGroup -Location $location
}


$registry = Get-AzContainerRegistry -Name $acrName -ResourceGroupName $resourceGroup

$servicePrincipal = New-AzADServicePrincipal -DisplayName $principalName -Scope $registry.Id -Role acrpush  

# $PASSWORD=$(az ad sp create-for-rbac --name $principalName --scopes $registry.Id --role acrpull --query "password" --output tsv)
# $USER_NAME=$(az ad sp list --display-name $principalName --query "[].appId" --output tsv)

 return $servicePrincipal;


