param([Parameter(Mandatory=$true)][string]$SubscriptionId,
[Parameter(Mandatory=$true)][string]$ResourceGroup, 
[string]$Location = 'northeurope', 
[Parameter(Mandatory=$true)][string]$VnetName
)
 
$bastionName =  "$VnetName-bastion"

$execDate = Get-Date
Write-Output " [$execDate] Creating Bastion  $Name ..."
 

Connect-AzAccount -Subscription $SubscriptionId

# existing resource groups https://azuretracks.com/2021/04/current-azure-region-names-reference/
Set-AzContext -SubscriptionId $SubscriptionId 

$resourceGroupFound = Get-AzResourceGroup -Name $ResourceGroup -Location $Location -ErrorAction SilentlyContinue

if($null -eq $resourceGroupFound){
    New-AzResourceGroup -Name $ResourceGroup -Location $Location
}


$publicip = New-AzPublicIpAddress -ResourceGroupName $ResourceGroup -name "$VnetName-pip-bastion" -location $Location -AllocationMethod Static -Sku Standard

$virtualNetwork = Get-AzVirtualNetwork -Name $VnetName `
-ResourceGroupName $ResourceGroup

if($null -eq $virtualNetwork)
{
    throw "Virtual Network  $VnetName located at $ResourceGroup not found!"
}

$bastionCreated = New-AzBastion -ResourceGroupName $ResourceGroup -Name $bastionName =  "$VnetName-bastion" `
-PublicIpAddressRgName $publicip.ResourceGroupName -PublicIpAddressName $publicip.Name `
-VirtualNetworkRgName $ResourceGroup -VirtualNetworkName $VnetName `
-Sku "Standard"


$execDate = Get-Date
Write-Output " [$execDate] Bastion $VmName Created !"


Return $bastionCreated;