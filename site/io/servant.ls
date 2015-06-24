_    = require \lodash
Ioc  = require \socket.io/node_modules/socket.io-client
Args = require \../args

module.exports = me =
  init: ->
    return me unless master-addr = Args.servant-to
    master-addr += ":#{Args.port}" unless _.contains master-addr, \:
    [host, port] = master-addr / \:
    me.master = Ioc url = "http://#master-addr"
      ..on \connect       -> log "connect #url"
      ..on \connect_error -> log "connect_error #url #it"
      ..on \disconnect    -> log "disconnect #url"
    me

  master: null
