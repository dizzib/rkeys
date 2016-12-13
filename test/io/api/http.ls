test = it
<- describe 'api: http POST interface'

Ex   = require \express
Http = require \http
M    = require \mockery
R    = require \request

const PORT = 7070
var actual, aw, s0, T

after ->
  s0.close!
  M.deregisterAll!
  M.disable!
before ->
  M.registerMock \../rkey -> actual.push it
  M.enable warnOnUnregistered:false
  ex = Ex!set \port PORT
  s0 := Http.createServer ex .listen PORT
  T := require \../../../site/io/api/http
  T.init ex
beforeEach ->
  actual := []

describe 'send message to api' ->
  const FROM = 'http ::ffff:127.0.0.1'
  function run id, data, expect
    test id, (done) ->
      err, res <- R.post "http://localhost:#PORT/api/#id" form:data
      done new Error err if err
      deq actual, expect
      done!
  run \rkeydown   \abc [{act:\abc direction:0 from:FROM}]
  run \rkeydownup \abc [{act:\abc direction:0 from:FROM} {act:\abc direction:1 from:FROM}]
  run \rkeyup     \def [{act:\def direction:1 from:FROM}]
