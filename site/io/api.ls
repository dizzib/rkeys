_    = require \lodash
Io   = require \socket.io
Awin = require \./x11/active-window
D    = require \./rkey/constants .directions
Rkey = require \./rkey
Rks  = require \./rkeystrokes

module.exports = (http) ->
  Awin.on \changed, -> io.emit \active-window-changed, Awin.title
  (io = Io http).on \connection, (socket) ->
    log 0, "connect #{ip = socket.conn.remoteAddress}"
    socket
      ..on \disconnect , -> log 0, "disconnect #ip"
      ..on \rkeydown   , -> Rkey it, D.DOWN, io
      ..on \rkeyup     , -> Rkey it, D.UP, io
      ..on \rkeystrokes, Rks
    Awin.emit \changed
