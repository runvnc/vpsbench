util = require 'util'
Mongolian = require 'mongolian'
server = new Mongolian
db = server.db 'bench'

justNum = (n) ->
  if n? then n.replace(/[^0-9\n\.\,]/g, '')

justNum2 = (n) ->
  if not n? then return n
  n = n.replace 's', ''
  n = n.replace(/[^0-9m\n\.\,]/g, '')
  if n.indexOf('m')>0
    s = n.split('m')
    m = s[0] * 1
    n = s[1].replace(/[^0-9\n.\,]/g, '')
    n = n * 1
    n = n + 60.0 * m
  n * 1.0

exports.parse = (data) ->
  console.log "Trying to parse " + data
  data = data + " "
  data = "\n" + data
  sections = data.split "\n---------\n" 
  sections.splice 0,1
  parts = []
  obj = {}
  for section in sections
    try 
      lines = section.split "\n"
      keep = (line for line in lines when line isnt '---')
      name = keep[0]
      switch name
        when "Provider" then      val = keep[2]
        when "RAM" then           val = keep[1]
        when "date" then          val = new Date(keep[2])
        when "Network"
          val = justNum2 keep[2]
          console.log 'secs = ' + val
          val = 100.0 / val
          console.log "network extracted " + val         
        when "IP address"
          val = keep[2].match(/\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/)[0]
        else                      val = justNum keep[2]
      obj[name] = val
    catch e
  console.log "returning from parse"
  console.log util.inspect(obj)
  obj

exports.newdata = (data) ->
  try
    record = exports.parse data
    if record is 'disk issue'
      console.log 'disk issue ' + data
    else
      results = db.collection 'results'
      results.insert record    
  catch e
    console.log e 
