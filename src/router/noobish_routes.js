var ObjectID = require('mongodb').ObjectID;
var express = require('express');
var request = require('request');
var app = express();
const shell = require('node-powershell'); //need to install module
 

module.exports = function(app, db) {
    app.get('/noobish_hosts/:id', (req, res) => {
        const id = req.params.id;
        const details = { '_id': id };
        db.collection('noobish_hosts').findOne(details, (err, item) => {
        if (err) {
          res.send({'error':'An error has occurred'});
        } else {
          res.send(item);
        } 
      });
    });


  app.get('/job_queue', (req, res) => {
      const getall = {req};
      db.collection('job_queue').find(getall, (err,item) => {
        //var info = JSON.parse(item)
        
        if (err) {
          res.send({'error': 'An error has occurred'})
        } else {
          res.send(JSON.parse(item));
        }
      });
    });

    app.post('/noobish_hosts', (req, res) => {
      /*
      var testpc = 'PCName-AsVar';
      let ps = new shell({
        executionPolicy: 'Bypass',
        noProfile: true
      });
      ps.addCommand('powershell c:\\temp\\Start-PwshTest.ps1 -ComputerName ' + testpc)
      ps.addCommand('pwsh /home/noobish/git/node-pwsh-api/src/pwsh/Start-PwshTest.ps1 -ComputerName' + testpc)
      ps.invoke()
      .then(output => {
        console.log(output);
        ps.dispose();
      })
      .catch(err => {
        console.log(err);
        ps.dispose();
      });
      */
      const id = req.body.id;
      const note = { '_id':id,hostname: req.body.hostname, os: req.body.os };
      //Confirmed the following works
      //const note = { '_id':id,hostname: testpc, os: req.body.os };
      db.collection('noobish_hosts').insert(note, (err, result) => {
      if (err) { 
        res.send({ 'error': 'An error has occurred' }); 
      } else {
        res.send(result.ops[0]);
      }
      });
    });

    
    app.post('/client_returndata', (req, res) => {
      const id = req.body.id;
      const note = { '_id':id,name: req.body.name, results: req.body.results, runtime: req.body.runtime, timestamp: req.body.timestamp };
      db.collection('client_returndata').insert(note, (err, result) => {
      if (err) { 
        res.send({ 'error': 'An error has occurred' }); 
      } else {
        res.send(result.ops[0]);
      }
      });
    });
  
    app.delete('/noobish_hosts/:id', (req, res) => {
      const id = req.params.id;
      const details = { '_id': new ObjectID(id) };
      db.collection('noobish_hosts').remove(details, (err, item) => {
      if (err) {
        res.send({'error':'An error has occurred'});
      } else {
        res.send('Note ' + id + ' deleted!');
      } 
      });
    });

    app.put('/noobish_hosts/:id', (req, res) => {
      const id = req.params.id;
      const details = { '_id': new ObjectID(id) };
      const note = { hostname: req.body.hostname, os: req.body.os };
      db.collection('noobish_hosts').update(details, note, (err, result) => {
      if (err) {
          res.send({'error':'An error has occurred'});
      } else {
          res.send(note);
      } 
    });
  });
};
