(function() {
  var app, fs, http, processor;

  http = require("http");

  fs = require("fs");

  processor = require("./processor");

  app = http.createServer(function(req, res) {
    res.writeHead(200);
    switch (req.url) {
      case "/dobench.sh":
        return res.end(fs.readFileSync("dobench.sh"));
      case "/process":
        request.on('data', function(data) {
          return body += data;
        });
        return request.on('end', function() {
          return res.end(processor.newdata(req));
        });
      case "/":
        return res.end(fs.readFileSync("index.html"));
    }
  });

  app.listen(3000);

}).call(this);
