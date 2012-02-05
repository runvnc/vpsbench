order = (a, b) ->
  ret = a - b
  if ret != 0 then ret /= Math.abs ret

multisort = (arr, propfuncs) ->
  arr.sort (a, b) ->
    for propfunc in propfuncs
      if typeof propfunc is 'function'
        numa = propfunc a
        numb = propfunc b
        ret = order numa, numb        
      else
        ret = order a[propfunc], b[propfunc]  
      if ret != 0 then break
    ret        

score = (obj) ->
  n = (100 - obj.CPU)
  n += obj.Network * 1
  n += obj['Disk Read'] * 1
  n += obj['Disk Write'] * 1
  1.0 / n 

process = (results) ->
  multisort results, [ score ]
  for row in results
    try
      row.Total = Math.round(1.0 / score(row))
      row.date = new Date(row.date).toLocaleDateString()
      row.CPU = 100 - row.CPU
      row['Disk Transfer'] = 100 - (row['Disk Transfer'] * 1.5)
      row.Network = Math.round(row.Network)
    catch e
      console.log e
  results
    
format = (name, val) ->
  if not val?
    ''
  else
    val

datatable = (rows) ->
  cols = ['Provider','RAM','IP address', 'Network', 'CPU', 'Disk Transfer', 'Total']
  out = "<table><thead>" 
  for col in cols
    out += "<th>#{col}</th>"
  out += "</thead><tbody>"
  for row in rows
    out += "<tr>"
    for col in cols
      out += "<td>#{format(col, row[col])}</td>"
    out += "</tr>"
  out += "</tbody></table>"

$ ->
  $.getJSON '/results', (arr) ->
    sorted = process arr
    console.log sorted
    $('#resultshere').html datatable(sorted)
    
