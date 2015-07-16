_    = require \lodash
Ioc  = require \socket.io/node_modules/socket.io-client
Args = require \../args
Log  = require \../log

module.exports = me =
  init: ->
    return me unless master-addr = Args.servant-to
    master-addr += ":#{Args.port}" unless _.contains master-addr, \:
    [host, port] = master-addr / \:
    me.master = Ioc url = "http://#master-addr"
      ..on \connect       -> Log "connect #url"
      ..on \connect_error -> Log "connect_error #url #it"
      ..on \disconnect    -> Log "disconnect #url"
    me
  master: null
