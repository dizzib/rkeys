test = it
<- describe 'servant'

A = require \chai .assert
E = require \events .EventEmitter
M = require \mockery

var args, out, T

after ->
  M.deregisterAll!
  M.disable!
before ->
  M.registerMock \../args args := port:7000
  M.registerMock \../log -> out.push it
  M.registerMock \socket.io/node_modules/socket.io-client (uri) ->
    out.push "ctor:#uri"
    (new E!) with emit: -> out.push "emit:#it"
  M.enable warnOnUnregistered:false
  T := require \../../site/io/servant
beforeEach ->
  out := []
  args.servant-to = 'master'

test '--servant-to null' ->
  args.servant-to = null
  A.isNull T.init!master

test '--servant-to host' ->
  args.servant-to = 'master'
  T.init!master.emit \abc
  assert 'ctor:http://master:7000 emit:abc'

test '--servant-to host:port' ->
  args.servant-to = 'master:8000'
  T.init!master.emit \abc
  assert 'ctor:http://master:8000 emit:abc'

function assert then A.equal it, out * ' '
