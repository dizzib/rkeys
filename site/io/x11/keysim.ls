_   = require \lodash
W4m = require \wait.for .forMethod
X11 = require \x11
H   = require \./helper
Kco = require \./keycode

# https://github.com/sidorares/node-x11/blob/master/examples/smoketest/xtesttest.js
xtest = W4m H.x, \require, \xtest

module.exports =
  down: -> fake-input xtest.KeyPress, it
  up  : -> fake-input xtest.KeyRelease, it

## helpers

function fake-input type, key
  return unless kc = Kco.get-keycode key
  xtest.FakeInput type, kc, 0, H.root, 0, 0
