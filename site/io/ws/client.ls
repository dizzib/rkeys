Ws = require \faye-websocket

var ws

module.exports =
  init: (url) ->
    ws := new Ws.Client url
    ws.on \error -> log 0 it.message
    ws.on \open  -> log 0 "connect #url"
    ws.on \close -> log 0 "disconnect #url"
  send: (msg) ->
    ws.send msg
