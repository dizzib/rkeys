Co = require \./command
Fc = require \./filter-chain

module.exports = (rkey-event) ->
  for {rx, cmd} in Co.get-sidechain!
    if rx.test rkey-event.act
      Fc rkey-event with command:cmd
      return # bail
