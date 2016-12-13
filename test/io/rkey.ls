test = it
<- describe 'rkey'

_ = require \lodash
L = require \lolex
M = require \mockery
U = require \util

const SITE = '../../site'
var actual, clock, T

after  ->
  clock.uninstall!
  M.deregisterAll!
  M.disable!
before ->
  clock := L.install!
  M.enable warnOnUnregistered:false useCleanCache:true
  M.registerMock \child_process exec: (cmd, cb) -> actual.push "ex:#cmd"
  M.registerMock \../args dirs: [ "#__dirname/test-app" ]
  M.registerMock \../../ws/server broadcast: (id, data) -> actual.push "br:{#id:#data}"
  M.registerMock \../../x11/buttonsim do
    down: -> actual.push "bd:#it"
    up  : -> actual.push "bu:#it"
  M.registerMock \../../x11/keycode is-keysym: -> _.startsWith it, \XK_
  M.registerMock \../../x11/keysim do
    down: -> actual.push "d:#it"
    up  : -> actual.push "u:#it"
  T := require "#SITE/io/rkey"
beforeEach ->
  clock.reset!
  actual := []

describe 'action' ->
  describe 'symbols and letters' ->
    test '@'        -> run 'D.@' 'd:XK_at'
    test ':'        -> run 'D.:' 'd:XK_colon' # delimiter char
    test ','        -> run 'D.,' 'd:XK_comma' # delimiter char
    test 'a'        -> run 'D.a U.a' 'd:a u:a'
    test 'CEE'      -> run 'D.CEE' 'd:c'
  describe 'chord' ->
    test 'a+b+CEE'  -> run 'D.a+b+CEE U.a+b+CEE' 'd:a d:b d:c u:a u:b u:c'
    test 'C+S+A+a'  -> run 'D.C+S+A+a' 'd:Control_L d:Shift_L d:Alt_L d:a'
  describe 'sequence' ->
    test 'alias'    -> run 'D.DEE,f' 'd:d u:d d:e u:e d:f u:f'
    test 'chords'   -> run 'D.C+x,S+A+y' 'd:Control_L d:x u:Control_L u:x d:Shift_L d:Alt_L d:y u:Shift_L u:Alt_L u:y'
    test 'space'    -> run 'D.a,{SPACE},b' 'd:a u:a d:space u:space d:b u:b'
    test 'symbols'  -> run 'D.<,>' 'd:XK_less u:XK_less d:XK_greater u:XK_greater'
    test 'xyz dn'   -> run 'D.x,y,z' 'd:x u:x d:y u:y d:z u:z'
    test 'xyz up  ' -> run 'U.x,y,z' ''
    test-seq-delay '9,05,a,95'
describe 'command' ->
  describe 'symbols and letters' ->
    test 'c dn'     -> run 'D.cee' 'd:c u:d'
    test 'c up'     -> run 'U.cee' ''
    test '<'        -> run 'D.sym' 'd:XK_less'
  describe 'sequence' ->
    test 'abc dn'   -> run 'D.abc' 'd:a d:b u:b'
    test 'abc up'   -> run 'U.abc' 'u:a d:c u:c'
    test 'chords'   -> run 'D.sqc' 'd:Control_L d:x u:Control_L u:x d:Shift_L d:Alt_L d:y u:Shift_L u:Alt_L u:y'
    test 'digits'   -> run 'D.dig' 'd:0 u:0 d:1 u:1 d:9 u:9'
    test 'params'   -> run 'D.bar:a,b' 'd:a u:a d:b u:b'
    test 'symbols'  -> run 'D.sqs' 'd:XK_less u:XK_less d:XK_greater u:XK_greater'
    test 'xyz down' -> run 'D.xyz' 'd:x u:x d:y u:y d:z u:z'
    test 'xyz up'   -> run 'U.xyz' ''
    test-seq-delay 'dly'
  describe 'directive' ->
    test 'btn 1 dn' -> run 'D.button:1' 'bd:1'
    test 'btn 2 up' -> run 'U.button:2' 'bu:2'
    test 'layout:x' -> run 'D.layout:x U.layout:x' "br:{layout:x} br:{layout:default}"
    test 'nop'      -> run 'D.nop U.nop' ''
    test 'shell'    -> run 'D.hi U.hi' 'ex:echo hi'
    describe 'type' ->
      const TYPE = 'D.type:O,{SPACE}k:'
      test 'trailing space' -> run 'D.type:x{SPACE} 10' 'd:x u:x d:space u:space'
      test 'apostrop' -> run "D.type:x' 10" 'd:x u:x d:XK_apostrophe u:XK_apostrophe'
      test 'type 0'   -> run "#TYPE" 'd:O u:O'
      test 'type 1'   -> run "#TYPE 1" 'd:O u:O d:comma u:comma'
      test 'type 2'   -> run "#TYPE 2" 'd:O u:O d:comma u:comma d:space u:space'
      test 'type 3'   -> run "#TYPE 3" 'd:O u:O d:comma u:comma d:space u:space d:k u:k'
      test 'type 4'   -> run "#TYPE 999" 'd:O u:O d:comma u:comma d:space u:space d:k u:k d:XK_colon u:XK_colon'
    describe 'script' ->
      test 'js 1'     -> run 'D.js1:J' 'd:J u:J d:s u:s'
      test 'js 2'     -> run 'D.js2:j' 'd:j u:j d:2 u:2'
      test 'js err1'  -> run 'D.jserr1' ''
      test 'js err2'  -> run 'D.jserr2' ''
      test 'ls 1'     -> run 'D.ls1:L' 'd:L u:L d:s u:s'
      test 'ls 2'     -> run 'D.ls2' 'd:L u:L d:2 u:2'
      test 'ls error' -> run 'D.lserr' ''
  describe 'sidechain' ->
    test '1 dn'     -> run 'D.sc1' 'ex:A-sc1 ex:C-sc1,1 d:1'
    test '1 up'     -> run 'U.sc1' 'u:1'
    test '2 dn'     -> run 'D.sc2' 'ex:A-sc2d ex:C-sc2,2 d:2'
    test '2 up'     -> run 'U.sc2' 'ex:A-sc2u u:2'

function test-seq-delay act
  describe 'sequence delay with auto-repeat' ->
    test '1'      -> run "D.#act 4" 'd:9 u:9'
    test '2'      -> run "D.#act 5" 'd:9 u:9 d:a u:a'
    test '3'      -> run "D.#act 99" 'd:9 u:9 d:a u:a'
    test '4'      -> run "D.#act 100" 'd:9 u:9 d:a u:a d:9 u:9'
    test 'once'   -> run "D.#act U.#act 500" 'd:9 u:9 d:a u:a'
    test 'twice'  -> run "D.#act 150 U.#act 500" 'd:9 u:9 d:a u:a d:9 u:9 d:a u:a'
    test 'stop 1' -> run "D.#act U.#act 4 D.#act U.#act 500" 'd:9 u:9 d:9 u:9 d:a u:a'
    test 'stop 2' -> run "D.#act U.#act 4 D.#act 150 U.#act 500" 'd:9 u:9 d:9 u:9 d:a u:a d:9 u:9 d:a u:a'

function run instructions, expect
  const DIRECTIONS = D:0 U:1
  for ins in instructions / ' '
    if ms = _.parseInt ins
      clock.tick ms
    else
      [dirn, act] = ins / '.'
      T act:act.replace('{SPACE}' ' '), direction:DIRECTIONS[dirn], from:'ws ::ffff:127.0.0.1'
  deq (actual * ' '), expect
