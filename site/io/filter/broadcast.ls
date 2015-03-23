_   = require \lodash

const DOWN = 0
const UP   = 1

module.exports = (direction, id, command, io) ->
  return false unless command?

  if _.isArray command then command = command[direction] # explicit down/up
  else return unless direction is DOWN # single command on down only

  return false unless (directives = command.split ' ').0 is \broadcast
  io.emit directives.1, directives.slice(2).join ' '
  true # handled
