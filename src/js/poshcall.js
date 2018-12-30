const shell = require('node-powershell'); //need to install module
 
let ps = new shell({
  executionPolicy: 'Bypass',
  noProfile: true
});
var testpc = 'Test-Computer';
ps.addCommand('pwsh c:\\git\\node-pwsh-api\\src\\pwsh\\Start-PwshTest.ps1 -ComputerName ' + testpc)
ps.invoke()
.then(output => {
  console.log(output);
  ps.dispose();
})
.catch(err => {
  console.log(err);
  ps.dispose();
});
