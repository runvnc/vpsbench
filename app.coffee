http = require "http"
fs = require "fs"
util = require "util"
processor = require "./processor"
Mongolian = require 'mongolian'
server = new Mongolian
db = server.db 'bench'

app = http.createServer (req, res) ->
  try
    res.writeHead 200 #,
      #"Content-Type": "text/plain"
    switch req.url
      when "/dobench.sh" then   res.end fs.readFileSync("dobench.sh")
      when "/graphs.js" then    res.end fs.readFileSync("graphs.js")
      when "/results"
        db.collection('results').find().toArray (err, arr) ->
          for obj in arr
            delete obj['_id']           
          res.end JSON.stringify(arr)
      when "/process"
        body = ''
        req.on 'data', (data) ->
          body += data
        req.on 'end', ->
          console.log "Processing " + body
          res.end processor.newdata(body)
      when "/" then             res.end fs.readFileSync("index.html")
      when "/indexnew.html" then res.end fs.readFileSync("indexnew.html")
  catch error
    console.log error

app.listen 3000
