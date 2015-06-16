require \../site/args
  ..dirs = [ __dirname ]
  ..verbosity = 1

test = it
<- require \wait.for .launchFiber
global.log = require \../site/log

A   = require \chai .assert
_   = require \lodash
L   = require \lolex
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

var clock
beforeEach -> clock := L.install global
afterEach -> out := []

describe 'keys and chords' ->
  test '@'        -> run-test 'D.@' 'd:XK_at'
  test 'a'        -> run-test 'D.a U.a' 'd:a u:a'
  test 'a+b+c'    -> run-test 'D.a+b+c U.a+b+c' 'd:a d:b d:c u:a u:b u:c'
  test 'C+S+A+a'  -> run-test 'D.C+S+A+a' 'd:Control_L d:Shift_L d:Alt_L d:a'
describe 'sequences' ->
  test 'abc down' -> run-test 'D.abc' 'd:a d:b u:b'
  test 'abc up'   -> run-test 'U.abc' 'u:a d:c u:c'
  test 'bar:a,b'  -> run-test 'D.bar:a,b' 'd:a u:a d:b u:b'
  test 'foo down' -> run-test 'D.foo' 'd:x u:x d:y u:y d:z u:z'
  test 'foo up'   -> run-test 'U.foo' ''
  test 'num'      -> run-test 'D.num' 'd:0 u:0 d:1 u:1 d:9 u:9'
  test 'seq'      -> run-test 'D.seq' 'd:Control_L d:x u:Control_L u:x d:Shift_L d:Alt_L d:y u:Shift_L u:Alt_L u:y'
  describe 'auto-repeat' ->
    test '1'      -> run-test 'D.arq 99' 'd:q u:q'
    test '2'      -> run-test 'D.arq 100' 'd:q u:q d:q u:q'
    test '3'      -> run-test 'D.arq 199' 'd:q u:q d:q u:q'
    test '4'      -> run-test 'D.arq 200' 'd:q u:q d:q u:q d:q u:q'
    test 'cancel' -> run-test 'D.arq 99 U.arq 500' 'd:q u:q'
  describe 'delay' ->
    test '1'      -> run-test 'D.dly 49' 'd:9 u:9'
    test '2'      -> run-test 'D.dly 50' 'd:9 u:9 d:a u:a'
    test '3'      -> run-test 'D.dly 149' 'd:9 u:9 d:a u:a'
    test '4'      -> run-test 'D.dly 150' 'd:9 u:9 d:a u:a d:9 u:9'
    test 'once'   -> run-test 'D.dly U.dly 500' 'd:9 u:9 d:a u:a'
    test 'twice'  -> run-test 'D.dly 200 U.dly 500' 'd:9 u:9 d:a u:a d:9 u:9 d:a u:a'
    test 'cancel' -> run-test 'D.dly U.dly 20 D.dly U.dly 500' 'd:9 u:9 d:9 u:9 d:a u:a'
describe 'directives' ->
  test 'btn 1 dn' -> run-test 'D.button:1' 'bd:1'
  test 'btn 2 up' -> run-test 'U.button:2' 'bu:2'
  test 'layout:x' -> run-test 'D.layout:x U.layout:x' 'io:layout,x io:layout,default'
  test 'nop'      -> run-test 'D.nop U.nop' ''
  test 'shell'    -> run-test 'D.hi U.hi' 'ex:echo hi'

function run-test instructions , expect
  const API-FNS = D:Api.rkeydown, U:Api.rkeyup
  for ins in instructions / ' '
    if ms = parseInt ins, 10
      clock.tick ms
    else
      [id, act] = ins / '.'
      API-FNS[id] io, act
  A.equal expect, out * ' '
