_   = require \lodash
Io  = require \socket.io
Cmd = require \./command
Fkm = require \./filter/key-macro
Fkr = require \./filter/key-raw
Fsh = require \./filter/shell-exec

module.exports.init = (http) ->
  socket <- (io = Io http).on \connection
  log \connect
  socket.on \disconnect, -> log \disconnect
  socket.on \keydown   , -> run-filters 0, it
  socket.on \keyup     , -> run-filters 1, it

function run-filters direction, id
  command = Cmd.get id
  for f in [ Fkr, Fsh, Fkm ] # filter order matters
    return if f direction, id, command
