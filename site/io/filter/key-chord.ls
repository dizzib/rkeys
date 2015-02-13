_ = require \lodash
X = require \../x

module.exports = (direction, id, command) ->
  return false if _.isArray command
  return false unless (directives = command.split ' ').length is 1
  return false if (d = directives.0).0 is \+ # prefix + denotes explicit press

  chord-keys = d.split \+ # infix + denotes a chord e.g. 'Shift+Alt+X'
  for k in chord-keys then [ X.keydown, X.keyup ][direction] k

  true # handled
