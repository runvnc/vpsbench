http = require "http"
fs = require "fs"
processor = require "./processor"
Mongolian = require 'mongolian'
server = new Mongolian
db = server.db 'bench'

app = http.createServer (req, res) ->
  res.writeHead 200 #,
    #"Content-Type": "text/plain"
  switch req.url
    when "/dobench.sh" then   res.end fs.readFileSync("dobench.sh")
    when "/results"
      results = db.collection('results').find()
      res.end results
    when "/process"
      body = ''
      req.on 'data', (data) ->
        body += data
      req.on 'end', ->
        console.log "Processing " + body
        res.end processor.newdata(body)
    when "/" then             res.end fs.readFileSync("index.html")

app.listen 3000
