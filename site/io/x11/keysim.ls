_   = require \lodash
W4m = require \wait.for .forMethod
X11 = require \x11
H   = require \./helper
Kco = require \./keycode

downkeys = []

# https://github.com/sidorares/node-x11/blob/master/examples/smoketest/xtesttest.js
xtest = W4m H.x, \require, \xtest

module.exports =
  down: -> simulate xtest.KeyPress, it
  up  : -> simulate xtest.KeyRelease, it

process.on \exit   , release-keys
process.on \SIGINT , process.exit
process.on \SIGTERM, process.exit

## helpers

function fake-input type, keycode
  xtest.FakeInput type, keycode, 0, H.root, 0, 0

function release-keys
  for kc in downkeys
    log "release key code=#kc"
    fake-input xtest.KeyRelease, kc

function simulate type, key
  return unless kc = Kco.get-keycode key
  track-downkeys type, kc
  fake-input type, kc

function track-downkeys type, keycode
  if type is xtest.KeyPress then downkeys.push keycode else _.pull downkeys, keycode
