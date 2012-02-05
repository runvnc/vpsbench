fs = require 'fs'
pr = require './processor'
util = require 'util'

data = fs.readFileSync 'testresults3'

pr.newdata data

