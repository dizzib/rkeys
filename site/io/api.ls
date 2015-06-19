_    = require \lodash
Io   = require \socket.io
Actw = require \./x11/active-window
Rkey = require \./rkey
Rks  = require \./rkeystrokes

module.exports = (http) ->
  Actw.on \changed, -> io.emit \active-window-changed, Actw.title
  (io = Io http).on \connection, (socket) ->
    log 0, "connect #{ip = socket.conn.remoteAddress}"
    socket
      ..on \disconnect , -> log 0, "disconnect #ip"
      ..on \rkeydown   , -> Rkey it, 0, io
      ..on \rkeyup     , -> Rkey it, 1, io
      ..on \rkeystrokes, Rks
    Actw.emit \changed
