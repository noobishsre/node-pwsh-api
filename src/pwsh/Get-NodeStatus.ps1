Function Get-NodeStatus
{
    ###############################################################
    ## Logging Stuff and terrible method for keeping count of db it
    ###############################################################
    $functionName = $MyInvocation.MyCommand.Name 
    $writeLogScript = "/home/noobish/git/node-pwsh-api/src/pwsh/Write-Log.ps1"
    $runCtrLog = "/home/noobish/git/node-pwsh-api/src/logs/client_returndata_runctr.log"
    [int]$runCtr = Get-Content $runCtrLog
    [int]$newCount = $runCtr + 1
    $newCount | out-file $runCtrLog
    pwsh $writeLogScript -filename $functionName -logMessage "Old Count: $runCtr - New Count: $newCount"
    
    #########################################
    ## Get Timestamp and runtime for API call
    #########################################
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

    ##############################################################
    ## Pass in params from script call, create object for API POST
    ##############################################################
    $scriptname = "Get-NodeStatus.ps1"
    $body = @{
        id = $newCount
        name = $scriptname
        results = $rtrnstatus
        runtime = $runtime
        timestamp = $ts
    }
    $uri = "http://localhost:8000/client_returndata"

    $return = Invoke-WebRequest -Uri $uri -Body $body -Method POST

    Return $return
}
Get-NodeStatus
