require \../site/args
  ..dirs = [ __dirname ]
  ..verbosity = 2

test = it
<- require \wait.for .launchFiber
global.log = require \../site/log

A   = require \chai .assert
_   = require \lodash
Api = require \../site/io/api
C   = require \../site/io/command

out = []
io  = emit: (id, msg)-> out.push "io:#id,#msg"
require \child_process
  ..exec = -> out.push "ex:#it"
require \../site/io/x11/buttonsim
  ..down = -> out.push "bd:#it"
  ..up   = -> out.push "bu:#it"
require \../site/io/x11/keysim
  ..down = -> out.push "d:#it"
  ..up   = -> out.push "u:#it"

afterEach -> out := []

test 'a'        -> run-test 'D.a U.a' 'd:a u:a'
test 'a+b+c'    -> run-test 'D.a+b+c U.a+b+c' 'd:a d:b d:c u:a u:b u:c'
test 'C+S+A+a'  -> run-test 'D.C+S+A+a' 'd:Control_L d:Shift_L d:Alt_L d:a'
test '@'        -> run-test 'D.@' 'd:XK_at'
test 'foo down' -> run-test 'D.foo' 'd:x u:x d:y u:y d:z u:z'
test 'foo up'   -> run-test 'U.foo' ''
test 'bar:a,b'  -> run-test 'D.bar:a,b' 'd:a u:a d:b u:b'
test 'btn 1 dn' -> run-test 'D.button:1' 'bd:1'
test 'btn 2 up' -> run-test 'U.button:2' 'bu:2'
test 'layout:x' -> run-test 'D.layout:x U.layout:x' 'io:layout,x io:layout,default'
test 'shell'    -> run-test 'D.hi U.hi' 'ex:echo hi'
test 'nop'      -> run-test 'D.nop U.nop' ''

function run-test api-calls, expect
  const API-FNS = D:Api.rkeydown, U:Api.rkeyup
  for call in api-calls / ' '
    [id, act] = call / '.'
    API-FNS[id] io, act
  A.equal expect, out * ' '
