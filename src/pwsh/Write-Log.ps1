Param(
    [string]$logMessage,
    [string]$filename
)
Function Write-Log
{
    Param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        HelpMessage="LogMessage:")]
	    [string] $logMessage,
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        HelpMessage="Filename:")]
	    [string] $filename
    )
    $date = Get-Date
    [string]$ts = $date.ToString("MM-dd-yyyy-HH:MM:ss")
    [string]$logPath = "/home/noobish/git/node-pwsh-api/src/logs/runtimelog.log"
    $outMessage = "$ts - $filename - $logMessage"
    $outMessage | out-file -Append $logPath
}
Write-Log $logMessage $fileName