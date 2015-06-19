_      = require \lodash
Cmd    = require \../../command
Keyco  = require \../../x11/keycode
Keysim = require \../../x11/keysim

# emitted key or key-chord follows rkeydown/up just like a real keyboard

module.exports = ({command, direction, id}) ->
  if command?
    return false if _.isArray command
    return false if _.contains command, ' '
    return false if _.contains command, ','
    return false if (keys = command).0 in <[ + - ]> # explicit press
  else
    return false if id.length > 1 and _.contains id, ',' # sequence action
    keys = Cmd.apply-aliases id

  ks = keys / \+ # infix + denotes a chord e.g. 'C+A+y'
  for k in ks
    if Keyco.is-keysym (c = Cmd.get-command k) then k = c
    [ Keysim.down, Keysim.up ][direction] k

  true # handled
