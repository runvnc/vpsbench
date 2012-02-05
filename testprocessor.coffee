fs = require 'fs'
pr = require './processor'
util = require 'util'

data = fs.readFileSync 'testresults5'

pr.newdata data

