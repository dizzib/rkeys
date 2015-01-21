_    = require \lodash
Io   = require \socket.io
Kseq = require \./keyseq.json
X    = require \./x

module.exports.init = (http) ->
  io = Io http

  socket <- io.on \connection
  log \connect

  socket.on \disconnect, -> log \disconnect

  socket.on \keydown, -> send-key-sequence 0, it
  socket.on \keyup  , -> send-key-sequence 1, it

  ## helpers

  function send-key-sequence origin-dirn, id
    return unless directive = Kseq[id]

    if _.isArray directive
      # verbose sequence
      return unless kseq = directive[origin-dirn]
      for act in acts = kseq.split ' '
        return log "Invalid action #act" unless (flag = act.0) in <[ + - ]>
        fn = if flag is \+ then X.keydown else X.keyup
        fn act.slice 1
    else
      if (acts = directive.split ' ').length is 1
        # simple key
        return [ X.keydown, X.keyup ][origin-dirn] acts.0
      # one-shot sequence on keydown
      return unless origin-dirn is 0
      for act in acts then X.keydown act
      for act in acts then X.keyup act
