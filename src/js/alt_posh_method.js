//Not sure if its even possible to pass a parameter. Looks like poshcall.js is the winner
var spawn = require("child_process").spawn,child;
child = spawn("powershell.exe",["c:\\git\\node-pwsh-api\\src\\pwsh\\Start-PwshTest.ps1"]);
child.stdout.on("data",function(data){
    console.log("Powershell Data: " + data);
});
child.stderr.on("data",function(data){
    console.log("Powershell Errors: " + data);
});
child.on("exit",function(){
    console.log("Powershell Script finished");
});
child.stdin.end(); //end input
