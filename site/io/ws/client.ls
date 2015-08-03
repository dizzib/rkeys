Em = require \events .EventEmitter
_  = require \lodash
Ws = require \faye-websocket

var ws

module.exports = me = (new Em!) with do
  init: (url, opts) ->
    function connect
      log2 "try connect #url"
      ws := new Ws.Client url
      ws.on \error -> log0 it.message
      ws.on \open  ->
        log0 "opened #url"
        me.emit \connect
      ws.on \close ->
        log0 "closed #url"
        me.emit \disconnect
        setTimeout connect, opts.reconnect-period
    connect!
    me

  send: (id, data) ->
    ws.send JSON.stringify "#id":data
