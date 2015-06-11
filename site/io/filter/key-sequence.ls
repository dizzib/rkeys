_      = require \lodash
Keysim = require \../x11/keysim

const DOWN = 0
const UP   = 1

delay-tids = {} # for cancelling a running sequence, keyed by command id
aurep-tids = {} # for cancelling auto-repeat, keyed by command id

module.exports = (direction, id, command) ->
  # rkeyup cancels auto-repeat
  if direction is UP
    if tid = aurep-tids[id]
      unless tid is \cancelled
        clearTimeout tid
        delete aurep-tids[id]
    else if delay-tids[id] # signal long running sequence to not auto-repeat
      aurep-tids[id] = \cancelled

  # rkeydown cancels an already running sequence
  if direction is DOWN and tid = delay-tids[id]
    clearTimeout tid
    delete delay-tids[id]

  if _.isArray command then command = command[direction] # explicit down/up
  else return unless direction is DOWN # single command on down only

  apply-next-instruction instructions = command.split ' '

  function apply-next-instruction ds
    return unless ds.length
    # int >= 10 denotes time delay in milliseconds
    if (d = ds.0).length > 1 and ms = parseInt d, 10
      if ds.length > 1 # more instructions to come
        tid = setTimeout apply-next-instruction, ms, ds.slice 1
        return delay-tids[id] = tid
      return delete aurep-tids[id] if aurep-tids[id] is \cancelled
      return aurep-tids[id] = setTimeout begin-auto-repeat, ms
    apply-instruction d
    apply-next-instruction ds.slice 1

  function begin-auto-repeat
    delete aurep-tids[id]
    apply-next-instruction instructions

function apply-instruction d
  # prefix + or - denotes explicit press or release
  return (Keysim.down d.slice 1) if d.0 is \+
  return (Keysim.up d.slice 1) if d.0 is \-

  chord-keys = d.split \+ # infix + denotes a chord e.g. 'Shift+Alt+X'
  for k in chord-keys then Keysim.down k
  for k in chord-keys then Keysim.up k    # implicit release
