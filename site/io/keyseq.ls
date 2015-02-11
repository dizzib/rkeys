Cmd = require \./command
X   = require \./x

const DELAY = 2ms # otherwise keys may be lost in some web input fields

module.exports = me = (ids) ->
  return unless ids.length
  ksym = Cmd.get id = ids.0 # handle symbols e.g. ' ' -> XK_space
  X.keydown k = (ksym or id)
  setTimeout keyup, DELAY
  function keyup
    X.keyup k
    setTimeout me, DELAY, ids.slice 1
