_    = require \lodash
Io   = require \socket.io
Awin = require \./active-window
D    = require \./rkey/constants .directions
Rkey = require \./rkey

module.exports = (http) ->
  (io = Io http).on \connection (socket) ->
    log 0 "connect #{ip = socket.conn.remoteAddress}"
    socket
      ..on \disconnect -> log 0 "disconnect #ip"
      ..on \rkeydown   -> Rkey act:it, direction:D.DOWN, io
      ..on \rkeyup     -> Rkey act:it, direction:D.UP, io
      ..on \servant    Awin.servant.update
    Awin.add-http-io(io).emit!
