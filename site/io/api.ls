_    = require \lodash
Io   = require \socket.io
Awin = require \./active-window
D    = require \./rkey/constants .directions
Rkey = require \./rkey
Rks  = require \./rkeystrokes

module.exports = (http) ->
  (io = Io http).on \connection, (socket) ->
    log 0, "connect #{ip = socket.conn.remoteAddress}"
    socket
      ..on \disconnect , -> log 0, "disconnect #ip"
      ..on \rkeydown   , -> Rkey it, D.DOWN, io
      ..on \rkeyup     , -> Rkey it, D.UP, io
      ..on \rkeystrokes, Rks
    Awin.init io
