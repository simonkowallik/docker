'use strict';

const PORT = 80;
const HOST = '0.0.0.0';

const express = require('express');
const fileUpload = require('express-fileupload');
var path = require('path');
const app = express();

app.use(fileUpload({
  limits: { fileSize: 500 * 1024 * 1024 },
}));
app.use(express.static('html'));

app.post('/upload', function(req, res) {
  if (Object.keys(req.files).length == 0) {
    return res.status(400).send('No files were uploaded or filesize is 0.');
  }

  let sampleFile = req.files.sampleFile;
  console.log('received filename:' + sampleFile.name
  	+ ', mimetype:' + sampleFile.mimetype
  	+ ', truncated:' + sampleFile.truncated
  	+ ', length:' + sampleFile.data.length
  	+ ', md5:' + sampleFile.md5()
  	);

  res.send('filename:' + sampleFile.name
  	+ ', mimetype:' + sampleFile.mimetype
  	+ ', truncated:' + sampleFile.truncated
  	+ ', length:' + sampleFile.data.length
  	+ ', md5:' + sampleFile.md5()
    + "\n"
  	);
  
});

app.get('/upload', function(req, res) {
    res.sendFile(path.join(__dirname + '/index.html'));
});

app.listen(PORT, HOST);
console.log(`Ready to receive requests on http://${HOST}:${PORT}`);