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

describe 'action' ->
  describe 'symbols and letters' ->
    test '@'        -> run-test 'D.@' 'd:XK_at'
    test ':'        -> run-test 'D.:' 'd:XK_colon' # delimiter char
    test ','        -> run-test 'D.,' 'd:XK_comma' # delimiter char
    test 'a'        -> run-test 'D.a U.a' 'd:a u:a'
    test 'CEE'      -> run-test 'D.CEE' 'd:c'
  describe 'chord' ->
    test 'a+b+CEE'  -> run-test 'D.a+b+CEE U.a+b+CEE' 'd:a d:b d:c u:a u:b u:c'
    test 'C+S+A+a'  -> run-test 'D.C+S+A+a' 'd:Control_L d:Shift_L d:Alt_L d:a'
  describe 'sequence' ->
    test 'alias'    -> run-test 'D.DEE,f' 'd:d u:d d:e u:e d:f u:f'
    test 'chords'   -> run-test 'D.C+x,S+A+y' 'd:Control_L d:x u:Control_L u:x d:Shift_L d:Alt_L d:y u:Shift_L u:Alt_L u:y'
    test 'symbols'  -> run-test 'D.<,>' 'd:XK_less u:XK_less d:XK_greater u:XK_greater'
    test 'xyz dn'   -> run-test 'D.x,y,z' 'd:x u:x d:y u:y d:z u:z'
    test 'xyz up  ' -> run-test 'U.x,y,z' ''
    test-seq-delay '9,50,a,100'
describe 'command' ->
  describe 'symbols and letters' ->
    test 'c dn'     -> run-test 'D.cee' 'd:c u:d'
    test 'c up'     -> run-test 'U.cee' ''
    test '<'        -> run-test 'D.sym' 'd:XK_less'
  describe 'sequence' ->
    test 'abc dn'   -> run-test 'D.abc' 'd:a d:b u:b'
    test 'abc up'   -> run-test 'U.abc' 'u:a d:c u:c'
    test 'chords'   -> run-test 'D.sqc' 'd:Control_L d:x u:Control_L u:x d:Shift_L d:Alt_L d:y u:Shift_L u:Alt_L u:y'
    test 'digits'   -> run-test 'D.dig' 'd:0 u:0 d:1 u:1 d:9 u:9'
    test 'params'   -> run-test 'D.bar:a,b' 'd:a u:a d:b u:b'
    test 'symbols'  -> run-test 'D.sqs' 'd:XK_less u:XK_less d:XK_greater u:XK_greater'
    test 'xyz down' -> run-test 'D.xyz' 'd:x u:x d:y u:y d:z u:z'
    test 'xyz up'   -> run-test 'U.xyz' ''
    test-seq-delay 'dly'
  describe 'directive' ->
    test 'btn 1 dn' -> run-test 'D.button:1' 'bd:1'
    test 'btn 2 up' -> run-test 'U.button:2' 'bu:2'
    test 'js'       -> run-test 'D.js1:J' 'd:J u:J d:s u:s'
    test 'ls'       -> run-test 'D.ls1:L' 'd:L u:L d:s u:s'
    test 'layout:x' -> run-test 'D.layout:x U.layout:x' 'io:layout,x io:layout,default'
    test 'nop'      -> run-test 'D.nop U.nop' ''
    test 'shell'    -> run-test 'D.hi U.hi' 'ex:echo hi'
  describe 'sidechain' ->
    test '1 dn'     -> run-test 'D.sc1' 'ex:sc1 d:1'
    test '1 up'     -> run-test 'U.sc1' 'u:1'
    test '2 dn'     -> run-test 'D.sc2' 'ex:sc2d d:2'
    test '2 up'     -> run-test 'U.sc2' 'ex:sc2u u:2'

function test-seq-delay act
  describe 'sequence delay with auto-repeat' ->
    test '1'      -> run-test "D.#act 49" 'd:9 u:9'
    test '2'      -> run-test "D.#act 50" 'd:9 u:9 d:a u:a'
    test '3'      -> run-test "D.#act 149" 'd:9 u:9 d:a u:a'
    test '4'      -> run-test "D.#act 150" 'd:9 u:9 d:a u:a d:9 u:9'
    test 'once'   -> run-test "D.#act U.#act 500" 'd:9 u:9 d:a u:a'
    test 'twice'  -> run-test "D.#act 200 U.#act 500" 'd:9 u:9 d:a u:a d:9 u:9 d:a u:a'
    test 'cancel' -> run-test "D.#act U.#act 20 D.#act U.#act 500" 'd:9 u:9 d:9 u:9 d:a u:a'

function run-test instructions , expect
  const API-FNS = D:Api.rkeydown, U:Api.rkeyup
  for ins in instructions / ' '
    if ms = parseInt ins, 10
      clock.tick ms
    else
      [id, act] = ins / '.'
      API-FNS[id] io, act
  A.equal expect, out * ' '
