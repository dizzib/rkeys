const AWC  = \active-window-changed
const SITE = '../../site'

A       = require \chai .assert
Evem    = require \events .EventEmitter
Proxreq = require \proxyquire
Aw      = Proxreq "#SITE/io/active-window" do
  \os        :os-stub = {}
  \./servant :servant-stub = init: -> servant-stub
Xaw     = require "#SITE/io/x11/active-window"

describe 'active-window' ->
  beforeEach ->
    Xaw.title = ''

  describe 'as master, should notify http clients' ->
    beforeEach ->
      servant-stub.master = null
      Aw.init!add-http-io io

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
    const MSGID = \servant

    beforeEach ->
      os-stub.hostname = -> \S0
      servant-stub.master = ms = new Evem!
        .._emit = ms.emit # workaround name clash
        ..emit = (msg-id, {hostname, event}) ->
          out.push "emit:#msg-id,#hostname,#{event.id},#{event.title}"
      Aw.init!

    test 'local focus' ->
      focus \blue
      focus \cyan
      assert "emit:#MSGID,S0,#AWC,blue;emit:#MSGID,S0,#AWC,cyan"

    test 'connect to master' ->
      Xaw.title = 'green'
      servant-stub.master._emit \connect
      assert "emit:#MSGID,S0,#AWC,green"

function assert then A.equal it, out * ';'

function focus
  Xaw.title = it
  Xaw.emit \changed

function focus-servant hostname, title
  Aw.servant.update hostname:hostname, event:{id:AWC, title:title}
