X = require \../x

module.exports = (direction, id, command) ->
  return false if command

  # no command in yaml so just simulate raw key behaviour
  # i.e. emitted key down/up follows touch down/up just like
  # a real keyboard

  [ X.keydown, X.keyup ][direction] id
  true # handled
