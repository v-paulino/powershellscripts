param([Parameter(Mandatory=$true)][string]$subscriptionId,
 [Parameter(Mandatory=$true)][string]$resourceGroup, 
 [string]$location = 'westeurope', 
 [Parameter(Mandatory=$true)][string]$acrName)

 Connect-AzAccount -Subscription $subscriptionId

# existing resource groups https://azuretracks.com/2021/04/current-azure-region-names-reference/
Set-AzContext -SubscriptionId $subscriptionId 

$resourceGroupFound = Get-AzResourceGroup -Name $resourceGroup -Location $location -ErrorAction SilentlyContinue

if($null -eq $resourceGroupFound){
    New-AzResourceGroup -Name $resourceGroup -Location $location
}

$registry = New-AzContainerRegistry -ResourceGroupName $resourceGroup -Name $acrName -Sku Basic


return $registry