test = it
<- describe 'ws/client'

Http = require \http
Ws   = require \faye-websocket
T    = require \../../../site/io/ws/client

const P0 = 7070
var msgs, s0, ws

afterEach ->
  s0.close!
beforeEach ->
  s0 := Http.createServer!
  s0.on \upgrade (req, socket, body) ->
    return unless Ws.isWebSocket req
    ws := new Ws req, socket, body
    ws.on \message -> msgs.push it.data
  T.init "ws://localhost:#P0" reconnect-period:25ms
  T.removeAllListeners!
  msgs := []

test 'send' (done) ->
  s0.listen P0
  T.on \connect -> T.send \a \b
  setTimeout (-> deq msgs, <[{"a":"b"}]>; done!), 100ms

test 'connect refused, should keep retrying' (done) ->
  T.send \foo \bar
  setTimeout (-> s0.listen P0), 100ms
  setTimeout (-> T.send \a \b), 150ms
  setTimeout (-> deq msgs, <[{"a":"b"}]>; done!), 300ms

test 'disconnect, should reconnect' (done) ->
  s0.listen P0
  T.send \a \b
  setTimeout (-> ws.close!; s0.close!), 50ms
  setTimeout (-> T.send \foo \bar), 100ms
  setTimeout (-> s0.listen P0), 150ms
  setTimeout (-> T.send \c \d), 200ms
  setTimeout (-> deq msgs, <[{"a":"b"} {"c":"d"}]>; done!), 300ms
