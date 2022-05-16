

$InboundRulesDomain = Get-NetFirewallRule -Direction Inbound | Where-Object {$_.Profile -eq 'Domain' -or $_.Profile -eq 'Any'}
$InboundRulesDomain | Select-Object -Property DisplayName,Profile,Enabled | Sort-Object -Property DisplayName

$InboundDomainPorts = $InboundRulesDomain | Get-NetFirewallPortFilter | Select-Object -Property InstanceID,Protocol,LocalPort,RemotePort
$InboundDomainPorts | Sort-Object -Property InstanceID
 
#  $InboundDomainPorts | Export-Csv -Path 'C:\FireWallPortReport.csv'
#  Import-Csv -Path 'C:\FireWallPortReport.csv' | Out-GridView