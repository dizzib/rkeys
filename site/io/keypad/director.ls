_   = require \lodash
Io  = require \socket.io
Cmd = require \./command
X   = require \../x

module.exports.init = (http) ->
  socket <- (io = Io http).on \connection
  log \connect
  socket.on \disconnect, -> log \disconnect
  socket.on \keydown   , -> run-command 0, it
  socket.on \keyup     , -> run-command 1, it

  ## helpers

  function run-command touch-dirn, id
    unless command = Cmd.get id
      # simple behaviour: emitted key down/up follows touch down/up
      # just like a real keyboard
      return [ X.keydown, X.keyup ][touch-dirn] id

    if _.isArray command
      # explicit command on down/up: index 0=down, 1=up
      directives = command[touch-dirn]
    else
      # single command on down only
      return unless touch-dirn is 0
      directives = command

    for d in directives.split ' ' then apply-directive d

  function apply-directive d
    return (X.keydown d.slice 1) if d.0 is \+
    return (X.keyup d.slice 1) if d.0 is \-

    chord-keys = d.split \+ # infix + denotes a chord e.g. 'Shift-Alt-X'
    for k in chord-keys then X.keydown k
    for k in chord-keys then X.keyup k
