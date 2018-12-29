Function Start-PwshTest
{
    $functionName = $MyInvocation.MyCommand.Name 
    Return $path
}
Start-PwshTest