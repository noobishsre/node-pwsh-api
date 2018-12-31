<# Sample JSON from Queue
{
    "script_name":"Get-NodeStatus.ps1",
    "host_name":"dirka"
}
#>
#############################################
## This function is intended to continuously
## run locally where it monitors a json file
## for jobs to perform. When a job is added
## to the json file, it is executed
#############################################
Function Start-LocalClient
{
    ###################################
    ## Logging helpers and declarations
    ###################################
    $functionName = $MyInvocation.MyCommand.Name 
    $writeLogScript = "/home/noobish/git/node-pwsh-api/src/pwsh/Write-Log.ps1"
    $jobsJsonFile = "/home/noobish/git/node-pwsh-api/src/queue/jobs.json"
    $run = $true
    $loopctr = 0

    ###############
    ## Runtime loop
    ###############
    while($run -eq $true)
    {
        #################################
        ### Sleep, check for content, log
        #################################
        start-sleep -s 5
        $queue = Get-Content $jobsJsonFile
        pwsh $writeLogScript -filename $functionName -logMessage "Beginning run of $functionName"
        if($ctr -eq 2)  
        {
            $run = $false
        }
        
        ############################################
        ## If queue is not null, read from jobs.json
        ## for execution data and run. For testing,
        ## if no jobs exist, create a fake one
        ###########################################
        if($queue -ne $Null)
        {
            pwsh $writeLogScript -filename $functionName -logMessage "New Job Available"
            $content = $queue | convertfrom-json
            $scriptname = $content.script_name
            $targetHost = $content.host_name
            pwsh $writeLogScript -filename $functionName -logMessage "Scriptname: $scriptname`nTarget Host: $targetHost"
            $scriptpath = "/home/noobish/git/node-pwsh-api/src/pwsh/$scriptname"
            pwsh $scriptpath
            $run = $false
        }
        else
        {
            Write-Host "No Jobs Available, creating mock job"
            [psobject]$outObj = @{
                script_name = "Get-NodeStatus.ps1"
                host_name = "testpc1"
            }
            if($loopctr -gt 0 -and $loopctr -lt 2)
            {
                Write-Host "Outputting json object"
                $outObj | Convertto-Json | out-file $jobsJsonFile
            }
        }
        $loopctr += 1
    }# while($run -eq $true)
}# Function Start-LocalClient

Start-LocalClient
