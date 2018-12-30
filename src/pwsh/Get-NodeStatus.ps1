Function Get-NodeStatus
{
    $writeLogScript = "/home/dirka/git/node-pwsh-api/src/pwsh/Write-Log.ps1"
    $functionName = $MyInvocation.MyCommand.Name 
    $runCtrLog = "/home/dirka/git/node-pwsh-api/src/logs/client_returndata_runctr.log"
    [int]$runCtr = Get-Content $runCtrLog
    [int]$newCount = $runCtr + 1
    pwsh $writeLogScript -filename $functionName -logMessage "Old Count: $runCtr - New Count: $newCount"
    $date = Get-date
    [string]$ts = $date.ToString("MM-dd-yyyy-HH:MM:ss")
    $measure = Measure-Command{$procs = Get-Process | where{$_.ProcessName -match "node"}}
    if($a -ne $NULL)
    {
        write-host "yay"
        $rtrnstatus = "0"
    }
    else
    {
        $rtrnstatus = "1"
    }
    $rtseconds = $measure.TotalSeconds
    [string]$runtime = [math]::Round($rtseconds,4)
    pwsh $writeLogScript -filename $functionName -logMessage "Runtime seconds: $runtime"
    $name = "Get-NodeStatus.ps1"
    $body = @{
        id = $newCount
        name = $name
        results = $rtrnstatus
        runtime = $runtime
        timestamp = $ts
    }
    #$body = $body | convertto-json
    $uri = "http://localhost:8000/client_returndata"

    Invoke-WebRequest -Uri $uri -Body $body -Method POST

    pwsh $writeLogScript -filename $functionName -logMessage 'Removing runctr.log'
    Remove-Item $runCtrLog -Force
    pwsh $writeLogScript -filename $functionName -logMessage "Creating new runctr log"
    $newCount | out-file $runCtrLog
    
}
Get-NodeStatus
