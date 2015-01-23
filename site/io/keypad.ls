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

  function run-command origin-dirn, id
    return unless command = Cmd.get id

    if _.isArray command
      # verbose sequence
      return unless kseq = command[origin-dirn]
      for act in acts = kseq.split ' '
        return log "Invalid action #act" unless (flag = act.0) in <[ + - ]>
        fn = if flag is \+ then X.keydown else X.keyup
        fn act.slice 1
    else
      if (acts = command.split ' ').length is 1
        # simple key
        return [ X.keydown, X.keyup ][origin-dirn] acts.0
      # one-shot sequence on keydown
      return unless origin-dirn is 0
      for act in acts then X.keydown act
      for act in acts then X.keyup act
