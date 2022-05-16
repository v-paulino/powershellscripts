
param([Parameter(Mandatory=$true)][string]$SubscriptionId,
[Parameter(Mandatory=$true)][string]$ResourceGroup, 
[string]$Location = 'northeurope', 
[Parameter(Mandatory=$true)][string]$VnetName,
[Parameter(Mandatory=$true)][string]$SubNetName
)


$execDate = Get-Date
Write-Output " [$execDate] Creating Standard_D2_v2  Windows Virtual Machine named $VmName ..."
 

Connect-AzAccount -Subscription $SubscriptionId

# existing resource groups https://azuretracks.com/2021/04/current-azure-region-names-reference/
Set-AzContext -SubscriptionId $SubscriptionId 

$resourceGroupFound = Get-AzResourceGroup -Name $ResourceGroup -Location $Location -ErrorAction SilentlyContinue

# Get the NICs in the subnet 

