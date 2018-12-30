Param(
    [string]$ComputerName
)
Function Start-PwshTest
{
    Param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        HelpMessage="LogMessage:")]
	    [string] $ComputerName
    )
    $date = Get-date
    [string]$ts = $date.ToString("MM-dd-yyyy-HH:MM:ss")
<#
    [psobject]$spoolerService = get-service | select Name, Status | where{$_.Name -match "spooler"}
    
    $connTestGood = Test-Connection -ComputerName T9779POS0001 -Count 1 -Quiet
    $connTestBad = Test-Connection -Computername T9779POS0002 -Count 1 -Quiet

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
    $outObj = @{
        ComputerName = $ComputerName
        Time = $ts
    }
    Return $outObj | ConvertTo-JSON
}
Start-PwshTest -Computername $ComputerName
