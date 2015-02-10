_   = require \lodash
Io  = require \socket.io
Cmd = require \./command
Fkm = require \./filter/key-macro
Fkr = require \./filter/key-raw
Fks = require \./filter/key-seq
Fsh = require \./filter/shell-exec

module.exports.init = (http) ->
  socket <- (io = Io http).on \connection
  log "connect #{ip = socket.conn.remoteAddress}"
  socket
    ..on \disconnect, -> log "disconnect #ip"
    ..on \keydown   , -> apply-filters 0, it
    ..on \keyup     , -> apply-filters 1, it
    ..on \keyseq    , Fks

## helpers

function apply-filters direction, id
  command = Cmd.get id
  for f in [ Fkr, Fsh, Fkm ] # filter order matters
    return if f direction, id, command
