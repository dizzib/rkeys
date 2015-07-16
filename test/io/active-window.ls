test = it
<- describe 'active-window'

const AWC  = \active-window-changed
const SITE = '../../site'

A = require \chai .assert
E = require \events .EventEmitter
M = require \mockery
  ..registerMock \./args args = verbosity:1
global.log = require "#SITE/log"

var out, T
var os, servant, xaw

after ->
  M.deregisterAll!
  M.disable!
before ->
  M.registerMock \os os := {}
  M.registerMock \./servant servant := init: -> servant
  M.registerMock \./x11/active-window xaw := (new E!) with current:{}
  M.enable warnOnUnregistered:false
  T := require "#SITE/io/active-window"
beforeEach ->
  out := []
  xaw.removeAllListeners!current.title = ''

describe 'as master, should notify http clients' ->
  beforeEach ->
    servant.master = null
    T.init!add-http-io emit: (id, msg) -> out.push "io:#id,#msg"

  test 'focus, no servants' ->
    focus \M0
    focus \M1
    assert "io:#AWC,M0;io:#AWC,M1"

  test 'seen servant focus' ->
    focus \S0-in-M0
    focus-servant \s0 \red
    assert "io:#AWC,S0-in-M0;io:#AWC,S0-in-M0 (red)"

  test 'unseen servant focus' ->
    focus \S0-in-M0
    focus-servant \s1 \red
    assert "io:#AWC,S0-in-M0"

  test 'focus to unseen servant focus' ->
    focus-servant \s0 \yellow
    focus-servant \s0 \blue
    focus \S0-in-M0
    assert "io:#AWC,S0-in-M0 (blue)"

  test 'multiple servants' ->
    focus-servant \s0 \purple
    focus-servant \s1 \orange
    focus \S0-in-M0
    focus \S1-in-M1
    focus \M2
    assert "io:#AWC,S0-in-M0 (purple);io:#AWC,S1-in-M1 (orange);io:#AWC,M2"

describe 'as servant, should notify master' ->
  beforeEach ->
    os.hostname = -> \S0
    servant.master = ms = new E!
      .._emit = ms.emit # workaround name clash
      ..emit = (msg-id, {hostname, event}) ->
        out.push "emit:#msg-id,#hostname,#{event.id},#{event.title}"
    T.init!

  const MSGID = \servant

  test 'local focus' ->
    focus \blue
    focus \cyan
    assert "emit:#MSGID,S0,#AWC,blue;emit:#MSGID,S0,#AWC,cyan"

  test 'connect to master' ->
    xaw.current.title = 'green'
    servant.master._emit \connect
    assert "emit:#MSGID,S0,#AWC,green"

function assert then A.equal it, out * ';'

function focus
  xaw.current.title = it
  xaw.emit \changed

function focus-servant hostname, title
  T.servant.update hostname:hostname, event:{id:AWC, title:title}
