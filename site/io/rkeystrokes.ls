Cmd    = require \./command
Keysim = require \./x11/keysim

const DELAY = 2ms # otherwise keys may be lost in some web input fields

module.exports = me = (keys) ->
  return unless keys.length
  ksym = Cmd.get-command key = keys.0 # map symbols e.g. ' ' -> XK_space
  Keysim.down k = (ksym or key)
  setTimeout keyup, DELAY
  function keyup
    Keysim.up k
    setTimeout me, DELAY, keys.slice 1
