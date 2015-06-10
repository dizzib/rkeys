Co = require \./command
Fc = require \./filter-chain

module.exports = (direction, id, command, io, act) ->
  for {rx, cmd} in Co.get-sidechain!
    if rx.test act
      #log act, cmd
      Fc direction, id, cmd, io
      return # bail
