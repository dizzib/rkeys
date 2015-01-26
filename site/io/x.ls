_   = require \lodash
X11 = require \x11
W4m = require \wait.for .forMethod

# https://github.com/sidorares/node-x11/blob/master/examples/smoketest/xtesttest.js
disp = W4m X11, \createClient
root = disp.screen.0.root
x = disp.client
x.on \error, -> log \error, it
xt = W4m x, \require, \xtest
ks2kc = get-keysym-to-keycode!

module.exports =
  keydown: -> fake-input xt.KeyPress, it
  keyup  : -> fake-input xt.KeyRelease, it

## helpers

function fake-input direction, keysym
  return log "Invalid keysym #keysym" unless ks2kc[keysym]
  xt.FakeInput direction, ks2kc[keysym], 0, root, 0, 0

# https://github.com/sidorares/node-x11/blob/ae71050a5d61ee7aab65369fab1efa2fc2404a7d/examples/smoketest/keyboard/getkeyboardmapping.js
function get-keysym-to-keycode
  ks2name = {}
  for key of (ks = X11.keySyms) then ks2name[ks[key]] = key

  min = disp.min_keycode
  max = disp.max_keycode
  list = W4m x, \GetKeyboardMapping, min, max - min

  ks2kc = {}
  for i from 0 to list.length - 1
    continue unless 0 <= (ksym = list[i].0) < 65536
    continue unless kname = ks2name[ksym]
    ks2kc[kname] = (keycode = i + min)
  ks2kc
