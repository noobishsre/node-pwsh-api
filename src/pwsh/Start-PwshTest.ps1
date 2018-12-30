###############################################
## Leading param declarations for function call
###############################################
Param(
    [string]$ComputerName,
    [string]$osarchitecture
)
Function Start-PwshTest
{
    Param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        HelpMessage="Hostname:")]
	    [string] $ComputerName,
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        HelpMessage="OS Architecture:")]
	    [string] $osarchitecture
    )
    ###############################################################
    ## Logging Stuff and terrible method for keeping count of db it
    ###############################################################
    $functionName = $MyInvocation.MyCommand.Name
    $writeLogScript = "/home/noobish/git/node-pwsh-api/src/pwsh/Write-Log.ps1"
    $runCtrLog = "/home/noobish/git/node-pwsh-api/src/logs/noobish_hosts_runctr.log"
    [int]$runCtr = Get-Content $runCtrLog
    [int]$newCount = $runCtr + 1
    $newCount | out-file $runCtrLog
    pwsh $writeLogScript `
        -filename $functionName `
        -logMessage "Old Count: $runCtr - New Count: $newCount"
<#

    $date = Get-date
    [string]$ts = $date.ToString("MM-dd-yyyy-HH:MM:ss")
    [psobject]$spoolerService = get-service | `
                                select Name, Status | `
                                where{$_.Name -match "spooler"}
    
    $connTestGood = Test-Connection -ComputerName testpc1 -Count 1 -Quiet
    $connTestBad = Test-Connection -Computername testpc2 -Count 1 -Quiet

    $functionName = $MyInvocation.MyCommand.Name 
    [psobject]$outObj = @{
        Date = $ts
        ComputerName = $ComputerName
        FunctionName = $functionName
        SpoolerObj = @{
            Name = $spoolerService.Name
            Status = $spoolerService.Status
        }
        GoodConnTest = $connTestGood
        BadConnTest = $connTestBad
    }
    if(Test-Path -Path c:\temp\pwshouttest.txt)
    {
        Remove-Item C:\temp\pwshouttest.txt -Force
    }
    $outObj | out-file c:\temp\pwshouttest.txt
#>
    
    ##############################################################
    ## Pass in params from script call, create object for API POST
    ##############################################################
    $body = @{
        id = $newCount
        hostname = $ComputerName
        os = $osarchitecture
    }
    $uri = "http://localhost:8000/noobish_hosts"

    $return = Invoke-WebRequest -Uri $uri -Body $body -Method POST
    
    Return $return
}
Start-PwshTest -Computername $ComputerName -osarchitecture $osarchitecture
