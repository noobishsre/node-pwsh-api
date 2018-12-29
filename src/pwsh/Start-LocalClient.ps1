<# Sample JSON for Queue
{
    "script_name":"Get-NodeStatus.ps1",
    "host_name":"dirka"
}
#>
Function Start-LocalClient
{
    $functionName = $MyInvocation.MyCommand.Name 
    $writeLogScript = "/home/dirka/git/node-pwsh-api/src/pwsh/Write-Log.ps1"
    $jobsJsonFile = "/home/dirka/git/node-pwsh-api/src/queue/jobs.json"
    $run = $true
    $ctr = 0
    while($run -eq $true)
    {
        start-sleep -s 5
        $queue = Get-Content $jobsJsonFile
        pwsh $writeLogScript -filename $functionName -logMessage "Beginning run of $functionName"
        if($ctr -eq 2)  
        {
            $run = $false
        }
        pwsh $writeLogScript -filename $functionName -logMessage "Beginning Loop..."
        if($queue -ne $Null)
        {
            pwsh $writeLogScript -filename $functionName -logMessage "New Job Available"
            $content = $queue | convertfrom-json
            $scriptname = $content.script_name
            $targetHost = $content.host_name
            pwsh $writeLogScript -filename $functionName -logMessage "Scriptname: $scriptname`nTarget Host: $targetHost"
            $scriptpath = "/home/dirka/git/node-pwsh-api/src/pwsh/$scriptname"
            pwsh $writeLogScript -filename $functionName -logMessage "Running job $scriptname"
            pwsh $scriptpath
            $run = $false
        }
        else
        {
            Write-Host "No Jobs Available, creating mock job"
            [psobject]$outObj = @{
                script_name = "Get-NodeStatus.ps1"
                host_name = "dirka"
            }
            if($ctr -gt 0 -and $ctr -lt 2)
            {
                Write-Host "Outputting json object"
                $outObj | Convertto-Json | out-file $jobsJsonFile
            }
        }
        $ctr += 1
    }
}
Start-LocalClient
