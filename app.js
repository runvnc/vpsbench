(function() {
  var Mongolian, app, db, fs, http, processor, server;

  http = require("http");

  fs = require("fs");

  processor = require("./processor");

  Mongolian = require('mongolian');

  server = new Mongolian;

  db = server.db('bench');

  app = http.createServer(function(req, res) {
    var body, results;
    res.writeHead(200);
    switch (req.url) {
      case "/dobench.sh":
        return res.end(fs.readFileSync("dobench.sh"));
      case "/results":
        results = db.collection('results').find();
        return res.end(results);
      case "/process":
        body = '';
        req.on('data', function(data) {
          return body += data;
        });
        return req.on('end', function() {
          console.log("Processing " + data);
          return res.end(processor.newdata(body));
        });
      case "/":
        return res.end(fs.readFileSync("index.html"));
    }
  });

  app.listen(3000);

}).call(this);
