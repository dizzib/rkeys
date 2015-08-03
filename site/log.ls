Args = require \./args

function get-logger level
  if level <= Args.verbosity then console.log else ->

global.log  = get-logger 1
global.log0 = get-logger 0
global.log2 = get-logger 2
