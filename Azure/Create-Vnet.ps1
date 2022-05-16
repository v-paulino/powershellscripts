param([Parameter(Mandatory=$true)][string]$subscriptionId,
 [Parameter(Mandatory=$true)][string]$ResourceGroup, 
 [string]$Location = 'westeurope', 
 [string]$VNetName = "vnet-$ResourceGroup",
 [string]$VMsSubNetName ="subnet-vnet-$ResourceGroup",
 [string]$AzureBastionSubnetName ="AzureBastionSubnet",
 [string]$VNetAddressPrefix = "10.1.0.0/16",
 [string]$VMsSubNetAddressPrefix = "10.1.1.0/24",
 [string]$SubNetBastionAddressPrefix = "10.1.2.0/24"
 )

 $execDate = Get-Date
Write-Output " [$execDate] Creating VNet $VNetName ... "


Connect-AzAccount -Subscription $subscriptionId

# existing resource groups https://azuretracks.com/2021/04/current-azure-region-names-reference/
Set-AzContext -SubscriptionId $subscriptionId 

$resourceGroupFound = Get-AzResourceGroup -Name $ResourceGroup -Location $Location -ErrorAction SilentlyContinue

if($null -eq $resourceGroupFound){
    New-AzResourceGroup -Name $ResourceGroup -Location $Location
}

$vmsubnet = New-AzVirtualNetworkSubnetConfig -Name $VMsSubNetName -AddressPrefix $VMsSubNetAddressPrefix -PrivateEndpointNetworkPoliciesFlag “Disabled”

$bastionSubnet = New-AzVirtualNetworkSubnetConfig -Name $AzureBastionSubnetName -AddressPrefix $SubNetBastionAddressPrefix -PrivateEndpointNetworkPoliciesFlag “Disabled”

$vnetCreated = New-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroup -Location $Location -AddressPrefix $VNetAddressPrefix -Subnet $vmsubnet,$bastionSubnet


$execDate = Get-Date
Write-Output " [$execDate] VNet $VNetName Created !"


return $vnetCreated;