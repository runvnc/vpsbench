var http = require('http');
var fs = require('fs');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  console.log(req.url);
  if (req.url=='/gcdmany.sh') {
    var gcd = fs.readFileSync('gcdmany.sh');
    res.end(gcd);
  } else { 
    var index = fs.readFileSync('index.html');    
    res.end(index);
  }
}).listen(3000);
