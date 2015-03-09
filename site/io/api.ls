_    = require \lodash
Io   = require \socket.io
Cmd  = require \./command
Actw = require \./x11/active-window
Fbu  = require \./filter/button
Fkc  = require \./filter/key-chord
Fkm  = require \./filter/key-macro
Fkr  = require \./filter/key-raw
Fsh  = require \./filter/shell-exec
Kseq = require \./keyseq

module.exports.init = (http) ->
  (io = Io http).on \connection, (socket) ->
    log "connect #{ip = socket.conn.remoteAddress}"
    socket
      ..on \disconnect, -> log "disconnect #ip"
      ..on \keydown   , -> apply-filters 0, it
      ..on \keyup     , -> apply-filters 1, it
      ..on \keyseq    , Kseq
    emit-active-window-changed!
  Actw.on \changed, emit-active-window-changed

  ## helpers

  function apply-filters direction, id
    command = Cmd.get id
    for f in [ Fbu, Fkr, Fsh, Fkc, Fkm ] # filter order matters
      return if f direction, id, command

  function emit-active-window-changed
    io.emit \active-window-changed, Actw.title
