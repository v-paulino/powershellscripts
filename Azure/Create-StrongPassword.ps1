
param([Parameter(Mandatory=$true)][int]$PasswordLenght)
 


$uppercase = "ABCDEFGHKLMNOPRSTUVWXYZ".tochararray() 
$lowercase = "abcdefghiklmnoprstuvwxyz".tochararray() 
$number = "0123456789".tochararray() 
$special = "$%&/()=?}{@#*+!".tochararray() 


$password =($uppercase | Get-Random -count 1) -join ''
$password +=($lowercase | Get-Random -count 5) -join ''
$password +=($number | Get-Random -count 1) -join ''
$password +=($special | Get-Random -count 1) -join ''

$passwordarray=$password.tochararray() 
$scrambledpassword=($passwordarray | Get-Random -Count $PasswordLenght) -join ''
 

return $scrambledpassword
