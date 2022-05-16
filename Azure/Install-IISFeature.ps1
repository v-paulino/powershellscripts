param([string]$SubscriptionId,
[string]$ResourceGroup,
[string]$Location,
[string]$Name,
[System.Management.Automation.PSCredential]$Credentials)

$execDate = Get-Date
Write-Output " [$execDate] Installing IIS Feature on Windows Virtual Machine named $Name ..."


Connect-AzAccount -Subscription $SubscriptionId

# existing resource groups https://azuretracks.com/2021/04/current-azure-region-names-reference/
Set-AzContext -SubscriptionId $SubscriptionId 

Set-AzVMExtension -ResourceGroupName $ResourceGroup `
    -ExtensionName "IIS" `
    -VMName $Name `
    -Location $Location `
    -Publisher Microsoft.Compute `
    -ExtensionType CustomScriptExtension `
    -TypeHandlerVersion 1.8 `
    -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'

    $execDate = Get-Date
    Write-Output " [$execDate] IIS Feature on Windows Virtual Machine named $Name Installed !"
    
# $port = Get-AzureEndpoint -Name PowerShell -VM (Get-AzureVM -ServiceName $Name -Name $Name) | Select-Object -ExpandProperty Port
# $sessionoption = New-PSSessionOption -SkipCACheck
# $session =  New-PSSession -ComputerName $Name -Credential $Credentials -Port $port -UseSSL -SessionOption $sessionoption -Verbose

# $getstatus = Get-AzureVM  -ServiceName $Name -name $name | Select-Object InstanceStatus, PowerState -Verbose
# if ($getstatus -match "ReadyRole" -and "Started") 
# {
#     Write-Host "Server is Ready, Connecting Now"; Enter-PSSession -Session $session
# }
# else {Write-Host "Unable to Connect, Something Wrong, Try Again"; $getstatus }

# #Once PSSession  starts then it should install Webserver Role in remote server
# #Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools -Verbose

# Invoke-Command -Session $session  -ScriptBlock {Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools -Verbose} -Verbose