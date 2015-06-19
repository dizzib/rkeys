_ = require \lodash
D = require \../constants .directions

module.exports = ({command, direction, id, io}) ->
  return false unless command?

  if _.isArray command then command = command[direction] # explicit down/up
  else return unless direction is D.DOWN # single command on down only

  return false unless (cmdarr = command / ' ').0 is \broadcast
  io.emit cmdarr.1, cmdarr.slice(2) * ' '

  true # handled