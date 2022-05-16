
param([Parameter(Mandatory=$true)][string]$SubscriptionId,
[Parameter(Mandatory=$true)][string]$ResourceGroup, 
[string]$Location = 'northeurope', 
[System.Management.Automation.PSCredential]$Credentials,
[Parameter(Mandatory=$true)][string]$Name,
[Parameter(Mandatory=$true)][string]$VnetName
)


$execDate = Get-Date
Write-Output " [$execDate] Creating Standard_D2_v2  Windows Virtual Machine named $VmName ..."
 

Connect-AzAccount -Subscription $SubscriptionId

# existing resource groups https://azuretracks.com/2021/04/current-azure-region-names-reference/
Set-AzContext -SubscriptionId $SubscriptionId 

$resourceGroupFound = Get-AzResourceGroup -Name $ResourceGroup -Location $Location -ErrorAction SilentlyContinue

if($null -eq $resourceGroupFound){
    New-AzResourceGroup -Name $ResourceGroup -Location $Location
}



$vnetFound = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroup

if($null -eq $vnetFound)
{
    throw "VNET  $VnetName does not exist"
}

$subnetDefault = $vnetFound.Subnets[0]


if($null -eq $Credentials)
{
    $strongPassword = . .\Create-StrongPassword.ps1 20
    Write-Output "VM Credentials: User vmadminuser; Password $strongPassword"
    $Credentials = return New-Object System.Management.Automation.PSCredential ("vmadminuser", $strongPassword)
}

# Create a public IP address and specify a DNS name
# $pip = New-AzPublicIpAddress `
#   -ResourceGroupName $ResourceGroup `
#   -Location $Location `
#   -AllocationMethod Static `
#   -IdleTimeoutInMinutes 4 `
#   -Name "$Name-PIP-$(Get-Random)"
 
# Create an inbound network security group rule for port 80
$nsgRuleWeb = New-AzNetworkSecurityRuleConfig `
  -Name myNetworkSecurityGroupRuleWWW `
  -Protocol Tcp `
  -Direction Inbound `
  -Priority 1001 `
  -SourceAddressPrefix * `
  -SourcePortRange * `
  -DestinationAddressPrefix * `
  -DestinationPortRange 80 `
  -Access Allow

# Create a network security group
$nsg = New-AzNetworkSecurityGroup `
  -ResourceGroupName $ResourceGroup `
  -Location $Location `
  -Name myNetworkSecurityGroup `
  -SecurityRules $nsgRuleWeb


$nic = New-AzNetworkInterface `
  -Name "$Name-nic" `
  -ResourceGroupName $ResourceGroup `
  -Location $Location `
  -SubnetId $subnetDefault.Id `
  -NetworkSecurityGroupId $nsg.Id
  #-PublicIpAddressId $pip.Id `
  

$VmSize = "Standard_D2_v2"

$VirtualMachine = New-AzVMConfig `
  -VMName $Name `
  -VMSize $VmSize

$VirtualMachine = Set-AzVMOperatingSystem `
  -VM $VirtualMachine `
  -Windows `
  -ComputerName $Name `
  -Credential $Credentials -ProvisionVMAgent -EnableAutoUpdate

$VirtualMachine = Set-AzVMSourceImage `
  -VM $VirtualMachine `
  -PublisherName "MicrosoftWindowsServer" `
  -Offer "WindowsServer" `
  -Skus "2019-Datacenter" `
  -Version "latest"

$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $nic.Id


# Create the VM.
New-AzVM `
  -ResourceGroupName $ResourceGroup `
  -Location $Location `
  -VM $VirtualMachine `
  -Verbose
   
$execDate = Get-Date
Write-Output " [$execDate] Windows Virtual Machine $VmName Created !"

return $vmCreated




