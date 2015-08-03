_  = require \lodash
Ws = require \faye-websocket

var ws

module.exports =
  init: (url, opts = reconnect-period:2000ms) ->
    function connect
      log 2 "try connect #url"
      ws := new Ws.Client url
      ws.on \error -> log 0 it.message
      ws.on \open  -> log 0 "opened #url"
      ws.on \close ->
        log 0 "closed #url"
        setTimeout connect, opts.reconnect-period
    connect!

  send: ->
    ws.send if _.isString it then it else JSON.stringify it
