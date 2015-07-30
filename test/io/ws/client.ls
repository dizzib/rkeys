test = it
<- describe 'ws/client'

A    = require \chai .assert
Http = require \http
Ws   = require \faye-websocket
T    = require \../../../site/io/ws/client

var msgs, s0
deq = A.deepEqual

after ->
  s0.close!
before ->
  s0 := Http.createServer!listen const P0 = 7070
  s0.on \upgrade (req, socket, body) ->
    return unless Ws.isWebSocket req
    ws = new Ws req, socket, body
    ws.on \message -> msgs.push it.data
  T.init "ws://localhost:#P0"
beforeEach ->
  msgs := []

test 'send' (done) ->
  T.send \a
  T.send \b
  setTimeout (-> deq msgs, <[a b]>; done!), 100ms
