Em = require \events .EventEmitter
_  = require \lodash
Ws = require \faye-websocket

var ws

module.exports = me = (new Em!) with do
  init: (url, opts = reconnect-period:2000ms) ->
    function connect
      log 2 "try connect #url"
      ws := new Ws.Client url
      ws.on \error -> log 0 it.message
      ws.on \open  ->
        log 0 "opened #url"
        me.emit \connect ws
      ws.on \close ->
        log 0 "closed #url"
        setTimeout connect, opts.reconnect-period
    connect!
    me

  send: (id, data) ->
    ws.send JSON.stringify "#id":data
