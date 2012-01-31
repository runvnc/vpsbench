http = require "http"
fs = require "fs"
processor = require "./processor"

app =http.createServer (req, res) ->
  res.writeHead 200 #,
    #"Content-Type": "text/plain"
  switch req.url
    when "/gcdmany.sh" then   res.end fs.readFileSync("gcdmany.sh")
    when "/disk.sh" then     res.end fs.readFileSync("disk.sh")
    when "/dobench.sh" then   res.end fs.readFileSync("dobench.sh")
    when "/process" then      res.end processor.newdata(req)
    when "/" then             res.end fs.readFileSync("index.html")

app.listen 3000
