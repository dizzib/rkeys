Fbr  = require \./filter/broadcast
Fbu  = require \./filter/button
Fkf  = require \./filter/key-follow
Fks  = require \./filter/key-sequence
Fnop = require \./filter/nop
Fsh  = require \./filter/shell-exec

module.exports = (direction, id, command, io) ->
  for f in [ Fnop, Fsh, Fbr, Fbu, Fkf, Fks ] # order matters
    return if f direction, id, command, io
