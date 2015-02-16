_ = require \lodash
X = require \../x

module.exports = (direction, id, command) ->
  keysym = id
  if command?
    return false if _.isArray command
    return false unless (directives = command.split ' ').length is 1
    return false if _.contains (d = directives.0), \+
    keysym = d

  # emitted key down/up follows touch down/up just like a real keyboard
  [ X.keydown, X.keyup ][direction] keysym

  true # handled
