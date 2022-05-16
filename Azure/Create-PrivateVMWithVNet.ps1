
# .\Create-PrivateVMWithVNet.ps1 -SubscriptionId 20410346-1177-4425-9c5a-86b20c84189a -ResourceGroup "automatedresources" -VmName "windowsMachine01FromPSM"
param([Parameter(Mandatory=$true)][string]$SubscriptionId,
[Parameter(Mandatory=$true)][string]$ResourceGroup, 
[string]$Location = 'northeurope', 
[string]$VmName ="windowsServer01",
[string]$VNetName = "virtualnetwork",
[string]$SubNetName = "defaultsubnet")


$startDate = Get-Date
Write-Output " [$startDate] - Starting Creating Private Windows VM ... " 


Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

$execDate = Get-Date
Write-Output " [$execDate] Generating Strong password for user vmadminuser.... "

$password = . .\Create-StrongPassword -PasswordLenght 10
$execDate = Get-Date
Write-Output " [$execDate] Password generated for Username: vmadminuser Password: $password"

$strongPassword = ConvertTo-SecureString $password -AsPlainText -Force 

$execDate = Get-Date
Write-Output " [$execDate] Creating VNet $VNetName ... "
$vnetCreated = . .\Create-Vnet.ps1 -subscriptionId $subscriptionId -Location $Location -ResourceGroup $resourceGroup -VNetName $VNetName -VMsSubNetName $SubNetName  

$execDate = Get-Date
Write-Output " [$execDate] VNet $VNetName Created !"

$execDate = Get-Date
Write-Output " [$execDate] Creating VM Admin Login Credentials to user vmadminuser ... "
$credentials = . .\Create-Credentials.ps1 -Username "vmadminuser" -Password $strongPassword
$execDate = Get-Date
Write-Output " [$execDate]Credentials to user vmadminuser Created !"

$execDate = Get-Date
Write-Output " [$execDate] Creating Standard_D2_v2  Windows Virtual Machine named $VmName ..."
$vmCreated =  . .\Create-WindowsVM.ps1 -subscriptionId $subscriptionId -Location $Location -ResourceGroup $resourceGroup -Name $VmName -Credentials $credentials -VnetName  $VNetName
$execDate = Get-Date
Write-Output " [$execDate] Windows Virtual Machine $VmName Created "

. .\Install-IISFeature.ps1 -SubscriptionId $subscriptionId -ResourceGroup $resourceGroup -Location $Location -Name $VmName -Credentials $credentials

$endDate = Get-Date
$timeTaken = New-TimeSpan -Start $startDate -End $endDate

Write-Output " [$endDate] - Script Finished ! It Took $timeTaken to complete" 