test = it
<- describe 'api'

Http = require \http
Ws   = require \faye-websocket
M    = require \mockery

const P0 = 7070
var res, s0, T

after ->
  s0.close!
  M.deregisterAll!
  M.disable!
before ->
  M.registerMock \./rkey -> res.push it
  M.enable warnOnUnregistered:false
  s0 := Http.createServer!listen P0
  T := require \../../site/io/api
  T.init [s0]
beforeEach ->
  res := []

describe 'send message to api' ->
  function run id, data, expect
    test id, (done) ->
      c = new Ws.Client "ws://localhost:#P0"
      c.on \error -> done new Error it.message
      c.on \open  ->
        c.send JSON.stringify "#id":data
        c.close!
        setTimeout (-> deq res, expect; done!), 50ms
  run \rkeydown \abc [{act:\abc direction:0}]
  run \rkeyup   \def [{act:\def direction:1}]
