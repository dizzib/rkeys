_    = require \lodash
Io   = require \socket.io
Cmd  = require \./command
Actw = require \./x11/active-window
Fbr  = require \./filter/broadcast
Fbu  = require \./filter/button
Fkc  = require \./filter/key-chord
Fkm  = require \./filter/key-macro
Fnop = require \./filter/nop
Fkr  = require \./filter/key-raw
Fsh  = require \./filter/shell-exec
Kseq = require \./keyseq

module.exports.init = (http) ->
  Actw.on \changed, -> io.emit \active-window-changed, Actw.title

  (io = Io http).on \connection, (socket) ->
    log "connect #{ip = socket.conn.remoteAddress}"
    socket
      ..on \disconnect, -> log "disconnect #ip"
      ..on \keydown   , -> apply-filters 0, it
      ..on \keyup     , -> apply-filters 1, it
      ..on \keyseq    , Kseq
    Actw.emit \changed

    function apply-filters direction, id
      command = Cmd.get id
      for f in [ Fnop, Fbu, Fkr, Fbr, Fsh, Fkc, Fkm ] # filter order matters
        return if f direction, id, command, io
