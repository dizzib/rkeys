Cmd    = require \./command
Keysim = require \./x11/keysim

const DELAY = 2ms # otherwise keys may be lost in some web input fields

module.exports = me = (ids) ->
  return unless ids.length
  ksym = Cmd.get-command id = ids.0 # handle symbols e.g. ' ' -> XK_space
  Keysim.down k = (ksym or id)
  setTimeout keyup, DELAY
  function keyup
    Keysim.up k
    setTimeout me, DELAY, ids.slice 1
