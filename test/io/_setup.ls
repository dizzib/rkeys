L = require \lolex
const SITE = '../../site'

before (done )->
  require "#SITE/args"
    ..dirs = [ __dirname ]
    ..verbosity = 1
  <- require \wait.for .launchFiber
  global.log = require "#SITE/log"
  global.io  = emit: (id, msg)-> global.out.push "io:#id,#msg"
  require \child_process
    ..exec = -> global.out.push "ex:#it"
  require "#SITE/io/x11/buttonsim"
    ..down = -> global.out.push "bd:#it"
    ..up   = -> global.out.push "bu:#it"
  require "#SITE/io/x11/keysim"
    ..down = -> global.out.push "d:#it"
    ..up   = -> global.out.push "u:#it"
  require "#SITE/io/command"
  done!

beforeEach ->
  global.clock = L.install global
  global.out   = []

global.test = it
