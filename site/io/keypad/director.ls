_   = require \lodash
Io  = require \socket.io
W4  = require \wait.for .for
W4l = require \wait.for .launchFiber
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
    <- W4l
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
    # prefix + or - denotes explicit press or release
    return (X.keydown d.slice 1) if d.0 is \+
    return (X.keyup d.slice 1) if d.0 is \-

    # number with ms suffix denotes time delay in milliseconds e.g. '500ms'
    return W4 pause, parseInt d.replace \ms, '' if \ms is d.slice -2

    chord-keys = d.split \+ # infix + denotes a chord e.g. 'Shift+Alt+X'
    for k in chord-keys then X.keydown k
    for k in chord-keys then X.keyup k

  function pause ms, cb then setTimeout (-> cb!), ms
