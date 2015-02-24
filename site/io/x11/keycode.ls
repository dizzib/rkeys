_   = require \lodash
W4m = require \wait.for .forMethod
X11 = require \x11
H   = require \./helper

ks2kc = get-keysym-to-keycode-mapping!

module.exports =
  get-keycodes: (key) ->
    keysym = get-keysym key
    return log "Invalid keysym #keysym" unless kc = ks2kc[keysym]
    return [kc.keycode] unless kc.is-shift
    [ks2kc[get-keysym \XK_Shift_L].keycode, kc.keycode]

## helpers

# key is either a full keysym-id like 'XK_a' or just a suffix like 'a'
function get-keysym key
  const PREFIX = \XK_
  return key if key.substring(0, PREFIX.length) is PREFIX
  "#PREFIX#key" # attach prefix e.g. 'a' maps to 'XK_a'

# https://github.com/sidorares/node-x11/blob/ae71050a5d61ee7aab65369fab1efa2fc2404a7d/examples/smoketest/keyboard/getkeyboardmapping.js
function get-keysym-to-keycode-mapping
  # keysym hash can contain aliases e.g.
  # XK_F11: 0xFFC8
  # XK_L1 : 0xFFC8
  ks2names = {}
  for name of (ks = X11.keySyms) then (ks2names[ks[name]] ||= []).push name

  min = H.display.min_keycode
  max = H.display.max_keycode
  list = W4m H.x, \GetKeyboardMapping, min, max - min

  ks2kc = {}
  for sublist, i in list
    for j in [0, 1]
      continue unless 0 <= (ksym = sublist[j]) < 65536
      continue unless knames = ks2names[ksym]
      for name in knames then ks2kc[name] =
        keycode : i + min
        is-shift: j is 1
  ks2kc
