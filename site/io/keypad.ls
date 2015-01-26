_   = require \lodash
Io  = require \socket.io
Cmd = require \./command
X   = require \./x

module.exports.init = (http) ->
  socket <- (io = Io http).on \connection
  log \connect
  socket.on \disconnect, -> log \disconnect
  socket.on \keydown   , -> run-command 0, it
  socket.on \keyup     , -> run-command 1, it

  ## helpers

  function run-command touch-dirn, id
    command = X.get-keysym-by-name id unless command = Cmd.get id

    if _.isArray command
      # explicit command on down/up: index 0=down, 1=up (optional)
      return unless directives = command[touch-dirn]
      for d in directives.split ' '
        switch d.0
          case \+ then X.keydown d.slice 1
          case \- then X.keyup d.slice 1
          default
            X.keydown d
            X.keyup d
    else
      if (directives = command.split ' ').length is 1
        # simple behaviour: emitted key down/up follows touch down/up
        # to simulate a real keyboard
        return [ X.keydown, X.keyup ][touch-dirn] directives.0
      return unless touch-dirn is 0 # touchdown ?
      # simple macro on touchdown only. To allow modifiers to take
      # effect we apply all keydowns followed by all keyups
      for d in directives then X.keydown d
      for d in directives then X.keyup d
