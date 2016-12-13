test = it
<- describe 'api: web socket interface'

Http = require \http
Ws   = require \faye-websocket
M    = require \mockery

const PORT = 7070
var actual, aw, s0, T

after ->
  s0.close!
  M.deregisterAll!
  M.disable!
before ->
  M.registerMock \../active-window aw := servant: update: -> actual.push "up:#it"
  M.registerMock \../rkey -> actual.push it
  M.enable warnOnUnregistered:false
  s0 := Http.createServer!listen PORT
  T := require \../../../site/io/api/ws
  T.init [s0]
beforeEach ->
  actual := []

test 'on connect should emit active window event' (done) ->
  c = new Ws.Client "ws://localhost:#PORT"
  aw.emit = ->
    c.close!
    aw.emit = ->
    done!

describe 'send message to api' ->
  function run id, data, expect
    test id, (done) ->
      c = new Ws.Client "ws://localhost:#PORT"
      c.on \error -> done new Error it.message
      c.on \open  ->
        c.send JSON.stringify "#id":data
        c.close!
        setTimeout (-> deq actual, expect; done!), 50ms
  run \rkeydown \abc [{act:\abc direction:0 from:'ws ::ffff:127.0.0.1'}]
  run \rkeyup   \def [{act:\def direction:1 from:'ws ::ffff:127.0.0.1'}]
  run \servant  \xyz [\up:xyz]
