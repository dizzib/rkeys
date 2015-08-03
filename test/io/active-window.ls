test = it
<- describe 'active-window'

const AWC  = \active-window-changed
const SITE = '../../site'

E = require \events .EventEmitter
M = require \mockery

var out, T
var args, os, wc, ws, xaw

after ->
  M.deregisterAll!
  M.disable!
before ->
  M.registerMock \os os := {}
  M.registerMock \../args args := verbosity:1
  M.registerMock \./ws/client wc := (new E!) with init: -> wc
  M.registerMock \./ws/server ws := {}
  M.registerMock \./x11/active-window xaw := (new E!) with current:{}
  M.enable warnOnUnregistered:false useCleanCache:true
  global.log = require "#SITE/log"
beforeEach ->
  M.resetCache!
  out := []
  wc.removeAllListeners!
  xaw.removeAllListeners!current.title = ''

describe 'as master, should notify http clients' ->
  beforeEach ->
    args.servant-to-url = null
    ws.broadcast = (id, data) -> out.push "br:#id,#data"
    T := require "#SITE/io/active-window"

  test 'focus, no servants' ->
    focus \M0
    focus \M1
    assert "br:#AWC,M0;br:#AWC,M1"

  test 'seen servant focus' ->
    focus \S0-in-M0
    focus-servant \s0 \red
    assert "br:#AWC,S0-in-M0;br:#AWC,S0-in-M0 (red)"

  test 'unseen servant focus' ->
    focus \S0-in-M0
    focus-servant \s1 \red
    assert "br:#AWC,S0-in-M0"

  test 'focus to unseen servant focus' ->
    focus-servant \s0 \yellow
    focus-servant \s0 \blue
    focus \S0-in-M0
    assert "br:#AWC,S0-in-M0 (blue)"

  test 'multiple servants' ->
    focus-servant \s0 \purple
    focus-servant \s1 \orange
    focus \S0-in-M0
    focus \S1-in-M1
    focus \M2
    assert "br:#AWC,S0-in-M0 (purple);br:#AWC,S1-in-M1 (orange);br:#AWC,M2"

describe 'as servant, should notify master' ->
  beforeEach ->
    args.servant-to-url = \master-url
    os.hostname = -> \S0
    wc.send = (id, {hostname, event}) ->
      out.push "send:#id,#hostname,#{event.id},#{event.title}"
    ws.broadcast = ->
    T := require "#SITE/io/active-window"

  const MSGID = \servant

  test 'local focus' ->
    focus \blue
    focus \cyan
    assert "send:#MSGID,S0,#AWC,blue;send:#MSGID,S0,#AWC,cyan"

  test 'connect to master' ->
    xaw.current.title = 'green'
    wc.emit \connect
    assert "send:#MSGID,S0,#AWC,green"

function assert then deq (out * ';'), it

function focus
  xaw.current.title = it
  xaw.emit \changed

function focus-servant hostname, title
  T.servant.update hostname:hostname, event:{id:AWC, title:title}
