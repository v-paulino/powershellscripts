
param([Parameter(Mandatory=$true)][string]$subscriptionId,
 [Parameter(Mandatory=$true)][string]$resourceGroup, 
 [string]$location = 'westeurope', 
 [Parameter(Mandatory=$true)][string]$clusterName)


    $kubeVersion = "1.20.5"
    $nodeVmSize = "Standard_D2_v2"
    $maxPodCount = 25
    $nodeName = "defnode"
    $nodeCount = 2
    $nodeMinCount = 1
    $nodeMaxCount = 10
    $nodeDiskSize = 30
    $nodeVmSetType = "VirtualMachineScaleSets"
    $nodeOsType = "Linux"
    $enableAutoScaling = $true
    $enableRbac = $true
    $loadBalancerSku = "Standard"
    $linuxAdminUser = "vpaulino"
    $dnsNamePrefix = "csscases"
    

Connect-AzAccount -Subscription $subscriptionId

# existing resource groups https://azuretracks.com/2021/04/current-azure-region-names-reference/
Set-AzContext -SubscriptionId $subscriptionId 

$resourceGroupFound = Get-AzResourceGroup -Name $resourceGroup -Location $location -ErrorAction SilentlyContinue

if($null -eq $resourceGroupFound){
    New-AzResourceGroup -Name $resourceGroup -Location $location
}

$aksCreated = New-AzAksCluster -ResourceGroupName $resourceGroup -Name $clusterName `
            -KubernetesVersion $kubeVersion -EnableRbac -LoadBalancerSku $loadBalancerSku -LinuxProfileAdminUserName $linuxAdminUser -DnsNamePrefix $dnsNamePrefix `
            -NodeName $nodeName -EnableNodeAutoScaling  -NodeCount $nodeCount -NodeOsDiskSize $nodeDiskSize -NodeVmSize $nodeVmSize `
            -NodeMaxCount $nodeMaxCount -NodeMinCount $nodeMinCount -NodeMaxPodCount $maxPodCount -NodeSetPriority Regular -NodeScaleSetEvictionPolicy Deallocate -NodeVmSetType VirtualMachineScaleSets
            
    
return $aksCreated;