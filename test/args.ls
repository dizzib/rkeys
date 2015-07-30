test = it
<- describe 'args'

M = require \mockery

function add then process.argv ++= it / ' '

after ->
  M.deregisterAll!
  M.disable!
  process.argv = process.argv-temp
before ->
  M.enable warnOnUnregistered:false useCleanCache:true
  process.argv-temp = process.argv
beforeEach ->
  M.resetCache!
  process.argv = <[node rkeys]>

describe '--servant-to' ->
  function run s, expect
    add "-s #s" if s
    T = require \../site/args
    deq T.servant-to-url, expect
  test 'void' -> run void void
  test 'host' -> run \host \ws://host:7000
  test 'host:port' -> run \host:1234 \ws://host:1234
