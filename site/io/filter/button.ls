_   = require \lodash
Sim = require \../x11/buttonsim

module.exports = (direction, id, command, params) ->
  return false unless command?
  return false if _.isArray command
  return false unless (directives = command / ' ').0 is \button

  [Sim.down, Sim.up][direction] directives.1.replace \$0, params.0

  true # handled
