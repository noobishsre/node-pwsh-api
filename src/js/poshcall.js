const shell = require('node-powershell');
 
let ps = new shell({
  executionPolicy: 'Bypass',
  noProfile: true
});
 
ps.addCommand('echo node-powershell')
ps.invoke()
.then(output => {
  console.log(output);
})
.catch(err => {
  console.log(err);
  ps.dispose();
});