_   = require \lodash
X11 = require \x11
H   = require \./helper

const PREFIX = \XK_
var ks2kc

module.exports = me =
  init: get-keysym-to-keycode-mapping
  is-keysym: -> _.startsWith it, PREFIX
  get-keycodes: (key) ->
    keysym = get-keysym key
    return log "Invalid keysym #keysym" unless kc = ks2kc[keysym]
    return [kc.keycode] unless kc.is-shift
    [ks2kc[get-keysym \XK_Shift_L].keycode, kc.keycode]

## helpers

# key is either a full keysym-id like 'XK_a' or just a suffix like 'a'
function get-keysym key
  if me.is-keysym key then key else "#PREFIX#key" # attach prefix e.g. 'a' maps to 'XK_a'

# https://github.com/sidorares/node-x11/blob/ae71050a5d61ee7aab65369fab1efa2fc2404a7d/examples/smoketest/keyboard/getkeyboardmapping.js
function get-keysym-to-keycode-mapping cb
  # keysym hash can contain aliases e.g.
  # XK_F11: 0xFFC8
  # XK_L1 : 0xFFC8
  ks2names = {}
  for name of (ks = X11.keySyms) then (ks2names[ks[name]] ||= []).push name

  min = H.display.min_keycode
  max = H.display.max_keycode
  err, list <- H.x.GetKeyboardMapping min, max - min
  return cb err if err

  ks2kc := {}
  for sublist, i in list
    for j in [0, 1]
      continue unless 0 <= (ksym = sublist[j]) < 65536
      continue unless knames = ks2names[ksym]
      for name in knames
        continue if ks2kc[name] # prefer unshifted over shifted
        ks2kc[name] = keycode:i + min, is-shift:j is 1
  cb!
