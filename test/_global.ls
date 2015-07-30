A = require \chai .assert

global.deq = A.deepEqual
global.log = console.log

Error.stackTraceLimit = 3
