_   = require \lodash
Sim = require \../x11/buttonsim

module.exports = (direction, id, command) ->
  return false unless command?
  return false if _.isArray command
  return false unless (cmdarr = command / ' ').0 is \button

  [Sim.down, Sim.up][direction] cmdarr.1

  true # handled
