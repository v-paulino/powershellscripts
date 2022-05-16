
# Set-ExecutionPolicy RemoteSigned

# show for each application pool their worker process and for that list the following information

# application pool name, PID, CP, Threads, Memory 

$WorkerProcessesStatus = New-Object PSObject

$WorkerProcessesStatus | Add-Member -MemberType NoteProperty -Name AppPoolName -Value 'None'
$WorkerProcessesStatus | Add-Member -MemberType NoteProperty -Name ProcessId -Value 0

$WorkerProcessesStatus | Add-Member -MemberType NoteProperty -Name Threads -Value 0
$WorkerProcessesStatus | Add-Member -MemberType NoteProperty -Name Memory -Value 0


$workerProcesses = Get-WmiObject -NameSpace 'root\WebAdministration' -Class 'WorkerProcess' | Select AppPoolName, ProcessId
 


 $processCounters = @();

  $workerProcesses | ForEach-Object{

    $Counters = @("\Process($($p1.InstanceName+$p1.InstanceId))\% Processor Time", "\Process($($p1.InstanceName+$p1.InstanceId))\Thread Count" );

    $p = $((Get-Counter '\Process(*)\ID Process' -ErrorAction SilentlyContinue).CounterSamples | % {[regex]$a = "^.*\($([regex]::Escape($_.InstanceName))(.*)\).*$";[PSCustomObject]@{InstanceName=$_.InstanceName;PID=$_.CookedValue;InstanceId=$a.Matches($($_.Path)).groups[1].value}})
    $id = $_.ProcessId
    $p1 = $p | where {$_.PID -eq $id}
    $processorTime = ((Get-Counter -Counter "\Process($($p1.InstanceName+$p1.InstanceId))\% Processor Time" -MaxSamples 10).CounterSamples).CookedValue
    $threadCount = ((Get-Counter -Counter "\Process($($p1.InstanceName+$p1.InstanceId))\Thread Count" -MaxSamples 10).CounterSamples).CookedValue
    

    
    # Get Computer Object
    $CompObject =  Get-WmiObject -Class WIN32_OperatingSystem
    $Memory = ((($CompObject.TotalVisibleMemorySize - $CompObject.FreePhysicalMemory)*100)/ $CompObject.TotalVisibleMemorySize)
    
    
    $processMemoryUsage = Get-WmiObject WIN32_PROCESS | Sort-Object -Property ws -Descending | Where-Object( $_.ProcessId -eq ) | Select-Object processname, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}
    
    

    Write-Host "Total Memory usage in Percentage:" $Memory
    Write-Host "Process Memory usage in Percentage:" $processMemoryUsage
    


    $workerProcessStatus = New-Object PSObject

    $workerProcessStatus | Add-Member -MemberType NoteProperty -Name AppPoolName -Value $_.AppPoolName
    $workerProcessStatus | Add-Member -MemberType NoteProperty -Name ProcessId -Value $_.ProcessId
    $workerProcessStatus | Add-Member -MemberType NoteProperty -Name Cpu -Value $processorTime
    $workerProcessStatus | Add-Member -MemberType NoteProperty -Name Threads -Value $threadCount
    $workerProcessStatus | Add-Member -MemberType NoteProperty -Name Memory -Value $processMemoryUsage
    $workerProcessStatus | Add-Member -MemberType NoteProperty -Name Network -Value 0

$processCounters +=$workerProcessStatus;
 #   $id = $_.ProcessId
    
 #   $proc = (Get-Process -Id $id)
 #   $proc
#     $results = Get-Process -Name $proc | ForEach 
#     {
#         [PSCustomObject]@{
#         'AppPool' =  $_.AppPoolName
#         'ProcessName' = $PSItem.ProcessName
#         'ProcessId' = $PSItem.Id
#         'Path' = $PSItem.Path
#         'Cookedvalue'  = ((Get-Counter -Counter "\Process($($PSItem.Name))\% Processor Time").CounterSamples).CookedValue
#         } 
#     }

}

$processCounters

 