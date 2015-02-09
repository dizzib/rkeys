_   = require \lodash
X11 = require \x11
W4m = require \wait.for .forMethod

# https://github.com/sidorares/node-x11/blob/master/examples/smoketest/xtesttest.js
disp  = W4m X11, \createClient
root  = disp.screen.0.root
x     = disp.client .on \error, -> log \error, it
xt    = W4m x, \require, \xtest
ks2kc = get-keysym-to-keycode!

module.exports =
  keydown: -> fake-input xt.KeyPress, it
  keyup  : -> fake-input xt.KeyRelease, it

## helpers

function fake-input direction, key
  keysym = get-keysym key
  return log "Invalid keysym #keysym" unless ks2kc[keysym]
  xt.FakeInput direction, ks2kc[keysym], 0, root, 0, 0

# key is either a full keysym-id like 'XK_a' or just a suffix like 'a'
function get-keysym key
  const PREFIX = \XK_
  return key if key.substring(0, PREFIX.length) is PREFIX
  "#PREFIX#key" # attach prefix e.g. 'a' maps to 'XK_a'

# https://github.com/sidorares/node-x11/blob/ae71050a5d61ee7aab65369fab1efa2fc2404a7d/examples/smoketest/keyboard/getkeyboardmapping.js
function get-keysym-to-keycode
  # keysym hash can contain aliases e.g.
  # XK_F11: 0xFFC8
  # XK_L1 : 0xFFC8
  ks2names = {}
  for name of (ks = X11.keySyms) then (ks2names[ks[name]] ||= []).push name

  min = disp.min_keycode
  max = disp.max_keycode
  list = W4m x, \GetKeyboardMapping, min, max - min

  ks2kc = {}
  for i from 0 to list.length - 1
    continue unless 0 <= (ksym = list[i].0) < 65536
    continue unless knames = ks2names[ksym]
    for name in knames then ks2kc[name] = keycode = i + min
  ks2kc
