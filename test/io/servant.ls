const SITE = '../../site'

A       = require \chai .assert
Evem    = require \events .EventEmitter
Proxreq = require \proxyquire
Args    = require "#SITE/args"
Servant = Proxreq "#SITE/io/servant" do
  \socket.io/node_modules/socket.io-client :ioc-stub = (uri) ->
    out.push "ctor:#uri"
    (new Evem!) with emit: -> out.push "emit:#{it.toString!}"

describe 'servant' ->
  beforeEach ->
    Args.servant-to = 'master'

  test '--servant-to null' ->
    Args.servant-to = null
    A.isNull Servant.init!master

  test '--servant-to host' ->
    Args.servant-to = 'master'
    Servant.init!master.emit \abc
    assert 'ctor:http://master:7000 emit:abc'

  test '--servant-to host:port' ->
    Args.servant-to = 'master:8000'
    Servant.init!master.emit \abc
    assert 'ctor:http://master:8000 emit:abc'

function assert then A.equal it, out * ' '
