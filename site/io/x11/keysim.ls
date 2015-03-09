_   = require \lodash
W4m = require \wait.for .forMethod
X11 = require \x11
H   = require \./helper
Kco = require \./keycode

downkeys = []

module.exports =
  down: -> simulate H.xtest.KeyPress, it
  up  : -> simulate H.xtest.KeyRelease, it

process.on \exit, release-keys
for sig in <[ SIGINT SIGHUP SIGTERM ]> then process.on sig, process.exit

## helpers

function fake-input type, keycode
  H.xtest.FakeInput type, keycode, 0, H.root, 0, 0

function release-keys
  for c in downkeys
    log "release key code=#c"
    fake-input H.xtest.KeyRelease, c

function simulate type, key
  return unless cs = Kco.get-keycodes key
  for c in cs
    track-downkeys type, c
    fake-input type, c

function track-downkeys type, keycode
  switch type
    case H.xtest.KeyPress then downkeys.push keycode
    case H.xtest.KeyRelease then _.pull downkeys, keycode
