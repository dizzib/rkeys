test = it
<- describe 'ws/client'

Http = require \http
Ws   = require \faye-websocket
T    = require \../../../site/io/ws/client

const P0 = 7070
var msgs, s0, ws

afterEach ->
  T.removeAllListeners!
  s0.close!
beforeEach ->
  s0 := Http.createServer!
  s0.on \upgrade (req, socket, body) ->
    return unless Ws.isWebSocket req
    ws := new Ws req, socket, body
    ws.on \message -> msgs.push it.data
  T.init "ws://localhost:#P0" reconnect-period:25ms
  msgs := []

test 'send' (done) ->
  s0.listen P0
  <- T.on \connect
  T.send \a \b
  setTimeout (-> deq msgs, <[{"a":"b"}]>; done!), 100ms

test 'connect refused, should keep retrying' (done) ->
  T.send \foo \bar
  s0.listen P0
  <- T.on \connect
  deq msgs, []
  done!

test 'disconnect, should reconnect' (done) ->
  s0.listen P0
  <- T.on \connect
  T.removeAllListeners!
  ws.close!
  s0.close!
  <- T.on \disconnect
  s0.listen P0
  <- T.on \connect
  done!
