global.deq = require \chai .assert .deepEqual

global.log = console.log
global.log0 = console.log
global.log2 = ->
#global.log2 = console.log  # uncomment this line for verbose logging during tests

Error.stackTraceLimit = 3
