test = it
<- describe 'ws/server'

A    = require \chai .assert
Http = require \http
Ws   = require \faye-websocket
T    = require \../../../site/io/ws/server

const P0 = 7070
const P1 = 7071

var s0, s1
deq = A.deepEqual

afterEach ->
  s0.close!
  s1.close!
beforeEach ->
  s0 := Http.createServer!listen P0
  s1 := Http.createServer!listen P1
  T.removeAllListeners!
  T.init [s0, s1]

describe 'message to server' ->
  function test-port port
    test "port #port" (done) ->
      T.on \message ->
        deq it, \foo
        c.close!
        done!
      c = new Ws.Client "ws://localhost:#port"
      c.on \error -> done new Error it.message
      c.on \open  -> c.send \foo
  test-port P0
  test-port P1

test 'broadcast to all clients' (done) ->
  const PORTS = [P0, P0, P1]
  msgs = []; nconn = 0
  function create-client port
    c = new Ws.Client "ws://localhost:#port"
    c.on \error -> done new Error it.message
    c.on \message -> msgs.push it.data
  for p in PORTS then create-client p
  T.on \connect ->
    return unless ++nconn is PORTS.length
    T.broadcast \x
    setTimeout (-> deq msgs, <[x x x]>; done!), 100ms
