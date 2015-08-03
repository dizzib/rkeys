Em = require \events .EventEmitter
_  = require \lodash
Ws = require \faye-websocket

var wsocks

module.exports = me = (new Em!) with do
  init: (http-servers) ->
    wsocks := []
    for s in http-servers when s
      s.on \upgrade (req, socket, body) ->
        return unless Ws.isWebSocket req
        wsocks.push ws = new Ws req, socket, body
        ws.on \close -> log 0 "disconnect #{socket.remoteAddress}"
        ws.on \message ->
          msg = JSON.parse it.data
          me.emit (_.keys msg).0, (_.values msg).0
        ws.on \open ->
          log 0 "connect #{socket.remoteAddress}"
          me.emit \connect ws

  broadcast: (id, data) ->
    for ws in wsocks then ws.send JSON.stringify "#id":data
