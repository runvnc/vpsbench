order = (a, b) ->
  ret = a - b
  if ret != 0 then ret /= Math.abs ret

multisort = (arr, propfuncs) ->
  arr.sort (a, b) ->
    for propfunc in propfuncs
      if typeof propfunc is func
        numa = propfunc a
        numb = propfunc b
        ret = order numa, numb        
      else
        ret = order a[propfunc], b[propfunc]  
      if ret != 0 then break
    ret        

score = (obj) ->
  n = (100 - obj.CPU)
  n += obj.Network
  n += obj['Disk Read']
  n += obj['Disk Write']
  1.0 / n 

process = (results) ->
  multisort results, [ 'RAM', score ]
    

$ ->
  $.getJSON '/results', (arr) ->
    sorted = process arr
    console.log sorted 
    
