_ = require \lodash
X = require \../x

const DOWN = 0
const UP   = 1

delay-tids = {} # for cancelling a running macro, keyed by command id
aurep-tids = {} # for cancelling auto-repeat, keyed by command id

module.exports = (direction, id, command) ->
  # touch up cancels auto-repeat
  if direction is UP
    if tid = aurep-tids[id]
      unless tid is \cancelled
        clearTimeout tid
        delete aurep-tids[id]
    else # signal long running macro to not auto-repeat
      aurep-tids[id] = \cancelled

  # touch down cancels an already running macro
  if direction is DOWN and tid = delay-tids[id]
    clearTimeout tid
    delete delay-tids[id]

  if _.isArray command then command = command[direction] # explicit down/up
  else return unless direction is DOWN # single command on down only

  apply-next-directive directives = command.split ' '

  function apply-next-directive ds
    return unless ds.length
    # int >= 10 denotes time delay in milliseconds
    if (d = ds.0).length > 1 and ms = parseInt d, 10
      if ds.length > 1 # more directives to come
        tid = setTimeout apply-next-directive, ms, ds.slice 1
        return delay-tids[id] = tid
      return delete aurep-tids[id] if aurep-tids[id] is \cancelled
      return aurep-tids[id] = setTimeout begin-auto-repeat, ms
    apply-directive d
    apply-next-directive ds.slice 1

  function begin-auto-repeat
    delete aurep-tids[id]
    apply-next-directive directives

function apply-directive d
  # prefix + or - denotes explicit press or release
  return (X.keydown d.slice 1) if d.0 is \+
  return (X.keyup d.slice 1) if d.0 is \-

  chord-keys = d.split \+ # infix + denotes a chord e.g. 'Shift+Alt+X'
  for k in chord-keys then X.keydown k
  for k in chord-keys then X.keyup k    # implicit release
