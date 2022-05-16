
param([Parameter(Mandatory=$true)][string]$resourceGroupName)

Get-AzResourceGroup -Name $resourceGroupName | Remove-AzResourceGroup -Force
