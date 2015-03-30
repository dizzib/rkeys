_      = require \lodash
Cmd    = require \../command
Keysim = require \../x11/keysim

# emitted key or key-chord follows touch down/up just like a real keyboard

module.exports = (direction, id, command) ->
  if command?
    return false if _.isArray command
    return false unless (directives = command / ' ').length is 1
    return false if (d = directives.0).0 in <[ + - ]> # explicit press
    keys = d
  else
    keys = Cmd.apply-aliases id

  ks = keys / \+ # infix + denotes a chord e.g. 'C+A+y'
  for k in ks then [ Keysim.down, Keysim.up ][direction] k

  true # handled
