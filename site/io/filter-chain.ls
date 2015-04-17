Fbr  = require \./filter/broadcast
Fbu  = require \./filter/button
Fkf  = require \./filter/key-follow
Fkm  = require \./filter/key-macro
Fnop = require \./filter/nop
Fsh  = require \./filter/shell-exec

module.exports = (direction, id, command, io) ->
  for f in [ Fnop, Fsh, Fbr, Fbu, Fkf, Fkm ] # order matters
    return if f direction, id, command, io
