_ = require \lodash
D = require \../constants .directions
S = require \../../ws/server

module.exports = ({command, direction, id}) ->
  return false unless command?

  if _.isArray command then command = command[direction] # explicit down/up
  else return unless direction is D.DOWN # single command on down only

  return false unless (cmdarr = command / ' ').0 is \broadcast
  S.broadcast "#{cmdarr.1}": cmdarr.slice(2) * ' '

  true # handled
