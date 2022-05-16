
param([Parameter(Mandatory=$true)][string]$Username, 
[Parameter(Mandatory=$true)][SecureString]$Password)


return New-Object System.Management.Automation.PSCredential ($username, $password)

