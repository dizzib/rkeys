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
        addr = socket.remoteAddress
        ws.on \close -> log0 "disconnect #addr"
        ws.on \message ->
          msg = JSON.parse it.data
          me.emit (_.keys msg).0, {act:(_.values msg).0, ip:addr}
        ws.on \open ->
          log0 "connect #addr"
          me.emit \connect ws

  broadcast: (id, data) ->
    for ws in wsocks then ws.send JSON.stringify "#id":data
