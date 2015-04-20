Co = require \./command
Fc = require \./filter-chain

module.exports = (direction, id, command, io, spec) ->
  for {rx, cmd} in Co.get-sidechain!
    if rx.test spec
      #log spec, cmd
      Fc direction, id, cmd, io
      return # bail
