util = require 'util'
Mongolian = require 'mongolian'
server = new Mongolian
db = server.db 'bench'

justNum = (n) ->
  n.replace(/[^0-9\n\.\,]/g, '')

exports.parse = (data) ->
  console.log "Trying to parse " + data
  data = data + " "
  sections = data.split "\n---------\n" 
  sections.splice 0, 1  
  parts = []
  obj = {}
  for section in sections
    lines = section.split "\n"
    keep = (line for line in lines when line isnt '---')
    name = keep[0]
    switch name
      when "Provider" then      val = keep[2]
      when "RAM" then           val = keep[1]
      when "date" then          val = new Date(keep[2])
      when "Network"
        val = justNum keep[2]
        val = 100.0 / val
      when "IP address"
        val = keep[2].match(/\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/)[0]
        #val = justNum ips[0]
      when "Disk Write", "Disk Read"
        val = keep[4]
        val = val.match /[0-9\.]+\ [a-zA-Z]+\/s/
        val = val[0]
        val = val.split ' '
        val = val[0]
      else                      val = justNum keep[2]
    obj[name] = val
  console.log "returning from parse"
  console.log util.inspect(obj)
  obj

exports.newdata = (data) ->
  record = exports.parse data
  results = db.collection 'results'
  console.log "inserting "
  results.insert record
  
