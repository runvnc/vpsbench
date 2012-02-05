(function() {
  var Mongolian, app, db, fs, http, processor, server, util;

  http = require("http");

  fs = require("fs");

  util = require("util");

  processor = require("./processor");

  Mongolian = require('mongolian');

  server = new Mongolian;

  db = server.db('bench');

  app = http.createServer(function(req, res) {
    var body;
    try {
      res.writeHead(200);
      switch (req.url) {
        case "/dobench.sh":
          return res.end(fs.readFileSync("dobench.sh"));
        case "/graphs.js":
          return res.end(fs.readFileSync("graphs.js"));
        case "/results":
          return db.collection('results').find().toArray(function(err, arr) {
            var obj, _i, _len;
            for (_i = 0, _len = arr.length; _i < _len; _i++) {
              obj = arr[_i];
              delete obj['_id'];
            }
            return res.end(JSON.stringify(arr));
          });
        case "/process":
          body = '';
          req.on('data', function(data) {
            return body += data;
          });
          return req.on('end', function() {
            console.log("Processing " + body);
            return res.end(processor.newdata(body));
          });
        case "/":
          return res.end(fs.readFileSync("index.html"));
      }
    } catch (error) {
      return console.log(error);
    }
  });

  app.listen(3000);

}).call(this);
